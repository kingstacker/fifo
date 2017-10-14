//************************************************
//  Filename      : fifo_asyn_tb.v                             
//  Author        : kingstacker                  
//  Company       : School                       
//  Email         : kingstacker_work@163.com     
//  Device        : Altera cyclone4 ep4ce6f17c8  
//  Description   :                              
//************************************************
`timescale 1ns/1ns
module fifo_asyn_tb ();
parameter CYCLE1 = 4;
parameter CYCLE2 = 8;
//input;
reg wrclk;
reg rdclk;
reg rst_n;
reg wr;
reg rd;
reg [7:0] data;
//output;
wire [7:0] q;
wire full;
wire empty;
//inst;
fifo_asyn  fifo_asyn_u1(
    .wrclk                (wrclk),
    .rdclk                (rdclk),
    .rst_n                (rst_n),
    .wr                   (wr),
    .rd                   (rd),
    .data                 (data),
    .q                    (q),
    .full                 (full),
    .empty                (empty)
);  
//wrclk produce;
initial begin
    wrclk = 1'b0;
end
always #(CYCLE1/2) wrclk = ~ wrclk;
//rdclk produce;
initial begin
    rdclk = 1'b0;
end
always #(CYCLE2/2) rdclk = ~ rdclk;
//rst_n ;
initial begin
            rst_n = 1'b0;
    #(1)    rst_n = 1'b1; 
end
initial begin
    wr = 0; rd = 0; data = 8'h00;
    #(CYCLE1*1) wr= 1'b1;data = 8'h11;
    #(CYCLE1*1) data = 8'h22;
    #(CYCLE1*1) data = 8'h33;
    #(CYCLE1*1) data = 8'h44;
    #(CYCLE1*1) data = 8'h55;
    #(CYCLE1*1) data = 8'h66;
    #(CYCLE1*1) data = 8'h77;
    #(CYCLE1*1) data = 8'h88;
    #(CYCLE1*1) data = 8'h99; //no store data;
    #(CYCLE1*2) wr= 0;rd = 1;
    #(CYCLE1*20)      rd =0;
    #(CYCLE1*1) wr= 1'b1;data = 8'h11;
    #(CYCLE1*1) data = 8'h22;
    #(CYCLE1*1) data = 8'h33;
    #(CYCLE1*1) data = 8'h44;
    #(CYCLE1*1) rd = 1;data = 8'h55;
    #(CYCLE1*1) data = 8'h66;
    #(CYCLE1*1) data = 8'h77;
    #(CYCLE1*1) data = 8'h88;
    #(CYCLE1*1) data = 8'h99;
    #(CYCLE1*1) data = 8'haa;
    #(CYCLE1*1) data = 8'hbb;
    #(CYCLE1*1) data = 8'hcc;
    #(CYCLE1*1) data = 8'hdd;
    #(CYCLE1*1) data = 8'hee;
    #(CYCLE1*1) wr= 0;rd = 0;
    #(CYCLE1*1)  rd = 1;
    #(CYCLE1*16) rd = 0;
end //initial

endmodule