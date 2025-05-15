`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.04.2025 19:04:16
// Design Name: 
// Module Name: tb_A_plus_B_and_A_minus_B
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


module tb_A_plus_B_and_A_minus_B;
    

    // Inputs
    reg [3:0] A;
    reg [3:0] B;
    
    // Outputs
    wire [7:0] TwoAB;
    wire [7:0] A_2;
    wire [7:0] B_2;
    wire [9:0] Final_plus;
    wire [9:0] Final_minus;
    
    // Instantiate the Unit Under Test (UUT)
    A_plus_B_and_A_minus_B uut (
        .A(A),
        .B(B),
        .TwoAB(TwoAB),
        .A_2(A_2),
        .B_2(B_2),
        .Final_plus(Final_plus),
        .Final_minus(Final_minus)
    );
    
    // Test procedure
    initial begin
        // Initialize Inputs
        A = 0;
        B = 0;
        
        // Wait 100 ns for global reset
        #100;
        
        // Test case 1: A=2, B=3
        A = 4'd2;
        B = 4'd3;
        #20;
        $display("Test 1: A=%d, B=%d", A, B);
        $display("A^2 = %d, B^2 = %d, 2AB = %d", A_2, B_2, TwoAB);
        $display("Final_plus = %d, Final_minus = %d", Final_plus, Final_minus);
        
        // Test case 2: A=5, B=4
        A = 4'd5;
        B = 4'd4;
        #20;
        $display("\nTest 2: A=%d, B=%d", A, B);
        $display("A^2 = %d, B^2 = %d, 2AB = %d", A_2, B_2, TwoAB);
        $display("Final_plus = %d, Final_minus = %d", Final_plus, Final_minus);
        
        // Test case 3: A=0, B=7
        A = 4'd0;
        B = 4'd7;
        #20;
        $display("\nTest 3: A=%d, B=%d", A, B);
        $display("A^2 = %d, B^2 = %d, 2AB = %d", A_2, B_2, TwoAB);
        $display("Final_plus = %d, Final_minus = %d", Final_plus, Final_minus);
        
        // Test case 4: A=15, B=15 (max values)
        A = 4'd15;
        B = 4'd15;
        #20;
        $display("\nTest 4: A=%d, B=%d", A, B);
        $display("A^2 = %d, B^2 = %d, 2AB = %d", A_2, B_2, TwoAB);
        $display("Final_plus = %d, Final_minus = %d", Final_plus, Final_minus);
        
        // Test case 5: A=1, B=1 (min non-zero values)
        A = 4'd1;
        B = 4'd1;
        #20;
        $display("\nTest 5: A=%d, B=%d", A, B);
        $display("A^2 = %d, B^2 = %d, 2AB = %d", A_2, B_2, TwoAB);
        $display("Final_plus = %d, Final_minus = %d", Final_plus, Final_minus);
        
        #20;
        $finish;
    end
    
    // Monitor changes
    initial begin
        $monitor("Time=%0t A=%d B=%d A_2=%d B_2=%d TwoAB=%d Final_plus=%d Final_minus=%d",
                 $time, A, B, A_2, B_2, TwoAB, Final_plus, Final_minus);
    end

endmodule