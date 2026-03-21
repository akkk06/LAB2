`timescale 1ns/1ps

module testbench();

    // 1. Khai báo các tín hiệu kết nối với DUT (Device Under Test)
    reg clk;
    reg rst_n;
    reg [7:0] R, G, B;
    reg valid_in;
    wire [7:0] Y;
    wire valid_out;

    // Các biến dùng để quản lý file
    integer fd_in, fd_out, scan_file;

    // 2. Khởi tạo module xử lý ảnh (DUT)
    rgb2gray #(
        .BRIGHTNESS(0) // Bạn có thể thay đổi số này (VD: 20, -10) để test chỉnh độ sáng
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .R(R),
        .G(G),
        .B(B),
        .valid_in(valid_in),
        .Y(Y),
        .valid_out(valid_out)
    );

    // 3. Tạo xung Clock (Chu kỳ 10ns -> Tần số 100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // 4. Khối xử lý chính: Đọc dữ liệu và điều khiển mô phỏng
    initial begin
        // Mở file ảnh đầu vào (đọc)
        fd_in = $fopen("rgb_input.txt", "r");
        if (fd_in == 0) begin
            $display("LỖI: Không thể mở file rgb_input.txt. Hãy kiểm tra lại đường dẫn!");
            $stop;
        end
        
        // Mở/Tạo file ảnh đầu ra (ghi)
        fd_out = $fopen("gray_output.txt", "w");
        if (fd_out == 0) begin
            $display("LỖI: Không thể tạo file gray_output.txt!");
            $stop;
        end

        // Khởi tạo các giá trị ban đầu (Reset hệ thống)
        rst_n = 0;
        valid_in = 0;
        R = 0; G = 0; B = 0;

        // Giữ reset trong 20ns rồi nhả ra để mạch bắt đầu hoạt động
        #20 rst_n = 1;
        #10; // Đợi thêm 1 chu kỳ clock

        // Vòng lặp đọc file cho đến khi kết thúc (End Of File)
        while (!$feof(fd_in)) begin
            // Đưa dữ liệu vào tại sườn âm của clock (để đảm bảo ổn định khi mạch đọc ở sườn dương)
            @(negedge clk); 
            
            // Đọc 3 giá trị Hex từ 1 dòng của file text
            scan_file = $fscanf(fd_in, "%x %x %x\n", R, G, B);
            
            if (scan_file == 3) begin
                valid_in = 1; // Báo cho module biết dữ liệu đã hợp lệ
            end else begin
                valid_in = 0;
            end
        end

        // Khi đọc hết file, ngắt tín hiệu valid_in
        @(negedge clk);
        valid_in = 0;
        
        // Đợi thêm vài chu kỳ clock để module xử lý nốt điểm ảnh cuối cùng
        #50;
        
        // Đóng file và kết thúc mô phỏng
        $fclose(fd_in);
        $fclose(fd_out);
        $display("HOÀN TẤT: Mô phỏng thành công! Dữ liệu đã được xuất ra gray_output.txt.");
        $stop;
    end

    // 5. Khối ghi dữ liệu: Bắt kết quả đầu ra
    // Bất cứ khi nào valid_out nhảy lên 1, ta ghi giá trị Y vào file output
    always @(posedge clk) begin
        if (valid_out) begin
            // Ghi giá trị Y dưới dạng Hex, đảm bảo luôn có 2 ký tự (VD: 0a, ff)
            $fdisplay(fd_out, "%02x", Y);
        end
    end

endmodule