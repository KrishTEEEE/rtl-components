// simple implementation of the fifo decided to assert full when wr_ptr is 1 less than rd_ptr
// so as to distinguish between full and empty, since an empty fifo and an actually full fifo both have equal ptrs
// as a result one mem array slot can never be written, a n-depth fifo has effectively n-1 depth

// To utilise the entire depth of the fifo, we need a better way of telling: When ptrs are equal
// is this a read more than write, i.e. empty; or write more than read, i.e. full, state?
// Hence, we introduce an extra bit to our counters
// The idea: for an empty fifo, read catches up to write, so they must have the same MSB, either both 0,
// or both 1, i.e. having wrapped around the mem array once. So rd_ptr == wr_ptr
// If it's a full fifo, the write catches up to read, so it has to lap the read ptr!, thus different MSBs
// but remaining bits are equal

module fifo #(
    parameter DEPTH = 8, WIDTH = 4 // for pointer wraparound to work, depth must be 2^n
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
            if(wr_en && (!full || rd_en)) begin // allows simultaneous read and write when FIFO is full
            // hardware equates to read first then write
                mem_array[wr_ptr[$clog2(DEPTH)-1:0]] <= din;
                wr_ptr <= wr_ptr + 1'b1;
            end
        end
    end
    assign full = (wr_ptr ^ rd_ptr) == {1'b1, {$clog2(DEPTH){1'b0}}};
    assign empty = (wr_ptr == rd_ptr);
endmodule
