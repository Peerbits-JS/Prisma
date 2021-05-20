using F3M.Oticas.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace F3M.Oticas.Data.Mapping
{
    public class ReceiptDocumentMap : IEntityTypeConfiguration<ReceiptDocument>
    {
        public void Configure(EntityTypeBuilder<ReceiptDocument> entity)
        {
            entity.ToTable("tbRecibos");

            entity.Property(e => e.Id).HasColumnName("ID");

            entity.Property(e => e.StoreSocialCapital).HasColumnName("CapitalSocialLoja").HasMaxLength(255);

            entity.Property(e => e.DocumentOriginCode).HasMaxLength(255);

            entity.Property(e => e.EntityCode).HasColumnName("CodigoDocOrigem").HasMaxLength(20);

            entity.Property(e => e.CurrencyCode).HasColumnName("CodigoMoeda").HasMaxLength(20);

            entity.Property(e => e.PrintFiscalZipCode).HasColumnName("CodigoPostalFiscal").HasMaxLength(50);

            entity.Property(e => e.StoreZipCode).HasColumnName("CodigoPostalLoja").HasMaxLength(8);

            entity.Property(e => e.TypeStateCode).HasColumnName("CodigoTipoEstado").HasMaxLength(20);

            entity.Property(e => e.StoreCommercialRegistryOffice).HasColumnName("ConservatoriaRegistoComerciaLoja").HasMaxLength(255);

            entity.Property(e => e.FiscalTaxPayer).HasColumnName("ContribuinteFiscal").HasMaxLength(25);

            entity.Property(e => e.SignatureDate).HasColumnName("DataAssinatura").HasColumnType("datetime");

            entity.Property(e => e.DocumentDate).HasColumnName("DataDocumento").HasColumnType("datetime");

            entity.Property(e => e.StateTime).HasColumnName("DataHoraEstado").HasColumnType("datetime");

            entity.Property(e => e.LastPrintDate).HasColumnName("DataUltimaImpressao").HasColumnType("datetime");

            entity.Property(e => e.DueDate).HasColumnName("DataVencimento").HasColumnType("datetime");

            entity.Property(e => e.FiscalZipCodeDescription).HasColumnName("DescricaoCodigoPostalFiscal").HasMaxLength(50);

            entity.Property(e => e.FiscalCountyDescription).HasColumnName("DescricaoConcelhoFiscal").HasMaxLength(50);

            entity.Property(e => e.FiscalDistrictDescription).HasColumnName("DescricaoDistritoFiscal").HasMaxLength(50);

            entity.Property(e => e.StoreBusinessName).HasColumnName("DesignacaoComercialLoja").HasMaxLength(160);

            entity.Property(e => e.Document).HasColumnName("Documento").HasMaxLength(255);

            entity.Property(e => e.StoreMail).HasColumnName("EmailLoja").HasMaxLength(255);

            entity.Property(e => e.StoreFax).HasColumnName("FaxLoja").HasMaxLength(50);

            entity.Property(e => e.FiscalZipCodeId).HasColumnName("IDCodigoPostalFiscal");

            entity.Property(e => e.FiscalCountyId).HasColumnName("IDConcelhoFiscal");

            entity.Property(e => e.FiscalDistrictId).HasColumnName("IDDistritoFiscal");

            entity.Property(e => e.EntityId).HasColumnName("IDEntidade");

            entity.Property(e => e.StateId).HasColumnName("IDEstado");

            entity.Property(e => e.OperationCodeId).HasColumnName("IDLocalOperacao");

            entity.Property(e => e.StoreId).HasColumnName("IDLoja");

            entity.Property(e => e.StoreLastPrintId).HasColumnName("IDLojaUltimaImpressao");

            entity.Property(e => e.CurrencyId).HasColumnName("IDMoeda");

            entity.Property(e => e.IdpagamentoVenda).HasColumnName("IDPagamentoVenda");

            entity.Property(e => e.FiscalCountryId).HasColumnName("IDPaisFiscal");

            entity.Property(e => e.DocumentTypeId).HasColumnName("IDTipoDocumento");

            entity.Property(e => e.EntityTypeId).HasColumnName("IDTipoEntidade");

            entity.Property(e => e.DocumentTypeSeriesId).HasColumnName("IDTiposDocumentoSeries");

            entity.Property(e => e.StoreCounty).HasColumnName("LocalidadeLoja").HasMaxLength(50);

            entity.Property(e => e.ATDocumentMessage).HasColumnName("MensagemDocAT").HasMaxLength(1000);

            entity.Property(e => e.FiscalAddress).HasColumnName("MoradaFiscal").HasMaxLength(100);

            entity.Property(e => e.StoreAddress).HasColumnName("MoradaLoja").HasMaxLength(100);

            entity.Property(e => e.StoreTaxPayer).HasColumnName("NIFLoja").HasMaxLength(9);

            entity.Property(e => e.FiscalName).HasColumnName("NomeFiscal").HasMaxLength(200);

            entity.Property(e => e.StoreBusinessRegistrationNumber).HasColumnName("NumeroRegistoComercialLoja").HasMaxLength(255);

            entity.Property(e => e.StoreAcronym).HasColumnName("SiglaLoja").HasMaxLength(3);

            entity.Property(e => e.CountryFiscalAcronym).HasColumnName("SiglaPaisFiscal").HasMaxLength(15);

            entity.Property(e => e.StorePhone).HasColumnName("TelefoneLoja").HasMaxLength(50);

            entity.Property(e => e.FiscalType).HasColumnName("TipoFiscal").HasMaxLength(20);

            entity.Property(e => e.StateUser).HasColumnName("UtilizadorEstado").HasMaxLength(20);

            entity.Property(e => e.ValorExtenso).HasMaxLength(4000);

            entity.Property(e => e.Notes).HasColumnName("Observacoes");

            entity.Property(e => e.ConversionRate).HasColumnName("TaxaConversao");

            entity.Property(e => e.DocumentNumber).HasColumnName("NumeroDocumento");

            entity.Property(e => e.DocumentOriginCode).HasColumnName("CodigoDocOrigem").HasMaxLength(20);

            entity.Property(e => e.TotalReferenceCurrency).HasColumnName("TotalMoedaReferencia");

            entity.Property(e => e.TotalCurrencyDocument).HasColumnName("TotalMoedaDocumento");

            entity.Property(e => e.TaxValue).HasColumnName("ValorImposto");

            entity.Property(e => e.NumberOfPrints).HasColumnName("NumeroImpressoes");

            entity.Property(e => e.IsSecondDocumentPath).HasColumnName("SegundaVia");

            entity.Property(e => e.CreatedAt).HasColumnName("DataCriacao").HasColumnType("datetime").HasDefaultValueSql("(getdate())");

            entity.Property(e => e.UpdatedBy).HasColumnName("UtilizadorAlteracao").HasMaxLength(20).HasDefaultValueSql("('')");

            entity.Property(e => e.CreatedBy).HasColumnName("UtilizadorCriacao").IsRequired().HasMaxLength(20).HasDefaultValueSql("('')");

            entity.Property(e => e.UpdatedAt).HasColumnName("DataAlteracao").HasColumnType("datetime").HasDefaultValueSql("(getdate())");

            entity.Property(e => e.IsSystem).HasColumnName("Sistema");

            entity.Property(e => e.IsActive).HasColumnName("Ativo").IsRequired().HasDefaultValueSql("((1))");

            entity.Property(e => e.F3MMarker).HasColumnName("F3MMarcador").IsRowVersion();

            entity.HasOne(d => d.FiscalZipCode)
                .WithMany(p => p.TbRecibos)
                .HasForeignKey(d => d.FiscalZipCodeId)
                .HasConstraintName("FK_tbRecibos_tbCodigosPostais");

            entity.HasOne(d => d.FiscalCounty)
                .WithMany(p => p.TbRecibos)
                .HasForeignKey(d => d.FiscalCountyId)
                .HasConstraintName("FK_tbRecibos_tbConcelhos");

            entity.HasOne(d => d.FiscalDistrict)
                .WithMany(p => p.TbRecibos)
                .HasForeignKey(d => d.FiscalDistrictId)
                .HasConstraintName("FK_tbRecibos_tbDistritos");

            entity.HasOne(d => d.Entity)
                .WithMany(p => p.TbRecibos)
                .HasForeignKey(d => d.EntityId)
                .HasConstraintName("FK_tbRecibos_tbClientes");

            entity.HasOne(d => d.State)
                .WithMany(p => p.ReceiptDocument)
                .HasForeignKey(d => d.StateId)
                .HasConstraintName("FK_tbRecibos_tbEstados");

            entity.HasOne(d => d.OperationCode)
                .WithMany(p => p.TbRecibos)
                .HasForeignKey(d => d.OperationCodeId)
                .HasConstraintName("FK_tbRecibos_tbSistemaRegioesIVA");

            entity.HasOne(d => d.Store)
                .WithMany(p => p.TbRecibos)
                .HasForeignKey(d => d.StoreId)
                .HasConstraintName("FK_tbRecibos_tbLojas");

            entity.HasOne(d => d.Currency)
                .WithMany(p => p.TbRecibos)
                .HasForeignKey(d => d.CurrencyId)
                .HasConstraintName("FK_tbRecibos_tbMoedas");

            entity.HasOne(d => d.IdpagamentoVendaNavigation)
                .WithMany(p => p.TbRecibos)
                .HasForeignKey(d => d.IdpagamentoVenda)
                .HasConstraintName("FK_tbRecibos_tbPagamentosVendas");

            entity.HasOne(d => d.FiscalCountry)
                .WithMany(p => p.ReceiptDocument)
                .HasForeignKey(d => d.FiscalCountryId)
                .HasConstraintName("FK_tbRecibos_tbPaises");

            entity.HasOne(d => d.DocumentType)
                .WithMany(p => p.TbRecibos)
                .HasForeignKey(d => d.DocumentTypeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbRecibos_tbTiposDocumento");

            entity.HasOne(d => d.EntityType)
                .WithMany(p => p.ReceiptDocument)
                .HasForeignKey(d => d.EntityTypeId)
                .HasConstraintName("FK_tbrecibos_tbSistemaTiposEntidade");

            entity.HasOne(d => d.DocumentTypeSeries)
                .WithMany(p => p.TbRecibos)
                .HasForeignKey(d => d.DocumentTypeSeriesId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbRecibos_tbTiposDocumentoSeries");
        }
    }
}