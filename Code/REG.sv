module REG (
    input wire clk,
    input wire [1:0] sel,
    input wire [31:0] write_data [0:15],
    input wire [31:0] alu_data1 [0:15],
    input wire [31:0] alu_data2 [0:15],
    input wire we,
    input wire walu,
    output reg [31:0] read_data [0:15],
    output wire [31:0] A1_out [0:15],
    output wire [31:0] A2_out [0:15]
);

//      if walu is on, loads alu_data1 into A3 and alu_data2 into A4.
//          Which are supposedly the results of
//                   the arithmetic operation. (@ negedge clk)
//          otherwise,
//                      if we is on, loads write_data into A[sel] (@ negedge clk)
//                      if we is off, loads A[sel] into read_data (@ posedge clk)

    // Define four 32-bit registers
    reg [31:0] A1 [0:15];
    reg [31:0] A2 [0:15];
    reg [31:0] A3 [0:15];
    reg [31:0] A4 [0:15];

    assign A1_out = A1;
    assign A2_out = A2;

    always @(negedge clk) begin
        //$display("this is REG talking, walu: %b we: %b", walu, we);
        if (walu) begin
            A3 <= alu_data1;
            A4 <= alu_data2;
            //$display("  %h %h", alu_data1[1], alu_data2[1]);
        end else if (we) begin
            //$display("hell yeah baby, sel: %b %b %h", {walu, we}, sel, write_data[0]);
            case (sel)
                2'b00: A1 <= write_data;
                2'b01: A2 <= write_data;
                2'b10: A3 <= write_data;
                2'b11: A4 <= write_data;
            endcase
        end
    end
    always @(posedge clk) begin
        if(!we && !walu) begin
            case (sel)
                2'b00: read_data <= A1;
                2'b01: read_data <= A2;
                2'b10: read_data <= A3;
                2'b11: read_data <= A4;
            endcase
            //$display("heavens yeah baby, sel: %b %h", sel, read_data[0]);
        end
    end

endmodule
