    `include "uvm_macros.svh"
    `include "alu_interface.sv"
    `include "dut.v"
    import uvm_pkg::*;
    `include "seq_item.sv"
    `include "alu_sequence.sv"
    `include "alu_sequencer.sv"
    `include "alu_driver.sv"
    `include "alu_a_monitor.sv"
    `include "alu_p_monitor.sv"
    `include "alu_agent.sv"
    `include "alu_scoreboard.sv"
    `include "alu_env.sv"
    `include "alu_test.sv"

module alu_top;
    
    bit clk;

    always #25 clk = ~clk;
    
    alu_interface intf(clk);

    ALU8bit d1(.Opcode(intf.opcode),.clk(clk),.Operand1(intf.operand_1),.Operand2(intf.operand_2),
        .Result(intf.result),.flagC(intf.flagc),.flagZ(intf.flagz));
        
    initial begin
        uvm_config_db#(virtual alu_interface)::set(uvm_root::get(),"*","alu_interface",intf);
        uvm_top.set_report_verbosity_level(UVM_MEDIUM);
    end

    initial begin
        run_test("alu_test_random");
    end
endmodule