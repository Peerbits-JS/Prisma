using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace F3M.Middleware.Data.Entities
{
    [Table("tbUtilizadoresEmpresa")]
    [Index(nameof(Idempresa), nameof(Idutilizador), Name = "IX_tbIEUtilizadoresEmpresa", IsUnique = true)]
    public partial class TbUtilizadoresEmpresa
    {
        public TbUtilizadoresEmpresa()
        {
            TbUtilEmprEstado = new HashSet<TbUtilEmprEstado>();
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

        [ForeignKey(nameof(Idempresa))]
        [InverseProperty(nameof(TbEmpresas.TbUtilizadoresEmpresa))]
        public virtual TbEmpresas IdempresaNavigation { get; set; }
        [ForeignKey(nameof(IdhomePage))]
        [InverseProperty(nameof(TbMenus.TbUtilizadoresEmpresa))]
        public virtual TbMenus IdhomePageNavigation { get; set; }
        [ForeignKey(nameof(Idperfil))]
        [InverseProperty(nameof(TbPerfis.TbUtilizadoresEmpresa))]
        public virtual TbPerfis IdperfilNavigation { get; set; }
        [ForeignKey(nameof(Idutilizador))]
        [InverseProperty(nameof(TbUtilizadores.TbUtilizadoresEmpresa))]
        public virtual TbUtilizadores IdutilizadorNavigation { get; set; }
        [InverseProperty("IdutilizadorEmpresaNavigation")]
        public virtual ICollection<TbUtilEmprEstado> TbUtilEmprEstado { get; set; }
    }

}
