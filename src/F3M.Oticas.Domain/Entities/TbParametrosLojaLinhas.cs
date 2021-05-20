﻿using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbParametrosLojaLinhas
    {
        public TbParametrosLojaLinhas()
        {
            TbParametrosLojaLinhasValores = new HashSet<TbParametrosLojaLinhasValores>();
        }

        public long Id { get; set; }
        public long Idloja { get; set; }
        public string Codigo { get; set; }
        public string Descricao { get; set; }
        public string Valor { get; set; }
        public string TipoDados { get; set; }
        public bool Sistema { get; set; }
        public bool Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public TbLojas IdlojaNavigation { get; set; }
        public ICollection<TbParametrosLojaLinhasValores> TbParametrosLojaLinhasValores { get; set; }
    }
}
