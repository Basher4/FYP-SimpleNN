`timescale 1ns/1ps
`include "types.sv"

module nn_Linear #(IN_FEATURES = 11, OUT_FEATURES = 11) (
    input  wire      clk,
    input  wire      rst_n,

    input  nn_data_t weight_mat [OUT_FEATURES][IN_FEATURES],
    input  nn_data_t bias_vec [OUT_FEATURES],

    input  nn_data_t data_i [IN_FEATURES],
    output nn_data_t data_o [OUT_FEATURES],
    output logic     data_v
);

    wire [0:OUT_FEATURES-1] valid_aggregate;
    assign valid = &valid_aggregate;

    genvar i;
    generate
        for (i = 0; i < OUT_FEATURES; i++) begin: PERCEPTRONS
            nn_Perceptron #(
            .FEATURES(IN_FEATURES)
            ) prec (
                .clk(clk),
                .rst_n(rst_n),
                .weights(weight_mat[i]),
                .bias(bias_vec[i]),
                .data_i(data_i),
                .data_o(data_o[i]),
                .data_v(valid_aggregate[i])
            );
        end
    endgenerate

endmodule: nn_Linear
