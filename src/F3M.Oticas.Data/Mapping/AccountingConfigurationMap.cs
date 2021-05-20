using F3M.Oticas.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace F3M.Oticas.Data.Mapping
{
    public class AccountingConfigurationMap : IEntityTypeConfiguration<AccountingConfiguration>
    {
        public void Configure(EntityTypeBuilder<AccountingConfiguration> entity)
        {
            entity.ToTable("tbContabilidadeConfiguracao");

            entity.HasKey(e => e.Id).HasName("ID");

            entity.Property(e => e.Year).IsRequired().HasColumnName("Ano").HasMaxLength(10);

            entity.Property(e => e.ModuleCode).IsRequired().HasColumnName("CodigoModulo").HasMaxLength(50);

            entity.Property(e => e.ModuleDescription).IsRequired().HasColumnName("DescricaoModulo").HasMaxLength(256);

            entity.Property(e => e.TypeCode).IsRequired().HasColumnName("CodigoTipo").HasMaxLength(50);

            entity.Property(e => e.TypeDescription).IsRequired().HasColumnName("DescricaoTipo").HasMaxLength(256);

            entity.Property(e => e.AlternativeCode).IsRequired().HasColumnName("CodigoAlternativa").HasMaxLength(50);

            entity.Property(e => e.AlternativeDescription).IsRequired().HasColumnName("DescricaoAlternativa").HasMaxLength(256);

            entity.Property(e => e.IsPreset).HasColumnName("Predefinido").HasDefaultValueSql("((0))");

            entity.Property(e => e.JournalCode).HasColumnName("Diario").HasMaxLength(50);

            entity.Property(e => e.DocumentCode).HasColumnName("CodDocumento").HasMaxLength(50);

            entity.Property(e => e.ReflectsIVAClassByFinancialAccount).HasColumnName("RefleteClasseIVAContaFinanceira").HasDefaultValueSql("((0))");

            entity.Property(e => e.ReflectsCostCenterByFinancialAccount).HasColumnName("RefleteCentroCustoContaFinanceira").HasDefaultValueSql("((0))");

            entity.Property(e => e.CreatedAt).HasColumnName("DataCriacao").HasColumnType("datetime").HasDefaultValueSql("(getdate())");

            entity.Property(e => e.UpdatedBy).HasColumnName("UtilizadorAlteracao").HasMaxLength(20).HasDefaultValueSql("('')");

            entity.Property(e => e.CreatedBy).HasColumnName("UtilizadorCriacao").IsRequired().HasMaxLength(20).HasDefaultValueSql("('')");

            entity.Property(e => e.UpdatedAt).HasColumnName("DataAlteracao").HasColumnType("datetime").HasDefaultValueSql("(getdate())");

            entity.Property(e => e.IsSystem).HasColumnName("Sistema");

            entity.Property(e => e.IsActive).HasColumnName("Ativo").IsRequired().HasDefaultValueSql("((1))");

            entity.Property(e => e.F3MMarker).HasColumnName("F3MMarcador").IsRowVersion();
        }
    }
}