module wr_handler #(
    parameter ADDR_WIDTH = 4
)(
    input logic                     clk_wr,
    input logic                     wr_en,
    input logic [ADDR_WIDTH:0]       sync_gray_rd_ptr,
    output logic [ADDR_WIDTH:0]      gray_wr_ptr,
    output logic [ADDR_WIDTH:0]      bin_wr_ptr, // dual port ram truncates the MSB, which is only used for flag logic
    output logic                    full,
    output logic                    mem_write,

    input logic                     rst
);

    always_ff @(posedge clk_wr)begin
        if(rst) bin_wr_ptr <= 'b0;
        else begin
            if(wr_en && !full)begin
                bin_wr_ptr <= bin_wr_ptr + 1;
            end
        end
    end

    assign mem_write = wr_en && !full; // write enable signal for mem

    assign gray_wr_ptr = (bin_wr_ptr >> 1) ^ bin_wr_ptr;

    //using gray coded ptrs to determine full flag directly to avoid extra gray-to-bin decoder hardware
    assign full = (gray_wr_ptr[ADDR_WIDTH-2:0] == sync_gray_rd_ptr[ADDR_WIDTH-2:0]) && ((gray_wr_ptr[ADDR_WIDTH:ADDR_WIDTH-1]^sync_gray_rd_ptr[ADDR_WIDTH:ADDR_WIDTH-1]) == 2'b11);

endmodule