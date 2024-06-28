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
۳۲ بیت پرارزش حاصل در `D` و ۳۲ بیت کم‌ارزش در `C` نوشته می‌شوند.
- RAM
- Register file
