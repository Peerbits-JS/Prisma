create table tbLojas (ID bigint, constraint PK_tbLojas primary Key (ID), IDEmpresa bigint not null,Codigo nvarchar (10) not null,Descricao nvarchar (50) not null,IDLojaSede bigint not null,DescricaoLojaSede nvarchar (50) null,SedeGrupo bit not null constraint DF_tbLojas_SedeGrupo default 0,Ativo bit not null constraint DF_tbLojas_Ativo default 1,Sistema bit not null constraint DF_tbLojas_Sistema default 0,DataCriacao datetime not null constraint DF_tbLojas_DataCriacao default getdate(),UtilizadorCriacao nvarchar (256) not null constraint DF_tbLojas_UtilizadorCriacao default '',DataAlteracao datetime null constraint DF_tbLojas_DataAlteracao default getdate(),UtilizadorAlteracao nvarchar (256) null constraint DF_tbLojas_UtilizadorAlteracao default '',F3MMarcador timestamp null ) 
create unique index IX_tbLojas_Codigo on tbLojas (Codigo) 
create table tbVersao (ID bigint  identity(1,1) , constraint PK_tbVersao primary Key (ID), Major int not null constraint DF_tbVersao_Major default 0,Minor int not null constraint DF_tbVersao_Minor default 0,Version int not null constraint DF_tbVersao_Version default 0,DbVersion int not null constraint DF_tbVersao_DbVersion default 0,DbVersionSistema int null,Ativo bit not null constraint DF_tbVersao_Ativo default 1,Sistema bit not null constraint DF_tbVersao_Sistema default 0,DataCriacao datetime not null constraint DF_tbVersao_DataCriacao default getdate(),UtilizadorCriacao nvarchar (256) not null constraint DF_tbVersao_UtilizadorCriacao default '',DataAlteracao datetime null constraint DF_tbVersao_DataAlteracao default getdate(),UtilizadorAlteracao nvarchar (256) null constraint DF_tbVersao_UtilizadorAlteracao default '',F3MMarcador timestamp null ) 
create table tbPaises (ID bigint  identity(1,1) , constraint PK_tbPaises primary Key (ID), Descricao nvarchar (50) not null,VariavelContabilidade nvarchar (20) null,IDSigla bigint not null,Ativo bit not null constraint DF_tbPaises_Ativo default 1,Sistema bit not null constraint DF_tbPaises_Sistema default 0,DataCriacao datetime not null constraint DF_tbPaises_DataCriacao default getdate(),UtilizadorCriacao nvarchar (256) not null constraint DF_tbPaises_UtilizadorCriacao default '',DataAlteracao datetime null constraint DF_tbPaises_DataAlteracao default getdate(),UtilizadorAlteracao nvarchar (256) null constraint DF_tbPaises_UtilizadorAlteracao default '',F3MMarcador timestamp null ) 
alter table tbPaises add constraint FK_tbPaises_IDSigla  foreign key (IDSigla) references tbSistemaSiglasPaises (ID)
create table tbDistritos (ID bigint  identity(1,1) , constraint PK_tbDistritos primary Key (ID), Codigo nvarchar (10) not null,Descricao nvarchar (50) not null,Ativo bit not null constraint DF_tbDistritos_Ativo default 1,Sistema bit not null constraint DF_tbDistritos_Sistema default 0,DataCriacao datetime not null constraint DF_tbDistritos_DataCriacao default getdate(),UtilizadorCriacao nvarchar (256) not null constraint DF_tbDistritos_UtilizadorCriacao default '',DataAlteracao datetime null constraint DF_tbDistritos_DataAlteracao default getdate(),UtilizadorAlteracao nvarchar (256) null constraint DF_tbDistritos_UtilizadorAlteracao default '',F3MMarcador timestamp null ) 
create unique index IX_tbDistritos_Codigo on tbDistritos (Codigo) 
create table tbConcelhos (ID bigint  identity(1,1) , constraint PK_tbConcelhos primary Key (ID), Codigo nvarchar (10) not null,Descricao nvarchar (50) not null,IDDistrito bigint not null,Ativo bit not null constraint DF_tbConcelhos_Ativo default 1,Sistema bit not null constraint DF_tbConcelhos_Sistema default 0,DataCriacao datetime not null constraint DF_tbConcelhos_DataCriacao default getdate(),UtilizadorCriacao nvarchar (256) not null constraint DF_tbConcelhos_UtilizadorCriacao default '',DataAlteracao datetime null constraint DF_tbConcelhos_DataAlteracao default getdate(),UtilizadorAlteracao nvarchar (256) null constraint DF_tbConcelhos_UtilizadorAlteracao default '',F3MMarcador timestamp null ) 
alter table tbConcelhos add constraint FK_tbConcelhos_tbDistritos foreign key (IDDistrito) references tbDistritos (ID)
create unique index IX_tbConcelhos_Codigo on tbConcelhos (Codigo) 
create table tbCodigosPostais (ID bigint  identity(1,1) , constraint PK_tbCodigosPostais primary Key (ID), Codigo nvarchar (10) not null,Descricao nvarchar (50) not null,IDConcelho bigint not null,Ativo bit not null constraint DF_tbCodigosPostais_Ativo default 1,Sistema bit not null constraint DF_tbCodigosPostais_Sistema default 0,DataCriacao datetime not null constraint DF_tbCodigosPostais_DataCriacao default getdate(),UtilizadorCriacao nvarchar (256) not null constraint DF_tbCodigosPostais_UtilizadorCriacao default '',DataAlteracao datetime null constraint DF_tbCodigosPostais_DataAlteracao default getdate(),UtilizadorAlteracao nvarchar (256) null constraint DF_tbCodigosPostais_UtilizadorAlteracao default '',F3MMarcador timestamp null ) 
alter table tbCodigosPostais add constraint FK_tbCodigosPostais_tbConcelhos foreign key (IDConcelho) references tbConcelhos (ID)
create unique index IX_tbCodigosPostais_Codigo on tbCodigosPostais (Codigo) 
create table tbMoedas (ID bigint  identity(1,1) , constraint PK_tbMoedas primary Key (ID), Codigo nvarchar (3) not null,Descricao nvarchar (50) not null,TaxaConversao float not null constraint DF_tbMoedas_TaxaConversao default 0,DescricaoDecimal nvarchar (50) not null,DescricaoInteira nvarchar (50) not null,CasasDecimaisTotais tinyint null constraint CK_tbMoedas_CasasDecimaisTotais check (CasasDecimaisTotais>=0 and CasasDecimaisTotais<=4),CasasDecimaisIva tinyint null constraint CK_tbMoedas_CasasDecimaisIva check (CasasDecimaisIva>=0 and CasasDecimaisIva<=6),CasasDecimaisPrecosUnitarios tinyint null constraint CK_tbMoedas_CasasDecimaisPrecosUnitarios check (CasasDecimaisPrecosUnitarios>=0 and CasasDecimaisPrecosUnitarios<=6), IDSistemaMoeda bigint not null,Ativo bit not null constraint DF_tbMoedas_Ativo default 1,Sistema bit not null constraint DF_tbMoedas_Sistema default 0,DataCriacao datetime not null constraint DF_tbMoedas_DataCriacao default getdate(),UtilizadorCriacao nvarchar (256) not null constraint DF_tbMoedas_UtilizadorCriacao default '',DataAlteracao datetime null constraint DF_tbMoedas_DataAlteracao default getdate(),UtilizadorAlteracao nvarchar (256) null constraint DF_tbMoedas_UtilizadorAlteracao default '',F3MMarcador timestamp null, Simbolo nvarchar(3) null) 
alter table tbMoedas add constraint FK_tbMoedas_tbSistemaMoedas foreign key (IDSistemaMoeda) references tbSistemaMoedas (ID)
create unique index IX_tbMoedas_Codigo on tbMoedas (Codigo) 
create table tbEntidades (ID bigint  identity(1,1) , constraint PK_tbEntidades primary Key (ID), IDLoja bigint null, Codigo nvarchar (10) not null,Descricao nvarchar (100) not null,Abreviatura nvarchar (50) null,Foto nvarchar (255) null,FotoCaminho nvarchar (4000) null,NContribuinte nvarchar (25) null,Contabilidade nvarchar (20) null,IDTipoEntidade bigint not null constraint DF_tbEntidades_IDTipoEntidade default 0,IDTipoDescricao bigint not null constraint DF_tbEntidades_IDTipoDescricao default 0,Observacoes nvarchar (4000) null,Ativo bit not null constraint DF_tbEntidades_Ativo default 1,Sistema bit not null constraint DF_tbEntidades_Sistema default 0,DataCriacao datetime not null constraint DF_tbEntidades_DataCriacao default getdate(),UtilizadorCriacao nvarchar (256) not null constraint DF_tbEntidades_UtilizadorCriacao default '',DataAlteracao datetime null constraint DF_tbEntidades_DataAlteracao default getdate(),UtilizadorAlteracao nvarchar (256) null constraint DF_tbEntidades_UtilizadorAlteracao default '',F3MMarcador timestamp null ) 
alter table tbEntidades add constraint FK_tbEntidades_tbSistemaEntidadeComparticipacao  foreign key (IDTipoEntidade) references tbSistemaEntidadeComparticipacao (ID)
alter table tbEntidades add constraint FK_tbEntidades_tbSistemaEntidadeDescricao foreign key (IDTipoDescricao) references tbSistemaEntidadeDescricao (ID)
alter table tbEntidades add constraint FK_tbEntidades_tbLojas foreign key (IDLoja) references tbLojas (ID)
create unique index IX_tbEntidades_Codigo on tbEntidades (Codigo) 
create table tbEntidadesLojas (ID bigint  identity(1,1) , constraint PK_tbEntidadesLojas primary Key (ID), IDLoja bigint null,IDEntidade bigint not null,NumAssociado nvarchar (50) null,ServicosAdm float not null constraint DF_tbEntidadesLojas_ServicosAdm default 0,TaxaIva float not null constraint DF_tbEntidadesLojas_TaxaIva default 0,Saldo float not null constraint DF_tbEntidadesLojas_Saldo default 0,Ativo bit not null constraint DF_tbEntidadesLojas_Ativo default 1,Sistema bit not null constraint DF_tbEntidadesLojas_Sistema default 0,DataCriacao datetime not null constraint DF_tbEntidadesLojas_DataCriacao default getdate(),UtilizadorCriacao nvarchar (256) not null constraint DF_tbEntidadesLojas_UtilizadorCriacao default '',DataAlteracao datetime null constraint DF_tbEntidadesLojas_DataAlteracao default getdate(),UtilizadorAlteracao nvarchar (256) null constraint DF_tbEntidadesLojas_UtilizadorAlteracao default '',F3MMarcador timestamp null, Ordem int null) 
alter table tbEntidadesLojas add constraint FK_tbEntidadesLojas_tbEntidades foreign key (IDEntidade) references tbEntidades (ID)
alter table tbEntidadesLojas add constraint FK_tbEntidadesLojas_tbLojas foreign key (IDLoja) references tbLojas (ID)
create table tbEntidadesMoradas (ID bigint  identity(1,1) , constraint PK_tbEntidadesMoradas primary Key (ID), IDEntidade bigint not null,IDCodigoPostal bigint null,IDConcelho bigint null,IDDistrito bigint null,IDPais bigint null,Descricao nvarchar (50) null,Rota nvarchar (255) null,Rua nvarchar (255) null,NumPolicia nvarchar (100) null,GPS nvarchar (100) null,Ordem int not null,OrdemMorada int not null,Ativo bit not null constraint DF_tbEntidadesMoradas_Ativo default 1,Sistema bit not null constraint DF_tbEntidadesMoradas_Sistema default 0,DataCriacao datetime not null constraint DF_tbEntidadesMoradas_DataCriacao default getdate(),UtilizadorCriacao nvarchar (256) not null constraint DF_tbEntidadesMoradas_UtilizadorCriacao default '',DataAlteracao datetime null constraint DF_tbEntidadesMoradas_DataAlteracao default getdate(),UtilizadorAlteracao nvarchar (256) null constraint DF_tbEntidadesMoradas_UtilizadorAlteracao default '',F3MMarcador timestamp null ) 
alter table tbEntidadesMoradas add constraint FK_tbEntidadesMoradas_tbEntidades foreign key (IDEntidade) references tbEntidades (ID)
alter table tbEntidadesMoradas add constraint FK_tbEntidadesMoradas_tbCodigosPostais  foreign key (IDCodigoPostal) references tbCodigosPostais (ID)
alter table tbEntidadesMoradas add constraint FK_tbEntidadesMoradas_tbConcelhos foreign key (IDConcelho) references tbConcelhos (ID)
alter table tbEntidadesMoradas add constraint FK_tbEntidadesMoradas_tbDistritos foreign key (IDDistrito) references tbDistritos (ID)
alter table tbEntidadesMoradas add constraint FK_tbEntidadesMoradas_tbPaises foreign key (IDPais) references tbPaises (ID)
create table tbTiposContatos (ID bigint  identity(1,1) , constraint PK_tbTiposContatos primary Key (ID), Codigo nvarchar (10) not null,Descricao nvarchar (50) not null,Ativo bit not null constraint DF_tbTiposContatos_Ativo default 1,Sistema bit not null constraint DF_tbTiposContatos_Sistema default 0,DataCriacao datetime not null constraint DF_tbTiposContatos_DataCriacao default getdate(),UtilizadorCriacao nvarchar (256) not null constraint DF_tbTiposContatos_UtilizadorCriacao default '',DataAlteracao datetime null constraint DF_tbTiposContatos_DataAlteracao default getdate(),UtilizadorAlteracao nvarchar (256) null constraint DF_tbTiposContatos_UtilizadorAlteracao default '',F3MMarcador timestamp null ) 
create unique index IX_tbTiposContatos_Codigo on tbTiposContatos (Codigo) 
create table tbEntidadesContatos (ID bigint  identity(1,1) , constraint PK_tbEntidadesContatos primary Key (ID), IDEntidade bigint null,IDTipo bigint null,Descricao nvarchar (50) null,Contato nvarchar (50) null,Telefone nvarchar (25) null,Telemovel nvarchar (25) null,Fax nvarchar (25) null,Email nvarchar (255) null,Mailing bit not null constraint DF_tbEntidadesContatos_Mailing default 1,PagWeb nvarchar (255) null,PagRedeSocial nvarchar (255) null,Ordem int not null,Ativo bit not null constraint DF_tbEntidadesContatos_Ativo default 1,Sistema bit not null constraint DF_tbEntidadesContatos_Sistema default 0,DataCriacao datetime not null constraint DF_tbEntidadesContatos_DataCriacao default getdate(),UtilizadorCriacao nvarchar (256) not null constraint DF_tbEntidadesContatos_UtilizadorCriacao default '',DataAlteracao datetime null constraint DF_tbEntidadesContatos_DataAlteracao default getdate(),UtilizadorAlteracao nvarchar (256) null constraint DF_tbEntidadesContatos_UtilizadorAlteracao default '',F3MMarcador timestamp null ) 
alter table tbEntidadesContatos add constraint FK_tbEntidadesContatos_tbEntidades foreign key (IDEntidade) references tbEntidades (ID)
alter table tbEntidadesContatos add constraint FK_tbEntidadesContatos_tbTiposContatos foreign key (IDTipo) references tbTiposContatos (ID)
create table tbTiposRelacao (ID bigint  identity(1,1) , constraint PK_tbTiposRelacao primary Key (ID), Codigo nvarchar (10) not null,Descricao nvarchar (50) not null,Ativo bit not null constraint DF_tbTiposRelacao_Ativo default 1,Sistema bit not null constraint DF_tbTiposRelacao_Sistema default 0,DataCriacao datetime not null constraint DF_tbTiposRelacao_DataCriacao default getdate(),UtilizadorCriacao nvarchar (256) not null constraint DF_tbTiposRelacao_UtilizadorCriacao default '',DataAlteracao datetime null constraint DF_tbTiposRelacao_DataAlteracao default getdate(),UtilizadorAlteracao nvarchar (256) null constraint DF_tbTiposRelacao_UtilizadorAlteracao default '',F3MMarcador timestamp null ) 
create unique index IX_tbTiposRelacao_Codigo on tbTiposRelacao (Codigo) 
create table tbEspecialidades (ID bigint  identity(1,1) , constraint PK_tbEspecialidades primary Key (ID), Codigo nvarchar (10) not null,Descricao nvarchar (50) not null,Ativo bit not null constraint DF_tbEspecialidades_Ativo default 1,Sistema bit not null constraint DF_tbEspecialidades_Sistema default 0,DataCriacao datetime not null constraint DF_tbEspecialidades_DataCriacao default getdate(),UtilizadorCriacao nvarchar (256) not null constraint DF_tbEspecialidades_UtilizadorCriacao default '',DataAlteracao datetime null constraint DF_tbEspecialidades_DataAlteracao default getdate(),UtilizadorAlteracao nvarchar (256) null constraint DF_tbEspecialidades_UtilizadorAlteracao default '',F3MMarcador timestamp null ) 
create unique index IX_tbEspecialidades_Codigo on tbEspecialidades (Codigo) 
create table tbMedicosTecnicos (ID bigint  identity(1,1) , constraint PK_tbMedicosTecnicos primary Key (ID), IDLoja bigint null, IDSexo bigint null, Codigo nvarchar (10) not null,Nome nvarchar (100) not null,Apelido nvarchar (50) null,Foto nvarchar (255) null,FotoCaminho nvarchar (4000) null,DataNascimento datetime null,DataValidade datetime null,IDTipoEntidade bigint not null,Abreviatura nvarchar (50) null,CartaoCidadao nvarchar (25) null,NCedula nvarchar (25) null,NContribuinte nvarchar (25) null,Tempoconsulta bigint not null constraint DF_tbMedicosTecnicos_Tempoconsulta default 30,TemAgenda bit not null constraint DF_tbMedicosTecnicos_TemAgenda default 1,CorTexto bigint not null constraint DF_tbMedicosTecnicos_CorTexto default 16777196,CorFundo bigint not null constraint DF_tbMedicosTecnicos_CorFundo default 8410939,CorTexto1 bigint not null constraint DF_tbMedicosTecnicos_CorTexto1 default 16777196,CorFundo1 bigint not null constraint DF_tbMedicosTecnicos_CorFundo1 default 13741460,Observacoes nvarchar (4000) null,Ativo bit not null constraint DF_tbMedicosTecnicos_Ativo default 1,Sistema bit not null constraint DF_tbMedicosTecnicos_Sistema default 0,DataCriacao datetime not null constraint DF_tbMedicosTecnicos_DataCriacao default getdate(),UtilizadorCriacao nvarchar (256) not null constraint DF_tbMedicosTecnicos_UtilizadorCriacao default '',DataAlteracao datetime null constraint DF_tbMedicosTecnicos_DataAlteracao default getdate(),UtilizadorAlteracao nvarchar (256) null constraint DF_tbMedicosTecnicos_UtilizadorAlteracao default '',F3MMarcador timestamp null ) 
create unique index IX_tbMedicosTecnicos_Codigo on tbMedicosTecnicos (Codigo) 
alter table tbMedicosTecnicos add constraint FK_tbMedicosTecnicos_tbLojas foreign key (IDLoja) references tbLojas (ID)
alter table tbMedicosTecnicos add constraint FK_tbMedicosTecnicos_tbSistemaSexo foreign key (IDSexo) references tbSistemaSexo (ID)
create table tbMedicosTecnicosMoradas (ID bigint  identity(1,1) , constraint PK_tbMedicosTecnicosMoradas primary Key (ID), IDMedicoTecnico bigint not null,IDCodigoPostal bigint null,IDConcelho bigint null,IDDistrito bigint null,IDPais bigint null,Descricao nvarchar (50) null,Rota nvarchar (255) null,Rua nvarchar (255) null,NumPolicia nvarchar (100) null,GPS nvarchar (100) null,Ordem int not null,OrdemMorada int not null,Ativo bit not null constraint DF_tbMedicosTecnicosMoradas_Ativo default 1,Sistema bit not null constraint DF_tbMedicosTecnicosMoradas_Sistema default 0,DataCriacao datetime not null constraint DF_tbMedicosTecnicosMoradas_DataCriacao default getdate(),UtilizadorCriacao nvarchar (256) not null constraint DF_tbMedicosTecnicosMoradas_UtilizadorCriacao default '',DataAlteracao datetime null constraint DF_tbMedicosTecnicosMoradas_DataAlteracao default getdate(),UtilizadorAlteracao nvarchar (256) null constraint DF_tbMedicosTecnicosMoradas_UtilizadorAlteracao default '',F3MMarcador timestamp null ) 
alter table tbMedicosTecnicosMoradas add constraint FK_tbMedicosTecnicosMoradas_tbMedicosTecnicos foreign key (IDMedicoTecnico) references tbMedicosTecnicos (ID)
alter table tbMedicosTecnicosMoradas add constraint FK_tbMedicosTecnicosMoradas_tbCodigosPostais foreign key (IDCodigoPostal) references tbCodigosPostais (ID)
alter table tbMedicosTecnicosMoradas add constraint FK_tbMedicosTecnicosMoradas_tbConcelhos foreign key (IDConcelho) references tbConcelhos (ID)
alter table tbMedicosTecnicosMoradas add constraint FK_tbMedicosTecnicosMoradas_tbDistritos foreign key (IDDistrito) references tbDistritos (ID)
alter table tbMedicosTecnicosMoradas add constraint FK_tbMedicosTecnicosMoradas_tbPaises foreign key (IDPais) references tbPaises (ID)
create table tbMedicosTecnicosContatos (ID bigint  identity(1,1) , constraint PK_tbMedicosTecnicosContatos primary Key (ID), IDMedicoTecnico bigint null,IDTipo bigint null,Descricao nvarchar (50) null,Contato nvarchar (50) null,Telefone nvarchar (25) null,Telemovel nvarchar (25) null,Fax nvarchar (25) null,Email nvarchar (255) null,Mailing bit not null constraint DF_tbMedicosTecnicosContatos_Mailing default 1,PagWeb nvarchar (255) null,PagRedeSocial nvarchar (255) null,Ordem int not null,Ativo bit not null constraint DF_tbMedicosTecnicosContatos_Ativo default 1,Sistema bit not null constraint DF_tbMedicosTecnicosContatos_Sistema default 0,DataCriacao datetime not null constraint DF_tbMedicosTecnicosContatos_DataCriacao default getdate(),UtilizadorCriacao nvarchar (256) not null constraint DF_tbMedicosTecnicosContatos_UtilizadorCriacao default '',DataAlteracao datetime null constraint DF_tbMedicosTecnicosContatos_DataAlteracao default getdate(),UtilizadorAlteracao nvarchar (256) null constraint DF_tbMedicosTecnicosContatos_UtilizadorAlteracao default '',F3MMarcador timestamp null ) 
alter table tbMedicosTecnicosContatos add constraint FK_tbMedicosTecnicosContatos_tbMedicostecnicos foreign key (IDMedicoTecnico) references tbMedicostecnicos (ID)
alter table tbMedicosTecnicosContatos add constraint FK_tbMedicosTecnicosContatos_tbTiposContatos foreign key (IDTipo) references tbTiposContatos (ID)
create table tbMedicosTecnicosEspecialidades (ID bigint  identity(1,1) , constraint PK_tbMedicosTecnicosEspecialidades primary Key (ID), IDMedicoTecnico bigint not null,IDEspecialidade bigint not null,Selecionado bit not null constraint DF_tbMedicosTecnicosEspecialidades_Selecionado default 0, Principal bit not null constraint DF_tbMedicosTecnicosEspecialidades_Principal default 0,Ativo bit not null constraint DF_tbMedicosTecnicosEspecialidades_Ativo default 1,Sistema bit not null constraint DF_tbMedicosTecnicosEspecialidades_Sistema default 0,DataCriacao datetime not null constraint DF_tbMedicosTecnicosEspecialidades_DataCriacao default getdate(),UtilizadorCriacao nvarchar (256) not null constraint DF_tbMedicosTecnicosEspecialidades_UtilizadorCriacao default '',DataAlteracao datetime null constraint DF_tbMedicosTecnicosEspecialidades_DataAlteracao default getdate(),UtilizadorAlteracao nvarchar (256) null constraint DF_tbMedicosTecnicosEspecialidades_UtilizadorAlteracao default '',F3MMarcador timestamp null ) 
alter table tbMedicosTecnicosEspecialidades add constraint FK_tbMedicosTecnicosEspecialidades_tbMedicosTecnicos foreign key (IDMedicoTecnico) references tbMedicosTecnicos (ID)
alter table tbMedicosTecnicosEspecialidades add constraint FK_tbMedicosTecnicosEspecialidades_tbEspecialidades foreign key (IDEspecialidade) references tbEspecialidades (ID)

CREATE TABLE [dbo].[tbParametrosEmpresa](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDMoedaDefeito] [bigint] NULL,
	[Morada] [nvarchar](100) NULL,
	[Foto] [nvarchar](255) NULL,
	[FotoCaminho] [nvarchar](max) NULL,
	[DesignacaoComercial] [nvarchar](160) NULL,
	[CodigoPostal] [nvarchar](8) NULL,
	[Localidade] [nvarchar](50) NULL,
	[Concelho] [nvarchar](50) NULL,
	[Distrito] [nvarchar](50) NULL,
	[IDPais] [bigint] NULL,
	[Telefone] [nvarchar](20) NULL,
	[Fax] [nvarchar](20) NULL,
	[Email] [nvarchar](60) NULL,
	[WebSite] [nvarchar](60) NULL,
	[NIF] [nvarchar](9) NULL,
	[ConservatoriaRegistoComercial] [nvarchar](35) NULL,
	[NumeroRegistoComercial] [nvarchar](15) NULL,
	[CapitalSocial] [nvarchar](255) NULL,
	[IDIdiomaBase] [bigint] NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](255) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](255) NULL,
	[F3MMarcador] [timestamp] NULL,
	[IDEmpresa] [bigint] NOT NULL DEFAULT ((0)),
	[CasasDecimaisPercentagem] [tinyint] NULL,
	[IDPaisesDesc] bigint NULL,
 CONSTRAINT [PK_tbParametrosEmpresa] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[tbParametrosEmpresa]  WITH CHECK ADD  CONSTRAINT [FK_tbParametrosEmpresa_tbMoedas] FOREIGN KEY([IDMoedaDefeito])
REFERENCES [dbo].[tbMoedas] ([ID])

ALTER TABLE [dbo].[tbParametrosEmpresa] CHECK CONSTRAINT [FK_tbParametrosEmpresa_tbMoedas]

ALTER TABLE [dbo].[tbParametrosEmpresa]  WITH CHECK ADD  CONSTRAINT [FK_tbParametrosEmpresa_tbSistemaSiglasPaises] FOREIGN KEY([IDPais])
REFERENCES [dbo].[tbSistemaSiglasPaises] ([ID])

ALTER TABLE [dbo].[tbParametrosEmpresa] CHECK CONSTRAINT [FK_tbParametrosEmpresa_tbSistemaSiglasPaises]

CREATE TABLE [dbo].[tbParametrosEmpresaCAE](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDParametrosEmpresa] [bigint] NOT NULL,
	[Codigo] [nvarchar](5) NULL,
	[Descricao] [nvarchar](255) NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbParametrosEmpresaCAE] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tbParametrosEmpresaCAE]  WITH CHECK ADD  CONSTRAINT [FK_tbParametrosEmpresaCAE_tbParametrosEmpresa] FOREIGN KEY([IDParametrosEmpresa])
REFERENCES [dbo].[tbParametrosEmpresa] ([ID])
ON DELETE CASCADE

ALTER TABLE [dbo].[tbParametrosEmpresaCAE] CHECK CONSTRAINT [FK_tbParametrosEmpresaCAE_tbParametrosEmpresa]

CREATE UNIQUE NONCLUSTERED INDEX [IX_tbParametrosEmpresaCAE] ON [dbo].[tbParametrosEmpresaCAE]
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

CREATE TABLE [dbo].[tbParametrosLoja](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDMoedaDefeito] [bigint] NULL,
	[Morada] [nvarchar](100) NULL,
	[Foto] [nvarchar](255) NULL,
	[FotoCaminho] [nvarchar](max) NULL,
	[DesignacaoComercial] [nvarchar](160) NULL,
	[CodigoPostal] [nvarchar](8) NULL,
	[Localidade] [nvarchar](50) NULL,
	[Concelho] [nvarchar](50) NULL,
	[Distrito] [nvarchar](50) NULL,
	[IDPais] [bigint] NULL,
	[Telefone] [nvarchar](20) NULL,
	[Fax] [nvarchar](20) NULL,
	[Email] [nvarchar](60) NULL,
	[WebSite] [nvarchar](60) NULL,
	[NIF] [nvarchar](9) NULL,
	[ConservatoriaRegistoComercial] [nvarchar](35) NULL,
	[NumeroRegistoComercial] [nvarchar](15) NULL,
	[CapitalSocial] [nvarchar](255) NULL,
	[CasasDecimaisPercentagem] [tinyint] NULL,
	[IDLoja] [bigint] NULL,
	[IDIdiomaBase] [bigint] NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](255) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](255) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbParametrosLoja] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[tbParametrosLoja]  WITH CHECK ADD  CONSTRAINT [FK_tbParametrosLoja_IDLoja] FOREIGN KEY([IDLoja])
REFERENCES [dbo].[tbLojas] ([ID])

ALTER TABLE [dbo].[tbParametrosLoja] CHECK CONSTRAINT [FK_tbParametrosLoja_IDLoja]

ALTER TABLE [dbo].[tbParametrosLoja]  WITH CHECK ADD  CONSTRAINT [FK_tbParametrosLoja_tbMoedas] FOREIGN KEY([IDMoedaDefeito])
REFERENCES [dbo].[tbMoedas] ([ID])

ALTER TABLE [dbo].[tbParametrosLoja] CHECK CONSTRAINT [FK_tbParametrosLoja_tbMoedas]

ALTER TABLE [dbo].[tbParametrosLoja]  WITH CHECK ADD  CONSTRAINT [FK_tbParametrosLoja_tbSistemaSiglasPaises] FOREIGN KEY([IDPais])
REFERENCES [dbo].[tbSistemaSiglasPaises] ([ID])

ALTER TABLE [dbo].[tbParametrosLoja] CHECK CONSTRAINT [FK_tbParametrosLoja_tbSistemaSiglasPaises]

create table tbTiposRetencao (ID bigint  identity(1,1) , constraint PK_tbTiposRetencao primary Key (ID), Codigo nvarchar (10) not null,Descricao nvarchar (50) not null,Percentagem float not null constraint DF_tbTiposRetencao_Percentagem default 0,Contabilidade nvarchar (20) null,Ativo bit not null constraint DF_tbTiposRetencao_Ativo default 1,Sistema bit not null constraint DF_tbTiposRetencao_Sistema default 0,DataCriacao datetime not null constraint DF_tbTiposRetencao_DataCriacao default getdate(),UtilizadorCriacao nvarchar (256) not null constraint DF_tbTiposRetencao_UtilizadorCriacao default '',DataAlteracao datetime null constraint DF_tbTiposRetencao_DataAlteracao default getdate(),UtilizadorAlteracao nvarchar (256) null constraint DF_tbTiposRetencao_UtilizadorAlteracao default '',F3MMarcador timestamp null ) 
create unique index IX_tbTiposRetencao_Codigo on tbTiposRetencao (Codigo) 
create table tbMarcas (ID bigint  identity(1,1) , constraint PK_tbMarcas primary Key (ID), Codigo nvarchar (10) not null,Descricao nvarchar (50) not null,VariavelContabilidade nvarchar (20) null, AtualizaPrecos bit null, Ativo bit not null constraint DF_tbMarcas_Ativo default 1,Sistema bit not null constraint DF_tbMarcas_Sistema default 0,DataCriacao datetime not null constraint DF_tbMarcas_DataCriacao default getdate(),UtilizadorCriacao nvarchar (256) not null constraint DF_tbMarcas_UtilizadorCriacao default '',DataAlteracao datetime null constraint DF_tbMarcas_DataAlteracao default getdate(),UtilizadorAlteracao nvarchar (256) null constraint DF_tbMarcas_UtilizadorAlteracao default '',F3MMarcador timestamp null ) 
create unique index IX_tbMarcas_Codigo on tbMarcas (Codigo) 
create table tbProfissoes (ID bigint  identity(1,1) , constraint PK_tbProfissoes primary Key (ID), Codigo nvarchar (10) not null,Descricao nvarchar (50) not null,Ativo bit not null constraint DF_tbProfissoes_Ativo default 1,Sistema bit not null constraint DF_tbProfissoes_Sistema default 0,DataCriacao datetime not null constraint DF_tbProfissoes_DataCriacao default getdate(),UtilizadorCriacao nvarchar (256) not null constraint DF_tbProfissoes_UtilizadorCriacao default '',DataAlteracao datetime null constraint DF_tbProfissoes_DataAlteracao default getdate(),UtilizadorAlteracao nvarchar (256) null constraint DF_tbProfissoes_UtilizadorAlteracao default '',F3MMarcador timestamp null ) 
create unique index IX_tbProfissoes_Codigo on tbProfissoes (Codigo) 
create table tbIdiomas (ID bigint  identity(1,1) , constraint PK_tbIdiomas primary Key (ID), Codigo nvarchar (10) not null, IDCultura bigint not null,Descricao nvarchar (40) not null,Ativo bit not null constraint DF_tbIdiomas_Ativo default 1,Sistema bit not null constraint DF_tbIdiomas_Sistema default 0,DataCriacao datetime not null constraint DF_tbIdiomas_DataCriacao default getdate(),UtilizadorCriacao nvarchar (256) not null constraint DF_tbIdiomas_UtilizadorCriacao default '',DataAlteracao datetime null constraint DF_tbIdiomas_DataAlteracao default getdate(),UtilizadorAlteracao nvarchar (256) null constraint DF_tbIdiomas_UtilizadorAlteracao default '',F3MMarcador timestamp null ) 
create unique index IX_tbIdiomas_Codigo on tbIdiomas (Codigo) 
create table tbTiposArtigos (ID bigint  identity(1,1) , constraint PK_tbTiposArtigos primary Key (ID), IDSistemaClassificacao bigint not null,IDSistemaClassificacaoGeral bigint not null,Codigo nvarchar (10) not null,Descricao nvarchar (50) not null,VariavelContabilidade nvarchar (20) null,Ativo bit not null constraint DF_tbTiposArtigos_Ativo default 1,Sistema bit not null constraint DF_tbTiposArtigos_Sistema default 0,DataCriacao datetime not null constraint DF_tbTiposArtigos_DataCriacao default getdate(),UtilizadorCriacao nvarchar (256) not null constraint DF_tbTiposArtigos_UtilizadorCriacao default '',DataAlteracao datetime null constraint DF_tbTiposArtigos_DataAlteracao default getdate(),UtilizadorAlteracao nvarchar (256) null constraint DF_tbTiposArtigos_UtilizadorAlteracao default '',F3MMarcador timestamp null, [StkUnidade1] [bit] NOT NULL CONSTRAINT [DF_tbTiposArtigos_Unidade1]  DEFAULT ((0)), [StkUnidade2] [bit] NOT NULL CONSTRAINT [DF_tbTiposArtigos_StkUnidade2]  DEFAULT ((0))) 
alter table tbTiposArtigos add constraint FK_tbTiposArtigos_tbSistemaClassificacoesTiposArtigos foreign key (IDSistemaClassificacao) references tbSistemaClassificacoesTiposArtigos (ID)
alter table tbTiposArtigos add constraint FK_tbTiposArtigos_tbSistemaClassificacoesTiposArtigosGeral foreign key (IDSistemaClassificacaoGeral) references tbSistemaClassificacoesTiposArtigosGeral (ID)
create unique index IX_tbTiposArtigos_Codigo on tbTiposArtigos (Codigo) 
create table tbFormasPagamento (ID bigint  identity(1,1) , constraint PK_tbFormasPagamento primary Key (ID), Codigo nvarchar (10) not null,Descricao nvarchar (50) not null,IDTipoFormaPagamento bigint not null,Ativo bit not null constraint DF_tbFormasPagamento_Ativo default 1,Sistema bit not null constraint DF_tbFormasPagamento_Sistema default 0,DataCriacao datetime not null constraint DF_tbFormasPagamento_DataCriacao default getdate(),UtilizadorCriacao nvarchar (256) not null constraint DF_tbFormasPagamento_UtilizadorCriacao default '',DataAlteracao datetime null constraint DF_tbFormasPagamento_DataAlteracao default getdate(),UtilizadorAlteracao nvarchar (256) null constraint DF_tbFormasPagamento_UtilizadorAlteracao default '',F3MMarcador timestamp null ) 
alter table tbFormasPagamento add constraint FK_tbFormasPagamento_tbSistemaTiposFormasPagamento foreign key (IDTipoFormaPagamento) references tbSistemaTiposFormasPagamento (ID)
create unique index IX_tbFormasPagamento_Codigo on tbFormasPagamento (Codigo) 
create table tbFormasPagamentoIdiomas (ID bigint  identity(1,1) , constraint PK_tbFormasPagamentoIdiomas primary Key (ID), IDFormaPagamento bigint not null,IDIdioma bigint not null,Descricao nvarchar (50) not null,Ordem int not null,Ativo bit not null constraint DF_tbFormasPagamentoIdiomas_Ativo default 1,Sistema bit not null constraint DF_tbFormasPagamentoIdiomas_Sistema default 0,DataCriacao datetime not null constraint DF_tbFormasPagamentoIdiomas_DataCriacao default getdate(),UtilizadorCriacao nvarchar (256) not null constraint DF_tbFormasPagamentoIdiomas_UtilizadorCriacao default '',DataAlteracao datetime null constraint DF_tbFormasPagamentoIdiomas_DataAlteracao default getdate(),UtilizadorAlteracao nvarchar (256) null constraint DF_tbFormasPagamentoIdiomas_UtilizadorAlteracao default '',F3MMarcador timestamp null ) 
alter table tbFormasPagamentoIdiomas add constraint FK_tbFormasPagamentoIdiomas_tbFormasPagamento foreign key (IDFormaPagamento) references tbFormasPagamento (ID)
alter table tbFormasPagamentoIdiomas add constraint FK_tbFormasPagamentoIdiomas_tbIdiomas foreign key (IDIdioma) references tbIdiomas (ID)
create table tbFormasExpedicao (ID bigint  identity(1,1) , constraint PK_tbFormasExpedicao primary Key (ID), Codigo nvarchar (10) not null,Descricao nvarchar (50) not null,Ativo bit not null constraint DF_tbFormasExpedicao_Ativo default 1,Sistema bit not null constraint DF_tbFormasExpedicao_Sistema default 0,DataCriacao datetime not null constraint DF_tbFormasExpedicao_DataCriacao default getdate(),UtilizadorCriacao nvarchar (256) not null constraint DF_tbFormasExpedicao_UtilizadorCriacao default '',DataAlteracao datetime null constraint DF_tbFormasExpedicao_DataAlteracao default getdate(),UtilizadorAlteracao nvarchar (256) null constraint DF_tbFormasExpedicao_UtilizadorAlteracao default '',F3MMarcador timestamp null ) 
create unique index IX_tbFormasExpedicao_Codigo on tbFormasExpedicao (Codigo) 
create table tbFormasExpedicaoIdiomas (ID bigint  identity(1,1) , constraint PK_tbFormasExpedicaoIdiomas primary Key (ID), IDFormaExpedicao bigint not null,IDIdioma bigint not null,Descricao nvarchar (50) not null,Ordem int not null,Ativo bit not null constraint DF_tbFormasExpedicaoIdiomas_Ativo default 1,Sistema bit not null constraint DF_tbFormasExpedicaoIdiomas_Sistema default 0,DataCriacao datetime not null constraint DF_tbFormasExpedicaoIdiomas_DataCriacao default getdate(),UtilizadorCriacao nvarchar (256) not null constraint DF_tbFormasExpedicaoIdiomas_UtilizadorCriacao default '',DataAlteracao datetime null constraint DF_tbFormasExpedicaoIdiomas_DataAlteracao default getdate(),UtilizadorAlteracao nvarchar (256) null constraint DF_tbFormasExpedicaoIdiomas_UtilizadorAlteracao default '',F3MMarcador timestamp null ) 
alter table tbFormasExpedicaoIdiomas add constraint FK_tbFormasExpedicaoIdiomas_tbFormasExpedicao foreign key (IDFormaExpedicao) references tbFormasExpedicao (ID)
alter table tbFormasExpedicaoIdiomas add constraint FK_tbFormasExpedicaoIdiomas_tbIdiomas foreign key (IDIdioma) references tbIdiomas (ID)
create table tbArmazens (ID bigint  identity(1,1) , constraint PK_tbArmazens primary Key (ID), IDLoja bigint null,Codigo nvarchar (10) not null,Descricao nvarchar (50) not null,Rua nvarchar (255) null,NumPolicia nvarchar (100) null,IDCodigoPostal bigint null,IDConcelho bigint null,IDDistrito bigint null,Ativo bit not null constraint DF_tbArmazens_Ativo default 1,Sistema bit not null constraint DF_tbArmazens_Sistema default 0,DataCriacao datetime not null constraint DF_tbArmazens_DataCriacao default getdate(),UtilizadorCriacao nvarchar (256) not null constraint DF_tbArmazens_UtilizadorCriacao default '',DataAlteracao datetime null constraint DF_tbArmazens_DataAlteracao default getdate(),UtilizadorAlteracao nvarchar (256) null constraint DF_tbArmazens_UtilizadorAlteracao default '',F3MMarcador timestamp null ) 
alter table tbArmazens add constraint FK_tbArmazens_tbLojas foreign key (IDLoja) references tbLojas (ID)
alter table tbArmazens add constraint FK_tbArmazens_tbCodigosPostais foreign key (IDCodigoPostal) references tbCodigosPostais (ID)
alter table tbArmazens add constraint FK_tbArmazens_tbConcelhos foreign key (IDConcelho) references tbConcelhos (ID)
alter table tbArmazens add constraint FK_tbArmazens_tbDistritos foreign key (IDDistrito) references tbDistritos (ID)
create unique index IX_tbArmazens_Codigo on tbArmazens (Codigo) 
create table tbArmazensLocalizacoes (ID bigint  identity(1,1) , constraint PK_tbArmazensLocalizacoes primary Key (ID), IDArmazem bigint not null,Codigo nvarchar (50) not null,Descricao nvarchar (100) not null,CodigoBarras nvarchar (125) null,Ordem int null,Ativo bit not null constraint DF_tbArmazensLocalizacoes_Ativo default 1,Sistema bit not null constraint DF_tbArmazensLocalizacoes_Sistema default 0,DataCriacao datetime not null constraint DF_tbArmazensLocalizacoes_DataCriacao default getdate(),UtilizadorCriacao nvarchar (256) not null constraint DF_tbArmazensLocalizacoes_UtilizadorCriacao default '',DataAlteracao datetime null constraint DF_tbArmazensLocalizacoes_DataAlteracao default getdate(),UtilizadorAlteracao nvarchar (256) null constraint DF_tbArmazensLocalizacoes_UtilizadorAlteracao default '',F3MMarcador timestamp null ) 
alter table tbArmazensLocalizacoes add constraint FK_tbArmazensLocalizacoes_tbArmazens foreign key (IDArmazem) references tbArmazens (ID)
create unique index IX_tbArmazensLocalizacoes_Codigo on tbArmazensLocalizacoes (Codigo) 
create table tbCondicoesPagamento (ID bigint  identity(1,1) , constraint PK_tbCondicoesPagamento primary Key (ID), IDTipoCondDataVencimento bigint not null,Codigo nvarchar (10) not null,Descricao nvarchar (50) not null,DescontosIncluiIva bit not null constraint DF_tbCondicoesPagamento_DescontosIncluiIva default 0,ValorCondicao int null,Prazo int null,Ativo bit not null constraint DF_tbCondicoesPagamento_Ativo default 1,Sistema bit not null constraint DF_tbCondicoesPagamento_Sistema default 0,DataCriacao datetime not null constraint DF_tbCondicoesPagamento_DataCriacao default getdate(),UtilizadorCriacao nvarchar (256) not null constraint DF_tbCondicoesPagamento_UtilizadorCriacao default '',DataAlteracao datetime null constraint DF_tbCondicoesPagamento_DataAlteracao default getdate(),UtilizadorAlteracao nvarchar (256) null constraint DF_tbCondicoesPagamento_UtilizadorAlteracao default '',F3MMarcador timestamp null,Importado bit not null constraint DF_tbCondicoesPagamento_Importado default 0 ) 
alter table tbCondicoesPagamento add constraint FK_tbCondicoesPagamento_tbSistemaTiposCondDataVencimento foreign key (IDTipoCondDataVencimento) references tbSistemaTiposCondDataVencimento (ID)
create unique index IX_tbCondicoesPagamento_Codigo on tbCondicoesPagamento (Codigo) 
create table tbCondicoesPagamentoIdiomas (ID bigint  identity(1,1) , constraint PK_tbCondicoesPagamentoIdiomas primary Key (ID), IDCondicaoPagamento bigint not null,IDIdioma bigint not null,Descricao nvarchar (50) not null,Ordem int not null,Ativo bit not null constraint DF_tbCondicoesPagamentoIdiomas_Ativo default 1,Sistema bit not null constraint DF_tbCondicoesPagamentoIdiomas_Sistema default 0,DataCriacao datetime not null constraint DF_tbCondicoesPagamentoIdiomas_DataCriacao default getdate(),UtilizadorCriacao nvarchar (256) not null constraint DF_tbCondicoesPagamentoIdiomas_UtilizadorCriacao default '',DataAlteracao datetime null constraint DF_tbCondicoesPagamentoIdiomas_DataAlteracao default getdate(),UtilizadorAlteracao nvarchar (256) null constraint DF_tbCondicoesPagamentoIdiomas_UtilizadorAlteracao default '',F3MMarcador timestamp null,Importado bit not null constraint DF_tbCondicoesPagamentoIdiomas_Importado default 0 ) 
alter table tbCondicoesPagamentoIdiomas add constraint FK_tbCondicoesPagamentoIdiomas_tbCondicoesPagamento foreign key (IDCondicaoPagamento) references tbCondicoesPagamento (ID)
alter table tbCondicoesPagamentoIdiomas add constraint FK_tbCondicoesPagamentoIdiomas_tbIdiomas foreign key (IDIdioma) references tbIdiomas (ID)
create table tbCondicoesPagamentoDescontos (ID bigint  identity(1,1) , constraint PK_tbCondicoesPagamentoDescontos primary Key (ID), IDCondicaoPagamento bigint not null,IDTipoEntidade bigint not null,AteXDiasAposEmissao int not null,Desconto float not null constraint DF_tbCondicoesPagamentoDescontos_Desconto default 0,Ordem int not null,Ativo bit not null constraint DF_tbCondicoesPagamentoDescontos_Ativo default 1,Sistema bit not null constraint DF_tbCondicoesPagamentoDescontos_Sistema default 0,DataCriacao datetime not null constraint DF_tbCondicoesPagamentoDescontos_DataCriacao default getdate(),UtilizadorCriacao nvarchar (256) not null constraint DF_tbCondicoesPagamentoDescontos_UtilizadorCriacao default '',DataAlteracao datetime null constraint DF_tbCondicoesPagamentoDescontos_DataAlteracao default getdate(),UtilizadorAlteracao nvarchar (256) null constraint DF_tbCondicoesPagamentoDescontos_UtilizadorAlteracao default '',F3MMarcador timestamp null,Importado bit not null constraint DF_tbCondicoesPagamentoDescontos_Importado default 0 ) 
alter table tbCondicoesPagamentoDescontos add constraint FK_tbCondicoesPagamentoDescontos_tbCondicoesPagamento foreign key (IDCondicaoPagamento) references tbCondicoesPagamento (ID)
alter table tbCondicoesPagamentoDescontos add constraint FK_tbCondicoesPagamentoDescontos_tbSistemaTiposEntidade foreign key (IDTipoEntidade) references tbSistemaTiposEntidade (ID)


/****** Object:  Table [dbo].[tbFornecedores]    Script Date: 31-05-2016 12:17:22 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbFornecedores](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDLoja] bigint null,
	[Codigo] [nvarchar](20) NOT NULL,
	[Nome] [nvarchar](200) NOT NULL,
	[Foto] [nvarchar](255) NULL,
	[FotoCaminho] [nvarchar](max) NULL,
	[DataValidade] [date] NULL,
	[DataNascimento] [date] NULL,
	[IDTipoEntidade] [bigint] NOT NULL,
	[Apelido] [nvarchar](50) NULL,
	[Abreviatura] [nvarchar](50) NULL,
	[CartaoCidadao] [nvarchar](25) NULL,
	[TituloAcademico] [nvarchar](50) NULL,
	[IDProfissao] [bigint] NULL,
	[IDMoeda] [bigint] NOT NULL,
	[IDFormaPagamento] [bigint] NOT NULL,
	[IDCondicaoPagamento] [bigint] NOT NULL,
	[IDTipoPessoa] [bigint] NULL,
	[IDEspacoFiscal] [bigint] NOT NULL,
	[IDRegimeIva] [bigint] NOT NULL,
	[IDLocalOperacao] [bigint] NULL,
	[IDPais] [bigint] NULL,
	[IDIdioma] [bigint] NULL,
	[IDSexo] [bigint] NULL,
	[Contabilidade] [nvarchar](20) NULL,
	[CodIQ] [nvarchar](10) NULL,
	[NIB] [nvarchar](30) NULL,
	[IDFornecimento] [bigint] NOT NULL,
	[RegimeEspecial] [bit] NOT NULL CONSTRAINT [DF_tbFornecedores_RegimeEspecial]  DEFAULT ((0)),
	[EfetuaRetencao] [bit] NOT NULL CONSTRAINT [DF_tbFornecedores_EfetuaRetencao]  DEFAULT ((0)),
	[IvaCaixa] [bit] NOT NULL CONSTRAINT [DF_tbFornecedores_IvaCaixa]  DEFAULT ((0)),
	[Observacoes] [nvarchar](max) NULL,
	[Avisos] [nvarchar](max) NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbFornecedores_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbFornecedores_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbFornecedores_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
	[Desconto1] [float] NOT NULL,
	[Desconto2] [float] NOT NULL,
	[NContribuinte] [nvarchar](25) NULL,
 CONSTRAINT [PK_tbFornecedores] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


/****** Object:  Table [dbo].[tbFornecedoresAnexos]    Script Date: 31-05-2016 12:17:22 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbFornecedoresAnexos](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDFornecedor] [bigint] NOT NULL,
	[IDTipoAnexo] [bigint] NULL,
	[Descricao] [nvarchar](255) NULL,
	[FicheiroOriginal] [nvarchar](255) NULL,
	[Ficheiro] [nvarchar](255) NOT NULL,
	[FicheiroThumbnail] [nvarchar](300) NULL,
	[Caminho] [nvarchar](max) NOT NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbFornecedoresAnexos_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbFornecedoresAnexos_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbFornecedoresAnexos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_tbFornecedoresAnexos] UNIQUE NONCLUSTERED 
(
	[IDFornecedor] ASC,
	[Ficheiro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


/****** Object:  Table [dbo].[tbFornecedoresContatos]    Script Date: 31-05-2016 12:17:22 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbFornecedoresContatos](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Ordem] [int] NOT NULL,
	[IDTipo] [bigint] NULL,
	[Contato] [nvarchar](50) NULL,
	[Telefone] [nvarchar](25) NULL,
	[Telemovel] [nvarchar](25) NULL,
	[IDFornecedor] [bigint] NOT NULL,
	[Fax] [nvarchar](25) NULL,
	[Email] [nvarchar](255) NULL,
	[Mailing] [bit] NOT NULL CONSTRAINT [DF_tbFornecedoresContatos_Mailing]  DEFAULT ((1)),
	[PagWeb] [nvarchar](255) NULL,
	[PagRedeSocial] [nvarchar](255) NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbFornecedoresContatos_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbFornecedoresContatos_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbFornecedoresContatos_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbFornecedoresContatos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbFornecedoresMoradas]    Script Date: 31-05-2016 12:17:22 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbFornecedoresMoradas](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Descricao] [nvarchar](50) NULL,
	[Rota] [nvarchar](255) NULL,
	[Rua] [nvarchar](255) NULL,
	[NumPolicia] [nvarchar](100) NULL,
	[IDFornecedor] [bigint] NOT NULL,
	[IDCodigoPostal] [bigint] NULL,
	[IDConcelho] [bigint] NULL,
	[IDDistrito] [bigint] NULL,
	[IDPais] [bigint] NULL,
	[GPS] [nvarchar](100) NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbFornecedoresMoradas_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbFornecedoresMoradas_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbFornecedoresMoradas_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
	[OrdemMorada] [int] NOT NULL,
	[Ordem] [int] NOT NULL,
 CONSTRAINT [PK_tbFornecedoresMoradas] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbFornecedoresTiposFornecimentos]    Script Date: 31-05-2016 12:17:22 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbFornecedoresTiposFornecimentos](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDTipoFornecimento] [bigint] NOT NULL,
	[IDFornecedor] [bigint] NOT NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbFornecedoresTiposFornecimentos_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbFornecedoresTiposFornecimentos_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbFornecedoresTiposFornecimentos_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
	[Ordem] [int] NOT NULL,
 CONSTRAINT [PK_tbFornecedoresTiposFornecimentos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

/****** Object:  Table [dbo].[tbTiposFornecimentos]    Script Date: 03-06-2016 09:11:38 ******/
SET ANSI_NULLS ON


SET QUOTED_IDENTIFIER ON


CREATE TABLE [dbo].[tbTiposFornecimentos](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbTiposFornecimentos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]



ALTER TABLE [dbo].[tbTiposFornecimentos] ADD  CONSTRAINT [DF_tbTiposFornecimentos_Sistema]  DEFAULT ((0)) FOR [Sistema]


ALTER TABLE [dbo].[tbTiposFornecimentos] ADD  CONSTRAINT [DF_tbTiposFornecimentos_Ativo]  DEFAULT ((1)) FOR [Ativo]


ALTER TABLE [dbo].[tbTiposFornecimentos] ADD  CONSTRAINT [DF_tbTiposFornecimentos_DataAlteracao]  DEFAULT (getdate()) FOR [DataAlteracao]


/****** Object:  Index [IX_tbFornecedoresCodigo]    Script Date: 31-05-2016 12:17:22 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_tbFornecedoresCodigo] ON [dbo].[tbFornecedores]
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

SET ANSI_PADDING ON


/****** Object:  Index [IX_tbTiposFornecimentos]    Script Date: 31-05-2016 12:17:22 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_tbTiposFornecimentos] ON [dbo].[tbTiposFornecimentos]
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

ALTER TABLE [dbo].[tbFornecedores]  WITH CHECK ADD  CONSTRAINT [FK_tbFornecedores_tbCondicoesPagamento] FOREIGN KEY([IDCondicaoPagamento])
REFERENCES [dbo].[tbCondicoesPagamento] ([ID])

ALTER TABLE [dbo].[tbFornecedores] CHECK CONSTRAINT [FK_tbFornecedores_tbCondicoesPagamento]

ALTER TABLE [dbo].[tbFornecedores]  WITH CHECK ADD  CONSTRAINT [FK_tbFornecedores_tbFormasPagamento] FOREIGN KEY([IDFormaPagamento])
REFERENCES [dbo].[tbFormasPagamento] ([ID])

ALTER TABLE [dbo].[tbFornecedores] CHECK CONSTRAINT [FK_tbFornecedores_tbFormasPagamento]

ALTER TABLE [dbo].[tbFornecedores]  WITH CHECK ADD  CONSTRAINT [FK_tbFornecedores_tbIdiomas] FOREIGN KEY([IDIdioma])
REFERENCES [dbo].[tbIdiomas] ([ID])

ALTER TABLE [dbo].[tbFornecedores] CHECK CONSTRAINT [FK_tbFornecedores_tbIdiomas]

ALTER TABLE [dbo].[tbFornecedores]  WITH CHECK ADD  CONSTRAINT [FK_tbFornecedores_tbMoedas] FOREIGN KEY([IDMoeda])
REFERENCES [dbo].[tbMoedas] ([ID])

ALTER TABLE [dbo].[tbFornecedores] CHECK CONSTRAINT [FK_tbFornecedores_tbMoedas]

ALTER TABLE [dbo].[tbFornecedores]  WITH CHECK ADD  CONSTRAINT [FK_tbFornecedores_tbPaises] FOREIGN KEY([IDPais])
REFERENCES [dbo].[tbPaises] ([ID])

ALTER TABLE [dbo].[tbFornecedores] CHECK CONSTRAINT [FK_tbFornecedores_tbPaises]

ALTER TABLE [dbo].[tbFornecedores]  WITH CHECK ADD  CONSTRAINT [FK_tbFornecedores_tbProfissoes] FOREIGN KEY([IDProfissao])
REFERENCES [dbo].[tbProfissoes] ([ID])

ALTER TABLE [dbo].[tbFornecedores] CHECK CONSTRAINT [FK_tbFornecedores_tbProfissoes]

ALTER TABLE [dbo].[tbFornecedores]  WITH CHECK ADD  CONSTRAINT [FK_tbFornecedores_tbSistemaEspacoFiscal] FOREIGN KEY([IDEspacoFiscal])
REFERENCES [dbo].[tbSistemaEspacoFiscal] ([ID])

ALTER TABLE [dbo].[tbFornecedores] CHECK CONSTRAINT [FK_tbFornecedores_tbSistemaEspacoFiscal]

ALTER TABLE [dbo].[tbFornecedores]  WITH CHECK ADD  CONSTRAINT [FK_tbFornecedores_tbSistemaRegimeIVA] FOREIGN KEY([IDRegimeIva])
REFERENCES [dbo].[tbSistemaRegimeIVA] ([ID])

ALTER TABLE [dbo].[tbFornecedores] CHECK CONSTRAINT [FK_tbFornecedores_tbSistemaRegimeIVA]

ALTER TABLE [dbo].[tbFornecedores]  WITH CHECK ADD  CONSTRAINT [FK_tbFornecedores_tbSistemaRegioesIVA] FOREIGN KEY([IDLocalOperacao])
REFERENCES [dbo].[tbSistemaRegioesIVA] ([ID])

ALTER TABLE [dbo].[tbFornecedores] CHECK CONSTRAINT [FK_tbFornecedores_tbSistemaRegioesIVA]

ALTER TABLE [dbo].[tbFornecedores]  WITH CHECK ADD  CONSTRAINT [FK_tbFornecedores_tbSistemaSexo] FOREIGN KEY([IDSexo])
REFERENCES [dbo].[tbSistemaSexo] ([ID])

ALTER TABLE [dbo].[tbFornecedores] CHECK CONSTRAINT [FK_tbFornecedores_tbSistemaSexo]

ALTER TABLE [dbo].[tbFornecedores]  WITH CHECK ADD  CONSTRAINT [FK_tbFornecedores_tbSistemaTiposEntidade] FOREIGN KEY([IDTipoEntidade])
REFERENCES [dbo].[tbSistemaTiposEntidade] ([ID])

ALTER TABLE [dbo].[tbFornecedores] CHECK CONSTRAINT [FK_tbFornecedores_tbSistemaTiposEntidade]

ALTER TABLE [dbo].[tbFornecedores]  WITH CHECK ADD  CONSTRAINT [FK_tbFornecedores_tbSistemaTiposPessoa] FOREIGN KEY([IDTipoPessoa])
REFERENCES [dbo].[tbSistemaTiposPessoa] ([ID])

ALTER TABLE [dbo].[tbFornecedores] CHECK CONSTRAINT [FK_tbFornecedores_tbSistemaTiposPessoa]

ALTER TABLE [dbo].[tbFornecedoresAnexos]  WITH CHECK ADD  CONSTRAINT [FK_tbFornecedoresAnexos_tbFornecedores] FOREIGN KEY([IDFornecedor])
REFERENCES [dbo].[tbFornecedores] ([ID])

ALTER TABLE [dbo].[tbFornecedoresAnexos] CHECK CONSTRAINT [FK_tbFornecedoresAnexos_tbFornecedores]

ALTER TABLE [dbo].[tbFornecedoresAnexos]  WITH CHECK ADD  CONSTRAINT [FK_tbFornecedoresAnexos_tbSistemaTiposAnexos] FOREIGN KEY([IDTipoAnexo])
REFERENCES [dbo].[tbSistemaTiposAnexos] ([ID])

ALTER TABLE [dbo].[tbFornecedoresAnexos] CHECK CONSTRAINT [FK_tbFornecedoresAnexos_tbSistemaTiposAnexos]

ALTER TABLE [dbo].[tbFornecedoresContatos]  WITH CHECK ADD  CONSTRAINT [FK_tbFornecedoresContatos_tbFornecedores] FOREIGN KEY([IDFornecedor])
REFERENCES [dbo].[tbFornecedores] ([ID])

ALTER TABLE [dbo].[tbFornecedoresContatos] CHECK CONSTRAINT [FK_tbFornecedoresContatos_tbFornecedores]

ALTER TABLE [dbo].[tbFornecedoresContatos]  WITH CHECK ADD  CONSTRAINT [FK_tbFornecedoresContatos_tbTiposContatos] FOREIGN KEY([IDTipo])
REFERENCES [dbo].[tbTiposContatos] ([ID])

ALTER TABLE [dbo].[tbFornecedoresContatos] CHECK CONSTRAINT [FK_tbFornecedoresContatos_tbTiposContatos]

ALTER TABLE [dbo].[tbFornecedoresMoradas]  WITH CHECK ADD  CONSTRAINT [FK_tbFornecedoresMoradas_tbCodigosPostais] FOREIGN KEY([IDCodigoPostal])
REFERENCES [dbo].[tbCodigosPostais] ([ID])

ALTER TABLE [dbo].[tbFornecedoresMoradas] CHECK CONSTRAINT [FK_tbFornecedoresMoradas_tbCodigosPostais]

ALTER TABLE [dbo].[tbFornecedoresMoradas]  WITH CHECK ADD  CONSTRAINT [FK_tbFornecedoresMoradas_tbConcelhos] FOREIGN KEY([IDConcelho])
REFERENCES [dbo].[tbConcelhos] ([ID])

ALTER TABLE [dbo].[tbFornecedoresMoradas] CHECK CONSTRAINT [FK_tbFornecedoresMoradas_tbConcelhos]

ALTER TABLE [dbo].[tbFornecedoresMoradas]  WITH CHECK ADD  CONSTRAINT [FK_tbFornecedoresMoradas_tbDistritos] FOREIGN KEY([IDDistrito])
REFERENCES [dbo].[tbDistritos] ([ID])

ALTER TABLE [dbo].[tbFornecedoresMoradas] CHECK CONSTRAINT [FK_tbFornecedoresMoradas_tbDistritos]

ALTER TABLE [dbo].[tbFornecedoresMoradas]  WITH CHECK ADD  CONSTRAINT [FK_tbFornecedoresMoradas_tbFornecedores] FOREIGN KEY([IDFornecedor])
REFERENCES [dbo].[tbFornecedores] ([ID])

ALTER TABLE [dbo].[tbFornecedoresMoradas] CHECK CONSTRAINT [FK_tbFornecedoresMoradas_tbFornecedores]

ALTER TABLE [dbo].[tbFornecedoresMoradas]  WITH CHECK ADD  CONSTRAINT [FK_tbFornecedoresMoradas_tbPaises] FOREIGN KEY([IDPais])
REFERENCES [dbo].[tbPaises] ([ID])

ALTER TABLE [dbo].[tbFornecedoresMoradas] CHECK CONSTRAINT [FK_tbFornecedoresMoradas_tbPaises]

ALTER TABLE [dbo].[tbFornecedoresTiposFornecimentos]  WITH CHECK ADD  CONSTRAINT [FK_tbFornecedoresTiposFornecimentos_tbFornecedores] FOREIGN KEY([IDFornecedor])
REFERENCES [dbo].[tbFornecedores] ([ID])

ALTER TABLE [dbo].[tbFornecedoresTiposFornecimentos] CHECK CONSTRAINT [FK_tbFornecedoresTiposFornecimentos_tbFornecedores]

ALTER TABLE [dbo].[tbFornecedoresTiposFornecimentos]  WITH CHECK ADD  CONSTRAINT [FK_tbFornecedoresTiposFornecimentos_tbTiposFornecimentos] FOREIGN KEY([IDTipoFornecimento])
REFERENCES [dbo].[tbTiposFornecimentos] ([ID])

ALTER TABLE [dbo].[tbFornecedoresTiposFornecimentos] CHECK CONSTRAINT [FK_tbFornecedoresTiposFornecimentos_tbTiposFornecimentos]

ALTER TABLE [dbo].[tbFornecedores]  WITH CHECK ADD  CONSTRAINT [FK_tbFornecedores_tbLojas] FOREIGN KEY([IDLoja])
REFERENCES [dbo].[tbLojas] ([ID])

ALTER TABLE [dbo].[tbFornecedores] CHECK CONSTRAINT [FK_tbFornecedores_tbLojas]

/****** Object:  Table [dbo].[tbSegmentosMercado]    Script Date: 31-05-2016 14:53:25 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSegmentosMercado](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[VariavelContabilidade] [nvarchar](20) NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbSegmentosMercado_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbSegmentosMercado_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbSegmentosMercado_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_SegmentosMercado] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSegmentosMercadoIdiomas]    Script Date: 31-05-2016 14:53:25 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSegmentosMercadoIdiomas](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDSegmentoMercado] [bigint] NOT NULL,
	[IDIdioma] [bigint] NOT NULL,
	[Descricao] [nvarchar](50) NULL,
	[Ordem] [int] NOT NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbSegmentosMercadoIdiomas_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbSegmentosMercadoIdiomas_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbSegmentosMercadoIdiomas_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbSegmentosMercadoIdiomas] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSetoresAtividade]    Script Date: 31-05-2016 14:53:25 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSetoresAtividade](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[VariavelContabilidade] [nvarchar](20) NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbSetoresAtividade_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbSetoresAtividade_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbSetoresAtividade_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbSetoresAtividade] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbSetoresAtividadeIdiomas]    Script Date: 31-05-2016 14:53:25 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbSetoresAtividadeIdiomas](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDSetorAtividade] [bigint] NOT NULL,
	[IDIdioma] [bigint] NOT NULL,
	[Descricao] [nvarchar](50) NULL,
	[Ordem] [int] NOT NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbSetoresAtividadeIdiomas_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbSetoresAtividadeIdiomas_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbSetoresAtividadeIdiomas_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbSetoresAtividadeIdiomas] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


SET ANSI_PADDING ON


/****** Object:  Index [IX_tbSegmentosMercadoCodigo]    Script Date: 31-05-2016 14:53:25 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_tbSegmentosMercadoCodigo] ON [dbo].[tbSegmentosMercado]
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

SET ANSI_PADDING ON


/****** Object:  Index [IX_tbSetoresAtividadeCodigo]    Script Date: 31-05-2016 14:53:25 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_tbSetoresAtividadeCodigo] ON [dbo].[tbSetoresAtividade]
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

ALTER TABLE [dbo].[tbSegmentosMercadoIdiomas]  WITH CHECK ADD  CONSTRAINT [FK_tbSegmentosMercadoIdiomas_tbIdiomas] FOREIGN KEY([IDIdioma])
REFERENCES [dbo].[tbIdiomas] ([ID])

ALTER TABLE [dbo].[tbSegmentosMercadoIdiomas] CHECK CONSTRAINT [FK_tbSegmentosMercadoIdiomas_tbIdiomas]

ALTER TABLE [dbo].[tbSegmentosMercadoIdiomas]  WITH CHECK ADD  CONSTRAINT [FK_tbSegmentosMercadoIdiomas_tbSegmentosMercado] FOREIGN KEY([IDSegmentoMercado])
REFERENCES [dbo].[tbSegmentosMercado] ([ID])

ALTER TABLE [dbo].[tbSegmentosMercadoIdiomas] CHECK CONSTRAINT [FK_tbSegmentosMercadoIdiomas_tbSegmentosMercado]

ALTER TABLE [dbo].[tbSetoresAtividadeIdiomas]  WITH CHECK ADD  CONSTRAINT [FK_tbSetoresAtividadeIdiomas_tbIdiomas] FOREIGN KEY([IDIdioma])
REFERENCES [dbo].[tbIdiomas] ([ID])

ALTER TABLE [dbo].[tbSetoresAtividadeIdiomas] CHECK CONSTRAINT [FK_tbSetoresAtividadeIdiomas_tbIdiomas]

ALTER TABLE [dbo].[tbSetoresAtividadeIdiomas]  WITH CHECK ADD  CONSTRAINT [FK_tbSetoresAtividadeIdiomas_tbSetoresAtividade] FOREIGN KEY([IDSetorAtividade])
REFERENCES [dbo].[tbSetoresAtividade] ([ID])

ALTER TABLE [dbo].[tbSetoresAtividadeIdiomas] CHECK CONSTRAINT [FK_tbSetoresAtividadeIdiomas_tbSetoresAtividade]




/****** Object:  Table [dbo].[tbClientes]    Script Date: 01-06-2016 00:14:39 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbClientes](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDLoja] bigint null,
	[Codigo] [nvarchar](20) NOT NULL,
	[Nome] [nvarchar](200) NOT NULL,
	[Foto] [nvarchar](255) NULL,
	[FotoCaminho] [nvarchar](max) NULL,
	[DataValidade] [date] NULL,
	[DataNascimento] [date] NULL,
	[IDTipoEntidade] [bigint] NOT NULL,
	[Apelido] [nvarchar](50) NULL,
	[Abreviatura] [nvarchar](50) NULL,
	[CartaoCidadao] [nvarchar](25) NULL,
	[TituloAcademico] [nvarchar](50) NULL,
	[IDProfissao] [bigint] NULL,
	[IDMoeda] [bigint] NOT NULL,
	[IDFormaPagamento] [bigint] NOT NULL,
	[IDCondicaoPagamento] [bigint] NOT NULL,
	[IDSegmentoMercado] [bigint] NULL,
	[IDSetorAtividade] [bigint] NULL,
	[IDPrecoSugerido] [bigint] NOT NULL,
	[IDVendedor] [bigint] NULL,
	[IDFormaExpedicao] [bigint] NULL,
	[IDTipoPessoa] [bigint] NULL,
	[IDEspacoFiscal] [bigint] NOT NULL,
	[IDRegimeIva] [bigint] NOT NULL,
	[IDLocalOperacao] [bigint] NULL,
	[IDPais] [bigint] NOT NULL,
	[IDIdioma] [bigint] NOT NULL,
	[IDSexo] [bigint] NULL,
	[Contabilidade] [nvarchar](20) NULL,
	[Prioridade] [bigint] NOT NULL,
	[IDEmissaoFatura] [bigint] NULL,
	[IDEmissaoPackingList] [bigint] NULL,
	[NIB] [nvarchar](30) NULL,
	[RegimeEspecial] [bit] NOT NULL CONSTRAINT [DF_tbClientes_RegimeEspecial]  DEFAULT ((0)),
	[EfetuaRetencao] [bit] NOT NULL CONSTRAINT [DF_tbClientes_EfetuaRetencao]  DEFAULT ((0)),
	[ControloCredito] [bit] NOT NULL CONSTRAINT [DF_tbClientes_ControloCredito]  DEFAULT ((0)),
	[EmitePedidoLiquidacao] [bit] NOT NULL CONSTRAINT [DF_tbClientes_EmitePedidoLiquidacao]  DEFAULT ((0)),
	[IvaCaixa] [bit] NOT NULL CONSTRAINT [DF_tbClientes_IvaCaixa]  DEFAULT ((0)),
	[Observacoes] [nvarchar](max) NULL,
	[Avisos] [nvarchar](max) NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbClientes_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbClientes_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbClientes_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
	[Desconto1] [float] NOT NULL,
	[Desconto2] [float] NOT NULL,
	[Comissao1] [float] NOT NULL,
	[Comissao2] [float] NOT NULL,
	[Plafond] [float] NULL,
	[NMaximoDiasAtraso] [bigint] NULL,
	[NContribuinte] [nvarchar](25) NOT NULL,
	[IDEntidade1] [bigint] NULL,
	[NumeroBeneficiario1] [nvarchar](50) NULL,
	[IDEntidade2] [bigint] NULL,
	[NumeroBeneficiario2] [nvarchar](50) NULL,
	[IDMedicoTecnico] [bigint] NULL,
 CONSTRAINT [PK_tbClientes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


/****** Object:  Table [dbo].[tbClientesAnexos]    Script Date: 01-06-2016 00:14:39 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbClientesAnexos](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDCliente] [bigint] NOT NULL,
	[IDTipoAnexo] [bigint] NULL,
	[Descricao] [nvarchar](255) NULL,
	[FicheiroOriginal] [nvarchar](255) NULL,
	[Ficheiro] [nvarchar](255) NOT NULL,
	[FicheiroThumbnail] [nvarchar](300) NULL,
	[Caminho] [nvarchar](max) NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbClientesAnexos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_tbClientesAnexos] UNIQUE NONCLUSTERED 
(
	[IDCliente] ASC,
	[Ficheiro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


/****** Object:  Table [dbo].[tbClientesContatos]    Script Date: 01-06-2016 00:14:39 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbClientesContatos](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Ordem] [int] NOT NULL,
	[IDTipo] [bigint] NULL,
	[Contato] [nvarchar](50) NULL,
	[Telefone] [nvarchar](25) NULL,
	[Telemovel] [nvarchar](25) NULL,
	[IDCliente] [bigint] NOT NULL,
	[Fax] [nvarchar](25) NULL,
	[Email] [nvarchar](255) NULL,
	[Mailing] [bit] NOT NULL CONSTRAINT [DF_tbClientesContatos_Mailing]  DEFAULT ((1)),
	[PagWeb] [nvarchar](255) NULL,
	[PagRedeSocial] [nvarchar](255) NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbClientesContatos_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbClientesContatos_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbClientesContatos_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbClientesContatos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbClientesMoradas]    Script Date: 01-06-2016 00:14:39 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbClientesMoradas](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Descricao] [nvarchar](50) NULL,
	[Rota] [nvarchar](255) NULL,
	[Rua] [nvarchar](255) NULL,
	[NumPolicia] [nvarchar](100) NULL,
	[IDCliente] [bigint] NOT NULL,
	[IDCodigoPostal] [bigint] NULL,
	[IDConcelho] [bigint] NULL,
	[IDDistrito] [bigint] NULL,
	[IDPais] [bigint] NULL,
	[GPS] [nvarchar](100) NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbClientesMoradas_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbClientesMoradas_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbClientesMoradas_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
	[OrdemMorada] [int] NOT NULL,
	[Ordem] [int] NOT NULL,
 CONSTRAINT [PK_tbClientesMoradas] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Index [IX_tbClientesCodigo]    Script Date: 01-06-2016 00:14:39 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_tbClientesCodigo] ON [dbo].[tbClientes]
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

SET ANSI_PADDING ON


/****** Object:  Index [IX_tbTiposContatosCodigo]    Script Date: 01-06-2016 00:14:39 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_tbTiposContatosCodigo] ON [dbo].[tbTiposContatos]
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

ALTER TABLE [dbo].[tbClientesAnexos] ADD  CONSTRAINT [DF_tbClientesAnexos_Sistema]  DEFAULT ((0)) FOR [Sistema]

ALTER TABLE [dbo].[tbClientesAnexos] ADD  CONSTRAINT [DF_tbClientesAnexos_Ativo]  DEFAULT ((1)) FOR [Ativo]

ALTER TABLE [dbo].[tbClientes]  WITH CHECK ADD  CONSTRAINT [FK_tbClientes_tbClientes] FOREIGN KEY([ID])
REFERENCES [dbo].[tbClientes] ([ID])

ALTER TABLE [dbo].[tbClientes] CHECK CONSTRAINT [FK_tbClientes_tbClientes]

ALTER TABLE [dbo].[tbClientes]  WITH CHECK ADD  CONSTRAINT [FK_tbClientes_tbCondicoesPagamento] FOREIGN KEY([IDCondicaoPagamento])
REFERENCES [dbo].[tbCondicoesPagamento] ([ID])

ALTER TABLE [dbo].[tbClientes] CHECK CONSTRAINT [FK_tbClientes_tbCondicoesPagamento]

ALTER TABLE [dbo].[tbClientes]  WITH CHECK ADD  CONSTRAINT [FK_tbClientes_tbFormasExpedicao] FOREIGN KEY([IDFormaExpedicao])
REFERENCES [dbo].[tbFormasExpedicao] ([ID])

ALTER TABLE [dbo].[tbClientes] CHECK CONSTRAINT [FK_tbClientes_tbFormasExpedicao]

ALTER TABLE [dbo].[tbClientes]  WITH CHECK ADD  CONSTRAINT [FK_tbClientes_tbFormasPagamento] FOREIGN KEY([IDFormaPagamento])
REFERENCES [dbo].[tbFormasPagamento] ([ID])

ALTER TABLE [dbo].[tbClientes] CHECK CONSTRAINT [FK_tbClientes_tbFormasPagamento]

ALTER TABLE [dbo].[tbClientes]  WITH CHECK ADD  CONSTRAINT [FK_tbClientes_tbIdiomas] FOREIGN KEY([IDIdioma])
REFERENCES [dbo].[tbIdiomas] ([ID])

ALTER TABLE [dbo].[tbClientes] CHECK CONSTRAINT [FK_tbClientes_tbIdiomas]

ALTER TABLE [dbo].[tbClientes]  WITH CHECK ADD  CONSTRAINT [FK_tbClientes_tbMoedas] FOREIGN KEY([IDMoeda])
REFERENCES [dbo].[tbMoedas] ([ID])

ALTER TABLE [dbo].[tbClientes] CHECK CONSTRAINT [FK_tbClientes_tbMoedas]

ALTER TABLE [dbo].[tbClientes]  WITH CHECK ADD  CONSTRAINT [FK_tbClientes_tbPaises] FOREIGN KEY([IDPais])
REFERENCES [dbo].[tbPaises] ([ID])

ALTER TABLE [dbo].[tbClientes] CHECK CONSTRAINT [FK_tbClientes_tbPaises]

ALTER TABLE [dbo].[tbClientes]  WITH CHECK ADD  CONSTRAINT [FK_tbClientes_tbProfissoes] FOREIGN KEY([IDProfissao])
REFERENCES [dbo].[tbProfissoes] ([ID])

ALTER TABLE [dbo].[tbClientes] CHECK CONSTRAINT [FK_tbClientes_tbProfissoes]

ALTER TABLE [dbo].[tbClientes]  WITH CHECK ADD  CONSTRAINT [FK_tbClientes_tbSegmentosMercado] FOREIGN KEY([IDSegmentoMercado])
REFERENCES [dbo].[tbSegmentosMercado] ([ID])

ALTER TABLE [dbo].[tbClientes] CHECK CONSTRAINT [FK_tbClientes_tbSegmentosMercado]

ALTER TABLE [dbo].[tbClientes]  WITH CHECK ADD  CONSTRAINT [FK_tbClientes_tbSetoresAtividade] FOREIGN KEY([IDSetorAtividade])
REFERENCES [dbo].[tbSetoresAtividade] ([ID])

ALTER TABLE [dbo].[tbClientes] CHECK CONSTRAINT [FK_tbClientes_tbSetoresAtividade]

ALTER TABLE [dbo].[tbClientes]  WITH CHECK ADD  CONSTRAINT [FK_tbClientes_tbSistemaCodigosPrecos] FOREIGN KEY([IDPrecoSugerido])
REFERENCES [dbo].[tbSistemaCodigosPrecos] ([ID])

ALTER TABLE [dbo].[tbClientes] CHECK CONSTRAINT [FK_tbClientes_tbSistemaCodigosPrecos]

ALTER TABLE [dbo].[tbClientes]  WITH CHECK ADD  CONSTRAINT [FK_tbClientes_tbSistemaEmissaoFatura] FOREIGN KEY([IDEmissaoFatura])
REFERENCES [dbo].[tbSistemaEmissaoFatura] ([ID])

ALTER TABLE [dbo].[tbClientes] CHECK CONSTRAINT [FK_tbClientes_tbSistemaEmissaoFatura]

ALTER TABLE [dbo].[tbClientes]  WITH CHECK ADD  CONSTRAINT [FK_tbClientes_tbSistemaEmissaoPackingList] FOREIGN KEY([IDEmissaoPackingList])
REFERENCES [dbo].[tbSistemaEmissaoPackingList] ([ID])

ALTER TABLE [dbo].[tbClientes] CHECK CONSTRAINT [FK_tbClientes_tbSistemaEmissaoPackingList]

ALTER TABLE [dbo].[tbClientes]  WITH CHECK ADD  CONSTRAINT [FK_tbClientes_tbSistemaEspacoFiscal] FOREIGN KEY([IDEspacoFiscal])
REFERENCES [dbo].[tbSistemaEspacoFiscal] ([ID])

ALTER TABLE [dbo].[tbClientes] CHECK CONSTRAINT [FK_tbClientes_tbSistemaEspacoFiscal]

ALTER TABLE [dbo].[tbClientes]  WITH CHECK ADD  CONSTRAINT [FK_tbClientes_tbSistemaRegimeIVA] FOREIGN KEY([IDRegimeIva])
REFERENCES [dbo].[tbSistemaRegimeIVA] ([ID])

ALTER TABLE [dbo].[tbClientes] CHECK CONSTRAINT [FK_tbClientes_tbSistemaRegimeIVA]

ALTER TABLE [dbo].[tbClientes]  WITH CHECK ADD  CONSTRAINT [FK_tbClientes_tbSistemaRegioesIVA] FOREIGN KEY([IDLocalOperacao])
REFERENCES [dbo].[tbSistemaRegioesIVA] ([ID])

ALTER TABLE [dbo].[tbClientes] CHECK CONSTRAINT [FK_tbClientes_tbSistemaRegioesIVA]

ALTER TABLE [dbo].[tbClientes]  WITH CHECK ADD  CONSTRAINT [FK_tbClientes_tbSistemaSexo] FOREIGN KEY([IDSexo])
REFERENCES [dbo].[tbSistemaSexo] ([ID])

ALTER TABLE [dbo].[tbClientes] CHECK CONSTRAINT [FK_tbClientes_tbSistemaSexo]

ALTER TABLE [dbo].[tbClientes]  WITH CHECK ADD  CONSTRAINT [FK_tbClientes_tbSistemaTiposEntidade] FOREIGN KEY([IDTipoEntidade])
REFERENCES [dbo].[tbSistemaTiposEntidade] ([ID])

ALTER TABLE [dbo].[tbClientes] CHECK CONSTRAINT [FK_tbClientes_tbSistemaTiposEntidade]

ALTER TABLE [dbo].[tbClientes]  WITH CHECK ADD  CONSTRAINT [FK_tbClientes_tbSistemaTiposPessoa] FOREIGN KEY([IDTipoPessoa])
REFERENCES [dbo].[tbSistemaTiposPessoa] ([ID])

ALTER TABLE [dbo].[tbClientes] CHECK CONSTRAINT [FK_tbClientes_tbSistemaTiposPessoa]

ALTER TABLE [dbo].[tbClientesAnexos]  WITH CHECK ADD  CONSTRAINT [FK_tbClientesAnexos_tbClientes] FOREIGN KEY([IDCliente])
REFERENCES [dbo].[tbClientes] ([ID])

ALTER TABLE [dbo].[tbClientesAnexos] CHECK CONSTRAINT [FK_tbClientesAnexos_tbClientes]

ALTER TABLE [dbo].[tbClientesAnexos]  WITH CHECK ADD  CONSTRAINT [FK_tbClientesAnexos_tbSistemaTiposAnexos] FOREIGN KEY([IDTipoAnexo])
REFERENCES [dbo].[tbSistemaTiposAnexos] ([ID])

ALTER TABLE [dbo].[tbClientesAnexos] CHECK CONSTRAINT [FK_tbClientesAnexos_tbSistemaTiposAnexos]

ALTER TABLE [dbo].[tbClientesContatos]  WITH CHECK ADD  CONSTRAINT [FK_tbClientesContatos_tbClientes] FOREIGN KEY([IDCliente])
REFERENCES [dbo].[tbClientes] ([ID])

ALTER TABLE [dbo].[tbClientesContatos] CHECK CONSTRAINT [FK_tbClientesContatos_tbClientes]

ALTER TABLE [dbo].[tbClientesContatos]  WITH CHECK ADD  CONSTRAINT [FK_tbClientesContatos_tbTiposContatos] FOREIGN KEY([IDTipo])
REFERENCES [dbo].[tbTiposContatos] ([ID])

ALTER TABLE [dbo].[tbClientesContatos] CHECK CONSTRAINT [FK_tbClientesContatos_tbTiposContatos]

ALTER TABLE [dbo].[tbClientesMoradas]  WITH CHECK ADD  CONSTRAINT [FK_tbClientesMoradas_tbClientes] FOREIGN KEY([IDCliente])
REFERENCES [dbo].[tbClientes] ([ID])

ALTER TABLE [dbo].[tbClientesMoradas] CHECK CONSTRAINT [FK_tbClientesMoradas_tbClientes]

ALTER TABLE [dbo].[tbClientesMoradas]  WITH CHECK ADD  CONSTRAINT [FK_tbClientesMoradas_tbCodigosPostais] FOREIGN KEY([IDCodigoPostal])
REFERENCES [dbo].[tbCodigosPostais] ([ID])

ALTER TABLE [dbo].[tbClientesMoradas] CHECK CONSTRAINT [FK_tbClientesMoradas_tbCodigosPostais]

ALTER TABLE [dbo].[tbClientesMoradas]  WITH CHECK ADD  CONSTRAINT [FK_tbClientesMoradas_tbConcelhos] FOREIGN KEY([IDConcelho])
REFERENCES [dbo].[tbConcelhos] ([ID])

ALTER TABLE [dbo].[tbClientesMoradas] CHECK CONSTRAINT [FK_tbClientesMoradas_tbConcelhos]

ALTER TABLE [dbo].[tbClientesMoradas]  WITH CHECK ADD  CONSTRAINT [FK_tbClientesMoradas_tbDistritos] FOREIGN KEY([IDDistrito])
REFERENCES [dbo].[tbDistritos] ([ID])

ALTER TABLE [dbo].[tbClientesMoradas] CHECK CONSTRAINT [FK_tbClientesMoradas_tbDistritos]

ALTER TABLE [dbo].[tbClientesMoradas]  WITH CHECK ADD  CONSTRAINT [FK_tbClientesMoradas_tbPaises] FOREIGN KEY([IDPais])
REFERENCES [dbo].[tbPaises] ([ID])

ALTER TABLE [dbo].[tbClientesMoradas] CHECK CONSTRAINT [FK_tbClientesMoradas_tbPaises]


ALTER TABLE [dbo].[tbClientes]  WITH CHECK ADD  CONSTRAINT [FK_tbClientes_tbEntidades1] FOREIGN KEY([IDEntidade1])
REFERENCES [dbo].[tbEntidades] ([ID])

ALTER TABLE [dbo].[tbClientes] CHECK CONSTRAINT [FK_tbClientes_tbEntidades1] 


ALTER TABLE [dbo].[tbClientes]  WITH CHECK ADD  CONSTRAINT [FK_tbClientes_tbEntidades2] FOREIGN KEY([IDEntidade2])
REFERENCES [dbo].[tbEntidades] ([ID])

ALTER TABLE [dbo].[tbClientes] CHECK CONSTRAINT [FK_tbClientes_tbEntidades2] 


ALTER TABLE [dbo].[tbClientes]  WITH CHECK ADD  CONSTRAINT [FK_tbClientes_tbMedicosTecnicos] FOREIGN KEY([IDMedicoTecnico])
REFERENCES [dbo].[tbMedicosTecnicos] ([ID])

ALTER TABLE [dbo].[tbClientes] CHECK CONSTRAINT [FK_tbClientes_tbMedicosTecnicos]


ALTER TABLE [dbo].[tbClientes]  WITH CHECK ADD  CONSTRAINT [FK_tbClientes_tbLojas] FOREIGN KEY([IDLoja])
REFERENCES [dbo].[tbLojas] ([ID])

ALTER TABLE [dbo].[tbClientes] CHECK CONSTRAINT [FK_tbClientes_tbLojas]


/****** Object:  Table [dbo].[tbTiposDocumento]    Script Date: 01-06-2016 16:38:53 ******/
CREATE TABLE [dbo].[tbTiposDocumento](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[IDModulo] [bigint] NOT NULL,
	[IDSistemaTiposDocumento] [bigint] NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
	[Observacoes] [nvarchar](max) NULL,
	[IDSistemaTiposDocumentoFiscal] [bigint] NULL,
	[GereStock] [bit] NULL,
	[GereContaCorrente] [bit] NULL,
	[GereCaixasBancos] [bit] NULL,
	[RegistarCosumidorFinal] [bit] NULL,
	[AnalisesEstatisticas] [bit] NULL,
	[CalculaComissoes] [bit] NULL,
	[ControlaPlafondEntidade] [bit] NULL,
	[LinhasNegativas] [bit] NULL,
	[AcompanhaBensCirculacao] [bit] NULL,
	[EntregueCliente] [bit] NULL,
	[DocNaoValorizado] [bit] NULL,
	[IDSistemaAcoes] [bigint] NULL,
	[IDSistemaTiposLiquidacao] [bigint] NULL,
	[CalculaNecessidades] [bit] NULL,
	[CustoMedio] [bit] NULL,
	[UltimoPrecoCusto] [bit] NULL,
	[DataPrimeiraEntrada] [bit] NULL,
	[DataUltimaEntrada] [bit] NULL,
	[DataPrimeiraSaida] [bit] NULL,
	[DataUltimaSaida] [bit] NULL,
	[IDSistemaAcoesRupturaStock] [bigint] NULL,
	[IDSistemaTiposDocumentoMovStock] [bigint] NULL,
	[IDSistemaTiposDocumentoPrecoUnitario] [bigint] NULL,
	[CalculaNecessidadesNeg] [bit] NULL,
	[CustoMedioNeg] [bit] NULL,
	[UltimoPrecoCustoNeg] [bit] NULL,
	[DataPrimeiraEntradaNeg] [bit] NULL,
	[DataUltimaEntradaNeg] [bit] NULL,
	[DataPrimeiraSaidaNeg] [bit] NULL,
	[DataUltimaSaidaNeg] [bit] NULL,
	[IDSistemaAcoesRupturaStockNeg] [bigint] NULL,
	[IDSistemaTiposDocumentoMovStockNeg] [bigint] NULL,
	[IDSistemaTiposDocumentoPrecoUnitarioNeg] [bigint] NULL,
	[AtualizaFichaTecnica] [bit] NULL,
	[IDEstado] [bigint] NULL,
	[IDCliente] [bigint] NULL,
	[IDSistemaAcoesStockMinimo] [bigint] NULL,
	[IDSistemaAcoesStockMaximo] [bigint] NULL,
	[IDSistemaAcoesReposicaoStock] [bigint] NULL,
 CONSTRAINT [PK_tbTiposDocumento] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


/****** Object:  Table [dbo].[tbTiposDocumentoIdioma]    Script Date: 01-06-2016 16:38:53 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbTiposDocumentoIdioma](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDTiposDocumento] [bigint] NOT NULL,
	[IDIdioma] [bigint] NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
	[Ordem] [bigint] NOT NULL,
 CONSTRAINT [PK_tbTiposDocumentoIdioma] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbTiposDocumentoSeries]    Script Date: 01-06-2016 16:38:53 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbTiposDocumentoSeries](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[CodigoSerie] [nvarchar](6) NOT NULL,
	[DescricaoSerie] [nvarchar](50) NOT NULL,
	[SugeridaPorDefeito] [bit] NOT NULL,
	[IDTiposDocumento] [bigint] NOT NULL,
	[Sistema] [bit] NOT NULL,
	[AtivoSerie] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
	[Ordem] [bigint] NOT NULL,
	[CalculaComissoesSerie] [bit] NOT NULL DEFAULT ((0)),
	[AnalisesEstatisticasSerie] [bit] NOT NULL DEFAULT ((0)),
	[IVAIncluido] [bit] NOT NULL DEFAULT ((0)),
	[IVARegimeCaixa] [bit] NOT NULL DEFAULT ((0)),
	[DataInicial] [datetime] NULL,
	[DataFinal] [datetime] NULL,
	[DataUltimoDoc] [datetime] NULL,
	[NumUltimoDoc] [bigint] NULL,
	[IDSistemaTiposDocumentoOrigem] [bigint] NULL,
	[IDSistemaTiposDocumentoComunicacao] [bigint] NULL,
 CONSTRAINT [PK_tbTiposDocumentoSeries] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbTiposDocumentoSeriesPermissoes]    Script Date: 01-06-2016 16:38:53 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbTiposDocumentoSeriesPermissoes](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDSerie] [bigint] NOT NULL,
	[IDPerfil] [bigint] NOT NULL,
	[PermissaoConsultar] [bit] NOT NULL,
	[PermissaoAlterar] [bit] NOT NULL,
	[PermissaoAdicionar] [bit] NOT NULL,
	[PermissaoRemover] [bit] NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbTiposDocumentoSeriesPermissoes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[tbTiposDocumentoTipEntPermDoc]    Script Date: 01-06-2016 16:38:53 ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tbTiposDocumentoTipEntPermDoc](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDTiposDocumento] [bigint] NOT NULL,
	[IDSistemaTiposEntidadeModulos] [bigint] NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
	[Ordem] [bigint] NOT NULL,
 CONSTRAINT [PK_tbTiposDocumentoTipEntPermDoc] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


SET ANSI_PADDING ON


/****** Object:  Index [IX_tbTiposDocumento]    Script Date: 01-06-2016 16:38:53 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_tbTiposDocumento] ON [dbo].[tbTiposDocumento]
(
 [Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

SET ANSI_PADDING ON


/****** Object:  Index [IX_tbTiposDocumentoSeries]    Script Date: 01-06-2016 16:38:53 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_tbTiposDocumentoSeries] ON [dbo].[tbTiposDocumentoSeries]
(
	[CodigoSerie] ASC,
	[IDTiposDocumento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

ALTER TABLE [dbo].[tbTiposDocumento]  WITH CHECK ADD  CONSTRAINT [FK_tbTiposDocumento_tbClientes] FOREIGN KEY([IDCliente])
REFERENCES [dbo].[tbClientes] ([ID])

ALTER TABLE [dbo].[tbTiposDocumento] CHECK CONSTRAINT [FK_tbTiposDocumento_tbClientes]

ALTER TABLE [dbo].[tbTiposDocumento]  WITH CHECK ADD  CONSTRAINT [FK_tbTiposDocumento_tbSistemaAcoes] FOREIGN KEY([IDSistemaAcoes])
REFERENCES [dbo].[tbSistemaAcoes] ([ID])

ALTER TABLE [dbo].[tbTiposDocumento] CHECK CONSTRAINT [FK_tbTiposDocumento_tbSistemaAcoes]

ALTER TABLE [dbo].[tbTiposDocumento]  WITH CHECK ADD  CONSTRAINT [FK_tbTiposDocumento_tbSistemaAcoes2] FOREIGN KEY([IDSistemaAcoesStockMinimo])
REFERENCES [dbo].[tbSistemaAcoes] ([ID])

ALTER TABLE [dbo].[tbTiposDocumento] CHECK CONSTRAINT [FK_tbTiposDocumento_tbSistemaAcoes2]

ALTER TABLE [dbo].[tbTiposDocumento]  WITH CHECK ADD  CONSTRAINT [FK_tbTiposDocumento_tbSistemaAcoes3] FOREIGN KEY([IDSistemaAcoesStockMaximo])
REFERENCES [dbo].[tbSistemaAcoes] ([ID])

ALTER TABLE [dbo].[tbTiposDocumento] CHECK CONSTRAINT [FK_tbTiposDocumento_tbSistemaAcoes3]

ALTER TABLE [dbo].[tbTiposDocumento]  WITH CHECK ADD  CONSTRAINT [FK_tbTiposDocumento_tbSistemaAcoes4] FOREIGN KEY([IDSistemaAcoesReposicaoStock])
REFERENCES [dbo].[tbSistemaAcoes] ([ID])

ALTER TABLE [dbo].[tbTiposDocumento] CHECK CONSTRAINT [FK_tbTiposDocumento_tbSistemaAcoes4]

ALTER TABLE [dbo].[tbTiposDocumento]  WITH CHECK ADD  CONSTRAINT [FK_tbTiposDocumento_tbSistemaAcoes1] FOREIGN KEY([IDSistemaAcoesRupturaStock])
REFERENCES [dbo].[tbSistemaAcoes] ([ID])

ALTER TABLE [dbo].[tbTiposDocumento] CHECK CONSTRAINT [FK_tbTiposDocumento_tbSistemaAcoes1]

ALTER TABLE [dbo].[tbTiposDocumento]  WITH CHECK ADD  CONSTRAINT [FK_tbTiposDocumento_tbSistemaAcoesRupturaStockNeg] FOREIGN KEY([IDSistemaAcoesRupturaStockNeg])
REFERENCES [dbo].[tbSistemaAcoes] ([ID])

ALTER TABLE [dbo].[tbTiposDocumento] CHECK CONSTRAINT [FK_tbTiposDocumento_tbSistemaAcoesRupturaStockNeg]

ALTER TABLE [dbo].[tbTiposDocumento]  WITH CHECK ADD  CONSTRAINT [FK_tbTiposDocumento_tbSistemaModulos] FOREIGN KEY([IDModulo])
REFERENCES [dbo].[tbSistemaModulos] ([ID])

ALTER TABLE [dbo].[tbTiposDocumento] CHECK CONSTRAINT [FK_tbTiposDocumento_tbSistemaModulos]

ALTER TABLE [dbo].[tbTiposDocumento]  WITH CHECK ADD  CONSTRAINT [FK_tbTiposDocumento_tbSistemaTiposDocumento] FOREIGN KEY([IDSistemaTiposDocumento])
REFERENCES [dbo].[tbSistemaTiposDocumento] ([ID])

ALTER TABLE [dbo].[tbTiposDocumento] CHECK CONSTRAINT [FK_tbTiposDocumento_tbSistemaTiposDocumento]

ALTER TABLE [dbo].[tbTiposDocumento]  WITH CHECK ADD  CONSTRAINT [FK_tbTiposDocumento_tbSistemaTiposDocumentoFiscal] FOREIGN KEY([IDSistemaTiposDocumentoFiscal])
REFERENCES [dbo].[tbSistemaTiposDocumentoFiscal] ([ID])

ALTER TABLE [dbo].[tbTiposDocumento] CHECK CONSTRAINT [FK_tbTiposDocumento_tbSistemaTiposDocumentoFiscal]

ALTER TABLE [dbo].[tbTiposDocumento]  WITH CHECK ADD  CONSTRAINT [FK_tbTiposDocumento_tbSistemaTiposDocumentoMovStock] FOREIGN KEY([IDSistemaTiposDocumentoMovStock])
REFERENCES [dbo].[tbSistemaTiposDocumentoMovStock] ([ID])

ALTER TABLE [dbo].[tbTiposDocumento] CHECK CONSTRAINT [FK_tbTiposDocumento_tbSistemaTiposDocumentoMovStock]

ALTER TABLE [dbo].[tbTiposDocumento]  WITH CHECK ADD  CONSTRAINT [FK_tbTiposDocumento_tbSistemaTiposDocumentoMovStockNeg] FOREIGN KEY([IDSistemaTiposDocumentoMovStockNeg])
REFERENCES [dbo].[tbSistemaTiposDocumentoMovStock] ([ID])

ALTER TABLE [dbo].[tbTiposDocumento] CHECK CONSTRAINT [FK_tbTiposDocumento_tbSistemaTiposDocumentoMovStockNeg]

ALTER TABLE [dbo].[tbTiposDocumento]  WITH CHECK ADD  CONSTRAINT [FK_tbTiposDocumento_tbSistemaTiposDocumentoPrecoUnitario] FOREIGN KEY([IDSistemaTiposDocumentoPrecoUnitario])
REFERENCES [dbo].[tbSistemaTiposDocumentoPrecoUnitario] ([ID])

ALTER TABLE [dbo].[tbTiposDocumento] CHECK CONSTRAINT [FK_tbTiposDocumento_tbSistemaTiposDocumentoPrecoUnitario]

ALTER TABLE [dbo].[tbTiposDocumento]  WITH CHECK ADD  CONSTRAINT [FK_tbTiposDocumento_tbSistemaTiposDocumentoPrecoUnitarioNeg] FOREIGN KEY([IDSistemaTiposDocumentoPrecoUnitarioNeg])
REFERENCES [dbo].[tbSistemaTiposDocumentoPrecoUnitario] ([ID])

ALTER TABLE [dbo].[tbTiposDocumento] CHECK CONSTRAINT [FK_tbTiposDocumento_tbSistemaTiposDocumentoPrecoUnitarioNeg]

ALTER TABLE [dbo].[tbTiposDocumento]  WITH CHECK ADD  CONSTRAINT [FK_tbTiposDocumento_tbSistemaTiposLiquidacao] FOREIGN KEY([IDSistemaTiposLiquidacao])
REFERENCES [dbo].[tbSistemaTiposLiquidacao] ([ID])

ALTER TABLE [dbo].[tbTiposDocumento] CHECK CONSTRAINT [FK_tbTiposDocumento_tbSistemaTiposLiquidacao]

ALTER TABLE [dbo].[tbTiposDocumentoTipEntPermDoc]  WITH CHECK ADD  CONSTRAINT [FK_tbTiposDocumentoTipEntPermDoc_tbSistemaTiposEntidadeModulos] FOREIGN KEY([IDSistemaTiposEntidadeModulos])
REFERENCES [dbo].[tbSistemaTiposEntidadeModulos] ([ID])

ALTER TABLE [dbo].[tbTiposDocumentoTipEntPermDoc] CHECK CONSTRAINT [FK_tbTiposDocumentoTipEntPermDoc_tbSistemaTiposEntidadeModulos]

ALTER TABLE [dbo].[tbTiposDocumentoTipEntPermDoc]  WITH CHECK ADD  CONSTRAINT [FK_tbTiposDocumentoTipEntPermDoc_tbTiposDocumento] FOREIGN KEY([IDTiposDocumento])
REFERENCES [dbo].[tbTiposDocumento] ([ID])

ALTER TABLE [dbo].[tbTiposDocumentoTipEntPermDoc] CHECK CONSTRAINT [FK_tbTiposDocumentoTipEntPermDoc_tbTiposDocumento]

ALTER TABLE [dbo].[tbTiposDocumentoSeries]  WITH CHECK ADD  CONSTRAINT [FK_tbTiposDocumentoSeries_tbSistemaTiposDocumentoComunicacao] FOREIGN KEY([IDSistemaTiposDocumentoComunicacao])
REFERENCES [dbo].[tbSistemaTiposDocumentoComunicacao] ([ID])

ALTER TABLE [dbo].[tbTiposDocumentoSeries] CHECK CONSTRAINT [FK_tbTiposDocumentoSeries_tbSistemaTiposDocumentoComunicacao]

ALTER TABLE [dbo].[tbTiposDocumentoSeries]  WITH CHECK ADD  CONSTRAINT [FK_tbTiposDocumentoSeries_tbSistemaTiposDocumentoOrigem] FOREIGN KEY([IDSistemaTiposDocumentoOrigem])
REFERENCES [dbo].[tbSistemaTiposDocumentoOrigem] ([ID])

ALTER TABLE [dbo].[tbTiposDocumentoSeries] CHECK CONSTRAINT [FK_tbTiposDocumentoSeries_tbSistemaTiposDocumentoOrigem]

ALTER TABLE [dbo].[tbTiposDocumentoSeries]  WITH CHECK ADD  CONSTRAINT [FK_tbTiposDocumentoSeries_tbTiposDocumento] FOREIGN KEY([IDTiposDocumento])
REFERENCES [dbo].[tbTiposDocumento] ([ID])

ALTER TABLE [dbo].[tbTiposDocumentoSeries] CHECK CONSTRAINT [FK_tbTiposDocumentoSeries_tbTiposDocumento]

ALTER TABLE [dbo].[tbTiposDocumentoIdioma]  WITH CHECK ADD  CONSTRAINT [FK_tbTiposDocumentoIdioma_tbIdiomas] FOREIGN KEY([IDIdioma])
REFERENCES [dbo].[tbIdiomas] ([ID])

ALTER TABLE [dbo].[tbTiposDocumentoIdioma] CHECK CONSTRAINT [FK_tbTiposDocumentoIdioma_tbIdiomas]

ALTER TABLE [dbo].[tbTiposDocumentoIdioma]  WITH CHECK ADD  CONSTRAINT [FK_tbTiposDocumentoIdioma_tbTiposDocumento] FOREIGN KEY([IDTiposDocumento])
REFERENCES [dbo].[tbTiposDocumento] ([ID])

ALTER TABLE [dbo].[tbTiposDocumentoIdioma] CHECK CONSTRAINT [FK_tbTiposDocumentoIdioma_tbTiposDocumento]

ALTER TABLE [dbo].[tbTiposDocumentoSeriesPermissoes]  WITH CHECK ADD  CONSTRAINT [FK_tbTiposDocumentoSeriesPermissoes_tbTiposDocumentoSeries] FOREIGN KEY([IDSerie])
REFERENCES [dbo].[tbTiposDocumentoSeries] ([ID])
ON DELETE CASCADE

ALTER TABLE [dbo].[tbTiposDocumentoSeriesPermissoes] CHECK CONSTRAINT [FK_tbTiposDocumentoSeriesPermissoes_tbTiposDocumentoSeries]

EXEC('CREATE  TRIGGER [dbo].[UpdateTbTiposDocumento]
ON [dbo].[tbTiposDocumento]  
AFTER  INSERT, UPDATE
AS 
	UPDATE tbTiposDocumentoSeries 
	SET IDSistemaTiposDocumentoComunicacao = 
		  (CASE WHEN i.IDSistemaTiposDocumento = (SELECT ID FROM tbSistemaTiposDocumento WHERE Tipo = '' VndFinanceiro '') 
						THEN (SELECT ID FROM tbSistemaTiposDocumentoComunicacao as b WHERE b.Codigo = ''002'') ELSE 
					
			CASE WHEN i.IDSistemaTiposDocumento = (SELECT ID FROM tbSistemaTiposDocumento WHERE Tipo = ''CmpFinanceiro'') 
						THEN (SELECT ID FROM tbSistemaTiposDocumentoComunicacao as b WHERE b.Codigo = ''002'') ELSE 
	  
			CASE WHEN i.IDSistemaTiposDocumento <> (SELECT ID FROM tbSistemaTiposDocumento WHERE Tipo = ''VndTransporte'') 
						THEN (SELECT ID FROM tbSistemaTiposDocumentoComunicacao as b WHERE b.Codigo = ''001'') ELSE 

			CASE WHEN i.IDSistemaTiposDocumento <> (SELECT ID FROM tbSistemaTiposDocumento WHERE Tipo = ''CmpTransporte'') 
						THEN (SELECT ID FROM tbSistemaTiposDocumentoComunicacao as b WHERE b.Codigo = ''001'') ELSE 

			CASE WHEN i.IDSistemaTiposDocumento <> (SELECT ID FROM tbSistemaTiposDocumento WHERE Tipo = ''VndFinanceiro'') 
						THEN (SELECT ID FROM tbSistemaTiposDocumentoComunicacao as b WHERE b.Codigo = ''001'') ELSE 

			CASE WHEN i.IDSistemaTiposDocumento <> (SELECT ID FROM tbSistemaTiposDocumento WHERE Tipo = ''CmpFinanceiro'') 
						THEN (SELECT ID FROM tbSistemaTiposDocumentoComunicacao as b WHERE b.Codigo = ''001'') ELSE 					
	  
		  i.IDSistemaTiposDocumento END
		  END
		  END
		  END
		END
		END)

	FROM tbTiposDocumentoSeries
	INNER JOIN INSERTED i ON  tbTiposDocumentoSeries.IDTiposDocumento = i.ID
')

/****** Object:  Trigger [dbo].[UpdateTbTiposDocumentoSeries]    Script Date: 16/06/2016 16:06:06 ******/
EXEC('CREATE TRIGGER [dbo].[UpdateTbTiposDocumentoSeries]
ON [dbo].[tbTiposDocumentoSeries]  
AFTER  INSERT, UPDATE
AS 

	UPDATE tbTiposDocumentoSeries 
	SET SugeridaPorDefeito = 0 
	FROM tbTiposDocumentoSeries
		INNER JOIN INSERTED i ON  tbTiposDocumentoSeries.IDTiposDocumento = i.IDTiposDocumento
	WHERE I.SugeridaPorDefeito = 1
		AND i.id <> tbTiposDocumentoSeries.ID
')



ALTER TABLE [dbo].[tbMedicosTecnicos]  WITH CHECK ADD  CONSTRAINT [FK_tbMedicosTecnicos_tbSistemaTiposEntidade] FOREIGN KEY([IDTipoEntidade])
REFERENCES [dbo].[tbSistemaTiposEntidade] ([ID])

ALTER TABLE [dbo].[tbMedicosTecnicos] CHECK CONSTRAINT [FK_tbMedicosTecnicos_tbSistemaTiposEntidade]

CREATE TABLE [dbo].[tbBancos](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDLoja] [bigint] NULL,
	[Codigo] [nvarchar](10) NOT NULL,
	[Descricao] [nvarchar](100) NOT NULL,
	[Sigla] [nvarchar](10) NOT NULL,
	[CodigoBP] [nvarchar](10) NULL,
	[PaisIban] [nvarchar](4) NULL,
	[BicSwift] [nvarchar](15) NULL,
	[NomeFichSepa] [nvarchar](50) NULL,
	[Observacoes] [nvarchar](Max) NULL,
	[Ativo] [bit] NOT NULL,
	[Sistema] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbBancos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)
) ON [PRIMARY]

create unique index IX_tbBancos_Codigo on tbBancos (Codigo) 

ALTER TABLE [dbo].[tbBancos] ADD  CONSTRAINT [DF_tbBancos_Ativo]  DEFAULT ((1)) FOR [Ativo]

ALTER TABLE [dbo].[tbBancos] ADD  CONSTRAINT [DF_tbBancos_Sistema]  DEFAULT ((0)) FOR [Sistema]

ALTER TABLE [dbo].[tbBancos] ADD  CONSTRAINT [DF_tbBancos_DataCriacao]  DEFAULT (getdate()) FOR [DataCriacao]

ALTER TABLE [dbo].[tbBancos] ADD  CONSTRAINT [DF_tbBancos_UtilizadorCriacao]  DEFAULT ('') FOR [UtilizadorCriacao]

ALTER TABLE [dbo].[tbBancos] ADD  CONSTRAINT [DF_tbBancos_DataAlteracao]  DEFAULT (getdate()) FOR [DataAlteracao]

ALTER TABLE [dbo].[tbBancos] ADD  CONSTRAINT [DF_tbBancos_UtilizadorAlteracao]  DEFAULT ('') FOR [UtilizadorAlteracao]

ALTER TABLE [dbo].[tbBancos]  WITH CHECK ADD  CONSTRAINT [FK_tbBancos_tbLojas] FOREIGN KEY([IDLoja])
REFERENCES [dbo].[tbLojas] ([ID])

ALTER TABLE [dbo].[tbBancos] CHECK CONSTRAINT [FK_tbBancos_tbLojas]


CREATE TABLE [dbo].[tbBancosContatos](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDBanco] [bigint] NULL,
	[IDTipo] [bigint] NULL,
	[Descricao] [nvarchar](50) NULL,
	[Contato] [nvarchar](50) NULL,
	[Telefone] [nvarchar](25) NULL,
	[Telemovel] [nvarchar](25) NULL,
	[Fax] [nvarchar](25) NULL,
	[Email] [nvarchar](255) NULL,
	[Mailing] [bit] NOT NULL,
	[PagWeb] [nvarchar](255) NULL,
	[PagRedeSocial] [nvarchar](255) NULL,
	[Ordem] [int] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[Sistema] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbBancosContatos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)
) ON [PRIMARY]


ALTER TABLE [dbo].[tbBancosContatos] ADD  CONSTRAINT [DF_tbBancosContatos_Mailing]  DEFAULT ((1)) FOR [Mailing]

ALTER TABLE [dbo].[tbBancosContatos] ADD  CONSTRAINT [DF_tbBancosContatos_Ativo]  DEFAULT ((1)) FOR [Ativo]

ALTER TABLE [dbo].[tbBancosContatos] ADD  CONSTRAINT [DF_tbBancosContatos_Sistema]  DEFAULT ((0)) FOR [Sistema]

ALTER TABLE [dbo].[tbBancosContatos] ADD  CONSTRAINT [DF_tbBancosContatos_DataCriacao]  DEFAULT (getdate()) FOR [DataCriacao]

ALTER TABLE [dbo].[tbBancosContatos] ADD  CONSTRAINT [DF_tbBancosContatos_UtilizadorCriacao]  DEFAULT ('') FOR [UtilizadorCriacao]

ALTER TABLE [dbo].[tbBancosContatos] ADD  CONSTRAINT [DF_tbBancosContatos_DataAlteracao]  DEFAULT (getdate()) FOR [DataAlteracao]

ALTER TABLE [dbo].[tbBancosContatos] ADD  CONSTRAINT [DF_tbBancosContatos_UtilizadorAlteracao]  DEFAULT ('') FOR [UtilizadorAlteracao]

ALTER TABLE [dbo].[tbBancosContatos]  WITH CHECK ADD  CONSTRAINT [FK_tbBancosContatos_tbBancos] FOREIGN KEY([IDBanco])
REFERENCES [dbo].[tbBancos] ([ID])

ALTER TABLE [dbo].[tbBancosContatos] CHECK CONSTRAINT [FK_tbBancosContatos_tbBancos]

ALTER TABLE [dbo].[tbBancosContatos]  WITH CHECK ADD  CONSTRAINT [FK_tbBancosContatos_tbTiposContatos] FOREIGN KEY([IDTipo])
REFERENCES [dbo].[tbTiposContatos] ([ID])

ALTER TABLE [dbo].[tbBancosContatos] CHECK CONSTRAINT [FK_tbBancosContatos_tbTiposContatos]

CREATE TABLE [dbo].[tbBancosMoradas](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDBanco] [bigint] NULL,
	[IDCodigoPostal] [bigint] NULL,
	[IDConcelho] [bigint] NULL,
	[IDDistrito] [bigint] NULL,
	[IDPais] [bigint] NULL,
	[Descricao] [nvarchar](50) NULL,
	[Rota] [nvarchar](255) NULL,
	[Rua] [nvarchar](255) NULL,
	[NumPolicia] [nvarchar](100) NULL,
	[GPS] [nvarchar](100) NULL,
	[Ordem] [int] NOT NULL,
	[OrdemMorada] [int] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[Sistema] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbBancosMoradas] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)
) ON [PRIMARY]


ALTER TABLE [dbo].[tbBancosMoradas] ADD  CONSTRAINT [DF_tbBancosMoradas_Ativo]  DEFAULT ((1)) FOR [Ativo]


ALTER TABLE [dbo].[tbBancosMoradas] ADD  CONSTRAINT [DF_tbBancosMoradas_Sistema]  DEFAULT ((0)) FOR [Sistema]


ALTER TABLE [dbo].[tbBancosMoradas] ADD  CONSTRAINT [DF_tbBancosMoradas_DataCriacao]  DEFAULT (getdate()) FOR [DataCriacao]


ALTER TABLE [dbo].[tbBancosMoradas] ADD  CONSTRAINT [DF_tbBancosMoradas_UtilizadorCriacao]  DEFAULT ('') FOR [UtilizadorCriacao]


ALTER TABLE [dbo].[tbBancosMoradas] ADD  CONSTRAINT [DF_tbBancosMoradas_DataAlteracao]  DEFAULT (getdate()) FOR [DataAlteracao]


ALTER TABLE [dbo].[tbBancosMoradas] ADD  CONSTRAINT [DF_tbBancosMoradas_UtilizadorAlteracao]  DEFAULT ('') FOR [UtilizadorAlteracao]


ALTER TABLE [dbo].[tbBancosMoradas]  WITH CHECK ADD  CONSTRAINT [FK_tbBancosMoradas_tbCodigosPostais] FOREIGN KEY([IDCodigoPostal])
REFERENCES [dbo].[tbCodigosPostais] ([ID])


ALTER TABLE [dbo].[tbBancosMoradas] CHECK CONSTRAINT [FK_tbBancosMoradas_tbCodigosPostais]


ALTER TABLE [dbo].[tbBancosMoradas]  WITH CHECK ADD  CONSTRAINT [FK_tbBancosMoradas_tbConcelhos] FOREIGN KEY([IDConcelho])
REFERENCES [dbo].[tbConcelhos] ([ID])


ALTER TABLE [dbo].[tbBancosMoradas] CHECK CONSTRAINT [FK_tbBancosMoradas_tbConcelhos]


ALTER TABLE [dbo].[tbBancosMoradas]  WITH CHECK ADD  CONSTRAINT [FK_tbBancosMoradas_tbDistritos] FOREIGN KEY([IDDistrito])
REFERENCES [dbo].[tbDistritos] ([ID])


ALTER TABLE [dbo].[tbBancosMoradas] CHECK CONSTRAINT [FK_tbBancosMoradas_tbDistritos]

ALTER TABLE [dbo].[tbBancosMoradas]  WITH CHECK ADD  CONSTRAINT [FK_tbBancosMoradas_tbBancos] FOREIGN KEY([IDBanco])
REFERENCES [dbo].[tbBancos] ([ID])

ALTER TABLE [dbo].[tbBancosMoradas] CHECK CONSTRAINT [FK_tbBancosMoradas_tbBancos]

ALTER TABLE [dbo].[tbBancosMoradas]  WITH CHECK ADD  CONSTRAINT [FK_tbBancosMoradas_tbPaises] FOREIGN KEY([IDPais])
REFERENCES [dbo].[tbPaises] ([ID])

ALTER TABLE [dbo].[tbBancosMoradas] CHECK CONSTRAINT [FK_tbBancosMoradas_tbPaises]

CREATE TABLE [dbo].[tbContasBancarias](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDLoja] [bigint] NULL,
	[Codigo] [nvarchar](10) NOT NULL,
	[Descricao] [nvarchar](100) NOT NULL,
	[IDBanco] [bigint] NOT NULL,
	[IDMoeda] [bigint] NOT NULL,
	[Plafond] [float] NULL,
	[TaxaPlafond] [float] NULL,
	[PaisIban] [nvarchar](4) NULL,
	[NIB] [nvarchar](30) NULL,
	[SepaPrv] [nvarchar](35) NULL,
	[VariavelContabilidade] [nvarchar](20) NULL,
	[ContaCaixa] [bit] NOT NULL,
	[SaldoTotal] [float] NULL,
	[SaldoReconciliado] [float] NULL,
	[Observacoes] [nvarchar](Max) NULL,
	[Ativo] [bit] NOT NULL,
	[Sistema] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbContasBancarias] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)
) ON [PRIMARY]

create unique index IX_tbContasBancarias_Codigo on tbContasBancarias (Codigo) 

ALTER TABLE [dbo].[tbContasBancarias] ADD  CONSTRAINT [DF_tbContasBancarias_ContaCaixa]  DEFAULT ((0)) FOR [ContaCaixa]

ALTER TABLE [dbo].[tbContasBancarias] ADD  CONSTRAINT [DF_tbContasBancarias_Ativo]  DEFAULT ((1)) FOR [Ativo]

ALTER TABLE [dbo].[tbContasBancarias] ADD  CONSTRAINT [DF_tbContasBancarias_Sistema]  DEFAULT ((0)) FOR [Sistema]

ALTER TABLE [dbo].[tbContasBancarias] ADD  CONSTRAINT [DF_tbContasBancarias_DataCriacao]  DEFAULT (getdate()) FOR [DataCriacao]

ALTER TABLE [dbo].[tbContasBancarias] ADD  CONSTRAINT [DF_tbContasBancarias_UtilizadorCriacao]  DEFAULT ('') FOR [UtilizadorCriacao]

ALTER TABLE [dbo].[tbContasBancarias] ADD  CONSTRAINT [DF_tbContasBancarias_DataAlteracao]  DEFAULT (getdate()) FOR [DataAlteracao]

ALTER TABLE [dbo].[tbContasBancarias] ADD  CONSTRAINT [DF_tbContasBancarias_UtilizadorAlteracao]  DEFAULT ('') FOR [UtilizadorAlteracao]

ALTER TABLE [dbo].[tbContasBancarias]  WITH CHECK ADD  CONSTRAINT [FK_tbContasBancarias_tbLojas] FOREIGN KEY([IDLoja])
REFERENCES [dbo].[tbLojas] ([ID])

ALTER TABLE [dbo].[tbContasBancarias] CHECK CONSTRAINT [FK_tbContasBancarias_tbLojas]

ALTER TABLE [dbo].[tbContasBancarias]  WITH CHECK ADD  CONSTRAINT [FK_tbContasBancarias_tbBancos] FOREIGN KEY([IDBanco])
REFERENCES [dbo].[tbBancos] ([ID])

ALTER TABLE [dbo].[tbContasBancarias] CHECK CONSTRAINT [FK_tbContasBancarias_tbBancos]

ALTER TABLE [dbo].[tbContasBancarias]  WITH CHECK ADD  CONSTRAINT [FK_tbContasBancarias_tbMoedas] FOREIGN KEY([IDMoeda])
REFERENCES [dbo].[tbMoedas] ([ID])

ALTER TABLE [dbo].[tbContasBancarias] CHECK CONSTRAINT [FK_tbContasBancarias_tbMoedas]

CREATE TABLE [dbo].[tbContasBancariasContatos](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDContaBancaria] [bigint] NULL,
	[IDTipo] [bigint] NULL,
	[Descricao] [nvarchar](50) NULL,
	[Contato] [nvarchar](50) NULL,
	[Telefone] [nvarchar](25) NULL,
	[Telemovel] [nvarchar](25) NULL,
	[Fax] [nvarchar](25) NULL,
	[Email] [nvarchar](255) NULL,
	[Mailing] [bit] NOT NULL,
	[PagWeb] [nvarchar](255) NULL,
	[PagRedeSocial] [nvarchar](255) NULL,
	[Ordem] [int] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[Sistema] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbContasBancariasContatos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)
) ON [PRIMARY]


ALTER TABLE [dbo].[tbContasBancariasContatos] ADD  CONSTRAINT [DF_tbContasBancariasContatos_Mailing]  DEFAULT ((1)) FOR [Mailing]

ALTER TABLE [dbo].[tbContasBancariasContatos] ADD  CONSTRAINT [DF_tbContasBancariasContatos_Ativo]  DEFAULT ((1)) FOR [Ativo]

ALTER TABLE [dbo].[tbContasBancariasContatos] ADD  CONSTRAINT [DF_tbContasBancariasContatos_Sistema]  DEFAULT ((0)) FOR [Sistema]

ALTER TABLE [dbo].[tbContasBancariasContatos] ADD  CONSTRAINT [DF_tbContasBancariasContatos_DataCriacao]  DEFAULT (getdate()) FOR [DataCriacao]

ALTER TABLE [dbo].[tbContasBancariasContatos] ADD  CONSTRAINT [DF_tbContasBancariasContatos_UtilizadorCriacao]  DEFAULT ('') FOR [UtilizadorCriacao]

ALTER TABLE [dbo].[tbContasBancariasContatos] ADD  CONSTRAINT [DF_tbContasBancariasContatos_DataAlteracao]  DEFAULT (getdate()) FOR [DataAlteracao]

ALTER TABLE [dbo].[tbContasBancariasContatos] ADD  CONSTRAINT [DF_tbContasBancariasContatos_UtilizadorAlteracao]  DEFAULT ('') FOR [UtilizadorAlteracao]

ALTER TABLE [dbo].[tbContasBancariasContatos]  WITH CHECK ADD  CONSTRAINT [FK_tbContasBancariasContatos_tbContasBancarias] FOREIGN KEY([IDContaBancaria])
REFERENCES [dbo].[tbContasBancarias] ([ID])

ALTER TABLE [dbo].[tbContasBancariasContatos] CHECK CONSTRAINT [FK_tbContasBancariasContatos_tbContasBancarias]

ALTER TABLE [dbo].[tbContasBancariasContatos]  WITH CHECK ADD  CONSTRAINT [FK_tbContasBancariasContatos_tbTiposContatos] FOREIGN KEY([IDTipo])
REFERENCES [dbo].[tbTiposContatos] ([ID])

ALTER TABLE [dbo].[tbContasBancariasContatos] CHECK CONSTRAINT [FK_tbContasBancariasContatos_tbTiposContatos]

CREATE TABLE [dbo].[tbContasBancariasMoradas](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDContaBancaria] [bigint] NULL,
	[IDCodigoPostal] [bigint] NULL,
	[IDConcelho] [bigint] NULL,
	[IDDistrito] [bigint] NULL,
	[IDPais] [bigint] NULL,
	[Descricao] [nvarchar](50) NULL,
	[Rota] [nvarchar](255) NULL,
	[Rua] [nvarchar](255) NULL,
	[NumPolicia] [nvarchar](100) NULL,
	[GPS] [nvarchar](100) NULL,
	[Ordem] [int] NOT NULL,
	[OrdemMorada] [int] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[Sistema] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbContasBancariasMoradas] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)
) ON [PRIMARY]

ALTER TABLE [dbo].[tbContasBancariasMoradas] ADD  CONSTRAINT [DF_tbContasBancariasMoradas_Ativo]  DEFAULT ((1)) FOR [Ativo]

ALTER TABLE [dbo].[tbContasBancariasMoradas] ADD  CONSTRAINT [DF_tbContasBancariasMoradas_Sistema]  DEFAULT ((0)) FOR [Sistema]

ALTER TABLE [dbo].[tbContasBancariasMoradas] ADD  CONSTRAINT [DF_tbContasBancariasMoradas_DataCriacao]  DEFAULT (getdate()) FOR [DataCriacao]

ALTER TABLE [dbo].[tbContasBancariasMoradas] ADD  CONSTRAINT [DF_tbContasBancariasMoradas_UtilizadorCriacao]  DEFAULT ('') FOR [UtilizadorCriacao]

ALTER TABLE [dbo].[tbContasBancariasMoradas] ADD  CONSTRAINT [DF_tbContasBancariasMoradas_DataAlteracao]  DEFAULT (getdate()) FOR [DataAlteracao]

ALTER TABLE [dbo].[tbContasBancariasMoradas] ADD  CONSTRAINT [DF_tbContasBancariasMoradas_UtilizadorAlteracao]  DEFAULT ('') FOR [UtilizadorAlteracao]

ALTER TABLE [dbo].[tbContasBancariasMoradas]  WITH CHECK ADD  CONSTRAINT [FK_tbContasBancariasMoradas_tbCodigosPostais] FOREIGN KEY([IDCodigoPostal])
REFERENCES [dbo].[tbCodigosPostais] ([ID])

ALTER TABLE [dbo].[tbContasBancariasMoradas] CHECK CONSTRAINT [FK_tbContasBancariasMoradas_tbCodigosPostais]

ALTER TABLE [dbo].[tbContasBancariasMoradas]  WITH CHECK ADD  CONSTRAINT [FK_tbContasBancariasMoradas_tbConcelhos] FOREIGN KEY([IDConcelho])
REFERENCES [dbo].[tbConcelhos] ([ID])

ALTER TABLE [dbo].[tbContasBancariasMoradas] CHECK CONSTRAINT [FK_tbContasBancariasMoradas_tbConcelhos]

ALTER TABLE [dbo].[tbContasBancariasMoradas]  WITH CHECK ADD  CONSTRAINT [FK_tbContasBancariasMoradas_tbDistritos] FOREIGN KEY([IDDistrito])
REFERENCES [dbo].[tbDistritos] ([ID])

ALTER TABLE [dbo].[tbContasBancariasMoradas] CHECK CONSTRAINT [FK_tbContasBancariasMoradas_tbDistritos]

ALTER TABLE [dbo].[tbContasBancariasMoradas]  WITH CHECK ADD  CONSTRAINT [FK_tbContasBancariasMoradas_tbContasBancarias] FOREIGN KEY([IDContaBancaria])
REFERENCES [dbo].[tbContasBancarias] ([ID])

ALTER TABLE [dbo].[tbContasBancariasMoradas] CHECK CONSTRAINT [FK_tbContasBancariasMoradas_tbContasBancarias]

ALTER TABLE [dbo].[tbContasBancariasMoradas]  WITH CHECK ADD  CONSTRAINT [FK_tbContasBancariasMoradas_tbPaises] FOREIGN KEY([IDPais])
REFERENCES [dbo].[tbPaises] ([ID])

ALTER TABLE [dbo].[tbContasBancariasMoradas] CHECK CONSTRAINT [FK_tbContasBancariasMoradas_tbPaises]

CREATE TABLE [dbo].[tbTextosBase](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[Texto] [nvarchar](4000) NOT NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbTextosBase_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbTextosBase_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](256) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbTextosBase_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](256) NULL,
	[F3MMarcador] [timestamp] NULL,
	[IDTiposTextoBase] [bigint] NOT NULL,
 CONSTRAINT [PK_tbTextosBase] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

create unique index IX_tbTextosBase_Codigo on tbTextosBase (Codigo)

ALTER TABLE [dbo].[tbTextosBase]  WITH CHECK ADD  CONSTRAINT [FK_tbTextosBase_tbSistemaTiposTextoBase] FOREIGN KEY([IDTiposTextoBase])
REFERENCES [dbo].[tbSistemaTiposTextoBase] ([ID])

ALTER TABLE [dbo].[tbTextosBase] CHECK CONSTRAINT [FK_tbTextosBase_tbSistemaTiposTextoBase]

CREATE TABLE [dbo].[tbEstados](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Codigo] [nvarchar](6) NOT NULL,
	[Descricao] [nvarchar](50) NOT NULL,
	[Sistema] [bit] NOT NULL CONSTRAINT [DF_tbEstados_Sistema]  DEFAULT ((0)),
	[Ativo] [bit] NOT NULL CONSTRAINT [DF_tbEstados_Ativo]  DEFAULT ((1)),
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL CONSTRAINT [DF_tbEstados_DataAlteracao]  DEFAULT (getdate()),
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NULL,
	[IDEntidadeEstado] [bigint] NOT NULL,
	[IDTipoEstado] [bigint] NOT NULL,
	[Predefinido] [bit] NOT NULL CONSTRAINT [DF_tbEstados_Predefinido]  DEFAULT ((0)),
	[EstadoInicial] [bit] NOT NULL CONSTRAINT [DF_tbEstados_EstadoInicial]  DEFAULT ((0)),
 CONSTRAINT [PK_tbEstados] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

create unique index IX_tbEstados_Codigo on tbEstados (Codigo) 

ALTER TABLE [dbo].[tbEstados]  WITH CHECK ADD  CONSTRAINT [FK_tbEstados_tbSistemaEntidadesEstados] FOREIGN KEY([IDEntidadeEstado])
REFERENCES [dbo].[tbSistemaEntidadesEstados] ([ID])

ALTER TABLE [dbo].[tbEstados] CHECK CONSTRAINT [FK_tbEstados_tbSistemaEntidadesEstados]

ALTER TABLE [dbo].[tbEstados]  WITH CHECK ADD  CONSTRAINT [FK_tbEstados_tbSistemaTiposEstados] FOREIGN KEY([IDTipoEstado])
REFERENCES [dbo].[tbSistemaTiposEstados] ([ID])

ALTER TABLE [dbo].[tbEstados] CHECK CONSTRAINT [FK_tbEstados_tbSistemaTiposEstados]

CREATE TABLE [dbo].[tbEntidadesAnexos](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDEntidade] [bigint] NOT NULL,
	[IDTipoAnexo] [bigint] NULL,
	[Descricao] [nvarchar](255) NULL,
	[FicheiroOriginal] [nvarchar](255) NULL,
	[Ficheiro] [nvarchar](255) NOT NULL,
	[FicheiroThumbnail] [nvarchar](300) NULL,
	[Caminho] [nvarchar](max) NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbEntidadesAnexos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_tbEntidadesAnexos] UNIQUE NONCLUSTERED 
(
	[IDEntidade] ASC,
	[Ficheiro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[tbEntidadesAnexos] ADD  CONSTRAINT [DF_tbEntidadesAnexos_Sistema]  DEFAULT ((0)) FOR [Sistema]

ALTER TABLE [dbo].[tbEntidadesAnexos] ADD  CONSTRAINT [DF_tbEntidadesAnexos_Ativo]  DEFAULT ((1)) FOR [Ativo]

ALTER TABLE [dbo].[tbEntidadesAnexos]  WITH CHECK ADD  CONSTRAINT [FK_tbEntidadesAnexos_tbEntidades] FOREIGN KEY([IDEntidade])
REFERENCES [dbo].[tbEntidades] ([ID])

ALTER TABLE [dbo].[tbEntidadesAnexos] CHECK CONSTRAINT [FK_tbEntidadesAnexos_tbEntidades]

ALTER TABLE [dbo].[tbEntidadesAnexos]  WITH CHECK ADD  CONSTRAINT [FK_tbEntidadesAnexos_tbSistemaTiposAnexos] FOREIGN KEY([IDTipoAnexo])
REFERENCES [dbo].[tbSistemaTiposAnexos] ([ID])

ALTER TABLE [dbo].[tbEntidadesAnexos] CHECK CONSTRAINT [FK_tbEntidadesAnexos_tbSistemaTiposAnexos]

CREATE TABLE [dbo].[tbMedicosTecnicosAnexos](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IDMedicoTecnico] [bigint] NOT NULL,
	[IDTipoAnexo] [bigint] NULL,
	[Descricao] [nvarchar](255) NULL,
	[FicheiroOriginal] [nvarchar](255) NULL,
	[Ficheiro] [nvarchar](255) NOT NULL,
	[FicheiroThumbnail] [nvarchar](300) NULL,
	[Caminho] [nvarchar](max) NOT NULL,
	[Sistema] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[DataCriacao] [datetime] NOT NULL,
	[UtilizadorCriacao] [nvarchar](20) NOT NULL,
	[DataAlteracao] [datetime] NULL,
	[UtilizadorAlteracao] [nvarchar](20) NULL,
	[F3MMarcador] [timestamp] NULL,
 CONSTRAINT [PK_tbMedicosTecnicosAnexos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_tbMedicosTecnicosAnexos] UNIQUE NONCLUSTERED 
(
	[IDMedicoTecnico] ASC,
	[Ficheiro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[tbMedicosTecnicosAnexos] ADD  CONSTRAINT [DF_tbMedicosTecnicosAnexos_Sistema]  DEFAULT ((0)) FOR [Sistema]

ALTER TABLE [dbo].[tbMedicosTecnicosAnexos] ADD  CONSTRAINT [DF_tbMedicosTecnicosAnexos_Ativo]  DEFAULT ((1)) FOR [Ativo]

ALTER TABLE [dbo].[tbMedicosTecnicosAnexos]  WITH CHECK ADD  CONSTRAINT [FK_tbMedicosTecnicosAnexos_tbMedicosTecnicos] FOREIGN KEY([IDMedicoTecnico])
REFERENCES [dbo].[tbMedicosTecnicos] ([ID])

ALTER TABLE [dbo].[tbMedicosTecnicosAnexos] CHECK CONSTRAINT [FK_tbMedicosTecnicosAnexos_tbMedicosTecnicos]

ALTER TABLE [dbo].[tbMedicosTecnicosAnexos]  WITH CHECK ADD  CONSTRAINT [FK_tbMedicosTecnicosAnexos_tbSistemaTiposAnexos] FOREIGN KEY([IDTipoAnexo])
REFERENCES [dbo].[tbSistemaTiposAnexos] ([ID])

ALTER TABLE [dbo].[tbMedicosTecnicosAnexos] CHECK CONSTRAINT [FK_tbMedicosTecnicosAnexos_tbSistemaTiposAnexos]

ALTER TABLE [dbo].[tbTiposDocumento]  WITH CHECK ADD  CONSTRAINT [FK_tbTiposDocumento_tbEstados] FOREIGN KEY([IDEstado])
REFERENCES [dbo].[tbEstados] ([ID])

ALTER TABLE [dbo].[tbTiposDocumento] CHECK CONSTRAINT [FK_tbTiposDocumento_tbEstados]