using F3M.Oticas.DTO.Enum;
using System;

namespace F3M.Oticas.DTO.Attributes
{
    [AttributeUsage(AttributeTargets.Property)]
    public sealed class FixedTextFileAttribute : Attribute
    {
        public readonly char Character;
        public readonly int Length;
        public readonly int StartAt;
        public readonly FixedTextFileAttributeJustification ValueJustification;


        public FixedTextFileAttribute(int startAt, int length, char character = ' ', FixedTextFileAttributeJustification justification = FixedTextFileAttributeJustification.Left)
        {
            StartAt = startAt - 1;
            Length = length;
            Character = character;
            ValueJustification = justification;
        }
    }
}
