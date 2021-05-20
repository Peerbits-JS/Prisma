﻿using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbUnidadesTempo
    {
        public long Id { get; set; }
        public string Codigo { get; set; }
        public string Descricao { get; set; }
        public bool Sistema { get; set; }
        public bool? Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }
        public double FatorConversaoSeg { get; set; }
        public long Idformato { get; set; }

        public TbSistemaFormatoUnidadeTempo IdformatoNavigation { get; set; }
    }
}
