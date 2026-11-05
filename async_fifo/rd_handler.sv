module rd_handler #(
    parameter ADDR_WIDTH = 4
)(
    input logic                     clk_rd,
    input logic                     rd_en,
    input logic [ADDR_WIDTH:0]      sync_gray_wr_ptr,
    output logic [ADDR_WIDTH:0]     bin_rd_ptr,
    output logic [ADDR_WIDTH:0]     gray_rd_ptr,
    output logic                    empty,
    output logic                    mem_read,

    input logic                     rst
);

    always_ff @(posedge clk_rd)begin
        if(rst) bin_rd_ptr <= 'b0;
        else begin
            if(rd_en && !empty)begin
                bin_rd_ptr <= bin_rd_ptr + 1;
            end
        end
    end

    assign mem_read = rd_en && !empty; // read_en signal for mem

    assign gray_rd_ptr = (bin_rd_ptr >> 1) ^ bin_rd_ptr;

    assign empty = (sync_gray_wr_ptr == gray_rd_ptr);
endmodule