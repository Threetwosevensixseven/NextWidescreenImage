using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.VisualStudio.Modeling.Diagrams;

namespace Daybreak
{
    public class NineBitColour
    {
        public Color RGB24 { get; set; }
        public byte Index { get; set; }
        public NineBitColour(Color RGB24, byte Index)
        {
            this.RGB24 = RGB24;
            this.Index = Index;
        }

        public HslColor HSL24
        {
            get
            {
                return HslColor.FromRgbColor(RGB24);
            }
        }
        public byte RGB9ByteA
        {
            get
            {
                var r = RGB24.R & 224; 
                var g = (RGB24.G & 224) >> 3;
                var b = (RGB24.B & 192) >> 6;
                return Convert.ToByte(r + g + b);
            }
        }

        public byte RGB9ByteB
        {
            get
            {
                var b = RGB24.B & 1;
                return Convert.ToByte(b);
            }
        }
    }
}
