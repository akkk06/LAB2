module lab22 #(
		parameter signed [8:0] brightness = 0
)(
		input clk,
		input rst_n,
		input valid_in,
		input [7:0] R, G, B,
		output reg [7:0] Y,
		output reg valid_out
);
		wire [17:0] r_mult = R * 18'd306;
		wire [17:0] g_mult = G * 18'd601;
		wire [17:0] b_mult = B * 18'd117;
		
		wire [17:0] sum = r_mult + g_mult + b_mult;
		wire [7:0] gray_base = sum[17:10];
		
		wire signed [9:0] gray_bright = $signed({1'b0,gray_base}) + $signed(brightness);
		
		always @(posedge clk or negedge rst_n) begin
			if ( !rst_n ) begin
				Y <= 8'd0;
				valid_out <= 1'b0;
			end
			else if (valid_in) begin
				valid_out <= 1'b1;
				if ( gray_bright > 255 ) Y <= 8'd255;
				else if ( gray_bright < 0 ) Y <= 8'd0;
				else Y <= gray_bright[7:0];
			end
			else begin
				valid_out <= 1'b0;
			end
		end
endmodule
		
