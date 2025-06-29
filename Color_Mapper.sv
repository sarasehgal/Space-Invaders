//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Zuofu Cheng   08-19-2023                               --
//                                                                       --
//    Fall 2023 Distribution                                             --
//                                                                       --
//    For use with ECE 385 USB + HDMI                                    --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( input  logic [9:0] PlayerX, PlayerY, DrawX, DrawY, Player_size,
                       input  logic [9:0] InvaderX[50], InvaderY[50],
                       input  logic [9:0] ShotX, ShotY, ShotW, ShotH,
                       input  logic       ShotOn,
                       input  logic [49:0] InvaderOn,
                       input  logic [6:0]  offset,
                       output logic [3:0] Red, Green, Blue );
    
    logic player_on, sprite_on, player_sprite;
    logic invader_on;
    logic shot_on;
    logic [9:0] InvX, InvY;
    logic [4:0] Invader_size;
    logic [3:0] BackP, PalInd, InvaderP;
	 
 /* Old Ball: Generated square box by checking if the current pixel is within a square of length
    2*BallS, centered at (BallX, BallY).  Note that this requires unsigned comparisons.
	 
    if ((DrawX >= BallX - Ball_size) &&
       (DrawX <= BallX + Ball_size) &&
       (DrawY >= BallY - Ball_size) &&
       (DrawY <= BallY + Ball_size)
       )

     New Ball: Generates (pixelated) circle by using the standard circle formula.  Note that while 
     this single line is quite powerful descriptively, it causes the synthesis tool to use up three
     of the 120 available multipliers on the chip!  Since the multiplicants are required to be signed,
	  we have to first cast them from logic to int (signed by default) before they are multiplied). */
	  
    always_comb
    begin
        if ((DrawX >= PlayerX - Player_size) &&
           (DrawX <= PlayerX + Player_size) &&
           (DrawY >= PlayerY - Player_size) &&
           (DrawY <= PlayerY + Player_size)
           )
            player_on = 1'b1;
        else 
            player_on = 1'b0;
           
       
       if ((DrawX >= ShotX - ShotW) &&
            (DrawX <= ShotX) &&
            (DrawY >= ShotY - ShotH) &&
            (DrawY <= ShotY + ShotH) &&
            ShotOn
           )
            shot_on = 1'b1;
        else 
            shot_on = 1'b0;
       
        for (int i = 0; i < 50; i++) begin
            invader_on = 1'b0;
            InvX = InvaderX[i];
            InvY = InvaderY[i];
            if (i <= 9) begin
                Invader_size = 8;
                InvaderP = 3'b100;
            end else if (i <= 29) begin
                Invader_size = 9;
                InvaderP = 3'b011;
            end else if (i <= 49) begin
                Invader_size = 10;
                InvaderP = 3'b101;
            end
            
            if ((DrawX >= InvaderX[i] - Invader_size) &&
                (DrawX <= InvaderX[i] + Invader_size) &&
                (DrawY >= InvaderY[i] - Invader_size) &&
                (DrawY <= InvaderY[i] + Invader_size) &&
                (InvaderOn[i])) begin
                invader_on = 1'b1;
                break;
            end
        end
         
     end    
       
    always_comb begin

        if ((shot_on) || (player_on && player_sprite)) begin 
            PalInd = 3'b010;
        end
        else if (invader_on && sprite_on) begin
            PalInd = InvaderP;
        end     
        else if (DrawX >= 140 && DrawX <= 500) begin 
            PalInd = BackP;
        end 
        else begin
            PalInd = 3'b110;
        end
    end 
    
    DrawInvader(
        .DrawX(DrawX),    
        .DrawY(DrawY),    
        .InvaderX(InvX), 
        .InvaderY(InvY), 
        .Size(Invader_size),      
        .invader_on(sprite_on)
    );
    
    DrawBackground(
        .DrawX(DrawX),
        .DrawY(DrawY[6:0]),
        .offset(offset),
        .PalInd(BackP)
    );  
    
    Pallette(
        .index(PalInd),
        .red(Red),
        .green(Green),
        .blue(Blue)
    ); 
    
    DrawPlayer(
        .DrawX(DrawX),    
        .DrawY(DrawY),    
        .PlayerX(PlayerX), 
        .PlayerY(PlayerY), 
        .Size(Player_size),      
        .player_on(player_sprite)
    );        
    
endmodule
