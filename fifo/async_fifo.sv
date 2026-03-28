module async_fifo #(
    parameter DEPTH = 16,    // Depth must be 2^n
    parameter WIDTH = 8,
    parameter M     = 3
) (
    input  logic              wr_rst_n,
    input  logic              wclk,
    input  logic              wr_en,
    input  logic [WIDTH-1:0]  wdata,

    input  logic              rd_rst_n,
    input  logic              rclk,
    input  logic              rd_en,

    output logic              full,

    output logic              empty,
    output logic [WIDTH-1:0]  rdata
);
    localparam ADDR_W = $clog2(DEPTH);

    logic [WIDTH-1:0] mem [DEPTH-1:0];

    // Binary + Gray pointers
    logic [ADDR_W:0] wr_ptr_bin, rd_ptr_bin;
    logic [ADDR_W:0] wr_ptr_gray, rd_ptr_gray;

    // Synced Gray pointers
    logic [ADDR_W:0] wr_ptr_gray_sync1, wr_ptr_gray_sync2;
    logic [ADDR_W:0] rd_ptr_gray_sync1, rd_ptr_gray_sync2;

    // WRITE DOMAIN
    always_ff @(posedge wclk or negedge wr_rst_n) begin
        logic [ADDR_W:0] wr_ptr_next;
        logic [ADDR_W:0] wr_ptr_gray_next;

        if (!wr_rst_n) begin
            wr_ptr_bin  <= '0;
            wr_ptr_gray <= '0;
            full        <= 1'b0;
        end
        else begin
            if (wr_en && !full)
                wr_ptr_next = wr_ptr_bin + 1'b1;
            else
                wr_ptr_next = wr_ptr_bin;

            // gray of next pointer
            wr_ptr_gray_next = wr_ptr_next ^ (wr_ptr_next >> 1);

            // full prediction uses rd_ptr_gray_sync2 with top two bits inverted
            full <= (wr_ptr_gray_next ==
                     {~rd_ptr_gray_sync2[ADDR_W:ADDR_W-1],
                       rd_ptr_gray_sync2[ADDR_W-2:0]});

            if (wr_en && !full)
                mem[wr_ptr_bin[ADDR_W-1:0]] <= wdata;

            wr_ptr_bin  <= wr_ptr_next;
            wr_ptr_gray <= wr_ptr_gray_next;
        end
    end

    // Sync read Gray pointer into write clock domain
    always_ff @(posedge wclk or negedge wr_rst_n) begin
        if (!wr_rst_n) begin
            rd_ptr_gray_sync1 <= '0;
            rd_ptr_gray_sync2 <= '0;
        end
        else begin
            rd_ptr_gray_sync1 <= rd_ptr_gray;
            rd_ptr_gray_sync2 <= rd_ptr_gray_sync1;
        end
    end

    // READ DOMAIN
    always_ff @(posedge rclk or negedge rd_rst_n) begin
        logic [ADDR_W:0] rd_ptr_next;
        logic [ADDR_W:0] rd_ptr_gray_next;

        if (!rd_rst_n) begin
            rd_ptr_bin      <= '0;
            rd_ptr_gray <= '0;
            empty       <= 1'b1;
            rdata       <= '0;
        end
        else begin
            if (rd_en && !empty)
                rd_ptr_next = rd_ptr_bin + 1'b1;
            else
                rd_ptr_next = rd_ptr_bin;

            // gray of next pointer
            rd_ptr_gray_next = rd_ptr_next ^ (rd_ptr_next >> 1);

            // empty prediction compares next read pointer against synced write pointer
            empty <= (rd_ptr_gray_next == wr_ptr_gray_sync2);

            // perform read using CURRENT address, then commit pointer
            if (rd_en && !empty)
                rdata <= mem[rd_ptr_bin[ADDR_W-1:0]];

            rd_ptr_bin      <= rd_ptr_next;
            rd_ptr_gray <= rd_ptr_gray_next;
        end
    end

    // Sync write Gray pointer into read clock domain
    always_ff @(posedge rclk or negedge rd_rst_n) begin
        if (!rd_rst_n) begin
            wr_ptr_gray_sync1 <= '0;
            wr_ptr_gray_sync2 <= '0;
        end
        else begin
            wr_ptr_gray_sync1 <= wr_ptr_gray;
            wr_ptr_gray_sync2 <= wr_ptr_gray_sync1;
        end
    end

endmodule