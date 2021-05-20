using F3M.Oticas.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace F3M.Oticas.Data.Mapping
{
    public class SaleDocumentLineMap : IEntityTypeConfiguration<SaleDocumentLine>
    {
        public void Configure(EntityTypeBuilder<SaleDocumentLine> entity)
        {
            entity.ToTable("tbDocumentosVendasLinhas");

            entity.HasKey(e => e.Id)
               .HasName("ID");

            entity.Property(e => e.Id).HasColumnName("ID");

            entity.Property(e => e.ArtigoNumSerie).HasMaxLength(20);

            entity.Property(e => e.CodigoArtigo).HasMaxLength(255);

            entity.Property(e => e.CodigoBarrasArtigo).HasMaxLength(255);

            entity.Property(e => e.CodigoLote).HasMaxLength(50);

            entity.Property(e => e.CodigoMotivoIsencaoIva).HasMaxLength(6);

            entity.Property(e => e.CodigoRegiaoIva).HasMaxLength(20);

            entity.Property(e => e.CodigoTaxaIva).HasMaxLength(255);

            entity.Property(e => e.CodigoTipoIva).HasMaxLength(20);

            entity.Property(e => e.CodigoTipoPreco).HasMaxLength(6);

            entity.Property(e => e.CodigoUnidade).HasMaxLength(20);

            entity.Property(e => e.DataDocOrigem).HasColumnType("datetime");

            entity.Property(e => e.DataEntrega).HasColumnType("datetime");

            entity.Property(e => e.DataFabricoLote).HasColumnType("datetime");

            entity.Property(e => e.DataValidadeLote).HasColumnType("datetime");

            entity.Property(e => e.Descricao).HasMaxLength(200);

            entity.Property(e => e.DescricaoLote).HasMaxLength(100);

            entity.Property(e => e.Diametro).HasMaxLength(10);

            entity.Property(e => e.DocumentoOrigem).HasMaxLength(255);

            entity.Property(e => e.DocumentoOrigemInicial).HasMaxLength(255);

            entity.Property(e => e.EspacoFiscal).HasMaxLength(50);

            entity.Property(e => e.IdadiantamentoOrigem).HasColumnName("IDAdiantamentoOrigem");

            entity.Property(e => e.Idarmazem).HasColumnName("IDArmazem");

            entity.Property(e => e.IdarmazemDestino).HasColumnName("IDArmazemDestino");

            entity.Property(e => e.IdarmazemLocalizacao).HasColumnName("IDArmazemLocalizacao");

            entity.Property(e => e.IdarmazemLocalizacaoDestino).HasColumnName("IDArmazemLocalizacaoDestino");

            entity.Property(e => e.Idartigo).HasColumnName("IDArtigo");

            entity.Property(e => e.IdartigoNumSerie).HasColumnName("IDArtigoNumSerie");

            entity.Property(e => e.IdartigoPa).HasColumnName("IDArtigoPA");

            entity.Property(e => e.IdartigoPara).HasColumnName("IDArtigoPara");

            entity.Property(e => e.Idcampanha).HasColumnName("IDCampanha");

            entity.Property(e => e.IdcodigoIva).HasColumnName("IDCodigoIva");

            entity.Property(e => e.IddocumentoOrigem).HasColumnName("IDDocumentoOrigem");

            entity.Property(e => e.IddocumentoOrigemInicial).HasColumnName("IDDocumentoOrigemInicial");

            entity.Property(e => e.IddocumentoVenda).HasColumnName("IDDocumentoVenda");

            entity.Property(e => e.IdespacoFiscal).HasColumnName("IDEspacoFiscal");

            entity.Property(e => e.IdlinhaDocumentoCompraInicial).HasColumnName("IDLinhaDocumentoCompraInicial");

            entity.Property(e => e.IdlinhaDocumentoOrigem).HasColumnName("IDLinhaDocumentoOrigem");

            entity.Property(e => e.IdlinhaDocumentoOrigemInicial).HasColumnName("IDLinhaDocumentoOrigemInicial");

            entity.Property(e => e.IdlinhaDocumentoStockInicial).HasColumnName("IDLinhaDocumentoStockInicial");

            entity.Property(e => e.Idlote).HasColumnName("IDLote");

            entity.Property(e => e.Idofartigo).HasColumnName("IDOFArtigo");

            entity.Property(e => e.IdregimeIva).HasColumnName("IDRegimeIva");

            entity.Property(e => e.Idservico).HasColumnName("IDServico");

            entity.Property(e => e.IdtaxaIva).HasColumnName("IDTaxaIva");

            entity.Property(e => e.IdtipoDocumentoOrigem).HasColumnName("IDTipoDocumentoOrigem");

            entity.Property(e => e.IdtipoDocumentoOrigemInicial).HasColumnName("IDTipoDocumentoOrigemInicial");

            entity.Property(e => e.IdtipoGraduacao).HasColumnName("IDTipoGraduacao");

            entity.Property(e => e.IdtipoIva).HasColumnName("IDTipoIva");

            entity.Property(e => e.IdtipoOlho).HasColumnName("IDTipoOlho");

            entity.Property(e => e.IdtipoPreco).HasColumnName("IDTipoPreco");

            entity.Property(e => e.IdtipoServico).HasColumnName("IDTipoServico");

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

            entity.Property(e => e.TipoDistancia).HasMaxLength(50);

            entity.Property(e => e.TipoOlho).HasMaxLength(50);

            entity.Property(e => e.TipoTaxa).HasMaxLength(3);

            entity.Property(e => e.UpcmoedaRef).HasColumnName("UPCMoedaRef");

            entity.Property(e => e.UpcompraMoedaRef).HasColumnName("UPCompraMoedaRef");

            entity.Property(e => e.VatValue).HasColumnName("ValorIVA");

            entity.Property(e => e.VossoNumeroDocumentoOrigem).HasMaxLength(256);

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
                .WithMany(p => p.TbDocumentosVendasLinhasIdarmazemNavigation)
                .HasForeignKey(d => d.Idarmazem)
                .HasConstraintName("FK_tbDocumentosVendasLinhas_tbArmazens");

            entity.HasOne(d => d.IdarmazemDestinoNavigation)
                .WithMany(p => p.TbDocumentosVendasLinhasIdarmazemDestinoNavigation)
                .HasForeignKey(d => d.IdarmazemDestino)
                .HasConstraintName("FK_tbDocumentosVendasLinhas_tbArmazens_Destino");

            entity.HasOne(d => d.IdarmazemLocalizacaoNavigation)
                .WithMany(p => p.TbDocumentosVendasLinhasIdarmazemLocalizacaoNavigation)
                .HasForeignKey(d => d.IdarmazemLocalizacao)
                .HasConstraintName("FK_tbDocumentosVendasLinhas_tbArmazensLocalizacoes");

            entity.HasOne(d => d.IdarmazemLocalizacaoDestinoNavigation)
                .WithMany(p => p.TbDocumentosVendasLinhasIdarmazemLocalizacaoDestinoNavigation)
                .HasForeignKey(d => d.IdarmazemLocalizacaoDestino)
                .HasConstraintName("FK_tbDocumentosVendasLinhas_tbArmazensLocalizacoes_Destino");

            entity.HasOne(d => d.IdartigoNavigation)
                .WithMany(p => p.SalesDocumentProducts)
                .HasForeignKey(d => d.Idartigo)
                .HasConstraintName("FK_tbDocumentosVendasLinhas_tbArtigos");

            entity.HasOne(d => d.IdartigoNumSerieNavigation)
                .WithMany(p => p.TbDocumentosVendasLinhas)
                .HasForeignKey(d => d.IdartigoNumSerie)
                .HasConstraintName("FK_tbDocumentosVendasLinhas_tbArtigosNumerosSeries");

            entity.HasOne(d => d.IdcampanhaNavigation)
                .WithMany(p => p.TbDocumentosVendasLinhas)
                .HasForeignKey(d => d.Idcampanha)
                .HasConstraintName("FK_tbDocumentosVendasLinhas_tbCampanhas");

            entity.HasOne(d => d.IdcodigoIvaNavigation)
                .WithMany(p => p.SalesDocumentLine)
                .HasForeignKey(d => d.IdcodigoIva)
                .HasConstraintName("FK_tbDocumentosVendasLinhas_tbSistemaCodigosIVA");

            entity.HasOne(d => d.IddocumentoVendaNavigation)
                .WithMany(p => p.Lines)
                .HasForeignKey(d => d.IddocumentoVenda)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbDocumentosVendasLinhas_tbDocumentosVendas");

            entity.HasOne(d => d.IdespacoFiscalNavigation)
                .WithMany(p => p.TbDocumentosVendasLinhas)
                .HasForeignKey(d => d.IdespacoFiscal)
                .HasConstraintName("FK_tbDocumentosVendasLinhas_tbSistemaEspacoFiscal");

            entity.HasOne(d => d.IdlinhaDocumentoCompraInicialNavigation)
                .WithMany(p => p.InverseIdlinhaDocumentoCompraInicialNavigation)
                .HasForeignKey(d => d.IdlinhaDocumentoCompraInicial)
                .HasConstraintName("FK_tbDocumentosVendasLinhas_tbDocumentosVendasLinhasInicial");

            entity.HasOne(d => d.IdlinhaDocumentoStockInicialNavigation)
                .WithMany(p => p.TbDocumentosVendasLinhas)
                .HasForeignKey(d => d.IdlinhaDocumentoStockInicial)
                .HasConstraintName("FK_tbDocumentosVendasLinhas_tbDocumentosStockLinhasInicial");

            entity.HasOne(d => d.IdloteNavigation)
                .WithMany(p => p.TbDocumentosVendasLinhas)
                .HasForeignKey(d => d.Idlote)
                .HasConstraintName("FK_tbDocumentosVendasLinhas_tbArtigosLotes");

            entity.HasOne(d => d.IdregimeIvaNavigation)
                .WithMany(p => p.TbDocumentosVendasLinhas)
                .HasForeignKey(d => d.IdregimeIva)
                .HasConstraintName("FK_tbDocumentosVendasLinhas_tbSistemaRegimeIVA");

            entity.HasOne(d => d.IdservicoNavigation)
                .WithMany(p => p.TbDocumentosVendasLinhas)
                .HasForeignKey(d => d.Idservico)
                .HasConstraintName("FK_tbDocumentosVendasLinhas_tbServicos");

            entity.HasOne(d => d.IdtaxaIvaNavigation)
                .WithMany(p => p.SaleDocumentLine)
                .HasForeignKey(d => d.IdtaxaIva)
                .HasConstraintName("FK_tbDocumentosVendasLinhas_tbIVA");

            entity.HasOne(d => d.IdtipoDocumentoOrigemNavigation)
                .WithMany(p => p.TbDocumentosVendasLinhasIdtipoDocumentoOrigemNavigation)
                .HasForeignKey(d => d.IdtipoDocumentoOrigem)
                .HasConstraintName("FK_tbDocumentosVendasLinhas_IDTipoDocumentoOrigem");

            entity.HasOne(d => d.IdtipoDocumentoOrigemInicialNavigation)
                .WithMany(p => p.TbDocumentosVendasLinhasIdtipoDocumentoOrigemInicialNavigation)
                .HasForeignKey(d => d.IdtipoDocumentoOrigemInicial)
                .HasConstraintName("FK_tbDocumentosVendasLinhas_tbTiposDocumentoOrigemInicial");

            entity.HasOne(d => d.IdtipoGraduacaoNavigation)
                .WithMany(p => p.TbDocumentosVendasLinhas)
                .HasForeignKey(d => d.IdtipoGraduacao)
                .HasConstraintName("FK_tbDocumentosVendasLinhas_tbSistemaTiposGraduacoes");

            entity.HasOne(d => d.SystemVatType)
                .WithMany(p => p.SalesDocumentLine)
                .HasForeignKey(d => d.IdtipoIva)
                .HasConstraintName("FK_tbDocumentosVendasLinhas_tbSistemaTiposIVA");

            entity.HasOne(d => d.IdtipoOlhoNavigation)
                .WithMany(p => p.TbDocumentosVendasLinhas)
                .HasForeignKey(d => d.IdtipoOlho)
                .HasConstraintName("FK_tbDocumentosVendasLinhas_tbSistemaTiposOlhos");

            entity.HasOne(d => d.IdtipoPrecoNavigation)
                .WithMany(p => p.TbDocumentosVendasLinhas)
                .HasForeignKey(d => d.IdtipoPreco)
                .HasConstraintName("FK_tbDocumentosVendasLinhas_tbSistemaTiposPrecos");

            entity.HasOne(d => d.IdtipoServicoNavigation)
                .WithMany(p => p.TbDocumentosVendasLinhas)
                .HasForeignKey(d => d.IdtipoServico)
                .HasConstraintName("FK_tbDocumentosVendasLinhas_tbSistemaTiposServicos");

            entity.HasOne(d => d.IdtiposDocumentoSeriesOrigemNavigation)
                .WithMany(p => p.TbDocumentosVendasLinhas)
                .HasForeignKey(d => d.IdtiposDocumentoSeriesOrigem)
                .HasConstraintName("FK_tbDocumentosVendasLinhas_tbTiposDocumentoSeriesOrigem");

            entity.HasOne(d => d.IdunidadeNavigation)
                .WithMany(p => p.TbDocumentosVendasLinhasIdunidadeNavigation)
                .HasForeignKey(d => d.Idunidade)
                .HasConstraintName("FK_tbDocumentosVendasLinhas_tbUnidades");

            entity.HasOne(d => d.IdunidadeStockNavigation)
                .WithMany(p => p.TbDocumentosVendasLinhasIdunidadeStockNavigation)
                .HasForeignKey(d => d.IdunidadeStock)
                .HasConstraintName("FK_tbDocumentosVendasLinhas_tbUnidades2");

            entity.HasOne(d => d.IdunidadeStock2Navigation)
                .WithMany(p => p.TbDocumentosVendasLinhasIdunidadeStock2Navigation)
                .HasForeignKey(d => d.IdunidadeStock2)
                .HasConstraintName("FK_tbDocumentosVendasLinhas_tbUnidades3");
        }
    }
}
