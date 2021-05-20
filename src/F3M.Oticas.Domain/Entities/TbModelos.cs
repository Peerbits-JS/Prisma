using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbModelos
    {
        public TbModelos()
        {
            TbAros = new HashSet<TbAros>();
            TbCoresLentes = new HashSet<TbCoresLentes>();
            TbGamasLentes = new HashSet<TbGamasLentes>();
            TbLentesContato = new HashSet<TbLentesContato>();
            TbLentesOftalmicas = new HashSet<TbLentesOftalmicas>();
            TbOculosSol = new HashSet<TbOculosSol>();
            TbPrecosLentes = new HashSet<TbPrecosLentes>();
            TbSuplementosLentes = new HashSet<TbSuplementosLentes>();
            TbTratamentosLentes = new HashSet<TbTratamentosLentes>();
        }

        public long Id { get; set; }
        public long Idmarca { get; set; }
        public long IdtipoArtigo { get; set; }
        public long? IdtipoLente { get; set; }
        public long? IdmateriaLente { get; set; }
        public long? IdsuperficieLente { get; set; }
        public string Codigo { get; set; }
        public string Descricao { get; set; }
        public bool Stock { get; set; }
        public bool Fotocromatica { get; set; }
        public double IndiceRefracao { get; set; }
        public string NrAbbe { get; set; }
        public string TransmissaoLuz { get; set; }
        public string Material { get; set; }
        public string Uva { get; set; }
        public string Uvb { get; set; }
        public string Infravermelhos { get; set; }
        public string CodForn { get; set; }
        public string Referencia { get; set; }
        public string ModeloForn { get; set; }
        public string CodCor { get; set; }
        public string CodTratamento { get; set; }
        public string CodInstrucao { get; set; }
        public string Observacoes { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public TbMarcas IdmarcaNavigation { get; set; }
        public TbSistemaMateriasLentes IdmateriaLenteNavigation { get; set; }
        public TbSistemaSuperficiesLentes IdsuperficieLenteNavigation { get; set; }
        public TbTiposArtigos IdtipoArtigoNavigation { get; set; }
        public TbSistemaTiposLentes IdtipoLenteNavigation { get; set; }
        public ICollection<TbAros> TbAros { get; set; }
        public ICollection<TbCoresLentes> TbCoresLentes { get; set; }
        public ICollection<TbGamasLentes> TbGamasLentes { get; set; }
        public ICollection<TbLentesContato> TbLentesContato { get; set; }
        public ICollection<TbLentesOftalmicas> TbLentesOftalmicas { get; set; }
        public ICollection<TbOculosSol> TbOculosSol { get; set; }
        public ICollection<TbPrecosLentes> TbPrecosLentes { get; set; }
        public ICollection<TbSuplementosLentes> TbSuplementosLentes { get; set; }
        public ICollection<TbTratamentosLentes> TbTratamentosLentes { get; set; }
    }
}
