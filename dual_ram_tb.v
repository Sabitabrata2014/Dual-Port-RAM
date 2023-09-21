`timescale 1ns / 1ps

module dual_ram_tb;

parameter RAM_WIDTH = 8;
parameter RAM_DEPTH = 16;
parameter ADDR_SIZE = 4;
parameter CYCLE = 10;

reg clk,read,write,reset;
reg [RAM_WIDTH-1:0] data_in;
reg [ADDR_SIZE-1:0] rd_addr, wr_addr;
wire [RAM_WIDTH-1:0] data_out;

integer i;

dual_ram DUT(clk,read,write,reset,rd_addr,wr_addr,data_in,data_out);

always
begin
#(CYCLE/2) clk = 1'b0;
#(CYCLE/2) clk = 1'b1;
end

task reset_t;
begin
@(negedge clk);
reset = 1'b1;
@(negedge clk);
reset = 1'b0;
end
endtask

task write_t(input [7:0]a,input [3:0]b, input w,r);
begin
@(negedge clk);
write = w;
read = r;
wr_addr = b;
data_in = a; 
end
endtask

task read_t(input [3:0]a, input w,r);
begin
@(negedge clk);
write = w;
read = r;
rd_addr = a;
end
endtask

initial
begin

reset_t;

repeat(10)
write_t({$random}%256,{$random}%16,1'b1,1'b0);

repeat(10)
read_t({$random}%16,1'b0,1'b1);

#100;
end

endmodule
