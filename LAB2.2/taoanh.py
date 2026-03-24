import numpy as np
import cv2

# 1. Đường dẫn tới file ảnh GỐC và file text ngõ ra
# LƯU Ý: Thay 'ten_anh_cua_ban.jpg' cho đúng với ảnh gốc của bạn
duong_dan_anh_goc = r"C:\LAB2.2\baitap2_anhgoc.jpg"
duong_dan_file_text = r"C:\LAB2.2\gray_output.txt"

# 2. Tự động lấy kích thước từ ảnh gốc
original_img = cv2.imread(duong_dan_anh_goc)
if original_img is None:
    print("LỖI: Không đọc được ảnh gốc để lấy kích thước!")
    exit()
    
height, width, _ = original_img.shape
print(f"Đã tự động nhận diện khung ảnh: {width} x {height}")

# 3. Đọc dữ liệu điểm ảnh từ Verilog
with open(duong_dan_file_text, 'r') as f:
    lines = f.readlines()

# 4. Gom dữ liệu và tạo ảnh
pixel_data = [int(line.strip(), 16) for line in lines]
image_array = np.array(pixel_data, dtype=np.uint8)

# Định hình lại mảng theo kích thước tự động
gray_image = image_array.reshape((height, width))

# 5. Lưu và hiển thị kết quả
cv2.imwrite(r"C:\LAB2.2\output_gray_image.jpg", gray_image)
print("Thành công! Đã lưu ảnh output_gray_image.jpg")
cv2.namedWindow('Anh Xam Tu Verilog', cv2.WINDOW_NORMAL)


cv2.resizeWindow('Anh Xam Tu Verilog', 800, 600)
cv2.imshow('Anh Xam Tu Verilog', gray_image)
cv2.waitKey(0)
cv2.destroyAllWindows()