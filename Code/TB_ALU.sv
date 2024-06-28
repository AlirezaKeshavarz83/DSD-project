module TB_ALU;

reg signed [31:0] A [0:15];
reg signed [31:0] B [0:15];
reg op;
wire [31:0] C [0:15];
wire [31:0] D [0:15];

ALU keshi(A, B, op, C, D);

integer i;

initial begin
    for(i = 0; i < 16; i = i + 1) begin
        A[i] = $random;
        B[i] = $random;
    end
    op = 1'b0;
    #10
    for(i = 0; i < 16; i = i + 1) begin
        $display("%d + %d = %d", A[i], B[i], $signed({D[i], C[i]}));
    end
    op = 1'b1;
    #10
    for(i = 0; i < 16; i = i + 1) begin
        $display("%d * %d = %d", A[i], B[i], $signed({D[i], C[i]}));
    end
end

endmodule
