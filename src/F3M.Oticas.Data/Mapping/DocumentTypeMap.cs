using F3M.Oticas.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace F3M.Oticas.Data.Mapping
{
    public class DocumentTypeMap : IEntityTypeConfiguration<TbTiposDocumento>
    {
        public void Configure(EntityTypeBuilder<TbTiposDocumento> entity)
        {
            entity.ToTable("tbTiposDocumento");

            entity.HasIndex(e => e.Codigo)
                .HasName("IX_tbTiposDocumento")
                .IsUnique();

            entity.Property(e => e.Id).HasColumnName("ID");

            entity.Property(e => e.Codigo)
                .IsRequired()
                .HasMaxLength(6);

            //entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //entity.Property(e => e.DataCriacao).HasColumnType("datetime");
            entity.Property(e => e.F3MMarker)
                .HasColumnName("F3MMarcador")
                .IsRowVersion();

            entity.Property(e => e.Descricao)
                .IsRequired()
                .HasMaxLength(50);

            entity.Property(e => e.Idcliente).HasColumnName("IDCliente");

            entity.Property(e => e.Idestado).HasColumnName("IDEstado");

            entity.Property(e => e.Idmodulo).HasColumnName("IDModulo");

            entity.Property(e => e.IdsistemaAcoes).HasColumnName("IDSistemaAcoes");

            entity.Property(e => e.IdsistemaAcoesReposicaoStock).HasColumnName("IDSistemaAcoesReposicaoStock");

            entity.Property(e => e.IdsistemaAcoesRupturaStock).HasColumnName("IDSistemaAcoesRupturaStock");

            entity.Property(e => e.IdsistemaAcoesStockMaximo).HasColumnName("IDSistemaAcoesStockMaximo");

            entity.Property(e => e.IdsistemaAcoesStockMinimo).HasColumnName("IDSistemaAcoesStockMinimo");

            entity.Property(e => e.IdsistemaNaturezas).HasColumnName("IDSistemaNaturezas");

            entity.Property(e => e.IdsistemaTiposDocumento).HasColumnName("IDSistemaTiposDocumento");

            entity.Property(e => e.IdsistemaTiposDocumentoFiscal).HasColumnName("IDSistemaTiposDocumentoFiscal");

            entity.Property(e => e.IdsistemaTiposDocumentoMovStock).HasColumnName("IDSistemaTiposDocumentoMovStock");

            entity.Property(e => e.IdsistemaTiposDocumentoPrecoUnitario).HasColumnName("IDSistemaTiposDocumentoPrecoUnitario");

            entity.Property(e => e.IdsistemaTiposLiquidacao).HasColumnName("IDSistemaTiposLiquidacao");

            entity.Property(e => e.IdtipoDocCusto).HasColumnName("IDTipoDocCusto");

            entity.Property(e => e.IdtipoDocFinalizacao).HasColumnName("IDTipoDocFinalizacao");

            entity.Property(e => e.IdtipoDocLibertaReserva).HasColumnName("IDTipoDocLibertaReserva");

            entity.Property(e => e.IdtipoDocReserva).HasColumnName("IDTipoDocReserva");

            entity.Property(e => e.Predefinido).HasDefaultValueSql("((0))");

            //entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //entity.Property(e => e.UtilizadorCriacao)
            //    .IsRequired()
            //    .HasMaxLength(256);

            entity.Property(e => e.UpdatedAt)
                .HasColumnName("DataAlteracao")
                .HasColumnType("datetime")
                .HasDefaultValueSql("(getdate())");

            entity.Property(e => e.CreatedAt)
                .HasColumnName("DataCriacao")
                .HasColumnType("datetime");

            entity.Property(e => e.F3MMarker)
                .HasColumnName("F3MMarcador")
                .IsRowVersion();

            entity.Property(e => e.UpdatedBy)
                .HasColumnName("UtilizadorAlteracao")
                .HasMaxLength(20);

            entity.Property(e => e.CreatedBy)
                .HasColumnName("UtilizadorCriacao")
                .IsRequired()
                .HasMaxLength(20);

            entity.Property(e => e.IsActive)
               .IsRequired()
               .HasColumnName("Ativo")
               .HasDefaultValueSql("((1))");

            entity.Property(e => e.IsSystem)
                .HasColumnName("Sistema")
                .HasDefaultValueSql("((0))");

            entity.HasOne(d => d.IdclienteNavigation)
                .WithMany(p => p.TbTiposDocumento)
                .HasForeignKey(d => d.Idcliente)
                .HasConstraintName("FK_tbTiposDocumento_tbClientes");

            entity.HasOne(d => d.IdestadoNavigation)
                .WithMany(p => p.TbTiposDocumento)
                .HasForeignKey(d => d.Idestado)
                .HasConstraintName("FK_tbTiposDocumento_tbEstados");

            entity.HasOne(d => d.IdmoduloNavigation)
                .WithMany(p => p.TbTiposDocumento)
                .HasForeignKey(d => d.Idmodulo)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbTiposDocumento_tbSistemaModulos");

            entity.HasOne(d => d.IdsistemaAcoesNavigation)
                .WithMany(p => p.TbTiposDocumentoIdsistemaAcoesNavigation)
                .HasForeignKey(d => d.IdsistemaAcoes)
                .HasConstraintName("FK_tbTiposDocumento_tbSistemaAcoes");

            entity.HasOne(d => d.IdsistemaAcoesReposicaoStockNavigation)
                .WithMany(p => p.TbTiposDocumentoIdsistemaAcoesReposicaoStockNavigation)
                .HasForeignKey(d => d.IdsistemaAcoesReposicaoStock)
                .HasConstraintName("FK_tbTiposDocumento_tbSistemaAcoes4");

            entity.HasOne(d => d.IdsistemaAcoesRupturaStockNavigation)
                .WithMany(p => p.TbTiposDocumentoIdsistemaAcoesRupturaStockNavigation)
                .HasForeignKey(d => d.IdsistemaAcoesRupturaStock)
                .HasConstraintName("FK_tbTiposDocumento_tbSistemaAcoes1");

            entity.HasOne(d => d.IdsistemaAcoesStockMaximoNavigation)
                .WithMany(p => p.TbTiposDocumentoIdsistemaAcoesStockMaximoNavigation)
                .HasForeignKey(d => d.IdsistemaAcoesStockMaximo)
                .HasConstraintName("FK_tbTiposDocumento_tbSistemaAcoes3");

            entity.HasOne(d => d.IdsistemaAcoesStockMinimoNavigation)
                .WithMany(p => p.TbTiposDocumentoIdsistemaAcoesStockMinimoNavigation)
                .HasForeignKey(d => d.IdsistemaAcoesStockMinimo)
                .HasConstraintName("FK_tbTiposDocumento_tbSistemaAcoes2");

            entity.HasOne(d => d.IdsistemaNaturezasNavigation)
                .WithMany(p => p.TbTiposDocumento)
                .HasForeignKey(d => d.IdsistemaNaturezas)
                .HasConstraintName("FK_tbTiposDocumento_tbSistemaNaturezas");

            entity.HasOne(d => d.IdsistemaTiposDocumentoNavigation)
                .WithMany(p => p.TbTiposDocumento)
                .HasForeignKey(d => d.IdsistemaTiposDocumento)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbTiposDocumento_tbSistemaTiposDocumento");

            entity.HasOne(d => d.IdsistemaTiposDocumentoFiscalNavigation)
                .WithMany(p => p.TbTiposDocumento)
                .HasForeignKey(d => d.IdsistemaTiposDocumentoFiscal)
                .HasConstraintName("FK_tbTiposDocumento_tbSistemaTiposDocumentoFiscal");

            entity.HasOne(d => d.IdsistemaTiposDocumentoMovStockNavigation)
                .WithMany(p => p.TbTiposDocumento)
                .HasForeignKey(d => d.IdsistemaTiposDocumentoMovStock)
                .HasConstraintName("FK_tbTiposDocumento_tbSistemaTiposDocumentoMovStock");

            entity.HasOne(d => d.IdsistemaTiposDocumentoPrecoUnitarioNavigation)
                .WithMany(p => p.TbTiposDocumento)
                .HasForeignKey(d => d.IdsistemaTiposDocumentoPrecoUnitario)
                .HasConstraintName("FK_tbTiposDocumento_tbSistemaTiposDocumentoPrecoUnitario");

            entity.HasOne(d => d.IdsistemaTiposLiquidacaoNavigation)
                .WithMany(p => p.TbTiposDocumento)
                .HasForeignKey(d => d.IdsistemaTiposLiquidacao)
                .HasConstraintName("FK_tbTiposDocumento_tbSistemaTiposLiquidacao");

            entity.HasOne(d => d.IdtipoDocCustoNavigation)
                .WithMany(p => p.InverseIdtipoDocCustoNavigation)
                .HasForeignKey(d => d.IdtipoDocCusto)
                .HasConstraintName("FK_tbTiposDocumento_tbTiposDocumento3");

            entity.HasOne(d => d.IdtipoDocFinalizacaoNavigation)
                .WithMany(p => p.InverseIdtipoDocFinalizacaoNavigation)
                .HasForeignKey(d => d.IdtipoDocFinalizacao)
                .HasConstraintName("FK_tbTiposDocumento_tbTiposDocumento4");

            entity.HasOne(d => d.IdtipoDocLibertaReservaNavigation)
                .WithMany(p => p.InverseIdtipoDocLibertaReservaNavigation)
                .HasForeignKey(d => d.IdtipoDocLibertaReserva)
                .HasConstraintName("FK_tbTiposDocumento_tbTiposDocumento2");

            entity.HasOne(d => d.IdtipoDocReservaNavigation)
                .WithMany(p => p.InverseIdtipoDocReservaNavigation)
                .HasForeignKey(d => d.IdtipoDocReserva)
                .HasConstraintName("FK_tbTiposDocumento_tbTiposDocumento1");
        }
    }
}
