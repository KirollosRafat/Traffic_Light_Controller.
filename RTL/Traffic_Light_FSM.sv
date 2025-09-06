module FSM_Traffic (
  input  logic clk,
  input  logic rst,
  input  logic ped_req, // Accessible Pedestrian Signal (APS)

  // North-South Lane Traffic Light Outputs
  output logic NS_G,   // green
  output logic NS_Y,   // yellow
  output logic NS_R,   // red

  // East-West Lane Traffic Light Outputs
  output logic EW_G,   // green
  output logic EW_Y,   // yellow
  output logic EW_R    // red
);

  // Enumerated Data type for representation of states
  typedef enum logic [1:0] {
    NS_Green  = 2'b00,
    NS_Yellow = 2'b01,
    EW_Green  = 2'b10,
    EW_Yellow = 2'b11
  } state_t;

  // State registers
  state_t current_state, next_state;

  // 4-bit counter
  logic [3:0] counter;

  // state + counter update
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      current_state <= NS_Green;  // Reset state
      counter <= 4'd0;
    end else begin
      current_state <= next_state;

      // If staying in same state, increment counter
      if (current_state == next_state)
        counter <= counter + 1;
      else
        counter <= 4'd0; // Reset counter on state change
    end
  end

  // next state and output logic 
  always_comb begin
    next_state = current_state; // default

    unique case (current_state) // using unqiue case to ensure no conflicts 
      NS_Green: begin
        if (!ped_req && counter == 4'd10)
          next_state = NS_Yellow;
        else if (ped_req && counter == 4'd15)
          next_state = NS_Yellow;

	{NS_G,NS_Y,NS_R} = 3'b100;

	{EW_G,EW_Y,EW_R} = 3'b001;
      end

      NS_Yellow: begin
        if (counter == 4'd3)
          next_state = EW_Green;

	{NS_G,NS_Y,NS_R} = 3'b010;

	{EW_G,EW_Y,EW_R} = 3'b001;
      end

      EW_Green: begin
        if (!ped_req && counter == 4'd10)
          next_state = EW_Yellow;
        else if (ped_req && counter == 4'd15)
          next_state = EW_Yellow;

	{NS_G,NS_Y,NS_R} = 3'b001;

	{EW_G,EW_Y,EW_R} = 3'b100;
      end

      EW_Yellow: begin
        if (counter == 4'd3)
          next_state = NS_Green;

	{NS_G,NS_Y,NS_R} = 3'b001;

	{EW_G,EW_Y,EW_R} = 3'b010;
      end

    endcase
  end

  endmodule
