module dual_mem #(
    parameter DEPTH, WIDTH // DEPTH must be a power of 2, just like in sync fifo
)(
    // writes
    input logic                         clk_wr,
    input logic [WIDTH-1:0]             din,
    input logic [$clog2(DEPTH)-1:0]     wr_addr,
    input logic                         wr_en,
    // reads
    input logic                         clk_rd,
    input logic [$clog2(DEPTH)-1:0]     rd_addr,
    input logic                         rd_en,
    output logic [WIDTH-1:0]            dout,
    // Note: rst not necessary for mem content, only pointers
);

    logic [WIDTH-1:0] mem_array [0:DEPTH-1];

    always_ff @(posedge clk_rd)begin
        if(rd_en)begin
            dout <= mem_array[rd_addr];
        end
    end
    always_ff @(posedge clk_wr)begin
        if(wr_en)begin
            mem_array[wr_addr] <= din;
        end
    end

endmodule