using F3M.Core.Domain.Entity;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TaxAuthorityComunication : EntityBase
    {
        public TaxAuthorityComunication()
        {
            TaxAuthorityComunicationProducts = new HashSet<TaxAuthorityComunicationProduct>();
        }

        public string Filter { get; set; }
        public string Observations { get; set; }
        public ICollection<TaxAuthorityComunicationProduct> TaxAuthorityComunicationProducts { get; set; }
    }
}
