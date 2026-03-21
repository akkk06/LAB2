`timescale 1ns / 1ps

module tb_median_filter;

    // Thay đổi thông số này khớp với kích thước ảnh bạn tạo từ Matlab/Python
    parameter WIDTH = 256; 
    parameter HEIGHT = 256;
    parameter PIXEL_COUNT = WIDTH * HEIGHT;

    // Bộ nhớ lưu ảnh
    reg [7:0] img_in [0:PIXEL_COUNT-1];
    
    // Tín hiệu kết nối với module
    reg [7:0] p1, p2, p3, p4, p5, p6, p7, p8, p9;
    wire [7:0] median_val;

    integer file_out;
    integer i, j;
    integer idx;

    // Khởi tạo module lọc
    lab21 dut(
        .p1(p1), .p2(p2), .p3(p3),
        .p4(p4), .p5(p5), .p6(p6),
        .p7(p7), .p8(p8), .p9(p9),
        .median(median_val)
    );

    initial begin
        // 1. Đọc file ảnh đầu vào (dưới dạng mã HEX, mỗi dòng 1 pixel)
        $readmemh("pic_input.txt", img_in);
        
        // 2. Mở file để ghi kết quả
        file_out = $fopen("pic_output.txt", "w");

        $display("Bat dau mo phong loc trung vi...");

        // 3. Quét cửa sổ 3x3 qua ảnh (Bỏ qua các viền sát cạnh ảnh để đơn giản hóa)
        for (i = 1; i < HEIGHT - 1; i = i + 1) begin
            for (j = 1; j < WIDTH - 1; j = j + 1) begin
                
                // Lấy 9 điểm ảnh lân cận
                p1 = img_in[(i-1)*WIDTH + (j-1)];
                p2 = img_in[(i-1)*WIDTH + j];
                p3 = img_in[(i-1)*WIDTH + (j+1)];
                
                p4 = img_in[i*WIDTH + (j-1)];
                p5 = img_in[i*WIDTH + j];      // Điểm ảnh trung tâm
                p6 = img_in[i*WIDTH + (j+1)];
                
                p7 = img_in[(i+1)*WIDTH + (j-1)];
                p8 = img_in[(i+1)*WIDTH + j];
                p9 = img_in[(i+1)*WIDTH + (j+1)];

                // Chờ một chút thời gian để combinational logic tính toán
                #10; 

                // 4. Ghi kết quả ra file (Định dạng HEX)
                $fdisplay(file_out, "%02X", median_val);
            end
        end

        // 5. Đóng file và kết thúc
        $fclose(file_out);
        $display("Hoan tat. Da xuat ra file pic_output.txt");
        $finish;
    end

endmodule