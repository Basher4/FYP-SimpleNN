`timescale 1ns/1ps
`include "types.sv"

typedef bit signed[DATA_WIDTH*2-1:0] nn_data_double_t; 

module nn_Perceptron #(FEATURES = 11) (
    input  wire      clk,
    input  wire      rst_n,

    input  nn_data_t weights [FEATURES],
    input  nn_data_t bias,

    input  nn_data_t data_i  [FEATURES],
    output nn_data_t data_o,
    output logic     data_v
);

    localparam TRUNC_START = DATA_WIDTH * 2 - INT_BITS - 1;
    localparam TRUNC_END   = FRAC_BITS;

    // bit signed [DATA_WIDTH*2:0] mul [11];
    // bit signed [DATA_WIDTH*2:0] adl [11];    // TODO: Make it parametric.
    nn_data_double_t mul[11];
    nn_data_double_t adl[10];
    nn_data_double_t result;

    // Parallel multipliers.
    genvar i, j;
    generate
        for (i = 0; i < FEATURES; i++) begin: MACC
//            wire [DATA_WIDTH*2-1:0] mul_res = weights[i] * data_i[i];
//            
//            // Truncate the result to DATA_WIDTH bits.
//            assign mul[i] = mul_res[TRUNC_START:TRUNC_END];
            assign mul[i] = weights[i] * data_i[i];
        end
    endgenerate
    
    // Adder ladder
    // Level 0.
    assign adl[0] = mul[0] + mul[1];
    assign adl[1] = mul[2] + mul[3];
    assign adl[2] = mul[4] + mul[5];
    assign adl[3] = mul[6] + mul[7];
    assign adl[4] = mul[8] + mul[9];
    // Level 1.
    assign adl[5] = adl[0] + adl[1];
    assign adl[6] = adl[2] + adl[3];
    assign adl[7] = adl[4] + mul[10];   // TODO: If pipelined then delay here.
    // Level 2.
    assign adl[8] = adl[5] + adl[6];
    // Level 3.
    assign adl[9] = adl[8] + adl[7];
    
    assign result = adl[9] + bias;
    
    assign data_o = result[TRUNC_START:TRUNC_END];
    assign data_v = 1;

endmodule