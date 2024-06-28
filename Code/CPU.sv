module CPU(
    input clk,
    input [2:0] op,
    input [8:0] ram_addr,
    input [3:0] ram_cnt,
    input [1:0] reg_sel,
    input [31:0] ram_input [0:15],
    output [31:0] ram_output [0:15]
);

wire [31:0] A1_out [0:15];
wire [31:0] A2_out [0:15];
wire [31:0] alu_out1 [0:15];
wire [31:0] alu_out2 [0:15];
reg alu_op, reg_we, reg_walu, ram_we;
reg [31:0] reg_write_data [0:15];
reg [31:0] reg_read_data [0:15];
reg [31:0] ram_data_in [0:15];
reg [31:0] ram_data_out [0:15];

assign ram_data_in = (op[2] ? ram_input : reg_read_data);
assign ram_output = ram_data_out;
assign reg_write_data = ram_data_out; // added in testbenching :)

ALU kalu(A1_out, A2_out, alu_op, alu_out1, alu_out2);
REG kreg(clk, reg_sel, reg_write_data, alu_out1, alu_out2,
            reg_we, reg_walu, reg_read_data, A1_out, A2_out);
RAM kram(clk, ram_we, ram_addr, ram_cnt, ram_data_in, ram_data_out);

// piece of work to put everything together.
//  this CPU supports the 6 following commands
//         1. Loads RAM[ram_addr] into REG[reg_sel]
//         2. Loads REG[reg_sel] into RAM[ram_addr]
//         3. stores (A1 + A2) in {A4, A3}
//         4. stores (A1 * A2) in {A4, A3}
//         5. Loads RAM[ram_addr] into ram_output
//         6. Loads ram_input into RAM[ram_addr]    (assigment from outside the cpu)

localparam [3:0] RamToReg = 3'b000,
                 RegToRam = 3'b001,
                 addi     = 3'b010,
                 mult     = 3'b011,
                 RamToOut = 3'b100,
                 OutToRam = 3'b101;

always @(op) begin
    reg_we = 1'b0;
    ram_we = 1'b0;
    reg_walu = 1'b0;
    alu_op = 1'b0;
    //$display($time, "nigga %b", op);
    case(op) 
        RamToReg: reg_we = 1'b1;
        RegToRam: ram_we = 1'b1;
        addi: begin
            alu_op = 1'b0;
            reg_walu = 1'b1;
        end
        mult: begin
            alu_op = 1'b1;
            reg_walu = 1'b1;
        end
        OutToRam: ram_we = 1'b1;
    endcase
end

//always @(posedge clk) begin
    //$monitor(" on yo ass %h %h", kreg.write_data[0], ram_data_out[0]);
    //$display("shit shit %h %h %h %b %b", reg_write_data[0], ram_data_out[0], 
    //                          ram_data_in[0], ram_we, op);
//end

endmodule