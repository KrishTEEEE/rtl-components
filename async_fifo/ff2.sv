module ff2 #(
    parameter WIDTH = 5
)(
    input logic                     clk,
    input logic [WIDTH-1:0]         din,
    output logic [WIDTH-1:0]        dout,

    input logic                     rst
);

    logic [WIDTH-1:0]       aux;

    always_ff @(posedge clk)begin
        if(rst) begin
            aux <= 'b0;
            dout <= 'b0;
        end
        else begin
            dout <= aux;
            aux <= din;
        end
    end
endmodule