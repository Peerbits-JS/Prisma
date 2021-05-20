using F3M.Oticas.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace F3M.Oticas.Data.Mapping
{
    public class AccountingExportMap : IEntityTypeConfiguration<AccountingExport>
    {
        public void Configure(EntityTypeBuilder<AccountingExport> builder)
        {
            builder.ToTable("tbContabilidadeExportacao");

            builder.HasKey(e => e.Id)
                .HasName("ID");

            builder.Property(e => e.Order)
                .HasColumnName("Ordem");

            builder.Property(e => e.DocumentId)
                .HasColumnName("IDDocumento");

            builder.Property(e => e.Document)
                .HasColumnName("Documento");

            builder.Property(e => e.ExternalDocumentNumber)
                .HasColumnName("VossoNumeroDocumento");

            builder.Property(e => e.DocumentNumber)
                .HasColumnName("NumeroDocumento");

            builder.Property(e => e.DocumentDate)
                .HasColumnName("DataDocumento");

            builder.Property(e => e.StoreId)
                .HasColumnName("IDLoja");

            builder.Property(e => e.StoreCode)
                .HasColumnName("CodigoLoja");

            builder.Property(e => e.DocumentTypeId)
                .HasColumnName("IDTiposDocumento");

            builder.Property(e => e.DocumentTypeCode)
                .HasColumnName("CodigoTipoDocumento");

            builder.Property(e => e.SerieDocumentTypeId)
                .HasColumnName("IDTiposDocumentoSeries");

            builder.Property(e => e.SerieDocumentTypeCode)
                .HasColumnName("CodigoTiposDocumentoSeries");

            builder.Property(e => e.EntityId)
                    .HasColumnName("IDEntidade");

            builder.Property(e => e.EntityCode)
                .HasColumnName("CodigoEntidade");

            builder.Property(e => e.Entity)
                .HasColumnName("Entidade");

            builder.Property(e => e.EntityTypeId)
                .HasColumnName("IDTipoEntidade");

            builder.Property(e => e.EntityTypeCode)
                .HasColumnName("CodigoTipoEntidade");

            builder.Property(e => e.JournalCode)
                .HasColumnName("Diario")
                .HasMaxLength(50);

            builder.Property(e => e.DocumentCode)
                .HasColumnName("CodigoDocumento")
                .HasMaxLength(50);

            builder.Property(e => e.OriginAccount)
                .HasColumnName("ContaOrigem")
                .HasMaxLength(256);

            builder.Property(e => e.ReflectsVatClass)
                .HasColumnName("RefleteClasseIVAContaFinanceira")
                .HasDefaultValueSql("((0))");

            builder.Property(e => e.VatClassAccount)
                .HasColumnName("ContaClasseIVA");

            builder.Property(e => e.ReflectsCostCenter)
                .HasColumnName("RefleteCentroCustoContaFinanceira")
                .HasDefaultValueSql("((0))");

            builder.Property(e => e.CostCenterAccount)
                .HasColumnName("ContaCentroCusto");

            builder.Property(e => e.Account)
                .HasColumnName("Conta");

            builder.Property(e => e.Value)
                .HasColumnName("Valor");

            builder.Property(e => e.NatureDescription)
                .HasColumnName("Natureza");

            builder.Property(e => e.IsGenerated)
                .HasColumnName("Gerado");

            builder.Property(e => e.IsExported)
                .HasColumnName("Exportado");

            builder.Property(e => e.HasErrors)
                .HasColumnName("Erro");

            builder.Property(e => e.ErrorNotes)
                .HasColumnName("ListaErros");

            builder.Property(e => e.DocumentModuleTypeCode)
                .HasColumnName("CodigoModulo");

            builder.Property(e => e.DocumentModuleTypeDescription)
                .HasColumnName("DescricaoModulo");

            builder.Property(e => e.AlternativeCode)
                .HasColumnName("CodigoAlternativa");

            builder.Property(e => e.AlternativeDescription)
                .HasColumnName("DescricaoAlternativa");

            builder.Property(e => e.IsCostCenter)
                .HasColumnName("CentroCusto");

            builder.Property(e => e.IsActive)
               .IsRequired()
               .HasColumnName("Ativo")
               .HasDefaultValueSql("((1))");

            builder.Property(e => e.UpdatedAt)
                .HasColumnName("DataAlteracao")
                .HasColumnType("datetime")
                .HasDefaultValueSql("(getdate())");

            builder.Property(e => e.CreatedAt)
                .HasColumnName("DataCriacao")
                .HasColumnType("datetime");

            builder.Property(e => e.F3MMarker)
                .HasColumnName("F3MMarcador")
                .IsRowVersion();

            builder.Property(e => e.UpdatedBy)
                .HasColumnName("UtilizadorAlteracao")
                .HasMaxLength(20);

            builder.Property(e => e.CreatedBy)
                .HasColumnName("UtilizadorCriacao")
                .IsRequired()
                .HasMaxLength(20);

            builder.Property(e => e.IsSystem)
                .HasColumnName("Sistema")
                .HasDefaultValueSql("((0))");
        }
    }
}