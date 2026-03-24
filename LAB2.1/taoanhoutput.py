import cv2
import numpy as np
from skimage.metrics import structural_similarity as ssim
from skimage.metrics import peak_signal_noise_ratio as psnr

def hex_to_image(input_txt_path, output_image_path, original_image_path, width=256, height=256):
    print("Dang tai tao anh tu file du lieu Verilog...")
    
    # 1. Đọc file txt chứa mã Hex
    with open(input_txt_path, 'r') as f:
        lines = f.readlines()
        
    # 2. Chuyển đổi mã Hex thành số nguyên (integer)
    pixel_values = [int(line.strip(), 16) for line in lines if line.strip()]
    
    if len(pixel_values) != width * height:
        print(f"Canh bao: So luong pixel ({len(pixel_values)}) khong khop voi kich thuoc {width}x{height}.")
    
    # 3. Tạo ma trận ảnh từ mảng pixel và lưu lại
    pixel_array = np.array(pixel_values[:width*height], dtype=np.uint8)
    img_out = pixel_array.reshape((height, width))
    
    cv2.imwrite(output_image_path, img_out)
    print(f"Da luu anh ket qua tai: {output_image_path}")
    
    # 4. Tính toán PSNR và SSIM
    img_original = cv2.imread(original_image_path, cv2.IMREAD_GRAYSCALE)
    if img_original is not None:
        psnr_val = psnr(img_original, img_out)
        ssim_val = ssim(img_original, img_out)
        
        print("-" * 30)
        print("DANH GIA CHAT LUONG ANH SAU KHI LOC:")
        print(f"PSNR (cang cao cang tot): {psnr_val:.2f} dB")
        print(f"SSIM (gan 1.0 la hoan hao): {ssim_val:.4f}")
        print("-" * 30)
        
        # Hiển thị ảnh để so sánh bằng mắt thường
        cv2.imshow("Anh Goc (Nhieu)", img_original)
        cv2.imshow("Anh Sau Khi Loc (Verilog)", img_out)
        print("Bam phim bat ky tren cua so anh de dong chuong trinh...")
        cv2.waitKey(0)
        cv2.destroyAllWindows()
    else:
        print("Loi: Khong tim thay file anh goc (input_resized_gray.jpg) de so sanh!")

# --- Thực thi ---
hex_to_image('pic_output.txt', 'output_filtered.jpg', 'input_resized_gray.jpg', width=256, height=256)