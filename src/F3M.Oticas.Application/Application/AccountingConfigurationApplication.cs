using F3M.Core.Components.Extensions;
using F3M.Core.Data.Interfaces.UnitOfWork;
using F3M.Core.Domain.Entity;
using F3M.Core.Domain.Validators;
using F3M.Oticas.Component.Extensions;
using F3M.Oticas.Component.Kendo;
using F3M.Oticas.Component.Kendo.Models;
using F3M.Oticas.Component.Models;
using F3M.Oticas.Domain.Entities;
using F3M.Oticas.DTO;
using F3M.Oticas.Interfaces.Application;
using F3M.Oticas.Interfaces.Repository;
using F3M.Oticas.Translate;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace F3M.Oticas.Application.Application
{
    public class AccountingConfigurationApplication : IAccountingConfigurationApplication
    {
        readonly IAccountingConfigurationDocumentTypeRepository _accountingConfigurationDocumentTypeRepository;
        readonly IAccountingConfigurationRepository _accountingConfigurationRepository;
        readonly IAccountingConfigurationModuleRepository _accountingConfigurationModulesRepository;
        readonly IAccountingConfigurationTypeRepository _accountingConfigurationTypesRepository;
        readonly IAccountingConfigurationEntityRepository _accountingConfigurationEntityRepository;
        readonly IDocumentTypeRepository _documentTypesRepository;
        readonly IUnitOfWork _unitOfWork;

        public AccountingConfigurationApplication(IAccountingConfigurationEntityRepository accountingConfigurationEntityRepository,
                                                                                       IAccountingConfigurationRepository accountingConfigurationRepository,
                                                                                       IAccountingConfigurationModuleRepository accountingConfigurationModulesRepository,
                                                                                       IAccountingConfigurationTypeRepository accountingConfigurationTypesRepository,
                                                                                       IDocumentTypeRepository documentTypesRepository,
                                                                                       IAccountingConfigurationDocumentTypeRepository accountingConfigurationDocumentTypeRepository,
                                                                                       IUnitOfWork unitOfWork)
        {
            _accountingConfigurationDocumentTypeRepository = accountingConfigurationDocumentTypeRepository;
            _accountingConfigurationRepository = accountingConfigurationRepository;
            _accountingConfigurationModulesRepository = accountingConfigurationModulesRepository;
            _accountingConfigurationTypesRepository = accountingConfigurationTypesRepository;
            _accountingConfigurationEntityRepository = accountingConfigurationEntityRepository;
            _documentTypesRepository = documentTypesRepository;
            _unitOfWork = unitOfWork;
        }

        public async Task<Paged<AccountingConfigurationDto>> GetAsync(F3MDataSourceRequest dataSourceRequest)
        {
            var paged = await _accountingConfigurationRepository.GetAsync(dataSourceRequest);

            var accountingConfigurationDto = paged.Data.Select(accountingConfiguration => new AccountingConfigurationDto
            {
                Id = accountingConfiguration.Id,
                Year = accountingConfiguration.Year,
                ModuleCode = accountingConfiguration.ModuleCode,
                ModuleDescription = accountingConfiguration.ModuleDescription,
                TypeCode = accountingConfiguration.TypeCode,
                TypeDescription = accountingConfiguration.TypeDescription,
                AlternativeCode = accountingConfiguration.AlternativeCode,
                AlternativeDescription = accountingConfiguration.AlternativeDescription,
                JournalCode = accountingConfiguration.JournalCode,
                DocumentCode = accountingConfiguration.DocumentCode,
                ReflectsCostCenterByFinancialAccount = accountingConfiguration.ReflectsCostCenterByFinancialAccount,
                ReflectsIVAClassByFinancialAccount = accountingConfiguration.ReflectsIVAClassByFinancialAccount,
                CreatedAt = accountingConfiguration.CreatedAt,
                CreatedBy = accountingConfiguration.CreatedBy,
                F3MMarker = accountingConfiguration.F3MMarker
            });

            return Paged<AccountingConfigurationDto>.Create(accountingConfigurationDto, paged.Total);
        }

        public async Task<AccountingConfigurationDto> GetAsync(long id)
        {
            var accountingConfiguration = await _accountingConfigurationRepository.FindAsync(id);

            var DTO = new AccountingConfigurationDto
            {
                Id = accountingConfiguration.Id,
                Year = accountingConfiguration.Year,
                ModuleCode = accountingConfiguration.ModuleCode,
                ModuleDescription = accountingConfiguration.ModuleDescription,
                TypeCode = accountingConfiguration.TypeCode,
                TypeDescription = accountingConfiguration.TypeDescription,
                AlternativeCode = accountingConfiguration.AlternativeCode,
                AlternativeDescription = accountingConfiguration.AlternativeDescription,
                IsPreset = accountingConfiguration.IsPreset,
                JournalCode = accountingConfiguration.JournalCode,
                DocumentCode = accountingConfiguration.DocumentCode,
                ReflectsCostCenterByFinancialAccount = accountingConfiguration.ReflectsCostCenterByFinancialAccount,
                ReflectsIVAClassByFinancialAccount = accountingConfiguration.ReflectsIVAClassByFinancialAccount,
                CreatedAt = accountingConfiguration.CreatedAt,
                CreatedBy = accountingConfiguration.CreatedBy,
                F3MMarker = accountingConfiguration.F3MMarker,
                Entities = accountingConfiguration.IsDocumentType() ? null : accountingConfiguration.Lines.Map<ICollection<AccountingConfigurationDetail>, IList<AccountingConfigurationEntityDto>>(),
                DocumentTypes = accountingConfiguration.IsDocumentType() ? accountingConfiguration.Lines.Map<ICollection<AccountingConfigurationDetail>, IList<AccountingConfigurationDocumentTypeDto>>() : null
            };

            if (accountingConfiguration.IsDocumentType() is false)
            {
                var dbEntities = _accountingConfigurationEntityRepository.GetToAccountingConfigurationByTableName(accountingConfiguration.TypeCode);
                var dbEntitiesToAdd = dbEntities?.Where(w => !DTO.Entities.Any(a => a.EntityId == w.EntityId)).ToList();

                if (dbEntitiesToAdd!=null)
                {
                    foreach (var dbEntitieToAdd in dbEntitiesToAdd)
                    {
                        DTO.Entities.Add(dbEntitieToAdd);
                    }
                }
            }
            return DTO;
        }

        public async Task<DomainResult<KendoResultModel<AccountingConfigurationDto>>> CreateWithAccountsAsync(KendoCreatedModel<AccountingConfigurationDto> kendoCreatedModel)
        {
            var accountingConfiguration = kendoCreatedModel.Data.Map<AccountingConfigurationDto, AccountingConfiguration>();
            var lines = kendoCreatedModel.Data.Entities.Map<IList<AccountingConfigurationEntityDto>, IList<AccountingConfigurationDetail>>();

            accountingConfiguration.AddLines(lines);

            var (isValid, errorMessage) = accountingConfiguration.ValidateAccounts();

            if (isValid)
            {
                var alreadyExists = _accountingConfigurationRepository.AlreadyExists(accountingConfiguration);

                if (alreadyExists)
                {
                    return DomainResult.Failure<KendoResultModel<AccountingConfigurationDto>>(AccountingConfigurationResources.ConfigurationAlreadyExistWithSelectedYear);
                }

                await _accountingConfigurationRepository.CreateAsync(accountingConfiguration);

                await _unitOfWork.CommitAsync();

                var lastPage = _accountingConfigurationRepository.GetLastPage(kendoCreatedModel.F3MKendoDataSource);

                return DomainResult.Ok(KendoResultModel<AccountingConfigurationDto>.Create(kendoCreatedModel.Data, accountingConfiguration.Id, lastPage));
            }

            return DomainResult.Failure<KendoResultModel<AccountingConfigurationDto>>(errorMessage);
        }

        public async Task<DomainResult<KendoResultModel<AccountingConfigurationDto>>> CreateWithDocumentTypesAsync(KendoCreatedModel<AccountingConfigurationDto> kendoCreatedModel)
        {
            var accountingConfiguration = kendoCreatedModel.Data.Map<AccountingConfigurationDto, AccountingConfiguration>();
            var lines = kendoCreatedModel.Data.DocumentTypes.Map<IList<AccountingConfigurationDocumentTypeDto>, IList<AccountingConfigurationDetail>>();

            accountingConfiguration.AddLines(lines);

            var (isValid, errorMessage) = accountingConfiguration.ValidateDocumentTypes();

            if (isValid)
            {
                await _accountingConfigurationRepository.CreateAsync(accountingConfiguration);
                await ChangeAlternativesPresetAsync(accountingConfiguration);

                await _unitOfWork.CommitAsync();

                var lastPage = _accountingConfigurationRepository.GetLastPage(kendoCreatedModel.F3MKendoDataSource);

                return DomainResult.Ok(KendoResultModel<AccountingConfigurationDto>.Create(kendoCreatedModel.Data, accountingConfiguration.Id, lastPage));
            }

            return DomainResult.Failure<KendoResultModel<AccountingConfigurationDto>>(errorMessage);
        }

        public async Task<KendoResultModel<AccountingConfigurationDto>> UpdateWithAccountsAsync(KendoCreatedModel<AccountingConfigurationDto> kendoCreatedModel)
        {
            var accountingConfiguration = kendoCreatedModel.Data.Map<AccountingConfigurationDto, AccountingConfiguration>();
            var lines = kendoCreatedModel.Data.Entities.Map<IList<AccountingConfigurationEntityDto>, IList<AccountingConfigurationDetail>>();

            accountingConfiguration.AddLines(lines);

            _accountingConfigurationRepository.Edit(accountingConfiguration);

            await _unitOfWork.CommitAsync();

            var lastPage = _accountingConfigurationRepository.GetLastPage(kendoCreatedModel.F3MKendoDataSource);

            return KendoResultModel<AccountingConfigurationDto>.Create(kendoCreatedModel.Data, accountingConfiguration.Id, lastPage);
        }

        public async Task<DomainResult<KendoResultModel<AccountingConfigurationDto>>> UpdateWithDocumentTypesAsync(KendoCreatedModel<AccountingConfigurationDto> kendoCreatedModel)
        {
            var data = kendoCreatedModel.Data;
            var accountingConfiguration = data.InjectObjectToObject<AccountingConfiguration>();

            var linesToInsertOrUpdate = data.DocumentTypes
                .Where(item => item.IsNotMarkedAsDeleted())
                .InjectObjectToObject<IList<AccountingConfigurationDetail>>();


            var linesToDelete = data.DocumentTypes
                .Where(item => item.IsMarkedAsDeleted())
                .InjectObjectToObject<IList<AccountingConfigurationDetail>>();

            accountingConfiguration.AddLines(linesToInsertOrUpdate);

            var (isValid, errorMessage) = accountingConfiguration.ValidateDocumentTypes();

            if (isValid)
            {
                await ChangeAlternativesPresetAsync(accountingConfiguration);

                _accountingConfigurationRepository.Edit(accountingConfiguration);

                if (linesToDelete.Any()) _accountingConfigurationDocumentTypeRepository.Delete(linesToDelete);

                await _unitOfWork.CommitAsync();

                var lastPage = _accountingConfigurationRepository.GetLastPage(kendoCreatedModel.F3MKendoDataSource);

                return DomainResult.Ok(KendoResultModel<AccountingConfigurationDto>.Create(data, accountingConfiguration.Id, lastPage));
            }

            return DomainResult.Failure<KendoResultModel<AccountingConfigurationDto>>(errorMessage);
        }
        
        public async Task<KendoResultModel<AccountingConfigurationDto>> RemoveAsync(KendoRemoveModel kendoRemoveModel)
        {
            var page = _accountingConfigurationRepository.GetPageToRemove(kendoRemoveModel);
            var beforeEntity = _accountingConfigurationRepository.GetBefore(kendoRemoveModel);

            var taxAuthorityComunication = await _accountingConfigurationRepository.FindAsync(kendoRemoveModel.Id);

            _accountingConfigurationRepository.Delete(taxAuthorityComunication);

            await _unitOfWork.CommitAsync();

            return KendoResultModel<AccountingConfigurationDto>.Create(taxAuthorityComunication.Map<AccountingConfiguration, AccountingConfigurationDto>(), beforeEntity.Id, page);
        }

        public async Task<List<KeyValueModel>> GetYearsAsync() => await _accountingConfigurationRepository.GetYears();

        public async Task<IEnumerable<AccountingConfigurationModulesDto>> GetModulesAsync()
        {
            var result = await _accountingConfigurationModulesRepository.GetAsync();

            return result.Select(module => new AccountingConfigurationModulesDto
            {
                Id = module.Id,
                Code = module.Code,
                Description = SystemModuleResources.ResourceManager.GetValue(module.Description)
            });
        }

        public async Task<IEnumerable<AccountingConfigurationTypesDto>> GetTypesAsync(AccountingConfigurationModulesDto model)
        {
            var module = model.Map<AccountingConfigurationModulesDto, AccountingConfigurationModule>();

            if (module.HasNoModuleSelected()) return default(IEnumerable<AccountingConfigurationTypesDto>);

            if (module.IsDocumentType())
            {
                var types = await _documentTypesRepository.GetTypesByModule(module);

                return types.Select(type => new AccountingConfigurationTypesDto
                {
                    Id = type.Id,
                    Code = type.Codigo,
                    Description = type.Descricao,
                });
            }

            var accountConfigurationTypes = await _accountingConfigurationTypesRepository.GetTypesByModule(module);

            return accountConfigurationTypes.Select(type => new AccountingConfigurationTypesDto
            {
                Id = type.Id,
                Code = type.Code,
                Description = type.Description,
                Table = type.Table
            });
        }

        public string GetAlternative(AccountingConfigurationDto model)
        {
            var accountingConfiguration = model.Map<AccountingConfigurationDto, AccountingConfiguration>();
            return _accountingConfigurationRepository.GetAlternative(accountingConfiguration);
        }

        public IEnumerable<AccountingConfigurationEntityDto> GetEntities(AccountingConfigurationTypesDto model) => _accountingConfigurationEntityRepository.GetToAccountingConfigurationAsync(model);

        private async Task ChangeAlternativesPresetAsync(AccountingConfiguration accountingConfiguration)
        {
            if (accountingConfiguration.IsPreset is true)
            {
                var accountingsConfiguration = await _accountingConfigurationRepository.GetToPresetAlternativeAsync(accountingConfiguration);

                accountingsConfiguration.ForEach(x => x.MarkPresetAsFalse());

                _accountingConfigurationRepository.Edit(accountingsConfiguration.ToArray());
            }
        }
    }
}
