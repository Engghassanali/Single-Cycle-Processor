module RISC_V (clk,reset,out);
    input logic clk,reset;
    output logic [31:0]out;
    logic [31:0] rdata1,rdata2,Alu_out,Addr,instruction,wdata,PC,load,ST_W,LD_Byte,LD_UByte,LD_HW,LD_UHW,LD_W,addrL,sign_extended_I,data_wr,data_rd,readData2,ImmU,readData1,immB,ImmJ,PC_br,addrS,ImmS;
    logic[6:0] opcode,fun7;
    logic[4:0] raddr1,raddr2,waddr;
    logic [2:0] fun3;
    logic alu_op,reg_wr,sel_B,cs,wr,sel_A,br_taken;
    logic [1:0] wb_sel,addr_dm;
    logic [3:0] mask;
    logic [7:0] ST_Byte;
    logic [15:0] ST_HByte;
    logic [11:0] immI;

    always_ff @( posedge clk ) begin 
        if (reset)begin
            PC <= 0;
        end        
        else begin
            PC <= PC_br;
        end
    end

    always_comb begin
        assign out = wdata;
        assign raddr1 = instruction[19:15];
        assign raddr2 = instruction[24:20];
        assign waddr  = instruction[11:7] ;
        assign opcode = instruction[6:0]  ;
        assign fun3   = instruction[14:12];
        assign fun7   = instruction[31:25];
        assign Addr   =  PC[31:2];//(br_taken) ? PC : PC[31:2];    
        assign immI   = instruction[31:20];   
        assign addrL   = readData1+sign_extended_I;
        assign ImmU   = {instruction[31:12],12'b0};
        assign immB   = {{20{instruction[31]}},{instruction[7],instruction[30:25],instruction[11:8],1'b0}};
        assign ImmJ   = {{12{instruction[31]}},{instruction[19:12],instruction[20],instruction[30:21],1'b0}};
        assign ImmS   = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
        assign addrS  = readData1+ImmS;
        assign addr_dm = addrS[1:0];
    end


    ALU AL(readData1,readData2,Alu_out,opcode,fun3,fun7,alu_op,ImmU,PC,ImmJ,sign_extended_I,immB);
    controller CN(reset,alu_op,reg_wr,opcode,sel_B,wb_sel,cs,wr,sel_A);
    Data_memory DM(addrL,addrS,data_wr,data_rd,wr,clk,cs,mask);
    instruction_memory IM(Addr,instruction);
    register_file RF(raddr1,raddr2,waddr,wdata,rdata1,rdata2,clk,reg_wr);
    mux_I I_Type(sel_B,rdata2,sign_extended_I,readData2);
    signed_extension SE(immI,sign_extended_I);
    Ld_St_unit LSU(opcode,fun3,load,LD_Byte,LD_UByte,LD_HW,LD_UHW,LD_W,ST_Byte,ST_HByte,ST_W);
    LD_Sizing LDS(opcode,fun3,addr_dm,LD_Byte,LD_HW,LD_W,data_rd,LD_UByte,LD_UHW);
    ST_Sizing STS(opcode,fun3,mask,data_wr,readData2,addr_dm,ST_Byte,ST_HByte,ST_W);
    mux_LS mxLS(wb_sel,Alu_out,load,wdata,PC);
    Branch_Mux Br_M(sel_A,rdata1,PC,readData1);
    Branch_taken Br_tk(Alu_out,PC_br,br_taken,PC);
    Branch Br(rdata1,rdata2,br_taken,opcode,fun3);
endmodule