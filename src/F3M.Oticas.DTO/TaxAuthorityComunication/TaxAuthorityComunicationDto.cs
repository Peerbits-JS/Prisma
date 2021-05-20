using System;
using System.Collections.Generic;

namespace F3M.Oticas.DTO
{
    public class TaxAuthorityComunicationDto
    {
        public TaxAuthorityComunicationDto()
        {
            Products = new List<TaxAuthorityComunicationProductDto>();
        }

        public double Id { get; set; }

        public DateTime CreatedAt { get; set; }

        public DateTime? UpdatedAt { get; set; }

        public string CreatedBy { get; set; }

        public string UpdatedBy { get; set; }

        public string Observations { get; set; }

        public TaxAuthorityComunicationFilterDto Filter { get; set; }

        public IList<TaxAuthorityComunicationProductDto> Products { get; set; }
    }
}
