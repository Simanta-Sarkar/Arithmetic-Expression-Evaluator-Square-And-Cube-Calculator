`timescale 1ns / 1ps

module top_level(
    input clk,          // 100 MHz clock from Basys 3
    input [3:0] sw_A,   // Switches SW0-SW3 for A
    input [3:0] sw_B,   // Switches SW4-SW7 for B
    input sw_plus_2,    // SW8 for (A+B)^2
    input sw_minus_2,   // SW9 for (A-B)^2
    input sw_plus_3,    // SW10 for (A+B)^3
    input sw_minus_3,   // SW11 for (A-B)^3
    input reset,        // SW12 for reset
    output [6:0] seg,   // 7-segment display segments (CA-CG)
    output [3:0] an     // 7-segment display anodes (AN0-AN3)
);

    // Instantiate (A+B)^2 and (A-B)^2 module
    wire [7:0] TwoAB, A_2, B_2;
    wire [9:0] Final_plus_2, Final_minus_2;
    A_plus_B_and_A_minus_B u1 (
        .A(sw_A),
        .B(sw_B),
        .TwoAB(TwoAB),
        .A_2(A_2),
        .B_2(B_2),
        .Final_plus_2(Final_plus_2),
        .Final_minus_2(Final_minus_2)
    );

    // Instantiate (A+B)^3 and (A-B)^3 module
    wire [14:0] A_3, B_3, Three_A2B, Three_AB2, Final_plus_3, Final_minus_3;
    Aplus_minusB_three u2 (
        .A(sw_A),
        .B(sw_B),
        .A_3(A_3),
        .B_3(B_3),
        .Three_A2B(Three_A2B),
        .Three_AB2(Three_AB2),
        .Final_plus_3(Final_plus_3),
        .Final_minus_3(Final_minus_3)
    );

    // Display selection and reset logic
    reg [15:0] display_value; // 16 bits to handle 15-bit Final_plus_3/Final_minus_3
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            display_value <= 16'b0;
        end else begin
            if (sw_plus_2 && !sw_minus_2 && !sw_plus_3 && !sw_minus_3)
                display_value <= {6'b0, Final_plus_2};  // (A+B)^2 (10-bit)
            else if (sw_minus_2 && !sw_plus_2 && !sw_plus_3 && !sw_minus_3)
                display_value <= {6'b0, Final_minus_2}; // (A-B)^2 (10-bit)
            else if (sw_plus_3 && !sw_minus_3 && !sw_plus_2 && !sw_minus_2)
                display_value <= Final_plus_3;          // (A+B)^3 (15-bit)
            else if (sw_minus_3 && !sw_plus_3 && !sw_plus_2 && !sw_minus_2)
                display_value <= Final_minus_3;         // (A-B)^3 (15-bit)
            else
                display_value <= 16'b0;                 // Default to 0
        end
    end

    // 7-segment display driver
    reg [3:0] digit;
    reg [1:0] digit_select;
    reg [19:0] counter;

    always @(posedge clk) begin
        counter <= counter + 1;
        if (counter == 20'd100000) begin // ~1 kHz refresh rate
            counter <= 0;
            digit_select <= digit_select + 1;
        end
    end

    always @(digit_select or display_value) begin
        case (digit_select)
            2'd0: digit = display_value[3:0];    // Digit 0 (LSB)
            2'd1: digit = display_value[7:4];    // Digit 1
            2'd2: digit = display_value[11:8];   // Digit 2
            2'd3: digit = display_value[15:12];  // Digit 3 (MSB, 0 for 10-bit values)
            default: digit = 4'b0;
        endcase
    end

    // Anode control (active-low)
    assign an = (digit_select == 2'd0) ? 4'b1110 :  // AN0
                (digit_select == 2'd1) ? 4'b1101 :  // AN1
                (digit_select == 2'd2) ? 4'b1011 :  // AN2
                (digit_select == 2'd3) ? 4'b0111 :  // AN3
                4'b1111;

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
                 (digit == 4'hB) ? 7'b0000011 :  // b
                 (digit == 4'hC) ? 7'b1000110 :  // C
                 (digit == 4'hD) ? 7'b0100001 :  // d
                 (digit == 4'hE) ? 7'b0000110 :  // E
                 (digit == 4'hF) ? 7'b0001110 :  // F
                 7'b1111111;                    // Off

endmodule

// Include the original modules unchanged
module A_plus_B_and_A_minus_B(
    input  [3:0] A,
    input  [3:0] B,     
    output reg [9:0] TwoAB, 
    output reg [7:0] A_2,
    output reg [7:0] B_2,
    output reg [9:0] Final_plus_2,
    output reg [9:0] Final_minus_2    
);

    integer i;
    reg [3:0] A_multiplier, B_multiplier;
    reg [7:0] A_product, B_product, A_multiplicand, B_multiplicand;
    reg [9:0] product; //  2AB

    always @* begin
        A_product = 8'b0;
        A_multiplicand = {4'b0, A}; 
        A_multiplier = A;
        for (i = 0; i < 4; i = i + 1) begin
            if (A_multiplier[0] == 1'b1)
                A_product = A_product + A_multiplicand;
            A_multiplicand = A_multiplicand << 1;
            A_multiplier = A_multiplier >> 1;
        end
        A_2 = A_product;
    end

    always @* begin
        B_product = 8'b0;
        B_multiplicand = {4'b0, B}; 
        B_multiplier = B;
        for (i = 0; i < 4; i = i + 1) begin
            if (B_multiplier[0] == 1'b1)
                B_product = B_product + B_multiplicand;
            B_multiplicand = B_multiplicand << 1;
            B_multiplier = B_multiplier >> 1;
        end
        B_2 = B_product;
    end

    always @* begin
        product = 8'b0;
        for (i = 0; i < 4; i = i + 1) begin
            if (B[i] == 1'b1)
                product = product + ((A << 1) << i);  
        end
        TwoAB = product;
    end

    always @* begin
        Final_plus_2  = A_2 + TwoAB + B_2;
        Final_minus_2 = A_2 - TwoAB + B_2;
    end

endmodule

module Aplus_minusB_three(
    input  [3:0] A,
    input  [3:0] B,
    output wire [14:0] A_3,
    output wire [14:0] B_3,
    output wire [14:0] Three_A2B,
    output wire [14:0] Three_AB2,
    output wire [14:0] Final_plus_3,
    output wire [14:0] Final_minus_3
);

    reg [7:0] A2, B2;  // A² and B² need only 8 bits (15² = 225)
    reg [14:0] A2B, AB2, product_A3, product_B3;
    reg [3:0] A_multiplier, B_multiplier;
    reg [7:0] A_multiplicand, B_multiplicand;

    always @(A) begin : A2_block
        integer i;
        A2 = 8'b0;
        A_multiplicand = {4'b0, A};
        A_multiplier = A;
        for (i = 0; i < 4; i = i + 1) begin
            if (A_multiplier[0] == 1'b1)
                A2 = A2 + A_multiplicand;
            A_multiplicand = A_multiplicand << 1;
            A_multiplier = A_multiplier >> 1;
        end
    end

    always @(B) begin : B2_block
        integer i;
        B2 = 8'b0;
        B_multiplicand = {4'b0, B};
        B_multiplier = B;
        for (i = 0; i < 4; i = i + 1) begin
            if (B_multiplier[0] == 1'b1)
                B2 = B2 + B_multiplicand;
            B_multiplicand = B_multiplicand << 1;
            B_multiplier = B_multiplier >> 1;
        end
    end

    always @(A2 or A) begin : A3_block
        integer i;
        product_A3 = 15'b0;
        A_multiplier = A;
        for (i = 0; i < 4; i = i + 1) begin
            if (A_multiplier[0] == 1'b1)
                product_A3 = product_A3 + (A2 << i);
            A_multiplier = A_multiplier >> 1;
        end
    end

    always @(B2 or B) begin : B3_block
        integer i;
        product_B3 = 15'b0;
        B_multiplier = B;
        for (i = 0; i < 4; i = i + 1) begin
            if (B_multiplier[0] == 1'b1)
                product_B3 = product_B3 + (B2 << i);
            B_multiplier = B_multiplier >> 1;
        end
    end

    always @(A2 or B) begin : A2B_block
        integer i;
        A2B = 15'b0;
        for (i = 0; i < 4; i = i + 1) begin
            if (B[i] == 1'b1)
                A2B = A2B + (A2 << i);
        end
    end

    always @(A or B2) begin : AB2_block
        integer i;
        AB2 = 15'b0;
        for (i = 0; i < 4; i = i + 1) begin
            if (A[i] == 1'b1)
                AB2 = AB2 + (B2 << i);
        end
    end

    assign A_3 = product_A3;
    assign B_3 = product_B3;
    assign Three_A2B = (A2B << 1) + A2B;  // 3A²B
    assign Three_AB2 = (AB2 << 1) + AB2;  // 3AB²
    assign Final_plus_3  = product_A3 + Three_A2B + Three_AB2 + product_B3;  // (A+B)³
    assign Final_minus_3 = product_A3 - Three_A2B + Three_AB2 - product_B3;  // (A-B)³

endmodule