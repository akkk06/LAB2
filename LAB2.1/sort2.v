module sort2 ( 
		input [7:0] a,b,
		output [7:0] min,max
 );
		assign min = ( a > b ) ? b : a;
		assign max = ( a > b ) ? a : b;
endmodule
