// FSM detect sequence for 1001
module seq_detector (
  input in,
  input clk,
  input rst_n,
  output out
);

  // One hot coding
  // Parameter S0=4'b0000, S1=4'b0001, S2=4'b0010, S3=4'b0100;
  parameter S0=3'b000, S1=3'b001, S2=3'b010, S3=3'b011, S4=3'b100;

  reg [2:0] next_state, state;

  always @(*) begin
    next_state = state;  // Prevents latch inference if incomplete assignment
    case(state)
      // IDLE
      S0: if (in == 1) next_state = S1;
      // 1
      S1: if (in == 0) next_state = S2;
      // 10
      S2: begin
        if (in == 0) next_state = S3;
        else next_state = S1;
      end
      // 100
      S3: begin
        if (in == 1) next_state = S4;
        else next_state = S0;
      end
      S4: begin
        if (in == 0) next_state = S2;
        else next_state = S1;
      end
      default: next_state = S0;  // Need it if reg exceeds the bit used to represent the states
    endcase
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) state <= S0;
    else state <= next_state;
  end

  // Moore FSM output only depends on current state
  // Measly FSM output depends on current state and input
  // assign out = (state == S3) & in;
  assign out = (state == S4);

endmodule



