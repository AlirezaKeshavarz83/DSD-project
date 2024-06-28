module TB_RAM;

reg clk;
reg [2:0] op;
reg [8:0] ram_addr;
reg [3:0] ram_cnt;
reg [1:0] reg_sel;
reg [31:0] ram_input [0:15];
wire [31:0] ram_output [0:15];

CPU keshi(clk, op, ram_addr, ram_cnt, reg_sel, ram_input, ram_output);

integer i;

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

initial begin
    clk = 0;
    ram_cnt = 15;

    write_random(12);
    read(12);
    // testing simple writing and reading, expecting the two lines to be equal
    write_random(42);
    read(13);
    // writing in [42] and then reading from [13] to make sure the thing works
    // expecting the output to be the same but shifted by one to the left
    // also the last number should be xxxxxxxx
    read(42);  // reading from [42]
    read(10);  // reading from [10] 
    write_random(496);  // writing in [496:511] to check corner case
    read(496); // reading from [496:511] to check corner case
    read(500);
    // reading from [500:516] to check corner case
    // although it's an invalid input the extra 4 slots are gonna be high impedance
    #1 ram_cnt = 2;
    write_random(12);
    // writing in [12:14] to check the functionality of ram_cnt
    #1 ram_cnt = 15;
    read(12);
    // expecting only the first 3 numbers to change
end

endmodule