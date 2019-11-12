module clock_fsm 
#(parameter WIDTH=150, parameter WIDTH_BITS = 8, parameter SCALE = 4, parameter LSCALE =2)
(reset, clk_in, clk_out);

	parameter INIT =0, COUNT1 = 1, TICK = 2, COUNT2 = 3, RESET_COUNT2 = 4;

	input reset, clk_in;
	output reg clk_out;
	
	reg [4:0] state, next_state;
	reg [LSCALE-1:0] count1;
	reg [WIDTH_BITS+1:0] count2;
	reg [WIDTH_BITS+1:0] count;
	wire parity;
	
	always @(posedge clk_in) begin
		if (~reset) begin
			count <= 0;
			clk_out <= 0;
		end
		else if (count == SCALE*WIDTH -1) begin
			count <= 0;
		end
		else begin
			count <= count + 1;
		end
	end
	
	assign parity = ^count;
	
	always @(count) begin
		if (count < WIDTH && parity == 1) begin
			clk_out = ~clk_out;
		end
	end
	
	
	
	//**state machine to iterate through shift reg
	/*
	//next state transition
	always @(posedge clk_in) begin
		if (~reset) begin
			state <= INIT;
		end
		else begin
			state <= next_state;
		end
	end
	
	// Output logic
	always @(posedge clk_in) begin
		//init
		if (state == INIT) begin
			clk_out <= 0;
			count1 <= 0;
			count2 <= 0;
		end
		//count horizontal edge
		else if (state == COUNT1) begin
			count1 <= count1 + 1;
			count2 <= count2 + 1;
		end
		//tick every SCALE/2 clock cycles (1/SCALE frequency)
		else if (state == TICK) begin
			clk_out <= ~clk_out;
			count1 <= 0;
		end
		else if (state == COUNT2) begin
			count2 <= count2 + 1;
		end
		else begin
			count2 <= 0;
		end
	end
	
	// Next state logic
	always @(*) begin
		if (~reset) begin
			next_state <= INIT;
		end
		else if (state == INIT) begin
			next_state <= COUNT1;
		end
		else if (state == COUNT1 && count1 == (SCALE>>1) && count2 < WIDTH-1) begin
			next_state <= TICK;
		end
		else if (state == COUNT1 && count1 == (SCALE>>1) && count2 == WIDTH-1) begin
			next_state <= COUNT2;
		end
		else if (state == COUNT1) begin
			next_state <= COUNT1;
		end
		else if (state == TICK) begin
			next_state <= COUNT1;
		end
		else if (state == COUNT2 && count2 < SCALE*WIDTH-1) begin
			next_state <= COUNT2;
		end
		else if (state == COUNT2 && count2 == SCALE*WIDTH-1) begin
			next_state <= RESET_COUNT2;
		end
		else if (state == RESET_COUNT2) begin
			next_state <= COUNT1;
		end
		else begin
			next_state <= INIT;
		end
		
	end
	*/
	//**end state machine
	
	
endmodule