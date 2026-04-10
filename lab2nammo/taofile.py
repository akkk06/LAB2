import cv2
import numpy as np

print("Đang đọc và xử lý ảnh...")
# 1. Đọc ảnh gốc
img = cv2.imread('baitap2_anhgoc.jpg')
if img is None:
    print("Lỗi: Không tìm thấy file 'baitap2_anhgoc.jpg'")
    exit()

# 2. Tự động lấy kích thước gốc (Không dùng cv2.resize nữa)
HEIGHT, WIDTH, _ = img.shape
img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)

print(f"Kích thước ảnh thật: Rộng (WIDTH) = {WIDTH}, Cao (HEIGHT) = {HEIGHT}")
print("!!! HÃY COPY HAI SỐ NÀY VÀO PARAMETER TRONG VERILOG !!!")

# 3. Xuất file txt
with open('R_cols.txt', 'w') as f_r, \
     open('G_cols.txt', 'w') as f_g, \
     open('B_cols.txt', 'w') as f_b:
     
    for w in range(WIDTH):
        str_r, str_g, str_b = "", "", ""
        for h in range(HEIGHT - 1, -1, -1):
            str_r += f"{img[h, w, 0]:02x}"
            str_g += f"{img[h, w, 1]:02x}"
            str_b += f"{img[h, w, 2]:02x}"
            
        f_r.write(str_r + "\n")
        f_g.write(str_g + "\n")
        f_b.write(str_b + "\n")

print("Hoàn tất xuất file!")