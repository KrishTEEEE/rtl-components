// my implementation of a synchronous FIFO
// A FIFO is a buffer that stores word and returns them in the order of words being written
// Both write and read running on the same clock
// It is implemented using a memory array with two pointers and full, empty flags

module fifo #(
    parameter DEPTH = 8, WIDTH = 4
)(
    input logic                 clk1,
    input logic                 rst,
    input logic                 rd_en,
    input logic                 wr_en,
    input logic [WIDTH-1:0]     din,
    output logic [WIDTH-1:0]    dout,
    output logic                empty,
    output logic                full
);
    logic [WIDTH-1: 0] mem_array [DEPTH-1:0];

    logic [$clog2(DEPTH)-1:0]      wr_ptr;
    logic [$clog2(DEPTH)-1:0]      rd_ptr;

    always_ff@(posedge clk1)begin
        if(rst)begin
            wr_ptr <= 0;
            rd_ptr <= 0;
        end
        else begin
            if(rd_en && !empty) begin
                dout <= mem_array[rd_ptr];
                rd_ptr <= rd_ptr + 1'b1;
            end
            if(wr_en && !full) begin
                mem_array[wr_ptr] <= din;
                wr_ptr <= wr_ptr + 1'b1;
            end
        end
    end
    assign full = (wr_ptr + 1'b1 == rd_ptr);
    assign empty = (wr_ptr == rd_ptr);


endmodule
