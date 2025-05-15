`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.04.2025 02:33:43
// Design Name: 
// Module Name: AB_three
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


module AB_three();




    reg [3:0] A;
    reg [3:0] B;
    wire [14:0] A_3;
    wire [14:0] B_3;
    wire [14:0] Three_A2B;
    wire [14:0] Three_AB2;
    wire [14:0] Final_plus;
    wire [14:0] Final_minus;

    Aplus_minusB_three uut (
        .A(A), .B(B),
        .A_3(A_3), .B_3(B_3),
        .Three_A2B(Three_A2B), .Three_AB2(Three_AB2),
        .Final_plus(Final_plus), .Final_minus(Final_minus)
    );

    initial begin
        // Initialize inputs
        A = 4'd0;
        B = 4'd0;
        #10;  // Small initial delay to ensure initialization

        // Test case 1: A=2, B=3
        $display("Starting Test 1 at time %0t", $time);
        A = 4'd2; B = 4'd3; #20;
        $display("Test 1: A=%d B=%d at time %0t", A, B, $time);
        $display("A^3=%d 3A^2B=%d 3AB^2=%d B^3=%d", A_3, Three_A2B, Three_AB2, B_3);
        $display("(A+B)^3=%d (A-B)^3=%d\n", Final_plus, Final_minus);

        // Test case 2: A=4, B=5
        $display("Starting Test 2 at time %0t", $time);
        A = 4'd4; B = 4'd5; #20;
        $display("Test 2: A=%d B=%d at time %0t", A, B, $time);
        $display("A^3=%d 3A^2B=%d 3AB^2=%d B^3=%d", A_3, Three_A2B, Three_AB2, B_3);
        $display("(A+B)^3=%d (A-B)^3=%d\n", Final_plus, Final_minus);

        // Test case 3: A=0, B=7
        $display("Starting Test 3 at time %0t", $time);
        A = 4'd0; B = 4'd7; #20;
        $display("Test 3: A=%d B=%d at time %0t", A, B, $time);
        $display("A^3=%d 3A^2B=%d 3AB^2=%d B^3=%d", A_3, Three_A2B, Three_AB2, B_3);
        $display("(A+B)^3=%d (A-B)^3=%d\n", Final_plus, Final_minus);

        $display("Simulation completed at time %0t", $time);
        $finish;
    end

    // Monitor for debugging
    initial begin
        $monitor("Time=%0t A=%d B=%d A_3=%d B_3=%d Three_A2B=%d Three_AB2=%d Final_plus=%d Final_minus=%d",
                 $time, A, B, A_3, B_3, Three_A2B, Three_AB2, Final_plus, Final_minus);
    end

endmodule