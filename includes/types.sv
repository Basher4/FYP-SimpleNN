`ifndef _TYPES_SV_
`define _TYPES_SV_

parameter INT_BITS = 4;
parameter FRAC_BITS = 14;
parameter DATA_WIDTH = INT_BITS + FRAC_BITS;
parameter DATA_MSB = DATA_WIDTH - 1;

typedef bit signed [DATA_MSB:0] nn_data_t;

`endif // _TYPES_SV_
