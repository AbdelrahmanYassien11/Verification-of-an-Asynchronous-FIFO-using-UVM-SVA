class predictor extends uvm_subscriber #(sequence_item);
  `uvm_component_utils(predictor);


  virtual inf.TEST my_vif;

  uvm_analysis_port #(sequence_item) analysis_port_expected_outputs;

  sequence_item seq_item_expected;

  event inputs_written;
  event expected_outputs_written;

   logic                    full_expected;
   logic                    empty_expected;


   logic [FIFO_WIDTH-1:0]   data_out;

   bit   [FIFO_WIDTH-1:0]   data_in;
   bit                      rrst_n, iwrst_n, w_en, r_en;


  logic  [FIFO_WIDTH-1:0] 	data_out_expected;
  bit 	 [FIFO_WIDTH-1:0]   data_write_queue [$];


  bit [31:0] write_pointer;
  bit [31:0] read_pointer;
  string data_str;


  function new(string name = "predictor", uvm_component parent);
    super.new(name, parent);
  endfunction


  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    
    analysis_port_expected_outputs = new ("analysis_port_expected_outputs", this);

    seq_item_expected = sequence_item::type_id::create("seq_item_expected");

    if(!uvm_config_db#(virtual inf.TEST)::get(this,"","my_vif",my_vif)) begin //to fix the get warning of having no container to return to
      `uvm_fatal(get_full_name(),"Error");
    end

    $display("my_predictor build phase");
  endfunction : build_phase


  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    //tlm_analysis_export.connect(tlm_analysis_fifo.analysis_export);
    $display("my_scoreboard connect phase");
  endfunction


  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin      
      $display("my_predictor run phase");
      @(inputs_written);
      `uvm_info("PREDICTOR", {"WRITTEN_DATA: ", data_str}, UVM_HIGH)
      predictor_idk();
      wait(expected_outputs_written.triggered);
          analysis_port_expected_outputs.write(seq_item_expected);
      `uvm_info("PREDICTOR", {"EXPECTED_DATA: ", seq_item_expected.convert2string()}, UVM_HIGH)
    end
  endtask

  function void write(sequence_item t);
    rst_n     = t.rst_n;
    data_in   = t.data_in;
    wr_en     = t.wr_en;
    rd_en     = t.rd_en;
    data_str = $sformatf("rst_n:%0d ,wr_en:%0d ,rd_en:%0d , data_in:%0d",
                         rst_n, wr_en, rd_en, data_in);
    -> inputs_written;
  endfunction

  task predictor_idk();
      if(rst_n === 1'b0) begin
        reset_FIFO();
      end
      else if(wr_en === 1'b1 && rd_en === 1'b0) begin
        FIFO_WRITE();
      end
      else if(wr_en === 1'b0 && rd_en === 1'b1) begin
        FIFO_READ();
      end
      send_results();
  endtask : predictor_idk

  function void send_results();
    seq_item_expected.rst_n   = rst_n;
    seq_item_expected.wr_en   = wr_en;
    seq_item_expected.rd_en   = rd_en;
    seq_item_expected.data_in = data_in;

    seq_item_expected.data_out       =      data_out_expected;
    seq_item_expected.wr_ack         =        wr_ack_expected;
    seq_item_expected.overflow       =      overflow_expected;
    seq_item_expected.underflow      =     underflow_expected;
    seq_item_expected.almost_empty   =  almost_empty_expected;
    seq_item_expected.empty          =         empty_expected;
    seq_item_expected.almost_full    =   almost_full_expected;
    seq_item_expected.full           =          full_expected;
    seq_item_expected.half_full      =     half_full_expected;
    -> expected_outputs_written;
  endfunction : send_results



   //FIFO_reeset task
  task reset_FIFO();
    if((wrst_n === 1'b1) && (rrst_n === 1'b1))begin
      data_out_expected     = 0;
      empty_expected        = 1;
      full_expected         = 0;
      fork
        read_reset();
        write_reset();
      join
    end
    else if ((wrst_n === 1'b1) && (rrst_n === 1'b0)) begin
      write_reset();
    end
    else if ((wrst_n === 1'b0) && (rrst_n === 1'b1)) begin
      read_reset();
    end
  endtask : reset_FIFO

  task read_reset();
    rrst_n = 0;
    read_pointer = 0;
  endtask : read_reset

  task write_reset();
    write_pointer = 0;
    wrst_n = 0;
  endtask : write_reset


  task write_read_FIFO(input bit [FIFO_WIDTH-1:0] idata_in);
    if((w_en === 1'b1) && (r_en === 1'b1))begin
      fork
        read_FIFO();
        write_FIFO(idata_in);
      join
      send_outputs();
      w_en = 1;
      r_en = 1;
    end
    else if ((w_en === 1'b1) && (r_en === 1'b0)) begin
      write_reset(idata_in);
      send_outputs();
      w_en = 1;
    end
    else if ((w_en === 1'b0) && (r_en === 1'b1)) begin
      read_reset();
      send_outputs();
      r_en = 1;
    end
  endtask : write_read_FIFO


  task write_FIFO(input bit [FIFO_WIDTH-1:0] idata_in);
    @(negedge wclk);
      wrst_n = 1'b1;
      w_en = 1'b1;
      data_in = idata_in;
    @(negedge wclk);
   endtask : write_FIFO


  task read_FIFO();
    @(negedge rclk);
      rrst_n = 1'b1;
      r_en = 1'b1;
    @(negedge rclk);
  endtask : read_FIFO



  task reset_READ();
    
  endtask : reset_READ

  task reset_WRITE();
    write_pointer = 0;
    wrst_n = 0;
  endtask : reset_WRITE








   //A task that writes address and data
	 task FIFO_WRITE();

     if(full_expected === 0)begin
      data_write_queue.push_back(data_in);
      if(write_pointer === FIFO_SIZE-1)begin
        write_pointer = 0;
      end
      else begin
        write_pointer = write_pointer+1;
      end 
     end
     $display("WRITE_POINER = %0d", write_pointer);
     $display("READ_POINER = %0d", read_pointer);
     FLAGS_WRITE();
   
   endtask : FIFO_WRITE




   //A task that reads data
   task FIFO_READ();


     if(empty_expected === 0)begin
	 	  data_out_expected = data_write_queue.pop_front();
      if(read_pointer === FIFO_SIZE-1)begin
        read_pointer = 0;
      end
      else begin
        read_pointer = read_pointer +1;
      end
     end
     $display("WRITE_POINER = %0d", write_pointer);
     $display("READ_POINER = %0d", read_pointer);

     FLAGS_READ();
   endtask : FIFO_READ




  task FLAGS_WRITE();

    	if ((read_pointer > write_pointer)) begin
        case(read_pointer - write_pointer)
          (1): begin
    		    empty_expected 	= 0;
    		    almost_empty_expected = 0;
    		    underflow_expected = 0;
    		    full_expected 	= 0;
    		    wr_ack_expected = 1;
    		    almost_full_expected = 1;
    		    overflow_expected = 0;
            half_full_expected = 0;
          	end
          (FIFO_SIZE-1): begin
              empty_expected  = 0;
              almost_empty_expected = 1;
              underflow_expected = 0;
              full_expected   = 0;
              wr_ack_expected = 1;
              almost_full_expected = 0;
              overflow_expected = 0;
              half_full_expected = 0;
          end
          (FIFO_SIZE/2): begin //
            empty_expected  = 0;
            almost_empty_expected = 0;
            underflow_expected = 0;
            full_expected   = 0;
            wr_ack_expected = 1;
            almost_full_expected = 0;
            overflow_expected = 0;
            half_full_expected = 1;
          end
          default: begin
            empty_expected  = 0;
            almost_empty_expected = 0;
            underflow_expected = 0;
           	full_expected   = 0;
            wr_ack_expected = 1;
            almost_full_expected = 0;
            overflow_expected = 0;
            half_full_expected = 0;
          	end
        endcase
    	end
      else if((write_pointer > read_pointer )) begin
        case(write_pointer - read_pointer)
          (1): begin
            empty_expected  = 0;
            almost_empty_expected = 1;
            underflow_expected = 0;
            full_expected   = 0;
            wr_ack_expected = 1;
            almost_full_expected = 0;
            overflow_expected = 0;
            half_full_expected = 0;
          end
          (FIFO_SIZE-1): begin
              empty_expected  = 0;
              almost_empty_expected = 0;
              underflow_expected = 0;
              full_expected   = 0;
              wr_ack_expected = 1;
              almost_full_expected = 1;
              overflow_expected = 0;
              half_full_expected = 0;
          end
          (FIFO_SIZE/2): begin //
            empty_expected  = 0;
            almost_empty_expected = 0;
            underflow_expected = 0;
            full_expected   = 0;
            wr_ack_expected = 1;
            almost_full_expected = 0;
            overflow_expected = 0;
            half_full_expected = 1;
          end
          default: begin
            empty_expected  = 0;
            almost_empty_expected = 0;
            underflow_expected = 0;
            full_expected   = 0;
            wr_ack_expected = 1;
            almost_full_expected = 0;
            overflow_expected = 0;
            half_full_expected = 0;
          end
        endcase // almost_full_expected
      end
    	else if((write_pointer === read_pointer )) begin
        if(almost_full_expected === 1) begin
            empty_expected  = 0;
            almost_empty_expected = 0;
            underflow_expected = 0;
            full_expected   = 1;
            wr_ack_expected = 1;
            almost_full_expected = 0;
            overflow_expected = 0;
            half_full_expected = 0;
        end
        else if(full_expected === 1)begin
            empty_expected  = 0;
            almost_empty_expected = 0;
            underflow_expected = 0;
            full_expected   = 1;
            wr_ack_expected = 0;
            almost_full_expected = 0;
            overflow_expected = 1;
            half_full_expected = 0;
        end
        else if(empty_expected === 1)begin 
            empty_expected  = 0;
            almost_empty_expected = 1;
            underflow_expected = 0;
            full_expected   = 0;
            wr_ack_expected = 1;
            almost_full_expected = 0;
            overflow_expected = 0;
            half_full_expected = 0;
        end
        else begin //obselete
            empty_expected  = 1;
            almost_empty_expected = 0;
            underflow_expected = 0;
            full_expected   = 0;
            wr_ack_expected = 0;
            almost_full_expected = 0;
            overflow_expected = 0;
            half_full_expected = 0;
        end 
      end
    endtask : FLAGS_WRITE




      task FLAGS_READ();
      if ((read_pointer > write_pointer)) begin
        case(read_pointer - write_pointer)
          (1): begin
            empty_expected  = 0;
            almost_empty_expected = 0;
            underflow_expected = 0;
            full_expected   = 0;
            wr_ack_expected = 0;
            almost_full_expected = 1;
            overflow_expected = 0;
            half_full_expected = 0;
          end
          (FIFO_SIZE-1): begin
            empty_expected  = 0;
            almost_empty_expected = 1;
            underflow_expected = 0;
            full_expected   = 0;
            wr_ack_expected = 0;
            almost_full_expected = 0;
            overflow_expected = 0;
            half_full_expected = 0;
          end
          (FIFO_SIZE/2): begin //
            empty_expected  = 0;
            almost_empty_expected = 0;
            underflow_expected = 0;
            full_expected   = 0;
            wr_ack_expected = 0;
            almost_full_expected = 0;
            overflow_expected = 0;
            half_full_expected = 1;
          end
          default: begin
            empty_expected  = 0;
            almost_empty_expected = 0;
            underflow_expected = 0;
            full_expected   = 0;
            wr_ack_expected = 0;
            almost_full_expected = 0;
            overflow_expected = 0;
            half_full_expected = 0;
          end
        endcase
      end
      else if((write_pointer > read_pointer )) begin
        case(write_pointer - read_pointer)
          (1): begin
            empty_expected  = 0;
            almost_empty_expected = 1;
            underflow_expected = 0;
            full_expected   = 0;
            wr_ack_expected = 0;
            almost_full_expected = 0;
            overflow_expected = 0;
            half_full_expected = 0;
          end
          (FIFO_SIZE-1): begin
            empty_expected  = 0;
            almost_empty_expected = 0;
            underflow_expected = 0;
            full_expected   = 0;
            wr_ack_expected = 0;
            almost_full_expected = 1;
            overflow_expected = 0;
            half_full_expected = 0;
          end
          (FIFO_SIZE/2): begin //
            empty_expected  = 0;
            almost_empty_expected = 0;
            underflow_expected = 0;
            full_expected   = 0;
            wr_ack_expected = 0;
            almost_full_expected = 0;
            overflow_expected = 0;
            half_full_expected = 1;
          end
          default: begin
            empty_expected  = 0;
            almost_empty_expected = 0;
            underflow_expected = 0;
            full_expected   = 0;
            wr_ack_expected = 0;
            almost_full_expected = 0;
            overflow_expected = 0;
            half_full_expected = 0;
          end
        endcase // almost_full_expected
      end
      else if((write_pointer === read_pointer )) begin
        if(almost_empty_expected === 1) begin
            empty_expected  = 1;
            almost_empty_expected = 0;
            underflow_expected = 0;
            full_expected   = 0;
            wr_ack_expected = 0;
            almost_full_expected = 0;
            overflow_expected = 0;
            half_full_expected = 0;
        end
        else if(empty_expected === 1)begin
            empty_expected  = 1;
            almost_empty_expected = 0;
            underflow_expected = 1;
            full_expected   = 0;
            wr_ack_expected = 0;
            almost_full_expected = 0;
            overflow_expected = 0;
            half_full_expected = 0;
        end
        else if(full_expected === 1)begin
            empty_expected  = 0;
            almost_empty_expected = 0;
            underflow_expected = 0;
            full_expected   = 0;
            wr_ack_expected = 0;
            almost_full_expected = 1;
            overflow_expected = 0;
            half_full_expected = 0;
        end
        else begin
            empty_expected  = 1;
            almost_empty_expected = 0;
            underflow_expected = 0;
            full_expected   = 0;
            wr_ack_expected = 0;
            almost_full_expected = 0;
            overflow_expected = 0;
            half_full_expected = 0;
        end 
      end
   endtask : FLAGS_READ


endclass : predictor