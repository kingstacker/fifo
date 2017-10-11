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
    output   wire    full,               //fifo is full;
    output   wire    empty,              //fifo is empty;
    output   wire    [(DEPTH>>1)-1:0] usedw 
);
reg [WIDTH-1:0]      memory [0:DEPTH-1];
reg [(DEPTH>>1)-1:0] wr_poi;    //wr pointer;
reg [(DEPTH>>1)-1:0] rd_poi;    //rd pointer;
reg [WIDTH-1:0] q_r;            //reg q;
reg [(DEPTH>>1)-1:0] usedw_r;   //reg usedw; 
wire wr_flag;                   //real wr request;
wire rd_flag;                   //real rd request;
assign q = q_r;
assign full = (((wr_poi-rd_poi) == (DEPTH-1))) ? 1'b1 : 1'b0;
assign empty = ((wr_poi-rd_poi) == 0) ? 1'b1 : 1'b0;
assign wr_flag = ((wr == 1'b1) && (full == 1'b0));
assign rd_flag = ((rd == 1'b1) && (empty == 1'b0));
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wr_poi <= 0;
    end //if
    else begin
        if (wr_poi == (DEPTH-1)) begin
        	wr_poi <= 0;
        end    
        else begin
        	wr_poi <= wr_flag ? wr_poi + 1'b1 : wr_poi;
        	memory[wr_poi] <= wr_flag ? data : memory[wr_poi];
        end
    end //else
end //always
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        rd_poi <= 0;
        q_r <= 0;
    end //if
    else begin
        if (rd_poi == (DEPTH-1)) begin
        	rd_poi <= 0;
        end
        else begin
        	rd_poi <= rd_flag ? rd_poi + 1'b1 : rd_poi;
        	q_r <= rd_flag ? memory[rd_poi] : q_r;
        end
    end //else
end //always
//product usedw;
assign usedw = usedw_r;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        usedw_r <= 0;
    end //if
    else begin
        if (wr_flag) begin
        	usedw_r <= usedw_r + 1'b1;
        end   
        else begin
        	if (rd_flag) begin
        		usedw_r <= usedw_r - 1'b1;
        	end
        	else begin
        		usedw_r <= usedw_r;
        	end
        end
    end //else
end //always

endmodule