`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.04.2025 02:11:52
// Design Name: 
// Module Name: test
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


module test(


    input  [3:0] A,
    input  [3:0] B,
    output reg [16:0] A_3,
    output reg [16:0] B_3,
    output reg [16:0] Three_A2B,
    output reg [16:0] Three_AB2,
    output reg [16:0] Final_plus,
    output reg [16:0] Final_minus
);
    reg [16:0] A2, B2, A2B, AB2;

    // Compute A^2
    always @* begin
        A2 = A * A;
    end

    // Compute B^2
    always @* begin
        B2 = B * B;
    end

    // Compute A^3
    always @* begin
        A_3 = A2 * A;
    end

    // Compute B^3
    always @* begin
        B_3 = B2 * B;
    end

    // Compute A^2 * B
    always @* begin
        A2B = A2 * B;
    end

    // Compute A * B^2
    always @* begin
        AB2 = A * B2;
    end

    // Compute 3(A^2B)
    always @* begin
        Three_A2B = (A2B << 1) + A2B;
    end

    // Compute 3(AB^2)
    always @* begin
        Three_AB2 = (AB2 << 1) + AB2;
    end

    // Compute (A+B)^3 and (A-B)^3
    always @* begin
        Final_plus  = A_3 + Three_A2B + Three_AB2 + B_3;
        Final_minus = A_3 - Three_A2B + Three_AB2 - B_3;
    end
endmodule
