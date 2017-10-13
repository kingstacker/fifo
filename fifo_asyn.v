//************************************************
//  Filename      : fifo_asyn.v                             
//  Author        : kingstacker                  
//  Company       : School                       
//  Email         : kingstacker_work@163.com     
//  Device        : Altera cyclone4 ep4ce6f17c8  
//  Description   : asynchronize fifo;8*8;                             
//************************************************
module  fifo_asyn #(parameter WIDTH = 8,DEPTH = 8)(
    //input;
    input    wire    wrclk,
    input    wire    rdclk,
    input    wire    rst_n,
    input    wire    wr,                 //wr request;
    input    wire    rd,                 //rd request;
    input    wire    [WIDTH-1:0]  data,  //data in;
    //output;
    output   wire    [WIDTH-1:0]  q,     //data out;
    output   wire    full,
    output   wire    empty
);
function integer clogb2 (input integer depth);
begin
    for (clogb2=0; depth>1; clogb2=clogb2+1) //depth>1 when you choose depth 2^n;otherwise change it to depth>0;for example depth is 7;
        depth = depth >>1;                          
end
endfunction               
(* ramstyle = "M9K" *) reg [WIDTH-1:0]      memory [0:DEPTH-1];
reg  [clogb2(DEPTH):0] wr_poi;    //wr pointer;
reg  [clogb2(DEPTH):0] rd_poi;    //rd pointer;
wire [clogb2(DEPTH):0] wr_poi_gray;
reg  [clogb2(DEPTH):0] wr_poi_gray1;
reg  [clogb2(DEPTH):0] wr_poi_gray2;
wire [clogb2(DEPTH):0] rd_poi_gray;
reg  [clogb2(DEPTH):0] rd_poi_gray1;
reg  [clogb2(DEPTH):0] rd_poi_gray2;
wire wr_flag;                   //real wr request;
wire rd_flag;                   //real rd request;
reg [WIDTH-1:0] q_r;            //reg q;
assign q = q_r;
assign wr_poi_gray = wr_poi ^ (wr_poi>>1); //produce wr pointer gray code;
assign rd_poi_gray = rd_poi ^ (rd_poi>>1); //produce rd pointer gray code;
assign full =  (wr_poi_gray2 == {~rd_poi_gray2[clogb2(DEPTH):clogb2(DEPTH)-1],rd_poi_gray2[clogb2(DEPTH)-2:0]});
assign empty = (wr_poi_gray2 == rd_poi_gray2);
assign wr_flag = ((wr == 1'b1) && (full == 1'b0));          //wr enable;
assign rd_flag = ((rd == 1'b1) && (empty == 1'b0)); 
always @(posedge wrclk or negedge rst_n) begin
    if (~rst_n) begin
        wr_poi <= 0;
    end //if
    else begin
        wr_poi <= wr_flag ? wr_poi + 1'b1 : wr_poi;
        memory[wr_poi[2:0]] <= wr_flag ? data : memory[wr_poi[2:0]];
    end //else
end //always
always @(posedge rdclk or negedge rst_n) begin
    if (~rst_n) begin
        rd_poi <= 0;
        q_r <= 0;
    end //if
    else begin
        rd_poi <= rd_flag ? rd_poi + 1'b1 : rd_poi;
        q_r <= rd_flag ? memory[rd_poi[2:0]] : q_r;
    end //else
end //always
always @(posedge rdclk or negedge rst_n) begin //syn wr poi gray code to rd clock domain;
    if (~rst_n) begin
        wr_poi_gray1 <= 0;
        wr_poi_gray2 <= 0;
    end //if
    else begin
        wr_poi_gray1 <= wr_poi_gray;    
        wr_poi_gray2 <= wr_poi_gray1;    
    end //else
end //always
always @(posedge wrclk or negedge rst_n) begin  //syn rd poi gray code to wr clock domain;
    if (~rst_n) begin
        rd_poi_gray1 <= 0;
        rd_poi_gray2 <= 0;
    end //if
    else begin
        rd_poi_gray1 <= rd_poi_gray;
        rd_poi_gray2 <= rd_poi_gray1;
    end //else
end //always

endmodule