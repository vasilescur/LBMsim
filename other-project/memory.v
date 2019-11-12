module memory(clk1, clk2, reset, iCoord_X, iCoord_Y, iCursor_X, iCursor_Y, left_click, right_click, direction, inject, vga_done,oRed, oGreen, oBlue, mem);
	
	//screen dimensions
	parameter WIDTH = 150;
	parameter HEIGHT = 120;
	parameter WIDTH_BITS = 7; //log2(WIDTH)
	parameter N_MAX = WIDTH * HEIGHT;
	parameter COUNT_MAX = 3*WIDTH;
	parameter N_BITS = 15; //log2(N_MAX)
	parameter SCALE = 4; //scaling factor for VGA display
	parameter LSCALE = 2; //log2(SCALE)
	//states
	parameter INIT = 0, FILL_MEM = 1, FILL_SR = 2, ITER = 3, CLICKED = 4, OVER=5;
	
	//inputs
	input clk1,clk2, reset, vga_done, left_click, right_click, mem;
	input [3:0] direction;
	input [9:0] iCoord_X, iCursor_X;
	input [9:0] iCoord_Y, iCursor_Y;
	input [2:0] inject;
	
	// Outputs
	output [7:0] oRed;
	output [7:0] oGreen;
	output [7:0] oBlue;

	//internal
	//overwrite values for left/right click
	wire [15:0] OVER_VAL_0;
	wire [15:0] OVER_VAL_N;
	
	assign OVER_VAL_0 = {2'b00, 14'b10110011001100}>>inject;
	assign OVER_VAL_N = {2'b00, 14'b01001100110010}>>inject;
	
	reg [N_BITS-1:0] coord_in; //input coord to shift registers
	
	reg [2:0] state;
	reg [2:0] next_state;
	
	wire solve_en; //write enable to memories
	wire [15:0] f0i,f1i,f2i,f3i,f4i,f5i,f6i,f7i,f8i; //to solver
	wire [15:0] f0o,f1o,f2o,f3o,f4o,f5o,f6o,f7o,f8o; //from solver
	wire [15:0] uout;											//from solver
	wire [15:0] f0o_init,f1o_init,f2o_init,f3o_init,f4o_init,f5o_init,f6o_init,f7o_init,f8o_init; //initial values
	wire [15:0] f0o_init_2,f1o_init_2,f2o_init_2,f3o_init_2,f4o_init_2,f5o_init_2,f6o_init_2,f7o_init_2,f8o_init_2; //2nd set of init values
	wire [15:0] f0o_write,f1o_write,f2o_write,f3o_write,f4o_write,f5o_write,f6o_write,f7o_write,f8o_write; //to memory
	
	wire [15:0] f_out;
	wire [N_BITS-1:0] f_out_r_addr;	//to VGA
	reg [N_BITS-1:0] overwrite_addr;
	wire [N_BITS-1:0] cursor_addr;	//from cursor
	reg [3:0] over_count;
	
	wire [23:0] color_out, color_speed, color_density;
	wire shift_en;

	wire [15:0] f1_write_mem, f2_write_mem, f3_write_mem, f4_write_mem, f5_write_mem, f6_write_mem, f7_write_mem, f8_write_mem, f0_write_mem;
	wire write_jet;
	
	//mux color based on solver boundaries and display mode
	assign color_out = (iCoord_X >= SCALE*WIDTH) ? 24'b0 : (iCoord_Y >= SCALE*HEIGHT) ? 24'b0 : (mem) ? color_speed : color_density;
	assign f_out_r_addr = (iCoord_X>>LSCALE) + (iCoord_Y>>LSCALE)*WIDTH; 
	assign cursor_addr = (iCursor_X>>LSCALE) + (iCursor_Y>>LSCALE)*WIDTH; 
	
	assign oRed = color_out[23:16];
	assign oGreen = color_out[15:8];
	assign oBlue = color_out[7:0];
	
	reg [N_BITS-1:0] f_w_addr;	//write address pf node being solved
	
	//register bank
	reg [15:0] tmp1_5, tmp1_3, tmp1_7, tmp2_3, tmp2_7, tmp3_7;
	reg [15:0] tmp1_2, tmp1_0, tmp1_1, tmp2_0, tmp2_1, tmp3_1;
	reg [15:0] tmp1_8, tmp1_4, tmp1_6, tmp2_4, tmp2_6, tmp3_6;
	
	//shift register taps
	wire [15:0] tap_0_0, tap_0_2, tap_0_1;
	wire [15:0] tap_1_0, tap_1_2, tap_1_1;
	wire [15:0] tap_2_0, tap_2_2, tap_2_1;
	wire [15:0] tap_3_0, tap_3_2, tap_3_1;
	wire [15:0] tap_4_0, tap_4_2, tap_4_1;
	wire [15:0] tap_5_0, tap_5_2, tap_5_1;
	wire [15:0] tap_6_0, tap_6_2, tap_6_1;
	wire [15:0] tap_7_0, tap_7_2, tap_7_1;
	wire [15:0] tap_8_0, tap_8_2, tap_8_1;
	
	wire done_init;						//done signal for initialization
	reg [N_BITS:0] count_init; 	//counter for initialization
	
	
	assign done_init = (count_init==N_MAX) ? 1'b1 : 1'b0;
	
	//write either initial values or values from solver
	assign f0o_write = (state == FILL_MEM && count_init < N_MAX/2) ? f0o_init : (state == FILL_MEM) ? f0o_init_2 : f0o;
	assign f1o_write = (state == FILL_MEM && count_init < N_MAX/2) ? f1o_init : (state == FILL_MEM) ? f1o_init_2 : f1o;
	assign f2o_write = (state == FILL_MEM && count_init < N_MAX/2) ? f2o_init : (state == FILL_MEM) ? f2o_init_2 : f2o;
	assign f3o_write = (state == FILL_MEM && count_init < N_MAX/2) ? f3o_init : (state == FILL_MEM) ? f3o_init_2 : f3o;
	assign f4o_write = (state == FILL_MEM && count_init < N_MAX/2) ? f4o_init : (state == FILL_MEM) ? f4o_init_2 : f4o;
	assign f5o_write = (state == FILL_MEM && count_init < N_MAX/2) ? f5o_init : (state == FILL_MEM) ? f5o_init_2 : f5o;
	assign f6o_write = (state == FILL_MEM && count_init < N_MAX/2) ? f6o_init : (state == FILL_MEM) ? f6o_init_2 : f6o;
	assign f7o_write = (state == FILL_MEM && count_init < N_MAX/2) ? f7o_init : (state == FILL_MEM) ? f7o_init_2 : f7o;
	assign f8o_write = (state == FILL_MEM && count_init < N_MAX/2) ? f8o_init : (state == FILL_MEM) ? f8o_init_2 : f8o;
	
	//initialize screen to 0 density at all points
	assign f0o_init = {2'b00, 14'b00000000000000};
	assign f1o_init = {2'b00, 14'b00000000000000};
	assign f2o_init = {2'b00, 14'b00000000000000};
	assign f3o_init = {2'b00, 14'b00000000000000};
	assign f4o_init = {2'b00, 14'b00000000000000};
	assign f5o_init = {2'b00, 14'b00000000000000};//00000100000000
	assign f6o_init = {2'b00, 14'b00000000000000};//00000110000000
	assign f7o_init = {2'b00, 14'b00000000000000};//00000110000000
	assign f8o_init = {2'b00, 14'b00000000000000};//00000100000000
	
	assign f0o_init_2 = {2'b00, 14'b00000000000000};
	assign f1o_init_2 = {2'b00, 14'b00000000000000};
	assign f2o_init_2 = {2'b00, 14'b00000000000000};
	assign f3o_init_2 = {2'b00, 14'b00000000000000};
	assign f4o_init_2 = {2'b00, 14'b00000000000000};
	assign f5o_init_2 = {2'b00, 14'b00000000000000};//00000100000000
	assign f6o_init_2 = {2'b00, 14'b00000000000000};//00000110000000
	assign f7o_init_2 = {2'b00, 14'b00000000000000};//00000110000000
	assign f8o_init_2 = {2'b00, 14'b00000000000000};//00000100000000
	
	//only write to memory in certain states
	assign solve_en = (state == FILL_MEM) || (state == ITER) || (state == OVER) || (state == CLICKED);

	// intermediate registers to hold values off of shift reg
	always @(posedge clk1) begin
		
		// READ FROM MEMORY
		// top row
		//load 5,3,7
		//node20
		tmp1_5 <= tap_5_2; //to solver, from memory
		tmp1_3 <= tap_3_2;
		tmp1_7 <= tap_7_2; 
		//node10
		tmp2_3 <= tmp1_3; //to solver
		tmp2_7 <= tmp1_7;
		//node00
		tmp3_7 <= tmp2_7; //to solver
		
		// middle row
		//load 2, 0 ,1
		//node21
		tmp1_2 <= tap_2_1; //to solver, from memory
		tmp1_0 <= tap_0_1;
		tmp1_1 <= tap_1_1; 
		//node11
		tmp2_0 <= tmp1_0; //to solver
		tmp2_1 <= tmp1_1;
		//node01
		tmp3_1 <= tmp2_1; //to solver
		
		// bottom row
		//load 8, 4, 6
		//node22
		tmp1_8 <= tap_8_0; //to solver, from memory
		tmp1_4 <= tap_4_0;
		tmp1_6 <= tap_6_0; 
		//node12
		tmp2_4 <= tmp1_4; //to solver
		tmp2_6 <= tmp1_6;
		//node02
		tmp3_6 <= tmp2_6; //to solver
	end
	
	
	//**state machine to iterate through shift reg
	
	//next state transition
	always @(posedge clk1) begin
		if (~reset) begin
			state <= INIT;
		end
		else begin
			state <= next_state;
		end
	end
	
	
	// Output logic
	always @(posedge clk1) begin
		//init
		if (state == INIT) begin
			coord_in <= 0;
			count_init <= 0;
		end
		//initialize memory
		else if (state == FILL_MEM) begin

			count_init <= count_init + 1;
			f_w_addr <= count_init;
			
		end
		//fill up shift register
		else if (state == FILL_SR) begin
			coord_in = coord_in + 1;

			//calculate the addresss of the node being solved
			if (coord_in >= 2*WIDTH + 3) begin
				f_w_addr = coord_in - (2*WIDTH + 3)-1;	
			end
			else begin
				f_w_addr = (N_MAX-1) - (2*WIDTH + 3) + coord_in;
			end
		end

		//ITER: iterate over pixels for solution
		else if (state == ITER) begin
			//calculate address of node being placed onto shift registers
			//pause simulation until VGA done
			if (coord_in == 2*WIDTH + 3 && ~vga_done) begin
				coord_in = coord_in;
			end
			else if (coord_in == 2*WIDTH + 3 && vga_done) begin
				coord_in = coord_in + 1;
			end
			//rollover
			else if (coord_in == N_MAX - 1) begin
				coord_in = 0;
			end
			else begin
				coord_in = coord_in + 1;
			end
			
			//calculate address of node being solved
			if (coord_in >= 2*WIDTH + 3) begin
				f_w_addr = coord_in - (2*WIDTH + 3)-1;
			end
			else begin
				f_w_addr = (N_MAX-1) - (2*WIDTH + 3) + coord_in;
			end
			
		end
		//LMB clicked
		else if (state == CLICKED) begin
			over_count <= 0;
			//pause simulation
			coord_in <= coord_in;
		end
		//OVER
		else begin
			over_count <= over_count + 1;
			//pause simulation
			coord_in <= coord_in;
			//overwrite 3x3 block of nodes around cursor
			if (over_count < 3) overwrite_addr <= cursor_addr + over_count;
			else if (over_count < 6) overwrite_addr <= cursor_addr + WIDTH + over_count - 3;
			else overwrite_addr <= cursor_addr + 2*WIDTH + over_count - 6;
		end
	end
	
	//active low - pauses shifting when high
	assign shift_en = ((state == ITER) && (coord_in == 2*WIDTH + 3) && (~vga_done)) || (state == OVER) || (state == CLICKED);
	
	// Next state logic
	always @(*) begin
		if (~reset) begin
			next_state <= INIT;
		end
		else if (state == INIT) begin
			next_state <= FILL_MEM;
		end
		else if (state == FILL_MEM && done_init) begin
			next_state <= FILL_SR;
		end
		else if (state == FILL_MEM && ~done_init) begin
			next_state <= FILL_MEM;
		end
		else if (state == FILL_SR && coord_in == COUNT_MAX-1) begin
			next_state <= ITER;
		end
		else if (state == FILL_SR && coord_in < COUNT_MAX-1) begin
			next_state <=FILL_SR;
		end
		//ITER
		else if (state == ITER && ~left_click) begin
			next_state <= ITER;
		end
		else if (state == ITER && left_click) begin
			next_state <= CLICKED;
		end
		else if (state == CLICKED) begin
			next_state <= OVER;
		end
		else if (state == OVER && over_count < 9) begin
			next_state <= OVER;
		end
		else if (state == OVER && over_count == 9 && left_click) begin
			next_state <= CLICKED;
		end
		else if (state == OVER && over_count == 9 && ~left_click) begin
			next_state <= ITER;
		end
		else begin
			next_state <= INIT;
		end
		
	end
	
	//**end state machine

	//are we at a coordinate where we want to have a jet?
	assign write_jet = f_w_addr==cursor_addr || f_w_addr==cursor_addr+1 || f_w_addr==cursor_addr+2 || f_w_addr==cursor_addr + WIDTH || f_w_addr==cursor_addr + WIDTH+1 || f_w_addr==cursor_addr + WIDTH+2;
	
	//mux between values for LMB, RMB, normal solve
	assign f1_write_mem = (state == OVER) ? OVER_VAL_N : (right_click && direction == 1 && write_jet) ? OVER_VAL_N : (right_click && (direction == 6 || direction == 7) && write_jet) ? OVER_VAL_N>>1 : (right_click && write_jet) ? 16'd0 : f1o_write;
	assign f2_write_mem = (state == OVER) ? OVER_VAL_N : (right_click && direction == 2 && write_jet) ? OVER_VAL_N : (right_click && (direction == 8 || direction == 5) && write_jet) ? OVER_VAL_N>>1 : (right_click && write_jet) ? 16'd0 : f2o_write;
	assign f3_write_mem = (state == OVER) ? OVER_VAL_N : (right_click && direction == 3 && write_jet) ? OVER_VAL_N : (right_click && (direction == 5 || direction == 7) && write_jet) ? OVER_VAL_N>>1 : (right_click && write_jet) ? 16'd0 : f3o_write;
	assign f4_write_mem = (state == OVER) ? OVER_VAL_N : (right_click && direction == 4 && write_jet) ? OVER_VAL_N : (right_click && (direction == 6 || direction == 8) && write_jet) ? OVER_VAL_N>>1 : (right_click && write_jet) ? 16'd0 : f4o_write;
	assign f5_write_mem = (state == OVER) ? OVER_VAL_N : (right_click && direction == 5 && write_jet) ? OVER_VAL_N : (right_click && (direction == 2 || direction == 3) && write_jet) ? OVER_VAL_N>>1 : (right_click && write_jet) ? 16'd0 : f5o_write;
	assign f6_write_mem = (state == OVER) ? OVER_VAL_N : (right_click && direction == 6 && write_jet) ? OVER_VAL_N : (right_click && (direction == 1 || direction == 4) && write_jet) ? OVER_VAL_N>>1 : (right_click && write_jet) ? 16'd0 : f6o_write;
	assign f7_write_mem = (state == OVER) ? OVER_VAL_N : (right_click && direction == 7 && write_jet) ? OVER_VAL_N : (right_click && (direction == 1 || direction == 3) && write_jet) ? OVER_VAL_N>>1 : (right_click && write_jet) ? 16'd0 : f7o_write;
	assign f8_write_mem = (state == OVER) ? OVER_VAL_N : (right_click && direction == 8 && write_jet) ? OVER_VAL_N : (right_click && (direction == 2 || direction == 4) && write_jet) ? OVER_VAL_N>>1 : (right_click && write_jet) ? 16'd0 : f8o_write;
	assign f0_write_mem = (state == OVER) ? OVER_VAL_0 : (right_click && write_jet) ? OVER_VAL_0 : f0o_write;
	

	//MODULE INSTANTIATIONS
	//two decoders for two view modes
	speed_decoder d1 (
		.in(f_out),
		.out(color_speed)
	);
	
	density_decoder d2 (
		.in(f_out),
		.out(color_density)
	);
	
	//the solver
	lattice_boltzmann lb(
		//from register bank
		.f0i(tmp2_0), 
		.f1i(tmp3_1), 
		.f2i(tmp1_2), 
		.f3i(tmp2_3), 
		.f4i(tmp2_4), 
		.f5i(tmp1_5), 
		.f6i(tmp3_6), 
		.f7i(tmp3_7), 
		.f8i(tmp1_8), 
		.clk(clk1), 
		.reset(reset),
		//to memory
		.f0o(f0o), 
		.f1o(f1o), 
		.f2o(f2o), 
		.f3o(f3o), 
		.f4o(f4o), 
		.f5o(f5o), 
		.f6o(f6o), 
		.f7o(f7o), 
		.f8o(f8o),
		.uout(uout)
	);
	
	
	//shift registers
	//outputs to register bank
	shift_reg_v#(WIDTH,16) sr_v0 (
		.clk(clk1),
		.reset(reset),
		.d(f0i),
		.en(shift_en),
		.q(),
		.tap0_out(tap_0_0),
		.tap1_out(tap_0_1),
		.tap2_out(tap_0_2)
	);
	shift_reg_v#(WIDTH,16) sr_v1 (
		.clk(clk1),
		.reset(reset),
		.d(f1i),
		.en(shift_en),
		.q(),
		.tap0_out(tap_1_0),
		.tap1_out(tap_1_1),
		.tap2_out(tap_1_2)
	);
	shift_reg_v#(WIDTH,16) sr_v2 (
		.clk(clk1),
		.reset(reset),
		.d(f2i),
		.en(shift_en),
		.q(),
		.tap0_out(tap_2_0),
		.tap1_out(tap_2_1),
		.tap2_out(tap_2_2)
	);
	shift_reg_v#(WIDTH,16) sr_v3 (
		.clk(clk1),
		.reset(reset),
		.d(f3i),
		.en(shift_en),
		.q(),
		.tap0_out(tap_3_0),
		.tap1_out(tap_3_1),
		.tap2_out(tap_3_2)
	);
	shift_reg_v#(WIDTH,16) sr_v4 (
		.clk(clk1),
		.reset(reset),
		.d(f4i),
		.en(shift_en),
		.q(),
		.tap0_out(tap_4_0),
		.tap1_out(tap_4_1),
		.tap2_out(tap_4_2)
	);
	shift_reg_v#(WIDTH,16) sr_v5 (
		.clk(clk1),
		.reset(reset),
		.d(f5i),
		.en(shift_en),
		.q(),
		.tap0_out(tap_5_0),
		.tap1_out(tap_5_1),
		.tap2_out(tap_5_2)
	);
	shift_reg_v#(WIDTH,16) sr_v6 (
		.clk(clk1),
		.reset(reset),
		.d(f6i),
		.en(shift_en),
		.q(),
		.tap0_out(tap_6_0),
		.tap1_out(tap_6_1),
		.tap2_out(tap_6_2)
	);
	shift_reg_v#(WIDTH,16) sr_v7 (
		.clk(clk1),
		.reset(reset),
		.d(f7i),
		.en(shift_en),
		.q(),
		.tap0_out(tap_7_0),
		.tap1_out(tap_7_1),
		.tap2_out(tap_7_2)
	);
	shift_reg_v#(WIDTH,16) sr_v8 (
		.clk(clk1),
		.reset(reset),
		.d(f8i),
		.en(shift_en),
		.q(),
		.tap0_out(tap_8_0),
		.tap1_out(tap_8_1),
		.tap2_out(tap_8_2)
	);
	
	
	//memory blocks
	
	//VGA read block
	dual_clock_ram#(16,N_MAX,N_BITS) m0_vga (
		.q(f_out),
		.d((state == OVER) ? 16'hFFFF : (mem) ? uout : f0_write_mem),
		.write_address((state==OVER) ? overwrite_addr : f_w_addr),
		.read_address(f_out_r_addr),
		.we(solve_en),
		.clk1(clk1),
		.clk2(clk1)
	);
	
	//direction read/write blocks
	dual_clock_ram#(16,N_MAX,N_BITS) m0 (
		.q(f0i),
		.d(f0_write_mem),
		.write_address((state==OVER) ? overwrite_addr : f_w_addr),
		.read_address(coord_in),
		.we(solve_en),
		.clk1(clk1),
		.clk2(clk1)
	);
	dual_clock_ram#(16,N_MAX,N_BITS) m1 (
		.q(f1i),
		.d(f1_write_mem),
		.write_address((state==OVER) ? overwrite_addr : f_w_addr),
		.read_address(coord_in),
		.we(solve_en),
		.clk1(clk1),
		.clk2(clk1)
	);
	dual_clock_ram#(16,N_MAX,N_BITS) m2 (
		.q(f2i),
		.d(f2_write_mem),
		.write_address((state==OVER) ? overwrite_addr : f_w_addr),
		.read_address(coord_in),
		.we(solve_en),
		.clk1(clk1),
		.clk2(clk1)
	);
	dual_clock_ram#(16,N_MAX,N_BITS) m3 (
		.q(f3i),
		.d(f3_write_mem),
		.write_address((state==OVER) ? overwrite_addr : f_w_addr),
		.read_address(coord_in),
		.we(solve_en),
		.clk1(clk1),
		.clk2(clk1)
	);
	dual_clock_ram#(16,N_MAX,N_BITS) m4 (
		.q(f4i),
		.d(f4_write_mem),
		.write_address((state==OVER) ? overwrite_addr : f_w_addr),
		.read_address(coord_in),
		.we(solve_en),
		.clk1(clk1),
		.clk2(clk1)
	);
	dual_clock_ram#(16,N_MAX,N_BITS) m5(
		.q(f5i),
		.d(f5_write_mem),
		.write_address((state==OVER) ? overwrite_addr : f_w_addr),
		.read_address(coord_in),
		.we(solve_en),
		.clk1(clk1),
		.clk2(clk1)
	);
	dual_clock_ram#(16,N_MAX,N_BITS) m6 (
		.q(f6i),
		.d(f6_write_mem),
		.write_address((state==OVER) ? overwrite_addr : f_w_addr),
		.read_address(coord_in),
		.we(solve_en),
		.clk1(clk1),
		.clk2(clk1)
	);
	dual_clock_ram#(16,N_MAX,N_BITS) m7 (
		.q(f7i),
		.d(f7_write_mem),
		.write_address((state==OVER) ? overwrite_addr : f_w_addr),
		.read_address(coord_in),
		.we(solve_en),
		.clk1(clk1),
		.clk2(clk1)
	);
	dual_clock_ram#(16,N_MAX,N_BITS) m8 (
		.q(f8i),
		.d(f8_write_mem),
		.write_address((state==OVER) ? overwrite_addr : f_w_addr),
		.read_address(coord_in),
		.we(solve_en),
		.clk1(clk1),
		.clk2(clk1)
	);
	
	
endmodule

// Dual clock, dual port SRAM (M10K)
module dual_clock_ram
//#(parameter DATA_WIDTH=8, parameter ADDR_WIDTH=6)
#(parameter DATA_WIDTH=16, parameter NUM_ADDR=19200, parameter ADDR_WIDTH = 15)
(
 output reg [(DATA_WIDTH-1):0] q,
 input [(DATA_WIDTH-1):0] d,
 input [(ADDR_WIDTH-1):0] write_address, read_address,
 input we, clk1, clk2
);
	reg [(ADDR_WIDTH-1):0] read_address_reg;
	reg [(DATA_WIDTH-1):0] mem [NUM_ADDR-1:0];
	//write
	always @ (posedge clk1) begin
		if (we)
			mem[write_address] <= d;
		end
	//read
	always @ (posedge clk2) begin
		q <= mem[read_address_reg];
		read_address_reg <= read_address;
	end
endmodule

module speed_decoder
(
input [15:0] in,
output reg [24:0] out
);
always @(*) begin
	if		  (in == 16'hFFFF)						 out = 24'h000000;
	else if (in > {2'b00, 14'b00000010000100}) out = 24'hC41313; //0.0081, deep red
	else if (in > {2'b00, 14'b00000001101000}) out = 24'hFF0000; //0.0064, red
	else if (in > {2'b00, 14'b00000001010000}) out = 24'hFF4D00; //0.0049, red-orange
	else if (in > {2'b00, 14'b00000000111010}) out = 24'hFF8000; //0.0036, orance
	else if (in > {2'b00, 14'b00000000101000}) out = 24'hFFFF00; //0.0025, yellow
	else if (in > {2'b00, 14'b00000000011010}) out = 24'hB3FF00; //0.0016, yellow-green
	else if (in > {2'b00, 14'b00000000001110}) out = 24'h80FF00; //0.0009, green
	else if (in > {2'b00, 14'b00000000000110}) out = 24'h00CC66; //0.0004, green-blue
	else if (in > {2'b00, 14'b00000000000001}) out = 24'h00FFFF; //0.0001, blue
	else 													 out = 24'h0066CC; //0.00
end

endmodule


module density_decoder
(
input [15:0] in,
output reg [24:0] out
);
always @(*) begin

	if		  (in == 16'hFFFF)						 out = 24'h000000;
	else if (in > {2'b00, 14'b01001100110011}) out = 24'hC41313; //0.30, deep red
	else if (in > {2'b00, 14'b01000100010001}) out = 24'hFF0000; //0.27, red
	else if (in > {2'b00, 14'b00111011101110}) out = 24'hFF4D00; //0.24, red-orange
	else if (in > {2'b00, 14'b00110011001100}) out = 24'hFF8000; //0.21, orance
	else if (in > {2'b00, 14'b00101010101010}) out = 24'hFFFF00; //0.18, yellow
	else if (in > {2'b00, 14'b00100010001000}) out = 24'hB3FF00; //0.15, yellow-green
	else if (in > {2'b00, 14'b00011001100110}) out = 24'h80FF00; //0.12, green
	else if (in > {2'b00, 14'b00010000111001}) out = 24'h00CC66; //0.09, green-blue
	else if (in > {2'b00, 14'b00001000011100}) out = 24'h00FFFF; //0.06, blue
	else 													 out = 24'h0066CC; //0.03
end

endmodule

