using F3M.Oticas.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace F3M.Oticas.Data.Mapping
{
    public class VatRegionsMap : IEntityTypeConfiguration<TbIvaregioes>
    {
        public void Configure(EntityTypeBuilder<TbIvaregioes> entity)
        {
            entity.ToTable("tbIVARegioes");

            entity.HasIndex(e => new { e.Idiva, e.Idregiao })
                .HasName("IX_tbIVARegioes")
                .IsUnique();

            entity.Property(e => e.Id).HasColumnName("ID");

            entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            entity.Property(e => e.F3mmarcador)
                .HasColumnName("F3MMarcador")
                .IsRowVersion();

            entity.Property(e => e.Idiva).HasColumnName("IDIva");

            entity.Property(e => e.IdivaRegiao).HasColumnName("IDIvaRegiao");

            entity.Property(e => e.Idregiao).HasColumnName("IDRegiao");

            entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(255);

            entity.Property(e => e.UtilizadorCriacao)
                .IsRequired()
                .HasMaxLength(255);

            entity.HasOne(d => d.IdivaNavigation)
                .WithMany(p => p.TbIvaregioesIdivaNavigation)
                .HasForeignKey(d => d.Idiva)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbIVARegioes_tbIVA");

            entity.HasOne(d => d.IdivaRegiaoNavigation)
                .WithMany(p => p.TbIvaregioesIdivaRegiaoNavigation)
                .HasForeignKey(d => d.IdivaRegiao)
                .HasConstraintName("FK_tbIVARegioes_tbIVA1");

            entity.HasOne(d => d.IdregiaoNavigation)
                .WithMany(p => p.TbIvaregioes)
                .HasForeignKey(d => d.Idregiao)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbIVARegioes_tbSistemaRegioesIVA");
        }
    }
}
