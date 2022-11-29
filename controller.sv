module controller(reset,alu_op,reg_wr,opcode,sel_B,wb_sel,cs,wr,sel_A);
    input logic reset;
    input logic[6:0] opcode;
    output logic alu_op,reg_wr,sel_B,cs,wr,sel_A;
    output logic[1:0]wb_sel;

    always_comb 
    begin
        if (reset)begin
            alu_op = 0;
            reg_wr = 0;
            sel_B  = 0;
            sel_A  = 0;
            wb_sel = 2'b00;
        end 
        else begin
            case (opcode)
            7'b0110011: begin alu_op = 1; reg_wr = 1; sel_A = 0;sel_B = 0; wb_sel = 2'b00;                 end 
            7'b0010011: begin alu_op = 1; reg_wr = 1; sel_B = 1; sel_A = 0; wb_sel = 2'b00;                end
            7'b0000011: begin reg_wr = 1; wb_sel = 2'b01; cs = 0; wr = 0; sel_A = 0;alu_op = 1; sel_B = 0; end
            7'b0100011: begin reg_wr = 0; wb_sel = 2'b01; cs = 0; wr = 1; sel_A = 0;alu_op = 1; sel_B = 0; end
            7'b1100011: begin sel_A  = 1; alu_op = 1; reg_wr = 1; sel_B = 0;wb_sel = 2'b00;                end
            7'b1101111: begin wb_sel = 2'b10; alu_op = 1; reg_wr = 1;sel_A = 0; sel_B = 0;                 end
            7'b1100111: begin wb_sel = 2'b10; alu_op = 1; reg_wr = 1; sel_A = 0; sel_B = 0;                end 
            default:    begin alu_op = 1; reg_wr = 1;                                                      end
        endcase
        end
           
    end

endmodule