// This fifo uses an extra bit for pointers, the MSB using to determine whether it's a full or empty
// when pointers point to the same spot
// fifo is read and write synchronous
// note depth must be 2^n so that the pointers wraparound for the fifo
// note that with the current if conditions for read/write:
// when your fifo is FULL, you can ONLY READ, not write, until the next clock cycle
// when your fifo is EMPTY, you can ONLY WRITE, not read, until the next clock cycle

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

    logic [$clog2(DEPTH):0]      wr_ptr;
    logic [$clog2(DEPTH):0]      rd_ptr;

    always_ff@(posedge clk1)begin
        if(rst)begin
            wr_ptr <= 0;
            rd_ptr <= 0;
        end
        else begin
            if(rd_en && !empty) begin
                dout <= mem_array[rd_ptr[$clog2(DEPTH)-1:0]];
                rd_ptr <= rd_ptr + 1'b1;
            end
            if(wr_en && !full) begin
                mem_array[wr_ptr[$clog2(DEPTH)-1:0]] <= din;
                wr_ptr <= wr_ptr + 1'b1;
            end
        end
    end
    assign full = (wr_ptr ^ rd_ptr) == {1'b1, {$clog2(DEPTH){1'b0}}};
    assign empty = (wr_ptr == rd_ptr);
endmodule
