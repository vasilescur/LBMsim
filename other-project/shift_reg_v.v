module shift_reg_v
#(parameter SCREEN_WIDTH=8, parameter N_BITS = 15)
(
input clk,
input reset,
input [N_BITS-1:0] d,
input en,
//output BIT_OUT,
output [N_BITS-1:0] q,
output [N_BITS-1:0] tap0_out,
output [N_BITS-1:0] tap1_out,
output [N_BITS-1:0] tap2_out
);

	//————————————————————–
	// signal definitions
	//————————————————————–

	//shift register signals
	
	//3*SCREEN_WIDTH locations
	//16 bit word size
	reg [N_BITS-1:0] byteShiftReg[3*SCREEN_WIDTH-1:0];
	integer i;

	//————————————————————–
	// shift register
	//————————————————————–

	//shift register
	always @(posedge clk) begin
		if (~en) begin
			byteShiftReg[0] <= d;
			for(i=1;i<3*SCREEN_WIDTH;i=i+1) begin
				byteShiftReg[i] <= byteShiftReg[i-1];
			end
		end
	end

	//————————————————————–
	// outputs
	//————————————————————–

	//module output wires
	assign tap0_out = byteShiftReg[3*SCREEN_WIDTH-1];
	assign tap1_out = byteShiftReg[2*SCREEN_WIDTH-1];
	assign tap2_out = byteShiftReg[SCREEN_WIDTH-1];
	assign q = byteShiftReg[3*SCREEN_WIDTH-1];
endmodule
