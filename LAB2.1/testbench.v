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

    // Khởi tạo module lọc
    lab21 dut(
        .p1(p1), .p2(p2), .p3(p3),
        .p4(p4), .p5(p5), .p6(p6),
        .p7(p7), .p8(p8), .p9(p9),
        .median(median_val)
    );

    initial begin
        // 1. Đọc file ảnh đầu vào (dưới dạng mã HEX)
        $readmemh("pic_input.txt", img_in);
        
        // 2. Mở file để ghi kết quả
        file_out = $fopen("pic_output.txt", "w");

        $display("Bat dau mo phong loc trung vi...");

        // 3. Quét TẤT CẢ pixel từ 0 đến 255
        for (i = 0; i < HEIGHT; i = i + 1) begin
            for (j = 0; j < WIDTH; j = j + 1) begin
                
                // Trường hợp 1: Pixel nằm ở rìa ngoài cùng của ảnh -> Xuất thẳng giá trị gốc
                if (i == 0 || i == HEIGHT - 1 || j == 0 || j == WIDTH - 1) begin
                    $fdisplay(file_out, "%02X", img_in[i*WIDTH + j]);
                end 
                // Trường hợp 2: Pixel nằm ở lõi ảnh -> Lấy 9 điểm lân cận đưa vào mạch
                else begin
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

                    // Ghi kết quả lọc ra file
                    $fdisplay(file_out, "%02X", median_val);
                end
                
            end
        end

        // 4. Đóng file và kết thúc
        $fclose(file_out);
        $display("Hoan tat! Da xuat day du 65536 pixel vao file pic_output.txt");
        $finish;
    end

endmodule
