`timescale 1ns / 1ps

module tb_top_level;

    // Inputs
    reg clk;
    reg [3:0] sw_A, sw_B;
    reg sw_plus_2, sw_minus_2, sw_plus_3, sw_minus_3;
    reg reset;

    // Outputs
    wire [6:0] seg;
    wire [3:0] an;

    // Instantiate the Unit Under Test (UUT)
    top_level uut (
        .clk(clk),
        .sw_A(sw_A),
        .sw_B(sw_B),
        .sw_plus_2(sw_plus_2),
        .sw_minus_2(sw_minus_2),
        .sw_plus_3(sw_plus_3),
        .sw_minus_3(sw_minus_3),
        .reset(reset),
        .seg(seg),
        .an(an)
    );

    // Clock generation (100 MHz, period = 10 ns)
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Toggle every 5 ns
    end

    // Test stimulus
    initial begin
        // Initialize inputs
        sw_A = 4'b0000;
        sw_B = 4'b0000;
        sw_plus_2 = 0;
        sw_minus_2 = 0;
        sw_plus_3 = 0;
        sw_minus_3 = 0;
        reset = 0;

        // Test Case 1: A = 3, B = 4
        $display("\nTest Case 1: A = 3, B = 4");
        sw_A = 4'b0011; // 3
        sw_B = 4'b0100; // 4
        sw_plus_2 = 1; // Select (A+B)^2
        #100; // Wait for combinational logic to settle
        $display("(A+B)^2: Expected 49, Got %d", uut.u1.Final_plus_2); // Changed uut1 to u1
        sw_minus_2 = 1; sw_plus_2 = 0; // Select (A-B)^2
        #100;
        $display("(A-B)^2: Expected 1, Got %d", uut.u1.Final_minus_2); // Changed uut1 to u1
        sw_plus_3 = 1; sw_minus_2 = 0; // Select (A+B)^3
        #100;
        $display("(A+B)^3: Expected 343, Got %d", uut.u2.Final_plus_3); // Changed uut2 to u2
        sw_minus_3 = 1; sw_plus_3 = 0; // Select (A-B)^3
        #100;
        $display("(A-B)^3: Expected -1 (unsigned 32767), Got %d", uut.u2.Final_minus_3); // Changed uut2 to u2

        // Test Case 2: A = 15, B = 15
        $display("\nTest Case 2: A = 15, B = 15");
        sw_A = 4'b1111; // 15
        sw_B = 4'b1111; // 15
        sw_plus_2 = 1; sw_minus_3 = 0; // Select (A+B)^2
        #100;
        $display("(A+B)^2: Expected 900, Got %d", uut.u1.Final_plus_2); // Changed uut1 to u1
        sw_minus_2 = 1; sw_plus_2 = 0; // Select (A-B)^2
        #100;
        $display("(A-B)^2: Expected 0, Got %d", uut.u1.Final_minus_2); // Changed uut1 to u1
        sw_plus_3 = 1; sw_minus_2 = 0; // Select (A+B)^3
        #100;
        $display("(A+B)^3: Expected 27000, Got %d", uut.u2.Final_plus_3); // Changed uut2 to u2
        sw_minus_3 = 1; sw_plus_3 = 0; // Select (A-B)^3
        #100;
        $display("(A-B)^3: Expected 0, Got %d", uut.u2.Final_minus_3); // Changed uut2 to u2

        // Test Case 3: Edge Case A = 0, B = 0
        $display("\nTest Case 3: Edge Case A = 0, B = 0");
        sw_A = 4'b0000;
        sw_B = 4'b0000;
        sw_plus_2 = 1; sw_minus_3 = 0; // Select (A+B)^2
        #100;
        $display("(A+B)^2: Expected 0, Got %d", uut.u1.Final_plus_2); // Changed uut1 to u1
        sw_minus_2 = 1; sw_plus_2 = 0; // Select (A-B)^2
        #100;
        $display("(A-B)^2: Expected 0, Got %d", uut.u1.Final_minus_2); // Changed uut1 to u1
        sw_plus_3 = 1; sw_minus_2 = 0; // Select (A+B)^3
        #100;
        $display("(A+B)^3: Expected 0, Got %d", uut.u2.Final_plus_3); // Changed uut2 to u2
        sw_minus_3 = 1; sw_plus_3 = 0; // Select (A-B)^3
        #100;
        $display("(A-B)^3: Expected 0, Got %d", uut.u2.Final_minus_3); // Changed uut2 to u2

        // Test Case 4: Edge Case A = 15, B = 15
        $display("\nTest Case 4: Edge Case A = 15, B = 15");
        sw_A = 4'b1111; // 15
        sw_B = 4'b1111; // 15
        sw_plus_2 = 1; sw_minus_3 = 0; // Select (A+B)^2
        #100;
        $display("(A+B)^2: Expected 900, Got %d", uut.u1.Final_plus_2); // Changed uut1 to u1
        sw_minus_2 = 1; sw_plus_2 = 0; // Select (A-B)^2
        #100;
        $display("(A-B)^2: Expected 0, Got %d", uut.u1.Final_minus_2); // Changed uut1 to u1
        sw_plus_3 = 1; sw_minus_2 = 0; // Select (A+B)^3
        #100;
        $display("(A+B)^3: Expected 27000, Got %d", uut.u2.Final_plus_3); // Changed uut2 to u2
        sw_minus_3 = 1; sw_plus_3 = 0; // Select (A-B)^3
        #100;
        $display("(A-B)^3: Expected 0, Got %d", uut.u2.Final_minus_3); // Changed uut2 to u2

        // Finish simulation
        $display("\nSimulation complete.");
        $finish;
    end

endmodule