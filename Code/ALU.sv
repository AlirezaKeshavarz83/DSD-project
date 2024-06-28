module ALU (
    input wire signed [31:0] A [0:15], // 16 words of 32-bit inputs
    input wire signed [31:0] B [0:15], // 16 words of 32-bit inputs
    input wire op,                     // Control signal: 0 - add, 1 - multiply
    output reg [31:0] C [0:15],        // 16 words of 32-bit outputs (lo)
    output reg [31:0] D [0:15]         // 16 words of 64-bit outputs (hi)
);

// {D[i], C[i]} = (op ? A[i] * B[i] : A[i] + B[i])

    reg [63:0] add_result [0:15];
    reg [63:0] mult_result [0:15];

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin
            assign add_result[i] = A[i] + B[i];
            assign mult_result[i] = A[i] * B[i];
            assign C[i] = (op ? mult_result[i][31:0] : add_result[i][31:0]);
            assign D[i] = (op ? mult_result[i][63:32] : add_result[i][63:32]);
        end
    endgenerate

endmodule


