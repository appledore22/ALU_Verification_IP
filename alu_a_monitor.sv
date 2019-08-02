    /*

    CLASS : alu_a_monitor
    Samples the data from the interface and pass it onto the scoreboard

    */

class alu_a_monitor extends uvm_monitor;

    `uvm_component_utils(alu_a_monitor)

    // virtual interface is used to sample the data from the real interface

    virtual alu_interface intf;

    // seq_item handle to store the interface data into seq_item packet
    // sqi1 = sequence item 1

    seq_item sqi1;

    // uvm_blocking port to send the seq_item packet to scoreboard

    uvm_blocking_put_port #(seq_item) put_port;


    extern function new(string name = "alu_a_monitor", uvm_component parent);

    // Function : build_phase 
    // create a new put_port object

    extern virtual function void build_phase(uvm_phase phase);

    // Function : connect_phase
    // Get the virtual interface data from the factory

    extern function void connect_phase(uvm_phase phase);

    // Task : run_phase
    // Assign the interface data values to the local seq_item object

    extern virtual task run_phase(uvm_phase phase);

endclass : alu_a_monitor

function alu_a_monitor::new(string name = "alu_a_monitor",uvm_component parent);
    super.new(name,parent);
endfunction : new

function void alu_a_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
    sqi1 = seq_item::type_id::create("sqi1",this);
    put_port = new("put_port",this);
endfunction : build_phase

function void alu_a_monitor::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(!(uvm_config_db#(virtual alu_interface)::get(null,"*","alu_interface",intf)))
    `uvm_error("", "uvm_config_db::get - Failed at interface")
endfunction : connect_phase

task alu_a_monitor::run_phase(uvm_phase phase);
    forever begin
        @(posedge intf.clk);
        sqi1.operand_1  =   intf.operand_1;
        sqi1.operand_2  =   intf.operand_2;
        sqi1.opcode     =   intf.opcode;
        #15;                                // Waiting for DUT to write the output on the interface
        sqi1.result     =   intf.result;
        sqi1.flagc      =   intf.flagc;
        sqi1.flagz      =   intf.flagz;
        put_port.put(sqi1);
        //$display();
        //$display("-------------------------Acitve Monitor Data---------------------");
        //sqi1.print();
    end
endtask : run_phase