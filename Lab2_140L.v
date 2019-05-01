//
// Lab2_140L
// CSE140L Spring 2019
//
// Author: Arman Massoudian
//

//
// Module Lab2_140L
// Four bit adder subtractor using submodule fu_adder (Full adder)
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

	sigDelay sigDelay (.sigOut(L2_adder_rdy), .sigIn(Gl_adder_start), .clk(clk), .rst(Gl_rst));

	wire [7:0] num2;
	wire [3:0] cout;
	
	//negating second number if Gl_subtract is active (bitwise)
	assign num2[0] = (Gl_subtract) ? ~Gl_r2[0] : Gl_r2[0];
	assign num2[1] = (Gl_subtract) ? ~Gl_r2[1] : Gl_r2[1];
	assign num2[2] = (Gl_subtract) ? ~Gl_r2[2] : Gl_r2[2];
	assign num2[3] = (Gl_subtract) ? ~Gl_r2[3] : Gl_r2[3];
	assign num2[4] = (Gl_subtract) ? ~Gl_r2[4] : Gl_r2[4];
	assign num2[5] = (Gl_subtract) ? ~Gl_r2[5] : Gl_r2[5];
	assign num2[6] = (Gl_subtract) ? ~Gl_r2[6] : Gl_r2[6];
	assign num2[7] = (Gl_subtract) ? ~Gl_r2[7] : Gl_r2[7];
	
	//using full adders to ripple creating four bit adder
	fu_adder fu_adder1 (.a(Gl_r1[0]), .b(num2[0]), .cin(Gl_subtract), .sum(L2_adder_data[0]), .cout(cout[0]));
	fu_adder fu_adder2 (.a(Gl_r1[1]), .b(num2[1]), .cin(cout[0]), .sum(L2_adder_data[1]), .cout(cout[1]));
	fu_adder fu_adder3 (.a(Gl_r1[2]), .b(num2[2]), .cin(cout[1]), .sum(L2_adder_data[2]), .cout(cout[2]));
	fu_adder fu_adder4 (.a(Gl_r1[3]), .b(num2[3]), .cin(cout[2]), .sum(L2_adder_data[3]), .cout(cout[3]));

	//set sum bits for character display
	assign L2_adder_data[7] = 1'b0;
	assign L2_adder_data[6] = L2_led[4];
	assign L2_adder_data[5] = ~L2_led[4];
	assign L2_adder_data[4] = 1'b1;
	assign L2_led[3:0] = L2_adder_data[3:0];
	
	//appropriate carry bit for led for subtracting/adding
	assign L2_led[4] = (Gl_subtract && (Gl_r2 > Gl_r1)) ? 1'b1 
						  : (Gl_subtract && (Gl_r2 <= Gl_r1)) ? 1'b0
						  : cout[3];

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


//
// Module fu_adder
// Full adder taking 3 inputs value 1, value 2, and carry in
// returns sum and carry out x=a+b+c then sum = x[0] and cout = x[1]
//
module fu_adder(input a, input b, input cin, 
					 output reg sum, output reg cout);
	always @(*) begin			 
	sum = ((a^b)^cin);
	cout = ((a&b) | (cin&a) | (cin&b));
	end 
endmodule //fulladder