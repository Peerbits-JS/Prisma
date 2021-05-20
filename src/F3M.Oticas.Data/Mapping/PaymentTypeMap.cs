using F3M.Oticas.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace F3M.Oticas.Data.Mapping
{
    public class PaymentTypeMap : IEntityTypeConfiguration<TbFormasPagamento>
    {
        public void Configure(EntityTypeBuilder<TbFormasPagamento> entity)
        {
            entity.ToTable("tbFormasPagamento");

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

            entity.Property(e => e.IdtipoFormaPagamento).HasColumnName("IDTipoFormaPagamento");

            entity.Property(e => e.UtilizadorAlteracao)
                .HasMaxLength(256)
                .HasDefaultValueSql("('')");

            entity.Property(e => e.UtilizadorCriacao)
                .IsRequired()
                .HasMaxLength(256)
                .HasDefaultValueSql("('')");

            entity.HasOne(d => d.IdtipoFormaPagamentoNavigation)
                .WithMany(p => p.TbFormasPagamento)
                .HasForeignKey(d => d.IdtipoFormaPagamento)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbFormasPagamento_tbSistemaTiposFormasPagamento");
        }
    }
}
