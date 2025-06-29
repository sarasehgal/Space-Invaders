module DrawBackground(
    input  logic [9:0] DrawX,
    input  logic [6:0] DrawY,
    input  logic [6:0] offset,
    
    output logic [2:0] PalInd
    );
    
    logic [9:0] col;
    logic [6:0] row;
    
    always_comb begin
    
        col = DrawX;
        row = (DrawY + offset) & 8'h7F;
    
        if((col == 76  && row == 21)  ||
           (col == 122 && row == 78)  ||
           (col == 175 && row == 63)  ||
           (col == 187 && row == 32)  ||
           (col == 245 && row == 107) ||
           (col == 248 && row == 25)  ||
           (col == 302 && row == 113) ||
           (col == 313 && row == 119) ||
           (col == 319 && row == 50)  ||
           (col == 329 && row == 93)  ||
           (col == 444 && row == 67)  ||
           (col == 468 && row == 90)  ||
           ((col == 33 || col == 34)   && (row == 21 || row == 22))  ||
           ((col == 108 || col == 109) && (row == 97 || row == 98))  ||
           ((col == 122 || col == 123) && (row == 25 || row == 26))  ||
           ((col == 135 || col == 136) && (row == 38 || row == 39))  ||
           ((col == 301 || col == 302) && (row == 55 || row == 56))  ||
           ((col == 338 || col == 339) && (row == 47 || row == 48))  ||
           ((col == 368 || col == 369) && (row == 114 || row == 115))||
           ((col == 377 || col == 378) && (row == 21 || row == 22))  ||
           ((col == 440 || col == 441) && (row == 108 || row == 109))||
           ((col == 481 || col == 482) && (row == 45 || row == 46))  ||
           ((col == 42  || col == 43  || col == 44 ) && (row == 106 || row == 107 || row == 108)) ||
           ((col == 86  || col == 87  || col == 88 ) && (row == 62  || row == 63  || row == 64 )))
            PalInd = 1;
        else
            PalInd = 0;
    end
endmodule
