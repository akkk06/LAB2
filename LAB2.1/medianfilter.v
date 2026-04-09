module medianfilter #(
    parameter width = 256,
    parameter height = 256
)(
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] pixel_in,
    output reg valid_out,
    output reg [7:0] pixel_out
);

    reg [7:0] line_buffer1 [0:width-1];
    reg [7:0] line_buffer2 [0:width-1];
    reg [7:0] p1, p2, p3, p4, p5, p6, p7, p8, p9;
    reg [15:0] col_p9, row_p9;
    reg [15:0] col_p5, row_p5;
    reg [15:0] delay;
    reg ready;

    wire [7:0] median;
    findMedian inst1 (p1, p2, p3, p4, p5, p6, p7, p8, p9, median);

    always @(posedge clk or negedge rst_n) begin
        if (rst_n==0) begin
            col_p9 <= 0;
            row_p9 <= 0;
            col_p5 <= 0;
            row_p5 <= 0;
            valid_out <= 0;
            pixel_out <= 0;
            delay <= 0;
            ready <= 0;
        end
        else if (valid_in==1) begin
            p9 <= pixel_in;
            p8 <= p9;
            p7 <= p8;
            p6 <= line_buffer1[col_p9];
            p5 <= p6;
            p4 <= p5;
            p3 <= line_buffer2[col_p9];
            p2 <= p3;
            p1 <= p2;

            line_buffer1[col_p9] <= pixel_in;
            line_buffer2[col_p9] <= line_buffer1[col_p9];

            if (col_p9 == width-1) begin
                col_p9 <= 0;
                if (row_p9 == height - 1) row_p9 <= 0;
                else row_p9 <= row_p9 + 1;
            end
            else col_p9 <= col_p9 + 1;

            if (ready==0) begin
                if (delay == width + 2) ready <= 1;
                else delay <= delay + 1;
            end

            if (ready==1 || delay == width + 2) begin
                valid_out <= 1;
                if (row_p5 == 0 || row_p5 == height - 1 || col_p5 == 0 || col_p5 == width - 1) pixel_out <= p5;
                else pixel_out <= median;

                if (col_p5 == width - 1) begin
                    col_p5 <= 0;
                    if (row_p5 == height - 1) row_p5 <= 0;
                    else row_p5 <= row_p5 + 1;
                end
                else col_p5 <= col_p5 + 1;
            end


        end
        else valid_out <= 0;
    end
endmodule
