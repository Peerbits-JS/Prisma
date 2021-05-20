using F3M.Oticas.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;

namespace F3M.Oticas.Data.Mapping
{
    public class ProductTypeMap : IEntityTypeConfiguration<TbTiposArtigos>
    {
        public void Configure(EntityTypeBuilder<TbTiposArtigos> entity)
        {
            entity.ToTable("tbTiposArtigos");

            entity.HasIndex(e => e.Codigo)
                .IsUnique();

            entity.Property(e => e.Id).HasColumnName("ID");

            entity.Property(e => e.Ativo)
                .IsRequired()
                .HasDefaultValueSql("((1))");

            entity.Property(e => e.Codigo)
                .IsRequired()
                .HasMaxLength(10);

            entity.Property(e => e.DataAlteracao)
                .HasColumnType("datetime")
                .HasDefaultValueSql("(getdate())");

            entity.Property(e => e.DataCriacao)
                .HasColumnType("datetime")
                .HasDefaultValueSql("(getdate())");

            entity.Property(e => e.Descricao)
                .IsRequired()
                .HasMaxLength(50);

            entity.Property(e => e.F3mmarcador)
                .HasColumnName("F3MMarcador")
                .IsRowVersion();

            entity.Property(e => e.IdsistemaClassificacao).HasColumnName("IDSistemaClassificacao");

            entity.Property(e => e.IdsistemaClassificacaoGeral).HasColumnName("IDSistemaClassificacaoGeral");

            entity.Property(e => e.UtilizadorAlteracao)
                .HasMaxLength(256)
                .HasDefaultValueSql("('')");

            entity.Property(e => e.UtilizadorCriacao)
                .IsRequired()
                .HasMaxLength(256)
                .HasDefaultValueSql("('')");

            entity.Property(e => e.VariavelContabilidade).HasMaxLength(20);

            entity.HasOne(d => d.IdsistemaClassificacaoNavigation)
                .WithMany(p => p.TbTiposArtigos)
                .HasForeignKey(d => d.IdsistemaClassificacao)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbTiposArtigos_tbSistemaClassificacoesTiposArtigos");

            entity.HasOne(d => d.IdsistemaClassificacaoGeralNavigation)
                .WithMany(p => p.TbTiposArtigos)
                .HasForeignKey(d => d.IdsistemaClassificacaoGeral)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbTiposArtigos_tbSistemaClassificacoesTiposArtigosGeral");
        }
    }
}
