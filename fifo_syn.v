//************************************************
//  Filename      : fifo_syn.v                             
//  Author        : kingstacker                  
//  Company       : School                       
//  Email         : kingstacker_work@163.com     
//  Device        : Altera cyclone4 ep4ce6f17c8  
//  Description   : synchronize fifo                             
//************************************************
module  fifo_syn #(parameter WIDTH = 8,DEPTH = 4)(
    //input;
    input    wire    clk,                //only one clock;
    input    wire    rst_n,
    input    wire    wr,                 //wr request;
    input    wire    rd,                 //rd request;
    input    wire    [WIDTH-1:0]  data,  //data in;
    //output;
    output   wire    [WIDTH-1:0]  q,     //data out;
    output   wire    almost_full,        
    output   wire    full,
    output   wire    almost_empty,
    output   wire    empty,
    output   wire    [(DEPTH>>1)-1:0] usedw 
);




endmodule