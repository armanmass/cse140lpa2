// --------------------------------------------------------------------
// >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<
// --------------------------------------------------------------------
// Copyright (c) 2019 by UCSD CSE 140L
// --------------------------------------------------------------------
//
// Permission:
//
//   This code for use in UCSD CSE 140L.
//   It is synthesisable for Lattice iCEstick 40HX.  
//
// Disclaimer:
//
//   This Verilog source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  
//
module Lab2_140L (
 input wire Gl_rst,                  // reset signal (active high)
 input wire clk,                     // global clock
 input wire Gl_adder_start,          // r1, r2, OP are ready  
 input wire Gl_subtract,             // subtract (active high)
 input wire [7:0] Gl_r1           , // 8bit number 1
 input wire [7:0] Gl_r2           , // 8bit number 1
 output wire [7:0] L2_adder_data   ,   // 8 bit ascii sum
 output wire L2_adder_rdy          , //pulse
 output wire [7:0] L2_led
);

	reg [7:0] num1;
	reg [7:0] num2;
	reg cin;
	

	always @(posedge clk) begin
		cin <= 0;
		num1 <= Gl_r1;
		num2 <= Gl_r2;
		if (Gl_subtract) begin
			num2 <= ~num2;
			cin <= 1;
		end
		
	end

	sigDelay sigDelay (.sigOut(L2_adder_rdy), .sigIn(Gl_adder_start), .clk(clk), .rst(Gl_rst));

	fb_adder fb_adder (num1, num2, cin, L2_adder_data);

endmodule

module sigDelay(
		  output      sigOut,
		  input       sigIn,
		  input       clk,
		  input       rst);

   parameter delayVal = 4;
   reg [15:0] 		      delayReg;


   always @(posedge clk) begin
      if (rst)
	delayReg <= 16'b0;
      else begin
	 delayReg <= {delayReg[14:0], sigIn};
      end
   end

   assign sigOut = delayReg[delayVal];
endmodule // sigDelay

module fu_adder(input a, input b, input cin, 
					 output reg sum, output reg cout);
always @(*) begin
	sum <= ((a^b)^cin);
	cout <= ((a&b) | (cin&(a^b)));
end
endmodule //fulladder


module fb_adder(input [7:0] a, input [7:0] b, input cin, output reg [7:0] sum);

reg [7:0] cout;

fu_adder fu_adder1 (.a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .cout(cout[0]));
fu_adder fu_adder2 (.a(a[1]), .b(b[1]), .cin(cout[0]), .sum(sum[1]), .cout(cout[1]));
fu_adder fu_adder3 (.a(a[2]), .b(b[2]), .cin(cout[1]), .sum(sum[2]), .cout(cout[2]));
fu_adder fu_adder4 (.a(a[3]), .b(b[3]), .cin(cout[2]), .sum(sum[3]), .cout(cout[3]));

always @(cout) begin
	sum[4] <= cout[3];
end

endmodule //4bit adder
