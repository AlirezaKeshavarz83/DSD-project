module TB;

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

task addition;
    begin
        #1 op = addi;
        $display("[32] = [0] + [1]");
        #5 clk = 1;
        #5 clk = 0;
    end
endtask

task multiplication;
    begin
        #1 op = mult;
        $display("[32] = [0] * [1]");
        #5 clk = 1;
        #5 clk = 0;
    end
endtask

initial begin
    clk = 0;
    ram_cnt = 15;

    #5

    write_random(10);
    write_random(56);
    ram_to_reg(10, 0);
    ram_to_reg(56, 1);
    addition();
    reg_to_ram(100, 2);
    reg_to_ram(120, 3);
    read(100);
    read(120);

    write_random(42);
    write_random(452);
    ram_to_reg(42, 0);
    ram_to_reg(452, 1);
    multiplication();
    reg_to_ram(215, 2);
    reg_to_ram(400, 3);
    read(215);
    read(400);
    
    write_random(354);
    write_random(461);
    ram_to_reg(354, 0);
    ram_to_reg(461, 1);
    addition();
    reg_to_ram(387, 2);
    reg_to_ram(491, 3);
    read(387);
    read(491);

    write_random(67);
    write_random(380);
    ram_to_reg(67, 0);
    ram_to_reg(380, 1);
    multiplication();
    reg_to_ram(155, 2);
    reg_to_ram(408, 3);
    read(155);
    read(408);

end

//always @(posedge clk) $display($time, " ++++++++++++++++++++++++++++++");
//always @(negedge clk) $display($time, " ------------------------------");

endmodule