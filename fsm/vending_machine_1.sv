module vending_machine_1 (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       nickel,
    input  logic       dime,
    input  logic       quarter,
    output logic       dispense,
    output logic [1:0] change   // 00=no change, 01=5 cent, 10=10 cent, capped max change at 10 cent
);
    parameter S0=2'b00, S5=2'b01, S10=2'b10, S15=2'b11;
    logic [1:0] next_state, state, next_change;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            change <= 2'b0;
            state <= S0;
            dispense <= 1'b0;
        end else begin
            state <= next_state;
            change <= next_change;
            dispense <= (state == S15);
        end
    end

  always @(*) begin
      next_state = state;
      next_change = 2'b00;
      case(state)
            S0: begin
                if (nickel) begin
                    next_state = S5;
                    next_change = 0;
                end else if (dime) begin
                    next_state = S10;
                    next_change = 0;
                end else if (quarter) begin
                    next_state = S15;
                    next_change = 2'b10;
                end
            end
            S5: begin
                if (nickel) begin
                    next_state = S10;
                    next_change = 0;
                end else if (dime) begin
                    next_state = S15;
                    next_change = 0;
                end else if (quarter) begin
                    next_state = S15;
                    next_change = 2'b10;
                end
            end
            S10: begin
                if (nickel) begin
                    next_state = S15;
                    next_change = 0;
                end else if (dime) begin
                    next_state = S15;
                    next_change = 2'b01;
                end else if (quarter) begin
                    next_state = S15;
                    next_change = 2'b10;
                end
            end
            S15: begin
                if (nickel) next_change = 2'b01;
                if (dime) next_change = 2'b10;
                if (quarter) next_change = 2'b10;
                next_state = S0;
            end
        	default: next_state = S0;
        endcase
    end


endmodule
