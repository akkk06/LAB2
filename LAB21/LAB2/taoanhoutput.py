import cv2
import numpy as np
from skimage.metrics import structural_similarity as ssim
from skimage.metrics import peak_signal_noise_ratio as psnr

def hex_to_image(input_txt_path, output_image_path, width, height, original_image_path=None):
    print("Đang tái tạo ảnh từ file dữ liệu Verilog...")
    
    # 1. Đọc file txt chứa mã Hex
    with open(input_txt_path, 'r') as f:
        lines = f.readlines()
        
    # 2. Chuyển đổi mã Hex thành số nguyên (integer)
    pixel_values = [int(line.strip(), 16) for line in lines if line.strip()]
    
    # Kiểm tra xem dữ liệu có khớp với khung ảnh không
    total_pixels = width * height
    if len(pixel_values) != total_pixels:
        print(f"Cảnh báo: Số lượng pixel ({len(pixel_values)}) không khớp với kích thước truyền vào {width}x{height} ({total_pixels} pixels).")
    
    # 3. Tạo ma trận ảnh từ mảng pixel và lưu lại
    # Cắt mảng pixel_values cho vừa với kích thước phòng trường hợp Verilog xuất dư dòng
    pixel_array = np.array(pixel_values[:total_pixels], dtype=np.uint8)
    
    try:
        # Tái tạo lại ma trận 2D dựa trên width và height được truyền vào
        img_out = pixel_array.reshape((height, width))
    except ValueError:
        print("Lỗi: Dữ liệu pixel không đủ để nặn lại thành khung ảnh!")
        return
        
    cv2.imwrite(output_image_path, img_out)
    print(f"Đã lưu ảnh kết quả tại: {output_image_path} (Kích thước: {width}x{height})")
    
    # 4. Tính toán PSNR và SSIM (Chỉ chạy nếu bạn truyền đường dẫn ảnh gốc vào)
    if original_image_path:
        img_original = cv2.imread(original_image_path, cv2.IMREAD_GRAYSCALE)
        
        if img_original is not None:
            # Kiểm tra xem ảnh gốc có cùng kích thước với ảnh xuất ra không
            if img_original.shape == (height, width):
                psnr_val = psnr(img_original, img_out)
                ssim_val = ssim(img_original, img_out)
                
                print("-" * 30)
                print("ĐÁNH GIÁ CHẤT LƯỢNG ẢNH SAU KHI LỌC:")
                print(f"PSNR (càng cao càng tốt): {psnr_val:.2f} dB")
                print(f"SSIM (gần 1.0 là hoàn hảo): {ssim_val:.4f}")
                print("-" * 30)
                
                # Hiển thị ảnh để so sánh bằng mắt thường
                cv2.imshow("Anh Goc", img_original)
                cv2.imshow("Anh Sau Khi Loc (Verilog)", img_out)
                print("Bấm phím bất kỳ trên cửa sổ ảnh để đóng chương trình...")
                cv2.waitKey(0)
                cv2.destroyAllWindows()
            else:
                print(f"Cảnh báo: Không thể tính PSNR/SSIM do ảnh gốc {img_original.shape} không khớp với kích thước truyền vào ({height}, {width}).")
        else:
            print(f"Lỗi: Không tìm thấy file ảnh gốc tại '{original_image_path}' để so sánh.")

# --- Thực thi ---
# Truyền cứng tham số width và height vào. 
# Ảnh gốc 'input_gray.jpg' vẫn được giữ lại để đánh giá chất lượng (nếu không cần đánh giá, bạn có thể xóa tham số này đi).
hex_to_image('pic_output.txt', 'output_filtered.jpg', width=430, height=554, original_image_path='baitap1_nhieu.jpg')