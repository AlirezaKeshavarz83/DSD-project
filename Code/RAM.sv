module RAM (
    input wire clk,
    input wire we,  // Write Enable
    input wire [8:0] addr,  // 9-bit address to access 512 depth (2^9 = 512)
    input wire [3:0] cnt,
    input wire [31:0] data_in [0:15],  // 16 words of 32-bit input data    ([15:0] -> [0:15] in testbenching :) )
    output reg [31:0] data_out [0:15]  // 16 words of 32-bit output data
);

//      if we is on, loads data_in[0:cnt] into mem[addr:addr+cnt]  (@ negedge clk)
//        otherwise, loads mem[addr:addr+cnt] into data_in[0:cnt]  (@ posedge clk)

    // Memory array: 512 x 32-bit
    reg [31:0] mem [0:511];

    integer i;

    always @(negedge clk) begin
        if (we) begin
            // Write cnt words at the specified address range
            for (i = 0; i < cnt + 1; i = i + 1) begin
                if(addr + i < 512) mem[addr + i] <= data_in[i];
            end
        end
    end
    always @(posedge clk) begin
        if (!we) begin
            // Read cnt words from the specified address range
            for (i = 0; i < cnt + 1; i = i + 1) begin
                if(addr + i < 512)  data_out[i] <= mem[addr + i];
                else data_out[i] <= 32'bz; // handling corner-cases
            end
        end
    end

endmodule


