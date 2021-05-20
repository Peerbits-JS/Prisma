using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace F3M.Middleware.Data.Entities
{
    [Table("tbPerfisAcessosAreasEmpresa")]
    public partial class TbPerfisAcessosAreasEmpresa
    {
        [Key]
        [Column("ID")]
        public long Id { get; set; }
        [Column("IDPerfis")]
        public long Idperfis { get; set; }
        [Column("IDMenusAreasEmpresa")]
        public long IdmenusAreasEmpresa { get; set; }
        [Column("IDLinhaTabela")]
        public long? IdlinhaTabela { get; set; }
        public bool? Consultar { get; set; }
        public bool? Adicionar { get; set; }
        public bool? Alterar { get; set; }
        public bool? Remover { get; set; }
        public bool? Imprimir { get; set; }
        public bool? Exportar { get; set; }
        public bool? F4 { get; set; }
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
        public bool? Importar { get; set; }
        public bool? Duplicar { get; set; }

        [ForeignKey(nameof(IdmenusAreasEmpresa))]
        [InverseProperty(nameof(TbMenusAreasEmpresa.TbPerfisAcessosAreasEmpresa))]
        public virtual TbMenusAreasEmpresa IdmenusAreasEmpresaNavigation { get; set; }
        [ForeignKey(nameof(Idperfis))]
        [InverseProperty(nameof(TbPerfis.TbPerfisAcessosAreasEmpresa))]
        public virtual TbPerfis IdperfisNavigation { get; set; }
    }
}
