module jk_ff (
    input wire clk,
    input wire reset,
    input wire j,
    input wire k,
    output reg q,
    output wire q_bar
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 1'b0;
        end else begin
            case ({j, k})
                2'b00: q <= q;      // No change
                2'b01: q <= 1'b0;   // Reset
                2'b10: q <= 1'b1;   // Set
                2'b11: q <= ~q;     // Toggle
            endcase
        end
    end
    
    assign q_bar = ~q;
    
endmodule

module synchronous_counter (
    input wire clk,
    input wire reset,
    input wire enable,
    output wire [3:0] count
);
    
    wire [3:0] j, k;
    wire [3:0] q_bar;
    
    // JK inputs for each flip-flop
    assign j[0] = enable;
    assign k[0] = enable;
    
    assign j[1] = enable & count[0];
    assign k[1] = enable & count[0];
    
    assign j[2] = enable & count[0] & count[1];
    assign k[2] = enable & count[0] & count[1];
    
    assign j[3] = enable & count[0] & count[1] & count[2];
    assign k[3] = enable & count[0] & count[1] & count[2];
    
    // Instantiate JK flip-flops
    jk_ff ff0 (
        .clk(clk),
        .reset(reset),
        .j(j[0]),
        .k(k[0]),
        .q(count[0]),
        .q_bar(q_bar[0])
    );
    
    jk_ff ff1 (
        .clk(clk),
        .reset(reset),
        .j(j[1]),
        .k(k[1]),
        .q(count[1]),
        .q_bar(q_bar[1])
    );
    
    jk_ff ff2 (
        .clk(clk),
        .reset(reset),
        .j(j[2]),
        .k(k[2]),
        .q(count[2]),
        .q_bar(q_bar[2])
    );
    
    jk_ff ff3 (
        .clk(clk),
        .reset(reset),
        .j(j[3]),
        .k(k[3]),
        .q(count[3]),
        .q_bar(q_bar[3])
    );
    
endmodule

// Testbench
module tb_synchronous_counter;
    reg clk;
    reg reset;
    reg enable;
    wire [3:0] count;
    
    // Instantiate the counter
    synchronous_counter uut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .count(count)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        enable = 0;
        
        // Apply reset
        #10 reset = 0;
        enable = 1;
        
        // Let counter run for some cycles
        #160;
        
        // Disable counter
        enable = 0;
        #40;
        
        // Re-enable counter
        enable = 1;
        #80;
        
        $finish;
    end
    
    // Monitor the outputs
    initial begin
        $monitor("Time = %0t, Count = %b (%0d)", $time, count, count);
    end
    
endmodule