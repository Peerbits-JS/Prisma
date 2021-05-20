using F3M.Oticas.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace F3M.Oticas.Data.Mapping
{
    public class StoreMap : IEntityTypeConfiguration<TbLojas>
    {
        public void Configure(EntityTypeBuilder<TbLojas> entity)
        {
            entity.ToTable("tbLojas");

            entity.HasIndex(e => e.Codigo)
                .IsUnique();

            entity.Property(e => e.Id)
                .HasColumnName("ID")
                .ValueGeneratedNever();

            entity.Property(e => e.Abertura).HasColumnType("datetime");

            entity.Property(e => e.Ativo)
                .IsRequired()
                .HasDefaultValueSql("((1))");

            entity.Property(e => e.Codigo)
                .IsRequired()
                .HasMaxLength(10);

            entity.Property(e => e.Cor).HasMaxLength(10);

            entity.Property(e => e.DataAlteracao)
                .HasColumnType("datetime")
                .HasDefaultValueSql("(getdate())");

            entity.Property(e => e.DataCriacao)
                .HasColumnType("datetime")
                .HasDefaultValueSql("(getdate())");

            entity.Property(e => e.Descricao)
                .IsRequired()
                .HasMaxLength(50);

            entity.Property(e => e.DescricaoLojaSede).HasMaxLength(50);

            entity.Property(e => e.EnderecoIp)
                .HasColumnName("EnderecoIP")
                .HasMaxLength(255);

            entity.Property(e => e.F3mmarcador)
                .HasColumnName("F3MMarcador")
                .IsRowVersion();

            entity.Property(e => e.Fecho).HasColumnType("datetime");

            entity.Property(e => e.Idempresa).HasColumnName("IDEmpresa");

            entity.Property(e => e.IdlojaSede).HasColumnName("IDLojaSede");

            entity.Property(e => e.UtilizadorAlteracao)
                .HasMaxLength(256)
                .HasDefaultValueSql("('')");

            entity.Property(e => e.UtilizadorCriacao)
                .IsRequired()
                .HasMaxLength(256)
                .HasDefaultValueSql("('')");
        }
    }
}
