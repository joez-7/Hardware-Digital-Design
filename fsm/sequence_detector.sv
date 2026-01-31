// FSM detect sequence for 1001
module seq_detector (
  input in,
  input clk,
  input resetn,
  output out
);

  // One hot coding
  // parameter S0=4'b0000, S1=4'b0001, S2=4'b0010, S3=4'b0100;
  parameter S0=2'b00, S1=2'b01, S2=2'b10, S3=2'b11;

  reg [1:0] next_state, state;

  always @(*) begin
    next_state = state;
    case(state)
      // Nothing
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
        if (in == 1) next_state = S1;
        else next_state = S0;
      end
      default: next_state = S0;	// need it if reg exceeds the bit use to represent the states
    endcase
  end

  always @(posedge clk or negedge resetn) begin
    if (!resetn) state <= S0;
    else state <= next_state;
  end

  assign out = (state == S3) & in;

endmodule