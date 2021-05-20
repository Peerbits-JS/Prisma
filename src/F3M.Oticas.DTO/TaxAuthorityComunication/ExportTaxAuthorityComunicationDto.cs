using F3M.Oticas.Domain.Enum;

namespace F3M.Oticas.DTO.TaxAuthorityComunication
{
    public class ExportTaxAuthorityComunicationDto
    {
        public long Id { get; set; }
        public TaxAuthorityComunicationFileType FileType { get; set; }
        public string Nif { get; set; }
    }
}
