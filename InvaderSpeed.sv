module InvaderSpeed(
    input  logic [49:0] InvaderOn,
    output logic [3:0]  Delay
);
    logic [5:0] Count; // Count can go up to 50, so we need 6 bits
    
    always_comb begin
        Count = 0;
        for (int i = 0; i < 50; i++) begin
            if (InvaderOn[i])
                Count = Count + 1;
        end
        // Limit Delay to a maximum of 15
        if (Count > 15)
            Delay = 4'b1111;
        else
            Delay = Count[3:0]; // Only take the lower 4 bits of Count
    end
endmodule

