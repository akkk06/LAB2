module sort3 (
		input [7:0] a,b,c,
		output [7:0] min, med, max
);
		wire [7:0] min_ab, max_ab, min_abc;
		sort2 s1(a, b, min_ab, max_ab);
		sort2 s2(max_ab, c, min_abc, max); 
		sort2 s3(min_ab, min_abc, min, med);
endmodule