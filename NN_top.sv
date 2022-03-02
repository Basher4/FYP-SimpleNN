`timescale 1ns/1ps

module NN_top #(bvalues = 11) (
    input  wire         clk_in,
    input  wire         rst_n,
    input  bit   [15:0] data_in [bvalues],
    output bit   [15:0] data_out,
    output logic        data_out_v
);

    wire [15:0] nn_linear_0_out [bvalues];
    wire [15:0] nn_relu_0_out [bvalues];

    nn_Linear #(
    .IN_FEATURES(bvalues),
    .OUT_FEATURES(bvalues)
    // .WEIGHTS_INIT_FILE()
    ) nn_linear_0 (
        .clk(clk),
        .data_in(data_in),
        .data_out(nn_linear_0_out)
    );

    nn_ReLU #(
    .FEATURES(6)
    ) nn_ReLU_instance (
        .clk(clk),
        .data_in(nn_linear_0_out),
        .data_out(nn_relu_0_out)
    );

    nn_Linear #(
    .IN_FEATURES(bvalues),
    .OUT_FEATURES(1)
    // .WEIGHTS_INIT_FILE()
    ) nn_linear_1 (
        .clk(clk),
        .data_in(nn_relu_0_out),
        .data_out(data_out)
    );

endmodule