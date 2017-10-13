//************************************************
//  Filename      : fifo_syn.v                             
//  Author        : kingstacker                  
//  Company       : School                       
//  Email         : kingstacker_work@163.com     
//  Device        : Altera cyclone4 ep4ce6f17c8  
//  Description   : synchronize fifo ;8*8 ;depth shuold be 2^n,otherwise change the clogb2 funtion;                           
//************************************************
module  fifo_syn #(parameter WIDTH = 8,DEPTH = 8)( 
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
    output   wire    [clogb2(DEPTH)-1:0] usedw //data number in fifo;
);
function integer clogb2 (input integer depth);
begin
    for (clogb2=0; depth>1; clogb2=clogb2+1) //depth>1 when you choose depth 2^n;otherwise change it to depth>0;for example depth is 7;
        depth = depth >>1;                       	
end
endfunction               
(* ramstyle = "M9K" *) reg [WIDTH-1:0]      memory [0:DEPTH-1];
reg [clogb2(DEPTH):0] wr_poi;    //wr pointer;
reg [clogb2(DEPTH):0] rd_poi;    //rd pointer;
reg [WIDTH-1:0] q_r;            //reg q;
reg [clogb2(DEPTH)-1:0] usedw_r;   //reg usedw_r;
wire wr_flag;                   //real wr request;
wire rd_flag;                   //real rd request;
assign q = q_r;
assign usedw = usedw_r;
assign full = (wr_poi[2:0]== rd_poi[2:0]) && (wr_poi[3] ^ rd_poi[3] == 1);  //highest bit is not same but rests bit is same;
assign empty = (wr_poi[2:0]== rd_poi[2:0]) && (wr_poi[3] ^ rd_poi[3] == 0); //every bit is same;
assign wr_flag = ((wr == 1'b1) && (full == 1'b0));          //wr enable;
assign rd_flag = ((rd == 1'b1) && (empty == 1'b0));         //rd enable;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wr_poi <= 0;
    end //if
    else begin
        wr_poi <= wr_flag ? wr_poi + 1'b1 : wr_poi;
        memory[wr_poi[2:0]] <= wr_flag ? data : memory[wr_poi[2:0]];
    end //else
end //always
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        rd_poi <= 0;
        q_r <= 0;
    end //if
    else begin
        rd_poi <= rd_flag ? rd_poi + 1'b1 : rd_poi;
        q_r <= rd_flag ? memory[rd_poi[2:0]] : q_r;
    end //else
end //always
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        usedw_r <= 0;
    end //if
    else begin
        case ({wr_flag,rd_flag})
               2'b00: begin
                   usedw_r <= usedw_r;
               end 
               2'b10: begin
                   if (usedw_r == DEPTH-1) begin  // full;
                       usedw_r <= usedw_r;
                   end
                   else begin
                       usedw_r <= usedw_r + 1'b1;
                   end
               end
               2'b01: begin
                   if (usedw_r == 0) begin     //empty;
                       usedw_r <= usedw_r;
                   end
                   else begin
                       usedw_r <= usedw_r - 1'b1;
                   end
               end
               2'b11: begin
                   usedw_r <= usedw_r;
               end                                             
               default:  usedw_r <= 0;
           endcase //case   
    end //else
end //always

endmodule