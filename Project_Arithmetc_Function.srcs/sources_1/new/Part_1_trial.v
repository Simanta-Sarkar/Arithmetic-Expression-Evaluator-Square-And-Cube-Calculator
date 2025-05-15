`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.03.2025 03:37:44
// Design Name: 
// Module Name: Part_1_trial
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Part_1_trial(
input clk,          // 100 MHz clock from Basys 3
    input [3:0] sw_A,   // Switches SW0-SW3 for A
    input [3:0] sw_B,   // Switches SW4-SW7 for B
    input sw_plus,      // SW8 to select Final_plus
    input sw_minus,     // SW9 to select Final_minus
    output [6:0] seg,   // 7-segment display segments (CA-CG)
    output [3:0] an     // 7-segment display anodes (AN0-AN3)
);

    integer i;
    reg [3:0] A_multiplier, B_multiplier;
    reg [7:0] A_product, B_product, A_multiplicand, B_multiplicand;
    reg [7:0] product; // 2AB
    reg [7:0] A_2, B_2, TwoAB;
    reg [9:0] Final_plus, Final_minus;
    reg [9:0] display_value; // Value to display on 7-segment

    // Compute A^2
    always @* begin
        A_product = 8'b0;
        A_multiplicand = {4'b0, sw_A};
        A_multiplier = sw_A;
        for (i = 0; i < 4; i = i + 1) begin
            if (A_multiplier[0] == 1'b1)
                A_product = A_product + A_multiplicand;
            A_multiplicand = A_multiplicand << 1;
            A_multiplier = A_multiplier >> 1;
        end
        A_2 = A_product;
    end

    // Compute B^2
    always @* begin
        B_product = 8'b0;
        B_multiplicand = {4'b0, sw_B};
        B_multiplier = sw_B;
        for (i = 0; i < 4; i = i + 1) begin
            if (B_multiplier[0] == 1'b1)
                B_product = B_product + B_multiplicand;
            B_multiplicand = B_multiplicand << 1;
            B_multiplier = B_multiplier >> 1;
        end
        B_2 = B_product;
    end

    // Compute 2AB (synchronous to clock)
    always @(posedge clk) begin
        product = 8'b0;
        for (i = 0; i < 4; i = i + 1) begin
            if (sw_B[i] == 1'b1)
                product = product + ((sw_A << 1) << i);
        end
        TwoAB = product;
    end

    // Compute Final_plus and Final_minus
    always @* begin
        Final_plus = A_2 + TwoAB + B_2;  // (A + B)^2
        Final_minus = A_2 - TwoAB + B_2; // (A - B)^2
        // Select display value based on switches
        if (sw_plus && !sw_minus)
            display_value = Final_plus;
        else if (sw_minus && !sw_plus)
            display_value = Final_minus;
        else
            display_value = 10'b0; // Display 0 if both or neither are high
    end

    // 7-segment display driver
    reg [3:0] digit;         // Current digit to display (0-9 or A-F)
    reg [1:0] digit_select;  // Selects which digit (0-3)
    reg [19:0] counter;      // Clock divider for refresh rate

    always @(posedge clk) begin
        counter <= counter + 1;
        if (counter == 20'd100000) begin // ~1 kHz refresh rate (100 MHz / 100,000)
            counter <= 0;
            digit_select <= digit_select + 1; // Cycle through digits
        end
    end

    // Multiplex the 10-bit value into 4 digits (hexadecimal)
    always @* begin
        case (digit_select)
            2'd0: digit = display_value[3:0];   // Least significant 4 bits
            2'd1: digit = display_value[7:4];   // Next 4 bits
            2'd2: digit = display_value[9:8];   // Most significant 2 bits + 2 zeros
            2'd3: digit = 4'b0000;              // Leading zero (if needed)
            default: digit = 4'b0000;
        endcase
    end

    // Anode control (active-low, enable one digit at a time)
    assign an = (digit_select == 2'd0) ? 4'b1110 :  // AN0 active
                (digit_select == 2'd1) ? 4'b1101 :  // AN1 active
                (digit_select == 2'd2) ? 4'b1011 :  // AN2 active
                (digit_select == 2'd3) ? 4'b0111 :  // AN3 active
                4'b1111;                            // All off (default)

    // Segment control (active-low, common anode)
    assign seg = (digit == 4'h0) ? 7'b1000000 :  // 0
                 (digit == 4'h1) ? 7'b1111001 :  // 1
                 (digit == 4'h2) ? 7'b0100100 :  // 2
                 (digit == 4'h3) ? 7'b0110000 :  // 3
                 (digit == 4'h4) ? 7'b0011001 :  // 4
                 (digit == 4'h5) ? 7'b0010010 :  // 5
                 (digit == 4'h6) ? 7'b0000010 :  // 6
                 (digit == 4'h7) ? 7'b1111000 :  // 7
                 (digit == 4'h8) ? 7'b0000000 :  // 8
                 (digit == 4'h9) ? 7'b0010000 :  // 9
                 (digit == 4'hA) ? 7'b0001000 :  // A
                 (digit == 4'hB) ? 7'b0000011 :  // B
                 (digit == 4'hC) ? 7'b1000110 :  // C
                 (digit == 4'hD) ? 7'b0100001 :  // D
                 (digit == 4'hE) ? 7'b0000110 :  // E
                 (digit == 4'hF) ? 7'b0001110 :  // F
                 7'b1111111;                    // Off (default)
endmodule