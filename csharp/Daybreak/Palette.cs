using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Daybreak
{
    public class Palette : Dictionary<Color, NineBitColour>
    {
        public void AddMe(Color RGB24, int Index)
        {
            if (!ContainsKey(RGB24))
             base.Add(RGB24, new NineBitColour(RGB24, Convert.ToByte(Index)));
        }

        public byte GetIndex(Color RGB24)
        {
            NineBitColour x = this[RGB24];
            var y = x.GetType();
            return x.Index;
        }

        public List<byte> GetRGB9Palette()
        {
            var list = new List<byte>();

            var e3 = this.Values.FirstOrDefault(v => v.Index == 0xE3);
            var black = this.Values.FirstOrDefault(v => v.RGB24 == Color.Black);
            var black2 = this.Values.FirstOrDefault(v => v.Index == 0x74);
            if (black == null && black2 != null)
                black2.RGB24 = Color.Black;
            var theBlack = black == null ? black2 : black;

            for (int i = 0; i < 256; i++)
            {
                var col = this.Values.FirstOrDefault(v => v.Index == i);
                if (col == null)
                {
                    list.Add(e3.Index);
                    list.Add(e3.Index);
                    continue;
                }
                if (col == e3)
                {
                    list.Add(theBlack.RGB9ByteA);
                    list.Add(theBlack.RGB9ByteB);
                }
                else if (col == theBlack)
                {
                    list.Add(e3.RGB9ByteA);
                    list.Add(e3.RGB9ByteB);
                }
                else
                {
                    list.Add(col.RGB9ByteA);
                    list.Add(col.RGB9ByteB);
                }
            }
            return list;
        }
    }
}
