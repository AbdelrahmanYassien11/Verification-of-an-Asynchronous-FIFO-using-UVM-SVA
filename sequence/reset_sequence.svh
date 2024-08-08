class reset_sequence extends base_sequence;
 	`uvm_object_utils(reset_sequence);

 	function new(string name = "reset_sequence");
 		super.new(name);
 	endfunction

 	task body();
 			$display("start of body task");
 			start_item(seq_item);
 			$display("start item has been invoked");
 			seq_item.rst_n = 1'b0;
 			finish_item(seq_item);
      `uvm_info("RESET_SEQUENCE", $sformatf(" reset only: %s", seq_item.convert2string), UVM_HIGH)
 			$display("finish item has been invoked");
 	endtask : body

 endclass

//start item - wait for grant
 //uvm_sequence_base(start_item)-> uvm_sequence-> start_item -> 
 //uvm_sequencer_param_base -> sequencer_base -> sequencer.wait_for_grant -> task (wait_for_grant) (called from sequencer)



// The sequence-item execution flow looks like
// 
// User code
//
//| parent_seq.start_item(item, priority);
//| item.randomize(...) [with {constraints}];
//| parent_seq.finish_item(item);
//|
//| or
//|
//| `uvm_do_with_prior(item, constraints, priority)
//|
//
// The following methods are called, in order
//
//|
//|   sequencer.wait_for_grant(prior) (task) \ start_item  \
//|   parent_seq.pre_do(1)            (task) /              \
//|                                                      `uvm_do* macros
//|   parent_seq.mid_do(item)         (func) \              /
//|   sequencer.send_request(item)    (func)  \finish_item /
//|   sequencer.wait_for_item_done()  (task)  /
//|   parent_seq.post_do(item)        (func) /
// 
// Attempting to execute a sequence via <start_item>/<finish_item>
// will produce a run-time error.

				/*sequence_base.svh*/

/*virtual task start_item (uvm_sequence_item item,
                           int set_priority = -1,
                           uvm_sequencer_base sequencer=null);
    uvm_sequence_base seq;
     
    if(item == null) begin
      uvm_report_fatal("NULLITM",
         {"attempting to start a null item from sequence '",
          get_full_name(), "'"}, UVM_NONE);
      return;
    end
          
    if($cast(seq, item)) begin
      uvm_report_fatal("SEQNOTITM",
         {"attempting to start a sequence using start_item() from sequence '",
          get_full_name(), "'. Use seq.start() instead."}, UVM_NONE);
      return;
    end
          
    if (sequencer == null)
        sequencer = item.get_sequencer();
        
    if(sequencer == null)
        sequencer = get_sequencer();   
        
    if(sequencer == null) begin
        uvm_report_fatal("SEQ",{"neither the item's sequencer nor dedicated sequencer has been supplied to start item in ",get_full_name()},UVM_NONE);
       return;
    end

    item.set_item_context(this, sequencer);

    if (set_priority < 0)
      set_priority = get_priority();
    
    sequencer.wait_for_grant(this, set_priority);

    `ifndef UVM_DISABLE_AUTO_ITEM_RECORDING
      void'(sequencer.begin_child_tr(item, m_tr_handle, item.get_root_sequence_name()));
    `endif

    pre_do(1);

  endtask  */


/*virtual task finish_item (uvm_sequence_item item,
                            int set_priority = -1);

    uvm_sequencer_base sequencer;
    
    sequencer = item.get_sequencer();

    if (sequencer == null) begin
        uvm_report_fatal("STRITM", "sequence_item has null sequencer", UVM_NONE);
    end

    mid_do(item);
    sequencer.send_request(this, item);
    sequencer.wait_for_item_done(this, -1);
    `ifndef UVM_DISABLE_AUTO_ITEM_RECORDING
    sequencer.end_tr(item);
    `endif
    post_do(item);

  endtask
*/