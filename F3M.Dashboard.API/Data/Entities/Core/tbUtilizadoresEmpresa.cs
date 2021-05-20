using F3M.Dashboard.API.Data.Entities.Base;
using F3M.Middleware.Data.Entities;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace F3M.Dashboard.API.Data.Entities.Core
{
    [Table("tbUtilizadoresEmpresa")]
    [Index(nameof(Idempresa), nameof(Idutilizador), Name = "IX_tbIEUtilizadoresEmpresa", IsUnique = true)]
    public partial class TbUtilizadoresEmpresa : EntityBase
    {
        public TbUtilizadoresEmpresa()
        {
        }

        [Key]
        [Column("ID")]
        public long Id { get; set; }
        [Column("IDEntidade")]
        public long? Identidade { get; set; }
        [Column("IDUtilizador")]
        public long Idutilizador { get; set; }
        [Column("IDPerfil")]
        public long? Idperfil { get; set; }
        [Column("IDEmpresa")]
        public long? Idempresa { get; set; }
        [Column("IDHomePage")]
        public long? IdhomePage { get; set; }
        [Column(TypeName = "datetime")]
        public DateTime? DataAberturaEmpresa { get; set; }
        public bool Ativo { get; set; }
        public bool Sistema { get; set; }
        [Column(TypeName = "datetime")]
        public DateTime DataCriacao { get; set; }
        [Required]
        [StringLength(256)]
        public string UtilizadorCriacao { get; set; }
        [Column(TypeName = "datetime")]
        public DateTime? DataAlteracao { get; set; }
        [StringLength(256)]
        public string UtilizadorAlteracao { get; set; }
        [Column("F3MMarcador")]
        public byte[] F3mmarcador { get; set; }
        [Column("IDLoja")]
        public long? Idloja { get; set; }
        [Column(TypeName = "datetime")]
        public DateTime? DataAberturaLoja { get; set; }

        
        [ForeignKey(nameof(IdhomePage))]
        [InverseProperty(nameof(TbMenus.TbUtilizadoresEmpresa))]
        public virtual TbMenus IdhomePageNavigation { get; set; }
       
        [ForeignKey(nameof(Idutilizador))]
        [InverseProperty(nameof(TbUtilizadores.TbUtilizadoresEmpresa))]
        public virtual TbUtilizadores IdutilizadorNavigation { get; set; }
        
    }
}