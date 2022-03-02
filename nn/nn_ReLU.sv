`timescale 1ns/1ps

module nn_ReLU #(FEATURES = 6) (
    input  wire               clk,
    input  bit  signed [15:0] data_in  [FEATURES],
    output bit  signed [15:0] data_out [FEATURES]
);

genvar i;
for (i = 0; i < FEATURES; i++) begin
    assign data_out[i] = data_in[i] > 0 ? data_in[i] : 16'b0; 
end

endmodule: nn_ReLU
