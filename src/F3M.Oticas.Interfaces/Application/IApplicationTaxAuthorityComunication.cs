using F3M.Core.Domain.Entity;
using F3M.Oticas.Component.Kendo;
using F3M.Oticas.Component.Kendo.Models;
using F3M.Oticas.DTO;
using F3M.Oticas.DTO.TaxAuthorityComunication;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace F3M.Oticas.Interfaces.Application
{
    public interface IApplicationTaxAuthorityComunication
    {
        Task<IEnumerable<TaxAuthorityComunicationProductDto>> GetProductsAsync(TaxAuthorityComunicationFilterDto filter);
        Task<Paged<TaxAuthorityComunicationDto>> GetAsync(F3MDataSourceRequest dataSourceRequest);
        Task<TaxAuthorityComunicationDto> GetAsync(long id);
        Task<KendoResultModel<TaxAuthorityComunicationDto>> CreateAsync(KendoCreatedModel<TaxAuthorityComunicationDto> taxAuthorityComunication);
        Task<KendoResultModel<TaxAuthorityComunicationDto>> RemoveAsync(KendoRemoveModel kendoRemoveModel);
        Task<FileTaxAuthorityComunication> ExportAsync(ExportTaxAuthorityComunicationDto exportTaxAuthorityComunicationDto);
    }
}
