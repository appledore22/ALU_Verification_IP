/*
    CLASS : alu_sequencer

*/

class alu_sequencer extends uvm_sequencer #(seq_item);

    `uvm_sequencer_utils(alu_sequencer)

    extern function new(string name = "alu_sequencer", uvm_component parent);
            
endclass : alu_sequencer

function alu_sequencer::new(string name = "alu_sequencer", uvm_component parent);
    super.new(name,parent);
endfunction : new