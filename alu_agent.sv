    /*
        CLASS : alu_agent
        Creates the object for driver,monitor and sequencer
        Connects the sequencer port to driver port

    */

class alu_agent extends uvm_agent;

    `uvm_component_utils(alu_agent)

    // Create handles for driver,monitor and sequencer

    alu_driver driver;
    alu_sequencer sequencer;
    alu_a_monitor monitor_a;
    alu_p_monitor monitor_p;

    extern function new(string name = "alu_agent", uvm_component parent);

    // Function : build_phase
    // Create object of driver,sequencer and monitor using the UVM Factory Create Method

    extern function void build_phase(uvm_phase phase);
    
    // Function : connect_phase
    // Connect the sequencer port to the driver port

    extern function void connect_phase(uvm_phase phase);

endclass : alu_agent

function alu_agent::new(string name = "alu_agent",uvm_component parent);
    super.new(name,parent);
endfunction : new

function void alu_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);
    driver = alu_driver::type_id::create("driver",this);
    sequencer = alu_sequencer::type_id::create("sequencer",this);
    monitor_a = alu_a_monitor::type_id::create("monitor_a",this);
    monitor_p = alu_p_monitor::type_id::create("monitor_p",this);
endfunction : build_phase

function void alu_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    driver.seq_item_port.connect(sequencer.seq_item_export);
endfunction : connect_phase
