class base_sequence extends uvm_sequence #(sequence_item);

   sequence_item seq_item;

    function new(string name = "base_sequence");
 		super.new(name);
 	endfunction
   
   task body();
      $fatal(1,"You cannot use base directly. You must override it");
   endtask : body

endclass : base_sequence
