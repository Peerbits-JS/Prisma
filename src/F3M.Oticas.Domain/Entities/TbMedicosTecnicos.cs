using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbMedicosTecnicos
    {
        public TbMedicosTecnicos()
        {
            TbAgendamento = new HashSet<TbAgendamento>();
            TbClientes = new HashSet<TbClientes>();
            TbExames = new HashSet<TbExames>();
            TbMedicosTecnicosAnexos = new HashSet<TbMedicosTecnicosAnexos>();
            TbMedicosTecnicosContatos = new HashSet<TbMedicosTecnicosContatos>();
            TbMedicosTecnicosEspecialidades = new HashSet<TbMedicosTecnicosEspecialidades>();
            TbMedicosTecnicosMoradas = new HashSet<TbMedicosTecnicosMoradas>();
            TbPlaneamento = new HashSet<TbPlaneamento>();
            TbServicos = new HashSet<TbServicos>();
        }

        public long Id { get; set; }
        public long? Idloja { get; set; }
        public long? Idsexo { get; set; }
        public string Codigo { get; set; }
        public string Nome { get; set; }
        public string Apelido { get; set; }
        public string Foto { get; set; }
        public string FotoCaminho { get; set; }
        public DateTime? DataNascimento { get; set; }
        public DateTime? DataValidade { get; set; }
        public long IdtipoEntidade { get; set; }
        public string Abreviatura { get; set; }
        public string CartaoCidadao { get; set; }
        public string Ncedula { get; set; }
        public string Ncontribuinte { get; set; }
        public long Tempoconsulta { get; set; }
        public bool? TemAgenda { get; set; }
        public long CorTexto { get; set; }
        public long CorFundo { get; set; }
        public long CorTexto1 { get; set; }
        public long CorFundo1 { get; set; }
        public string Observacoes { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }
        public bool? Esquecido { get; set; }
        public string Cor { get; set; }
        public long? Idutilizador { get; set; }
        public long? IdsistemaAcoes { get; set; }
        public long? Idtemplate { get; set; }
        public long? IdtipoConsulta { get; set; }
        public string Cabecalho { get; set; }

        public TbLojas IdlojaNavigation { get; set; }
        public SystemSex IdsexoNavigation { get; set; }
        public TbSistemaAcoes IdsistemaAcoesNavigation { get; set; }
        public TbTemplates IdtemplateNavigation { get; set; }
        public TbTiposConsultas IdtipoConsultaNavigation { get; set; }
        public SystemEntityType IdtipoEntidadeNavigation { get; set; }
        public ICollection<TbAgendamento> TbAgendamento { get; set; }
        public ICollection<TbClientes> TbClientes { get; set; }
        public ICollection<TbExames> TbExames { get; set; }
        public ICollection<TbMedicosTecnicosAnexos> TbMedicosTecnicosAnexos { get; set; }
        public ICollection<TbMedicosTecnicosContatos> TbMedicosTecnicosContatos { get; set; }
        public ICollection<TbMedicosTecnicosEspecialidades> TbMedicosTecnicosEspecialidades { get; set; }
        public ICollection<TbMedicosTecnicosMoradas> TbMedicosTecnicosMoradas { get; set; }
        public ICollection<TbPlaneamento> TbPlaneamento { get; set; }
        public ICollection<TbServicos> TbServicos { get; set; }
    }
}
