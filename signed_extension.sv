module signed_extension(immI,sign_extended_I);
    input logic[11:0]immI;
    output logic[31:0]sign_extended_I;
    always_comb begin
        sign_extended_I[11:0] = immI[11:0];
        sign_extended_I[31:12] = {20{immI[11]}}; 
    end
endmodule