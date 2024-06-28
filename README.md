![image](https://github.com/AlirezaKeshavarz83/DSD-project/assets/47504151/4dd41bb7-b4e6-4da4-aea1-a18c43a6e5b8)


# Vector Processor

Our Project is a Vector Processor that is capable of vector addition and multiplication operations.

## Tools
- SystemVerilog
- ModelSim


## Implementation Details

### Components
- Vector ALU
```verilog
module ALU (
    input wire signed [31:0] A [0:15],
    input wire signed [31:0] B [0:15],
    input wire op,
    output reg [31:0] C [0:15],
    output reg [31:0] D [0:15]
);

```
طراحی واحد محاسباتی آرایه‌ای به صورت بالاست.
دو آرایه `A` و `B` ورودی‌ها هستند. و در صورتی که `op` فعال باشد عملیات ضرب و در غیر این صورت عملیات جمع انجام می‌شود.
32 بیت پرارزش حاصل در `D` و 32 بیت کم‌ارزش در `C` نوشته می‌شوند.
- RAM
```verilog
module RAM (
    input wire clk,
    input wire we,
    input wire [8:0] addr,
    input wire [3:0] cnt,
    input wire [31:0] data_in [0:15],
    output reg [31:0] data_out [0:15]
);
```
در اینجا یک حافظه با عمق 512 و عرض 32 بیت داریم. که امکان بارگذاری/ذخیره‌سازی ۱۶ خانه‌ی پشت سر هم از حافظه را دارد.
در حقیقت در (cnt + 1) خانه بارگذاری/ذخیره‌سازی می‌کند.
- Register file
```verilog
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
```
این رجیستر فایل با توجه به نیاز‌های پردازنده طراحی شده است. دو نوع ورودی/خروجی داریم. \
در ورودی/خروجی اول، دیتای `write_data` در یکی از 4 رجیستر نوشته می‌شود و دیتای رجیستر‌ها در `read_data` نوشته می‌شود. که این دو حالت توسط `we` معین می‌شوند. \
در ورودی/خروجی دوم. دیتای دو رجیستر `A1` و `A2` همواره در `A1_out` و `A2_out` نوشته می‌شود. و اگر `walu` فعال باشد. خروجی‌های `ALU` که `alu_out1` و `alu_out2` هستند، در `A3` و `A4` نوشته می‌شوند.
همچنین اگر `walu` فعال باشد ورودی/خروجی های نوع اول غیرفعال می‌شوند.
- CPU
```verilog
module CPU(
    input clk,
    input [2:0] op,
    input [8:0] ram_addr,
    input [3:0] ram_cnt,
    input [1:0] reg_sel,
    input [31:0] ram_input [0:15],
    output [31:0] ram_output [0:15]
);
```
Inside of this module we use an instance of each of the previous modules, and wire them so we have a working CPU.\
This CPU supports the 6 following commands:

         opcode 0 : Loads RAM[ram_addr] into REG[reg_sel]
         opcode 1 : Loads REG[reg_sel] into RAM[ram_addr]
         opcode 2 : Stores (A1 + A2) in {A4, A3}
         opcode 3 : Stores (A1 * A2) in {A4, A3}
         opcode 4 : Loads RAM[ram_addr] into ram_output
         opcode 5 : Loads ram_input into RAM[ram_addr]

Each operation is done in a single cycle of the clock. (i.e. one posedge followed by a negedge)

## Authors
- [Alireza Keshavarz](https://github.com/AlirezaKeshavarz83)
  + Student Number: 401110578
