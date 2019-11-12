`timescale 1ns/1ns

module testbench();
	
	reg clk_50, clk_25, reset;
	reg signed [17:0] f0i, f1i, f2i, f3i, f4i, f5i, f6i, f7i, f8i;
	reg [31:0] index;
	wire signed [17:0] f0o, f1o, f2o, f3o, f4o, f5o, f6o, f7o, f8o;
	reg [9:0] iCoord_X, iCoord_Y;
	wire [7:0] oRed, oGreen, oBlue;
	wire clk_out;
	
	
	//Initialize clocks and index
	initial begin
		clk_50 = 1'b0;
		clk_25 = 1'b0;
		index  = 32'd0;
		reset = 1'b0;
	end
		
	//Toggle the clocks
	always begin
		#10
		clk_50  = !clk_50;
	end
	
	always begin
		#20
		clk_25  = !clk_25;
	end


	//		.iCoord_X(),
//		.iCoord_Y(),
//		.oRed(),
//		.oGreen(),
//		.oBlue()
	
	// SOLVER TESTS
	//Intialize and drive signals
	reg vga_done;
	initial begin
		reset <= 0;
		vga_done <= 0;
		#100
		reset <= 1;
		#5000
		vga_done <= 1;
		#20
		vga_done <= 0;
		#5000
		vga_done <= 1;
		#20
		vga_done <= 0;
		#5000
		vga_done <= 1;
		#20
		vga_done <= 0;
		#5000
		vga_done <= 1;
		#20
		vga_done <= 0;
		#5000
		vga_done <= 1;
		#20
		vga_done <= 0;
		#5000
		vga_done <= 1;
		#20
		vga_done <= 0;
		#5000
		vga_done <= 1;
		#20
		vga_done <= 0;
		#5000
		vga_done <= 1;
		#20
		vga_done <= 0;
		#5000
		vga_done <= 1;
		#20
		vga_done <= 0;
		#5000
		vga_done <= 1;
		#20
		vga_done <= 0;
		#5000
		vga_done <= 1;
		#20
		vga_done <= 0;
		#5000
		vga_done <= 1;
		#20
		vga_done <= 0;
		#5000
		vga_done <= 1;
		#20
		vga_done <= 0;
		#5000
		vga_done <= 1;
		#20
		vga_done <= 0;
		#5000
		vga_done <= 1;
		#20
		vga_done <= 0;
		#5000
		vga_done <= 1;
		#20
		vga_done <= 0;
		#5000
		vga_done <= 1;
		#20
		vga_done <= 0;
		#5000
		vga_done <= 1;
		#20
		vga_done <= 0;
		#5000
		vga_done <= 1;
		#20
		vga_done <= 0;
		#5000
		vga_done <= 1;
		#20
		vga_done <= 0;
		#5000
		vga_done <= 1;
		#20
		vga_done <= 0;
		#5000
		vga_done <= 1;
		#20
		vga_done <= 0;
		#5000
		vga_done <= 1;
		#20
		vga_done <= 0;
		#5000
		vga_done <= 1;
		#20
		vga_done <= 0;
		#5000
		vga_done <= 1;
		#20
		vga_done <= 0;
		#5000
		vga_done <= 1;
		#20
		vga_done <= 0;
		#5000
		vga_done <= 1;
		#20
		vga_done <= 0;
		#5000
		vga_done <= 1;
		#20
		vga_done <= 0;
		#5000
		vga_done <= 1;
		#20
		vga_done <= 0;
		#5000
		vga_done <= 1;
		#20
		vga_done <= 0;
		#5000
		vga_done <= 1;
		#20
		vga_done <= 0;
		#5000
		vga_done <= 1;
		#20
		vga_done <= 0;
		#5000
		vga_done <= 1;
		#20
		vga_done <= 0;
		#5000
		vga_done <= 1;
		#20
		vga_done <= 0;
		#5000
		vga_done <= 1;
		#20
		vga_done <= 0;
		#5000
		vga_done <= 1;
		#20
		vga_done <= 0;
		#5000
		vga_done <= 1;
		#20
		vga_done <= 0;
		#5000
		vga_done <= 1;
		#20
		vga_done <= 0;
		#5000
		vga_done <= 1;
		#20
		vga_done <= 0;
		#5000
		vga_done <= 1;
		#20
		vga_done <= 0;
		#5000
		
		
		$stop;
	end
	/*
	initial begin
		reset <= 0;
		#10
		// 500, 400 => .3427 57BB2F, .6660. AA7EF9
		f0i = {1'b0, 4'b0000, 13'b0101000000000};
		f1i = {1'b0, 4'b0000, 13'b0001100000000};
		f2i = {1'b0, 4'b0000, 13'b0000110000000};
		f3i = {1'b0, 4'b0000, 13'b0001010000000};
		f4i = {1'b0, 4'b0000, 13'b0001010000000};
		f5i = {1'b0, 4'b0000, 13'b0000010000000};
		f6i = {1'b0, 4'b0000, 13'b0000011000000};
		f7i = {1'b0, 4'b0000, 13'b0000011000000};
		f8i = {1'b0, 4'b0000, 13'b0000010000000};
		
		reset <= 1;
		#3000
		$display("f0i:  %b", f0i) ;
		$display("f0o:  %b", f0o) ;
		$display("want: 000000100110110001") ;
		$display("\n") ;
		
		$display("f1i:  %b", f1i) ;
		$display("f1o:  %b", f1o) ;
		$display("want: 000000001100100111") ;
		$display("\n") ;
		
		$display("f2i:  %b", f2i) ;
		$display("f2o:  %b", f2o) ;
		$display("want: 000000000111010001") ;
		$display("\n") ;
		
		$display("f3i:  %b", f3i) ;
		$display("f3o:  %b", f3o) ;
		$display("want: 000000001001101100") ;
		$display("\n") ;
		
		$display("f4i:  %b", f4i) ;
		$display("f4o:  %b", f4o) ;
		$display("want: 000000001001101100") ;
		$display("\n") ;
		
		$display("f5i:  %b", f5i) ;
		$display("f5o:  %b", f5o) ;
		$display("want: 000000000001110100") ;
		$display("\n") ;
		
		$display("f6i:  %b", f6i) ;
		$display("f6o:  %b", f6o) ;
		$display("want: 000000000011001001") ;
		$display("\n") ;
		
		$display("f7i:  %b", f7i) ;
		$display("f7o:  %b", f7o) ;
		$display("want: 000000000011001001") ;
		$display("\n") ;
		
		$display("f8i:  %b", f8i) ;
		$display("f8o:  %b", f8o) ;
		$display("want: 000000000001110100") ;
		$display("\n") ;
		
		
		$stop;
	end
	*/
	
	//Increment index
	always @ (posedge clk_50) begin
		index  <= index + 32'd1;
	end

	//Instantiation of Device Under Test
	memory m(clk_50, clk_25, reset, iCoord_X, iCoord_Y, vga_done, oRed, oGreen, oBlue);
	
	/*
	lattice_boltzmann lb(
		.f0i(f0i), 
		.f1i(f1i), 
		.f2i(f2i), 
		.f3i(f3i), 
		.f4i(f4i), 
		.f5i(f5i), 
		.f6i(f6i), 
		.f7i(f7i), 
		.f8i(f8i), 
		.clk(clk_50), 
		.reset(reset), 
		.f0o(f0o), 
		.f1o(f1o), 
		.f2o(f2o), 
		.f3o(f3o), 
		.f4o(f4o), 
		.f5o(f5o), 
		.f6o(f6o), 
		.f7o(f7o), 
		.f8o(f8o)
	);
	*/
	
//	solver solver(
//		.zr(zr),
//		.zi(zi),
//		.cr(cr),
//		.ci(ci),
//		.n_max(n_max),
//		.clk(clk_50),
//		.n(n),
//		.reset(reset)
//	);
	
	
endmodule