using F3M.Oticas.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace F3M.Oticas.Data.Mapping
{
    public class PurchaseDocumentMap : IEntityTypeConfiguration<PurchaseDocument>
    {
        public void Configure(EntityTypeBuilder<PurchaseDocument> entity)
        {
            entity.ToTable("tbDocumentosCompras");

            entity.HasKey(e => e.Id)
                .HasName("ID");

            entity.Property(e => e.Signature)
                .HasColumnName("Assinatura")
                .HasMaxLength(255);

            entity.Property(e => e.IsActive)
                .HasColumnName("Ativo")
                .IsRequired()
                .HasDefaultValueSql("((1))");

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

            entity.Property(e => e.PrintLoadDistrict)
                .HasColumnName("DistritoCarga")
                .HasMaxLength(255);

            entity.Property(e => e.PrintDownloadDistrict)
                .HasColumnName("DistritoDescarga")
                .HasMaxLength(255);

            entity.Property(e => e.Document)
                .HasColumnName("Documento")
                .HasMaxLength(50);

            entity.Property(e => e.PrintFiscalSpaceCharges)
                .HasColumnName("EspacoFiscalPortes")
                .HasMaxLength(50);

            entity.Property(e => e.F3MMarker)
                .HasColumnName("F3MMarcador")
                .IsRowVersion();

            entity.Property(e => e.LoadTime)
                .HasColumnName("HoraCarga")
                .HasColumnType("datetime");

            entity.Property(e => e.DownloadTime)
                .HasColumnName("HoraDescarga")
                .HasColumnType("datetime");

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
                .HasColumnName("IDCondicaoPagamento")
                .HasDefaultValueSql("((13))");

            entity.Property(e => e.LoadDistrictId)
                .HasColumnName("IDDistritoCarga");

            entity.Property(e => e.DownloadDistrictId)
                .HasColumnName("IDDistritoDescarga");

            entity.Property(e => e.ReceiverDistrictId)
                .HasColumnName("IDDistritoDestinatario");

            entity.Property(e => e.FiscalDistrictId)
                .HasColumnName("IDDistritoFiscal");

            entity.Property(e => e.EntityId)
                .HasColumnName("IDEntidade")
                .HasDefaultValueSql("((1))");

            entity.Property(e => e.AmmountPaid)
                .HasColumnName("ValorPago");

            entity.Property(e => e.FiscalSpaceId)
                .HasColumnName("IDEspacoFiscal");

            entity.Property(e => e.FiscalSpaceChargesId)
                .HasColumnName("IDEspacoFiscalPortes");

            entity.Property(e => e.StateId)
                .HasColumnName("IDEstado");

            entity.Property(e => e.ShippingWayId)
                .HasColumnName("IDFormaExpedicao");

            entity.Property(e => e.OperationCodeId)
                .HasColumnName("IDLocalOperacao")
                .HasDefaultValueSql("((1))");

            entity.Property(e => e.StoreId)
                .HasColumnName("IDLoja");

            entity.Property(e => e.HeadStoreId)
                .HasColumnName("IDLojaSede");

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

            entity.Property(e => e.DocumentTypeId)
                .HasColumnName("IDTipoDocumento");

            entity.Property(e => e.EntityTypeId)
                .HasColumnName("IDTipoEntidade")
                .HasDefaultValueSql("((3))");

            entity.Property(e => e.DocumentTypeSeriesId)
                .HasColumnName("IDTiposDocumentoSeries");

            entity.Property(e => e.LoadPlace)
                .HasColumnName("LocalCarga")
                .HasMaxLength(50);

            entity.Property(e => e.DownloadPlace)
                .HasColumnName("LocalDescarga")
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

            entity.Property(e => e.ReasonForExemptionFromVat)
                .HasColumnName("MotivoIsencaoIva")
                .HasMaxLength(255);

            entity.Property(e => e.ReasonForExemptionFromCharges)
                .HasColumnName("MotivoIsencaoPortes")
                .HasMaxLength(255);

            entity.Property(e => e.ReceiverName)
                .HasColumnName("NomeDestinatario")
                .HasMaxLength(100);

            entity.Property(e => e.FiscalName)
               .HasColumnName("NomeFiscal")
               .HasMaxLength(200);

            entity.Property(e => e.ManualDocumentNumber)
               .HasColumnName("NumeroDocManual")
               .HasMaxLength(50);

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

            entity.Property(e => e.LoadCountryAcronym)
                .HasColumnName("SiglaPaisCarga")
                .HasMaxLength(6);

            entity.Property(e => e.DownloadCountryAcronym)
                .HasColumnName("SiglaPaisDescarga")
                .HasMaxLength(6);

            entity.Property(e => e.CountryFiscalAcronym)
                .HasColumnName("SiglaPaisFiscal")
                .HasMaxLength(15);

            entity.Property(e => e.FiscalType)
                .HasColumnName("TipoFiscal")
                .HasMaxLength(20);

            entity.Property(e => e.VatTotal)
                .HasColumnName("TotalIVA");

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

            //new
            entity.Property(e => e.ChargesValue)
                .HasColumnName("ValorPortes");

            //new
            entity.Property(e => e.ConversionRate)
                .HasColumnName("TaxaConversao");

            //new
            entity.Property(e => e.DiscountPercentage)
                .HasColumnName("PercentagemDesconto");

            //new
            entity.Property(e => e.DiscountValue)
                .HasColumnName("ValorDesconto");

            //new
            entity.Property(e => e.AddicionalCosts)
                .HasColumnName("CustosAdicionais");

            //new
            entity.Property(e => e.FiscalDistrictDescription)
                .HasColumnName("DescricaoDistritoFiscal")
                .HasMaxLength(50);

            //new
            entity.Property(e => e.InternalNumber)
                .HasColumnName("NumeroInterno");

            //new
            entity.Property(e => e.IsManualDocument)
                .HasColumnName("DocManual");

            //new
            entity.Property(e => e.IsPrinted)
                .HasColumnName("Impresso");
            
            //new
            entity.Property(e => e.IsReplenishmentDocument)
                .HasColumnName("DocReposicao");

            //new
            entity.Property(e => e.IsSatisfied)
                .HasColumnName("Satisfeito");

            //new
            entity.Property(e => e.IsSecondDocumentPath)
                .HasColumnName("SegundaVia");

            //new
            entity.Property(e => e.IsSystem)
                .HasColumnName("Sistema");

            //new
            entity.Property(e => e.LinesDiscounts)
                .HasColumnName("DescontosLinha");

            //new
            entity.Property(e => e.Notes)
                .HasColumnName("Observacoes");

            //new
            entity.Property(e => e.NumberOfPrints)
                .HasColumnName("NumeroImpressoes");

            //new
            entity.Property(e => e.NumberOfLines)
                .HasColumnName("NumeroLinhas");

            //new
            entity.Property(e => e.PrintFiscalSpaceCharges)
                .HasColumnName("EspacoFiscalPortes")
                .HasMaxLength(50);

            //new
            entity.Property(e => e.PrintVatRateCharges)
                .HasColumnName("TaxaIvaPortes");

            //new
            entity.Property(e => e.TaxValue)
                .HasColumnName("ValorImposto");

            //new
            entity.Property(e => e.TotalCurrencyDocument)
                .HasColumnName("TotalMoedaDocumento");

            //new
            entity.Property(e => e.TotalReferenceCurrency)
                .HasColumnName("TotalMoedaReferencia");

            entity.Property(e => e.PrivateKeyVersion)
                .HasColumnName("VersaoChavePrivada");

            //new
            entity.Property(e => e.DocumentNumber)
                .HasColumnName("NumeroDocumento");

            entity.Property(e => e.SubTotal)
                .HasColumnName("SubTotal");

            entity.Property(e => e.StockDocumentId)
                .HasColumnName("IDDocReserva");


            entity.HasOne(d => d.Entity)
                .WithMany(p => p.TbDocumentosCompras)
                .HasForeignKey(d => d.EntityId)
                .HasConstraintName("FK_tbDocumentosCompras_tbFornecedores");

            entity.HasOne(d => d.LoadZipCode)
                .WithMany(p => p.TbDocumentosComprasIdcodigoPostalCargaNavigation)
                .HasForeignKey(d => d.LoadZipCodeId)
                .HasConstraintName("FK_tbDocumentosCompras_tbCodigosPostais_Carga");

            entity.HasOne(d => d.DowloadZipCode)
                .WithMany(p => p.TbDocumentosComprasIdcodigoPostalDescargaNavigation)
                .HasForeignKey(d => d.DownloadZipCodeId)
                .HasConstraintName("FK_tbDocumentosCompras_tbCodigosPostais_Descarga");

            entity.HasOne(d => d.ReceiverZipCode)
                .WithMany(p => p.TbDocumentosComprasIdcodigoPostalDestinatarioNavigation)
                .HasForeignKey(d => d.ReceiverZipCodeId)
                .HasConstraintName("FK_tbDocumentosCompras_tbCodigosPostais_Destinatario");

            entity.HasOne(d => d.FiscalZipCode)
                .WithMany(p => p.TbDocumentosComprasIdcodigoPostalFiscalNavigation)
                .HasForeignKey(d => d.FiscalZipCodeId)
                .HasConstraintName("FK_tbDocumentosCompras_tbCodigosPostais_Fiscal");

            entity.HasOne(d => d.LoadCounty)
                .WithMany(p => p.TbDocumentosComprasIdconcelhoCargaNavigation)
                .HasForeignKey(d => d.LoadCountyId)
                .HasConstraintName("FK_tbDocumentosCompras_tbConcelhos_Carga");

            entity.HasOne(d => d.DownloadCounty)
                .WithMany(p => p.TbDocumentosComprasIdconcelhoDescargaNavigation)
                .HasForeignKey(d => d.DownloadCountyId)
                .HasConstraintName("FK_tbDocumentosCompras_tbConcelhos_Descarga");

            entity.HasOne(d => d.ReceiverCounty)
                .WithMany(p => p.TbDocumentosComprasIdconcelhoDestinatarioNavigation)
                .HasForeignKey(d => d.ReceiverCountyId)
                .HasConstraintName("FK_tbDocumentosCompras_tbConcelhos_Destinatario");

            entity.HasOne(d => d.FiscalCounty)
                .WithMany(p => p.TbDocumentosComprasIdconcelhoFiscalNavigation)
                .HasForeignKey(d => d.FiscalCountyId)
                .HasConstraintName("FK_tbDocumentosCompras_tbConcelhos_Fiscal");

            entity.HasOne(d => d.PaymentType)
                .WithMany(p => p.TbDocumentosCompras)
                .HasForeignKey(d => d.PaymentTypeId)
                .HasConstraintName("FK_tbDocumentosCompras_tbCondicoesPagamento");

            entity.HasOne(d => d.LoadDistrict)
                .WithMany(p => p.TbDocumentosComprasIddistritoCargaNavigation)
                .HasForeignKey(d => d.LoadDistrictId)
                .HasConstraintName("FK_tbDocumentosCompras_tbDistritos_Carga");

            entity.HasOne(d => d.DownloadDistrict)
                .WithMany(p => p.TbDocumentosComprasIddistritoDescargaNavigation)
                .HasForeignKey(d => d.DownloadDistrictId)
                .HasConstraintName("FK_tbDocumentosCompras_tbDistritos_Descarga");

            entity.HasOne(d => d.ReceiverDistrict)
                .WithMany(p => p.TbDocumentosComprasIddistritoDestinatarioNavigation)
                .HasForeignKey(d => d.ReceiverDistrictId)
                .HasConstraintName("FK_tbDocumentosCompras_tbDistritos_Destinatario");

            entity.HasOne(d => d.FiscalDistrict)
                .WithMany(p => p.TbDocumentosComprasIddistritoFiscalNavigation)
                .HasForeignKey(d => d.FiscalDistrictId)
                .HasConstraintName("FK_tbDocumentosCompras_tbDistritos_Fiscal");



            entity.HasOne(d => d.FiscalSpace)
                .WithMany(p => p.TbDocumentosComprasIdespacoFiscalNavigation)
                .HasForeignKey(d => d.FiscalSpaceId)
                .HasConstraintName("FK_tbDocumentosCompras_tbSistemaEspacoFiscal1");

            entity.HasOne(d => d.FiscalSpaceCharges)
                .WithMany(p => p.TbDocumentosComprasIdespacoFiscalPortesNavigation)
                .HasForeignKey(d => d.FiscalSpaceChargesId)
                .HasConstraintName("FK_tbDocumentosCompras_tbSistemaEspacoFiscal");

            entity.HasOne(d => d.State)
                .WithMany(p => p.PurchaseDocument)
                .HasForeignKey(d => d.StateId)
                .HasConstraintName("FK_tbDocumentosCompras_tbEstados");

            entity.HasOne(d => d.ShippingWay)
                .WithMany(p => p.TbDocumentosCompras)
                .HasForeignKey(d => d.ShippingWayId)
                .HasConstraintName("FK_tbDocumentosCompras_tbFormasExpedicao");

            entity.HasOne(d => d.OperationCode)
                .WithMany(p => p.TbDocumentosCompras)
                .HasForeignKey(d => d.OperationCodeId)
                .HasConstraintName("FK_tbDocumentosCompras_tbSistemaRegioesIVA");

            entity.HasOne(d => d.Store)
                .WithMany(p => p.TbDocumentosCompras)
                .HasForeignKey(d => d.StoreId)
                .HasConstraintName("FK_tbDocumentosCompras_tbLojas");

            entity.HasOne(d => d.Currency)
                .WithMany(p => p.TbDocumentosCompras)
                .HasForeignKey(d => d.CurrencyId)
                .HasConstraintName("FK_tbDocumentosCompras_tbMoedas");

            entity.HasOne(d => d.LoadCountry)
                .WithMany(p => p.LoadPurchaseDocuments)
                .HasForeignKey(d => d.LoadCountryId)
                .HasConstraintName("FK_tbDocumentosCompras_tbPaises");

            entity.HasOne(d => d.DownloadCountry)
                .WithMany(p => p.DownloadPurchaseDocuments)
                .HasForeignKey(d => d.DownloadCountryId)
                .HasConstraintName("FK_tbDocumentosCompras_tbPaises_Descarga");

            entity.HasOne(d => d.FiscalCountry)
                .WithMany(p => p.FiscalCountryPurchaseDocuments)
                .HasForeignKey(d => d.FiscalCountryId)
                .HasConstraintName("FK_tbDocumentosCompras_tbPaises_Fiscal");

            entity.HasOne(d => d.VatScheme)
                .WithMany(p => p.TbDocumentosComprasIdregimeIvaNavigation)
                .HasForeignKey(d => d.VatSchemeId)
                .HasConstraintName("FK_tbDocumentosCompras_tbSistemaRegimeIVA1");

            entity.HasOne(d => d.VatSchemeCharges)
                .WithMany(p => p.TbDocumentosComprasIdregimeIvaPortesNavigation)
                .HasForeignKey(d => d.VatSchemeChargesId)
                .HasConstraintName("FK_tbDocumentosCompras_tbSistemaRegimeIVA");

            entity.HasOne(d => d.SystemUnitPricesType)
                .WithMany(p => p.TbDocumentosCompras)
                .HasForeignKey(d => d.SystemUnitPricesTypeId)
                .HasConstraintName("FK_tbDocumentosCompras_tbSistemaTiposDocumentoPrecoUnitario");

            entity.HasOne(d => d.VatRateCharges)
                .WithMany(p => p.PurchaseDocument)
                .HasForeignKey(d => d.VatRateChargesId)
                .HasConstraintName("FK_tbDocumentosCompras_tbIVA_Portes");

            entity.HasOne(d => d.DocumentType)
                .WithMany(p => p.TbDocumentosCompras)
                .HasForeignKey(d => d.DocumentTypeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbDocumentosCompras_tbTiposDocumento");

            entity.HasOne(d => d.EntityType)
                .WithMany(p => p.PurchaseDocument)
                .HasForeignKey(d => d.EntityTypeId)
                .HasConstraintName("FK_tbDocumentosCompras_tbSistemaTiposEntidade");

            entity.HasOne(d => d.DocumentTypeSeries)
                .WithMany(p => p.TbDocumentosCompras)
                .HasForeignKey(d => d.DocumentTypeSeriesId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbDocumentosCompras_tbTiposDocumentoSeries");
        }
    }
}
