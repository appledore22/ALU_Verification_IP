/*
    CLASS   :   alu_sequence
    CHILD   :   alu_seq_*
    * may contain add,sub,mul,etc
    Responsilbe for sending packets to the driver
    It is a parameterized class that uses seq_item as the parameter
    It randomizes the opcode and operands

*/

class alu_sequence extends uvm_sequence #(seq_item);

    `uvm_object_utils(alu_sequence)

    seq_item req;

    extern function new(string name = "alu_sequence");
    
    // Task : body
    // Upon the drivers request the task will randomize the data and send the randomized packets to the driver.
    
    extern virtual task body();
            
endclass : alu_sequence

/*
    CLASS   :   alu_seq_add
    PARENT  :   alu_sequence
    Randomizes the operands and set the opcode to ADD
*/

class alu_seq_add extends alu_sequence;

    `uvm_object_utils(alu_seq_add)

    extern function new(string name = "alu_seq_add");

    // TASK : body
    // Randomizes the operands and sets opcode to ADD

    extern task body();

endclass : alu_seq_add

function alu_seq_add::new(string name = "alu_seq_add");
    super.new(name);
endfunction : new

task alu_seq_add::body();
    req = seq_item::type_id::create("req");
    forever begin
        wait_for_grant();
        assert(req.randomize() with {req.opcode == ADD;});
        send_request(req);
        wait_for_item_done();            
    end
endtask : body

function alu_sequence::new(string name = "alu_sequence");
    super.new(name);
endfunction

task alu_sequence::body();
    req = seq_item::type_id::create("req");
    forever begin
        wait_for_grant();
        assert(req.randomize());
        send_request(req);
        wait_for_item_done();            
    end
endtask
        