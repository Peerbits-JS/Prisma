using F3M.Oticas.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace F3M.Oticas.Data.Mapping
{
    public class DocumentTypeSeriesMap : IEntityTypeConfiguration<TbTiposDocumentoSeries>
    {
        public void Configure(EntityTypeBuilder<TbTiposDocumentoSeries> entity)
        {
            entity.ToTable("tbTiposDocumentoSeries");

            entity.HasIndex(e => new { e.CodigoSerie, e.IdtiposDocumento })
                .HasName("IX_tbTiposDocumentoSeries")
                .IsUnique();

            entity.Property(e => e.Id).HasColumnName("ID");

            entity.Property(e => e.CodigoSerie)
                .IsRequired()
                .HasMaxLength(6);

            entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            entity.Property(e => e.DataFinal).HasColumnType("datetime");

            entity.Property(e => e.DataInicial).HasColumnType("datetime");

            entity.Property(e => e.DataUltimoDoc).HasColumnType("datetime");

            entity.Property(e => e.DescricaoSerie)
                .IsRequired()
                .HasMaxLength(50);

            entity.Property(e => e.F3mmarcador)
                .HasColumnName("F3MMarcador")
                .IsRowVersion();

            entity.Property(e => e.Idloja).HasColumnName("IDLoja");

            entity.Property(e => e.IdmapasVistas).HasColumnName("IDMapasVistas");

            entity.Property(e => e.IdparametrosEmpresaCae).HasColumnName("IDParametrosEmpresaCAE");

            entity.Property(e => e.IdsistemaTiposDocumentoComunicacao).HasColumnName("IDSistemaTiposDocumentoComunicacao");

            entity.Property(e => e.IdsistemaTiposDocumentoOrigem).HasColumnName("IDSistemaTiposDocumentoOrigem");

            entity.Property(e => e.IdtiposDocumento).HasColumnName("IDTiposDocumento");

            entity.Property(e => e.Ivaincluido).HasColumnName("IVAIncluido");

            entity.Property(e => e.IvaregimeCaixa).HasColumnName("IVARegimeCaixa");

            entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            entity.Property(e => e.UtilizadorCriacao)
                .IsRequired()
                .HasMaxLength(256);

            entity.HasOne(d => d.IdlojaNavigation)
                .WithMany(p => p.TbTiposDocumentoSeries)
                .HasForeignKey(d => d.Idloja)
                .HasConstraintName("FK_tbTiposDocumentoSeries_tbLojas");

            entity.HasOne(d => d.IdmapasVistasNavigation)
                .WithMany(p => p.TbTiposDocumentoSeries)
                .HasForeignKey(d => d.IdmapasVistas)
                .HasConstraintName("FK_tbTiposDocumentoSeries_tbMapasVistas");

            entity.HasOne(d => d.IdparametrosEmpresaCaeNavigation)
                .WithMany(p => p.TbTiposDocumentoSeries)
                .HasForeignKey(d => d.IdparametrosEmpresaCae)
                .HasConstraintName("FK_tbTiposDocumentoSeries_tbParametrosEmpresaCAE");

            entity.HasOne(d => d.IdsistemaTiposDocumentoComunicacaoNavigation)
                .WithMany(p => p.TbTiposDocumentoSeries)
                .HasForeignKey(d => d.IdsistemaTiposDocumentoComunicacao)
                .HasConstraintName("FK_tbTiposDocumentoSeries_tbSistemaTiposDocumentoComunicacao");

            entity.HasOne(d => d.IdsistemaTiposDocumentoOrigemNavigation)
                .WithMany(p => p.TbTiposDocumentoSeries)
                .HasForeignKey(d => d.IdsistemaTiposDocumentoOrigem)
                .HasConstraintName("FK_tbTiposDocumentoSeries_tbSistemaTiposDocumentoOrigem");

            entity.HasOne(d => d.IdtiposDocumentoNavigation)
                .WithMany(p => p.TbTiposDocumentoSeries)
                .HasForeignKey(d => d.IdtiposDocumento)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbTiposDocumentoSeries_tbTiposDocumento");
        }
    }
}
