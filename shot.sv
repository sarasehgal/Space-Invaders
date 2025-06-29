module shot(
    input  logic        Reset, 
    input  logic        frame_clk,
    input  logic [7:0]  keycode0,
    input  logic [7:0]  keycode1,
    input  logic [9:0]  PlayerX,
    input  logic [9:0]  PlayerY,
    input  logic [9:0]  PlayerS,
    input  logic        Player, // Indicates whether this is a player shot
    input  logic [9:0]  InvaderX[50], 
    input  logic [9:0]  InvaderY[50],
    input  logic [49:0] InvaderOn,

    output logic [9:0]  ShotX, 
    output logic [9:0]  ShotY, 
    output logic [9:0]  ShotW,
    output logic [9:0]  ShotH,
    output logic        ShotOn,
    output logic [49:0] Collision
);

    // Parameters
    parameter [9:0] Shot_Y_Min = 10;      // Highest point on the Y axis
    parameter [9:0] Shot_Y_Max = 479;      // Highest point on the Y axis
    parameter [9:0] Shot_Y_Step = 8;     // Step size on the Y axis

    // Internal Signals
    logic [9:0] Shot_Y_Motion;
    logic [9:0] Shot_Y_next;
    logic ShotOnNext;
    logic [4:0] Invader_size;
    
    always_comb begin
        ShotOnNext = ShotOn;
        for(int i = 0; i < 50; i++) begin   
            Collision[i] = 0;
            if (i <= 9) 
                Invader_size = 8;
            else if (i <= 29) 
                Invader_size = 9;
            else if (i <= 49) 
                Invader_size = 10;
            if ((ShotX >= InvaderX[i] - Invader_size) &&
                (ShotX <= InvaderX[i] + Invader_size + ShotW) &&
                (ShotY >= InvaderY[i] - Invader_size - ShotH) &&
                (ShotY <= InvaderY[i] + Invader_size + ShotH) &&
                (InvaderOn[i]) && (ShotOn)) begin
                Collision[i] = 1;
                break;
            end
        end
            if(Collision)
                ShotOnNext = 0;
    end
    
    assign ShotH = 6;   // Height of sprite
    assign ShotW = 1;   // Width

    // Sequential Logic for Shot State
    always_ff @(posedge frame_clk) begin
        if (Reset) begin
            ShotOn <= 0; // Reset disables the shot
            ShotY <= 0;
            ShotX <= 0;
        end else if (ShotOn) begin
            // Update shot position
            ShotY <= Shot_Y_next;
            ShotOn <= ShotOnNext;
            // Turn off the shot if it reaches the border
            if (ShotY <= Shot_Y_Min && Player) begin
                ShotOn <= 0; // Shot for player hits the top
            end else if (ShotY >= Shot_Y_Max && !Player) begin
                ShotOn <= 0; // Shot for invader hits the bottom
            end
        end else if (((keycode0 == 8'd44)|| keycode1 == 8'd44) && !ShotOn) begin
            // Launch new shot
            ShotOn <= 1;
            ShotX <= PlayerX; // Start at the player's current X position
            if (Player)
                ShotY <= PlayerY - PlayerS - ShotH; // Above player sprite
            else
                ShotY <= PlayerY + PlayerS + ShotH; // Below invader sprite
        end
    end

    // Combinational Logic for Next Shot Position
    always_comb begin
        Shot_Y_Motion = 0; // Default to no motion
        if (ShotOn) begin
            if (Player)
                Shot_Y_Motion = -Shot_Y_Step; // Move up for player
            else
                Shot_Y_Motion = Shot_Y_Step;  // Move down for invader
        end
        Shot_Y_next = ShotY + Shot_Y_Motion; // Calculate next Y position
    end

endmodule
