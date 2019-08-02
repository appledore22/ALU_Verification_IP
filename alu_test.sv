
// -----------------------------------------------------------------------------------------
    
    /*
        CLASS : alu_test
        CHILD : alu_test_*
        * may contain add,sub,mul,etc.
        Creates the env object and has the methods for deciding 'TEST PASS' and 'TEST FAIL' using UVM_REPORT_SERVER

    */

class alu_test extends uvm_test;

    `uvm_component_utils(alu_test)

    // env handle declaration

    alu_env env;

    extern function new(string name = "alu_test",uvm_component parent);

    // Function : build_phase
    // Creates the env object using factory method

    extern function void build_phase(uvm_phase phase);

    // Function : end_of _elaboration
    // Prints the topology 

    extern function void end_of_elaboration();

    // Function : report_phase
    // Contains the UVM_REPORT_SERVER handle which is used to decide 'TEST PASS' or 'TEST FAIL' 
    
    extern function void report_phase(uvm_phase phase);

endclass : alu_test

function alu_test::new(string name = "alu_test",uvm_component parent);
    super.new(name,parent);
endfunction : new

function void alu_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = alu_env::type_id::create("alu_test",this);
endfunction : build_phase

function void alu_test::end_of_elaboration();
    print();
endfunction : end_of_elaboration

function void alu_test::report_phase(uvm_phase phase);
    uvm_report_server svr;

    super.report_phase(phase);
    svr = uvm_report_server::get_server();

    if(svr.get_severity_count(UVM_ERROR)> 0)
    begin        
        $display("");
        $display("--------------------------------------------------------------------");
        $display("                              TEST FAILED ");
        $display("--------------------------------------------------------------------");
    end
    else 
    begin
        $display("");
        $display("--------------------------------------------------------------------");
        $display("                           TEST PASSED ");
        $display("--------------------------------------------------------------------");
    end
    
endfunction : report_phase

// -----------------------------------------------------------------------------------------

    /*
      
        CLASS   : alu_test_random
        PARENT  : alu_test
        Creates a testcase with random operands and opcode

    */    

class alu_test_random extends alu_test;

    `uvm_component_utils(alu_test_random)

    // Declearing alu_sequence for randoming testing

    alu_sequence rand_seq;

    extern function new(string name = "alu_test_random",uvm_component parent);

    // Function : build_phase
    // Create the object for the rand_seq handle

    extern function void build_phase(uvm_phase phase);

    // Task : run_phase
    // starts the sequencer for the alu_sequence

    extern task run_phase(uvm_phase phase);


endclass : alu_test_random

function alu_test_random::new(string name = "alu_test_random",uvm_component parent);
    super.new(name,parent);
endfunction : new

function void alu_test_random::build_phase(uvm_phase phase);
    super.build_phase(phase);
    rand_seq = alu_sequence::type_id::create("rand_seq",this);
endfunction : build_phase

task alu_test_random::run_phase(uvm_phase phase);
    rand_seq.start(env.agent.sequencer);
endtask : run_phase

// -----------------------------------------------------------------------------------------

    /*
        CLASS   :   alu_test_add
        PARENT  :   alu_test
        Create a sequence of alu_seq_add so as to set the opcode to ADD
    */

class alu_test_add extends alu_test;

    `uvm_component_utils(alu_test_add)

    // Declaring add_seq for constraint testing with opcode = ADD

    alu_seq_add add_seq;

    extern function new(string name = "alu_test_add",uvm_component parent);

    // Function : build_phase 
    // Creates the object for add_seq handle

    extern function void build_phase(uvm_phase phase);

    // Function : run_phase
    // Starts the sequencer for add sequence

    extern task run_phase(uvm_phase phase);


endclass : alu_test_add

function alu_test_add::new(string name = "alu_test_add",uvm_component parent);
    super.new(name,parent);
endfunction : new

function void alu_test_add::build_phase(uvm_phase phase);
    super.build_phase(phase);
    add_seq = alu_seq_add::type_id::create("add_seq",this);
endfunction : build_phase

task alu_test_add::run_phase(uvm_phase phase);
    add_seq.start(env.agent.sequencer);
endtask : run_phase

// -----------------------------------------------------------------------------------------
