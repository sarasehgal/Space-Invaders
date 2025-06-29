module player (
    input  logic        Reset, 
    input  logic        frame_clk,
    input  logic [7:0]  keycode0,
    input  logic [7:0]  keycode1,//input left or right

    output logic [9:0]  PlayerX, //horizontal pos
    output logic [9:0]  PlayerY, //veritcal pos -fixed
    output logic [9:0]  PlayerS //-size fixed at 12
);

    // Parameters
    parameter [9:0] Player_X_Center = 320;   // Center position on the X axis
    parameter [9:0] Player_Y_Center = 450;   // Fixed position on the Y axis
    parameter [9:0] Player_X_Min = 140;        // Leftmost point on the X axis
    parameter [9:0] Player_X_Max = 500;      // Rightmost point on the X axis
    parameter [9:0] Player_X_Step = 2;       // Step size on the X axis

    // Internal Signals
    logic [9:0] Player_X_Motion;
    logic [9:0] Player_X_Motion_next;
    logic [9:0] Player_X_next;

    // Combinational Logic for Motion
    always_comb begin
        Player_X_Motion_next = 10'd0; // Default to no motion

        // Handle keycode for left and right movement
        if ((keycode0 == 8'h07) || (keycode1 == 8'h07)) // Right key
            Player_X_Motion_next = Player_X_Step;
        else if ((keycode0 == 8'h04) || (keycode1 == 8'h04)) // Left key
            Player_X_Motion_next = -Player_X_Step;

        // Stop motion at boundaries
        if (PlayerX > (Player_X_Max - PlayerS - Player_X_Motion_next) )
            Player_X_Motion_next = Player_X_Max - PlayerS - PlayerX;
        else if (PlayerX < (Player_X_Min + PlayerS - Player_X_Motion_next))
            Player_X_Motion_next = Player_X_Min + PlayerS - PlayerX;
    end

    // Assign Player Size
    assign PlayerS = 12; // Default player size

    // Calculate Next Position
    assign Player_X_next = PlayerX + Player_X_Motion_next;

    // Sequential Logic for Updating Position
    always_ff @(posedge frame_clk) begin
        if (Reset) begin
            PlayerX <= Player_X_Center; // Reset to center
            PlayerY <= Player_Y_Center; // Fixed vertical position
            Player_X_Motion <= 10'd0;   // No motion
        end else begin
            PlayerX <= Player_X_next;  // Update horizontal position
            Player_X_Motion <= Player_X_Motion_next;
            PlayerY <= Player_Y_Center; // Keep Y position constant
        end
    end
endmodule
