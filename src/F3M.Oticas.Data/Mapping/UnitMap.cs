using F3M.Oticas.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace F3M.Oticas.Data.Mapping
{
    public class UnitMap : IEntityTypeConfiguration<TbUnidades>
    {
        public void Configure(EntityTypeBuilder<TbUnidades> entity)
        {
            entity.ToTable("tbUnidades");

            entity.HasIndex(e => e.Codigo)
                .HasName("IX_tbUnidadesCodigo")
                .IsUnique();

            entity.Property(e => e.Id).HasColumnName("ID");

            entity.Property(e => e.Ativo)
                .IsRequired()
                .HasDefaultValueSql("((1))");

            entity.Property(e => e.Codigo)
                .IsRequired()
                .HasMaxLength(6);

            entity.Property(e => e.DataAlteracao)
                .HasColumnType("datetime")
                .HasDefaultValueSql("(getdate())");

            entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            entity.Property(e => e.Descricao)
                .IsRequired()
                .HasMaxLength(50);

            entity.Property(e => e.F3mmarcador)
                .HasColumnName("F3MMarcador")
                .IsRowVersion();

            entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(20);

            entity.Property(e => e.UtilizadorCriacao)
                .IsRequired()
                .HasMaxLength(20);
        }
    }
}
