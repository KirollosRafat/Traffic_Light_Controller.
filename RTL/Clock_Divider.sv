module Clock_divider #(parameter DIVISOR = 50_000_000) // We chose 50e6 for 50 MHz clock to be 1Hz
(
input logic clock_in,
input logic rst,
output logic clock_out
);

logic[$clog2(DIVISOR)-1:0] counter= 0;

always_ff @(posedge clock_in,posedge rst)
begin
 if(rst)
 begin
 	counter <= 0;
	clock_out <= 1'b0;
 end
 else 
 begin
 

 if(counter == (DIVISOR-1)) //When counter reaches the end we reset it
  counter <= {$clog2(DIVISOR){1'b0}};
 else
  counter <= counter + 1;

 clock_out <= (counter<DIVISOR/2)?1'b1:1'b0; // At half divisor value set the clk = 1 and zero otherwise to maintain 50% duty cycle. 
 end
end
endmodule
