`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.03.2025 11:49:54
// Design Name: 
// Module Name: Arithmetic_Function
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

module Arithmetic_Function(


    input clk,          
    input  [3:0] A,
    input  [3:0] B,     
    output [7:0] TwoAB, 
    output [7:0] A_2,
    output [7:0] B_2,
    output [9:0] Final_plus,
    output [9:0] Final_minus    
);
    reg [7:0] product;
    integer i;
    wire [7:0] TwoAB;  // Explicitly declare output as wire
    reg [7:0] A_product;
    reg [3:0] A_multiplier;
    reg [7:0] A_multiplicand;
    integer i;
    wire [7:0] A_2;  // Explicitly declare output as wire
    reg [7:0] B_product;
    reg [3:0] B_multiplier;
    reg [7:0] B_multiplicand;
    integer i;
    wire [7:0] B_2;  // Explicitly declare output as wire

    
        always @(A) begin
        A_product = 8'b0;
        A_multiplicand = {4'b0, A};
        A_multiplier = A;

        for (i = 0; i < 4; i = i + 1) begin
            if (A_multiplier[0] == 1'b1)
                A_product = A_product + A_multiplicand;
            A_multiplicand = A_multiplicand << 1;
            A_multiplier = A_multiplier >> 1;
        end
    end

    assign A_2 = A_product;

    always @(posedge clk) begin
        product = 8'b0;
        for (i = 0; i < 4; i = i + 1) begin
            if (B[i] == 1'b1)
                product = product + (A << 1) << i;  
        end
    end

    assign TwoAB = product;

    always @(B) begin
        B_product = 8'b0;
        B_multiplicand = {4'b0, B};
        B_multiplier = B;

        for (i = 0; i < 4; i = i + 1) begin
            if (B_multiplier[0] == 1'b1)
                B_product = B_product + B_multiplicand;
            B_multiplicand = B_multiplicand << 1;
            B_multiplier = B_multiplier >> 1;
        end
    end

    assign B_2 = B_product;
    
    assign Final_plus = A_2 + TwoAB + B_2;
    assign Final_minus = A_2 - TwoAB + B_2;
    
    
endmodule

