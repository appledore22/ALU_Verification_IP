/*

    CLASS : alu_driver
    Collects the packet from sequencer and puts it on the interface
    Contains the functions to display operand and opcode    
    
*/

class alu_driver extends uvm_driver #(seq_item);

    `uvm_component_utils(alu_driver)

    // The alu_interface is used to assign the packet data onto the real interface 

    virtual alu_interface intf;

    extern function new(string name = "alu_driver",uvm_component parent);

    // Function : Connect_phase
    // It will get the interface from the factory and store into local virtual interface handle

    extern function void connect_phase(uvm_phase phase);

    // Task : run_phase
    // It will driver the virtual interface signals with the data received from the sequencer.
    // The get_opcode and get_operand function are used to 

    extern task run_phase(uvm_phase phase);

    // Function : put_data
    // Write the seq_item data onto the interface 

    extern function void put_data();

    // Function : get_operand 
    // Upon the randomization of data the get_operand function will display the operand data.
    // The operands are given a UVM_LOW verbosity according to the requirements

    extern function void get_operand();

    // Function : get_opcode
    // Upon the randomization of data the get_opcode function will display the opcode data.
    // The opcode are given a UVM_LOW verbosiy according to the requirements

    extern function void get_opcode();

endclass : alu_driver

function alu_driver::new(string name = "alu_driver", uvm_component parent);
    super.new(name,parent);
endfunction

function void alu_driver::connect_phase(uvm_phase phase);
    if(!(uvm_config_db#(virtual alu_interface)::get(null,"*","alu_interface",intf)))
    `uvm_error("", "uvm_config_db::get - Failed at interface")
endfunction

task alu_driver::run_phase(uvm_phase phase);
    phase.raise_objection(this);
        repeat(10)
        begin
            @(posedge intf.clk);
            seq_item_port.get_next_item(req);
            put_data();
            seq_item_port.item_done();
            get_operand();
            get_opcode();
        end
    phase.drop_objection(this);
endtask

function void alu_driver::put_data();
    intf.operand_1  = req.operand_1;
    intf.operand_2  = req.operand_2;
    intf.opcode     = req.opcode;    
endfunction

function void alu_driver::get_opcode();
    //`uvm_info("Operation : ",$sformatf("%s",req.opcode), UVM_LOW)    
endfunction

function void alu_driver::get_operand();
    //`uvm_info("Operand 1 : ",$sformatf("%b",req.operand_1), UVM_MEDIUM) 
    //`uvm_info("Operand 2 : ",$sformatf("%b",req.operand_2), UVM_MEDIUM)
endfunction