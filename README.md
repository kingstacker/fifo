# fifo
DEVICE:ALTERA EP4CEF17C8
SOFTWARE:Quartus prime 16.0
synchronized fifo &amp; asynchronized fifo
##fifo_syn:
Please let the depth be 2^n,otherwise change the clog2 function;
If you device is not ep4cef17c8,please check your device have M9K resource.
Otherwise revise :
(* ramstyle = "M9K" *) reg [WIDTH-1:0]      memory [0:DEPTH-1];
to right memory;
Or just use dff resource:
reg [WIDTH-1:0]      memory [0:DEPTH-1];