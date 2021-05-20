using F3M.Oticas.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;

namespace F3M.Oticas.Data.Mapping
{
    public class PurchaseDocumentLineMap : IEntityTypeConfiguration<PurchaseDocumentLine>
    {
        public void Configure(EntityTypeBuilder<PurchaseDocumentLine> entity)
        {
            entity.ToTable("tbDocumentosComprasLinhas");

            entity.Property(e => e.Id).HasColumnName("ID");

            entity.Property(e => e.ArtigoNumSerie).HasMaxLength(20);

            entity.Property(e => e.CodigoArtigo).HasMaxLength(255);

            entity.Property(e => e.CodigoBarrasArtigo).HasMaxLength(255);

            entity.Property(e => e.CodigoLote).HasMaxLength(50);

            entity.Property(e => e.CodigoMotivoIsencaoIva).HasMaxLength(6);

            entity.Property(e => e.CodigoRegiaoIva).HasMaxLength(20);

            entity.Property(e => e.CodigoTaxaIva).HasMaxLength(6);

            entity.Property(e => e.CodigoTipoIva).HasMaxLength(20);

            entity.Property(e => e.CodigoTipoPreco).HasMaxLength(6);

            entity.Property(e => e.CodigoUnidade).HasMaxLength(20);

            entity.Property(e => e.DataDocOrigem).HasColumnType("datetime");

            entity.Property(e => e.DataEntrega).HasColumnType("datetime");

            entity.Property(e => e.DataFabricoLote).HasColumnType("datetime");

            entity.Property(e => e.DataValidadeLote).HasColumnType("datetime");

            entity.Property(e => e.Descricao)
                .IsRequired()
                .HasMaxLength(200);

            entity.Property(e => e.DescricaoLote).HasMaxLength(100);

            entity.Property(e => e.DocumentoOrigem).HasMaxLength(255);

            entity.Property(e => e.DocumentoOrigemInicial).HasMaxLength(255);

            entity.Property(e => e.EspacoFiscal).HasMaxLength(50);

            entity.Property(e => e.Idarmazem).HasColumnName("IDArmazem");

            entity.Property(e => e.IdarmazemDestino).HasColumnName("IDArmazemDestino");

            entity.Property(e => e.IdarmazemLocalizacao).HasColumnName("IDArmazemLocalizacao");

            entity.Property(e => e.IdarmazemLocalizacaoDestino).HasColumnName("IDArmazemLocalizacaoDestino");

            entity.Property(e => e.Idartigo).HasColumnName("IDArtigo");

            entity.Property(e => e.IdartigoNumSerie).HasColumnName("IDArtigoNumSerie");

            entity.Property(e => e.IdartigoPa).HasColumnName("IDArtigoPA");

            entity.Property(e => e.IdartigoPara).HasColumnName("IDArtigoPara");

            entity.Property(e => e.IdcodigoIva).HasColumnName("IDCodigoIva");

            entity.Property(e => e.IddocumentoCompra).HasColumnName("IDDocumentoCompra");

            entity.Property(e => e.IddocumentoOrigem).HasColumnName("IDDocumentoOrigem");

            entity.Property(e => e.IddocumentoOrigemInicial).HasColumnName("IDDocumentoOrigemInicial");

            entity.Property(e => e.IdespacoFiscal).HasColumnName("IDEspacoFiscal");

            entity.Property(e => e.IdlinhaDocumentoCompra).HasColumnName("IDLinhaDocumentoCompra");

            entity.Property(e => e.IdlinhaDocumentoCompraInicial).HasColumnName("IDLinhaDocumentoCompraInicial");

            entity.Property(e => e.IdlinhaDocumentoOrigem).HasColumnName("IDLinhaDocumentoOrigem");

            entity.Property(e => e.IdlinhaDocumentoOrigemInicial).HasColumnName("IDLinhaDocumentoOrigemInicial");

            entity.Property(e => e.IdlinhaDocumentoStock).HasColumnName("IDLinhaDocumentoStock");

            entity.Property(e => e.IdlinhaDocumentoStockInicial).HasColumnName("IDLinhaDocumentoStockInicial");

            entity.Property(e => e.IdlinhaDocumentoVenda).HasColumnName("IDLinhaDocumentoVenda");

            entity.Property(e => e.Idlote).HasColumnName("IDLote");

            entity.Property(e => e.Idofartigo).HasColumnName("IDOFArtigo");

            entity.Property(e => e.IdregimeIva).HasColumnName("IDRegimeIva");

            entity.Property(e => e.IdtaxaIva).HasColumnName("IDTaxaIva");

            entity.Property(e => e.IdtipoDocumentoOrigem).HasColumnName("IDTipoDocumentoOrigem");

            entity.Property(e => e.IdtipoDocumentoOrigemInicial).HasColumnName("IDTipoDocumentoOrigemInicial");

            entity.Property(e => e.IdtipoIva).HasColumnName("IDTipoIva");

            entity.Property(e => e.IdtipoPreco).HasColumnName("IDTipoPreco");

            entity.Property(e => e.IdtiposDocumentoSeriesOrigem).HasColumnName("IDTiposDocumentoSeriesOrigem");

            entity.Property(e => e.Idunidade).HasColumnName("IDUnidade");

            entity.Property(e => e.IdunidadeStock).HasColumnName("IDUnidadeStock");

            entity.Property(e => e.IdunidadeStock2).HasColumnName("IDUnidadeStock2");

            entity.Property(e => e.MotivoIsencaoIva).HasMaxLength(255);

            entity.Property(e => e.OperacaoConv2UnidStk).HasMaxLength(50);

            entity.Property(e => e.OperacaoConvUnidStk).HasMaxLength(50);

            entity.Property(e => e.PcmanteriorMoedaRef).HasColumnName("PCMAnteriorMoedaRef");

            entity.Property(e => e.PcmanteriorMoedaRefOrigem).HasColumnName("PCMAnteriorMoedaRefOrigem");

            entity.Property(e => e.PcmatualMoedaRef).HasColumnName("PCMAtualMoedaRef");

            entity.Property(e => e.PvmoedaRef).HasColumnName("PVMoedaRef");

            entity.Property(e => e.RegimeIva).HasMaxLength(50);

            entity.Property(e => e.SiglaPais).HasMaxLength(15);

            entity.Property(e => e.UpcmoedaRef).HasColumnName("UPCMoedaRef");

            entity.Property(e => e.UpcompraMoedaRef).HasColumnName("UPCompraMoedaRef");

            entity.Property(e => e.VossoNumeroDocumentoOrigem).HasMaxLength(256);

            //new
            entity.Property(e => e.VatValue).HasColumnName("ValorIVA");

            entity.Property(e => e.TotalPrice).HasColumnName("PrecoTotal");

            entity.Property(e => e.IncidenceValue).HasColumnName("ValorIncidencia");

            entity.Property(e => e.EffectiveDiscountValueWithoutVat).HasColumnName("ValorDescontoEfetivoSemIva");

            //new
            entity.Property(e => e.CreatedAt)
             .HasColumnName("DataCriacao")
             .HasColumnType("datetime")
             .HasDefaultValueSql("(getdate())");

            entity.Property(e => e.UpdatedBy)
                .HasColumnName("UtilizadorAlteracao")
                .HasMaxLength(20)
                .HasDefaultValueSql("('')");

            entity.Property(e => e.CreatedBy)
                .HasColumnName("UtilizadorCriacao")
                .IsRequired()
                .HasMaxLength(20)
                .HasDefaultValueSql("('')");

            entity.Property(e => e.UpdatedAt)
                .HasColumnName("DataAlteracao")
                .HasColumnType("datetime")
                .HasDefaultValueSql("(getdate())");

            entity.Property(e => e.IsSystem)
                .HasColumnName("Sistema");

            entity.Property(e => e.IsActive)
                .HasColumnName("Ativo")
                .IsRequired()
                .HasDefaultValueSql("((1))");

            entity.Property(e => e.F3MMarker)
                .HasColumnName("F3MMarcador")
                .IsRowVersion();

            entity.HasOne(d => d.IdarmazemNavigation)
                .WithMany(p => p.TbDocumentosComprasLinhasIdarmazemNavigation)
                .HasForeignKey(d => d.Idarmazem)
                .HasConstraintName("FK_tbDocumentosComprasLinhas_tbArmazens");

            entity.HasOne(d => d.IdarmazemDestinoNavigation)
                .WithMany(p => p.TbDocumentosComprasLinhasIdarmazemDestinoNavigation)
                .HasForeignKey(d => d.IdarmazemDestino)
                .HasConstraintName("FK_tbDocumentosComprasLinhas_tbArmazens_Destino");

            entity.HasOne(d => d.IdarmazemLocalizacaoNavigation)
                .WithMany(p => p.TbDocumentosComprasLinhasIdarmazemLocalizacaoNavigation)
                .HasForeignKey(d => d.IdarmazemLocalizacao)
                .HasConstraintName("FK_tbDocumentosComprasLinhas_tbArmazensLocalizacoes");

            entity.HasOne(d => d.IdarmazemLocalizacaoDestinoNavigation)
                .WithMany(p => p.TbDocumentosComprasLinhasIdarmazemLocalizacaoDestinoNavigation)
                .HasForeignKey(d => d.IdarmazemLocalizacaoDestino)
                .HasConstraintName("FK_tbDocumentosComprasLinhas_tbArmazensLocalizacoes_Destino");

            entity.HasOne(d => d.IdartigoNavigation)
                .WithMany(p => p.PurchaseDocumentProducts)
                .HasForeignKey(d => d.Idartigo)
                .HasConstraintName("FK_tbDocumentosComprasLinhas_tbArtigos");

            entity.HasOne(d => d.IdartigoNumSerieNavigation)
                .WithMany(p => p.TbDocumentosComprasLinhas)
                .HasForeignKey(d => d.IdartigoNumSerie)
                .HasConstraintName("FK_tbDocumentosComprasLinhas_tbArtigosNumerosSeries");

            entity.HasOne(d => d.IdcodigoIvaNavigation)
                .WithMany(p => p.PurchaseDocumentLine)
                .HasForeignKey(d => d.IdcodigoIva)
                .HasConstraintName("FK_tbDocumentosComprasLinhas_tbSistemaCodigosIVA");

            entity.HasOne(d => d.IddocumentoCompraNavigation)
                .WithMany(p => p.Lines)
                .HasForeignKey(d => d.IddocumentoCompra)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbDocumentosComprasLinhas_tbDocumentosCompras");

            entity.HasOne(d => d.IdespacoFiscalNavigation)
                .WithMany(p => p.TbDocumentosComprasLinhas)
                .HasForeignKey(d => d.IdespacoFiscal)
                .HasConstraintName("FK_tbDocumentosComprasLinhas_tbSistemaEspacoFiscal");

            entity.HasOne(d => d.IdlinhaDocumentoCompraNavigation)
                .WithMany(p => p.InverseIdlinhaDocumentoCompraNavigation)
                .HasForeignKey(d => d.IdlinhaDocumentoCompra)
                .HasConstraintName("FK_tbDocumentosComprasLinhas_tbDocumentosComprasLinhas");

            entity.HasOne(d => d.IdlinhaDocumentoCompraInicialNavigation)
                .WithMany(p => p.InverseIdlinhaDocumentoCompraInicialNavigation)
                .HasForeignKey(d => d.IdlinhaDocumentoCompraInicial)
                .HasConstraintName("FK_tbDocumentosComprasLinhas_tbDocumentosComprasLinhasInicial");

            entity.HasOne(d => d.IdlinhaDocumentoStockNavigation)
                .WithMany(p => p.TbDocumentosComprasLinhasIdlinhaDocumentoStockNavigation)
                .HasForeignKey(d => d.IdlinhaDocumentoStock)
                .HasConstraintName("FK_tbDocumentosComprasLinhas_tbDocumentosStockLinhas");

            entity.HasOne(d => d.IdlinhaDocumentoStockInicialNavigation)
                .WithMany(p => p.TbDocumentosComprasLinhasIdlinhaDocumentoStockInicialNavigation)
                .HasForeignKey(d => d.IdlinhaDocumentoStockInicial)
                .HasConstraintName("FK_tbDocumentosComprasLinhas_tbDocumentosStockLinhasInicial");

            entity.HasOne(d => d.IdlinhaDocumentoVendaNavigation)
                .WithMany(p => p.TbDocumentosComprasLinhas)
                .HasForeignKey(d => d.IdlinhaDocumentoVenda)
                .HasConstraintName("FK_tbDocumentosComprasLinhas_tbDocumentosVendasLinhas");

            entity.HasOne(d => d.IdloteNavigation)
                .WithMany(p => p.TbDocumentosComprasLinhas)
                .HasForeignKey(d => d.Idlote)
                .HasConstraintName("FK_tbDocumentosComprasLinhas_tbArtigosLotes");

            entity.HasOne(d => d.IdregimeIvaNavigation)
                .WithMany(p => p.TbDocumentosComprasLinhas)
                .HasForeignKey(d => d.IdregimeIva)
                .HasConstraintName("FK_tbDocumentosComprasLinhas_tbSistemaRegimeIVA");

            entity.HasOne(d => d.IdtaxaIvaNavigation)
                .WithMany(p => p.PurchaseDocumentLine)
                .HasForeignKey(d => d.IdtaxaIva)
                .HasConstraintName("FK_tbDocumentosComprasLinhas_tbIVA");

            entity.HasOne(d => d.IdtipoDocumentoOrigemNavigation)
                .WithMany(p => p.TbDocumentosComprasLinhasIdtipoDocumentoOrigemNavigation)
                .HasForeignKey(d => d.IdtipoDocumentoOrigem)
                .HasConstraintName("FK_tbDocumentosComprasLinhas_IDTipoDocumentoOrigem");

            entity.HasOne(d => d.IdtipoDocumentoOrigemInicialNavigation)
                .WithMany(p => p.TbDocumentosComprasLinhasIdtipoDocumentoOrigemInicialNavigation)
                .HasForeignKey(d => d.IdtipoDocumentoOrigemInicial)
                .HasConstraintName("FK_tbDocumentosComprasLinhas_tbTiposDocumentoOrigemInicial");

            entity.HasOne(d => d.SystemVatType)
                .WithMany(p => p.PurchaseDocumentLine)
                .HasForeignKey(d => d.IdtipoIva)
                .HasConstraintName("FK_tbDocumentosComprasLinhas_tbSistemaTiposIVA");

            entity.HasOne(d => d.IdtipoPrecoNavigation)
                .WithMany(p => p.TbDocumentosComprasLinhas)
                .HasForeignKey(d => d.IdtipoPreco)
                .HasConstraintName("FK_tbDocumentosComprasLinhas_tbSistemaTiposPrecos");

            entity.HasOne(d => d.IdtiposDocumentoSeriesOrigemNavigation)
                .WithMany(p => p.TbDocumentosComprasLinhas)
                .HasForeignKey(d => d.IdtiposDocumentoSeriesOrigem)
                .HasConstraintName("FK_tbDocumentosComprasLinhas_tbTiposDocumentoSeriesOrigem");

            entity.HasOne(d => d.IdunidadeNavigation)
                .WithMany(p => p.TbDocumentosComprasLinhasIdunidadeNavigation)
                .HasForeignKey(d => d.Idunidade)
                .HasConstraintName("FK_tbDocumentosComprasLinhas_tbUnidades");

            entity.HasOne(d => d.IdunidadeStockNavigation)
                .WithMany(p => p.TbDocumentosComprasLinhasIdunidadeStockNavigation)
                .HasForeignKey(d => d.IdunidadeStock)
                .HasConstraintName("FK_tbDocumentosComprasLinhas_tbUnidades2");

            entity.HasOne(d => d.IdunidadeStock2Navigation)
                .WithMany(p => p.TbDocumentosComprasLinhasIdunidadeStock2Navigation)
                .HasForeignKey(d => d.IdunidadeStock2)
                .HasConstraintName("FK_tbDocumentosComprasLinhas_tbUnidades3");
        }
    }
}
