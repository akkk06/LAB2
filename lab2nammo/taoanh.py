import cv2
import numpy as np

# Cấu hình phải khớp
WIDTH = 2048
HEIGHT = 1365

print("Đang đọc kết quả từ Verilog...")
# Tạo ma trận rỗng để chứa ảnh xám
img_gray = np.zeros((HEIGHT, WIDTH), dtype=np.uint8)

try:
    with open('Y_cols_out.txt', 'r') as f:
        lines = f.readlines()
        
        # Đảm bảo số lượng cột xuất ra đúng bằng WIDTH
        if len(lines) < WIDTH:
            print(f"Cảnh báo: File output chỉ có {len(lines)} cột!")
            
        for w, line in enumerate(lines):
            if w >= WIDTH: 
                break
                
            line = line.strip()
            
            # Verilog thỉnh thoảng bỏ các số 0 ở đầu nếu dùng %h
            # Ta cần đệm lại cho đủ (HEIGHT * 2) ký tự hex
            expected_len = HEIGHT * 2
            line = line.zfill(expected_len)
            
            # Đọc lại: Cắt từng 2 ký tự (1 byte). 
            # Vì lúc nạp vào ta lặp từ dưới lên (h = 255 -> 0)
            # Nên byte đầu tiên trong chuỗi chính là pixel h = 255.
            for h_idx in range(HEIGHT):
                start_idx = h_idx * 2
                end_idx = start_idx + 2
                hex_val = line[start_idx:end_idx]
                
                # Tính toán lại vị trí hàng (h) thật sự trên ảnh
                real_h = (HEIGHT - 1) - h_idx
                img_gray[real_h, w] = int(hex_val, 16)
                
    # Lưu và hiển thị ảnh
    cv2.imwrite('output_gray.jpg', img_gray)
    print("Thành công! Đã lưu ảnh kết quả vào 'output_gray.jpg'")
    
except FileNotFoundError:
    print("Lỗi: Không tìm thấy file 'Y_cols_out.txt'. Bạn đã chạy Verilog xong chưa?")