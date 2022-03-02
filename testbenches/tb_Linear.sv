`timescale 1ns/1ns
`include "types.sv"

`ifndef PROJECT_PATH
`define PROJECT_PATH "C:/Users/user/source/fpga/fyp/SimpleNN/"
`endif // PROJECT_PATH

module tb_Linear;
    localparam IN_FEATS = 3;
    localparam OUT_FEATS = 2;
    
    // Control signal.
    logic clk_in;
    logic rst_n;    
    
    nn_data_t weight_mat [OUT_FEATS][IN_FEATS];
    nn_data_t bias_vec [OUT_FEATS];
    nn_data_t data_in [IN_FEATS];
    nn_data_t data_out [OUT_FEATS];
    nn_data_t data_out_gt [OUT_FEATS];
    
    nn_Linear #(.IN_FEATURES(IN_FEATS), .OUT_FEATURES(OUT_FEATS)) UUT (
        .clk(clk_in),
        .rst_n(rst_n),
        
        .weight_mat(weight_mat),
        .bias_vec(bias_vec),
        
        .data_i(data_in),
        .data_o(data_out),
        .data_v()
    );
    
    // Load ROMs.
    initial begin
        $readmemh({`PROJECT_PATH, "roms/tb/linear/weights.mem"}, weight_mat);
        $readmemh({`PROJECT_PATH, "roms/tb/linear/bias.mem"}, bias_vec);
        $readmemh({`PROJECT_PATH, "roms/tb/linear/data_in.mem"}, data_in);
        $readmemh({`PROJECT_PATH, "roms/tb/linear/data_out.mem"}, data_out_gt);
    end
    
    // UUT behaviour.
    initial begin
        // Initialization.
        clk_in = 0;
        rst_n = 1;
        #100;   // Wait 100ns for everything to reset.
        rst_n = 0;
        
        #50 // Wait 10 clock cycles for computation.
        
        $display("Results:");
        for (int i = 0; i < OUT_FEATS; i++) begin
            $display("%d: %x", i, data_out[i]);
            if (data_out[i] != data_out_gt[i]) begin
                $display("Assertion failed for output %d. Expected %x got %x", i, data_out_gt[i], data_out[i]);
            end
        end
        
        $stop;         
    end
    
    always #5 clk_in = ~clk_in; //100MHz clock.
    
endmodule