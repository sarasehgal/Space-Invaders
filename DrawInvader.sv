module DrawInvader(
    input  logic [9:0] DrawX,
    input  logic [9:0] DrawY,
    input  logic [9:0] InvaderX,
    input  logic [9:0] InvaderY,
    input  logic [4:0] Size,
    
    output logic       invader_on
    );
    
    logic [9:0] col, row;
    
    always_comb begin
        row = DrawY - InvaderY + Size;
        if(DrawX <= InvaderX)
            col = InvaderX - DrawX;
        else
            col = DrawX - InvaderX;
        if(Size == 10) begin
            if((col == 0  && (row == 14 || row == 15 || row == 16 || row == 19 || row == 20)) ||
               (col == 1  && (row == 14 || row == 15 || row == 16 || row == 19 || row == 20)) ||
               (col == 2  && (row == 14 || row == 15 || row == 16 || row == 19 || row == 20)) ||
               (col == 3  && (row == 9  || row == 10 || row == 17 || row == 18 || row == 19 || row == 20)) ||
               (col == 4  && (row == 9  || row == 10 || row == 17 || row == 18)) ||
               (col == 5  && (row == 0  || row == 1  || row == 2  || row == 9  || row == 10 || row == 17 || row == 18)) ||
               (col == 6  && (row == 0  || row == 1  || row == 2  || row == 9  || row == 10)) ||
               (col == 7  && (row == 0  || row == 1  || row == 2)) ||
               (col == 8  && (row == 0  || row == 1  || row == 2  || row == 14 || row == 15 || row == 16 || row == 19 || row == 20)) ||
               (col == 9  && (row == 0  || row == 1  || row == 2  || row == 3  || row == 4  || row == 14 || row == 15 || row == 16 || row == 19 || row == 20)) ||
               (col == 10 && (row == 0  || row == 1  || row == 2  || row == 3  || row == 4  || row == 14 || row == 15 || row == 16 || row == 17 || row == 18 || row == 19 || row == 20)))
                invader_on = 0;
            else
                invader_on = 1;
        end else if(Size == 9) begin
            if((col == 0  && (row == 0  || row == 1  || row == 2  || row == 3  || row == 14 || row == 15 || row == 16 || row == 17 || row == 18)) ||
               (col == 1  && (row == 0  || row == 1  || row == 2  || row == 3  || row == 14 || row == 15 || row == 16)) ||
               (col == 2  && (row == 0  || row == 1  || row == 2  || row == 3  || row == 14 || row == 15 || row == 16)) ||
               (col == 3  && (row == 0  || row == 1  || row == 6  || row == 7  || row == 14 || row == 15 || row == 16)) ||
               (col == 4  && (row == 0  || row == 1  || row == 6  || row == 7  || row == 17 || row == 18)) ||
               (col == 5  && (row == 2  || row == 3  || row == 17 || row == 18)) ||
               (col == 6  && (row == 2  || row == 3  || row == 12 || row == 13 || row == 14 || row == 15 || row == 16 || row == 17 || row == 18)) ||
               (col == 7  && (row == 0  || row == 1  || row == 2  || row == 3  || row == 4  || row == 5  || row == 12 || row == 13 || row == 14 || row == 15 || row == 16 || row == 17 || row == 18)) ||
               (col == 8  && (row == 0  || row == 1  || row == 2  || row == 3  || row == 4  || row == 5  || row == 17 || row == 18)) ||
               (col == 9  && (row == 0  || row == 1  || row == 2  || row == 3  || row == 4  || row == 5  || row == 6  || row == 7  || row == 17 || row == 18)))
                invader_on = 0;
            else
                invader_on = 1;
       end else if(Size == 8) begin
            if((col == 0  && (row == 13 || row == 14 || row == 15 || row == 16)) ||
               (col == 1  && (row == 13 || row == 14 || row == 15 || row == 16)) ||
               (col == 2  && (row == 13 || row == 14 || row == 15 || row == 16)) ||
               (col == 3  && (row == 0  || row == 1  || row == 7  || row == 8  || row == 11 || row == 12 || row == 13 || row == 14 || row == 15 || row == 16)) ||
               (col == 4  && (row == 0  || row == 1  || row == 7  || row == 8  || row == 11 || row == 12 || row == 13 || row == 14 || row == 15 || row == 16)) ||
               (col == 5  && (row == 0  || row == 1  || row == 2  || row == 3  || row == 13 || row == 14)) ||
               (col == 6  && (row == 0  || row == 1  || row == 2  || row == 3  || row == 13 || row == 14)) ||
               (col == 7  && (row == 0  || row == 1  || row == 2  || row == 3  || row == 4  || row == 5  || row == 11 || row == 12 || row == 15 || row == 16)) ||
               (col == 8  && (row == 0  || row == 1  || row == 2  || row == 3  || row == 4  || row == 5  || row == 11 || row == 12 || row == 15 || row == 16)))
                invader_on = 0;
            else
                invader_on = 1;  
       end   
    end
endmodule
