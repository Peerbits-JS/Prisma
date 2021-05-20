using F3M.Oticas.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;

namespace F3M.Oticas.Data.Mapping
{
    public class ProductFinancialDataMap : IEntityTypeConfiguration<TbArtigosDadosFinanceiros>
    {
        public void Configure(EntityTypeBuilder<TbArtigosDadosFinanceiros> entity)
        {
            entity.ToTable("tbArtigosDadosFinanceiros");

            entity.HasIndex(e => e.Idartigo)
                .HasName("IX_tbArtigosDadosFinanceiros")
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

            entity.Property(e => e.IdartigoImpostoSelo)
                .HasColumnName("IDArtigoImpostoSelo")
                .HasDefaultValueSql("((0))");

            entity.Property(e => e.Idiva).HasColumnName("IDIva");

            entity.Property(e => e.TextoMotivoIsencaoPersonalizado).HasMaxLength(4000);

            entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            entity.Property(e => e.UtilizadorCriacao)
                .IsRequired()
                .HasMaxLength(256);

            entity.HasOne(d => d.IdartigoNavigation)
                .WithOne(p => p.FinancialData)
                .HasForeignKey<TbArtigosDadosFinanceiros>(d => d.Idartigo)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbArtigosDadosFinanceiros_tbArtigos");
        }
    }
}
