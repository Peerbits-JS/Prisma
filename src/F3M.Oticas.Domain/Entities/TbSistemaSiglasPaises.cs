using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbSistemaSiglasPaises
    {
        public TbSistemaSiglasPaises()
        {
            TbPaises = new HashSet<Country>();
            TbParametrosEmpresa = new HashSet<TbParametrosEmpresa>();
            TbParametrosLoja = new HashSet<TbParametrosLoja>();
        }

        public long Id { get; set; }
        public string Sigla { get; set; }
        public bool Sistema { get; set; }
        public bool Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }
        public bool? Nacional { get; set; }
        public string Descricao { get; set; }
        public string DescricaoPais { get; set; }

        public ICollection<Country> TbPaises { get; set; }
        public ICollection<TbParametrosEmpresa> TbParametrosEmpresa { get; set; }
        public ICollection<TbParametrosLoja> TbParametrosLoja { get; set; }
    }
}
