using Autofac;
using F3M.Core.Application.Interfaces.Services;
using F3M.Core.Application.Services;
using F3M.Core.Data.Interfaces.UnitOfWork;
using F3M.Core.Data.UnitOfWork;
using F3M.Oticas.Application.Application;
using F3M.Oticas.Application.Services;
using F3M.Oticas.Data.Context;
using F3M.Oticas.Data.Repository;
using F3M.Oticas.Interfaces.Application;
using F3M.Oticas.Interfaces.Application.Services;
using F3M.Oticas.Interfaces.Repository;
using F3M.Purchase.Documents.Services.Services;
using F3M.Purchase.Documents.Services.Services.Interfaces;
using System;

namespace F3M.Oticas.Component.IOC
{
    public class DependencyInjection
    {
        public static ContainerBuilder RegisterTypes(ContainerBuilder builder, Func<IComponentContext, OticasContext> funcContext)  
        {
            RegisterContext(builder, funcContext);
            RegisterServices(builder);
            RegisterApplication(builder);
            RegisterRepositories(builder);

            return builder;
        }

        private static void RegisterContext(ContainerBuilder builder, Func<IComponentContext, OticasContext> funcContext)
        {
            builder.Register(funcContext).As<OticasContext>().InstancePerRequest();
            builder.Register(x =>  new UnitOfWork(x.Resolve<OticasContext>())).As<IUnitOfWork>().InstancePerRequest();
        }

        private static void RegisterServices(ContainerBuilder builder)
        {
            builder.RegisterType<TaxAuthorityComunicationFileService>().As<ITaxAuthorityComunicationFileService>().InstancePerRequest();
            builder.RegisterType<DocumentTypeRepositoryMapperService>().As<IDocumentTypeRepositoryMapperService>().InstancePerRequest();
            builder.RegisterType<AccountingExportService>().As<IAccountingExportService>().InstancePerRequest();

            builder.RegisterType<PurchaseDocumentsService>().As<IPurchaseDocumentsService>().InstancePerRequest();
        }

        private  static void RegisterApplication(ContainerBuilder builder)
        {
            builder.RegisterType<TaxAuthorityComunicationApplication>().As<IApplicationTaxAuthorityComunication > ().InstancePerRequest();
            builder.RegisterType<AccountingConfigurationApplication>().As<IAccountingConfigurationApplication>().InstancePerRequest();
            builder.RegisterType<AccountingExportApplication>().As<IAccountingExportApplication>().InstancePerRequest();
        }

        private static void RegisterRepositories(ContainerBuilder builder)
        {
            builder.RegisterType<ProductRepository>().As<IProductRepository>().InstancePerRequest();

            builder.RegisterType<DocumentTypeRepository>().As<IDocumentTypeRepository>().InstancePerRequest();

            builder.RegisterType<TaxAuthorityComunicationRepository>().As<ITaxAuthorityComunicationRepository>().InstancePerRequest();

            builder.RegisterType<AccountingConfigurationRepository>().As<IAccountingConfigurationRepository>().InstancePerRequest();
            builder.RegisterType<AccountingConfigurationModuleRepository>().As<IAccountingConfigurationModuleRepository>().InstancePerRequest();
            builder.RegisterType<AccountingConfigurationTypeRepository>().As<IAccountingConfigurationTypeRepository>().InstancePerRequest();
            builder.RegisterType<AccountingConfigurationTypeRepository>().As<IAccountingConfigurationTypeRepository>().InstancePerRequest();
            builder.RegisterType<AccountingConfigurationDocumentTypeRepository>().As<IAccountingConfigurationDocumentTypeRepository>().InstancePerRequest();
            builder.RegisterType<AccountingConfigurationEntityRepository>().As<IAccountingConfigurationEntityRepository>().InstancePerRequest();
            builder.RegisterType<AccountingExportRepository>().As<IAccountingExportRepository>().InstancePerRequest();

            builder.RegisterType<SaleDocumentRepository>().As<ISaleDocumentRepository>().InstancePerRequest();
            builder.RegisterType<SaleDocumentLineRepository>().As<ISaleDocumentLineRepository>().InstancePerRequest();

            builder.RegisterType<PurchaseDocumentRepository>().As<IPurchaseDocumentRepository>().InstancePerRequest();
            builder.RegisterType<PurchaseDocumentLineRepository>().As<IPurchaseDocumentLineRepository>().InstancePerRequest();

            builder.RegisterType<ProviderPaymentDocumentRepository>().As<IProviderPaymentDocumentRepository>().InstancePerRequest();
            builder.RegisterType<ProviderPaymentDocumentLineRepository>().As<IProviderPaymentDocumentLineRepository>().InstancePerRequest();
            builder.RegisterType<ProviderPaymentDocumentPaymentTypeRepository>().As<IProviderPaymentDocumentPaymentTypeRepository>().InstancePerRequest();

            builder.RegisterType<StockDocumentRepository>().As<IStockDocumentRepository>().InstancePerRequest();
            builder.RegisterType<StockDocumentLineRepository>().As<IStockDocumentLineRepository>().InstancePerRequest();

            builder.RegisterType<ReceiptDocumentRepository>().As<IReceiptDocumentRepository>().InstancePerRequest();
            builder.RegisterType<ReceiptDocumentLineRepository>().As<IReceiptDocumentLineRepository>().InstancePerRequest();
            builder.RegisterType<ReceiptDocumentPaymentTypeRepository>().As<IReceiptDocumentPaymentTypeRepository>().InstancePerRequest();

            builder.RegisterType<SystemEntityStateRepository>().As<ISystemEntityStateRepository>().InstancePerRequest();
            builder.RegisterType<SystemEntityTypeRepository>().As<ISystemEntityTypeRepository>().InstancePerRequest();
            builder.RegisterType<SystemSexRepository>().As<ISystemSexRepository>().InstancePerRequest();
            builder.RegisterType<SystemStateTypeRepository>().As<ISystemStateTypeRepository>().InstancePerRequest();
        }
    }
}