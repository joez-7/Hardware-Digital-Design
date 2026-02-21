module divide_by_odd #(
    parameter N = 3
) (
    input logic clk,
    input logic rst_n,
    output logic clk_out
);
    localparam WIDTH = $clog2(N);	// Rounds up
    logic [WIDTH-1:0] cnt;
  
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
        end
        else begin
            if (cnt == (N-1)) cnt <= 0;
            else cnt <= cnt + 1'b1;
        end
    end
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) clk_out <= 0;
        else if (cnt == (N-1) || cnt == ((N-1)/2)) 
            clk_out <= ~clk_out;
    end
	
endmodule