module mux_I(sel_B,rdata2,sign_extended_I,readData2);
    input logic[31:0]rdata2,sign_extended_I;
    input sel_B;
    output logic[31:0]readData2;

    always_comb begin 
        case (sel_B)
            0:readData2 = rdata2;
            1:readData2 = sign_extended_I; 
        endcase
    end
endmodule

module mux_LS(wb_sel,Alu_out,load,wdata,PC);
    input logic[1:0]wb_sel;
    input logic[31:0]Alu_out,load,PC;
    output logic[31:0]wdata;

    always_comb begin 
        case(wb_sel)
            2'b00:wdata = Alu_out;
            2'b01:wdata = load;
            2'b10:wdata = PC;
        endcase
    end
endmodule

module Branch_Mux(sel_A,rdata1,PC,readData1);
    input logic[31:0]rdata1,PC;
    output logic[31:0]readData1;
    input sel_A;

    always_comb begin 
        case (sel_A)
            0: readData1 = rdata1;
            1: readData1 = PC; 
        endcase 
    end
endmodule

module Branch_taken(Alu_out,PC_br,br_taken,PC);
    input logic [31:0]Alu_out,PC;
    input logic br_taken;
    output logic [31:0] PC_br;
    always_comb begin 
        case (br_taken)
            0: PC_br = PC + 4;
            1: PC_br = Alu_out; 
        endcase  
    end      
endmodule