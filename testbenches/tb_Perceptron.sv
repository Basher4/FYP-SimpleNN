`timescale 1ns/1ns
`include "types.sv"

`ifndef PROJECT_PATH
`define PROJECT_PATH "C:/Users/user/source/fpga/fyp/SimpleNN/"
`endif // PROJECT_PATH

module tb_Perceptron;
    
    // Control signal.
    logic clk_in;
    logic rst_n;

    nn_data_t nn_i [11];
    nn_data_t nn_w [11];
    nn_data_t nn_b [ 1];
    
    nn_data_t nn_desired_out [1];
    
    // Outputs
    nn_data_t nn_out;
    wire      nn_out_v;

    real      nn_des_out_r;    
    real      nn_out_r;
    real      delta_r;
    
    // UUT
    nn_Perceptron #(.FEATURES(11)) uut (
        .clk(clk_in),
        .rst_n(rst_n),

        .weights(nn_w),
        .bias(nn_b[0]),
        
        .data_i(nn_i),
        .data_o(nn_out),
        .data_v(nn_out_v)
    );
    
    // Load data
    initial begin
        $readmemh({`PROJECT_PATH, "roms/tb/perceptron/data_in.mem"}, nn_i);
        $readmemh({`PROJECT_PATH, "roms/tb/perceptron/weights.mem"}, nn_w);
        $readmemh({`PROJECT_PATH, "roms/tb/perceptron/bias.mem"}, nn_b);
        $readmemh({`PROJECT_PATH, "roms/tb/perceptron/data_out.mem"}, nn_desired_out);
    end
    
    // UUT behaviour.
    initial begin
        // Initialization.
        clk_in = 0;
        rst_n = 1;
        #100;   // Wait 100ns for everything to reset.
        rst_n = 0;
        
        #50 // Wait 10 clock cycles for computation.
        nn_out_r = real'(nn_out)/(2.0 ** FRAC_BITS);
        nn_des_out_r = real'(nn_desired_out[0])/(2.0 ** FRAC_BITS);
        delta_r = nn_out_r - nn_des_out_r;
        delta_r = $sqrt(delta_r * delta_r);

        $display("Results:");
        if (delta_r > 0.01) begin
            $display("Incorrect result. Expected %x (%f) got %x (%f)", nn_desired_out[0], nn_des_out_r, nn_out, nn_out_r);
        end
        
        $stop;
    end
    
    always #5 clk_in = ~clk_in; //100MHz clock.
    
endmodule