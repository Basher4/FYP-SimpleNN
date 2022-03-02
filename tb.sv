`timescale 1ns/1ns

module tb;
    
    // Inputs.
    logic clk_in;
    logic rst_n;
    logic [15:0] nn_in [6];
    
    // Outputs
    wire signed [15:0] nn_out;
    wire               nn_out_v;
    
    // UUT
    NN_top uut (
        .clk_in(clk_in),
        .rst_n(rst_n),
        .data_in(nn_in),
        
        .data_out(nn_out),
        .data_out_v(nn_out_v)
    );
    
    
    initial begin
        // Initialization.
        clk_in = 0;
        rst_n = 1;
        
        #100;   // Wait 100ns for everything to reset.
        rst_n = 0;
        
        #500_000 // Wait 0.5ms for computation.
        $display("Signal valid: %d", nn_out_v);
        $display("NN output data: %d", nn_out);
        $stop;         
    end
    
    always #5 clk_in = ~clk_in; //100MHz clock.
    
endmodule