using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Imaging;

namespace Daybreak
{
    public class Program
    {
        public const int BANKSIZE = 0x2000;
        public static List<byte> palettes = new List<Byte>();

        public static void Main(string[] args)
        {
            Sprites("full.png", 0, 32, 31, false);
            Middle("full.png", 32, 256, 18);
            Sprites("full.png", 288, 32, 32, true);
            Palette(30, palettes);
        }

        public static void Middle(string FileName, int Left, int Width, int StartBank)
        {
            string path = Path.GetDirectoryName(new Uri(Assembly.GetExecutingAssembly().CodeBase).LocalPath);
            string inFile = Path.Combine(path, "..", "..", "..", "..", "images", "Daybreak", FileName);
            string outBank = Path.Combine(path, "..", "..", "..", "..", "banks", "bank{0}.bin");
            var pal = new Palette();
            var bytes = new List<Byte>();
            using (var img = Bitmap.FromFile(inFile, true) as Bitmap)
            {
                for (int i = 0; i < img.Palette.Entries.Length; i++)
                    pal.AddMe(img.Palette.Entries[i], i);

                var e3 = pal.Values.FirstOrDefault(v => v.Index == 0xE3);
                var black = pal.Values.FirstOrDefault(v => v.RGB24 == Color.Black);
                var black2 = pal.Values.FirstOrDefault(v => v.Index == 0x74);

                for (int y = 0; y < img.Height; y++)
                {
                    for (int x = Left; x < Left + Width; x++)
                    {
                        var px = img.GetPixel(x, y);
                        if (black != null && px == black.RGB24)
                        {
                            bytes.Add(pal.GetIndex(e3.RGB24));
                        }
                        else if (black2 != null && px == black2.RGB24)
                        {
                            bytes.Add(pal.GetIndex(e3.RGB24));
                        }
                        else if (e3 != null && px == e3.RGB24)
                        {
                            if (black != null)
                                bytes.Add(pal.GetIndex(black.RGB24));
                            else
                                bytes.Add(pal.GetIndex(black2.RGB24));
                        }
                        else
                        {
                            bytes.Add(pal.GetIndex(px));
                        }
                    }
                }
                for (int i = 0; i < 6; i++)
                {
                    string fn = string.Format(outBank, StartBank + i);
                    var dir = Path.GetDirectoryName(fn);
                    if (!Directory.Exists(dir))
                        Directory.CreateDirectory(dir);
                    var bank = bytes.GetRange(BANKSIZE * i, BANKSIZE).ToArray();
                    File.WriteAllBytes(fn, bank);
                }
                palettes.AddRange(pal.GetRGB9Palette());
            }
        }

        public static void Palette(int Bank, List<byte> Bytes)
        {
            string path = Path.GetDirectoryName(new Uri(Assembly.GetExecutingAssembly().CodeBase).LocalPath);
            string outBank = Path.Combine(path, "..", "..", "..", "..", "banks", "bank{0}.bin");
            string fn = string.Format(outBank, Bank);
            var dir = Path.GetDirectoryName(fn);
            if (!Directory.Exists(dir))
                Directory.CreateDirectory(dir);
            File.WriteAllBytes(fn, Bytes.ToArray());
        }

        public static void Sprites(string FileName, int Left, int Width, int StartBank, bool SavePalette)
        {
            string path = Path.GetDirectoryName(new Uri(Assembly.GetExecutingAssembly().CodeBase).LocalPath);
            string inFile = Path.Combine(path, "..", "..", "..", "..", "images", "Daybreak", FileName);
            string outBank = Path.Combine(path, "..", "..", "..", "..", "banks", "bank{0}.bin");
            var pal = new Palette();
            var bytes = new List<Byte>();
            using (var img = Bitmap.FromFile(inFile, true) as Bitmap)
            {
                for (int i = 0; i < img.Palette.Entries.Length; i++)
                    pal.AddMe(img.Palette.Entries[i], i);

                var e3 = pal.Values.FirstOrDefault(v => v.Index == 0xE3);
                var black = pal.Values.FirstOrDefault(v => v.RGB24 == Color.Black);
                var black2 = pal.Values.FirstOrDefault(v => v.Index == 0x74);

                int hnum = Width / 16;
                int vnum = img.Height / 16;
                for (int y = 0; y < vnum; y++)
                {
                    for (int x = 0; x < hnum; x++)
                    {
                        var x1 = Left + (x * 16);
                        var y1 = y * 16;
                        for (int y2 = y1; y2 < y1 + 16; y2++)
                        {
                            for (int x2 = x1; x2 < x1 + 16; x2++)
                            {
                                var px = img.GetPixel(x2, y2);
                                if (black != null && px == black.RGB24)
                                {
                                    bytes.Add(pal.GetIndex(e3.RGB24));
                                }
                                else if (black2 != null && px == black2.RGB24)
                                {
                                    bytes.Add(pal.GetIndex(e3.RGB24));
                                }
                                else if (e3 != null && px == e3.RGB24)
                                {
                                    if (black != null)
                                        bytes.Add(pal.GetIndex(black.RGB24));
                                    else
                                        bytes.Add(pal.GetIndex(black2.RGB24));
                                }
                                else
                                {
                                    bytes.Add(pal.GetIndex(px));
                                }
                            }
                        }
                    }
                }
                if (SavePalette)
                    palettes.AddRange(pal.GetRGB9Palette());
                string fn = string.Format(outBank, StartBank);
                var dir = Path.GetDirectoryName(fn);
                if (!Directory.Exists(dir))
                    Directory.CreateDirectory(dir);
                File.WriteAllBytes(fn, bytes.ToArray());
            }
        }
    }
}
