using System;
using System.Collections.Generic;

namespace F3M.Oticas.DTO
{
    public class TaxAuthorityComunicationFilterDto
    {
        public TaxAuthorityComunicationFilterDto()
        {
            Warehouses = new List<TaxAuthorityComunicationWarehouseDto>();
        }

        public DateTime FilterDate { get; set; }

        public IList<TaxAuthorityComunicationWarehouseDto> Warehouses { get; set; }
    }
}
