`timescale 1ns/100ps
module sync_fifo_counter_tb;
    reg        clk, rst_n, wr_en, rd_en;
    reg  [7:0] wr_data;
    wire [7:0] rd_data;
    wire       full, empty;

    integer i;

    // clock
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // DUT
    sync_fifo_counter #(
        .WIDTH   (8),
        .DEPTH   (16)
    ) dut (
        .clk     (clk),
        .rst_n   (rst_n),
        .wr_en   (wr_en),
        .rd_en   (rd_en),
        .wr_data (wr_data),
        .rd_data (rd_data),
        .full    (full),
        .empty   (empty)
    );

    initial begin
        rst_n   = 1'b0;
        wr_en   = 1'b0;
        rd_en   = 1'b0;
        wr_data = 8'b0;

        #10 rst_n = 1'b1;

        // Write
        for (i = 0; i < 16; i = i + 1) begin
            @(posedge clk);
            if (!full) begin
                wr_en   = 1'b1;
                rd_en   = 1'b0;
                wr_data = i[7:0];
            end else begin
                wr_en = 1'b0;
            end
        end
        @(posedge clk) wr_en = 1'b0;

        repeat (2) @(posedge clk);

        // Read
        for (i = 0; i < 16; i = i + 1) begin
        @(posedge clk);
            if (!empty) begin
                rd_en = 1'b1;
                wr_en = 1'b0;
            end else begin
                rd_en = 1'b0;
            end
        end
        @(posedge clk) rd_en = 1'b0;

        #40 $finish;
    end

    initial begin
        $dumpfile("sync_fifo_counter.vcd");
        $dumpvars();
    end

endmodule