Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports F3M.Modelos.Autenticacao
Imports System.Data.Entity
Imports F3M.Modelos.ConstantesKendo
Imports System.IO
Imports System.Data.SqlClient
Imports Kendo.Mvc.UI
Imports Kendo.Mvc.Extensions
Imports F3M.Models.Communication

Namespace Repositorio
    Public Class RepositorioClientes
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbClientes, Clientes)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbClientes)) As IQueryable(Of Clientes)
            Dim listaCli As List(Of Clientes) = query.ToList().Select(Function(e) New Clientes With {
                    .ID = e.ID, .Codigo = e.Codigo, .Nome = e.Nome, .Descricao = e.Nome, .Abreviatura = e.Abreviatura, .Apelido = e.Apelido,
                    .Foto = e.Foto, .FotoCaminho = e.FotoCaminho, .FotoAnterior = e.Foto, .FotoCaminhoAnterior = e.FotoCaminho, .Observacoes = e.Observacoes,
                    .IDTipoEntidade = e.IDTipoEntidade, .DataValidade = e.DataValidade, .DataNascimento = e.DataNascimento, .PermiteComunicacoes = e.PermiteComunicacoes,
                    .Comissao1 = e.Comissao1, .Comissao2 = e.Comissao2, .ControloCredito = e.ControloCredito, .IDEmissaoFatura = e.IDEmissaoFatura, .DescricaoEmissaoFatura = If(e.tbSistemaEmissaoFatura IsNot Nothing, e.tbSistemaEmissaoFatura.Descricao, String.Empty),
                    .IDEmissaoPackingList = e.IDEmissaoPackingList, .DescricaoEmissaoPackingList = If(e.tbSistemaEmissaoPackingList IsNot Nothing, e.tbSistemaEmissaoPackingList.Descricao, String.Empty),
                    .IDFormaExpedicao = e.IDFormaExpedicao, .DescricaoFormaExpedicao = If(e.tbFormasExpedicao IsNot Nothing, e.tbFormasExpedicao.Descricao, String.Empty),
                    .IDSegmentoMercado = e.IDSegmentoMercado, .DescricaoSegmentoMercado = If(e.tbSegmentosMercado IsNot Nothing, e.tbSegmentosMercado.Descricao, String.Empty),
                    .IDSetorAtividade = e.IDSetorAtividade, .DescricaoSetorAtividade = If(e.tbSetoresAtividade IsNot Nothing, e.tbSetoresAtividade.Descricao, String.Empty),
                    .IDPrecoSugerido = e.IDPrecoSugerido, .DescricaoPrecoSugerido = If(e.tbSistemaCodigosPrecos IsNot Nothing, e.tbSistemaCodigosPrecos.Descricao, String.Empty), .EmitePedidoLiquidacao = e.EmitePedidoLiquidacao, .Prioridade = e.Prioridade, .Plafond = e.Plafond,
                    .DescricaoTipoEntidade = If(e.tbSistemaTiposEntidade IsNot Nothing, e.tbSistemaTiposEntidade.Tipo, String.Empty), .IDPais = e.IDPais, .DescricaoPais = If(e.tbPaises IsNot Nothing, e.tbPaises.Descricao, String.Empty),
                    .NMaximoDiasAtraso = e.NMaximoDiasAtraso,
                    .IDCondicaoPagamento = e.IDCondicaoPagamento, .DescricaoCondicaoPagamento = If(e.tbCondicoesPagamento IsNot Nothing, e.tbCondicoesPagamento.Descricao, String.Empty), .IDEspacoFiscal = e.IDEspacoFiscal,
                    .DescricaoEspacoFiscal = If(e.tbSistemaEspacoFiscal IsNot Nothing, e.tbSistemaEspacoFiscal.Descricao, String.Empty), .CodigoEspacoFiscal = If(e.tbSistemaEspacoFiscal IsNot Nothing, e.tbSistemaEspacoFiscal.Codigo, String.Empty), .IDFormaPagamento = e.IDFormaPagamento, .DescricaoFormaPagamento = If(e.tbFormasPagamento IsNot Nothing, e.tbFormasPagamento.Descricao, String.Empty),
                    .IDIdioma = e.IDIdioma, .DescricaoIdioma = If(e.tbIdiomas IsNot Nothing, e.tbIdiomas.Descricao, String.Empty), .IDLocalOperacao = e.IDLocalOperacao, .DescricaoLocalOperacao = If(e.tbSistemaRegioesIVA IsNot Nothing, e.tbSistemaRegioesIVA.Descricao, String.Empty), .CodigoLocalOperacao = If(e.tbSistemaRegioesIVA IsNot Nothing, e.tbSistemaRegioesIVA.Codigo, String.Empty),
                    .IDMoeda = e.IDMoeda, .DescricaoMoeda = If(e.tbMoedas IsNot Nothing, e.tbMoedas.Descricao, String.Empty),
                    .CodigoSistemaMoeda = If(e.tbMoedas IsNot Nothing, If(e.tbMoedas.tbSistemaMoedas IsNot Nothing, e.tbMoedas.tbSistemaMoedas.Codigo, String.Empty), String.Empty),
                    .TaxaConversao = If(e.tbMoedas IsNot Nothing, e.tbMoedas.TaxaConversao, 0),
                    .SiglaPais = If(e.tbPaises.tbSistemaSiglasPaises IsNot Nothing, e.tbPaises.tbSistemaSiglasPaises.Sigla, String.Empty),
                    .CasasDecimaisIva = If(e.tbMoedas IsNot Nothing, e.tbMoedas.CasasDecimaisIva, CByte(0)),
                    .CasasDecimaisPrecosUnitarios = If(e.tbMoedas IsNot Nothing, e.tbMoedas.CasasDecimaisPrecosUnitarios, CByte(0)),
                    .CasasDecimaisTotais = If(e.tbMoedas IsNot Nothing, e.tbMoedas.CasasDecimaisTotais, CByte(0)),
                    .Simbolo = If(e.tbMoedas IsNot Nothing, e.tbMoedas.Simbolo, String.Empty),
                    .DescricaoSplitterLadoDireito = e.Nome,
                    .IDProfissao = e.IDProfissao, .DescricaoProfissao = If(e.tbProfissoes IsNot Nothing, e.tbProfissoes.Descricao, String.Empty),
                    .IDRegimeIva = e.IDRegimeIva, .DescricaoRegimeIva = If(e.tbSistemaRegimeIVA IsNot Nothing, e.tbSistemaRegimeIVA.Descricao, String.Empty),
                    .IDTipoPessoa = e.IDTipoPessoa,
                    .CodigoTipoPessoa = If(e.tbSistemaTiposPessoa IsNot Nothing, e.tbSistemaTiposPessoa.Codigo, String.Empty),
                    .DescricaoTipoPessoa = If(e.tbSistemaTiposPessoa IsNot Nothing, e.tbSistemaTiposPessoa.Descricao, String.Empty),
                    .IDMedicoTecnico = e.IDMedicoTecnico, .DescricaoMedicoTecnico = If(e.tbMedicosTecnicos IsNot Nothing, e.tbMedicosTecnicos.Nome, String.Empty),
                    .TituloAcademico = e.TituloAcademico, .IvaCaixa = e.IvaCaixa, .NContribuinte = e.NContribuinte,
                    .NIB = e.NIB, .Avisos = e.Avisos, .CartaoCidadao = e.CartaoCidadao, .Contabilidade = e.Contabilidade,
                    .Desconto1 = e.Desconto1, .Desconto2 = e.Desconto2, .IDSexo = e.IDSexo, .DescricaoSexo = If(e.tbSistemaSexo IsNot Nothing, e.tbSistemaSexo.Descricao, String.Empty),
                    .Ativo = e.Ativo, .Sistema = e.Sistema, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao,
                    .IDEntidade1 = e.IDEntidade1, .IDEntidade2 = e.IDEntidade2, .DescricaoEntidade1 = If(e.tbEntidades IsNot Nothing, e.tbEntidades.Descricao, String.Empty), .DescricaoEntidade2 = If(e.tbEntidades1 IsNot Nothing, e.tbEntidades1.Descricao, String.Empty),
                    .NumeroBeneficiario1 = e.NumeroBeneficiario1, .NumeroBeneficiario2 = e.NumeroBeneficiario2, .Parentesco1 = e.Parentesco1, .Parentesco2 = e.Parentesco2,
                    .IDLoja = e.IDLoja, .DescricaoLoja = If(e.tbLojas IsNot Nothing, e.tbLojas.Descricao, String.Empty), .Saldo = 0,
                    .Telefone = If(e.tbClientesContatos IsNot Nothing AndAlso e.tbClientesContatos.Count > 0, e.tbClientesContatos.OrderBy(Function(o) o.Ordem).FirstOrDefault.Telefone, String.Empty),
                    .Telemovel = If(e.tbClientesContatos IsNot Nothing AndAlso e.tbClientesContatos.Count > 0, e.tbClientesContatos.OrderBy(Function(o) o.Ordem).FirstOrDefault.Telemovel, String.Empty),
                    .EMail = If(e.tbClientesContatos IsNot Nothing AndAlso e.tbClientesContatos.Count > 0, e.tbClientesContatos.OrderBy(Function(o) o.Ordem).FirstOrDefault.Email, String.Empty),
                    .IDContactoPorDefeito = If(e.tbClientesContatos IsNot Nothing AndAlso e.tbClientesContatos.Where(Function(w) w.Ordem = CLng(1)).Count > 0,
                                                 e.tbClientesContatos.Where(Function(w) w.Ordem = CLng(1)).FirstOrDefault.ID, CLng(0)),
                    .TelefonePorDefeito = If(e.tbClientesContatos IsNot Nothing AndAlso e.tbClientesContatos.Where(Function(w) w.Ordem = CLng(1)).Count > 0,
                                                 e.tbClientesContatos.Where(Function(w) w.Ordem = CLng(1)).FirstOrDefault.Telefone, String.Empty),
                    .TelemovelPorDefeito = If(e.tbClientesContatos IsNot Nothing AndAlso e.tbClientesContatos.Where(Function(w) w.Ordem = CLng(1)).Count > 0,
                                                 e.tbClientesContatos.Where(Function(w) w.Ordem = CLng(1)).FirstOrDefault.Telemovel, String.Empty),
                    .EMailPorDefeito = If(e.tbClientesContatos IsNot Nothing AndAlso e.tbClientesContatos.Where(Function(w) w.Ordem = CLng(1)).Count > 0,
                                                 e.tbClientesContatos.Where(Function(w) w.Ordem = CLng(1)).FirstOrDefault.Email, String.Empty),
                    .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador,
                    .IDPaisFiscal = If(e.tbClientesMoradas IsNot Nothing AndAlso e.tbClientesMoradas.Count > 0, e.tbClientesMoradas.OrderBy(Function(o) o.Ordem).FirstOrDefault.IDPais, Nothing),
                    .DescricaoPaisFiscal = If(e.tbClientesMoradas IsNot Nothing AndAlso e.tbClientesMoradas.Count > 0,
                                                 If(e.tbClientesMoradas.OrderBy(Function(o) o.Ordem).FirstOrDefault.tbPaises IsNot Nothing,
                                                 e.tbClientesMoradas.OrderBy(Function(o) o.Ordem).FirstOrDefault.tbPaises.Descricao, String.Empty), String.Empty),
                    .MoradaFiscal = If(e.tbClientesMoradas IsNot Nothing AndAlso e.tbClientesMoradas.Count > 0, e.tbClientesMoradas.OrderBy(Function(o) o.Ordem).FirstOrDefault.Morada, String.Empty),
                    .IDCodigoPostalFiscal = If(e.tbClientesMoradas IsNot Nothing AndAlso e.tbClientesMoradas.Count > 0, e.tbClientesMoradas.OrderBy(Function(o) o.Ordem).FirstOrDefault.IDCodigoPostal, Nothing),
                    .DescricaoCodigoPostalFiscal = If(e.tbClientesMoradas IsNot Nothing AndAlso e.tbClientesMoradas.Count > 0,
                                                 If(e.tbClientesMoradas.OrderBy(Function(o) o.Ordem).FirstOrDefault.tbCodigosPostais IsNot Nothing,
                                                 e.tbClientesMoradas.OrderBy(Function(o) o.Ordem).FirstOrDefault.tbCodigosPostais.Descricao, String.Empty), String.Empty),
                    .CodigoPostalFiscal = If(e.tbClientesMoradas IsNot Nothing AndAlso e.tbClientesMoradas.Count > 0,
                                                 If(e.tbClientesMoradas.OrderBy(Function(o) o.Ordem).FirstOrDefault.tbCodigosPostais IsNot Nothing,
                                                 e.tbClientesMoradas.OrderBy(Function(o) o.Ordem).FirstOrDefault.tbCodigosPostais.Codigo, String.Empty), String.Empty),
                    .IDDistritoFiscal = If(e.tbClientesMoradas IsNot Nothing AndAlso e.tbClientesMoradas.Count > 0, e.tbClientesMoradas.OrderBy(Function(o) o.Ordem).FirstOrDefault.IDDistrito, Nothing),
                    .DescricaoDistritoFiscal = If(e.tbClientesMoradas IsNot Nothing AndAlso e.tbClientesMoradas.Count > 0,
                                                 If(e.tbClientesMoradas.OrderBy(Function(o) o.Ordem).FirstOrDefault.tbDistritos IsNot Nothing,
                                                 e.tbClientesMoradas.OrderBy(Function(o) o.Ordem).FirstOrDefault.tbDistritos.Descricao, String.Empty), String.Empty),
                    .IDConcelhoFiscal = If(e.tbClientesMoradas IsNot Nothing AndAlso e.tbClientesMoradas.Count > 0, e.tbClientesMoradas.OrderBy(Function(o) o.Ordem).FirstOrDefault.IDConcelho, Nothing),
                    .DescricaoConcelhoFiscal = If(e.tbClientesMoradas IsNot Nothing AndAlso e.tbClientesMoradas.Count > 0,
                                                 If(e.tbClientesMoradas.OrderBy(Function(o) o.Ordem).FirstOrDefault.tbConcelhos IsNot Nothing,
                                                 e.tbClientesMoradas.OrderBy(Function(o) o.Ordem).FirstOrDefault.tbConcelhos.Descricao, String.Empty), String.Empty),
                     .IDMoradaPorDefeito = If(e.tbClientesMoradas IsNot Nothing AndAlso e.tbClientesMoradas.Where(Function(w) w.Ordem = CLng(1)).Count > 0,
                                                 e.tbClientesMoradas.Where(Function(w) w.Ordem = CLng(1)).FirstOrDefault.ID, 0),
                     .MoradaPorDefeito = If(e.tbClientesMoradas IsNot Nothing AndAlso e.tbClientesMoradas.Where(Function(w) w.Ordem = CLng(1)).Count > 0,
                                                 e.tbClientesMoradas.Where(Function(w) w.Ordem = CLng(1)).FirstOrDefault.Morada, String.Empty),
                     .IDPaisPorDefeito = If(e.tbClientesMoradas IsNot Nothing AndAlso e.tbClientesMoradas.Where(Function(w) w.Ordem = CLng(1)).Count > 0,
                                                 e.tbClientesMoradas.Where(Function(w) w.Ordem = CLng(1)).FirstOrDefault.IDPais, Nothing),
                    .DescricaoPaisPorDefeito = If(e.tbClientesMoradas IsNot Nothing AndAlso e.tbClientesMoradas.Where(Function(w) w.Ordem = CLng(1)).Count > 0,
                                                 If(e.tbClientesMoradas.Where(Function(w) w.Ordem = CLng(1)).FirstOrDefault.tbPaises IsNot Nothing,
                                                 e.tbClientesMoradas.Where(Function(w) w.Ordem = CLng(1)).FirstOrDefault.tbPaises.Descricao, String.Empty), String.Empty),
                    .IDCodigoPostalPorDefeito = If(e.tbClientesMoradas IsNot Nothing AndAlso e.tbClientesMoradas.Where(Function(w) w.Ordem = CLng(1)).Count > 0,
                                                 e.tbClientesMoradas.Where(Function(w) w.Ordem = CLng(1)).FirstOrDefault.IDCodigoPostal, Nothing),
                    .DescricaoCodigoPostalPorDefeito = If(e.tbClientesMoradas IsNot Nothing AndAlso e.tbClientesMoradas.Where(Function(w) w.Ordem = CLng(1)).Count > 0,
                                                 If(e.tbClientesMoradas.Where(Function(w) w.Ordem = CLng(1)).FirstOrDefault.tbCodigosPostais IsNot Nothing,
                                                 e.tbClientesMoradas.Where(Function(w) w.Ordem = CLng(1)).FirstOrDefault.tbCodigosPostais.Codigo, String.Empty), String.Empty),
                    .IDDistritoPorDefeito = If(e.tbClientesMoradas IsNot Nothing AndAlso e.tbClientesMoradas.Where(Function(w) w.Ordem = CLng(1)).Count > 0, e.tbClientesMoradas.Where(Function(w) w.Ordem = CLng(1)).FirstOrDefault.IDDistrito, Nothing),
                    .DescricaoDistritoPorDefeito = If(e.tbClientesMoradas IsNot Nothing AndAlso e.tbClientesMoradas.Where(Function(w) w.Ordem = CLng(1)).Count > 0,
                                                 If(e.tbClientesMoradas.Where(Function(w) w.Ordem = CLng(1)).FirstOrDefault.tbDistritos IsNot Nothing,
                                                 e.tbClientesMoradas.Where(Function(w) w.Ordem = CLng(1)).FirstOrDefault.tbDistritos.Descricao, String.Empty), String.Empty),
                    .IDConcelhoPorDefeito = If(e.tbClientesMoradas IsNot Nothing AndAlso e.tbClientesMoradas.Where(Function(w) w.Ordem = CLng(1)).Count > 0, e.tbClientesMoradas.Where(Function(w) w.Ordem = CLng(1)).FirstOrDefault.IDConcelho, Nothing),
                    .DescricaoConcelhoPorDefeito = If(e.tbClientesMoradas IsNot Nothing AndAlso e.tbClientesMoradas.Where(Function(w) w.Ordem = CLng(1)).Count > 0,
                                                 If(e.tbClientesMoradas.Where(Function(w) w.Ordem = CLng(1)).FirstOrDefault.tbConcelhos IsNot Nothing,
                                                 e.tbClientesMoradas.Where(Function(w) w.Ordem = CLng(1)).FirstOrDefault.tbConcelhos.Descricao, String.Empty), String.Empty),
                     .Idade = ClsUtilitarios.CalculaIdade(.DataNascimento),
                     .Prazo = If(e.tbCondicoesPagamento IsNot Nothing, e.tbCondicoesPagamento.Prazo, Nothing),
                     .ValorCondicao = If(e.tbCondicoesPagamento IsNot Nothing, e.tbCondicoesPagamento.ValorCondicao, Nothing),
                     .CodigoTipoCondDataVencimento = If(e.tbCondicoesPagamento IsNot Nothing AndAlso e.tbCondicoesPagamento.tbSistemaTiposCondDataVencimento IsNot Nothing, e.tbCondicoesPagamento.tbSistemaTiposCondDataVencimento.Codigo, String.Empty),
                     .CodCodigoPostalFiscal = If(e.tbClientesMoradas IsNot Nothing AndAlso e.tbClientesMoradas.Count > 0,
                                                 If(e.tbClientesMoradas.OrderBy(Function(o) o.Ordem).FirstOrDefault.tbCodigosPostais IsNot Nothing,
                                                 e.tbClientesMoradas.OrderBy(Function(o) o.Ordem).FirstOrDefault.tbCodigosPostais.Codigo, String.Empty), String.Empty)}).ToList()

            Return listaCli.AsQueryable
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbClientes)) As IQueryable(Of Clientes)
            Return ListaCamposTodos(query.Take(TamanhoDados.NumeroMaximo))
        End Function

        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of Clientes)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        Private Sub FiltraQueryEspecifico(inFiltro As ClsF3MFiltro, ByRef query As IQueryable(Of tbClientes))
            ' --- ESPECIFICO ---
            Dim tipoEnt As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDTiposEntidade, GetType(Long))
            Dim IDTipoEnt As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDTipoEntidade, GetType(Long))

            If tipoEnt > 0 Then query = query.Where(Function(w) w.IDTipoEntidade = tipoEnt)

            If IDTipoEnt <> 0 Then query = query.Where(Function(w) w.IDTipoEntidade = IDTipoEnt AndAlso w.Ativo)

            AplicaFiltrosEOrdenacoesDasVistas(inFiltro, query, True)
        End Sub

        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbClientes)
            Dim query As IQueryable(Of tbClientes) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto
            Dim IDTipoDoc As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDTipoDocumento, GetType(Long))
            Dim codMod As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "CodigoModulo", GetType(String))
            Dim ID As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.ID, GetType(Long))

            ' --- GENERICO ---
            ' COMBO
            If Not String.IsNullOrEmpty(filtroTxt) Then query = query.Where(Function(w) w.Nome.Contains(filtroTxt))

            ' --- ESPECIFICO ---
            If ID <> 0 Then query = query.Where(Function(w) w.ID = ID)

            FiltraQueryEspecifico(inFiltro, query)

            If IDTipoDoc <> 0 AndAlso Not String.IsNullOrEmpty(codMod) Then FiltraTipoDocEspecifico(inFiltro, query)

            Return query
        End Function

        Public Function GetClienteWithTransaction(ByVal ID As Long, inCtx As BD.Dinamica.Aplicacao) As Clientes
            Dim query As IQueryable(Of tbClientes) = inCtx.tbClientes.Where(Function(f) f.ID = ID)

            Return ListaCamposTodos(query).FirstOrDefault()
        End Function

        ''' <summary>
        ''' Funcao que retorna o cliente by ID
        ''' </summary>
        ''' <param name="inIDCliente"></param>
        ''' <returns></returns>
        Public Function GetCliente(ByVal inIDCliente As Long) As Clientes
            Return GetClienteWithTransaction(inIDCliente, BDContexto)
        End Function

        ''' <summary>
        ''' Funcao que preenche os dados da entidade para os docs
        ''' </summary>
        ''' <typeparam name="M"></typeparam>
        ''' <param name="inIDEntidade"></param>
        ''' <param name="inModelo"></param>
        Public Sub PreencheEntidadeForClass(Of M)(inIDEntidade As Long, inModelo As M)
            'obtem entidade por ID
            Dim cli As New Oticas.Clientes
            cli = GetCliente(inIDEntidade)

            'preenche a entidade por defeito
            With CObj(inModelo)
                .IDEntidade = cli.ID : .DescricaoEntidade = cli.Nome : .NomeFiscal = cli.Nome : .CodigoEntidade = cli.Codigo

                .IDCondicaoPagamento = cli.IDCondicaoPagamento : .DescricaoCondicaoPagamento = cli.DescricaoCondicaoPagamento

                .IDMoeda = cli.IDMoeda : .DescricaoMoeda = cli.DescricaoMoeda : .TaxaConversao = cli.TaxaConversao

                .ContribuinteFiscal = cli.NContribuinte

                .IDEspacoFiscal = cli.IDEspacoFiscal : .DescricaoEspacoFiscal = cli.DescricaoEspacoFiscal

                .IDRegimeIva = cli.IDRegimeIva : .DescricaoRegimeIva = cli.DescricaoRegimeIva

                .IDLocalOperacao = cli.IDLocalOperacao : .DescricaoLocalOperacao = cli.DescricaoLocalOperacao

                .IDPaisFiscal = cli.IDPaisFiscal : .DescricaoPaisFiscal = cli.DescricaoPaisFiscal

                .MoradaFiscal = cli.MoradaFiscal

                .IDCodigoPostalFiscal = cli.IDCodigoPostalFiscal : .DescricaoCodigoPostalFiscal = cli.CodCodigoPostalFiscal

                .IDConcelhoFiscal = cli.IDConcelhoFiscal : .DescricaoConcelhoFiscal = cli.DescricaoConcelhoFiscal

                .IDDistritoFiscal = cli.IDDistritoFiscal : .DescricaoDistritoFiscal = cli.DescricaoDistritoFiscal

                'entidades 1 e 2
                .IDEntidade1 = cli.IDEntidade1 : .DescricaoEntidade1 = cli.DescricaoEntidade1 : .NumeroBeneficiario1 = cli.NumeroBeneficiario1 : .Parentesco1 = cli.Parentesco1
                .IDEntidade2 = cli.IDEntidade2 : .DescricaoEntidade2 = cli.DescricaoEntidade2 : .NumeroBeneficiario2 = cli.NumeroBeneficiario2 : .Parentesco2 = cli.Parentesco2
                'idade
                .Idade = ClsUtilitarios.CalculaIdade(cli.DataNascimento) : .Idade = If(.Idade <> 0, .Idade, Nothing)

                If .GeraPendente Then
                    .DataVencimento = ClsUtilitarios.CalculaDataVencimento(Date.Now, cli.Prazo, cli.ValorCondicao, cli.CodigoTipoCondDataVencimento)
                End If
            End With
        End Sub
#End Region

#Region "F4"
        Public Function ListaPorTipoDoc(request As DataSourceRequest, filtro As ClsF3MFiltro) As DataSourceResult
            Dim query As IQueryable(Of Oticas.Clientes) = AplicaQueryListaPersonalizada(filtro)

            Dim ID As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(filtro, CamposGenericos.ID, GetType(Long))

            If ID <> 0 Then query = query.Where(Function(w) w.ID = ID).AsQueryable

            FiltraTipoDocEspecificoF4(filtro, query)
            AplicaFiltroAtivo(filtro, query)

            Dim total As Long = query.Count()

            If total = 0 Then Return New DataSourceResult With {.Data = New Clientes, .Total = 0}

            Dim data As IEnumerable(Of Oticas.Clientes) = query.ToDataSourceResult(request).Data
            Dim ids As Long() = data.Select(Function(w) w.ID).ToArray()

            Return New DataSourceResult With {.Data = ListaCamposTodos(tabela.Where(Function(w) ids.Contains(w.ID))).ToList(), .Total = total}
        End Function

        Private Sub FiltraTipoDocEspecificoF4(inFiltro As ClsF3MFiltro, ByRef query As IQueryable(Of Clientes))
            Dim IDTipoDoc As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDTipoDocumento, GetType(Long))
            Dim codMod As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "CodigoModulo", GetType(String))

            If IDTipoDoc > 0 AndAlso Not ClsTexto.ENuloOuVazio(codMod) Then

                Dim listIds As List(Of Long) = (From td In BDContexto.tbTiposDocumento
                                                Join tdp In BDContexto.tbTiposDocumentoTipEntPermDoc On td.ID Equals tdp.IDTiposDocumento
                                                Join tem In BDContexto.tbSistemaTiposEntidadeModulos On tem.ID Equals tdp.IDSistemaTiposEntidadeModulos
                                                Join m In BDContexto.tbSistemaModulos On m.ID Equals tem.IDSistemaModulos
                                                Join te In BDContexto.tbSistemaTiposEntidade On te.ID Equals tem.IDSistemaTiposEntidade
                                                Where m.Codigo = codMod AndAlso td.ID = IDTipoDoc
                                                Select te.ID).ToList

                If listIds IsNot Nothing Then
                    query = query.Where(Function(w) listIds.Contains(w.IDTipoEntidade))

                    Dim blnRegistarCosumidorFinal As Boolean = (From x In BDContexto.tbTiposDocumento
                                                                Where x.ID = IDTipoDoc
                                                                Select x.RegistarCosumidorFinal).FirstOrDefault()

                    If Not blnRegistarCosumidorFinal Then
                        query = query.Where(Function(w) w.Codigo <> "CF")
                    End If

                Else
                    query = query.Where(Function(w) w.IDTipoEntidade = -1)
                End If
            End If

        End Sub
#End Region

#Region "ESCRITA"
        ' ADICIONA POR OBJETO
        Public Overrides Sub AdicionaObj(ByRef inModelo As Clientes, inFiltro As ClsF3MFiltro)
            inModelo.IDLoja = ClsF3MSessao.RetornaLojaID

            inModelo.IDPais = inModelo.IDPaisPorDefeito
            inModelo.DescricaoPais = inModelo.DescricaoPaisPorDefeito

            If inModelo.IDPais Is Nothing Then
                inModelo.IDPais = 184
                inModelo.DescricaoPais = "Portugal"
            End If

            If inModelo.IDLocalOperacao Is Nothing Then
                inModelo.IDLocalOperacao = 1
                inModelo.DescricaoLocalOperacao = "Continente"
            End If

            If inModelo.Codigo.Trim.Replace(" ", "") = "999999990" Then
                Throw New Exception(Traducao.EstruturaDocumentos.CodigoConsumidorFinal)
            End If

            If inModelo.Nome.IndexOf(",") > 0 OrElse inModelo.Nome.IndexOf(":") > 0 Then
                Throw New Exception(Traducao.EstruturaDocumentos.CaracteresInvalidos)
            End If

            If Not ClsF3MSessao.EmDesenvolvimento AndAlso inModelo.IDPais = 184 AndAlso Not ClsUtilitarios.ValidaNIF(inModelo.NContribuinte) Then
                Throw New Exception(ClsTexto.Traduz(Traducao.EstruturaEmpresas.NIFInvalido))
            End If

            If ClsF3MSessao.RetornaParametros.Lojas.ParametroArtigoCodigo.ToLower = "true" Then
                If IsNumeric(inModelo.Codigo) Then
                    Using rp As New RepositorioClientes
                        inModelo.Codigo = rp.RetornaProximoCodigo
                    End Using
                End If
            End If

            AcaoObjTransacao(inModelo, AcoesFormulario.Adicionar)
        End Sub

        ' EDITA POR OBJETO
        Public Overrides Sub EditaObj(ByRef inModelo As Clientes, inFiltro As ClsF3MFiltro)
            If inModelo.IDLoja Is Nothing Then inModelo.IDLoja = ClsF3MSessao.RetornaLojaID

            inModelo.IDPais = inModelo.IDPaisPorDefeito
            inModelo.DescricaoPais = inModelo.DescricaoPaisPorDefeito

            If inModelo.IDPais Is Nothing Then
                inModelo.IDPais = 184
                inModelo.DescricaoPais = "Portugal"
            End If

            If inModelo.IDLocalOperacao Is Nothing Then
                inModelo.IDLocalOperacao = 1
                inModelo.DescricaoLocalOperacao = "Continente"
            End If

            If inModelo.Nome.IndexOf(",") > 0 Or inModelo.Nome.IndexOf(":") > 0 Then
                Throw New Exception(Traducao.EstruturaDocumentos.CaracteresInvalidos)
            End If

            If inModelo.Codigo.Trim.Replace(" ", "") = "999999990" Then
                Throw New Exception(Traducao.EstruturaDocumentos.CodigoConsumidorFinal)
            End If

            If Not ClsF3MSessao.EmDesenvolvimento AndAlso inModelo.IDPais = 184 AndAlso Not ClsUtilitarios.ValidaNIF(inModelo.NContribuinte) Then
                Throw New Exception(ClsTexto.Traduz(Traducao.EstruturaEmpresas.NIFInvalido))
            End If

            AcaoObjTransacao(inModelo, AcoesFormulario.Alterar)
        End Sub

        ' REMOVE POR OBJETO
        Public Overrides Sub RemoveObj(ByRef o As Clientes, inFiltro As ClsF3MFiltro)
            AcaoObjTransacao(o, AcoesFormulario.Remover)
        End Sub

        ' GRAVA LINHAS
        Protected Overrides Sub GravaLinhasTodas(ByRef inCtx As BD.Dinamica.Aplicacao, ByRef inModelo As Clientes, inTbCli As tbClientes, inAcao As AcoesFormulario)
            Dim dict As Dictionary(Of String, Object) = New Dictionary(Of String, Object)
            dict.Add("IDCliente", inTbCli.ID)

            Select Case inAcao
                Case AcoesFormulario.Adicionar, AcoesFormulario.Alterar
                    GravaMoradas(inCtx, inTbCli, inModelo, inAcao, dict)
                    GravaContactos(inCtx, inTbCli, inModelo, inAcao, dict)

                Case AcoesFormulario.Remover
                    GravaLinhasEntidades(Of tbClientesMoradas)(inCtx, inTbCli.tbClientesMoradas.ToList, AcoesFormulario.Remover, Nothing)
                    GravaLinhasEntidades(Of tbClientesContatos)(inCtx, inTbCli.tbClientesContatos.ToList, AcoesFormulario.Remover, Nothing)
            End Select
        End Sub

        ''' <summary>
        ''' Funcao que grava as moradas do cliente
        ''' </summary>
        ''' <param name="inCtx"></param>
        ''' <param name="e"></param>
        ''' <param name="inModelo"></param>
        ''' <param name="inAcao"></param>
        ''' <param name="dic"></param>
        Private Sub GravaMoradas(inCtx As BD.Dinamica.Aplicacao, e As tbClientes, inModelo As Clientes, inAcao As AcoesFormulario, dic As Dictionary(Of String, Object))
            If inModelo.Versao = 2 AndAlso
                (Not String.IsNullOrEmpty(inModelo.MoradaPorDefeito) OrElse
                inModelo.IDCodigoPostalPorDefeito IsNot Nothing OrElse
                inModelo.IDConcelhoPorDefeito IsNot Nothing OrElse
                inModelo.IDDistritoPorDefeito IsNot Nothing OrElse
                inModelo.IDPaisPorDefeito IsNot Nothing) Then

                Dim tbCliMor As tbClientesMoradas = Nothing
                If inModelo.IDMoradaPorDefeito <> 0 Then
                    tbCliMor = inCtx.tbClientesMoradas.Where(Function(w) w.ID = inModelo.IDMoradaPorDefeito).FirstOrDefault()
                End If

                Dim CliMor As New ClientesMoradas
                With CliMor
                    .ID = inModelo.IDMoradaPorDefeito : .Ordem = 1 : .OrdemMorada = 1
                    .Morada = inModelo.MoradaPorDefeito
                    .IDCodigoPostal = inModelo.IDCodigoPostalPorDefeito : .IDConcelho = inModelo.IDConcelhoPorDefeito
                    .IDDistrito = inModelo.IDDistritoPorDefeito : .IDPais = inModelo.IDPaisPorDefeito
                    .Ativo = True

                    If Not tbCliMor Is Nothing Then
                        .UtilizadorCriacao = tbCliMor.UtilizadorCriacao
                        .DataCriacao = tbCliMor.DataCriacao
                    End If
                End With

                If inModelo.ClientesMoradas Is Nothing Then inModelo.ClientesMoradas = New List(Of ClientesMoradas)
                inModelo.ClientesMoradas.Add(CliMor)
            End If

            GravaLinhas(Of tbClientesMoradas, ClientesMoradas)(inCtx, e, inModelo, dic)
        End Sub

        ''' <summary>
        ''' Funcao que grava os contactos do cliente
        ''' </summary>
        ''' <param name="inCtx"></param>
        ''' <param name="e"></param>
        ''' <param name="inModelo"></param>
        ''' <param name="inAcao"></param>
        ''' <param name="dic"></param>
        Private Sub GravaContactos(inCtx As BD.Dinamica.Aplicacao, e As tbClientes, inModelo As Clientes, inAcao As AcoesFormulario, dic As Dictionary(Of String, Object))
            If inModelo.Versao = 2 Then
                Dim tbCliCon As tbClientesContatos = Nothing
                If inModelo.IDContactoPorDefeito <> 0 Then
                    tbCliCon = inCtx.tbClientesContatos.Where(Function(w) w.ID = inModelo.IDContactoPorDefeito).FirstOrDefault()
                End If

                Dim CliCon As New ClientesContatos
                With CliCon
                    .ID = inModelo.IDContactoPorDefeito : CliCon.Ordem = 1
                    .Telemovel = inModelo.TelemovelPorDefeito : CliCon.Telefone = inModelo.TelefonePorDefeito : CliCon.Email = inModelo.EMailPorDefeito
                    .Ativo = True

                    If Not tbCliCon Is Nothing Then
                        .UtilizadorCriacao = tbCliCon.UtilizadorCriacao
                        .DataCriacao = tbCliCon.DataCriacao
                    End If
                End With

                If inModelo.ClientesContatos Is Nothing Then inModelo.ClientesContatos = New List(Of ClientesContatos)
                inModelo.ClientesContatos.Add(CliCon)
            End If

            If Not e.tbClientesContatos Is Nothing Then
                Dim intOrdem As Long = 2
                For Each lin In e.tbClientesContatos.Where(Function(w) w.Ordem <> 1)
                    lin.Ordem = intOrdem
                    intOrdem += 1
                Next
            End If

            GravaLinhas(Of tbClientesContatos, ClientesContatos)(inCtx, e, inModelo, dic)
        End Sub

        Public Function Importar(ByVal o As F3M.Importacao) As F3M.Importacao
            Try
                If Upload(o) Then
                    ImportaFicheiro(o)
                End If
                Return o
            Catch ex As F3M.Modelos.Excepcoes.Tipo.ClsExF3MValidacao
                Throw ex
            Catch ex As Exception
                Throw ex
            End Try
        End Function

        Private Function Upload(modelo As F3M.Importacao) As Boolean
            Try
                Dim nome = modelo.NomeFicheiro
                Dim extensao As String = "." & modelo.Extensao
                If Not extensao.ToUpper.Equals(".CSV") Then
                    Throw New F3M.Modelos.Excepcoes.Tipo.ClsExF3MValidacao("O tipo do ficheiro não está correto.")
                End If
                Dim jsonR As New JsonResult
                Dim novoCaminho As String = ClsTexto.ConcatenaStrings(New String() {System.Web.HttpContext.Current.Request.Path, URLs.Importacao, Operadores.Backslash})

                Dim novoCaminhoServidor As String = ClsTexto.ConcatenaStrings(New String() {
                                          HttpContext.Current.Server.MapPath("~/"),
                                          URLs.Importacao,
                                          F3M.Modelos.ConstantesKendo.Operadores.Backslash})

                Dim dataStr As String = DateTime.Now
                Dim novoNome As String = ClsTexto.ConcatenaStrings(New String() {modelo.NomeFicheiro, extensao})

                modelo.NomeFicheiro = novoNome
                modelo.Caminho = novoCaminhoServidor
                modelo.Ativo = True
                modelo.UtilizadorCriacao = ClsF3MSessao.RetornaUtilizadorNome
                modelo.DataCriacao = dataStr

                ' PARA CRIAR PASTA CASO NAO EXISTA
                If (Not Directory.Exists(novoCaminhoServidor)) Then
                    Directory.CreateDirectory(novoCaminhoServidor)
                End If

                Dim caminho As String = novoCaminhoServidor & modelo.NomeFicheiro
                Dim fileApagar As New FileInfo(caminho)
                If fileApagar.Exists Then
                    fileApagar.Delete()
                End If

                Dim data As Byte()
                Dim fs As New FileStream(novoCaminhoServidor & modelo.NomeFicheiro, FileMode.Create)
                Using fs
                    Using bw As New BinaryWriter(fs)
                        data = Convert.FromBase64String(modelo.strFicheiro)
                        bw.Write(data)
                        bw.Close()
                    End Using
                End Using

                Return True
            Catch ex As F3M.Modelos.Excepcoes.Tipo.ClsExF3MValidacao
                Throw ex
            Catch ex As Exception
                Throw
            End Try
        End Function

        Private Function ImportaFicheiro(ByVal modelo As F3M.Importacao) As F3M.Importacao
            Try
                Dim path = System.Web.HttpContext.Current.Server.MapPath(HttpContext.Current.Request.ApplicationPath) & "\Importacao"
                Dim lines() As String = IO.File.ReadAllLines(path & "\" & modelo.NomeFicheiro.ToUpper)
                Dim campos() As String = lines(0).Split(";")

                Dim strTabela As String = modelo.NomeFicheiro.ToLower.Replace(".csv", String.Empty)

                If ImportarBLK(path & "\" & modelo.NomeFicheiro.ToLower, BDContexto, strTabela, campos) Then
                    modelo.Estado = "Importado com sucesso!"
                Else
                    modelo.Estado = "Erro ao importar!"
                    Throw New Exception("O ficheiro não foi importado porque ocorreram erros.")
                End If

                Return modelo
            Catch ex As Exception
                Throw ex
            End Try
        End Function

        Public Function ImportarBLK(inUrlFicheiro As String, inCtx As BD.Dinamica.Aplicacao, strTabela As String, ByVal Campos() As String) As Boolean

            Dim transDados As System.Data.SqlClient.SqlTransaction

            Try
                Dim strNomeFicheiro As String = Path.GetFileName(inUrlFicheiro)
                Dim strUtilizador As String = ClsF3MSessao.RetornaUtilizadorNome '"F3M"
                Dim dtDataCriacao As String = DateTime.Today
                Dim strConteudo As String = File.ReadAllText(inUrlFicheiro, UTF8Encoding.Default)
                Dim intContador As Integer = 0
                Dim dttb As New DataTable()
                Dim strChave As String = RetornaNomeTabelaTemp() 'cria temporária
                Dim strCampos As String = String.Empty
                Dim strValores As String = String.Empty
                Dim strCamposAux As String = String.Empty
                Dim strColl As String = "COLLATE DATABASE_DEFAULT"

                If strTabela.ToLower = "tbdocumentosstock" Then
                    strCamposAux = " cast('' as nvarchar(50)) as CodigoCliente, cast('' as nvarchar(50)) as CodigoPostal, cast('' as nvarchar(50)) as CodigoDistrito, cast('' as nvarchar(50)) as CodigoConcelho, cast('' as nvarchar(50)) as CodigoMedicoTecnico, cast('' as nvarchar(50)) as CodigoProfissao "
                ElseIf strTabela.ToLower = "tbdocumentosvendas" Then
                    strCamposAux = " cast('' as nvarchar(50)) as CodigoCliente, cast('' as nvarchar(50)) as CodigoPostal, cast('' as nvarchar(50)) as CodigoDistrito, cast('' as nvarchar(50)) as CodigoConcelho, cast('' as nvarchar(50)) as CodigoMedicoTecnico, cast('' as nvarchar(50)) as CodigoProfissao, cast('' as nvarchar(50)) " & strColl & " as CodigoLoja "
                ElseIf strTabela.ToLower = "tbdocumentosstocklinhas" Then
                    strCamposAux = " cast('' as nvarchar(50)) " & strColl & " as CodigoCliente, cast('' as nvarchar(50)) " & strColl & " as CodigoPostal, cast('' as nvarchar(50)) " & strColl & " as CodigoDistrito, cast('' as nvarchar(50)) " & strColl & " as CodigoConcelho, cast('' as nvarchar(50)) " & strColl & " as CodigoEntidade, cast('' as nvarchar(50)) " & strColl & " as CodigoEntidade2, cast('' as nvarchar(50)) " & strColl & " as CodigoMedicoTecnico, cast('' as nvarchar(50)) " & strColl & " as CodigoProfissao, cast('' as nvarchar(50)) " & strColl & " as CodigoMarca, cast('' as nvarchar(50)) " & strColl & " as CodigoTipoArtigo, cast('' as nvarchar(50)) " & strColl & " as CodigoFornecedor, cast('' as nvarchar(50)) " & strColl & " as CodigoModelo, cast('' as nvarchar(50)) " & strColl & " as CodigoDocumento, cast('' as nvarchar(50)) " & strColl & " as CodigoArmazemLocalizacao "
                Else
                    strCamposAux = " cast('' as nvarchar(50)) " & strColl & " as CodigoCliente, cast('' as nvarchar(50)) " & strColl & " as CodigoPostal, cast('' as nvarchar(50))  " & strColl & " as CodigoDistrito, cast('' as nvarchar(50)) " & strColl & " as CodigoConcelho, cast('' as nvarchar(50)) " & strColl & " as CodigoEntidade,cast('' as nvarchar(50)) " & strColl & " as CodigoEntidade2,cast('' as nvarchar(50)) " & strColl & " as CodigoMedicoTecnico, cast('' as nvarchar(50)) " & strColl & " as CodigoProfissao, cast('' as nvarchar(50)) " & strColl & " as CodigoMarca, cast('' as nvarchar(50)) " & strColl & " as CodigoTipoArtigo, cast('' as nvarchar(50)) " & strColl & " as CodigoFornecedor, cast('' as nvarchar(50)) " & strColl & " as CodigoModelo, cast('' as nvarchar(50)) " & strColl & " as CodigoArtigo, cast('' as nvarchar(50)) " & strColl & " as CodigoDocumento, cast('' as nvarchar(50)) " & strColl & " as CodigoLoja "
                End If

                '1) Carregar o DataTable da estrutura mas vazio
                Dim strConexao As String = inCtx.Database.Connection.ConnectionString
                Using dad As New SqlDataAdapter("select " & strCamposAux & ", * from " & strTabela & " where 1 = 0 ", strConexao)
                    dad.Fill(dttb)
                End Using

                Using conn As New SqlConnection(strConexao)
                    conn.Open()
                    transDados = conn.BeginTransaction

                    Using cmdTemp As New SqlCommand
                        cmdTemp.Transaction = transDados
                        cmdTemp.Connection = conn
                        cmdTemp.CommandText = ClsTexto.ConcatenaStrings(New String() {"SELECT " & strCamposAux & ", * INTO  ", strChave, " FROM " & strTabela & " WHERE 1 = 0 "})
                        cmdTemp.ExecuteNonQuery()
                    End Using

                    '2) Preencher datatable com o conteúdo do ficheiro
                    For Each itemLinha As String In strConteudo.Split(ControlChars.CrLf)
                        If Not String.IsNullOrEmpty(itemLinha) Then
                            If intContador <> 0 Then
                                Dim linha = itemLinha.Replace(vbLf, "").Split(";")
                                If linha(0) <> String.Empty Then
                                    Dim newrow = dttb.Rows.Add()
                                    With newrow
                                        .Item(CamposGenericos.UtilizadorCriacao) = strUtilizador
                                        .Item(CamposGenericos.DataCriacao) = dtDataCriacao
                                        .Item(CamposGenericos.Sistema) = False
                                        .Item(CamposGenericos.Ativo) = True

                                        Select Case strTabela.ToLower
                                            Case "tbmodelos"
                                                .Item("codigo") = "codigo"
                                                .Item("descricao") = "descricao"
                                                .Item("idtipoartigo") = 1
                                                .Item("idmarca") = 1
                                                .Item("fotocromatica") = False
                                                .Item("stock") = False
                                                .Item("indicerefracao") = 0

                                                .Item("DataCriacao") = Date.Now
                                                .Item("UtilizadorCriacao") = ClsF3MSessao.RetornaUtilizadorNome

                                                strCampos = " stock, fotocromatica, indicerefracao, Ativo, Sistema, DataCriacao, UtilizadorCriacao "
                                                strValores = " 0, 0, 0, 1, 0, getdate(), " & ClsUtilitarios.EnvolveSQL(strUtilizador)

                                            Case "tbaros", "tboculossol"
                                                .Item("idartigo") = 1
                                                .Item("DataCriacao") = Date.Now
                                                .Item("UtilizadorCriacao") = ClsF3MSessao.RetornaUtilizadorNome

                                                strCampos = " , Ativo, Sistema, DataCriacao, UtilizadorCriacao "
                                                strValores = " , 1, 0, getdate(), " & ClsUtilitarios.EnvolveSQL(strUtilizador)

                                            Case "tbartigosprecos"
                                                .Item("idartigo") = 1
                                                .Item("ordem") = 1
                                                .Item("idcodigopreco") = 1
                                                .Item("DataCriacao") = Date.Now
                                                .Item("UtilizadorCriacao") = ClsF3MSessao.RetornaUtilizadorNome

                                                strCampos = " , idcodigopreco, ordem, Ativo, Sistema, DataCriacao, UtilizadorCriacao "
                                                strValores = ", 1, 1, 1, 0, getdate(), " & ClsUtilitarios.EnvolveSQL(strUtilizador)

                                            Case "tbartigos"
                                                .Item("codigo") = "ar1"
                                                .Item("idtipoartigo") = 2
                                                .Item("idgrupoartigo") = 1
                                                .Item("codigobarras") = "1"
                                                .Item("descricao") = "artigo"
                                                .Item("gerelotes") = 2
                                                .Item("gerestock") = 1
                                                .Item("descricaovariavel") = 1
                                                .Item("idunidade") = 1
                                                .Item("idunidadecompra") = 1
                                                .Item("idunidadevenda") = 1
                                                .Item("idunidadestock2") = 1
                                                .Item("idtaxa") = 4
                                                .Item("DedutivelPercentagem") = 100
                                                .Item("incidenciaPercentagem") = 100
                                                .Item("idtipopreco") = 1
                                                .Item("idsistemaclassificacao") = 2
                                                .Item("idmarca") = 0
                                                .Item("DataCriacao") = Date.Now
                                                .Item("UtilizadorCriacao") = ClsF3MSessao.RetornaUtilizadorNome

                                                strCampos = " , idgrupoartigo, gerelotes, GereStock, DescricaoVariavel, idunidade, idunidadecompra, IDUnidadeVenda, IDUnidadeStock2, idtaxa,  DedutivelPercentagem, incidenciaPercentagem, idtipopreco, Ativo, Sistema, DataCriacao, UtilizadorCriacao "

                                                strValores = " , 1, 0, 1, 1, 1, 1, 1, 1, 4, 100, 100, 1, 1, 0, getdate(), " & ClsUtilitarios.EnvolveSQL(strUtilizador)

                                            Case "tbclientes"
                                                .Item("IDTipoPessoa") = 1
                                                .Item("IDTipoEntidade") = 2
                                                .Item("IDMoeda") = 1
                                                .Item("IDLocalOperacao") = 1
                                                .Item("IDFormaPagamento") = 1
                                                .Item("IDCondicaoPagamento") = 1
                                                .Item("IDPrecoSugerido") = 1
                                                .Item("IDEspacoFiscal") = 1
                                                .Item("IDRegimeIva") = 1
                                                .Item("idpais") = 184
                                                .Item("IDIdioma") = 2
                                                .Item("Prioridade") = 999
                                                .Item("Desconto1") = 0
                                                .Item("Desconto2") = 0
                                                .Item("Comissao1") = 0
                                                .Item("Comissao2") = 0
                                                .Item("RegimeEspecial") = 0
                                                .Item("EfetuaRetencao") = 0
                                                .Item("ControloCredito") = 0
                                                .Item("EmitePedidoLiquidacao") = 0
                                                .Item("IvaCaixa") = 0
                                                .Item("Saldo") = 0
                                                .Item("TotalVendas") = 0

                                                .Item("idloja") = ClsF3MSessao.RetornaLojaID
                                                .Item("DataCriacao") = Date.Now
                                                .Item("UtilizadorCriacao") = ClsF3MSessao.RetornaUtilizadorNome

                                                strCampos = " IDTipoPessoa, IDTipoEntidade, IDMoeda, IDLocalOperacao, IDFormaPagamento, IDCondicaoPagamento, IDPrecoSugerido, IDEspacoFiscal, IDRegimeIva, idpais, IDIdioma, Prioridade, Desconto1, Desconto2, Comissao1, Comissao2, RegimeEspecial, EfetuaRetencao, ControloCredito, EmitePedidoLiquidacao, IvaCaixa, Saldo, TotalVendas, Ativo, Sistema, DataCriacao, UtilizadorCriacao "

                                                strValores = " 1, 2, 1, 1, 1, 1, 1, 1, 1, 184, 2, 999, 0,0,0,0,0,0,0,0,0,0,0, 1, 0, getdate(), " & ClsUtilitarios.EnvolveSQL(strUtilizador)

                                            Case "tbfornecedores"
                                                .Item("IDTipoEntidade") = 4
                                                .Item("IDMoeda") = 1
                                                .Item("IDLocalOperacao") = 1
                                                .Item("IDFormaPagamento") = 1
                                                .Item("IDCondicaoPagamento") = 1
                                                .Item("IDEspacoFiscal") = 1
                                                .Item("IDRegimeIva") = 1
                                                .Item("IDPais") = 184
                                                .Item("IDIdioma") = 2
                                                .Item("IDFornecimento") = 1
                                                .Item("Desconto1") = 0
                                                .Item("Desconto2") = 0
                                                .Item("RegimeEspecial") = 0
                                                .Item("EfetuaRetencao") = 0
                                                .Item("IvaCaixa") = 0
                                                .Item("IDFornecimento") = 0

                                                .Item("idloja") = ClsF3MSessao.RetornaLojaID
                                                .Item("DataCriacao") = Date.Now
                                                .Item("UtilizadorCriacao") = ClsF3MSessao.RetornaUtilizadorNome

                                                strCampos = " IDFornecimento, IDTipoEntidade, IDMoeda, IDLocalOperacao, IDFormaPagamento, IDCondicaoPagamento, IDEspacoFiscal, IDRegimeIva, IDPais, IDIdioma, Desconto1, Desconto2, RegimeEspecial, EfetuaRetencao, IvaCaixa, IDLoja, Ativo, Sistema, DataCriacao, UtilizadorCriacao "

                                                strValores = " 0, 4, 1, 1, 1, 1, 1, 1, 184, 2, 0,0,0,0,0, " & ClsF3MSessao.RetornaLojaID & ", 1, 0, getdate(), " & ClsUtilitarios.EnvolveSQL(strUtilizador)

                                            Case "tbdocumentosvendas" ' Serviços 
                                                .Item("IDTiposDocumentoSeries") = 19 ' TODO série de conversão pelo codigo
                                                .Item("IDTipoDocumento") = 1 'SV
                                                .Item("IDEntidade") = 1
                                                .Item("NomeFiscal") = "CONSUMIDOR FINAL"
                                                .Item("IDTipoEntidade") = 2
                                                .Item("IDMoeda") = 1
                                                .Item("TaxaConversao") = 1
                                                .Item("IDEstado") = 2 ' Efetivo
                                                .Item("NumeroInterno") = 0
                                                .Item("DataDocumento") = Date.Now
                                                .Item("NumeroDocumento") = 1
                                                .Item("Impresso") = 1
                                                .Item("IDLoja") = ClsF3MSessao.RetornaLojaID
                                                .Item("DataCriacao") = Date.Now
                                                .Item("UtilizadorCriacao") = ClsF3MSessao.RetornaUtilizadorNome
                                                .Item("TotalEntidade1") = 0
                                                .Item("TotalClienteMoedaDocumento") = 0

                                                strCampos = " IDTiposDocumentoSeries, IDTipoDocumento, IDTipoEntidade, IDMoeda, TaxaConversao, IDEstado, CodigoTipoEstado, NumeroInterno, Impresso, Ativo, Sistema, UtilizadorCriacao, UtilizadorEstado, DataCriacao, DataHoraEstado, DataControloInterno, DataAssinatura "

                                                strValores = " 19, 1, 2, 1, 1, 2, '" & TiposEstados.Efetivo & "', 0, 1, 1, 0, " & ClsUtilitarios.EnvolveSQL(strUtilizador) & ", " & ClsUtilitarios.EnvolveSQL(strUtilizador) & ", getdate(), getdate(), getdate(), getdate() "

                                            Case "tbdocumentosstock"
                                                .Item("IDTiposDocumentoSeries") = 11 ' 2017ES
                                                .Item("IDTipoDocumento") = 11 ' Entrada Stock
                                                .Item("IDEntidade") = 1
                                                .Item("NomeFiscal") = "CONSUMIDOR FINAL"
                                                .Item("IDTipoEntidade") = 2
                                                .Item("IDMoeda") = 1
                                                .Item("TaxaConversao") = 1
                                                .Item("IDEstado") = 12
                                                .Item("NumeroInterno") = 0
                                                .Item("DataDocumento") = Date.Now
                                                .Item("NumeroDocumento") = 0
                                                .Item("Impresso") = 0
                                                .Item("IDLoja") = ClsF3MSessao.RetornaLojaID
                                                .Item("DataCriacao") = Date.Now
                                                .Item("UtilizadorCriacao") = ClsF3MSessao.RetornaUtilizadorNome

                                                strCampos = " IdLocalOperacao, IDPaisCarga, IDEspacoFiscal, IDRegimeIva, CodigoDocOrigem, IDSisTiposDocPU, CodigoSisTiposDocPU, CodigoMoeda,IDCondicaoPagamento, IDTiposDocumentoSeries, IDTipoDocumento, IDTipoEntidade, IDMoeda, TaxaConversao, IDEstado, CodigoTipoEstado, NumeroInterno, Impresso, IDLoja, Ativo, Sistema, UtilizadorCriacao, UtilizadorEstado, DataCriacao, DataHoraEstado, DataControloInterno, DataAssinatura "
                                                strValores = " 1,184,1,1,'001',13,'003','EUR', 1, 11, 11, 2, 1, 1, 11, '" & TiposEstados.Efetivo & "', 0, 0, " & ClsF3MSessao.RetornaLojaID & ", 1, 0, " & ClsUtilitarios.EnvolveSQL(strUtilizador) & ", " & ClsUtilitarios.EnvolveSQL(strUtilizador) & ", getdate(), getdate(), getdate(), getdate() "

                                            Case "tbdocumentosstocklinhas"
                                                .Item("IDDocumentoStock") = 1
                                                .Item("Descricao") = "artigo"
                                                .Item("IDUnidade") = 1
                                                .Item("NumCasasDecUnidade") = 0
                                                .Item("Ordem") = 1
                                                .Item("DataCriacao") = Date.Now
                                                .Item("UtilizadorCriacao") = ClsF3MSessao.RetornaUtilizadorNome


                                                strCampos = " , IDUnidadeStock, Desconto1, CodigoTipoPreco,PercIncidencia, PercDeducao, CodigoUnidade, IDTipoPreco, OperacaoConvUnidStk, FatorConvUnidStk, NumCasasDecUnidadeStk, Alterada, SiglaPais, IDRegimeIva, RegimeIva, IDEspacoFiscal, EspacoFiscal, IDUnidade, NumCasasDecUnidade, Ativo, Sistema, UtilizadorCriacao, DataCriacao"

                                                strValores = " , 1, 0,'Unico', 100, 100, 'UN', 1, 'Multiplica', 1, 0, 0, 'PT', 1, 'Normal', 1, 'Nacional', 1, 0, 1, 0, " & ClsUtilitarios.EnvolveSQL(strUtilizador) & ", getdate() "

                                            Case "tbmedicostecnicos"
                                                .Item("IDTipoEntidade") = 13
                                                .Item("idloja") = ClsF3MSessao.RetornaLojaID
                                                .Item("TemAgenda") = 1
                                                .Item("Tempoconsulta") = 0
                                                .Item("CorTexto") = 0
                                                .Item("CorTexto1") = 0
                                                .Item("CorFundo") = 0
                                                .Item("CorFundo1") = 0
                                                .Item("DataCriacao") = Date.Now
                                                .Item("UtilizadorCriacao") = ClsF3MSessao.RetornaUtilizadorNome

                                                strCampos = " CorTexto, CorTexto1, CorFundo, CorFundo1, Tempoconsulta, TemAgenda, IDTipoEntidade, IDLoja, Ativo, Sistema, DataCriacao, UtilizadorCriacao"
                                                strValores = " 0, 0, 0, 0, 0, 1, 13, " & ClsF3MSessao.RetornaLojaID & ", 1, 0, getdate(), " & ClsUtilitarios.EnvolveSQL(strUtilizador)

                                            Case "tbentidades"
                                                .Item("IDTipoEntidade") = 1
                                                .Item("IDTipoDescricao") = 1
                                                .Item("idloja") = ClsF3MSessao.RetornaLojaID
                                                .Item("DataCriacao") = Date.Now
                                                .Item("UtilizadorCriacao") = ClsF3MSessao.RetornaUtilizadorNome

                                                strCampos = " IDTipoEntidade, IDTipoDescricao, IDLoja, Ativo, Sistema, DataCriacao, UtilizadorCriacao"
                                                strValores = " 1, 1, " & ClsF3MSessao.RetornaLojaID & ", 1, 0, getdate(), " & ClsUtilitarios.EnvolveSQL(strUtilizador)

                                            Case "tbcodigospostais"
                                                .Item("IDConcelho") = 1
                                                .Item("DataCriacao") = Date.Now
                                                .Item("UtilizadorCriacao") = ClsF3MSessao.RetornaUtilizadorNome

                                                strCampos = " Ativo, Sistema, DataCriacao, UtilizadorCriacao"
                                                strValores = " 1, 0, getdate(), " & ClsUtilitarios.EnvolveSQL(strUtilizador)

                                            Case "tbdistritos", "tbprofissoes", "tbmarcas"
                                                .Item("DataCriacao") = Date.Now
                                                .Item("UtilizadorCriacao") = ClsF3MSessao.RetornaUtilizadorNome

                                                strCampos = " Ativo, Sistema, DataCriacao, UtilizadorCriacao"
                                                strValores = " 1, 0, getdate(), " & ClsUtilitarios.EnvolveSQL(strUtilizador)

                                            Case "tbconcelhos"
                                                .Item("IDDistrito") = 1
                                                .Item("DataCriacao") = Date.Now
                                                .Item("UtilizadorCriacao") = ClsF3MSessao.RetornaUtilizadorNome

                                                strCampos = " Ativo, Sistema, DataCriacao, UtilizadorCriacao"
                                                strValores = " 1, 0, getdate(), " & ClsUtilitarios.EnvolveSQL(strUtilizador)

                                            Case "tbclientescontatos"
                                                .Item("IDCliente") = 1
                                                .Item("Ordem") = 1
                                                .Item("Mailing") = 1
                                                strCampos = " , Ordem, Mailing, Ativo, Sistema, DataCriacao, UtilizadorCriacao"
                                                strValores = " , 1, 1, 1, 0, getdate(), " & ClsUtilitarios.EnvolveSQL(strUtilizador)

                                            Case "tbclientesmoradas"
                                                .Item("IDCliente") = 1
                                                .Item("Ordem") = 1
                                                .Item("OrdemMorada") = 1
                                                strCampos = " , Ordem, OrdemMorada, Ativo, Sistema, DataCriacao, UtilizadorCriacao"
                                                strValores = " , 1, 1, 1, 0, getdate(), " & ClsUtilitarios.EnvolveSQL(strUtilizador)

                                            Case "tbfornecedorescontatos"
                                                .Item("IDFornecedor") = 1
                                                .Item("Ordem") = 1
                                                .Item("Mailing") = 1
                                                strCampos = " , Ordem, Mailing, Ativo, Sistema, DataCriacao, UtilizadorCriacao"
                                                strValores = " , 1, 1, 1, 0, getdate(), " & ClsUtilitarios.EnvolveSQL(strUtilizador)

                                            Case "tbfornecedoresmoradas"
                                                .Item("IDFornecedor") = 1
                                                .Item("Ordem") = 1
                                                .Item("OrdemMorada") = 1
                                                strCampos = " , Ordem, OrdemMorada, Ativo, Sistema, DataCriacao, UtilizadorCriacao"
                                                strValores = " , 1, 1, 1, 0, getdate(), " & ClsUtilitarios.EnvolveSQL(strUtilizador)

                                        End Select

                                        For intI = 0 To Campos.Count - 1
                                            Select Case strTabela
                                                Case "tbclientes", "tbclientesmoradas", "tbclientescontatos", "tbmedicostecnicos", "tbentidades", "tbcodigospostais", "tbdistritos", "tbconcelhos", "tbprofissoes", "tbmarcas", "tbmodelos", "tbfornecedores", "tbfornecedoresmoradas", "tbfornecedorescontatos", "tbartigos", "tbaros", "tboculossol", "tbartigosprecos", "tbdocumentosvendas", "tbdocumentosstock", "tbdocumentosstocklinhas"

                                                    If Campos(intI).ToLower = "datanascimento" Then
                                                        If IsDate(linha(intI)) Then
                                                            .Item(Campos(intI)) = RetornaNuloSeVazio(linha(intI))
                                                        Else
                                                            .Item(Campos(intI)) = System.DBNull.Value
                                                        End If
                                                    Else
                                                        .Item(Campos(intI)) = linha(intI)
                                                    End If
                                            End Select
                                        Next
                                    End With
                                End If
                            End If
                        End If
                        intContador += 1
                    Next

                    For intI = 0 To Campos.Count - 1
                        Select Case strTabela
                            Case "tbclientes", "tbclientesmoradas", "tbclientescontatos", "tbmedicostecnicos", "tbentidades", "tbcodigospostais", "tbdistritos", "tbconcelhos", "tbprofissoes", "tbmarcas", "tbmodelos", "tbfornecedores", "tbfornecedoresmoradas", "tbfornecedorescontatos", "tbartigos", "tbaros", "tboculossol", "tbartigosprecos", "tbdocumentosvendas", "tbdocumentosstock", "tbdocumentosstocklinhas"

                                Select Case Campos(intI).ToLower
                                    Case "codigocliente", "codigopostal", "codigodistrito", "codigoconcelho", "codigomedicotecnico", "codigoentidade", "codigoentidade2", "codigoprofissao", "codigomarca", "codigofornecedor", "codigomodelo", "codigodocumento", "codigoarmazemlocalizacao", "codigoloja"

                                    Case "codigotipoartigo", "codigoartigo"
                                        If strTabela = "tbdocumentosstocklinhas" Then
                                            strCampos += "," & "temp." & Campos(intI)
                                            strValores += "," & "temp." & Campos(intI)
                                        End If
                                    Case Else
                                        strCampos += "," & "temp." & Campos(intI)
                                        strValores += "," & "temp." & Campos(intI)
                                End Select
                        End Select
                    Next


                    '3) Gravar dataTable com os registos
                    Using sqlBulkCopy As New System.Data.SqlClient.SqlBulkCopy(conn, SqlClient.SqlBulkCopyOptions.Default, transDados)
                        Try
                            sqlBulkCopy.DestinationTableName = strChave
                            sqlBulkCopy.WriteToServer(dttb)
                        Catch ex As Exception
                            Throw
                        End Try
                    End Using

                    ''4) Inserir apenas os registos relacionados
                    Using cmdInserir As New System.Data.SqlClient.SqlCommand
                        cmdInserir.Transaction = transDados
                        cmdInserir.Connection = conn
                        Select Case strTabela.ToLower
                            Case "tbclientes"
                                cmdInserir.CommandText = ClsTexto.ConcatenaStrings(New String() {"INSERT INTO " & strTabela & "(IDMedicoTecnico, IDProfissao, IDLoja, IDEntidade1, IDEntidade2, ", strCampos, ") ",
                                    " Select M.ID, P.ID, L.ID, E.ID, ED.ID, ", strValores, " FROM ", strChave, " As Temp ",
                                    " LEFT JOIN TBMEDICOSTECNICOS M On M.Codigo=Temp.CodigoMedicoTecnico ",
                                    " LEFT JOIN TBPROFISSOES P On P.Codigo=Temp.CodigoProfissao ",
                                    " LEFT JOIN TBLOJAS L On L.Codigo=Temp.CodigoLoja ",
                                    " LEFT JOIN TBENTIDADES E On E.Codigo=Temp.CodigoEntidade ",
                                    " LEFT JOIN TBENTIDADES ED On ED.Codigo=Temp.CodigoEntidade2 "})

                                cmdInserir.ExecuteNonQuery()

                            Case "tbclientesmoradas"
                                cmdInserir.CommandText = ClsTexto.ConcatenaStrings(New String() {"INSERT INTO " & strTabela & "(IDCliente, IDCodigoPostal ", strCampos, ") ",
                                                                               " Select C.ID, CP.ID ", strValores, " FROM ", strChave, " As Temp ",
                                                                               " INNER JOIN TBCLIENTES C On C.Codigo=Temp.CodigoCliente ",
                                                                               " LEFT JOIN TBCODIGOSPOSTAIS CP On CP.Codigo=Temp.CodigoPostal "})
                                cmdInserir.ExecuteNonQuery()

                                cmdInserir.CommandText = "update t Set t.IDConcelho=cp.IDConcelho, t.IDDistrito = c.IDDistrito from tbclientesmoradas t inner join tbcodigospostais cp on                        t.idcodigopostal=cp.id left join tbconcelhos c On cp.IDConcelho=c.id left join tbdistritos d On c.IDdistrito=d.id where                                t.IDConcelho Is null Or t.IDDistrito Is null "
                                cmdInserir.ExecuteNonQuery()

                            Case "tbclientescontatos"
                                cmdInserir.CommandText = ClsTexto.ConcatenaStrings(New String() {"INSERT INTO " & strTabela & "(IDCliente ", strCampos, ") ",
                                                                               " Select C.ID ", strValores, " FROM ", strChave, " As Temp ",
                                                                               " INNER JOIN TBCLIENTES C On C.Codigo=Temp.CodigoCliente "})
                                cmdInserir.ExecuteNonQuery()


                            Case "tbfornecedores"
                                cmdInserir.CommandText = ClsTexto.ConcatenaStrings(New String() {"INSERT INTO " & strTabela & "(", strCampos, ") ",
                                                                               " Select ", strValores, " FROM ", strChave, " As Temp ",
                                                                               " LEFT JOIN " & strTabela & " As Definit On Definit.codigo=Temp.codigo collate database_default ",
                                                                               " WHERE Definit.codigo Is NULL"})
                                cmdInserir.ExecuteNonQuery()

                            Case "tbfornecedoresmoradas"
                                cmdInserir.CommandText = ClsTexto.ConcatenaStrings(New String() {"INSERT INTO " & strTabela & "(IDFornecedor, IDCodigoPostal ", strCampos, ") ",
                                                                               " Select F.ID, CP.ID ", strValores, " FROM ", strChave, " As Temp ",
                                                                               " INNER JOIN TBFORNECEDORES F On F.Codigo=Temp.CodigoFornecedor ",
                                                                               " LEFT JOIN TBCODIGOSPOSTAIS CP On CP.Codigo=Temp.CodigoPostal "})
                                cmdInserir.ExecuteNonQuery()

                                cmdInserir.CommandText = "update t Set t.IDConcelho=cp.IDConcelho, t.IDDistrito = c.IDDistrito from tbfornecedoresmoradas t inner join tbcodigospostais cp on t.idcodigopostal=cp.id left join tbconcelhos c On cp.IDConcelho=c.id left join tbdistritos d On c.IDdistrito=d.id where t.IDConcelho Is null Or t.IDDistrito Is null "

                                cmdInserir.ExecuteNonQuery()

                            Case "tbfornecedorescontatos"
                                cmdInserir.CommandText = ClsTexto.ConcatenaStrings(New String() {"INSERT INTO " & strTabela & "(IDFornecedor ", strCampos, ") ",
                                                                               " Select F.ID ", strValores, " FROM ", strChave, " As Temp ",
                                                                               " INNER JOIN TBFORNECEDORES F On F.Codigo=Temp.CodigoFornecedor "})
                                cmdInserir.ExecuteNonQuery()


                            Case "tbconcelhos"
                                cmdInserir.CommandText = ClsTexto.ConcatenaStrings(New String() {"INSERT INTO " & strTabela & "(IDDistrito, ", strCampos, ") ",
                                                                               " Select C.ID, ", strValores, " FROM ", strChave, " As Temp ",
                                                                               " INNER JOIN TBDISTRITOS C On C.Codigo=Temp.CodigoDistrito "})
                                cmdInserir.ExecuteNonQuery()

                            Case "tbartigos"
                                cmdInserir.CommandText = ClsTexto.ConcatenaStrings(New String() {"INSERT INTO " & strTabela & "(IDMARCA, IDTIPOARTIGO, IDSistemaClassificacao ", strCampos, ") ",
                                                                            " Select M.ID, T.ID, T.ID ", strValores, " FROM ", strChave, " As Temp ",
                                                                            " INNER JOIN TBMARCAS M On M.Codigo=Temp.CodigoMarca ",
                                                                            " LEFT JOIN TBTIPOSARTIGOS T On T.Codigo=Temp.CodigoTipoArtigo ",
                                                                            " LEFT JOIN " & strTabela & " As Definit On  Definit.codigo=Temp.codigo collate database_default ",
                                                                            " WHERE Definit.codigo Is NULL"})
                                Dim lngRecAff As Long = cmdInserir.ExecuteNonQuery()

                            Case "tbaros", "tboculossol"
                                cmdInserir.CommandText = ClsTexto.ConcatenaStrings(New String() {"INSERT INTO " & strTabela & "(IDARTIGO, IDMODELO ", strCampos, ") ",
                                                                            " Select A.ID, M.ID  ", strValores, " FROM ", strChave, " As Temp ",
                                                                            "INNER JOIN TBMODELOS M On M.Codigo=Temp.CodigoModelo ",
                                                                            "INNER JOIN TBARTIGOS a On A.Codigo=Temp.CodigoARTIGO ",
                                                                            "LEFT JOIN " & strTabela & " As Definit On  Definit.IDArtigo=A.ID ",
                                                                            " WHERE Definit.IDArtigo Is NULL AND NOT A.ID IS NULL "})
                                Dim lngRecAff As Long = cmdInserir.ExecuteNonQuery()

                            Case "tbartigosprecos"
                                cmdInserir.CommandText = ClsTexto.ConcatenaStrings(New String() {"INSERT INTO " & strTabela & "(IDARTIGO ", strCampos, ") ",
                                                                            "SELECT A.ID ", strValores, " FROM ", strChave, " As Temp ",
                                                                            "INNER JOIN TBARTIGOS a On A.Codigo=Temp.CodigoARTIGO ",
                                                                            "LEFT JOIN " & strTabela & " As Definit On  Definit.IDArtigo=A.ID ",
                                                                            "WHERE Definit.IDArtigo Is NULL AND NOT A.ID IS NULL "})
                                Dim lngRecAff As Long = cmdInserir.ExecuteNonQuery()

                            Case "tbmarcas"
                                cmdInserir.CommandText = ClsTexto.ConcatenaStrings(New String() {"INSERT INTO " & strTabela & "(", strCampos, ") ",
                                                                               " Select ", strValores, " FROM ", strChave, " As Temp ",
                                                                               " LEFT JOIN " & strTabela & " As Definit On  Definit.codigo=Temp.codigo collate database_default ",
                                                                               " WHERE Definit.codigo Is NULL"})
                                cmdInserir.ExecuteNonQuery()

                            Case "tbmodelos"
                                cmdInserir.CommandText = ClsTexto.ConcatenaStrings(New String() {"INSERT INTO " & strTabela & "(IDMarca, IDTipoArtigo, ", strCampos, ") ",
                                                                               " Select M.ID, T.ID,", strValores, " FROM ", strChave, " As Temp ",
                                                                               " INNER JOIN TBMARCAS M On M.Codigo=Temp.CodigoMarca ",
                                                                               " LEFT JOIN TBTIPOSARTIGOS T On T.Codigo=Temp.CodigoTipoArtigo ",
                                                                               " LEFT JOIN " & strTabela & " As Definit On  Definit.codigo=Temp.codigo collate database_default ",
                                                                               " WHERE Definit.codigo Is NULL "})
                                cmdInserir.ExecuteNonQuery()

                            Case "tbcodigospostais"
                                cmdInserir.CommandText = ClsTexto.ConcatenaStrings(New String() {"INSERT INTO " & strTabela & "(IDConcelho, ", strCampos, ") ",
                                                                               " Select C.ID, ", strValores, " FROM ", strChave, " As Temp ",
                                                                               " INNER JOIN TBCONCELHOS C On C.Codigo=Temp.CodigoConcelho",
                                                                               " LEFT JOIN " & strTabela & " As Definit On  Definit.Codigo=Temp.Codigo ",
                                                                               " WHERE Definit.Codigo Is NULL "})
                                cmdInserir.ExecuteNonQuery()

                            Case "tbmedicostecnicos", "tbentidades", "tbdistritos", "tbprofissoes"
                                cmdInserir.CommandText = ClsTexto.ConcatenaStrings(New String() {"INSERT INTO " & strTabela & "(", strCampos, ") ",
                                                                               " Select ", strValores, " FROM ", strChave, " As Temp ",
                                                                               " LEFT JOIN " & strTabela & " As Definit On  Definit.Codigo=Temp.Codigo collate database_default  ",
                                                                               " WHERE Definit.Codigo Is NULL "})
                                cmdInserir.ExecuteNonQuery()


                            Case "tbdocumentosvendas"
                                cmdInserir.CommandText = ClsTexto.ConcatenaStrings(New String() {"INSERT INTO " & strTabela & "(IDENTIDADE, NOMEFISCAL, IDLOJA, ", strCampos, ") ",
                                                                               " Select ISNULL(C.ID,1), ISNULL(C.NOME, 'CONSUMIDOR FINAL'), L.ID, ", strValores, " FROM ", strChave, " As Temp ",
                                                                               " LEFT JOIN " & strTabela & " As Definit On  Definit.NumeroDocumento=Temp.NumeroDocumento ",
                                                                               " LEFT JOIN TBCLIENTES C On C.Codigo=Temp.Codigocliente ",
                                                                               " LEFT JOIN TBLOJAS L On L.Codigo=Temp.CodigoLoja ",
                                                                               " WHERE Definit.NumeroDocumento is null "})
                                Dim lngRecAff As Long = cmdInserir.ExecuteNonQuery()

                                'inserir serviços associados
                                cmdInserir.CommandText = ClsTexto.ConcatenaStrings(New String() {"INSERT INTO tbservicos (Ordem, IDTipoServico, IDTipoServicoOlho, CombinacaoDefeito, IDDocumentoVenda, Ativo, Sistema, DataCriacao, UtilizadorCriacao) Select 0, (case when substring(temp.codigodocorigem,1,1)='C' then 6 else 2 end), 0, 0, Definit.id, 1, 0, getdate(), 'F3M' FROM ", strChave, " As Temp INNER JOIN " & strTabela & " As Definit On Definit.NumeroDocumento=Temp.NumeroDocumento "})
                                lngRecAff = cmdInserir.ExecuteNonQuery()

                                'substituir os caracteres da mudança de linha (LfCr)
                                cmdInserir.CommandText = "update tbdocumentosvendas set observacoes=replace(replace(cast(observacoes as varchar(max)), '¤',CHAR(10)), '¥', CHAR(13))"
                                lngRecAff = cmdInserir.ExecuteNonQuery()

                                'aplicar só no final da conversão
                                'cmdInserir.CommandText = "update tbclientes set codigo=right('000000' + codigo,6)"
                                'lngRecAff = cmdInserir.ExecuteNonQuery()

                                'TODO passar para script
                                'cmdInserir.CommandText = "update tbTiposDocumentoSeries set codigoserie=replace(codigoserie,'17','18') , descricaoserie=replace(descricaoserie,'17','18') and id<20"
                                'lngRecAff = cmdInserir.ExecuteNonQuery()

                                'cmdInserir.CommandText = "update tbdocumentosVendas Set IDEstado=2, CodigoTipoEstado ='EFT'"
                                'lngRecAff = cmdInserir.ExecuteNonQuery()

                            Case "tbdocumentosstock"

                                cmdInserir.CommandText = ClsTexto.ConcatenaStrings(New String() {"INSERT INTO " & strTabela & "(IDENTIDADE, NOMEFISCAL, CODIGOENTIDADE, ", strCampos, ") ",
                                                                               " Select ISNULL(C.ID,1), ISNULL(C.NOME, 'CONSUMIDOR FINAL'), ISNULL(C.CODIGO, '1'), ", strValores, " FROM ", strChave, " As Temp ",
                                                                               " LEFT JOIN " & strTabela & " As Definit On  Definit.NumeroDocumento=Temp.NumeroDocumento ",
                                                                               " LEFT JOIN TBCLIENTES C On C.Codigo=Temp.Codigocliente ",
                                                                               " WHERE Definit.NumeroDocumento is null "})
                                Dim lngRecAff As Long = cmdInserir.ExecuteNonQuery()

                            Case "tbdocumentosstocklinhas"

                                'inserir linhas de um documento de stock existente
                                cmdInserir.CommandText = ClsTexto.ConcatenaStrings(New String() {"INSERT INTO " & strTabela & "(iddocumentostock, idartigo, ordem, Descricao, CodigoBarrasArtigo, idarmazemdestino, idarmazemlocalizacaodestino, idtaxaiva, taxaiva, CodigoTipoIva, IDTipoIva, CodigoTaxaIva, QuantidadeStock, QtdAfetacaoStock, PrecoUnitarioMoedaRef, PrecoUnitarioEfetivoMoedaRef, Valoriva, Valorincidencia, ValorIvaDedutivel, precototal ", strCampos, ") ",
                                            "Select S.ID, A.ID, Temp.ID, A.Descricao, A.CodigoBarras, AL.IDArmazem, AL.ID, I.ID, I.TAXA, I.Codigo, I.IDTipoIVA, I.Codigo, Temp.Quantidade, Temp.Quantidade, temp.precounitario, temp.precounitario, (temp.precounitario*temp.quantidade*i.taxa/100), (temp.precounitario*temp.quantidade), (temp.precounitario*temp.quantidade*i.taxa/100), (temp.precounitario*temp.quantidade) ", strValores, " FROM ", strChave, " As Temp ",
                                            "LEFT JOIN tbdocumentosstock S On S.Documento=Temp.CodigoDocumento ",
                                            "LEFT JOIN " & strTabela & " As Definit On Definit.Ordem=Temp.ID And Definit.IDDocumentostock=S.ID ",
                                            "LEFT JOIN tbartigos A On A.Codigo=Temp.CodigoArtigo ",
                                            "LEFT JOIN tbiva I On I.ID=A.IDTaxa ",
                                            "LEFT JOIN tbarmazenslocalizacoes AL On AL.Codigo=Temp.CodigoArmazemLocalizacao  ",
                                            "WHERE Definit.IDDocumentoStock is null order by temp.id "})

                                Dim lngRecAff As Long = cmdInserir.ExecuteNonQuery()
                        End Select
                    End Using

                    transDados.Commit()
                    conn.Close()

                    '5) apaga o ficheiro importado
                    If File.Exists(inUrlFicheiro) Then
                        'File.Delete(inUrlFicheiro)
                    End If

                End Using
                Return True
            Catch ex As Exception
                Return False
            End Try
        End Function

        Private Function RetornaNomeTabelaTemp() As String
            Dim strCaracteres As String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            Dim rndNumero As New Random
            Dim sbresult As New StringBuilder

            For intConta As Integer = 1 To 8
                Dim intidx As Integer = rndNumero.Next(0, 35)
                sbresult.Append(strCaracteres.Substring(intidx, 1))
            Next

            Return ClsTexto.ConcatenaStrings(New String() {"##", DateTime.Now.ToString("ddMMyyyyHHmmssSSS"), sbresult.ToString()})
        End Function

        Private Function RetornaNuloSeVazio(instrValorCampo As String) As Object

            If String.IsNullOrEmpty(instrValorCampo) Then
                Return System.DBNull.Value
            Else
                Return instrValorCampo
            End If

        End Function
#End Region

#Region "ESPECIFICO"
        ''' <summary>
        ''' Funcao que retorna o proximo codigo de cliente
        ''' </summary>
        ''' <returns></returns>
        Public Function RetornaProximoCodigo() As String
            Dim strQry As String = "Select cast(isnull(max(cast(isnull(codigo, 0) As bigint)),0)+1 As nvarchar) As codigo from tbclientes where codigo<>'999999990' and codigo not like '%[^0-9]%'"
            Return BDContexto.Database.SqlQuery(Of String)(strQry).FirstOrDefault()
        End Function



        Private Sub FiltraTipoDocEspecifico(inFiltro As ClsF3MFiltro, ByRef query As IQueryable(Of tbClientes))
            Dim IDTipoDoc As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDTipoDocumento, GetType(Long))
            Dim codMod As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "CodigoModulo", GetType(String))

            If IDTipoDoc > 0 AndAlso Not ClsTexto.ENuloOuVazio(codMod) Then

                Dim listIds As List(Of Long) = (From td In BDContexto.tbTiposDocumento
                                                Join tdp In BDContexto.tbTiposDocumentoTipEntPermDoc On td.ID Equals tdp.IDTiposDocumento
                                                Join tem In BDContexto.tbSistemaTiposEntidadeModulos On tem.ID Equals tdp.IDSistemaTiposEntidadeModulos
                                                Join m In BDContexto.tbSistemaModulos On m.ID Equals tem.IDSistemaModulos
                                                Join te In BDContexto.tbSistemaTiposEntidade On te.ID Equals tem.IDSistemaTiposEntidade
                                                Where m.Codigo = codMod AndAlso td.ID = IDTipoDoc
                                                Select te.ID).ToList

                If listIds IsNot Nothing Then
                    query = query.Where(Function(w) listIds.Contains(w.IDTipoEntidade))

                    Dim blnRegistarCosumidorFinal As Boolean = (From x In BDContexto.tbTiposDocumento
                                                                Where x.ID = IDTipoDoc
                                                                Select x.RegistarCosumidorFinal).FirstOrDefault()

                    If Not blnRegistarCosumidorFinal Then
                        query = query.Where(Function(w) w.Codigo <> "CF")
                    End If

                Else
                    query = query.Where(Function(w) w.IDTipoEntidade = -1)
                End If
            End If

        End Sub

        Public Function TemDocumentos(ByVal strTipo As String, ByVal lngIDEntidade As Long) As Integer

            Dim blnOk As Boolean = False
            Dim lngID As Long? = 0

            Dim lngEstado_Efetivo As Long? = (From x In BDContexto.tbEstados
                                              Where x.tbSistemaTiposEstados.Codigo = "EFT" And x.tbSistemaTiposEstados.tbSistemaEntidadesEstados.Codigo = "DV"
                                              Select x.ID).FirstOrDefault()

            Select Case strTipo
                Case "clientes"

                    Dim strNIF As String = (From x In BDContexto.tbClientes
                                            Where x.ID = lngIDEntidade
                                            Select x.NContribuinte).FirstOrDefault()

                    If strNIF = "999999990" Then
                        blnOk = False
                    Else
                        blnOk = ClsUtilitarios.ValidaNIF(strNIF)
                    End If

                    If strNIF IsNot Nothing AndAlso blnOk Then
                    Else
                        lngID = (From x In BDContexto.tbDocumentosVendas
                                 Where x.IDEntidade = lngIDEntidade And x.Assinatura IsNot Nothing
                                 Select x.ID).DefaultIfEmpty(0).FirstOrDefault()
                    End If

                Case "clientesnif"

                    Dim strNIF As String = (From x In BDContexto.tbClientes
                                            Where x.ID = lngIDEntidade
                                            Select x.NContribuinte).FirstOrDefault()
                    lngID = 0

                    If strNIF = "999999990" Then
                        blnOk = False
                    Else
                        blnOk = ClsUtilitarios.ValidaNIF(strNIF)
                    End If

                    If strNIF IsNot Nothing AndAlso blnOk Then
                        lngID = (From x In BDContexto.tbDocumentosVendas
                                 Where x.IDEntidade = lngIDEntidade And x.Assinatura IsNot Nothing
                                 Select x.ID).DefaultIfEmpty(0).FirstOrDefault()
                    End If

                Case "artigos"

                    lngID = (From x In BDContexto.tbDocumentosVendasLinhas
                             Where x.IDArtigo = lngIDEntidade And x.tbDocumentosVendas.Assinatura IsNot Nothing
                             Select x.ID).DefaultIfEmpty(0).FirstOrDefault()

                Case "modelos"
                    lngID = (From x In BDContexto.tbArtigos
                             Where x.tbLentesOftalmicas.FirstOrDefault.IDModelo = lngIDEntidade
                             Select x.ID).DefaultIfEmpty(0).FirstOrDefault()

                    If lngID = 0 Then
                        lngID = (From x In BDContexto.tbDocumentosVendasLinhas
                                 Where x.tbArtigos.tbLentesOftalmicas.FirstOrDefault.IDModelo = lngIDEntidade And x.tbDocumentosVendas.Assinatura IsNot Nothing
                                 Select x.ID).DefaultIfEmpty(0).FirstOrDefault()
                    End If

                    If lngID = 0 Then
                        lngID = (From x In BDContexto.tbDocumentosVendasLinhas
                                 Where x.tbArtigos.tbLentesContato.FirstOrDefault.IDModelo = lngIDEntidade And x.tbDocumentosVendas.Assinatura IsNot Nothing
                                 Select x.ID).DefaultIfEmpty(0).FirstOrDefault()
                    End If

                    If lngID = 0 Then
                        lngID = (From x In BDContexto.tbDocumentosVendasLinhas
                                 Where x.tbArtigos.tbAros.FirstOrDefault.IDModelo = lngIDEntidade And x.tbDocumentosVendas.Assinatura IsNot Nothing
                                 Select x.ID).DefaultIfEmpty(0).FirstOrDefault()
                    End If

                    If lngID = 0 Then
                        lngID = (From x In BDContexto.tbDocumentosVendasLinhas
                                 Where x.tbArtigos.tbOculosSol.FirstOrDefault.IDModelo = lngIDEntidade And x.tbDocumentosVendas.Assinatura IsNot Nothing
                                 Select x.ID).DefaultIfEmpty(0).FirstOrDefault()
                    End If

                Case "tratamentos"
                    lngID = (From x In BDContexto.tbDocumentosVendasLinhas
                             Where x.tbArtigos.tbLentesOftalmicas.FirstOrDefault.IDTratamentoLente = lngIDEntidade And x.tbDocumentosVendas.Assinatura IsNot Nothing
                             Select x.ID).DefaultIfEmpty(0).FirstOrDefault()

                Case "cores"
                    lngID = (From x In BDContexto.tbDocumentosVendasLinhas
                             Where x.tbArtigos.tbLentesOftalmicas.FirstOrDefault.IDCorLente = lngIDEntidade And x.tbDocumentosVendas.Assinatura IsNot Nothing
                             Select x.ID).DefaultIfEmpty(0).FirstOrDefault()

                Case "suplementos"
                    lngID = (From x In BDContexto.tbDocumentosVendasLinhas
                             Where x.tbArtigos.tbLentesOftalmicas.FirstOrDefault.tbLentesOftalmicasSuplementos.FirstOrDefault.IDSuplementoLente = lngIDEntidade And x.tbDocumentosVendas.Assinatura IsNot Nothing
                             Select x.ID).DefaultIfEmpty(0).FirstOrDefault()

            End Select

            Return lngID
        End Function
#End Region

#Region "COMMUNICATION - SMS"
        Public Overrides Function GetCommunicationSmsProperties(id As Long) As ClsF3MCommunicationSms
            Dim phoneNumber As String = BDContexto.tbClientesContatos.OrderBy(Function(entity) entity.Ordem)?.FirstOrDefault(Function(entity) entity.IDCliente = id)?.Telemovel
            Return New ClsF3MCommunicationSms With {.EntityToSendSmsId = id, .MobilePhoneNumber = phoneNumber}
        End Function
#End Region
    End Class
End Namespace