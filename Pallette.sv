module Pallette(
    input  logic [2:0] index,
    
    output logic [3:0] red,
    output logic [3:0] green,
    output logic [3:0] blue
    );
    
    always_comb begin
        unique case (index)
            3'b000: begin
                red = 4'h0;
                green = 4'h0;
                blue = 4'h2;
            end
            3'b001: begin
                red = 4'hf;
                green = 4'hf;
                blue = 4'hf;
            end
            3'b010: begin
                red = 4'h0;
                green = 4'hf;
                blue = 4'h3;
            end
            3'b011: begin
                red = 4'hb;
                green = 4'h1;
                blue = 4'hd;
            end
            3'b100: begin
                red = 4'hf;
                green = 4'h0;
                blue = 4'h2;
            end
            3'b101: begin
                red = 4'h5;
                green = 4'h9;
                blue = 4'hf;
            end
            3'b110: begin
                red = 4'h0;
                green = 4'h0;
                blue = 4'h0;
            end
            default: begin
                red = 4'h0;
                green = 4'h0;
                blue = 4'h0;
            end
        endcase
    end   
endmodule
