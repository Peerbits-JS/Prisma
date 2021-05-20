﻿using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbContasBancariasMoradas
    {
        public long Id { get; set; }
        public long? IdcontaBancaria { get; set; }
        public long? IdcodigoPostal { get; set; }
        public long? Idconcelho { get; set; }
        public long? Iddistrito { get; set; }
        public long? Idpais { get; set; }
        public string Descricao { get; set; }
        public string Rota { get; set; }
        public string Gps { get; set; }
        public int Ordem { get; set; }
        public int OrdemMorada { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }
        public string Morada { get; set; }

        public TbCodigosPostais IdcodigoPostalNavigation { get; set; }
        public TbConcelhos IdconcelhoNavigation { get; set; }
        public TbContasBancarias IdcontaBancariaNavigation { get; set; }
        public TbDistritos IddistritoNavigation { get; set; }
        public Country IdpaisNavigation { get; set; }
    }
}
