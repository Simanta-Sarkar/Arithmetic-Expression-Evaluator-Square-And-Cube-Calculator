`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.03.2025 20:10:30
// Design Name: 
// Module Name: A_Square
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


module Another_A2(

    input  [3:0] A,     
    output [7:0] A_2  
);
    reg [7:0] A_product;
    reg [3:0] A_multiplier;
    reg [7:0] A_multiplicand;
    integer i;
    wire [7:0] A_2;  // Explicitly declare output as wire

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
endmodule