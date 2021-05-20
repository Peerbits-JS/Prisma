using F3M.Oticas.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Text;

namespace F3M.Oticas.Data.Mapping
{
    public class SaleDocumentMap : IEntityTypeConfiguration<SaleDocument>
    {
        public void Configure(EntityTypeBuilder<SaleDocument> entity)
        {
            entity.ToTable("tbDocumentosVendas");

            entity.HasKey(e => e.Id)
               .HasName("ID");

            entity.HasIndex(e => new { e.DocumentTypeId, e.DocumentTypeSeriesId, e.DocumentNumber, e.InternalNumber })
                .HasName("IX_tbDocumentosVendas_Chave")
                .IsUnique();

            entity.Property(e => e.DocumentNumber)
                .HasColumnName("NumeroDocumento");

            entity.Property(e => e.Id)
                .HasColumnName("ID");

            entity.Property(e => e.Notes)
                .HasColumnName("Observacoes");

            entity.Property(e => e.ConversionRate)
                .HasColumnName("TaxaConversao");

            entity.Property(e => e.TotalCurrencyDocument)
                .HasColumnName("TotalMoedaDocumento");
            
            entity.Property(e => e.TotalReferenceCurrency)
                .HasColumnName("TotalMoedaReferencia");

            entity.Property(e => e.Signature)
                .HasColumnName("Assinatura")
                .HasMaxLength(255);

            entity.Property(e => e.PrivateKeyVersion)
                .HasColumnName("VersaoChavePrivada");

            entity.Property(e => e.IsActive)
                .HasColumnName("Ativo")
                .IsRequired()
                .HasDefaultValueSql("((1))");

            entity.Property(e => e.StoreSocialCapital)
                .HasColumnName("CapitalSocialLoja")
                .HasMaxLength(255);

            entity.Property(e => e.ATCode)
                .HasColumnName("CodigoAT")
                .HasMaxLength(200);

            entity.Property(e => e.ATInternalCode)
                .HasColumnName("CodigoATInterno")
                .HasMaxLength(200);

            entity.Property(e => e.DocumentOriginCode)
                .HasColumnName("CodigoDocOrigem")
                .HasMaxLength(255);

            entity.Property(e => e.EntityCode)
                .HasColumnName("CodigoEntidade")
                .HasMaxLength(20);

            entity.Property(e => e.CurrencyCode)
                .HasColumnName("CodigoMoeda")
                .HasMaxLength(20);

            entity.Property(e => e.PrintLoadZipCode)
                .HasColumnName("CodigoPostalCarga")
                .HasMaxLength(20);

            entity.Property(e => e.DownloadZipCode)
                .HasColumnName("CodigoPostalDescarga")
                .HasMaxLength(20);

            entity.Property(e => e.PrintFiscalZipCode)
                .HasColumnName("CodigoPostalFiscal")
                .HasMaxLength(10);

            entity.Property(e => e.StoreZipCode)
                .HasColumnName("CodigoPostalLoja")
                .HasMaxLength(8);

            entity.Property(e => e.SystemUnitPricesTypeCode)
                .HasColumnName("CodigoSisTiposDocPU")
                .HasMaxLength(6);

            entity.Property(e => e.TypeStateCode)
                .HasColumnName("CodigoTipoEstado")
                .HasMaxLength(20);

            entity.Property(e => e.PrintLoadCounty)
                .HasColumnName("ConcelhoCarga")
                .HasMaxLength(255);

            entity.Property(e => e.PrintDownloadCounty)
                .HasColumnName("ConcelhoDescarga")
                .HasMaxLength(255);

            entity.Property(e => e.StoreCommercialRegistryOffice)
                .HasColumnName("ConservatoriaRegistoComerciaLoja")
                .HasMaxLength(255);

            entity.Property(e => e.FiscalTaxPayer)
                .HasColumnName("ContribuinteFiscal")
                .HasMaxLength(25);

            entity.Property(e => e.UpdatedAt)
                .HasColumnName("DataAlteracao")
                .HasColumnType("datetime")
                .HasDefaultValueSql("(getdate())");

            entity.Property(e => e.SignatureDate)
                .HasColumnName("DataAssinatura")
                .HasColumnType("datetime");

            entity.Property(e => e.LoadDate)
                .HasColumnName("DataCarga")
                .HasColumnType("datetime");

            entity.Property(e => e.InternalControlDate)
                .HasColumnName("DataControloInterno")
                .HasColumnType("datetime");

            entity.Property(e => e.CreatedAt)
                .HasColumnName("DataCriacao")
                .HasColumnType("datetime")
                .HasDefaultValueSql("(getdate())");

            entity.Property(e => e.DownloadDate)
                .HasColumnName("DataDescarga")
                .HasColumnType("datetime");

            entity.Property(e => e.DocumentDate)
                .HasColumnName("DataDocumento")
                .HasColumnType("datetime");

            entity.Property(e => e.DeliveryDate)
                .HasColumnName("DataEntrega")
                .HasColumnType("datetime");

            entity.Property(e => e.StateTime)
                .HasColumnName("DataHoraEstado")
                .HasColumnType("datetime");

            entity.Property(e => e.BirthdayDate)
                .HasColumnName("DataNascimento")
                .HasColumnType("datetime");

            entity.Property(e => e.LastPrintDate)
                .HasColumnName("DataUltimaImpressao")
                .HasColumnType("datetime");

            entity.Property(e => e.DueDate)
                .HasColumnName("DataVencimento")
                .HasColumnType("datetime");

            entity.Property(e => e.FiscalZipCodeDescription)
                .HasColumnName("DescricaoCodigoPostalFiscal")
                .HasMaxLength(50);

            entity.Property(e => e.FiscalCountyDescription)
                .HasColumnName("DescricaoConcelhoFiscal")
                .HasMaxLength(50);

            entity.Property(e => e.FiscalDistrictDescription)
                .HasColumnName("DescricaoDistritoFiscal")
                .HasMaxLength(50);

            entity.Property(e => e.StoreBusinessName)
                .HasColumnName("DesignacaoComercialLoja")
                .HasMaxLength(160);

            entity.Property(e => e.PrintLoadDistrict)
                .HasColumnName("DistritoCarga")
                .HasMaxLength(255);

            entity.Property(e => e.PrintDownloadDistrict)
                .HasColumnName("DistritoDescarga")
                .HasMaxLength(255);

            entity.Property(e => e.Document)
                .HasColumnName("Documento")
                .HasMaxLength(50);

            entity.Property(e => e.Mail)
                .HasColumnName("Email")
                .HasMaxLength(255);

            entity.Property(e => e.StoreMail)
                .HasColumnName("EmailLoja")
                .HasMaxLength(255);

            entity.Property(e => e.PrintFiscalSpaceCharges)
                .HasColumnName("EspacoFiscalPortes")
                .HasMaxLength(50);

            entity.Property(e => e.F3MMarker)
                .HasColumnName("F3MMarcador")
                .IsRowVersion();

            entity.Property(e => e.StoreFax)
                .HasColumnName("FaxLoja")
                .HasMaxLength(50);

            entity.Property(e => e.LoadTime)
                .HasColumnName("HoraCarga")
                .HasColumnType("datetime");

            entity.Property(e => e.DownloadTime)
                .HasColumnName("HoraDescarga")
                .HasColumnType("datetime");

            entity.Property(e => e.IdCustomer)
                .HasColumnName("IDCliente");

            entity.Property(e => e.LoadZipCodeId)
                .HasColumnName("IDCodigoPostalCarga");

            entity.Property(e => e.DownloadZipCodeId)
                .HasColumnName("IDCodigoPostalDescarga");

            entity.Property(e => e.ReceiverZipCodeId)
                .HasColumnName("IDCodigoPostalDestinatario");

            entity.Property(e => e.FiscalZipCodeId)
                .HasColumnName("IDCodigoPostalFiscal");

            entity.Property(e => e.LoadCountyId)
                .HasColumnName("IDConcelhoCarga");

            entity.Property(e => e.DownloadCountyId)
                .HasColumnName("IDConcelhoDescarga");

            entity.Property(e => e.ReceiverCountyId)
                .HasColumnName("IDConcelhoDestinatario");

            entity.Property(e => e.FiscalCountyId)
                .HasColumnName("IDConcelhoFiscal");

            entity.Property(e => e.PaymentTypeId)
                .HasColumnName("IDCondicaoPagamento");

            entity.Property(e => e.LoadDistrictId).
                HasColumnName("IDDistritoCarga");

            entity.Property(e => e.DownloadDistrictId)
                .HasColumnName("IDDistritoDescarga");

            entity.Property(e => e.ReceiverDistrictId)
                .HasColumnName("IDDistritoDestinatario");

            entity.Property(e => e.FiscalDistrictId)
                .HasColumnName("IDDistritoFiscal");

            entity.Property(e => e.EntityId)
                .HasColumnName("IDEntidade");

            entity.Property(e => e.IdEntityOne)
                .HasColumnName("IDEntidade1");

            entity.Property(e => e.IdEntityTwo)
                .HasColumnName("IDEntidade2");

            entity.Property(e => e.FiscalSpaceId)
                .HasColumnName("IDEspacoFiscal");

            entity.Property(e => e.FiscalSpaceChargesId).HasColumnName("IDEspacoFiscalPortes");

            entity.Property(e => e.StateId)
                .HasColumnName("IDEstado");

            entity.Property(e => e.ShippingWayId)
                .HasColumnName("IDFormaExpedicao");

            entity.Property(e => e.OperationCodeId)
                .HasColumnName("IDLocalOperacao");

            entity.Property(e => e.StoreId)
                .HasColumnName("IDLoja");

            entity.Property(e => e.HeadStoreId)
                .HasColumnName("IDLojaSede");

            //new
            entity.Property(e => e.IsPrinted)
                .HasColumnName("Impresso");

            //new
            entity.Property(e => e.TaxValue)
                .HasColumnName("ValorImposto");

            //new
            entity.Property(e => e.DiscountPercentage)
                .HasColumnName("PercentagemDesconto");

            //new
            entity.Property(e => e.DiscountValue)
                .HasColumnName("ValorDesconto");

            //new
            entity.Property(e => e.ChargesValue)
                .HasColumnName("ValorPortes");

            //new
            entity.Property(e => e.PrintVatRateCharges)
                .HasColumnName("TaxaIvaPortes");

            //new
            entity.Property(e => e.IsSystem)
                .HasColumnName("Sistema");

            //new
            entity.Property(e => e.AddicionalCosts)
                .HasColumnName("CustosAdicionais");

            //new
            entity.Property(e => e.InternalNumber)
                .HasColumnName("NumeroInterno");

            //new
            entity.Property(e => e.Age)
                .HasColumnName("Idade");

            //new
            entity.Property(e => e.LinesDiscounts)
                .HasColumnName("DescontosLinha");

            //new
            entity.Property(e => e.OtherDiscounts)
                .HasColumnName("OutrosDescontos");

            //new
            entity.Property(e => e.TotalOfPoints)
                .HasColumnName("TotalPontos");

            //new
            entity.Property(e => e.TotalOfGiftVouchers)
                .HasColumnName("TotalValesOferta");

            //new
            entity.Property(e => e.VatTotal)
                .HasColumnName("TotalIva");

            //new
            entity.Property(e => e.TotalEntityOne)
                .HasColumnName("TotalEntidade1");

            //new
            entity.Property(e => e.TotalEntityTwo)
                .HasColumnName("TotalEntidade2");

            //new
            entity.Property(e => e.IsAutomaticEntityOne)
                .HasColumnName("Entidade1Automatica");

            //new
            entity.Property(e => e.AmmountPaid)
                .HasColumnName("ValorPago");

            //new
            entity.Property(e => e.IsManualDocument)
                .HasColumnName("DocManual");

            //new
            entity.Property(e => e.IsSecondDocumentPath)
                .HasColumnName("SegundaVia");

            //new
            entity.Property(e => e.IsSatisfied)
                .HasColumnName("Satisfeito");

            //new
            entity.Property(e => e.NumberOfPrints)
                .HasColumnName("NumeroImpressoes");

            //new
            entity.Property(e => e.IsOriginEntityTwo)
                .HasColumnName("OrigemEntidade2");

            //new
            entity.Property(e => e.IsDownPayment)
                .HasColumnName("Adiantamento");

            //new
            entity.Property(e => e.IsReplenishmentDocument)
                .HasColumnName("DocReposicao");

            //new
            entity.Property(e => e.TotalCustomerDocumentCurrency)
                .HasColumnName("TotalClienteMoedaDocumento");

            //new
            entity.Property(e => e.TotalCustomerDocumentReferenceCurrency)
                .HasColumnName("TotalClienteMoedaReferencia");

            entity.Property(e => e.StoreLastPrintId)
                .HasColumnName("IDLojaUltimaImpressao");

            entity.Property(e => e.CurrencyId)
                .HasColumnName("IDMoeda");

            entity.Property(e => e.LoadCountryId)
                .HasColumnName("IDPaisCarga");

            entity.Property(e => e.DownloadCountryId)
                .HasColumnName("IDPaisDescarga");

            entity.Property(e => e.FiscalCountryId)
                .HasColumnName("IDPaisFiscal");

            entity.Property(e => e.VatSchemeId)
                .HasColumnName("IDRegimeIva");

            entity.Property(e => e.VatSchemeChargesId)
                .HasColumnName("IDRegimeIvaPortes");

            entity.Property(e => e.SystemUnitPricesTypeId)
                .HasColumnName("IDSisTiposDocPU");

            entity.Property(e => e.VatRateChargesId)
                .HasColumnName("IDTaxaIvaPortes");

            entity.Property(e => e.DocumentTypeId).HasColumnName("IDTipoDocumento");

            entity.Property(e => e.EntityTypeId)
                .HasColumnName("IDTipoEntidade");

            entity.Property(e => e.DocumentTypeSeriesId)
                .HasColumnName("IDTiposDocumentoSeries");

            entity.Property(e => e.LoadPlace)
                .HasColumnName("LocalCarga")
                .HasMaxLength(50);

            entity.Property(e => e.DownloadPlace)
                .HasColumnName("LocalDescarga")
                .HasMaxLength(50);

            entity.Property(e => e.StoreCounty)
                .HasColumnName("LocalidadeLoja")
                .HasMaxLength(50);

            entity.Property(e => e.Registry)
                .HasColumnName("Matricula")
                .HasMaxLength(255);

            entity.Property(e => e.ATDocumentMessage)
                .HasColumnName("MensagemDocAT")
                .HasMaxLength(1000);

            entity.Property(e => e.LoadAddress)
                .HasColumnName("MoradaCarga")
                .HasMaxLength(100);

            entity.Property(e => e.DownloadAdrress)
                .HasColumnName("MoradaDescarga")
                .HasMaxLength(100);

            entity.Property(e => e.ReceiverAddress)
                .HasColumnName("MoradaDestinatario")
                .HasMaxLength(100);

            entity.Property(e => e.FiscalAddress)
                .HasColumnName("MoradaFiscal")
                .HasMaxLength(100);

            entity.Property(e => e.StoreAddress)
                .HasColumnName("MoradaLoja")
                .HasMaxLength(100);

            entity.Property(e => e.ReasonForExemptionFromVat)
                .HasColumnName("MotivoIsencaoIva")
                .HasMaxLength(255);

            entity.Property(e => e.ReasonForExemptionFromCharges)
                .HasColumnName("MotivoIsencaoPortes")
                .HasMaxLength(255);

            entity.Property(e => e.StoreTaxPayer)
                .HasColumnName("NIFLoja")
                .HasMaxLength(9);

            entity.Property(e => e.ReceiverName)
                .HasColumnName("NomeDestinatario")
                .HasMaxLength(100);

            entity.Property(e => e.FiscalName)
                .HasColumnName("NomeFiscal")
                .HasMaxLength(200);

            entity.Property(e => e.NumberOfbeneficiaryOne)
                .HasColumnName("NumeroBeneficiario1")
                .HasMaxLength(50);

            entity.Property(e => e.NumberOfbeneficiaryTwo)
                .HasColumnName("NumeroBeneficiario2")
                .HasMaxLength(50);

            entity.Property(e => e.ManualDocumentNumber)
                .HasColumnName("NumeroDocManual")
                .HasMaxLength(50);

            entity.Property(e => e.ManualNumber)
                .HasColumnName("NumeroManual")
                .HasMaxLength(50);

            entity.Property(e => e.StoreBusinessRegistrationNumber)
                .HasColumnName("NumeroRegistoComercialLoja")
                .HasMaxLength(255);

            entity.Property(e => e.KinshipOne)
                .HasColumnName("Parentesco1")
                .HasMaxLength(50);

            entity.Property(e => e.KinshipTwo)
                .HasColumnName("Parentesco2")
                .HasMaxLength(50);

            entity.Property(e => e.NumberOfLines)
                .HasColumnName("NumeroLinhas");

            entity.Property(e => e.Station)
                .HasColumnName("Posto")
                .HasMaxLength(512);

            entity.Property(e => e.StateReason)
                .HasColumnName("RazaoEstado")
                .HasMaxLength(50);

            entity.Property(e => e.PrintVatSchemeCharges)
                .HasColumnName("RegimeIvaPortes")
                .HasMaxLength(50);

            entity.Property(e => e.ManualDocumentSerie)
                .HasColumnName("SerieDocManual")
                .HasMaxLength(50);

            entity.Property(e => e.ManualSerie)
                .HasColumnName("SerieManual")
                .HasMaxLength(50);

            entity.Property(e => e.StoreAcronym)
                .HasColumnName("SiglaLoja")
                .HasMaxLength(3);

            entity.Property(e => e.LoadCountryAcronym)
                .HasColumnName("SiglaPaisCarga")
                .HasMaxLength(6);

            entity.Property(e => e.DownloadCountryAcronym)
                .HasColumnName("SiglaPaisDescarga")
                .HasMaxLength(6);

            entity.Property(e => e.CountryFiscalAcronym)
                .HasColumnName("SiglaPaisFiscal")
                .HasMaxLength(15);

            entity.Property(e => e.StorePhone)
                .HasColumnName("TelefoneLoja")
                .HasMaxLength(50);

            entity.Property(e => e.FiscalType)
                .HasColumnName("TipoFiscal")
                .HasMaxLength(20);

            entity.Property(e => e.UpdatedBy)
                .HasColumnName("UtilizadorAlteracao")
                .HasMaxLength(20)
                .HasDefaultValueSql("('')");

            entity.Property(e => e.CreatedBy)
                .HasColumnName("UtilizadorCriacao")
                .IsRequired()
                .HasMaxLength(20)
                .HasDefaultValueSql("('')");

            entity.Property(e => e.StateUser)
                .HasColumnName("UtilizadorEstado")
                .HasMaxLength(20);

            entity.Property(e => e.ExternalDocumentNumber)
                .HasColumnName("VossoNumeroDocumento")
                .HasMaxLength(256);

            entity.HasOne(d => d.DowloadZipCode)
                .WithMany(p => p.TbDocumentosVendasIdcodigoPostalDescargaNavigation)
                .HasForeignKey(d => d.DownloadZipCodeId)
                .HasConstraintName("FK_tbDocumentosVendas_tbCodigosPostais_Descarga");

            entity.HasOne(d => d.ReceiverZipCode)
                .WithMany(p => p.TbDocumentosVendasIdcodigoPostalDestinatarioNavigation)
                .HasForeignKey(d => d.ReceiverZipCodeId)
                .HasConstraintName("FK_tbDocumentosVendas_tbCodigosPostais_Destinatario");

            entity.HasOne(d => d.FiscalZipCode)
                .WithMany(p => p.TbDocumentosVendasIdcodigoPostalFiscalNavigation)
                .HasForeignKey(d => d.FiscalZipCodeId)
                .HasConstraintName("FK_tbDocumentosVendas_tbCodigosPostais_Fiscal");

            entity.HasOne(d => d.LoadCounty)
                .WithMany(p => p.TbDocumentosVendasIdconcelhoCargaNavigation)
                .HasForeignKey(d => d.LoadCountyId)
                .HasConstraintName("FK_tbDocumentosVendas_tbConcelhos_Carga");

            entity.HasOne(d => d.DownloadCounty)
                .WithMany(p => p.TbDocumentosVendasIdconcelhoDescargaNavigation)
                .HasForeignKey(d => d.DownloadCountyId)
                .HasConstraintName("FK_tbDocumentosVendas_tbConcelhos_Descarga");

            entity.HasOne(d => d.ReceiverCounty)
                .WithMany(p => p.TbDocumentosVendasIdconcelhoDestinatarioNavigation)
                .HasForeignKey(d => d.ReceiverCountyId)
                .HasConstraintName("FK_tbDocumentosVendas_tbConcelhos_Destinatario");

            entity.HasOne(d => d.FiscalCounty)
                .WithMany(p => p.TbDocumentosVendasIdconcelhoFiscalNavigation)
                .HasForeignKey(d => d.FiscalCountyId)
                .HasConstraintName("FK_tbDocumentosVendas_tbConcelhos_Fiscal");

            entity.HasOne(d => d.PaymentType)
                .WithMany(p => p.TbDocumentosVendas)
                .HasForeignKey(d => d.PaymentTypeId)
                .HasConstraintName("FK_tbDocumentosVendas_tbCondicoesPagamento");

            entity.HasOne(d => d.LoadDistrict)
                .WithMany(p => p.TbDocumentosVendasIddistritoCargaNavigation)
                .HasForeignKey(d => d.LoadDistrictId)
                .HasConstraintName("FK_tbDocumentosVendas_tbDistritos_Carga");

            entity.HasOne(d => d.DownloadDistrict)
                .WithMany(p => p.TbDocumentosVendasIddistritoDescargaNavigation)
                .HasForeignKey(d => d.DownloadDistrictId)
                .HasConstraintName("FK_tbDocumentosVendas_tbDistritos_Descarga");

            entity.HasOne(d => d.ReceiverDistrict)
                .WithMany(p => p.TbDocumentosVendasIddistritoDestinatarioNavigation)
                .HasForeignKey(d => d.ReceiverDistrictId)
                .HasConstraintName("FK_tbDocumentosVendas_tbDistritos_Destinatario");

            entity.HasOne(d => d.FiscalDistrict)
                .WithMany(p => p.TbDocumentosVendasIddistritoFiscalNavigation)
                .HasForeignKey(d => d.FiscalDistrictId)
                .HasConstraintName("FK_tbDocumentosVendas_tbDistritos_Fiscal");

            entity.HasOne(d => d.Entity)
                .WithMany(p => p.TbDocumentosVendas)
                .HasForeignKey(d => d.EntityId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbDocumentosVendas_tbClientes");

            entity.HasOne(d => d.EntityOne)
                .WithMany(p => p.TbDocumentosVendasIdentidade1Navigation)
                .HasForeignKey(d => d.IdEntityOne)
                .HasConstraintName("FK_tbDocumentosVendas_tbEntidades1");

            entity.HasOne(d => d.EntityTwo)
                .WithMany(p => p.TbDocumentosVendasIdentidade2Navigation)
                .HasForeignKey(d => d.IdEntityTwo)
                .HasConstraintName("FK_tbDocumentosVendas_tbEntidades2");

            entity.HasOne(d => d.FiscalSpace)
                .WithMany(p => p.TbDocumentosVendasIdespacoFiscalNavigation)
                .HasForeignKey(d => d.FiscalSpaceId)
                .HasConstraintName("FK_tbDocumentosVendas_tbSistemaEspacoFiscal1");

            entity.HasOne(d => d.FiscalSpaceCharges)
                .WithMany(p => p.TbDocumentosVendasIdespacoFiscalPortesNavigation)
                .HasForeignKey(d => d.FiscalSpaceChargesId)
                .HasConstraintName("FK_tbDocumentosVendas_tbSistemaEspacoFiscal");

            entity.HasOne(d => d.State)
                .WithMany(p => p.SaleDocument)
                .HasForeignKey(d => d.StateId)
                .HasConstraintName("FK_tbDocumentosVendas_tbEstados");

            entity.HasOne(d => d.ShippingWay)
                .WithMany(p => p.TbDocumentosVendas)
                .HasForeignKey(d => d.ShippingWayId)
                .HasConstraintName("FK_tbDocumentosVendas_tbFormasExpedicao");

            entity.HasOne(d => d.OperationCode)
                .WithMany(p => p.TbDocumentosVendas)
                .HasForeignKey(d => d.OperationCodeId)
                .HasConstraintName("FK_tbDocumentosVendas_tbSistemaRegioesIVA");

            entity.HasOne(d => d.Store)
                .WithMany(p => p.TbDocumentosVendas)
                .HasForeignKey(d => d.StoreId)
                .HasConstraintName("FK_tbDocumentosVendas_tbLojas");

            entity.HasOne(d => d.Currency)
                .WithMany(p => p.TbDocumentosVendas)
                .HasForeignKey(d => d.CurrencyId)
                .HasConstraintName("FK_tbDocumentosVendas_tbMoedas");

            entity.HasOne(d => d.LoadCountry)
                .WithMany(p => p.LoadCountrySalesDocuments)
                .HasForeignKey(d => d.LoadCountryId)
                .HasConstraintName("FK_tbDocumentosVendas_tbPaises1");

            entity.HasOne(d => d.DownloadCountry)
                .WithMany(p => p.DownLoadCountrySalesDocuments)
                .HasForeignKey(d => d.DownloadCountryId)
                .HasConstraintName("FK_tbDocumentosVendas_tbPaises2");

            entity.HasOne(d => d.FiscalCountry)
                .WithMany(p => p.FiscalCountrySalesDocuments)
                .HasForeignKey(d => d.FiscalCountryId)
                .HasConstraintName("FK_tbDocumentosVendas_tbPaises_Fiscal");

            entity.HasOne(d => d.VatScheme)
                .WithMany(p => p.TbDocumentosVendasIdregimeIvaNavigation)
                .HasForeignKey(d => d.VatSchemeId)
                .HasConstraintName("FK_tbDocumentosVendas_tbSistemaRegimeIVA1");

            entity.HasOne(d => d.VatSchemeCharges)
                .WithMany(p => p.TbDocumentosVendasIdregimeIvaPortesNavigation)
                .HasForeignKey(d => d.VatSchemeChargesId)
                .HasConstraintName("FK_tbDocumentosVendas_tbSistemaRegimeIVA");

            entity.HasOne(d => d.SystemUnitPricesType)
                .WithMany(p => p.TbDocumentosVendas)
                .HasForeignKey(d => d.SystemUnitPricesTypeId)
                .HasConstraintName("FK_tbDocumentosVendas_tbSistemaTiposDocumentoPrecoUnitario");

            entity.HasOne(d => d.VatRateCharges)
                .WithMany(p => p.SaleDocument)
                .HasForeignKey(d => d.VatRateChargesId)
                .HasConstraintName("FK_tbDocumentosVendas_tbIVA_Portes");

            entity.HasOne(d => d.DocumentType)
                .WithMany(p => p.TbDocumentosVendas)
                .HasForeignKey(d => d.DocumentTypeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbDocumentosVendas_tbTiposDocumento");

            entity.HasOne(d => d.EntityType)
                .WithMany(p => p.SaleDocument)
                .HasForeignKey(d => d.EntityTypeId)
                .HasConstraintName("FK_tbDocumentosVendas_tbSistemaTiposEntidade");

            entity.HasOne(d => d.DocumentTypeSeries)
                .WithMany(p => p.TbDocumentosVendas)
                .HasForeignKey(d => d.DocumentTypeSeriesId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbDocumentosVendas_tbTiposDocumentoSeries");

            entity.HasOne(d => d.LoadZipCode)
                .WithMany(p => p.TbDocumentosVendasIdcodigoPostalCargaNavigation)
                .HasForeignKey(d => d.LoadZipCodeId)
                .HasConstraintName("FK_tbDocumentosVendas_tbCodigosPostais_Carga");

        }
    }
}
