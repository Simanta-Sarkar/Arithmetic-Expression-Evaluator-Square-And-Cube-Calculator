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