using F3M.Oticas.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace F3M.Oticas.Data.Mapping
{
    public class AccountingConfigurationModulesMap : IEntityTypeConfiguration<AccountingConfigurationModule>
    {
        public void Configure(EntityTypeBuilder<AccountingConfigurationModule> builder)
        {
            builder.ToTable("tbContabilidadeConfiguracaoModulos");

            builder.HasKey(e => e.Id)
                .HasName("ID");

            builder.Property(e => e.Code)
                .IsRequired()
                .HasColumnName("Codigo")
                .HasMaxLength(50);

            builder.Property(e => e.Description)
                .IsRequired()
                .HasColumnName("Descricao")
                .HasMaxLength(50);

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
                .HasMaxLength(256);

            builder.Property(e => e.CreatedBy)
                .HasColumnName("UtilizadorCriacao")
                .IsRequired()
                .HasMaxLength(256);

            builder.Property(e => e.IsSystem)
                .HasColumnName("Sistema")
                .HasDefaultValueSql("((0))");
        }

    }
}
