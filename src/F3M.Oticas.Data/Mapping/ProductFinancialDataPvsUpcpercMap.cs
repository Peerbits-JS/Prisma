using F3M.Oticas.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;

namespace F3M.Oticas.Data.Mapping
{
    public class ProductFinancialDataPvsUpcpercMap : IEntityTypeConfiguration<TbArtigosDadosFinanceirosPvsUpcperc>
    {
        public void Configure(EntityTypeBuilder<TbArtigosDadosFinanceirosPvsUpcperc> entity)
        {
            entity.ToTable("tbArtigosDadosFinanceirosPVsUPCPerc");

            entity.HasIndex(e => e.Idartigo)
                .HasName("IX_tbArtigosDadosFinanceirosPVsUPCPerc")
                .IsUnique();

            entity.Property(e => e.Id).HasColumnName("ID");

            entity.Property(e => e.Ativo)
                .IsRequired()
                .HasDefaultValueSql("((1))");

            entity.Property(e => e.DataAlteracao)
                .HasColumnType("datetime")
                .HasDefaultValueSql("(getdate())");

            entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            entity.Property(e => e.F3mmarcador)
                .HasColumnName("F3MMarcador")
                .IsRowVersion();

            entity.Property(e => e.Idartigo).HasColumnName("IDArtigo");

            entity.Property(e => e.PercUpc1).HasColumnName("PercUPC1");

            entity.Property(e => e.PercUpc10).HasColumnName("PercUPC10");

            entity.Property(e => e.PercUpc2).HasColumnName("PercUPC2");

            entity.Property(e => e.PercUpc3).HasColumnName("PercUPC3");

            entity.Property(e => e.PercUpc4).HasColumnName("PercUPC4");

            entity.Property(e => e.PercUpc5).HasColumnName("PercUPC5");

            entity.Property(e => e.PercUpc6).HasColumnName("PercUPC6");

            entity.Property(e => e.PercUpc7).HasColumnName("PercUPC7");

            entity.Property(e => e.PercUpc8).HasColumnName("PercUPC8");

            entity.Property(e => e.PercUpc9).HasColumnName("PercUPC9");

            entity.Property(e => e.Pv1).HasColumnName("PV1");

            entity.Property(e => e.Pv10).HasColumnName("PV10");

            entity.Property(e => e.Pv10iva).HasColumnName("PV10IVA");

            entity.Property(e => e.Pv1iva).HasColumnName("PV1IVA");

            entity.Property(e => e.Pv2).HasColumnName("PV2");

            entity.Property(e => e.Pv2iva).HasColumnName("PV2IVA");

            entity.Property(e => e.Pv3).HasColumnName("PV3");

            entity.Property(e => e.Pv3iva).HasColumnName("PV3IVA");

            entity.Property(e => e.Pv4).HasColumnName("PV4");

            entity.Property(e => e.Pv4iva).HasColumnName("PV4IVA");

            entity.Property(e => e.Pv5).HasColumnName("PV5");

            entity.Property(e => e.Pv5iva).HasColumnName("PV5IVA");

            entity.Property(e => e.Pv6).HasColumnName("PV6");

            entity.Property(e => e.Pv6iva).HasColumnName("PV6IVA");

            entity.Property(e => e.Pv7).HasColumnName("PV7");

            entity.Property(e => e.Pv7iva).HasColumnName("PV7IVA");

            entity.Property(e => e.Pv8).HasColumnName("PV8");

            entity.Property(e => e.Pv8iva).HasColumnName("PV8IVA");

            entity.Property(e => e.Pv9).HasColumnName("PV9");

            entity.Property(e => e.Pv9iva).HasColumnName("PV9IVA");

            entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            entity.Property(e => e.UtilizadorCriacao)
                .IsRequired()
                .HasMaxLength(256);

            entity.HasOne(d => d.IdartigoNavigation)
                .WithOne(p => p.FinancialDataPvsUpcperc)
                .HasForeignKey<TbArtigosDadosFinanceirosPvsUpcperc>(d => d.Idartigo)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbArtigosDadosFinanceirosPVsUPCPerc_tbArtigos");
        }
    }
}
