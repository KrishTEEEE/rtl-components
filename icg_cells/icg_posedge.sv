module icg_posedge(
    input logic             clk,
    input logic             en,
    output logic            clk_gated
);
    logic latch_en;

    always_latch begin
        if(!clk) latch_en <= en;
    end

    assign clk_gated = latch_en & clk;

endmodule