using F3M.Oticas.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace F3M.Oticas.Data.Mapping
{
    public class WarehouseMap : IEntityTypeConfiguration<TbArmazens>
    {
        public void Configure(EntityTypeBuilder<TbArmazens> entity)
        {
            entity.ToTable("tbArmazens");

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

            entity.Property(e => e.IdcodigoPostal).HasColumnName("IDCodigoPostal");

            entity.Property(e => e.Idconcelho).HasColumnName("IDConcelho");

            entity.Property(e => e.Iddistrito).HasColumnName("IDDistrito");

            entity.Property(e => e.Idloja).HasColumnName("IDLoja");

            entity.Property(e => e.Idpais).HasColumnName("IDPais");

            entity.Property(e => e.Morada)
                .HasMaxLength(100)
                .HasDefaultValueSql("('')");

            entity.Property(e => e.UtilizadorAlteracao)
                .HasMaxLength(256)
                .HasDefaultValueSql("('')");

            entity.Property(e => e.UtilizadorCriacao)
                .IsRequired()
                .HasMaxLength(256)
                .HasDefaultValueSql("('')");

            entity.HasOne(d => d.IdcodigoPostalNavigation)
                .WithMany(p => p.TbArmazens)
                .HasForeignKey(d => d.IdcodigoPostal)
                .HasConstraintName("FK_tbArmazens_tbCodigosPostais");

            entity.HasOne(d => d.IdconcelhoNavigation)
                .WithMany(p => p.TbArmazens)
                .HasForeignKey(d => d.Idconcelho)
                .HasConstraintName("FK_tbArmazens_tbConcelhos");

            entity.HasOne(d => d.IddistritoNavigation)
                .WithMany(p => p.TbArmazens)
                .HasForeignKey(d => d.Iddistrito)
                .HasConstraintName("FK_tbArmazens_tbDistritos");

            entity.HasOne(d => d.IdlojaNavigation)
                .WithMany(p => p.TbArmazens)
                .HasForeignKey(d => d.Idloja)
                .HasConstraintName("FK_tbArmazens_tbLojas");

            entity.HasOne(d => d.IdpaisNavigation)
                .WithMany(p => p.Warehouse)
                .HasForeignKey(d => d.Idpais)
                .HasConstraintName("FK_tbArmazens_tbPaises");
        }
    }
}
