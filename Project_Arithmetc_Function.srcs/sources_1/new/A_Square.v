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


module A_Square(
    input clk,          // Clock signal
    input  [3:0] A,
    input  [3:0] B,     
    output [7:0] TwoAB  
);
    reg [7:0] product;
    integer i;
    wire [7:0] TwoAB;  // Explicitly declare output as wire

    always @(posedge clk) begin
        product = 8'b0;
        for (i = 0; i < 4; i = i + 1) begin
            if (B[i] == 1'b1)
                product = product + (A << 1) << i;  
        end
    end

    assign TwoAB = product;
endmodule
