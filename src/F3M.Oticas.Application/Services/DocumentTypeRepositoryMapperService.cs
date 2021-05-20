using F3M.Oticas.Component.Extensions;
using F3M.Oticas.Domain.Constants;
using F3M.Oticas.Domain.Entities.Base;
using F3M.Oticas.DTO;
using F3M.Oticas.Interfaces.Application.Services;
using F3M.Oticas.Interfaces.Repository;
using System.Collections.Generic;
using System.Linq;

namespace F3M.Oticas.Application.Services
{
    public class DocumentTypeRepositoryMapperService : IDocumentTypeRepositoryMapperService
    {
        readonly IList<ModuleRepository> _modulesRepository = new List<ModuleRepository>();

        readonly ISaleDocumentRepository _saleDocumentRepository;
        readonly IPurchaseDocumentRepository _purchaseDocumentRepository;
        readonly IStockDocumentRepository _stockDocumentRepository;
        readonly IProviderPaymentDocumentRepository _providersPaymentsRepository;
        readonly IReceiptDocumentRepository _receiptDocumentRepository;

        public DocumentTypeRepositoryMapperService(
            ISaleDocumentRepository saleDocumentRepository, 
            IPurchaseDocumentRepository purchaseDocumentRepository,
            IStockDocumentRepository stockDocumentRepository,
            IProviderPaymentDocumentRepository providerPaymentRepository, 
            IReceiptDocumentRepository receiptDocumentRepository)
        {
            _saleDocumentRepository = saleDocumentRepository;
            _purchaseDocumentRepository = purchaseDocumentRepository;
            _stockDocumentRepository = stockDocumentRepository;
            _providersPaymentsRepository = providerPaymentRepository;
            _receiptDocumentRepository = receiptDocumentRepository;

            _modulesRepository.Add(new ModuleRepository { key = DocumentTypeConstants.Module.Sale, rep = _saleDocumentRepository});
            _modulesRepository.Add(new ModuleRepository { key = DocumentTypeConstants.Module.Purchase, rep = _purchaseDocumentRepository });
            _modulesRepository.Add(new ModuleRepository { key = DocumentTypeConstants.Module.Stock, rep = _stockDocumentRepository });
            _modulesRepository.Add(new ModuleRepository { key = DocumentTypeConstants.Module.CurrentAccount, rep = _providersPaymentsRepository });
            _modulesRepository.Add(new ModuleRepository { key = DocumentTypeConstants.Module.CurrentAccount, rep = _receiptDocumentRepository });
        }

        public IList<AccountingExportDocumentsDto> GetDocuments(AccountingExportFilterDto filter)
        {
            var result = new List<AccountingExportDocumentsDto>();
            var mappersRepositories = _modulesRepository
                .Where(x => (filter.ModulesCode is null) ? true : filter.ModulesCode.Any(moduleCode => moduleCode == x.key));

            foreach (var mapper in mappersRepositories)
            {
                mapper.rep.GetDocuments(filter).ForEach(document => result.Add(document.MapperToAccountingExportDocumentsDto()));
            }

            return result;
        }

        public IList<DocumentBase> GetDocuments(AccountingExportDto model)
        {
            var result = new List<DocumentBase>();
            var mappersRepositories = _modulesRepository
                .Where(x => (model.Filter.ModulesCode is null) ? true : model.Filter.ModulesCode.Any(moduleCode => moduleCode == x.key));

            foreach (var mapper in mappersRepositories)
            {
                mapper.rep.GetDocuments(model).ForEach(document => result.Add(document));
            }

            return result;
        }
    }

    public class ModuleRepository
    {
        public string key { get; set; }
        public IAccountingExportDocumentReadRepository rep { get; set; }
    }
}