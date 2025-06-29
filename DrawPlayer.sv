module DrawPlayer(
    input  logic [9:0] DrawX,
    input  logic [9:0] DrawY,
    input  logic [9:0] PlayerX,
    input  logic [9:0] PlayerY,
    input  logic [4:0] Size,
    
    output logic       player_on
    );
    
    logic [9:0] col, row;
    
    always_comb begin
        row = DrawY - PlayerY + Size;
        if(DrawX <= PlayerX)
            col = PlayerX - DrawX;
        else
            col = DrawX - PlayerX;
        if((col == 2  && (row == 1  || row == 0)) ||
           (col == 3  && (row == 1  || row == 0)) ||
           (col == 4  && (row == 1  || row == 0)) ||
           (col == 5  && (row == 0  || row == 1  || row == 2  || row == 3  || row == 4  || row == 5)) ||
           (col == 6  && (row == 0  || row == 1  || row == 2  || row == 3  || row == 4  || row == 5)) ||
           (col == 7  && (row == 0  || row == 1  || row == 2  || row == 3  || row == 4  || row == 5)) ||
           (col == 8  && (row == 0  || row == 1  || row == 2  || row == 3  || row == 4  || row == 5)) ||
           (col == 9  && (row == 0  || row == 1  || row == 2  || row == 3  || row == 4  || row == 5)) ||
           (col == 10 && (row == 0  || row == 1  || row == 2  || row == 3  || row == 4  || row == 5)) ||
           (col == 11 && (row == 0  || row == 1  || row == 2  || row == 3  || row == 4  || row == 5)) ||
           (col == 12 && (row == 0  || row == 1  || row == 2  || row == 3  || row == 4  || row == 5  || row == 6  || row == 7)))
            player_on = 0;
        else
            player_on = 1;
    end
    
endmodule
