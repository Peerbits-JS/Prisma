using F3M.Core.Components.Extensions;
using F3M.Core.Data.Interfaces.UnitOfWork;
using F3M.Oticas.Component.Extensions;
using F3M.Oticas.Component.Kendo;
using F3M.Oticas.Domain.Constants;
using F3M.Oticas.Domain.Entities;
using F3M.Oticas.Domain.Entities.Base;
using F3M.Oticas.Domain.Extensions;
using F3M.Oticas.DTO;
using F3M.Oticas.DTO.Enum;
using F3M.Oticas.Interfaces.Application;
using F3M.Oticas.Interfaces.Application.Services;
using F3M.Oticas.Interfaces.Repository;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using static F3M.Oticas.Domain.Constants.AccountingExportConstants;
using F3M.Oticas.Translate;
using System.IO;
using System.Text;

namespace F3M.Oticas.Application.Application
{
    public class AccountingExportApplication : IAccountingExportApplication
    {
        readonly IAccountingExportRepository _accountingExportRepository;
        readonly IAccountingExportService _accountingExportService;
        readonly IDocumentTypeRepositoryMapperService _documentTypeRepositoryMapperService;
        readonly IDocumentTypeRepository _documentTypesRepository;
        readonly IAccountingConfigurationRepository _repositoryAccountingConfiguration;
        readonly IAccountingConfigurationEntityRepository _repositoryAccountingConfigurationEntity;
        readonly IAccountingConfigurationModuleRepository _repositoryAccountingConfigurationModules;
        readonly IUnitOfWork _unitOfWork;

        public AccountingExportApplication(
            IUnitOfWork unitOfWork,
            IDocumentTypeRepositoryMapperService documentTypeRepositoryMapperService,
            IDocumentTypeRepository documentTypesRepository,
            IAccountingConfigurationRepository repositoryAccountingConfiguration,
            IAccountingExportRepository accountingExportRepository,
            IAccountingExportService accountingExportService,
            IAccountingConfigurationEntityRepository repositoryAccountingConfigurationEntity,
            IAccountingConfigurationModuleRepository repositoryAccountingConfigurationModules
            )
        {
            _unitOfWork = unitOfWork;
            _documentTypeRepositoryMapperService = documentTypeRepositoryMapperService;
            _documentTypesRepository = documentTypesRepository;
            _repositoryAccountingConfiguration = repositoryAccountingConfiguration;
            _accountingExportRepository = accountingExportRepository;
            _accountingExportService = accountingExportService;
            _repositoryAccountingConfigurationEntity = repositoryAccountingConfigurationEntity;
            _repositoryAccountingConfigurationModules = repositoryAccountingConfigurationModules;
        }

        public byte[] ExportFile(AccountingExportDto model)
        {
            var accountsExporting = _accountingExportRepository.GetDocumentsDetails(model).Where(documentDetail => documentDetail.IsGenerated == true);

            var accountExportingFiles = accountsExporting
                .Select(x => new AccountingExportFile
                {
                    ReflectsVATClasses = x.ReflectsVatClass ?? false,
                    ReflectsCostCenters = x.ReflectsCostCenter ?? false,
                    LineType = x.IsCostCenter == true ? AccountingExportLineType.CostCenter  : AccountingExportLineType.Financial,
                    Module = x.DocumentModuleTypeCode.ToAccountingExportModule(),
                    Date = x.DocumentDate.Date,
                    AccountToMove = x.Account,
                    Daily = x.JournalCode,
                    Document = x.DocumentCode,
                    DocumentNumber = x.DocumentNumber?.ToString() ?? string.Empty,
                    Description = x.Document,
                    SourceValue = x.Value ?? 0,
                    Nature = x.NatureDescription.ToAccountingExportNatureType(),
                    VatClass = x.VatClassAccount,
                    SourceAccount = x.OriginAccount,
                    Year = x.DocumentDate.Year.ToString(),
                    ExternalDocumentNumber = x.ExternalDocumentNumber
                });

            var ExportFiles = from ef in accountExportingFiles
                          group ef by new {ef.ReflectsVATClasses, ef.ReflectsCostCenters, ef.LineType, ef.Module, ef.Date,ef.AccountToMove, ef.Daily, ef.Document,
                              ef.DocumentNumber, ef.Description,  ef.Nature, ef.VatClass, ef.SourceAccount, ef.Year, ef.ExternalDocumentNumber} into table
                          select new AccountingExportFile {ReflectsVATClasses = table.First().ReflectsVATClasses,ReflectsCostCenters = table.First().ReflectsCostCenters,
                              LineType = table.First().LineType, Module = table.First().Module,Date = table.First().Date, AccountToMove = table.First().AccountToMove,
                              Daily = table.First().Daily,Document = table.First().Document,DocumentNumber = table.First().DocumentNumber,Description = table.First().Description,
                              Nature = table.First().Nature,VatClass = table.First().VatClass,SourceAccount = table.First().SourceAccount,Year = table.First().Year,
                              ExternalDocumentNumber=table.First().ExternalDocumentNumber, SourceValue = table.Sum(s => s.SourceValue)};

            var file = _accountingExportService.ExportAccountingCblle(ExportFiles);

            //TODO: Converter em evento.

            foreach (var item in accountsExporting)
            {
                item.IsExported = true;
            }

            _accountingExportRepository.Edit(accountsExporting.ToArray());
            _accountingExportRepository.Commit();

            return file;
        }

        public async Task GenerateMovements(AccountingExportDto model)
        {
            try
            {
                var accountingExports = new List<AccountingExport>();
                log("1");
                var existedAccountingExports = _accountingExportRepository.GetDocumentsDetails(model);
                log("3");
                var configurations = _repositoryAccountingConfiguration.GetConfigurations(model.Filter);
                log("5");
                var documents = _documentTypeRepositoryMapperService.GetDocuments(model);
                log("7");
                var accountingConfigurations = _repositoryAccountingConfigurationEntity.GetAccountingConfigurationEntities(model.Filter);
                log("9");

                foreach (var document in documents)
                {
                    var errorNotes = new List<string>();
                    var configuration = document.GetAccountingConfiguration(configurations);

                    log("f1");

                    if (configuration is null)
                    {
                        errorNotes.Add(AccountingExportResources.DocumentWithoutConfiguration);
                        accountingExports.Add(AccountingExport.Create(document).MarkWithErrors(errorNotes));
                        continue;
                    }
                    log("f2");

                    var accountingExport = CreateAccountingExport(document, document.GetDocumentLineBase(), configuration, accountingConfigurations);
                    log("f2");

                    var isBalanced = accountingExport.IsAccountingExportBalanced();
                    var areAllTokensReplaced = accountingExport.AreAllTokensReplaced();
                    log("f3");

                    if (isBalanced && areAllTokensReplaced)
                    {
                        accountingExports.AddRange(accountingExport);
                        continue;
                    }
                    log("f4");

                    foreach (var accountingToExport in accountingExport)
                    {
                        errorNotes = new List<string>();
                        if (isBalanced is false) errorNotes.Add(AccountingExportResources.MovementNotBalanced);
                        if (accountingToExport.AreAllTokensReplaced() is false) errorNotes.Add(AccountingExportResources.TokensNotDefined);

                        accountingToExport.MarkWithErrors(errorNotes);
                        accountingToExport.SetIsGenerated(true);
                    }
                    accountingExports.AddRange(accountingExport);
                }
                log("11");

                var existsDocumentsDetails = existedAccountingExports.Where(x => accountingExports.Any(y => x.DocumentId == x.DocumentId && y.DocumentTypeId == x.DocumentTypeId));
                log("13");

                _accountingExportRepository.Delete(existsDocumentsDetails);
                log("15");

                await _accountingExportRepository.CreateAsync(accountingExports);
                log("17");

                _accountingExportRepository.Commit();

                log("19");

            }
            catch (Exception ex)
            {
                log("99" + ex.Message);
                throw ex;
            }
        }

        public IEnumerable<AccountingExportDocumentsDto> GetDocuments(AccountingExportFilterDto filter)
        {
            log("5.1");
            var configurations = _repositoryAccountingConfiguration.GetConfigurations(filter).Select(s => s.TypeCode).ToArray();
            log("5.2");
            var documents = _documentTypeRepositoryMapperService.GetDocuments(filter).Where(w => configurations.Contains(w.DocumentTypeCode)).ToList();
            log("5.3");
            var documentDetails = _accountingExportRepository.GetDocumentsDetails(documents);
            log("5.4");
            foreach (var document in documents)
            {
                var documentDetail = documentDetails.Where(t => t.DocumentId == document.DocumentId && t.DocumentTypeId == document.DocumenTypetId).ToList();
                log("5.5");

                if (documentDetail.Any())
                {
                    document.IsGenerated = documentDetail.All(a => a.IsGenerated);
                    document.IsExported = documentDetail.All(a => a.IsExported);
                    document.HasErrors = documentDetail.All(a => a.HasErrors);
                    log("5.6");

                    var errorNotes = string.Join("; ", documentDetail.Where(w => w.HasErrors).SelectMany(s => s.ErrorNotes?.Split(';'))?.Distinct());
                    log("5.7");
                    errorNotes = errorNotes.StartsWith(";") ? errorNotes.Replace(";", "") : errorNotes;
                    log("5.8");
                    document.ErrorNotes = errorNotes;
                    log("5.9");
                }
            }

            log("5.10");
            bool FilterWhere(AccountingExportDocumentsDto document) =>
                (filter.Generated == Generated.All ? true : (filter.Generated == Generated.True ? document.IsGenerated : !document.IsGenerated)) &&
                (filter.Exported == Exported.All ? true : (filter.Exported == Exported.True ? document.IsExported : !document.IsExported)) &&
                (string.IsNullOrEmpty(filter.EntityType) ? true : (filter.EntityType == EntityTypes.Customer ? document.EntityType == "C" : document.EntityType == "F"));
            log("5.11");
            return documents.Where(FilterWhere);
        }

        public IEnumerable<AccountingExportDocumentsDetailsDto> GetDocumentsDetails(AccountingExportDto model)
        {
            var documentsDetails = _accountingExportRepository.GetDocumentsDetails(model);
            var documentsDetailsDto = documentsDetails.Map<IEnumerable<AccountingExport>, IEnumerable<AccountingExportDocumentsDetailsDto>>();

            foreach (var documentDetailsDto in documentsDetailsDto)
            {
                documentDetailsDto.DocumentDateFormated = documentDetailsDto.DocumentDate.ToShortDateString();
            }

            return documentsDetailsDto;
        }

        public IEnumerable<AccountingConfigurationModulesDto> GetModulesByFilter(AccountingExportFilterDto accountingConfigurationFilter)
        {
            var configurations = _repositoryAccountingConfiguration.GetConfigurations(accountingConfigurationFilter).Select(s => s.ModuleCode).ToArray();
            var result = _repositoryAccountingConfigurationModules.Get(w => w.Code != AccountingConfigurationConstants.Module.Entities && configurations.Contains(w.Code));

            return result.Select(module => new AccountingConfigurationModulesDto
            {
                Id = module.Id,
                Code = module.Code,
                Description = SystemModuleResources.ResourceManager.GetString(module.Description) ?? module.Description
            });
        }

        public IEnumerable<AccountingConfigurationTypesDto> GetDocumentTypesByFilter(AccountingExportFilterDto accountingConfigurationFilter)
        {
            var configurations = _repositoryAccountingConfiguration.GetConfigurations(accountingConfigurationFilter).Select(s => s.TypeCode).ToArray();
            var types = _documentTypesRepository.GetTypesByModulesIds(accountingConfigurationFilter.ModulesId);

            return types.Where(w => configurations.Contains(w.Codigo)).Select(type => new AccountingConfigurationTypesDto
            {
                Id = type.Id,
                Code = type.Codigo,
                Description = type.Descricao,
            });
        }

        public IEnumerable<object> GetEntityTypesList()
            => new List<object>
            {
                new { Code = EntityTypes.Customer, Description = AccountingExportResources.Customer},
                new { Code = EntityTypes.Provider, Description = AccountingExportResources.Provider}
            };

        public IEnumerable<object> GetExportedList()
            => new List<object>
            {
                new { Code = Exported.All, Description = AccountingExportResources.All},
                new { Code = Exported.True, Description = AccountingExportResources.Yes},
                new { Code = Exported.False, Description =AccountingExportResources.No}
            };

        public IEnumerable<object> GetFormatsList()
            => new List<object>
            {
                new { Code = ExportFormats.PBSSV9, Description = "Primavera 9.00"},
            };

        public IEnumerable<object> GetGeneratedList()
            => new List<object>
            {
                new { Code = Generated.All, Description = AccountingExportResources.All},
                new { Code = Generated.True, Description = AccountingExportResources.Yes},
                new { Code = Generated.False, Description = AccountingExportResources.No}
            };


        private static IEnumerable<AccountingExport> CreateAccountingExport(DocumentBase documentBase, IEnumerable<DocumentLineBase> documentLines, AccountingConfiguration configuration, IEnumerable<AccountingConfigurationDetail> accountingConfigurations)
        {
            var documentsDetails = new List<AccountingExport>();

            documentsDetails.AddRange(configuration.GetDocumentDetailsWithLinesConfiguration(documentLines, accountingConfigurations));
            documentsDetails.AddRange(configuration.GetDocumentDetailsWithHeadConfiguration(documentBase, documentLines, accountingConfigurations));
            documentsDetails.AddRange(configuration.GetDocumentDetailsWithPaymentConfiguration(documentBase, accountingConfigurations, documentBase.GetPaymentsTypes()));

            return documentsDetails.Where(documentDetail => documentDetail.Value != 0);
        }
        private void log(string text)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(text + "\r\n");
            File.AppendAllText(AppDomain.CurrentDomain.BaseDirectory + "expAcc.log", sb.ToString());
            sb.Clear();
        }
    }

}