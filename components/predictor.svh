class predictor extends uvm_subscriber #(sequence_item);
  `uvm_component_utils(predictor);


  virtual inf my_vif;

  uvm_analysis_port #(sequence_item) analysis_port_expected_outputs;

  sequence_item seq_item_expected;

  event inputs_written;
  event expected_outputs_written;

   logic                    full_expected;
   logic                    empty_expected;

   bit   [FIFO_WIDTH-1:0]   data_in;
   bit                      rrst_n, wrst_n, w_en, r_en;


  logic  [FIFO_WIDTH-1:0] 	data_out_expected;
  bit 	 [FIFO_WIDTH-1:0]   data_write_queue [$];


  bit [FIFO_SIZE-1:0] write_pointer;
  bit [FIFO_SIZE-1:0] read_pointer;
  bit wrap_around;
  string data_str;


  function new(string name = "predictor", uvm_component parent);
    super.new(name, parent);
  endfunction


  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    
    analysis_port_expected_outputs = new ("analysis_port_expected_outputs", this);

    seq_item_expected = sequence_item::type_id::create("seq_item_expected");

    if(!uvm_config_db#(virtual inf)::get(this,"","my_vif",my_vif)) begin //to fix the get warning of having no container to return to
      `uvm_fatal(get_full_name(),"Error");
    end

    $display("my_predictor build phase");
  endfunction : build_phase


  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
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
    rrst_n     = t.rrst_n;
    wrst_n    = t.wrst_n;
    data_in   = t.data_in;
    w_en     = t.w_en;
    r_en     = t.r_en;
    data_str = $sformatf("rrst_n:%0d, wrst_n:%0d ,w_en:%0d ,r_en:%0d , data_in:%0d",
                         rrst_n, wrst_n, w_en, r_en, data_in);
    -> inputs_written;
  endfunction

  task predictor_idk();
      if(rrst_n === 1'b0 || wrst_n === 1'b0) begin
        reset_FIFO();
      end
      else begin
        write_read_FIFO();
      end
      // if(w_en && r_en)
      //   concurrent_send_results();
      // else
      send_results();
  endtask : predictor_idk

  function void send_results();
    seq_item_expected.wrst_n          = wrst_n;
    seq_item_expected.rrst_n          = rrst_n;
    seq_item_expected.w_en            = w_en;
    seq_item_expected.r_en            = r_en;
    seq_item_expected.data_in         = data_in;

    seq_item_expected.data_out        =      data_out_expected;
    seq_item_expected.empty           =         empty_expected;
    seq_item_expected.full            =          full_expected;
    -> expected_outputs_written;
  endfunction : send_results


  //FIFO_reeset task
  task reset_FIFO();
    if((wrst_n === 1'b0) && (rrst_n === 1'b0))begin
      data_out_expected     = 0;
      empty_expected        = 1;
      full_expected         = 0;
      fork
        read_reset();
        write_reset();
      join
      data_write_queue.delete();
    end
    else if ((wrst_n === 1'b0) && (rrst_n === 1'b1)) begin
      write_reset();
    end
    else if ((wrst_n === 1'b1) && (rrst_n === 1'b0)) begin
      read_reset();
    end
  endtask : reset_FIFO

  task read_reset();
    read_pointer = 0;
  endtask : read_reset

  task write_reset();
    write_pointer = 0;
  endtask : write_reset


  task write_read_FIFO();
    if((w_en === 1'b1) && (r_en === 1'b1))begin
      fork
        read_FIFO();
        write_FIFO();
      join
      FLAGS();
    end
    else if ((w_en === 1'b1) && (r_en === 1'b0)) begin
      write_FIFO();
      FLAGS();
    end
    else if ((w_en === 1'b0) && (r_en === 1'b1)) begin
      read_FIFO();
      FLAGS();
    end
  endtask : write_read_FIFO

  //A task that writes address and data
  task write_FIFO();
    if(full_expected === 0) begin
      data_write_queue.push_back(data_in);
      if(write_pointer === FIFO_SIZE-1)begin
        write_pointer = 0;
        wrap_around = 1;
      end
      else begin
        write_pointer = write_pointer + 1;
      end
    end
    FLAGS();
     $display("WRITE_POINER = %0d", write_pointer);
     $display("READ_POINER = %0d", read_pointer);
   endtask : write_FIFO

  //A task that reads data
  task read_FIFO();
    if(empty_expected === 0) begin
      data_out_expected = data_write_queue.pop_front();
      if(read_pointer === FIFO_SIZE-1)begin
        read_pointer = 0;
        wrap_around = 0;
      end
      else begin
        read_pointer = read_pointer + 1;
      end
    end
    FLAGS();
     $display("WRITE_POINER = %0d", write_pointer);
     $display("READ_POINER = %0d", read_pointer);
  endtask : read_FIFO


  task FLAGS();
    if(read_pointer === write_pointer) begin
      if(( wrap_around & (read_pointer[FIFO_SIZE-1:0] === write_pointer[FIFO_SIZE-1:0]))) begin
        full_expected = 1;
        empty_expected = 0;
      end
      else if(read_pointer === write_pointer)begin
        full_expected = 0;
        empty_expected = 1;
      end
    end
    else begin
      full_expected = 0;
      empty_expected = 0;
    end
  endtask : FLAGS



endclass : predictor