module TB_REGRAM;

reg clk;
reg [2:0] op;
reg [8:0] ram_addr;
reg [3:0] ram_cnt;
reg [1:0] reg_sel;
reg [31:0] ram_input [0:15];
wire [31:0] ram_output [0:15];

integer i;

CPU keshi(clk, op, ram_addr, ram_cnt, reg_sel, ram_input, ram_output);

localparam [3:0] RamToReg = 3'b000,
                 RegToRam = 3'b001,
                 addi     = 3'b010,
                 mult     = 3'b011,
                 RamToOut = 3'b100,
                 OutToRam = 3'b101;

task write_random (input [8:0] a);
    begin
        #1 op = OutToRam;
        ram_addr = a;
        for(i = 0; i < 16; i = i + 1) begin
            ram_input[i] = $random;
        end
        $display(" wrote in %d  : %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h", ram_addr, ram_input[0], ram_input[1], ram_input[2], ram_input[3], ram_input[4], ram_input[5], ram_input[6], ram_input[7], ram_input[8], ram_input[9], ram_input[10], ram_input[11], ram_input[12], ram_input[13], ram_input[14], ram_input[15]);
        #5 clk = 1;
        #5 clk = 0;
    end
endtask
task read (input [8:0] a);
    begin
        #1 op = RamToOut;
        ram_addr = a;
        #5 clk = 1;
        #5 clk = 0;
        $display(" read from %d : %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h", ram_addr, ram_output[0], ram_output[1], ram_output[2], ram_output[3], ram_output[4], ram_output[5], ram_output[6], ram_output[7], ram_output[8], ram_output[9], ram_output[10], ram_output[11], ram_output[12], ram_output[13], ram_output[14], ram_output[15]);
    end
endtask

task ram_to_reg (input [8:0] a, [1:0] b);
    begin
        #1 op = RamToReg;
        ram_addr = a;
        reg_sel = b;
        $display(" [%b] <- (%d)", b, a);
        #5 clk = 1;
        #5 clk = 0;
    end
endtask

task reg_to_ram (input [8:0] a, [1:0] b);
    begin
        #1 op = RegToRam;
        ram_addr = a;
        reg_sel = b;
        $display(" [%b] -> (%d)", b, a);
        #5 clk = 1;
        #5 clk = 0;
    end
endtask

initial begin
    clk = 0;
    ram_cnt = 15;

    #5

    write_random(10);
    read(10);
    ram_to_reg(10, 2);
    reg_to_ram(20, 2);
    read(20);

    write_random(5);
    ram_to_reg(5, 2);
    reg_to_ram(6, 2);
    read(6);

    write_random(140);
    ram_to_reg(140, 3);
    write_random(222);
    ram_to_reg(222, 0);
    
    reg_to_ram(222, 3);
    reg_to_ram(140, 0);
    read(140);
    read(222);
    read(222);

end

//always @(posedge clk) $display($time, " ++++++++++++++++++++++++++++++");
//always @(negedge clk) $display($time, " ------------------------------");

endmodule
