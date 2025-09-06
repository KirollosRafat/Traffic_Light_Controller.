module TOP (
  input  logic FPGA_CLK,
  input  logic rst,
  input  logic ped_req,

  // 12 LED outputs: North, South, East, West (R,Y,G each)
  output logic LED0,  // North Red
  output logic LED1,  // North Yellow
  output logic LED2,  // North Green
  output logic LED3,  // South Red
  output logic LED4,  // South Yellow
  output logic LED5,  // South Green
  output logic LED6,  // East Red
  output logic LED7,  // East Yellow
  output logic LED8,  // East Green
  output logic LED9,  // West Red
  output logic LED10, // West Yellow
  output logic LED11  // West Green
);

  parameter DIVISOR = 100_000_000; 

  // Intermediate connections
  logic FSM_CLK;
  logic NS_G, NS_Y, NS_R;
  logic EW_G, EW_Y, EW_R;

  // Clock divider
  Clock_divider #(DIVISOR) clk_divider (
    .clock_in(FPGA_CLK),
    .rst(rst),
    .clock_out(FSM_CLK)
  );

  // Traffic FSM
  FSM_Traffic FSM (
    .clk(FSM_CLK),
    .rst(rst),
    .ped_req(ped_req),
    .NS_G(NS_G),
    .NS_Y(NS_Y),
    .NS_R(NS_R),
    .EW_G(EW_G),
    .EW_Y(EW_Y),
    .EW_R(EW_R)
  );

  // Map FSM outputs to 12 LEDs
  assign LED0  = NS_R;  // North Red
  assign LED1  = NS_Y;  // North Yellow
  assign LED2  = NS_G;  // North Green

  assign LED3  = NS_R;  // South Red (same as North Red)
  assign LED4  = NS_Y;  // South Yellow
  assign LED5  = NS_G;  // South Green

  assign LED6  = EW_R;  // East Red
  assign LED7  = EW_Y;  // East Yellow
  assign LED8  = EW_G;  // East Green

  assign LED9  = EW_R;  // West Red (same as East Red)
  assign LED10 = EW_Y;  // West Yellow
  assign LED11 = EW_G;  // West Green

endmodule
