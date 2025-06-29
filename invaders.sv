module invader (
    input  logic        Reset, 
    input  logic        frame_clk,
    input  logic [7:0]  keycode,
    input  logic [9:0]  ShotX,
    input  logic [9:0]  ShotY,
    input  logic [9:0]  ShotW,
    input  logic [9:0]  ShotH,
    input  logic [9:0]  Invader_X_Start,
    input  logic [9:0]  Invader_Y_Start,
    input  logic [9:0]  InvaderS,
    input  logic [2:0]  index,
    input  logic [5:0]  Last_Active_Col,
    input  logic [5:0]  First_Active_Col,
    input  logic        Collision,
    input  logic [3:0]  Delay,

    output logic [9:0]  InvaderX, 
    output logic [9:0]  InvaderY,
    output logic        InvaderOn //active invader or not
);

    // Parameters
    parameter [9:0] Invader_X_Step = 15;      // Step size on the X axis

    // Internal Signals
    logic [9:0]  Invader_X_Motion;
    logic [9:0]  Invader_X_Motion_next;
    logic [9:0]  Invader_X_next;
    logic [9:0]  Invader_X_Min;
    logic [9:0]  Invader_X_Max;
    logic [2:0]  Invader_Index; // Index to select which invader to update
    logic [3:0]  Timing_Counter; // Slower timing counter
    logic [9:0]  Min_Offset;
    logic [9:0]  Max_Offset;
    logic        InvaderOnNext;
    
    always_comb begin
        unique case (First_Active_Col)
            5'd0: Min_Offset = 0;
            5'd1: Min_Offset = 25;
            5'd2: Min_Offset = 50;
            5'd3: Min_Offset = 75;
            5'd4: Min_Offset = 100;
            5'd5: Min_Offset = 125;
            5'd6: Min_Offset = 150;
            5'd7: Min_Offset = 175;
            5'd8: Min_Offset = 200;
            5'd9: Min_Offset = 225;
            default: Min_Offset = 0;
        endcase
        unique case (Last_Active_Col)
            5'd0: Max_Offset = 340;
            5'd1: Max_Offset = 315;
            5'd2: Max_Offset = 290;
            5'd3: Max_Offset = 265;
            5'd4: Max_Offset = 240;
            5'd5: Max_Offset = 215;
            5'd6: Max_Offset = 190;
            5'd7: Max_Offset = 165;
            5'd8: Max_Offset = 140;
            5'd9: Max_Offset = 115;
            default: Max_Offset = 115;
        endcase
        Invader_X_Min = Invader_X_Start - Min_Offset;
        Invader_X_Max = Invader_X_Start + Max_Offset;
        
        InvaderOnNext = InvaderOn;
        
        if(Collision) InvaderOnNext = 0;
    end
    
    always_comb begin
        Invader_X_Motion_next = Invader_X_Motion; // Default to previous motion

        // Bounce at boundaries
        if (InvaderX >= Invader_X_Max)
            Invader_X_Motion_next = -Invader_X_Step; // Reverse direction
        else if (InvaderX > Invader_X_Max - Invader_X_Motion_next )
            Invader_X_Motion_next = Invader_X_Max - InvaderX; // Reverse direction
        
        if (InvaderX <= Invader_X_Min)
            Invader_X_Motion_next = Invader_X_Step; // Move forward
        else if (InvaderX < Invader_X_Min - Invader_X_Motion_next)
            Invader_X_Motion_next = Invader_X_Min - InvaderX; // Move forward
    end

    // Calculate Next Position
    assign Invader_X_next = InvaderX + Invader_X_Motion_next;

    // Sequential Logic for Updating Invaders
    always_ff @(posedge frame_clk) begin
        if (Reset || keycode == 21) begin
            InvaderY <= Invader_Y_Start;
            InvaderX <= Invader_X_Start;
            Invader_X_Motion <= Invader_X_Step;
            Invader_Index <= 4;
            Timing_Counter <= 0;
            InvaderOn <= 1;
        end else begin // Move Invader
            InvaderOn <= InvaderOnNext;
            if(InvaderOn) begin
                if(Timing_Counter == Delay) begin
                    Timing_Counter <= 0;
                    Invader_Index <= (Invader_Index == 3'd0) ? 4 : Invader_Index - 1; // Cycle through invaders
                    if((Invader_Index == index)) begin
                        InvaderX <= Invader_X_next; // Update position of the current invader
                        Invader_X_Motion <= Invader_X_Motion_next; // Update motion direction
                    end
                end else begin
                    Timing_Counter <= Timing_Counter + 1;
                end
            end
        end
    end

endmodule
