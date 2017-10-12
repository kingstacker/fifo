//************************************************
//  Filename      : fifo_syn_tb.v                             
//  Author        : kingstacker                  
//  Company       : School                       
//  Email         : kingstacker_work@163.com     
//  Device        : Altera cyclone4 ep4ce6f17c8  
//  Description   :                              
//************************************************
`timescale 1ns/1ns
module fifo_syn_tb #(parameter WIDTH = 8,DEPTH = 8)();
parameter CYCLE = 4;
//input;
reg clk;
reg rst_n;
reg wr;
reg rd;
reg [WIDTH-1:0] data;
//output;
wire [WIDTH-1:0] q;
wire full;
wire empty;
wire [(DEPTH>>1)-2:0] usedw;

//inst;
fifo_syn  fifo_syn_u1(
    .clk                (clk),
    .rst_n              (rst_n),
    .wr                 (wr),
    .rd                 (rd),
    .data               (data),
    .q                  (q),
    .full               (full),
    .empty              (empty),
    .usedw              (usedw)
);
//clk produce;
initial begin
    clk = 1'b0;
end
always #(CYCLE/2) clk = ~ clk;
//rst_n ;
initial begin
                  rst_n = 1'b0;
    #(CYCLE*4)    rst_n = 1'b1; 
end
//data;
initial begin
    wr = 0;rd = 0;data = 8'h00;
    #(CYCLE*5) data = 8'hab;
    #(CYCLE*2) wr = 1'b1;
    #(CYCLE*1) data = 8'h12;
    #(CYCLE*1) data = 8'h34;
    #(CYCLE*1) data = 8'h56;
    #(CYCLE*1) data = 8'h78;
    #(CYCLE*1) data = 8'hcd;
    #(CYCLE*1) data = 8'hcc;
    #(CYCLE*1) data = 8'hdd;
    #(CYCLE*1) data = 8'hee;
    #(CYCLE*1) wr = 1'b0;
    #(CYCLE*1) data = 8'h33;
    #(CYCLE*1) rd = 1'b1;
    #(CYCLE*1) data = 8'h44;
    #(CYCLE*1) wr = 1'b1;
    #(CYCLE*1) data = 8'h55;
    #(CYCLE*1) wr = 1'b0;
    #(CYCLE*1) rd = 1'b1;
end //initial

endmodule