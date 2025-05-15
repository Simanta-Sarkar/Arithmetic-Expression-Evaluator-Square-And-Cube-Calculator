`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.04.2025 01:17:10
// Design Name: 
// Module Name: Aplus_minusB_three
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


module Aplus_minusB_three(



    input  [3:0] A,
    input  [3:0] B,
    output wire [14:0] A_3,
    output wire [14:0] B_3,
    output wire [14:0] Three_A2B,
    output wire [14:0] Three_AB2,
    output wire [14:0] Final_plus,
    output wire [14:0] Final_minus
);

    // Internal signals
    reg [7:0] A2, B2;  // A² and B² need only 8 bits (15² = 225)
    reg [14:0] A2B, AB2, product_A3, product_B3;
    reg [3:0] A_multiplier, B_multiplier;
    reg [7:0] A_multiplicand, B_multiplicand;

    // A^2 Calculation
    always @(A) begin : A2_block
        integer i;  // Local to the named block
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

    // B^2 Calculation
    always @(B) begin : B2_block
        integer i;  // Local to the named block
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

    // A^3 Calculation
    always @(A2 or A) begin : A3_block
        integer i;  // Local to the named block
        product_A3 = 15'b0;
        A_multiplier = A;
        for (i = 0; i < 4; i = i + 1) begin
            if (A_multiplier[0] == 1'b1)
                product_A3 = product_A3 + (A2 << i);
            A_multiplier = A_multiplier >> 1;
        end
    end

    // B^3 Calculation
    always @(B2 or B) begin : B3_block
        integer i;  // Local to the named block
        product_B3 = 15'b0;
        B_multiplier = B;
        for (i = 0; i < 4; i = i + 1) begin
            if (B_multiplier[0] == 1'b1)
                product_B3 = product_B3 + (B2 << i);
            B_multiplier = B_multiplier >> 1;
        end
    end

    // A^2 * B Calculation
    always @(A2 or B) begin : A2B_block
        integer i;  // Local to the named block
        A2B = 15'b0;
        for (i = 0; i < 4; i = i + 1) begin
            if (B[i] == 1'b1)
                A2B = A2B + (A2 << i);
        end
    end

    // A * B^2 Calculation
    always @(A or B2) begin : AB2_block
        integer i;  // Local to the named block
        AB2 = 15'b0;
        for (i = 0; i < 4; i = i + 1) begin
            if (A[i] == 1'b1)
                AB2 = AB2 + (B2 << i);
        end
    end

    // Output assignments
    assign A_3 = product_A3;
    assign B_3 = product_B3;
    assign Three_A2B = (A2B << 1) + A2B;  // 3A²B
    assign Three_AB2 = (AB2 << 1) + AB2;  // 3AB²
    assign Final_plus  = product_A3 + Three_A2B + Three_AB2 + product_B3;  // (A+B)³
    assign Final_minus = product_A3 - Three_A2B + Three_AB2 - product_B3;  // (A-B)³

endmodule