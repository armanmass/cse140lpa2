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
   assign c[7:0] = 0;
	assign cin = 0;

always @(posedge clk) begin

	if (Gl_subtract == 1) begin
		Gl_r2 <= ~Gl_r2;
		cin <= 1;
	end
	
end

fb_adder fb_adder1 (Gl_r1, Gl_r2, 0, L2_adder_data, c);

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

module fu_adder(input x, input y, input cin, 
					 output sum, output cout);
always @(posedge clk) begin
	sum <= (x^y^cin);
	cout <= ((x&y) | (cin&(x^y)));
end 
endmodule


module fb_adder(input a[7:0], input b[7:0], input cin, input sum [7:0], input cout[7:0]);

fu_adder fu_adder1 (a[0], b[0], cin, sum[0], cout[0]);
fu_adder fu_adder2 (a[1], b[1], cout[0], sum[1], cout[1]);
fu_adder fu_adder3 (a[2], b[2], cout[1], sum[2], cout[2]);
fu_adder fu_adder4 (a[3], b[3], cout[2], sum[3], cout[3]);

endmodule

//testing