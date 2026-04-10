module rgbgray #(
    parameter HEIGHT = 1365
) (
    input clk,
    input signed [8:0] brightness,
    input [(HEIGHT*8)-1:0] colR,
    input [(HEIGHT*8)-1:0] colG,
    input [(HEIGHT*8)-1:0] colB,
    output reg [(HEIGHT*8)-1:0] colY
);

    genvar i;
    generate
        for ( i=0; i<HEIGHT; i=i+1 ) begin: block
            reg [15:0] rmul_reg, gmul_reg, bmul_reg;
            reg [15:0] sumy_reg;
            
            wire [7:0] r = colR[i*8 +: 8];
            wire [7:0] g = colG[i*8 +: 8];
            wire [7:0] b = colB[i*8 +: 8];
            reg [7:0] y;
            reg signed [9:0] ketqua;

            always @(posedge clk) begin
                //stage1
                rmul_reg <= r*8'd76;
                gmul_reg <= g*8'd150;
                bmul_reg <= b*8'd29;
                //stage2
                sumy_reg <= rmul_reg+gmul_reg+bmul_reg;
                //stage3
                begin
                    ketqua = $signed({1'b0,sumy_reg[15:8]})+brightness;
                    if (ketqua>10'sd255) y=8'd255;
                    else if (ketqua<10'sd0) y=8'd0;
                    else y=ketqua[7:0];
                end
                colY[i*8 +: 8] <= y;
            end
        end
    endgenerate
    
endmodule