class scoreboard extends uvm_scoreboard;
 	`uvm_component_utils(scoreboard);

 	sequence_item seq_item;

  predictor predictor_h;
  comparator comparator_h;

 	//uvm_tlm_analysis_fifo #(sequence_item) tlm_analysis_fifo;

 	uvm_analysis_export #(sequence_item) analysis_export_inputs;
  uvm_analysis_export #(sequence_item) analysis_export_outputs;


  virtual inf my_vif;

 	function new(string name = "scoreboard", uvm_component parent);
 	 	super.new(name, parent);
 	endfunction

 	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		//tlm_analysis_fifo = new("tlm_analysis_fifo",this);
		analysis_export_outputs = new("analysis_export_outputs",this);
    analysis_export_inputs = new("analysis_export_inputs",this);

    predictor_h = predictor::type_id::create("predictor_h", this);
    comparator_h = comparator::type_id::create("comparator_h", this);


    if(!uvm_config_db#(virtual inf)::get(this,"","my_vif",my_vif)) begin //to fix the get warning of having no container to return to
      `uvm_fatal(get_full_name(),"Error");
    end

    uvm_config_db#(virtual inf)::set(this, "predictor_h", "my_vif", my_vif);

				
		$display("my_scoreboard build phase");
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		analysis_export_inputs.connect(predictor_h.analysis_export);
    analysis_export_outputs.connect(comparator_h.analysis_actual_outputs);
    predictor_h.analysis_port_expected_outputs.connect(comparator_h.analysis_expected_outputs);
		$display("my_scoreboard connect phase");
	endfunction

endclass


/*class uvm_tlm_analysis_fifo #(type T = int) extends uvm_tlm_fifo #(T);

  // Port: analysis_export #(T)
  //
  // The analysis_export provides the write method to all connected analysis
  // ports and parent exports:
  //
  //|  function void write (T t)
  //
  // Access via ports bound to this export is the normal mechanism for writing
  // to an analysis FIFO. 
  // See write method of <uvm_tlm_if_base #(T1,T2)> for more information.

  uvm_analysis_imp #(T, uvm_tlm_analysis_fifo #(T)) analysis_export;


  // Function: new
  //
  // This is the standard uvm_component constructor. ~name~ is the local name
  // of this component. The ~parent~ should be left unspecified when this
  // component is instantiated in statically elaborated constructs and must be
  // specified when this component is a child of another UVM component.

  function new(string name ,  uvm_component parent = null);
    super.new(name, parent, 0); // analysis fifo must be unbounded
    analysis_export = new("analysis_export", this);
  endfunction

  const static string type_name = "uvm_tlm_analysis_fifo #(T)";

  virtual function string get_type_name();
    return type_name;
  endfunction

  function void write(input T t);
    void'(this.try_put(t)); // unbounded => must succeed
  endfunction

endclass*/


/*class uvm_tlm_fifo #(type T=int) extends uvm_tlm_fifo_base #(T);

  const static string type_name = "uvm_tlm_fifo #(T)";

  local mailbox #( T ) m;
  local int m_size;
  protected int m_pending_blocked_gets;


  // Function: new
  //
  // The ~name~ and ~parent~ are the normal uvm_component constructor arguments. 
  // The ~parent~ should be null if the <uvm_tlm_fifo> is going to be used in a
  // statically elaborated construct (e.g., a module). The ~size~ indicates the
  // maximum size of the FIFO; a value of zero indicates no upper bound.

  function new(string name, uvm_component parent = null, int size = 1);
    super.new(name, parent);
    m = new( size );
    m_size = size;
  endfunction

  virtual function string get_type_name();
    return type_name;
  endfunction


  // Function: size
  //
  // Returns the capacity of the FIFO-- that is, the number of entries
  // the FIFO is capable of holding. A return value of 0 indicates the
  // FIFO capacity has no limit.

  virtual function int size();
    return m_size;
  endfunction
 

  // Function: used
  //
  // Returns the number of entries put into the FIFO.

  virtual function int used();
    return m.num();
  endfunction


  // Function: is_empty
  //
  // Returns 1 when there are no entries in the FIFO, 0 otherwise.

  virtual function bit is_empty();
    return (m.num() == 0);
  endfunction
 

  // Function: is_full
  //
  // Returns 1 when the number of entries in the FIFO is equal to its <size>,
  // 0 otherwise.

  virtual function bit is_full();
    return (m_size != 0) && (m.num() == m_size);
  endfunction
 


  virtual task put( input T t );
    m.put( t );
    put_ap.write( t );
  endtask

  virtual task get( output T t );
    m_pending_blocked_gets++;
    m.get( t );
    m_pending_blocked_gets--;
    get_ap.write( t );
  endtask
  
  virtual task peek( output T t );
    m.peek( t );
  endtask
   
  virtual function bit try_get( output T t );
    if( !m.try_get( t ) ) begin
      return 0;
    end

    get_ap.write( t );
    return 1;
  endfunction 
  
  virtual function bit try_peek( output T t );
    if( !m.try_peek( t ) ) begin
      return 0;
    end
    return 1;
  endfunction

  virtual function bit try_put( input T t );
    if( !m.try_put( t ) ) begin
      return 0;
    end
  
    put_ap.write( t );
    return 1;
  endfunction  

  virtual function bit can_put();
    return m_size == 0 || m.num() < m_size;
  endfunction  

  virtual function bit can_get();
    return m.num() > 0 && m_pending_blocked_gets == 0;
  endfunction
  
  virtual function bit can_peek();
    return m.num() > 0;
  endfunction


  // Function: flush
  //
  // Removes all entries from the FIFO, after which <used> returns 0
  // and <is_empty> returns 1.

  virtual function void flush();
    T t;
    bit r;

    r = 1; 
    while( r ) r = try_get( t ) ;
    
    if( m.num() > 0 && m_pending_blocked_gets != 0 ) begin
      uvm_report_error("flush failed" ,
		       "there are blocked gets preventing the flush", UVM_NONE);
    end
  
  endfunction
 
endclass */

/*virtual class uvm_tlm_fifo_base #(type T=int) extends uvm_component;

  typedef uvm_tlm_fifo_base #(T) this_type;
  
  // Port: put_export
  //
  // The ~put_export~ provides both the blocking and non-blocking put interface
  // methods to any attached port:
  //
  //|  task put (input T t)
  //|  function bit can_put ()
  //|  function bit try_put (input T t)
  //
  // Any ~put~ port variant can connect and send transactions to the FIFO via this
  // export, provided the transaction types match. See <uvm_tlm_if_base #(T1,T2)>
  // for more information on each of the above interface methods.

  uvm_put_imp #(T, this_type) put_export;
  

  // Port: get_peek_export
  //
  // The ~get_peek_export~ provides all the blocking and non-blocking get and peek
  // interface methods:
  //
  //|  task get (output T t)
  //|  function bit can_get ()
  //|  function bit try_get (output T t)
  //|  task peek (output T t)
  //|  function bit can_peek ()
  //|  function bit try_peek (output T t)
  //
  // Any ~get~ or ~peek~ port variant can connect to and retrieve transactions from
  // the FIFO via this export, provided the transaction types match. See
  // <uvm_tlm_if_base #(T1,T2)> for more information on each of the above interface
  // methods.

  uvm_get_peek_imp #(T, this_type) get_peek_export;  


  // Port: put_ap
  //
  // Transactions passed via ~put~ or ~try_put~ (via any port connected to the
  // <put_export>) are sent out this port via its ~write~ method.
  //
  //|  function void write (T t)
  //
  // All connected analysis exports and imps will receive put transactions.
  // See <uvm_tlm_if_base #(T1,T2)> for more information on the ~write~ interface
  // method.

  uvm_analysis_port #(T) put_ap;


  // Port: get_ap
  //
  // Transactions passed via ~get~, ~try_get~, ~peek~, or ~try_peek~ (via any
  // port connected to the <get_peek_export>) are sent out this port via its
  // ~write~ method.
  //
  //|  function void write (T t)
  //
  // All connected analysis exports and imps will receive get transactions.
  // See <uvm_tlm_if_base #(T1,T2)> for more information on the ~write~ method.

  uvm_analysis_port #(T) get_ap;


  // The following are aliases to the above put_export.

  uvm_put_imp      #(T, this_type) blocking_put_export;
  uvm_put_imp      #(T, this_type) nonblocking_put_export;

  // The following are all aliased to the above get_peek_export, which provides
  // the superset of these interfaces.

  uvm_get_peek_imp #(T, this_type) blocking_get_export;
  uvm_get_peek_imp #(T, this_type) nonblocking_get_export;
  uvm_get_peek_imp #(T, this_type) get_export;
  
  uvm_get_peek_imp #(T, this_type) blocking_peek_export;
  uvm_get_peek_imp #(T, this_type) nonblocking_peek_export;
  uvm_get_peek_imp #(T, this_type) peek_export;
  
  uvm_get_peek_imp #(T, this_type) blocking_get_peek_export;
  uvm_get_peek_imp #(T, this_type) nonblocking_get_peek_export;


  // Function: new
  //
  // The ~name~ and ~parent~ are the normal uvm_component constructor arguments. 
  // The ~parent~ should be null if the uvm_tlm_fifo is going to be used in a
  // statically elaborated construct (e.g., a module). The ~size~ indicates the
  // maximum size of the FIFO. A value of zero indicates no upper bound.

  function new(string name, uvm_component parent = null);
    super.new(name, parent);

    put_export = new("put_export", this);
    blocking_put_export     = put_export;
    nonblocking_put_export  = put_export;

    get_peek_export = new("get_peek_export", this);
    blocking_get_peek_export    = get_peek_export;
    nonblocking_get_peek_export = get_peek_export;
    blocking_get_export         = get_peek_export;
    nonblocking_get_export      = get_peek_export;
    get_export                  = get_peek_export;
    blocking_peek_export        = get_peek_export;
    nonblocking_peek_export     = get_peek_export;
    peek_export                 = get_peek_export;

    put_ap = new("put_ap", this);
    get_ap = new("get_ap", this);
    
  endfunction

  //turn off auto config
  function void build_phase(uvm_phase phase);
    build(); //for backward compat, won't cause auto-config
    return;
  endfunction

  virtual function void flush();
    uvm_report_error("flush", `UVM_TLM_FIFO_FUNCTION_ERROR, UVM_NONE);
  endfunction
  
  virtual function int size();
    uvm_report_error("size", `UVM_TLM_FIFO_FUNCTION_ERROR, UVM_NONE);
    return 0;
  endfunction

  virtual task put(T t);
    uvm_report_error("put", `UVM_TLM_FIFO_TASK_ERROR, UVM_NONE);
  endtask

  virtual task get(output T t);
    uvm_report_error("get", `UVM_TLM_FIFO_TASK_ERROR, UVM_NONE);
  endtask

  virtual task peek(output T t);
    uvm_report_error("peek", `UVM_TLM_FIFO_TASK_ERROR, UVM_NONE);
  endtask
  
  virtual function bit try_put(T t);
    uvm_report_error("try_put", `UVM_TLM_FIFO_FUNCTION_ERROR, UVM_NONE);
    return 0;
  endfunction

  virtual function bit try_get(output T t);
    uvm_report_error("try_get", `UVM_TLM_FIFO_FUNCTION_ERROR, UVM_NONE);
    return 0;
  endfunction

  virtual function bit try_peek(output T t);
    uvm_report_error("try_peek", `UVM_TLM_FIFO_FUNCTION_ERROR, UVM_NONE);
    return 0;
  endfunction
  
  virtual function bit can_put();
    uvm_report_error("can_put", `UVM_TLM_FIFO_FUNCTION_ERROR, UVM_NONE);
    return 0;
  endfunction

  virtual function bit can_get();
    uvm_report_error("can_get", `UVM_TLM_FIFO_FUNCTION_ERROR, UVM_NONE);
    return 0;
  endfunction

  virtual function bit can_peek();
    uvm_report_error("can_peek", `UVM_TLM_FIFO_FUNCTION_ERROR, UVM_NONE);
    return 0;
  endfunction

  virtual function uvm_tlm_event ok_to_put();
    uvm_report_error("ok_to_put", `UVM_TLM_FIFO_FUNCTION_ERROR, UVM_NONE);
    return null;
  endfunction

  virtual function uvm_tlm_event ok_to_get();
    uvm_report_error("ok_to_get", `UVM_TLM_FIFO_FUNCTION_ERROR, UVM_NONE);
    return null;
  endfunction

  virtual function uvm_tlm_event ok_to_peek();
    uvm_report_error("ok_to_peek", `UVM_TLM_FIFO_FUNCTION_ERROR, UVM_NONE);
    return null;
  endfunction

  virtual function bit is_empty();
    uvm_report_error("is_empty", `UVM_TLM_FIFO_FUNCTION_ERROR, UVM_NONE);
    return 0;
  endfunction

  virtual function bit is_full();
    uvm_report_error("is_full", `UVM_TLM_FIFO_FUNCTION_ERROR);
    return 0;
  endfunction

  virtual function int used();
    uvm_report_error("used", `UVM_TLM_FIFO_FUNCTION_ERROR, UVM_NONE);
    return 0;
  endfunction

endclass*/