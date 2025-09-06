`timescale 1ns/1ps

module tb_TOP;

  logic FPGA_CLK;
  logic rst;
  logic ped_req;

  // 12 LED outputs from TOP
  logic LED0, LED1, LED2;
  logic LED3, LED4, LED5;
  logic LED6, LED7, LED8;
  logic LED9, LED10, LED11;

  parameter DIVISOR = 100;

  // Clock generation: 10ns period = 100MHz
  initial FPGA_CLK = 0;
  always #5 FPGA_CLK = ~FPGA_CLK;

  // DUT instantiation
  TOP #(DIVISOR) dut (
    .FPGA_CLK(FPGA_CLK),
    .rst(rst),
    .ped_req(ped_req),
    .LED0(LED0), .LED1(LED1), .LED2(LED2),
    .LED3(LED3), .LED4(LED4), .LED5(LED5),
    .LED6(LED6), .LED7(LED7), .LED8(LED8),
    .LED9(LED9), .LED10(LED10), .LED11(LED11)
  );

  // Stimulus
  initial begin
    // Open waveform dump (for GTKWave or ModelSim)
    $dumpfile("traffic_tb.vcd");
    $dumpvars(0, tb_TOP);

    // Reset
    rst = 1;
    ped_req = 0;
    #50;
    rst = 0;

    // Normal operation: run through 2 full cycles
    repeat (40) @(posedge dut.FSM_CLK);

    // Trigger pedestrian request during NS green
    ped_req = 1;
    repeat (20) @(posedge dut.FSM_CLK);
    ped_req = 0;

    // Trigger pedestrian request during EW green
    repeat (60) @(posedge dut.FSM_CLK);
    ped_req = 1;
    repeat (20) @(posedge dut.FSM_CLK);
    ped_req = 0;

    // Let FSM run extra cycles
    //repeat (200) @(posedge dut.FSM_CLK);

    $finish;
  end

  // Monitor LED states
  initial begin
    $display("Time | Ped | N(R,Y,G) | S(R,Y,G) | E(R,Y,G) | W(R,Y,G)");
    $monitor("%0t | %b | %b%b%b | %b%b%b | %b%b%b | %b%b%b",
             $time, ped_req,
             LED0, LED1, LED2,
             LED3, LED4, LED5,
             LED6, LED7, LED8,
             LED9, LED10, LED11);
  end


endmodule

