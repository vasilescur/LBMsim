module lattice_boltzmann (f0i, f1i, f2i, f3i, f4i, f5i, f6i, f7i, f8i, clk, reset, f0o, f1o, f2o, f3o, f4o, f5o, f6o, f7o, f8o, uout);

	parameter X = 0, Y = 1;
	
	parameter SATURATION_VALUE = {2'b00, 14'b00100110011001}; //unused
	

	// f inputs
	input signed [15:0] f0i, f1i, f2i, f3i, f4i, f5i, f6i, f7i, f8i;
	//0 no boundary, 1 left, 2 right, 3 top, 4 bottom, 5 top left, 6 top right, 7 bottom left, 8 bottom right
	
	input clk, reset;
	
	// f outputs
	output signed [15:0] f0o, f1o, f2o, f3o, f4o, f5o, f6o, f7o, f8o, uout;
	
	//	state regs
	reg [3:0] state, next_state;
	
	// internal variables
	wire signed [15:0] f0;
	wire signed [15:0] rho;
	wire signed [15:0] u [1:0];
	
	// assign directions to inputs
	wire signed [15:0] f1i_x, f2i_x, f3i_x, f4i_x;
	wire signed [15:0] f1i_y, f2i_y, f3i_y, f4i_y;
	assign f1i_x = f1i; assign f1i_y = 16'd0;
	assign f2i_x = -f2i; assign f2i_y = 16'd0;
	assign f3i_x = 16'd0; assign f3i_y = -f3i;
	assign f4i_x = 16'd0; assign f4i_y = f4i;
	
	// decomposition for diagonals
	wire signed [15:0] f5i_x, f6i_x, f7i_x, f8i_x;
	wire signed [15:0] f5i_y, f6i_y, f7i_y, f8i_y;
	decompose d5(f5i, f5i_x, f5i_y, 4'd5);
	decompose d6(f6i, f6i_x, f6i_y, 4'd6);
	decompose d7(f7i, f7i_x, f7i_y, 4'd7);
	decompose d8(f8i, f8i_x, f8i_y, 4'd8);

	// multiplies for calculations
	wire signed [15:0] uxx, uyy, uxy, uu, ux, uy;//, uxx214, uyy214;
	wire signed [15:0] uxy_temp;

	
	// calc rho and u logic
	assign rho = f0i + f1i + f2i + f3i + f4i + f5i + f6i + f7i + f8i;
	assign u[X] = f1i_x + f2i_x + f3i_x + f4i_x + f5i_x + f6i_x + f7i_x + f8i_x;
	assign u[Y] = f1i_y + f2i_y + f3i_y + f4i_y + f5i_y + f6i_y + f7i_y + f8i_y;
	
	assign uout = uu; //speed^2
	
	assign uu = uxx + uyy;
	assign ux = u[X];
	assign uy = u[Y];
	assign uxy = uxy_temp<<<1;
	signed_mult sm1 (uxx, u[X], u[X]);
	signed_mult sm2 (uyy, u[Y], u[Y]);
	signed_mult sm3 (uxy_temp, u[X], u[Y]);
	
	// calculate temp outputs before weights
	wire signed [15:0] f1o_temp, f2o_temp, f3o_temp, f4o_temp, f5o_temp, f6o_temp, f7o_temp, f8o_temp;
	
	//(1/9)(rho + 3ux + 4.5uxx - 1.5uu)
	assign f1o_temp = rho + ((ux<<<1) + ux) + ((uxx<<<2) + (uxx>>>1)) - ((uu<<<1) - (uu>>>1));
	assign f1o = (f1o_temp>>>4) + (f1o_temp>>>5) + (f1o_temp>>>6) + (f1o_temp>>>10) + (f1o_temp>>>11) + (f1o_temp>>>12); 

	//(1/9)(rho - 3ux + 4.5uxx - 1.5uu)
	assign f2o_temp = rho - ((ux<<<1) + ux) + ((uxx<<<2) + (uxx>>>1)) - ((uu<<<1) - (uu>>>1));
	assign f2o = (f2o_temp>>>4) + (f2o_temp>>>5) + (f2o_temp>>>6) + (f2o_temp>>>10) + (f2o_temp>>>11) + (f2o_temp>>>12);
	
	//(1/9)(rho - 3uy + 4.5uyy - 1.5uu)
	assign f3o_temp = rho - ((uy<<<1) + uy) + ((uyy<<<2) + (uyy>>>1)) - ((uu<<<1) - (uu>>>1));
	assign f3o = (f3o_temp>>>4) + (f3o_temp>>>5) + (f3o_temp>>>6) + (f3o_temp>>>10) + (f3o_temp>>>11) + (f3o_temp>>>12);
	
	//(1/9)(rho + 3uy + 4.5uyy - 1.5uu)
	assign f4o_temp = rho + ((ux<<<1) + ux) + ((uxx<<<2) + (uxx>>>1)) - ((uu<<<1) - (uu>>>1));
	assign f4o = (f4o_temp>>>4) + (f4o_temp>>>5) + (f4o_temp>>>6) + (f4o_temp>>>10) + (f4o_temp>>>11) + (f4o_temp>>>12);

	//(1/36)(rho - 3(ux+uy) + 4.5(uxx+uyy+uxy) - 1.5uu)
	assign f5o_temp = rho - (((ux+uy)<<<1) + (ux+uy)) + (((uxx+uyy+uxy)<<<2) + ((uxx+uyy+uxy)>>>1)) - ((uu<<<1) - (uu>>>1));
	assign f5o = (f5o_temp>>>6) + (f5o_temp>>>7) + (f5o_temp>>>8) + (f5o_temp>>>12) + (f5o_temp>>>13);

	//(1/36)(rho + 3(ux+uy) + 4.5(uxx+uyy+uxy) - 1.5uu)
	assign f6o_temp = rho + (((ux+uy)<<<1) + (ux+uy)) + (((uxx+uyy+uxy)<<<2) + ((uxx+uyy+uxy)>>>1)) - ((uu<<<1) - (uu>>>1));
	assign f6o = (f6o_temp>>>6) + (f6o_temp>>>7) + (f6o_temp>>>8) + (f6o_temp>>>12) + (f6o_temp>>>13);

	//(1/36)(rho + 3(ux-uy) + 4.5(uxx+uyy-uxy) - 1.5uu)
	assign f7o_temp = rho + (((ux-uy)<<<1) + (ux-uy)) + (((uxx+uyy-uxy)<<<2) + ((uxx+uyy-uxy)>>>1)) - ((uu<<<1) - (uu>>>1));
	assign f7o = (f7o_temp>>>6) + (f7o_temp>>>7) + (f7o_temp>>>8) + (f7o_temp>>>12) + (f7o_temp>>>13);

	//(1/36)(rho - 3(ux-uy) + 4.5(uxx+uyy-uxy) - 1.5uu)
	assign f8o_temp = rho - (((ux-uy)<<<1) + (ux-uy)) + (((uxx+uyy-uxy)<<<2) + ((uxx+uyy-uxy)>>>1)) - ((uu<<<1) - (uu>>>1));
	assign f8o = (f8o_temp>>>6) + (f8o_temp>>>7) + (f8o_temp>>>8) + (f8o_temp>>>12) + (f8o_temp>>>13);

	assign f0o = rho - f1o - f2o - f3o - f4o- f5o- f6o - f7o - f8o;
	
	
endmodule

//2.14
module signed_mult (out, a, b);
	output 	signed   [15:0]	out;
	input 	signed	[15:0] 	a;
	input 	signed	[15:0] 	b;
	// intermediate full bit length
	wire 	signed	[31:0]	mult_out;
	assign mult_out = a * b;
	// select bits for 2.14 fixed point
	assign out = {mult_out[31], mult_out[28:15]};	
endmodule

module decompose (in, outx, outy, index);
	input signed [15:0] in;
	output reg signed [15:0] outx, outy;
	input [3:0] index;
	
	always @(*) begin
		if (index == 4'd5) begin
			//SW (-1/sqrt(2), -1/sqrt(2))
			outx <= -((in>>>1) + (in>>>3) + (in>>>4) + (in>>>6) + (in>>>8) + (in>>>14));
			outy <= -((in>>>1) + (in>>>3) + (in>>>4) + (in>>>6) + (in>>>8) + (in>>>14));
		end
		else if (index == 4'd6) begin
			//NE
			outx <= ((in>>>1) + (in>>>3) + (in>>>4) + (in>>>6) + (in>>>8) + (in>>>14));
			outy <= ((in>>>1) + (in>>>3) + (in>>>4) + (in>>>6) + (in>>>8) + (in>>>14));
		end
		else if (index == 4'd7) begin
			//SE
			outx <= ((in>>>1) + (in>>>3) + (in>>>4) + (in>>>6) + (in>>>8) + (in>>>14));
			outy <= -((in>>>1) + (in>>>3) + (in>>>4) + (in>>>6) + (in>>>8) + (in>>>14));
		end
		else begin
			//NW
			outx <= -((in>>>1) + (in>>>3) + (in>>>4) + (in>>>6) + (in>>>8) + (in>>>14));
			outy <= ((in>>>1) + (in>>>3) + (in>>>4) + (in>>>6) + (in>>>8) + (in>>>14));
		end
	end
	
endmodule