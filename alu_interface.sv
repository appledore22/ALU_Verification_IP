interface alu_interface (input clk);
    logic [7:0] operand_1;
    logic [7:0] operand_2;
    logic [2:0] opcode;
    logic flagc;
    logic flagz;
    logic [15:0] result;
endinterface : alu_interface