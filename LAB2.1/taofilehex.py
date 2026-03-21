import cv2

def image_to_hex(image_path, output_txt_path, width=256, height=256):
    print("Đang đọc và xử lý ảnh...")
    
    # 1. Đọc ảnh và tự động chuyển sang ảnh xám (Grayscale)
    img = cv2.imread(image_path, cv2.IMREAD_GRAYSCALE)
    
    if img is None:
        print("Lỗi: Không tìm thấy ảnh. Vui lòng kiểm tra lại đường dẫn!")
        return

    # 2. Resize ảnh về kích thước cố định (phải khớp với Testbench trong Verilog)
    img_resized = cv2.resize(img, (width, height))
    
    # Lưu lại ảnh input đã resize để lát nữa so sánh PSNR/SSIM
    cv2.imwrite("input_resized_gray.jpg", img_resized)

    # 3. Ghi giá trị pixel ra file text dưới dạng Hexadecimal
    with open(output_txt_path, 'w') as f:
        for row in img_resized:
            for pixel in row:
                # Định dạng hex 2 chữ số (VD: 255 -> FF, 10 -> 0A)
                hex_val = f"{pixel:02X}" 
                f.write(hex_val + '\n')
                
    print(f"Thành công! Đã xuất file {output_txt_path} ({width}x{height} pixels).")

# --- Thực thi ---
# Thay 'your_image.jpg' bằng tên ảnh nhiễu bạn muốn lọc
image_to_hex('baitap1_nhieu.jpg', 'pic_input.txt', width=256, height=256)