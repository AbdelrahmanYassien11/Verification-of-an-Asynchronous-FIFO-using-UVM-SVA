class base_sequence extends uvm_sequence #(sequence_item);
	`uvm_object_utils(base_sequence)
   sequence_item seq_item;

    function new(string name = "base_sequence");
 		super.new(name);
 	endfunction
 	
 	task pre_body();
 		$display("start of pre_body task");
 		seq_item = sequence_item::type_id::create("seq_item");
 	endtask : pre_body
   
   task body();
      $fatal(1,"You cannot use base directly. You must override it");
   endtask : body

endclass : base_sequence
