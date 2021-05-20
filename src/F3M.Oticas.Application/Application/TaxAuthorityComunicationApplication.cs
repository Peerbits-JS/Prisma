using F3M.Core.Application.Interfaces.Services;
using F3M.Core.Components.Extensions;
using F3M.Core.Data.Interfaces.UnitOfWork;
using F3M.Core.Domain.Entity;
using F3M.Oticas.Component.Kendo;
using F3M.Oticas.Component.Kendo.Models;
using F3M.Oticas.Domain.Entities;
using F3M.Oticas.Domain.Enum;
using F3M.Oticas.DTO;
using F3M.Oticas.DTO.TaxAuthorityComunication;
using F3M.Oticas.Interfaces.Application;
using F3M.Oticas.Interfaces.Repository;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace F3M.Oticas.Application.Application
{
    public class TaxAuthorityComunicationApplication : IApplicationTaxAuthorityComunication
    {
        readonly IProductRepository _productRepository;
        readonly ITaxAuthorityComunicationFileService _taxAuthorityComunicationFileService;
        readonly ITaxAuthorityComunicationRepository _taxAuthorityComunicationRepository;
        readonly IUnitOfWork _unitOfWork;

        public TaxAuthorityComunicationApplication(IProductRepository productRepository, ITaxAuthorityComunicationRepository taxAuthorityComunicationRepository,
            IUnitOfWork unitOfWork, ITaxAuthorityComunicationFileService taxAuthorityComunicationFileService)
        {
            _productRepository = productRepository;
            _taxAuthorityComunicationRepository = taxAuthorityComunicationRepository;
            _taxAuthorityComunicationFileService = taxAuthorityComunicationFileService;
            _unitOfWork = unitOfWork;
        }

        public async Task<KendoResultModel<TaxAuthorityComunicationDto>> CreateAsync(KendoCreatedModel<TaxAuthorityComunicationDto> kendoCreatedModel)
        {
            var taxAuthorityComunication = kendoCreatedModel.Data.Map<TaxAuthorityComunicationDto, TaxAuthorityComunication>();

            taxAuthorityComunication.Filter = kendoCreatedModel.Data.Filter.ObjectToJson();
            taxAuthorityComunication.TaxAuthorityComunicationProducts = kendoCreatedModel.Data.Products.Map<IList<TaxAuthorityComunicationProductDto>, ICollection<TaxAuthorityComunicationProduct>>();

            await _taxAuthorityComunicationRepository.CreateAsync(taxAuthorityComunication);
            await _taxAuthorityComunicationRepository.CommitAsync();

            var lastPage = _taxAuthorityComunicationRepository.GetLastPage(kendoCreatedModel.F3MKendoDataSource);

            kendoCreatedModel.Data.Id = taxAuthorityComunication.Id;

            return KendoResultModel<TaxAuthorityComunicationDto>.Create(kendoCreatedModel.Data, taxAuthorityComunication.Id, lastPage);
        }

        public async Task<FileTaxAuthorityComunication> ExportAsync(ExportTaxAuthorityComunicationDto exportTaxAuthorityComunicationDto)
        {
            var taxAuthorityComunication = await _taxAuthorityComunicationRepository.FindAsync(exportTaxAuthorityComunicationDto.Id);
            var filter = taxAuthorityComunication.Filter.JsonToObject<TaxAuthorityComunicationFilterDto>();

            var item = new TaxAuthorityComunicationBase
            {
                TaxRegistrationNumber = exportTaxAuthorityComunicationDto.Nif,
                FiscalYear = filter.FilterDate.Year,
                EndDate = filter.FilterDate,
                Produtcs = taxAuthorityComunication.TaxAuthorityComunicationProducts.Select(x => new TaxAuthorityComunicationProductBase
                {
                    ProductCategory = x.Category,
                    ProductCode = x.ProductCode,
                    ProductDescription = x.ProductDescription,
                    ProductNumberCode = x.BarCode,
                    ClosingStockQuantity = x.StockQuantity.ToString("n0").Replace(",", ".").Replace("\u00A0", ""),
                    //ClosingStockValue= x.StockValue.ToString("n2").Replace(",", ".").Replace("\u00A0", ""),,
                    UnitOfMeasure = x.UnitCode
                })
            };

            _taxAuthorityComunicationRepository.Edit(taxAuthorityComunication);
            _taxAuthorityComunicationRepository.Commit();

            return exportTaxAuthorityComunicationDto.FileType == TaxAuthorityComunicationFileType.Csv
                ? await _taxAuthorityComunicationFileService.CreateCsvAsync(item)
                : await _taxAuthorityComunicationFileService.CreateXmlAsync(item);
        }

        public async Task<Paged<TaxAuthorityComunicationDto>> GetAsync(F3MDataSourceRequest dataSourceRequest)
        {
            var paged = await _taxAuthorityComunicationRepository.GetAsync(dataSourceRequest);

            var taxAuthorityComunicationDto = paged.Data.Select(taxAuthorityComunication => new TaxAuthorityComunicationDto
            {
                Id = taxAuthorityComunication.Id,
                CreatedAt = taxAuthorityComunication.CreatedAt,
                UpdatedAt = taxAuthorityComunication.UpdatedAt,
                CreatedBy = taxAuthorityComunication.CreatedBy,
                UpdatedBy = taxAuthorityComunication.UpdatedBy,
                Observations = taxAuthorityComunication.Observations,
                Filter = taxAuthorityComunication.Filter.JsonToObject<TaxAuthorityComunicationFilterDto>(),
            });

            return Paged<TaxAuthorityComunicationDto>.Create(taxAuthorityComunicationDto, paged.Total);
        }

        public async Task<TaxAuthorityComunicationDto> GetAsync(long id)
        {
            var taxAuthorityComunication = await _taxAuthorityComunicationRepository.FindAsync(id);

            return new TaxAuthorityComunicationDto
            {
                Id = taxAuthorityComunication.Id,
                CreatedAt = taxAuthorityComunication.CreatedAt,
                UpdatedAt = taxAuthorityComunication.UpdatedAt,
                CreatedBy = taxAuthorityComunication.CreatedBy,
                UpdatedBy = taxAuthorityComunication.UpdatedBy,
                Observations = taxAuthorityComunication.Observations,
                Filter = taxAuthorityComunication.Filter.JsonToObject<TaxAuthorityComunicationFilterDto>(),
                Products = taxAuthorityComunication.TaxAuthorityComunicationProducts.Map<ICollection<Domain.Entities.TaxAuthorityComunicationProduct>, IList<TaxAuthorityComunicationProductDto>>()
            };
        }

        public async Task<IEnumerable<TaxAuthorityComunicationProductDto>> GetProductsAsync(TaxAuthorityComunicationFilterDto filter)
        {
            var products = await _productRepository.GetToTaxAuthorityComunicationAsync(filter);
            
            return products.Select(product => new TaxAuthorityComunicationProductDto
            {
                ProductCode = product.Code,
                ProductId = product.Id,
                ProductDescription = product.Description,
                StockQuantity = product.ComputeCurrentAccountBalance(),
                StockValue = Math.Round(Convert.ToDouble(product.AveragePrice * product.ComputeCurrentAccountBalance()), 2),
                UnitCode = product.Unit?.Codigo,
                UnitDescription = product.Unit?.Descricao,
                UnitId = product.UnitId,
                BarCode = product.BarCode,
                Category = product.ProductType.IdsistemaClassificacaoGeralNavigation.CodigoAt
            }).Where(product => product.StockQuantity > 0);
        }

        public async Task<KendoResultModel<TaxAuthorityComunicationDto>> RemoveAsync(KendoRemoveModel kendoRemoveModel)
        {

            var page = _taxAuthorityComunicationRepository.GetPageToRemove(kendoRemoveModel);
            var beforeEntity = _taxAuthorityComunicationRepository.GetBefore(kendoRemoveModel);

            var taxAuthorityComunication = await _taxAuthorityComunicationRepository.FindAsync(kendoRemoveModel.Id);

            _taxAuthorityComunicationRepository.Delete(taxAuthorityComunication);
            _taxAuthorityComunicationRepository.Commit();

            return KendoResultModel<TaxAuthorityComunicationDto>.Create(taxAuthorityComunication.Map<TaxAuthorityComunication, TaxAuthorityComunicationDto>(), beforeEntity.Id, page);
        }
    }
}
