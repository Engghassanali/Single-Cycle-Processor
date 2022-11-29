module Ld_St_unit(opcode,fun3,load,LD_Byte,LD_UByte,LD_HW,LD_UHW,LD_W,ST_Byte,ST_HByte,ST_W);
    input logic[6:0] opcode;
    input logic[2:0]fun3;
    input logic [31:0] LD_Byte,LD_UByte,LD_HW,LD_UHW,LD_W;
    input logic [7:0]ST_Byte;
    input logic [15:0]ST_HByte;
    input logic [31:0]ST_W;
    output logic [31:0] load;

    always_comb begin 
        if (opcode == 7'b0000011)begin
            case (fun3)
                3'b000:load = LD_Byte; 
                3'b001:load = LD_HW;
                3'b010:load = LD_W;
                3'b100:load = LD_UByte;
                3'b101:load = LD_UHW;
            endcase
        end
        if (opcode == 7'b0100011)begin
            case (fun3)
                3'b000:load = ST_Byte; 
                3'b001:load = ST_HByte;
                3'b010:load = ST_W;
            endcase
        end
    end
endmodule

module LD_Sizing(opcode,fun3,addr_dm,LD_Byte,LD_HW,LD_W,data_rd,LD_UByte,LD_UHW);
    input logic[6:0]opcode;
    input logic[2:0]fun3;
    input logic[1:0]addr_dm;
    input logic[31:0]data_rd;
    output logic[31:0]LD_Byte,LD_HW,LD_W,LD_UByte,LD_UHW;
    always_comb begin 
        if (opcode == 7'b0000011)begin
            case (fun3)
                3'b000:LD_Byte  = (addr_dm    == 2'b00) ? {{24{data_rd[7]}},data_rd[7:0]} : 0;
                3'b100:LD_UByte = (addr_dm    == 2'b01) ? {24'b0,data_rd[7:0]}  : 0;
                3'b001:LD_HW    = (addr_dm[1] == 1'b0)  ? {{24{data_rd[15]}},data_rd[7:0]}: 0;
                3'b101:LD_UHW   = (addr_dm[1] == 1'b1)  ? {24'b0,data_rd[15:0]} : 0;
                3'b010:LD_W     = data_rd;
                default:LD_W    = data_rd;
            endcase
        end
    end
endmodule

module ST_Sizing(opcode,fun3,mask,data_wr,readData2,addr_dm,ST_Byte,ST_HByte,ST_W);
    input logic[1:0]addr_dm;
    input logic[6:0]opcode;
    input logic[2:0]fun3;
    input logic[31:0]readData2;
    output logic[31:0]data_wr;
    output logic[3:0]mask;
    output logic [7:0]ST_Byte;
    output logic [15:0]ST_HByte;
    output logic [31:0]ST_W;
    always_comb begin 
        if (opcode == 7'b0100011)begin
            case (fun3)
                3'b000:begin 
                    if (addr_dm == 2'b00) begin 
                        data_wr[7:0] = readData2[7:0];mask = 4'b0001;ST_Byte = readData2[7:0];
                    end
                    else begin
                        if (addr_dm == 2'b11)begin
                            data_wr[31:24] = readData2[31:24]; mask = 4'b0001;ST_Byte = readData2[31:24];
                        end
                    end
                end
                3'b001:begin 
                    if (addr_dm[1] == 1'b0)begin
                        data_wr[15:0] = readData2[15:0];mask = 4'b0011;ST_HByte = readData2[15:0];
                    end
                    else begin
                        if (addr_dm[1] == 1'b1) begin
                            data_wr[31:16] = readData2[31:16];mask = 4'b1100;ST_HByte = readData2[15:0];
                        end
                    end
                end
                3'b010:begin data_wr = readData2; mask = 4'b1111; ST_W = readData2;  end
            endcase
        end
        
    end
endmodule