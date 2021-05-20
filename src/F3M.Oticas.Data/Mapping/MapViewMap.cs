using F3M.Oticas.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace F3M.Oticas.Data.Mapping
{
    public class MapViewMap : IEntityTypeConfiguration<TbMapasVistas>
    {
        public void Configure(EntityTypeBuilder<TbMapasVistas> entity)
        {
            entity.ToTable("tbMapasVistas");

            entity.Property(e => e.Id).HasColumnName("ID");

            entity.Property(e => e.Ativo)
                .IsRequired()
                .HasDefaultValueSql("((1))");

            entity.Property(e => e.Caminho)
                .IsRequired()
                .HasMaxLength(255);

            entity.Property(e => e.DataAlteracao)
                .HasColumnType("datetime")
                .HasDefaultValueSql("(getdate())");

            entity.Property(e => e.DataCriacao)
                .HasColumnType("datetime")
                .HasDefaultValueSql("(getdate())");

            entity.Property(e => e.Descricao)
                .IsRequired()
                .HasMaxLength(255);

            entity.Property(e => e.Entidade)
                .IsRequired()
                .HasMaxLength(255);

            entity.Property(e => e.F3mmarcador)
                .HasColumnName("F3MMarcador")
                .IsRowVersion();

            entity.Property(e => e.Idloja).HasColumnName("IDLoja");

            entity.Property(e => e.Idmodulo).HasColumnName("IDModulo");

            entity.Property(e => e.IdsistemaTipoDoc).HasColumnName("IDSistemaTipoDoc");

            entity.Property(e => e.IdsistemaTipoDocFiscal).HasColumnName("IDSistemaTipoDocFiscal");

            entity.Property(e => e.MapaXml).HasColumnName("MapaXML");

            entity.Property(e => e.NomeMapa)
                .IsRequired()
                .HasMaxLength(255);

            entity.Property(e => e.Sqlquery).HasColumnName("SQLQuery");

            entity.Property(e => e.Tabela).HasMaxLength(255);

            entity.Property(e => e.UtilizadorAlteracao)
                .HasMaxLength(256)
                .HasDefaultValueSql("('')");

            entity.Property(e => e.UtilizadorCriacao)
                .IsRequired()
                .HasMaxLength(256)
                .HasDefaultValueSql("('')");

            entity.HasOne(d => d.IdlojaNavigation)
                .WithMany(p => p.TbMapasVistas)
                .HasForeignKey(d => d.Idloja)
                .HasConstraintName("FK_tbMapasVistas_tbLojas");

            entity.HasOne(d => d.IdmoduloNavigation)
                .WithMany(p => p.TbMapasVistas)
                .HasForeignKey(d => d.Idmodulo)
                .HasConstraintName("FK_tbMapasVistas_tbSistemaModulos");

            entity.HasOne(d => d.IdsistemaTipoDocNavigation)
                .WithMany(p => p.TbMapasVistas)
                .HasForeignKey(d => d.IdsistemaTipoDoc)
                .HasConstraintName("FK_tbMapasVistas_tbSistemaTiposDocumento");

            entity.HasOne(d => d.IdsistemaTipoDocFiscalNavigation)
                .WithMany(p => p.TbMapasVistas)
                .HasForeignKey(d => d.IdsistemaTipoDocFiscal)
                .HasConstraintName("FK_tbMapasVistas_tbSistemaTiposDocumentoFiscal");
        }
    }
}
