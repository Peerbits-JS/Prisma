using F3M.Oticas.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace F3M.Oticas.Data.Mapping
{
    public class WarehouseLocationMap : IEntityTypeConfiguration<TbArmazensLocalizacoes>
    {
        public void Configure(EntityTypeBuilder<TbArmazensLocalizacoes> entity)
        {
            entity.ToTable("tbArmazensLocalizacoes");

            entity.HasIndex(e => e.Codigo)
                .IsUnique();

            entity.Property(e => e.Id).HasColumnName("ID");

            entity.Property(e => e.Ativo)
                .IsRequired()
                .HasDefaultValueSql("((1))");

            entity.Property(e => e.Codigo)
                .IsRequired()
                .HasMaxLength(50);

            entity.Property(e => e.CodigoBarras).HasMaxLength(125);

            entity.Property(e => e.DataAlteracao)
                .HasColumnType("datetime")
                .HasDefaultValueSql("(getdate())");

            entity.Property(e => e.DataCriacao)
                .HasColumnType("datetime")
                .HasDefaultValueSql("(getdate())");

            entity.Property(e => e.Descricao)
                .IsRequired()
                .HasMaxLength(100);

            entity.Property(e => e.F3mmarcador)
                .HasColumnName("F3MMarcador")
                .IsRowVersion();

            entity.Property(e => e.Idarmazem).HasColumnName("IDArmazem");

            entity.Property(e => e.UtilizadorAlteracao)
                .HasMaxLength(256)
                .HasDefaultValueSql("('')");

            entity.Property(e => e.UtilizadorCriacao)
                .IsRequired()
                .HasMaxLength(256)
                .HasDefaultValueSql("('')");

            entity.HasOne(d => d.IdarmazemNavigation)
                .WithMany(p => p.TbArmazensLocalizacoes)
                .HasForeignKey(d => d.Idarmazem)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbArmazensLocalizacoes_tbArmazens");
        }
    }
}
