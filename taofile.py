import cv2
import os

# 1. Khai báo đường dẫn TUYỆT ĐỐI (chắc chắn 100% không bị lạc file)
# LƯU Ý: Bạn hãy thay đổi chữ 'ten_anh_cua_ban.jpg' cho đúng với tên file ảnh thực tế bạn đang có trong C:\LAB2.2
duong_dan_anh = r"C:\LAB2.2\baitap2_anhgoc.jpg" 
duong_dan_file_text = r"C:\LAB2.2\rgb_input.txt"

print(f"Đang tìm ảnh tại: {duong_dan_anh}")

# 2. Thử đọc ảnh
img = cv2.imread(duong_dan_anh)

# 3. Kiểm tra xem có tìm thấy ảnh không
if img is None:
    print("❌ LỖI: Không tìm thấy ảnh!")
    print("Hãy kiểm tra lại xem tên ảnh bạn nhập trong code có khớp CHÍNH XÁC với tên file ảnh trong thư mục không (lưu ý đuôi .jpg hay .png).")
else:
    print("✅ Đã tìm thấy ảnh! Đang tiến hành chuyển đổi sang mã Hex...")
    img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    height, width, channels = img.shape

    # 4. Ghi file text
    with open(duong_dan_file_text, 'w') as f:
        for y in range(height):
            for x in range(width):
                r, g, b = img[y, x]
                f.write(f"{r:02x} {g:02x} {b:02x}\n")
    
    print(f"🎉 THÀNH CÔNG! Đã xuất {height * width} pixel ra file tại: {duong_dan_file_text}")