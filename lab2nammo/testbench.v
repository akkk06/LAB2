
`timescale 1ns/1ps

module testbench;

    parameter WIDTH = 10;
    parameter HEIGHT = 10;
    reg clk;
    reg signed [8:0] brightness;

    reg [(HEIGHT*8)-1:0] R [0:WIDTH-1];
    reg [(HEIGHT*8)-1:0] G [0:WIDTH-1];
    reg [(HEIGHT*8)-1:0] B [0:WIDTH-1];

    reg [(HEIGHT*8)-1:0] colR, colG, colB;
    wire [(HEIGHT*8)-1:0] colY;
    integer count;
    integer write;

    lab2nammo  DUT (
        clk, brightness, colR, colG, colB, colY
    );

    always #15 clk = ~clk;

    initial begin
        clk = 0;
        count = 0;
        brightness = 9'd0;
        $readmemh ("R_cols.txt", R);
        $readmemh ("G_cols.txt", G);
        $readmemh ("B_cols.txt", B);
        write = $fopen ("Y_cols_out.txt", "w");
        $display ("Bat dau mo phong");
    end

    always @(negedge clk) begin
        if ( count < WIDTH ) begin
            colR <= R[count];
            colG <= G[count];
            colB <= B[count];
        end
        if ( count == WIDTH+3 ) begin
            $fclose (write);
            $display ("Mo phong hoan tat");
            $finish;
        end
        count <= count + 1;
    end

    always @(negedge clk) begin
        if (count >= 3  && count < WIDTH+3) begin
            $fdisplay (write, "%h", colY);
        end
    end

endmodule
