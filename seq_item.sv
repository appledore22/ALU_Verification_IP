/*
    
    CLASS : seq_item
    The seq_item class is used to create a packet of required data that will drive through the interface.
    
*/

    //   Declaring the required operation in enumerated data-type so as to easily identify the operation that is performed

    typedef enum bit [2:0] {
                            ADD,
                            SUB,
                            MUL,
                            AND,
                            OR,
                            NAND,
                            NOR,
                            EXOR                                    
    } operation;


class seq_item extends uvm_sequence_item;

    // Required Data in simulation

    rand bit            [7:0]   operand_1;
    rand bit            [7:0]   operand_2;
    rand operation              opcode;
    bit                 [15:0]  result;
    bit                         flagc;
    bit                         flagz;

    // Registering the data with UVM Factory

    `uvm_object_utils_begin(seq_item)
        `uvm_field_int(operand_1,UVM_ALL_ON)
        `uvm_field_int(operand_2,UVM_ALL_ON)
        `uvm_field_enum(operation,opcode,UVM_ALL_ON)
    `uvm_object_utils_end
        
    extern function new(string name = "seq_item");     

endclass : seq_item

function seq_item::new(string name = "seq_item");
    super.new(name);
endfunction : new