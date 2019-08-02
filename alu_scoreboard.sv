    /*
        CLASS : alu_scoreboard
        Recieves the packets from the monitor via the port
        Recieves the packets from the passive monitor (alu_p_monitor)
        Performs operation on the packets received from the active monitor
        Calculates and compare the actual and predicted data

    */

    // Declare uvm_imp for recevieing pakects from more than one source

    `uvm_blocking_put_imp_decl(_a)
    `uvm_blocking_put_imp_decl(_p)

class alu_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(alu_scoreboard)

    // virtual interface for performing operation at the posedge of the clk

    virtual alu_interface intf;

    // seq_item queue is used to store the incoming data packet from the active monitor

    seq_item data_rec_a[$];

    // seq_item queue is used to store the incoming data packet from the active monitor

    seq_item data_rec_p[$];

    // temp_seq_item_a is used to store the seq_item poped from the data_rec_a queue

    seq_item temp_seq_item_a;

    // temp_seq_item_p is used to store the seq_item poped from the data_rec_p queue

    seq_item temp_seq_item_p;

    // uvm_imp port to receive packets from the active monitor

    uvm_blocking_put_imp_a #(seq_item,alu_scoreboard) put_export_a;

    // uvm_imp port to receive packets from the passive monitor

    uvm_blocking_put_imp_p #(seq_item,alu_scoreboard) put_export_p;


    extern function new(string name = "alu_scoreboard", uvm_component parent);

    // Function : build_phase
    // Create put_export object

    extern function void build_phase(uvm_phase phase);

    // Function : connect_phase
    // get method for virtual interface

    extern function void connect_phase(uvm_phase phase);

    // Task : put_a
    // This task will be called from the active monitor to give port data 
    // The 'seq' will contain data from the interface and will be used to compute results for ideal DUT

    extern task put_a(seq_item seq);

    // Task : put_p
    // This task will be called from the passive monitor to give port data 
    // The 'seq' will contain data from the interface and will be used to compute results for ideal DUT

    extern task put_p(seq_item seq);
    
    // Task : run_phase
    // It will compute the expected DUT output and compare with to actual output
    
    extern virtual task run_phase(uvm_phase phase);

    // Function : exp_dut
    // It will compute the expected output from seq_item_a and store the result on the seq_item_a
    // Returns the handle to the seq_item

    //extern function seq_item exp_dut();

    // Function : compare_item
    // Compares the received seq_item and the expected seq_item

    extern function void compare_item();
    

endclass : alu_scoreboard

function alu_scoreboard::new(string name = "alu_scoreboard",uvm_component parent);
    super.new(name,parent);
endfunction : new

function void alu_scoreboard::build_phase(uvm_phase phase);
    super.build_phase(phase);
    put_export_a    =   new("put_export_a",this);
    put_export_p    =   new("put_export_p",this);
    temp_seq_item_a =   new("temp_seq_item_a");
    temp_seq_item_p =   new("temp_seq_item_p");
endfunction : build_phase

function void alu_scoreboard::connect_phase(uvm_phase phase);
    if(!(uvm_config_db#(virtual alu_interface)::get(null,"*","alu_interface",intf)))
    `uvm_error("", "uvm_config_db::get - Failed at interface")
endfunction : connect_phase
    
task alu_scoreboard::put_a(seq_item seq);
    data_rec_a.push_back(seq);
endtask : put_a

task alu_scoreboard::put_p(seq_item seq);
    data_rec_p.push_back(seq);
endtask : put_p

function void alu_scoreboard::compare_item();
    temp_seq_item_p = data_rec_p.pop_front();
        
    if(temp_seq_item_a.compare(temp_seq_item_p))
        `uvm_info(get_name(),"------------Data Matched Successful------------",UVM_MEDIUM)
    else
        `uvm_error(get_name(), "-------------Data Mismatched----------------")
endfunction : compare_item

task alu_scoreboard::run_phase(uvm_phase phase);
    forever begin
        wait(data_rec_a.size > 0);
        temp_seq_item_a = data_rec_a.pop_front();
        //@(posedge intf.clk)
        case(temp_seq_item_a.opcode)
            ADD     : 
                    begin 
                        temp_seq_item_a.result  =   temp_seq_item_a.operand_1 + temp_seq_item_a.operand_2;
                        temp_seq_item_a.flagc   =   temp_seq_item_a.result[8];
                        temp_seq_item_a.flagz   =   (temp_seq_item_a.result == 0);  
                    end
            SUB     :
                    begin 
                        temp_seq_item_a.result  =   temp_seq_item_a.operand_1 - temp_seq_item_a.operand_2;
                        temp_seq_item_a.flagc   =   temp_seq_item_a.result[8];
                        temp_seq_item_a.flagz   =   (temp_seq_item_a.result == 0);  
                    end
            MUL     :
                    begin 
                        temp_seq_item_a.result  =   temp_seq_item_a.operand_1 * temp_seq_item_a.operand_2;
                        temp_seq_item_a.flagc   =   1'b0;
                        temp_seq_item_a.flagz   =   (temp_seq_item_a.result == 0);  
                    end
            AND     :
                    begin 
                        temp_seq_item_a.result  =   temp_seq_item_a.operand_1 & temp_seq_item_a.operand_2;
                        temp_seq_item_a.flagc   =   1'b0;
                        temp_seq_item_a.flagz   =   (temp_seq_item_a.result == 0);  
                    end
            OR      :
                    begin 
                        temp_seq_item_a.result  =   temp_seq_item_a.operand_1 | temp_seq_item_a.operand_2;
                        temp_seq_item_a.flagc   =   1'b0;
                        temp_seq_item_a.flagz   =   (temp_seq_item_a.result == 0);  
                    end
            NAND    :
                    begin 
                        temp_seq_item_a.result  =   ~(temp_seq_item_a.operand_1 & temp_seq_item_a.operand_2);
                        temp_seq_item_a.flagc   =   1'b0;
                        temp_seq_item_a.flagz   =   (temp_seq_item_a.result == 0);  
                    end
            NOR     :
                    begin 
                        temp_seq_item_a.result  =   ~(temp_seq_item_a.operand_1 | temp_seq_item_a.operand_2);
                        temp_seq_item_a.flagc   =   1'b0;
                        temp_seq_item_a.flagz   =   (temp_seq_item_a.result == 0);  
                    end
            EXOR     :
                    begin 
                        temp_seq_item_a.result  =   temp_seq_item_a.operand_1 ^ temp_seq_item_a.operand_2;
                        temp_seq_item_a.flagc   =   1'b0;
                        temp_seq_item_a.flagz   =   (temp_seq_item_a.result == 0);  
                    end
            
            default:
                    begin 
                        temp_seq_item_a.result  =   16'b0;
                        temp_seq_item_a.flagc   =   1'b0;
                        temp_seq_item_a.flagz   =   1'b0;  
                    end
        endcase
        compare_item();
    end
endtask : run_phase