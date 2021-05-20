using F3M.Oticas.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace F3M.Oticas.Data.Mapping
{
    public class AccountingConfigurationDetailMap : IEntityTypeConfiguration<AccountingConfigurationDetail>
    {
        public void Configure(EntityTypeBuilder<AccountingConfigurationDetail> builder)
        {
            builder.ToTable("tbContabilidadeConfiguracaoLinhas");

            builder.HasKey(e => e.Id)
                .HasName("ID");

            builder.Property(e => e.AccountingConfigurationId)
                .HasColumnName("IDConfiguracaoContabilidade");

            builder.Property(e => e.Account)
                .HasColumnName("Conta")
                .HasMaxLength(256);

            builder.Property(e => e.ValueId)
                .HasColumnName("IDValor");

            builder.Property(e => e.ValueDescription)
                .HasColumnName("DescricaoValor")
                .HasMaxLength(256);

            builder.Property(e => e.NatureDescription)
                .HasColumnName("Natureza")
                .HasMaxLength(256);

            builder.Property(e => e.IVAClass)
                .HasColumnName("ClasseIVA")
                .HasMaxLength(256);

            builder.Property(e => e.CostCenter)
                .HasColumnName("CentroCusto")
                .HasMaxLength(256);

            builder.Property(e => e.GoodsCostInPurchase)
                .HasColumnName("CustoMercadoriaCompras");

            builder.Property(e => e.EntityId)
                .HasColumnName("IDTipoDocumento");

            builder.Property(e => e.EntityCode)
                .HasColumnName("CodigoTipoDocumento")
                .HasMaxLength(256);

            builder.Property(e => e.EntityDescription)
                .HasColumnName("DescricaoTipoDocumento")
                .HasMaxLength(256);

            builder.Property(e => e.AccountingVariable)
                .HasColumnName("VariavelContabilidade")
                .HasMaxLength(256);

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

            builder.HasOne(d => d.AccountingConfiguration)
                .WithMany(p => p.Lines)
                .HasForeignKey(d => d.AccountingConfigurationId)
                .OnDelete(DeleteBehavior.Cascade)
                .HasConstraintName("FK_tbContabilidadeConfiguracaoLinhas_tbContabilidadeConfiguracao");
        }

    }
}
