# fifo
    DEVICE:ALTERA EP4CEF17C8
    SOFTWARE:Quartus prime 16.0
    synchronized fifo &amp; asynchronized fifo
# fifo_syn:
    8*8 synchronized fifo;you can change by yourself;
    Please let the depth be 2^n,otherwise change the clog2 function;
    If you device is not ep4cef17c8,please check your device have M9K resource.
    Otherwise revise :
    (* ramstyle = "M9K" *) reg [WIDTH-1:0]      memory [0:DEPTH-1];
    to right memory;
    Or just use dff resource:
    reg [WIDTH-1:0]      memory [0:DEPTH-1];
# fifo_asyn:
    8*8 asynchronized fifo;you can change by yourself;
    Please must let the depth be 2^n,because gray code used by it to cross domian;
## I hope you will enjoy it,thanks!If you have any questions please contact me!