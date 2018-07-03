using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace PaletteGenerator
{
    class Program
    {
        static void Main(string[] args)
        {
            string path = Path.GetDirectoryName(new Uri(Assembly.GetExecutingAssembly().CodeBase).LocalPath);
            string outFile = Path.Combine(path, "..", "..", "..", "..", "images", "PaletteGenerator", "Palette333.png");
            var dir = Path.GetDirectoryName(outFile);
            if (!Directory.Exists(dir))
                Directory.CreateDirectory(dir);
            var bytes = new List<Byte>();
            using (var img = new Bitmap(257, 193))
            {
                using (Graphics g = Graphics.FromImage(img))
                {
                    int i = 0;
                    for (int v = 0; v < 32; v++)
                    {
                        for (int h = 0; h < 16; h++)
                        {
                            int r3 = (i & 448) >> 6;
                            int g3 = (i & 56) >> 3;
                            int b3 = i & 7;
                            int r8 = r3 + (r3 << 3) + ((r3 & 6) << 5);
                            int g8 = g3 + (g3 << 3) + ((g3 & 6) << 5);
                            int b8 = b3 + (b3 << 3) + ((b3 & 6) << 5);
                            var rgb888 = Color.FromArgb(r8, g8, b8);
                            using (var brush = new SolidBrush(rgb888))
                                g.FillRectangle(brush, h * 16, v * 6, 16, 6);
                            i++;
                        }
                    }
                    using (var pen = new Pen(Color.FromArgb(128, 128, 128)))
                    {
                        for (int h = 0; h <= 16; h++)
                            g.DrawLine(pen, h * 16, 0, h * 16, 192);
                        for (int v = 0; v <= 32; v++)
                            g.DrawLine(pen, 0, v * 6, 255, v * 6);
                    }
                }
                img.Save(outFile, ImageFormat.Png);
            }
        }
    }
}
