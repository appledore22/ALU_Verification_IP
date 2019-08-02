module ALU8bit( Opcode,

                clk,

                Operand1,

                Operand2,

                Result,

                flagC,

                flagZ

              );

    input clk;    

    input [2:0]  Opcode;

    input [7:0]  Operand1,

             Operand2;

     

    output reg [15:0] Result = 16'b0;

    output reg  flagC = 1'b0,

            flagZ = 1'b0;   

    parameter  [2:0] ADD = 3'b000,

                 SUB = 3'b001,

                 MUL = 3'b010,

                 AND = 3'b011,

                 OR = 3'b100,

                 NAND = 3'b101,

                 NOR = 3'b110,

                 XOR = 3'b111; 
                      

    always @ (posedge clk)

    begin

        case (Opcode)

            ADD: begin

            Result = Operand1 + Operand2;

            flagC  = Result[8];

            flagZ  = (Result == 16'b0);

            end

            SUB: begin

            Result = Operand1 - Operand2;

            flagC  = Result[8];

            flagZ  = (Result == 16'b0);

            end

            MUL: begin

            Result = Operand1 * Operand2;

            flagZ  = (Result == 16'b0);

            end

            AND: begin

            Result = Operand1 & Operand2;

            flagZ  = (Result == 16'b0);

            end

            OR:  begin

                Result = Operand1 | Operand2;

                flagZ  = (Result == 16'b0);

            end

            NAND: begin

            Result = ~(Operand1 & Operand2);

            flagZ  = (Result == 16'b0);

            end

            NOR: begin

            Result = ~(Operand1 | Operand2);

            flagZ  = (Result == 16'b0);

            end

            XOR: begin

            Result = Operand1 ^ Operand2;

            flagZ  = (Result == 16'b0);

            end

            default: begin

            Result = 16'b0;

            flagC  = 1'b0;

            flagZ  = 1'b0;

            end

        endcase

    end

endmodule