# @ Author: firstfu
# @ Create Time: 2024-03-29 10:15:23
# @ Description: 高解析度 SVG 到 PNG 轉換工具

import os
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path


def ensure_dir_exists(dir_path):
    """確保目錄存在"""
    if not os.path.exists(dir_path):
        os.makedirs(dir_path)
        print(f"創建目錄: {dir_path}")


def high_quality_convert(svg_path, png_path, width=1024, height=1024, dpi=300):
    """使用多種工具嘗試高質量 SVG 到 PNG 轉換"""
    try:
        # 確保輸出目錄存在
        output_dir = os.path.dirname(png_path)
        ensure_dir_exists(output_dir)

        # 創建臨時目錄
        with tempfile.TemporaryDirectory() as temp_dir:
            success = False

            # 1. 嘗試使用 Inkscape (最高質量)
            try:
                print("嘗試使用 Inkscape 轉換...")
                cmd = ["inkscape", "--export-filename", png_path, "--export-width", str(width), "--export-height", str(height), "--export-dpi", str(dpi), svg_path]
                subprocess.run(cmd, capture_output=True, check=True)
                print("使用 Inkscape 成功轉換")
                success = True
            except (subprocess.SubprocessError, FileNotFoundError) as e:
                print(f"Inkscape 轉換失敗: {e}")

            # 2. 如果 Inkscape 失敗，嘗試使用 cairosvg
            if not success:
                try:
                    print("嘗試使用 cairosvg 轉換...")
                    import cairosvg

                    # 使用較高解析度 (2x size, 後面再調整)
                    cairosvg.svg2png(url=svg_path, write_to=png_path, output_width=width * 2, output_height=height * 2, scale=2)

                    # 如果需要優化尺寸，使用 PIL 調整
                    from PIL import Image

                    img = Image.open(png_path)
                    img = img.resize((width, height), Image.Resampling.LANCZOS)
                    img.save(png_path, optimize=True, quality=95)

                    print("使用 cairosvg 成功轉換")
                    success = True
                except Exception as e:
                    print(f"cairosvg 轉換失敗: {e}")

            # 3. 如果是 macOS，嘗試使用系統工具
            if not success and sys.platform.startswith("darwin"):
                try:
                    print("嘗試使用 macOS 系統工具轉換...")
                    # 創建臨時 PDF 文件 (macOS 處理 SVG 轉 PDF 效果好)
                    temp_pdf = os.path.join(temp_dir, "temp.pdf")

                    # 嘗試 sips 或 rsvg-convert
                    try:
                        # 先嘗試 rsvg-convert (需要安裝 librsvg)
                        subprocess.run(["rsvg-convert", "-f", "pdf", "-o", temp_pdf, svg_path], check=True)
                    except (subprocess.SubprocessError, FileNotFoundError):
                        # 如果失敗，使用 sips
                        subprocess.run(["sips", "-s", "format", "pdf", svg_path, "--out", temp_pdf], check=True)

                    # 使用 ImageMagick 的 convert 命令生成高質量 PNG
                    subprocess.run(["convert", "-density", str(dpi), temp_pdf, "-resize", f"{width}x{height}", "-quality", "100", "-background", "none", png_path], check=True)
                    print("使用 macOS 系統工具成功轉換")
                    success = True
                except Exception as e:
                    print(f"macOS 系統工具轉換失敗: {e}")

            if success:
                print(f"成功將 {svg_path} 轉換為 {png_path}")
                return True
            else:
                print("所有轉換方法都失敗了")
                return False

    except Exception as e:
        print(f"轉換過程中出錯: {e}")
        return False


def optimize_png(png_path):
    """優化 PNG 文件大小和質量"""
    try:
        # 使用 pngquant 優化 (如果安裝)
        try:
            print(f"優化 PNG 文件: {png_path}")
            subprocess.run(["pngquant", "--force", "--output", png_path, "--quality=90-100", "--strip", png_path], capture_output=True)
            print("PNG 優化成功")
        except (subprocess.SubprocessError, FileNotFoundError):
            # 如果 pngquant 不可用，嘗試使用 PIL 優化
            try:
                from PIL import Image

                img = Image.open(png_path)
                img.save(png_path, optimize=True, quality=95)
                print("使用 PIL 優化成功")
            except Exception as e:
                print(f"PNG 優化失敗: {e}")
    except Exception as e:
        print(f"PNG 優化過程中出錯: {e}")


def main():
    # 檢查命令行參數
    if len(sys.argv) > 1:
        svg_path = sys.argv[1]
    else:
        # 默認路徑
        svg_path = "assets/images/svg/logo.svg"

    # 檢查文件是否存在
    if not os.path.exists(svg_path):
        print(f"錯誤: 文件 {svg_path} 不存在")
        sys.exit(1)

    # 轉換為高質量 PNG
    png_path = "assets/icons/logo.png"
    if high_quality_convert(svg_path, png_path, width=1024, height=1024, dpi=600):
        # 優化 PNG
        optimize_png(png_path)

        # 創建 web 目錄的圖標
        print("創建 web 目錄的圖標...")
        web_icons_dir = "web/icons"
        ensure_dir_exists(web_icons_dir)

        # 創建 web 圖標
        high_quality_convert(svg_path, os.path.join(web_icons_dir, "Icon-512.png"), 512, 512, dpi=300)
        high_quality_convert(svg_path, os.path.join(web_icons_dir, "Icon-192.png"), 192, 192, dpi=300)
        high_quality_convert(svg_path, os.path.join(web_icons_dir, "Icon-maskable-512.png"), 512, 512, dpi=300)
        high_quality_convert(svg_path, os.path.join(web_icons_dir, "Icon-maskable-192.png"), 192, 192, dpi=300)

        print("圖標生成完成！")
        print("現在你可以運行以下命令來生成所有平台的圖標:")
        print("flutter pub run flutter_launcher_icons")
    else:
        print("圖標生成失敗，請檢查錯誤信息。")


if __name__ == "__main__":
    main()
