`timescale 1ps/1ps
module async_fifo_tb ();
    reg        wclk, wr_rst_n, wr_en, rclk, rd_rst_n, rd_en;
    reg  [7:0] wdata;
    wire [7:0] rdata;
    wire       full, empty;

    initial begin
        #0 wclk = 0; 
        forever #5 wclk = ~wclk;
    end

    initial begin
        #0 rclk = 0;
        forever #6 rclk = ~rclk;
    end

    async_fifo #(
        .DEPTH (16),
        .WIDTH (8),
        .M     (3)
    ) dut (
        .wclk         (wclk),
        .rclk         (rclk),
        .wr_rst_n     (wr_rst_n),
        .rd_rst_n     (rd_rst_n),
        .wr_en        (wr_en),
        .rd_en        (rd_en),
        .rdata        (rdata),
        .wdata        (wdata),
        .empty        (empty),
        .full         (full)
    );

    initial begin
        #0 begin
            wr_rst_n = 1'b0;
            wr_en = 1'b0;
        end
        #5 wr_rst_n = 1'b1;
        #6 wdata = 8'd1;
        repeat (17) begin
            @(posedge wclk) begin
                if (!full) begin
                    wdata = wdata + 1'b1;
                    #5 wr_en = 1'b1;
                end
            end
        end 
        @(posedge wclk) wr_en = 1'b0;
    end

    initial begin
        #0 begin
            rd_rst_n = 1'b0;
            rd_en = 1'b0;
        end
        #6 rd_rst_n = 1'b1;
        #200;
        repeat (18) begin
            @(posedge rclk) begin
                if (!empty)  
              	#6 rd_en = 1'b1;
            end
        end
        @(posedge rclk) rd_en = 1'b0;
        #700 $finish;
    end

    initial begin
        $dumpfile("async_fifo_wave.vcd");
        $dumpvars();
    end

endmodule