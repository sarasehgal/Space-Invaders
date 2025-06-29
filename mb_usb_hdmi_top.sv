//-------------------------------------------------------------------------
//    mb_usb_hdmi_top.sv                                                 --
//    Zuofu Cheng                                                        --
//    2-29-24                                                            --
//                                                                       --
//                                                                       --
//    Spring 2024 Distribution                                           --
//                                                                       --
//    For use with ECE 385 USB + HDMI                                    --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module mb_usb_hdmi_top(
    input logic Clk,
    input logic reset_rtl_0,
    
    //USB signals
    input logic [0:0] gpio_usb_int_tri_i,
    output logic gpio_usb_rst_tri_o,
    input logic usb_spi_miso,
    output logic usb_spi_mosi,
    output logic usb_spi_sclk,
    output logic usb_spi_ss,
    
    //UART
    input logic uart_rtl_0_rxd,
    output logic uart_rtl_0_txd,
    
    //HDMI
    output logic hdmi_tmds_clk_n,
    output logic hdmi_tmds_clk_p,
    output logic [2:0]hdmi_tmds_data_n,
    output logic [2:0]hdmi_tmds_data_p,
        
    //HEX displays
    output logic [7:0] hex_segA,
    output logic [3:0] hex_gridA,
    output logic [7:0] hex_segB,
    output logic [3:0] hex_gridB
);
    
    logic [31:0] keycode0_gpio, keycode1_gpio;
    logic clk_25MHz, clk_125MHz, clk, clk_100MHz;
    logic locked;
    logic [9:0] drawX, drawY, playerxsig, playerysig, playersizesig, shotxsig, shotysig, shotwsig, shothsig;
    logic [9:0] invaderxsig[50], invaderysig[50];
    logic shotonsig;
    logic [49:0] InvaderOn, InvaderCollision;
    logic [6:0]  offset;

    logic hsync, vsync, vde;
    logic [3:0] red, green, blue;
    logic reset_ah;
    logic [5:0] counter;
    
    assign reset_ah = reset_rtl_0;
    
    
    //Keycode HEX drivers
    hex_driver HexA (
        .clk(Clk),
        .reset(reset_ah),
        .in({keycode0_gpio[31:28], keycode0_gpio[27:24], keycode0_gpio[23:20], keycode0_gpio[19:16]}),
        .hex_seg(hex_segA),
        .hex_grid(hex_gridA)
    );
    
    hex_driver HexB (
        .clk(Clk),
        .reset(reset_ah),
        .in({keycode0_gpio[15:12], keycode0_gpio[11:8], keycode0_gpio[7:4], keycode0_gpio[3:0]}),
        .hex_seg(hex_segB),
        .hex_grid(hex_gridB)
    );
    
    mb_block mb_block_i (
        .clk_100MHz(Clk),
        .gpio_usb_int_tri_i(gpio_usb_int_tri_i),
        .gpio_usb_keycode_0_tri_o(keycode0_gpio),
        .gpio_usb_keycode_1_tri_o(keycode1_gpio),
        .gpio_usb_rst_tri_o(gpio_usb_rst_tri_o),
        .reset_rtl_0(~reset_ah), //Block designs expect active low reset, all other modules are active high
        .uart_rtl_0_rxd(uart_rtl_0_rxd),
        .uart_rtl_0_txd(uart_rtl_0_txd),
        .usb_spi_miso(usb_spi_miso),
        .usb_spi_mosi(usb_spi_mosi),
        .usb_spi_sclk(usb_spi_sclk),
        .usb_spi_ss(usb_spi_ss)
    );
        
    //clock wizard configured with a 1x and 5x clock for HDMI
    clk_wiz_0 clk_wiz (
        .clk_out1(clk_25MHz),
        .clk_out2(clk_125MHz),
        .reset(reset_ah),
        .locked(locked),
        .clk_in1(Clk)
    );
    
    //VGA Sync signal generator
    vga_controller vga (
        .pixel_clk(clk_25MHz),
        .reset(reset_ah),
        .hs(hsync),
        .vs(vsync),
        .active_nblank(vde),
        .drawX(drawX),
        .drawY(drawY)
    );    

    //Real Digital VGA to HDMI converter
    hdmi_tx_0 vga_to_hdmi (
        //Clocking and Reset
        .pix_clk(clk_25MHz),
        .pix_clkx5(clk_125MHz),
        .pix_clk_locked(locked),
        //Reset is active LOW
        .rst(reset_ah),
        //Color and Sync Signals
        .red(red),
        .green(green),
        .blue(blue),
        .hsync(hsync),
        .vsync(vsync),
        .vde(vde),
        
        //aux Data (unused)
        .aux0_din(4'b0),
        .aux1_din(4'b0),
        .aux2_din(4'b0),
        .ade(1'b0),
        
        //Differential outputs
        .TMDS_CLK_P(hdmi_tmds_clk_p),          
        .TMDS_CLK_N(hdmi_tmds_clk_n),          
        .TMDS_DATA_P(hdmi_tmds_data_p),         
        .TMDS_DATA_N(hdmi_tmds_data_n)          
    );

    
    //Ball Module
    player player_instance(
        .Reset(reset_ah),
        .frame_clk(vsync),                    //Figure out what this should be so that the ball will move
        .keycode0(keycode0_gpio[7:0]),
        .keycode1(keycode0_gpio[15:8]),
        .PlayerX(playerxsig),
        .PlayerY(playerysig),
        .PlayerS(playersizesig)
    );
    
    InstantiateInvaders Invaders(
        .reset_ah(reset_ah), 
        .vsync(vsync),
        .keycode(keycode0_gpio[7:0]),
        .ShotX(shotxsig),
        .ShotY(shotysig),
        .ShotW(shotwsig),
        .ShotH(shothsig),
        .Collision(InvaderCollision),
        .InvaderX(invaderxsig), 
        .InvaderY(invaderysig),
        .InvaderOn(InvaderOn)
     );
    
    shot player_shot(
        .Reset(reset_ah), 
        .frame_clk(vsync),
        .keycode0(keycode0_gpio[7:0]),
        .keycode1(keycode0_gpio[15:8]),
        .PlayerX(playerxsig),
        .PlayerY(playerysig),
        .PlayerS(playersizesig),
        .Player(1'b1),
        .InvaderX(invaderxsig),
        .InvaderY(invaderysig),
        .InvaderOn(InvaderOn),
        .ShotX(shotxsig), 
        .ShotY(shotysig), 
        .ShotW(shotwsig),
        .ShotH(shothsig),
        .ShotOn(shotonsig),
        .Collision(InvaderCollision)
   );    
    //Color Mapper Module   
    color_mapper color_instance(
        .PlayerX(playerxsig),
        .PlayerY(playerysig),
        .DrawX(drawX),
        .DrawY(drawY),
        .Player_size(playersizesig),
        .InvaderX(invaderxsig),
        .InvaderY(invaderysig),
        .offset(offset),
        .Red(red),
        .Green(green),
        .Blue(blue),
        .ShotX(shotxsig), 
        .ShotY(shotysig), 
        .ShotW(shotwsig),
        .ShotH(shothsig),
        .ShotOn(shotonsig),
        .InvaderOn(InvaderOn)
    );
    
    always_ff @ (posedge vsync) begin
        if(reset_ah)
            offset <= 7'd127;
        else
             offset <= (offset < 4) ? 7'd127 : offset - 4;
    end
endmodule
