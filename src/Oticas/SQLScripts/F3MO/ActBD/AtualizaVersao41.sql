/* ACT BD EMPRESA VERSAO 41*/

--incluir novas colunas na lista personalizada de clientes
EXEC('update [F3MOGeral].dbo.tbListasPersonalizadas set query=''select tbclientes.ID, tbclientes.Codigo, tbclientes.Nome, tbclientes.NContribuinte, tbclientes.Ativo, mt.Nome as DescricaoMedicoTecnico, tbclientes.Datanascimento, convert(nvarchar(MAX), tbclientes.Datanascimento, 105) as DiaNascimento, 
cc.Telefone, cc.Telemovel, en.Descricao as DescricaoEntidade1, et.Descricao as DescricaoEntidade2, lj.descricao as DescricaoLoja, isnull(tbclientes.saldo, 0) as Saldo, tbclientes.IdTipoEntidade, cast(tbclientes.nome as nvarchar(100)) as DescricaoSplitterLadoDireito ,tbclientes.UtilizadorCriacao
, cm.morada as DescricaoMorada, cp.codigo as codigopostal, cp.descricao as descricaocodigopostal 
from tbclientes  
left join tbLojas lj on tbclientes.idloja=lj.id
left join tbMedicosTecnicos mt on tbclientes.idmedicotecnico=mt.id
left join tbentidades en on tbclientes.identidade1=en.id
left join tbentidades et on tbclientes.identidade2=et.id
left join tbclientescontatos cc on tbclientes.id=cc.idcliente and cc.ordem=1
left join tbclientesmoradas cm on tbclientes.id=cm.idcliente and cm.ordem=1
left join tbcodigospostais cp on cp.id=cm.idcodigopostal ''
where id in (25,66,68)')

EXEC('
BEGIN
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE ID=25
DELETE [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] WHERE idlistapersonalizada=25
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Codigo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Nome'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 300)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DiaNascimento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Telefone'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Telemovel'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''NContribuinte'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDMedicoTecnico'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDEntidade1'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDEntidade2'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDLoja'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Saldo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 3, 1, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''UtilizadorCriacao'',  @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoMorada'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 3, 1, 500)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoPostal'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 3, 1, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoCodigoPostal'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 3, 1, 150)
END')

EXEC('
BEGIN
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE ID=66
DELETE [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] WHERE idlistapersonalizada=66
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Codigo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Nome'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 300)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DiaNascimento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Telefone'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Telemovel'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''NContribuinte'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDMedicoTecnico'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDEntidade1'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDEntidade2'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDLoja'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Saldo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 3, 1, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''UtilizadorCriacao'',  @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoMorada'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 3, 1, 500)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoPostal'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 3, 1, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoCodigoPostal'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 3, 1, 150)
END')

EXEC('
BEGIN
DECLARE @IDLista as bigint
SELECT @IDLista=ID FROM [F3MOGeral].[dbo].[tbListasPersonalizadas] WHERE ID=68
DELETE [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] WHERE idlistapersonalizada=68
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Codigo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Nome'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 300)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DiaNascimento'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Telefone'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Telemovel'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''NContribuinte'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDMedicoTecnico'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDEntidade1'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDEntidade2'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''IDLoja'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''Saldo'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 3, 1, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''UtilizadorCriacao'',  @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 1, 1, 150)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoMorada'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 3, 1, 500)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''CodigoPostal'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 3, 1, 100)
INSERT [F3MOGeral].[dbo].[tbColunasListasPersonalizadas] ([ColunaVista], [IDListaPersonalizada], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [ValorCondicao], [OperadorCondicao], [Tabela], [Visivel], [TipoColuna], [ColumnWidth]) VALUES (N''DescricaoCodigoPostal'', @IDLista, 0, 1, CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', CAST(N''2017-05-10 10:12:39.637'' AS DateTime), N''F3M'', NULL, NULL, N''tbClientes'', 3, 1, 150)
END')

--atualizar sp_AtualizaCCFornecedores
EXEC('DROP PROCEDURE [dbo].[sp_AtualizaCCFornecedores]')

EXEC('CREATE PROCEDURE [dbo].[sp_AtualizaCCFornecedores]  
	@lngidDocumento AS bigint = NULL,
	@lngidTipoDocumento AS bigint = NULL,
	@intAccao AS int = 0,
	@strUtilizador AS nvarchar(256) = '''',
	@lngidEntidade AS bigint = NULL
AS  BEGIN
SET NOCOUNT ON

DECLARE @strSqlQuery AS varchar(max),--variavel para querys dinamicos
	@strSqlQueryAux AS varchar(max),--variavel para querys dinamicos
	@strSqlQueryUpdates AS varchar(max),--variavel para querys dinamicos
	@strSqlQueryInsert AS varchar(max),--varivale para a parte do insert
	@strFiltro as nvarchar(1024),--variavel para a parte do insert
	@strFiltroIns as nvarchar(1024),--variavel para a parte do insert

	@ErrorMessage   varchar(2000),
	@ErrorSeverity  tinyint,
	@ErrorState     tinyint,
	@rowcount INT

BEGIN TRY
	--Verificar se o tipo de documento gere conta corrente
	IF EXISTS(SELECT ID FROM tbTiposDocumento WHERE ISNULL(GereContaCorrente,0)<>0 AND ID=@lngidTipoDocumento)
		BEGIN
		IF (@intAccao = 0) OR (@intAccao = 1)
			BEGIN
				IF @lngidDocumento>0
					BEGIN
						SET @strFiltro='' and IDDocumento='' + cast(@lngidDocumento as nvarchar(50))
						SET @strFiltroIns='' and DV.ID='' + cast(@lngidDocumento as nvarchar(50))
					END
				ELSE
					BEGIN
						SET @strFiltro=''''
						SET @strFiltroIns=''''
					END

				SET @strSqlQuery=''DELETE FROM tbCCFornecedores where IDTipoDocumento='' + cast(@lngidTipoDocumento as nvarchar(50)) + @strFiltro
				EXEC(@strSqlQuery)

				SET @strSqlQueryInsert = ''insert into tbCCFornecedores ([Natureza], [IDLoja], [IDTipoEntidade],[IDEntidade],[NomeFiscal],[IDTipoDocumento],[IDTipoDocumentoSeries],[IDDocumento],[NumeroDocumento],
										[DataDocumento],[Descricao], [IDMoeda], [TotalMoeda],[TotalMoedaReferencia],[TaxaConversao],[Ativo],[Sistema],[DataCriacao],[UtilizadorCriacao])''
								
				SELECT @strSqlQuery = @strSqlQueryInsert + '' select (case when (TD.Adiantamento=1 and TSN.Codigo=''''R'''') then ''''P'''' when (TD.Adiantamento=1 and TSN.Codigo=''''P'''') then ''''R'''' else TSN.Codigo end) as Natureza, DV.IDLoja, DV.IDTipoEntidade, DV.IDEntidade, DV.NomeFiscal, DV.IDTipoDocumento, DV.IDTiposDocumentoSeries, DV.ID as IDDocumento, DV.NumeroDocumento,  
									DV.DataDocumento, DV.Documento, DV.IDMoeda, DV.TotalMoedaDocumento, DV.TotalMoedaReferencia, DV.TaxaConversao, 1, 0, DV.DataCriacao, DV.UtilizadorCriacao 
									from tbdocumentoscompras DV left join tbTiposDocumento TD on TD.ID=DV.IDTipoDocumento
									left join tbTiposDocumentoSeries TDS on TDS.ID=DV.IDTiposDocumentoSeries
									left join tbSistemaNaturezas TSN on TD.IDSistemaNaturezas=TSN.ID
									where DV.IDTipoDocumento='' + cast(@lngidTipoDocumento as nvarchar(50)) + @strFiltroIns
				EXEC(@strSqlQuery)

				SELECT @strSqlQuery = @strSqlQueryInsert + '' select (case when (TD.Adiantamento=1 and TSN.Codigo=''''R'''') then ''''P'''' when (TD.Adiantamento=1 and TSN.Codigo=''''P'''') then ''''R'''' else TSN.Codigo end) as Natureza, DV.IDLoja, DV.IDTipoEntidade, DV.IDEntidade, DV.NomeFiscal, DV.IDTipoDocumento, DV.IDTiposDocumentoSeries, DV.ID as IDDocumento, DV.NumeroDocumento,  
									DV.DataDocumento, DV.Documento, DV.IDMoeda, DV.TotalMoedaDocumento, DV.TotalMoedaReferencia, DV.TaxaConversao, 1, 0, DV.DataCriacao, DV.UtilizadorCriacao 
									from tbdocumentoscompras DV left join tbTiposDocumento TD on TD.ID=DV.IDTipoDocumento
									left join tbTiposDocumentoSeries TDS on TDS.ID=DV.IDTiposDocumentoSeries
									left join tbSistemaNaturezas TSN on TD.IDSistemaNaturezas=TSN.ID
									where TD.Adiantamento=0 and TD.GeraPendente=0 and DV.IDTipoDocumento='' + cast(@lngidTipoDocumento as nvarchar(50)) + @strFiltroIns
				EXEC(@strSqlQuery)

				SELECT @strSqlQuery = @strSqlQueryInsert + '' select TSN.Codigo as Natureza, DV.IDLoja, DV.IDTipoEntidade, DV.IDEntidade, DV.NomeFiscal, DV.IDTipoDocumento, DV.IDTiposDocumentoSeries, DV.ID as IDDocumento, DV.NumeroDocumento,  
									DV.DataDocumento, DV.Documento, DV.IDMoeda, DV.TotalMoedaDocumento+DV.TotalDescontos, DV.TotalMoedaReferencia+(DV.TotalDescontos*DV.TaxaConversao), DV.TaxaConversao, 1, 0, DV.DataCriacao, DV.UtilizadorCriacao 
									from tbpagamentoscompras DV left join tbTiposDocumento TD on TD.ID=DV.IDTipoDocumento
									left join tbTiposDocumentoSeries TDS on TDS.ID=DV.IDTiposDocumentoSeries
									left join tbSistemaNaturezas TSN on TD.IDSistemaNaturezas=TSN.ID
									where DV.IDTipoDocumento='' + cast(@lngidTipoDocumento as nvarchar(50)) + @strFiltroIns
				EXEC(@strSqlQuery)
			END
		ELSE
			BEGIN
				IF @lngidDocumento>0
					BEGIN
						SET @strFiltro='' and IDDocumento='' + cast(@lngidDocumento as nvarchar(50))
						SET @strFiltroIns='' and DV.ID='' + cast(@lngidDocumento as nvarchar(50))
					END

				SET @strSqlQuery=''DELETE FROM tbCCFornecedores where IDTipoDocumento='' + cast(@lngidTipoDocumento as nvarchar(50)) + @strFiltro
				EXEC(@strSqlQuery)
			END

		  UPDATE tbfornecedores set saldo=tbcc.saldo FROM tbfornecedores Cli
			   INNER JOIN (
			   select identidade, isnull(sum(case when natureza=''P'' then totalmoedareferencia else -totalmoedareferencia end ),0) as saldo from tbCCFornecedores where identidade=@lngidEntidade group by IDEntidade) tbcc
			   ON Cli.ID= tbcc.identidade
	END
END TRY
	BEGIN CATCH
		SET @ErrorMessage  = ERROR_MESSAGE()
		SET @ErrorSeverity = ERROR_SEVERITY()
		SET @ErrorState    = ERROR_STATE()
		RAISERROR(@ErrorMessage, @ErrorSeverity,@ErrorState)
	END CATCH
END')


--Adicionar novo parâmetro lojas
EXEC('
BEGIN
DELETE FROM [tbParametrosCamposContexto] WHERE CodigoCampo=''PCM_UPC_Desconto''
INSERT INTO tbParametrosCamposContexto (IDParametroContexto, [CodigoCampo], [DescricaoCampo], [IDTipoDados],  [ValorCampo], [ValorMax], [ValorMin], [ValorReadOnly], [Ordem], [Sistema], [Ativo], [DataCriacao], [UtilizadorCriacao])
SELECT tbParametrosContexto.id as IDParametroContexto, ''PCM_UPC_Desconto'' as [CodigoCampo], ''PCM_UPC_Desconto'' as [DescricaoCampo], 9 as [IDTipoDados],  N''0'' as [ValorCampo], N''1'' as [ValorMax], N''0'' as [ValorMin], 0 as [ValorReadOnly], 3 as [Ordem], 0 as [Sistema], 1 as [Ativo], getdate() as [DataCriacao], N''F3M'' as [UtilizadorCriacao] 
FROM tbParametrosContexto where Codigo=''Stocks''
END')

--atribuir parâmetros por defeito
EXEC('update tbParametrosCamposContexto set conteudolista=''CustoMedio|UPC|CustoPadrao'', valorcampo=0, ativo=0 where descricaocampo in (''ValorizacaoDoStock'')')
EXEC('update tbParametrosCamposContexto set conteudolista=''CustoMedio|UPC|CustoPadrao'', valorcampo=0, ativo=0 where codigocampo in (''CustoMecVendidas'')')
EXEC('update tbParametrosCamposContexto set conteudolista=''Ignorar|DesativarLote'', valorcampo=0 where codigocampo in (''FinalLote'')')
EXEC('update tbParametrosCamposContexto set conteudolista=''Ignorar|AlertarCom'' ,valorcampo=0 where codigocampo in (''DataExpirEntrada'', ''DataExpirSaida'')')
EXEC('update tbParametrosCamposContexto set valorcampo=null where codigocampo in (''DataAnteEntrada'', ''DataAnteSaida'')')
EXEC('update tbParametrosCamposContexto set valorcampo=''False'' where codigocampo in (''ReativarLote'')')

--ativar modulos da contabilidade
EXEC('update tbContabilidadeConfiguracaomodulos set ativo=1 where codigo in (''001'',''006'')')

--aviso de nova versão
EXEC('
BEGIN
DELETE [F3MOGeral].dbo.tbNotificacoes Where versao=''1.18.0''
insert into [F3MOGeral].dbo.tbNotificacoes (Produto, Versao, Tipo, DataInicio, DataFim, Titulo, Texto, Link, Ordem, Visto, IdLoja, Ativo, Sistema, DataCriacao, UtilizadorCriacao) 
values (''Prisma'', ''1.18.0'', ''A'', ''2019-06-04 00:00'', ''2019-06-11 08:00'', ''Próxima atualização:'', ''O serviço poderá estar inativo durante breves minutos. Agradecemos a sua compreensão.'', ''MaisValias.pdf'', 2, 0, 1, 1, 0, getdate(), ''F3M'' ) 
insert into [F3MOGeral].dbo.tbNotificacoes (Produto, Versao, Tipo, DataInicio, DataFim, Titulo, Texto, Link, Ordem, Visto, IdLoja, Ativo, Sistema, DataCriacao, UtilizadorCriacao) 
values (''Prisma'', ''1.18.0'', ''V'', ''2019-06-11 08:00'', ''2019-06-11 08:00'', ''Funcionalidades da versão'', ''
<li>VER PREÇOS NOS DOCUMENTOS DE STOCK E COMPRAS</li>
<li>EXPORTAÇÃO PARA A CONTABILIDADE</li>
<li>DOCUMENTOS DE STOCK</li>
<li>DOCUMENTOS DE CONTA CORRENTE</li>
<li>MAIS INFORMAÇÃO NA FICHA DE CLIENTES</li>
<li>VALORES POR DEFEITO NA CRIAÇÃO DE UMA LOJA</li>
<li>PREÇOS NÃO INCLUEM DESCONTOS COMERCIAIS</li>
'', ''MaisValias.pdf'', 2, 0, 1, 1, 0, getdate(), ''F3M'' ) 
END')