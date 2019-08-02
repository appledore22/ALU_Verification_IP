    /*
        CLASS : alu_env
        Generates the objects for active agent, passive agent, scoreboard

    */

class alu_env extends uvm_env;

    `uvm_component_utils(alu_env)

    // Delcaring the handles of the required components
    alu_agent agent;
    alu_scoreboard scb;

    extern function new(string name = "alu_env", uvm_component parent);

    // Function : build_phase
    // Creates the object for the handles

    extern function void build_phase(uvm_phase phase);

    // Function : connect_phase
    // Connects the agents to the scoreboard

    extern function void connect_phase(uvm_phase phase);

endclass : alu_env

function alu_env::new(string name = "alu_env", uvm_component parent);
    super.new(name,parent);
endfunction : new

function void alu_env::build_phase(uvm_phase phase);
    agent   =   alu_agent::type_id::create("agnet",this);
    scb     =   alu_scoreboard::type_id::create("scb",this);
endfunction : build_phase

function void alu_env::connect_phase(uvm_phase phase);
    agent.monitor_a.put_port.connect(scb.put_export_a);
    agent.monitor_p.put_port.connect(scb.put_export_p);
endfunction
