module findMedian ( 
		input [7:0] p1, p2, p3, p4, p5, p6, p7, p8, p9,
		output [7:0] median
);
		wire [7:0] min1, med1, max1, min2, med2, max2, min3, med3, max3;
		sort3 inst1 ( p1, p2, p3, min1, med1, max1 );
		sort3 inst2 ( p4, p5, p6, min2, med2, max2 );
		sort3 inst3 ( p7, p8, p9, min3, med3, max3 );
		wire [7:0] unusedmin1, unusedmed1, maxofmin;
		wire [7:0] unuseddmin2, medofmed, unusedmax2;
		wire [7:0] minofmax, unusedmed3, unusedmax3;
		sort3 inst4 ( min1, min2, min3, unusedmin1, unusedmed1, maxofmin );
		sort3 inst5 ( med1, med2, med3, unuseddmin2, medofmed, unusedmax2 );
		sort3 inst6 ( max1, max2, max3, minofmax, unusedmed3, unusedmax3 );
		wire [7:0] finalmin, finalmax;
		sort3 inst7 ( maxofmin, medofmed, minofmax, finalmin, median, finalmax );	
endmodule