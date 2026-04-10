import cv2

def image_to_hex(image_path, output_txt_path):
    print("Đang đọc và xử lý ảnh...")
    
    # 1. Đọc ảnh và tự động chuyển sang ảnh xám (Grayscale)
    img = cv2.imread(image_path, cv2.IMREAD_GRAYSCALE)
    
    if img is None:
        print("Lỗi: Không tìm thấy ảnh. Vui lòng kiểm tra lại đường dẫn!")
        return

    # 2. Lấy kích thước gốc của ảnh
    height, width = img.shape
    
    # Lưu lại ảnh input (đã chuyển xám) để lát nữa so sánh PSNR/SSIM
    cv2.imwrite("input_gray.jpg", img)

    # 3. Ghi giá trị pixel ra file text dưới dạng Hexadecimal
    with open(output_txt_path, 'w') as f:
        for row in img:
            for pixel in row:
                # Định dạng hex 2 chữ số (VD: 255 -> FF, 10 -> 0A)
                hex_val = f"{pixel:02X}" 
                f.write(hex_val + '\n')
                
    print(f"Thành công! Đã xuất file {output_txt_path} với kích thước gốc ({width}x{height} pixels).")

# --- Thực thi ---
# Cung cấp đúng tên ảnh nhiễu bạn muốn xử lý
image_to_hex('baitap1_nhieu.jpg', 'pic_input.txt')