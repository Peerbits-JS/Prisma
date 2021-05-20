using F3M.Oticas.DTO;
using F3M.Oticas.DTO.Attributes;
using F3M.Oticas.DTO.Enum;
using F3M.Oticas.Interfaces.Application.Services;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;

namespace F3M.Oticas.Application.Services
{
    public class AccountingExportService : IAccountingExportService
    {
        public byte[] ExportAccountingCblle(IEnumerable<AccountingExportFile> accountingExportFiles)
        {
            var cblles = accountingExportFiles.Select(accountingExportFile => new AccountingExportCblle(accountingExportFile));

            using (var memoryStream = new MemoryStream())
            using (var streamWritter = new StreamWriter(memoryStream))
            {
                streamWritter.WriteLine("CBLLE09.00");
                streamWritter.WriteLine($"PRISMA{DateTime.Now.Year}");

                for (int i = 0; i < 3; i++)
                {
                    streamWritter.WriteLine();
                }

                foreach (var cblle in cblles)
                {
                    var line = new StringBuilder();
                    var properties = cblle.GetType().GetProperties();

                    foreach (var property in properties)
                    {
                        var propertyValue = property.GetValue(cblle);
                        var value = propertyValue is null ? string.Empty : propertyValue.ToString();
                        var (startAt, length, character, justification) = GetAttributeValues(property);

                        line.Insert(startAt, justification == FixedTextFileAttributeJustification.Left ? value.PadLeft(length, character) : value.PadRight(length, character));
                    }

                    streamWritter.WriteLine(line.ToString());
                }

                return memoryStream.ToArray();
            }
        }

        static (int startAt, int length, char character, FixedTextFileAttributeJustification justification) GetAttributeValues(PropertyInfo property)
        {
            var attribute = property.GetCustomAttributes(true).FirstOrDefault() as FixedTextFileAttribute;
            return (attribute.StartAt, attribute.Length, attribute.Character, attribute.ValueJustification);
        }
    }
}
