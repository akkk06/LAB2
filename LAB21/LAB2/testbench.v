`timescale 1ns/1ps
module tb_medianfilter;
    parameter width = 430;
    parameter height = 554;
    parameter pixel_cnt = width * height;

    reg clk;
    reg rst_n;
    reg valid_in;
    reg [7:0] pixel_in;
    wire [7:0] pixel_out;
    wire valid_out;
    reg [7:0] img_in [0:pixel_cnt-1]; //bo nho luu hoat anh

    integer read_ptr = 0;
    integer write_ptr = 0;
    integer file_out;

    medianfilter #(
        width, height
    ) dut (
        clk, rst_n, valid_in, pixel_in, valid_out, pixel_out
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $readmemh ("pic_input.txt", img_in);
        file_out = $fopen ("pic_output.txt", "w");
        rst_n = 0;
        valid_in = 0;
        pixel_in = 0;
        #20;
        rst_n = 1;
        $display("Bat dau dua luong du lieu vao...");
    end

 always @(posedge clk) begin //bom du lieu vao
        if (rst_n) begin
            if (read_ptr < pixel_cnt + width + 50) begin
                
                if (read_ptr < pixel_cnt) 
                    pixel_in <= img_in[read_ptr]; 
                else 
                    pixel_in <= 8'h00;       
                valid_in <= 1;
                read_ptr <= read_ptr + 1;
            end
            else begin
                valid_in <= 0;
            end
        end
    end

    always @(posedge clk ) begin //hut du lieu ra
        if (rst_n && valid_out) begin
            $fdisplay (file_out, "%02X", pixel_out);
            write_ptr <= write_ptr + 1;
            if (write_ptr == pixel_cnt - 1) begin
                $display ("Hoan tat");
                $fclose (file_out);
                #10
                $finish;
            end
        end
    end
endmodule