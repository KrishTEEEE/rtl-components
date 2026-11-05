module async_fifo #(
    parameter DEPTH, WIDTH
)(
    input logic                         clk_rd,
    input logic                         rd_en,
    output logic [WIDTH-1:0]            dout,

    input logic                         clk_wr,
    input logic                         wr_en,
    input logic [WIDTH-1:0]             din,

    input logic                         rst // reset pointers only, memory does not matter!
);


    dual_mem mem_inst #(.DEPTH(DEPTH), .WIDTH(WIDTH))(.clk_wr(clk_wr), .din(), .wr_addr(), .wr_en(), .clk_rd(clk_rd), .rd_addr(), .rd_en(), .dout());
    wr_handler wr_inst #(.ADDR_WIDTH($clog2(DEPTH)))(.clk_wr(clk_wr), .wr_en(), .sync_gray_rd_ptr(), .gray_wr_ptr(), .bin_wr_ptr(), .full(), .mem_write(), .rst(rst));
    rd_handler rd_inst #(.ADDR_WIDTH($clog2(DEPTH)))(.clk_rd(clk_rd), .rd_en(), .sync_gray_wr_ptr(), .gray_rd_ptr(), .bin_rd_ptr(), .empty(), .mem_read(), .rst(rst));
    ff2 sync_wr #(.WIDTH($clog2(DEPTH)+1))(.clk(), .din(), .dout(), .rst(rst));
    ff2 sync_rd #(.WIDTH($clog2(DEPTH)+1))(.clk(), .din(), .dout(), .rst(rst));

endmodule