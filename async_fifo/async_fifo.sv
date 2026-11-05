module async_fifo #(
    parameter DEPTH, WIDTH // DEPTH must be a power of 2, or pointer wrap around fails
)(
    input logic                         clk_rd,
    input logic                         rd_en,
    output logic [WIDTH-1:0]            dout,

    input logic                         clk_wr,
    input logic                         wr_en,
    input logic [WIDTH-1:0]             din,

    output logic                        full,
    output logic                        empty,

    input logic                         rst // reset pointers only, memory does not matter!
);

    logic [$clog2(DEPTH):0] bin_rd_ptr, bin_wr_ptr, sync_gray_rd_ptr, sync_gray_wr_ptr, gray_rd_ptr, gray_rd_ptr;

    logic mem_write, mem_read;

    dual_mem #(.DEPTH(DEPTH), .WIDTH(WIDTH)) mem_inst (.clk_wr(clk_wr), .din(din), .wr_addr(bin_wr_ptr[$clog2(DEPTH)-1:0]), .wr_en(mem_write), .clk_rd(clk_rd), .rd_addr(bin_rd_ptr[$clog2(DEPTH)-1:0]), .rd_en(mem_read), .dout(dout));
    wr_handler #(.ADDR_WIDTH($clog2(DEPTH))) wr_inst (.clk_wr(clk_wr), .wr_en(wr_en), .sync_gray_rd_ptr(sync_gray_rd_ptr), .gray_wr_ptr(gray_wr_ptr), .bin_wr_ptr(bin_wr_ptr), .full(full), .mem_write(mem_write), .rst(rst));
    rd_handler #(.ADDR_WIDTH($clog2(DEPTH))) rd_inst (.clk_rd(clk_rd), .rd_en(rd_en), .sync_gray_wr_ptr(sync_gray_wr_ptr), .gray_rd_ptr(gray_rd_ptr), .bin_rd_ptr(bin_rd_ptr), .empty(empty), .mem_read(mem_read), .rst(rst));
    ff2 #(.WIDTH($clog2(DEPTH)+1)) sync_wr (.clk(clk_rd), .din(gray_wr_ptr), .dout(sync_gray_wr_ptr), .rst(rst));
    ff2 #(.WIDTH($clog2(DEPTH)+1)) sync_rd (.clk(clk_wr), .din(gray_rd_ptr), .dout(sync_gray_rd_ptr), .rst(rst));

endmodule