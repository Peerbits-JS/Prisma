Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports System.Data.SqlClient

Namespace Repositorio
    Public Class RepositorioFornecedores
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbFornecedores, Oticas.Fornecedores)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbFornecedores)) As IQueryable(Of Oticas.Fornecedores)
            Dim listaForn As List(Of Oticas.Fornecedores) = query.ToList().Select(Function(e) New Oticas.Fornecedores With {
                .ID = e.ID, .Codigo = e.Codigo, .Nome = e.Nome, .Descricao = e.Nome, .Abreviatura = e.Abreviatura, .Apelido = e.Apelido,
                .Foto = e.Foto, .FotoCaminho = e.FotoCaminho, .FotoAnterior = e.Foto, .FotoCaminhoAnterior = e.FotoCaminho, .Observacoes = e.Observacoes,
                .IDTipoEntidade = e.IDTipoEntidade, .DataValidade = e.DataValidade, .DataNascimento = e.DataNascimento,
                .DescricaoTipoEntidade = If(e.tbSistemaTiposEntidade IsNot Nothing, e.tbSistemaTiposEntidade.Tipo, String.Empty), .IDPais = e.IDPais, .DescricaoPais = If(e.tbPaises IsNot Nothing, e.tbPaises.Descricao, String.Empty),
                .IDCondicaoPagamento = e.IDCondicaoPagamento, .DescricaoCondicaoPagamento = If(e.tbCondicoesPagamento IsNot Nothing, e.tbCondicoesPagamento.Descricao, String.Empty), .IDEspacoFiscal = e.IDEspacoFiscal,
                .DescricaoEspacoFiscal = If(e.tbSistemaEspacoFiscal IsNot Nothing, e.tbSistemaEspacoFiscal.Descricao, String.Empty), .CodigoEspacoFiscal = If(e.tbSistemaEspacoFiscal IsNot Nothing, e.tbSistemaEspacoFiscal.Codigo, String.Empty), .IDFormaPagamento = e.IDFormaPagamento, .DescricaoFormaPagamento = If(e.tbFormasPagamento IsNot Nothing, e.tbFormasPagamento.Descricao, String.Empty),
                .IDIdioma = e.IDIdioma, .DescricaoIdioma = If(e.tbIdiomas IsNot Nothing, e.tbIdiomas.Descricao, String.Empty), .IDLocalOperacao = e.IDLocalOperacao, .DescricaoLocalOperacao = If(e.tbSistemaRegioesIVA IsNot Nothing, e.tbSistemaRegioesIVA.Descricao, String.Empty),
                .IDMoeda = e.IDMoeda, .DescricaoMoeda = If(e.tbMoedas IsNot Nothing, e.tbMoedas.Descricao, String.Empty),
                .CodigoSistemaMoeda = If(e.tbMoedas IsNot Nothing, If(e.tbMoedas.tbSistemaMoedas IsNot Nothing, e.tbMoedas.tbSistemaMoedas.Codigo, String.Empty), String.Empty),
                .TaxaConversao = If(e.tbMoedas IsNot Nothing, e.tbMoedas.TaxaConversao, 0),
                .SiglaPais = If(e.tbPaises.tbSistemaSiglasPaises IsNot Nothing, e.tbPaises.tbSistemaSiglasPaises.Sigla, String.Empty),
                .CasasDecimaisIva = If(e.tbMoedas IsNot Nothing, e.tbMoedas.CasasDecimaisIva, CByte(0)),
                .CasasDecimaisPrecosUnitarios = If(e.tbMoedas IsNot Nothing, e.tbMoedas.CasasDecimaisPrecosUnitarios, CByte(0)),
                .CasasDecimaisTotais = If(e.tbMoedas IsNot Nothing, e.tbMoedas.CasasDecimaisTotais, CByte(0)),
                .Simbolo = If(e.tbMoedas IsNot Nothing, e.tbMoedas.Simbolo, String.Empty),
                .IDProfissao = e.IDProfissao, .DescricaoProfissao = If(e.tbProfissoes IsNot Nothing, e.tbProfissoes.Descricao, String.Empty),
                .IDRegimeIva = e.IDRegimeIva, .DescricaoRegimeIva = If(e.tbSistemaRegimeIVA IsNot Nothing, e.tbSistemaRegimeIVA.Descricao, String.Empty), .IDTipoPessoa = e.IDTipoPessoa, .DescricaoTipoPessoa = If(e.tbSistemaTiposPessoa IsNot Nothing, e.tbSistemaTiposPessoa.Descricao, String.Empty),
                .TituloAcademico = e.TituloAcademico, .IvaCaixa = e.IvaCaixa, .NContribuinte = e.NContribuinte,
                .NIB = e.NIB, .Avisos = e.Avisos, .CartaoCidadao = e.CartaoCidadao, .Contabilidade = e.Contabilidade,
                .RegimeEspecial = e.RegimeEspecial, .CodIQ = e.CodIQ, .EfetuaRetencao = e.EfetuaRetencao, .CodigoCliente = e.CodigoCliente,
                .Desconto1 = e.Desconto1, .Desconto2 = e.Desconto2, .IDSexo = e.IDSexo, .DescricaoSexo = If(e.tbSistemaSexo IsNot Nothing, e.tbSistemaSexo.Descricao, String.Empty),
                .Ativo = e.Ativo, .Sistema = e.Sistema, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao,
                .IDPaisFiscal = If(e.tbFornecedoresMoradas IsNot Nothing AndAlso e.tbFornecedoresMoradas.Count > 0, e.tbFornecedoresMoradas.FirstOrDefault.IDPais, Nothing),
                .DescricaoPaisFiscal = If(e.tbFornecedoresMoradas IsNot Nothing AndAlso e.tbFornecedoresMoradas.Count > 0,
                                       If(e.tbFornecedoresMoradas.FirstOrDefault.tbPaises IsNot Nothing, e.tbFornecedoresMoradas.FirstOrDefault.tbPaises.Descricao, String.Empty), String.Empty),
                .MoradaFiscal = If(e.tbFornecedoresMoradas IsNot Nothing AndAlso e.tbFornecedoresMoradas.Count > 0, e.tbFornecedoresMoradas.FirstOrDefault.Morada, String.Empty),
                .IDCodigoPostalFiscal = If(e.tbFornecedoresMoradas IsNot Nothing AndAlso e.tbFornecedoresMoradas.Count > 0, e.tbFornecedoresMoradas.FirstOrDefault.IDCodigoPostal, Nothing),
                .DescricaoCodigoPostalFiscal = If(e.tbFornecedoresMoradas IsNot Nothing AndAlso e.tbFornecedoresMoradas.Count > 0,
                                               If(e.tbFornecedoresMoradas.FirstOrDefault.tbCodigosPostais IsNot Nothing, e.tbFornecedoresMoradas.FirstOrDefault.tbCodigosPostais.Descricao, String.Empty), String.Empty),
                .IDDistritoFiscal = If(e.tbFornecedoresMoradas IsNot Nothing AndAlso e.tbFornecedoresMoradas.Count > 0, e.tbFornecedoresMoradas.FirstOrDefault.IDDistrito, Nothing),
                .DescricaoDistritoFiscal = If(e.tbFornecedoresMoradas IsNot Nothing AndAlso e.tbFornecedoresMoradas.Count > 0,
                                           If(e.tbFornecedoresMoradas.FirstOrDefault.tbDistritos IsNot Nothing, e.tbFornecedoresMoradas.FirstOrDefault.tbDistritos.Descricao, String.Empty), String.Empty),
                .IDConcelhoFiscal = If(e.tbFornecedoresMoradas IsNot Nothing AndAlso e.tbFornecedoresMoradas.Count > 0, e.tbFornecedoresMoradas.FirstOrDefault.IDConcelho, Nothing),
                .DescricaoConcelhoFiscal = If(e.tbFornecedoresMoradas IsNot Nothing AndAlso e.tbFornecedoresMoradas.Count > 0,
                                           If(e.tbFornecedoresMoradas.FirstOrDefault.tbConcelhos IsNot Nothing, e.tbFornecedoresMoradas.FirstOrDefault.tbConcelhos.Descricao, String.Empty), String.Empty),
                .Prazo = e.tbCondicoesPagamento?.Prazo,
                .ValorCondicao = e.tbCondicoesPagamento?.ValorCondicao,
                .CodigoTipoCondDataVencimento = e.tbCondicoesPagamento?.tbSistemaTiposCondDataVencimento?.Codigo,
                .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador,
                .CodCodigoPostalFiscal = If(e.tbFornecedoresMoradas IsNot Nothing AndAlso e.tbFornecedoresMoradas.Count > 0,
                                               If(e.tbFornecedoresMoradas.FirstOrDefault.tbCodigosPostais IsNot Nothing, e.tbFornecedoresMoradas.FirstOrDefault.tbCodigosPostais.Codigo, String.Empty), String.Empty)}).ToList

            Return listaForn.AsQueryable
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbFornecedores)) As IQueryable(Of Oticas.Fornecedores)
            Return ListaCamposTodos(query.Take(TamanhoDados.NumeroMaximo))
        End Function

        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of Oticas.Fornecedores)
            Dim filtroTxt As String = inFiltro.FiltroTexto

            Dim query As IQueryable(Of Oticas.Fornecedores) = AplicaQueryListaPersonalizada(inFiltro)

            FiltraQueryEspecifico(inFiltro, query)

            Return query
        End Function

        Private Sub FiltraQueryEspecifico(Of T As Class)(inFiltro As ClsF3MFiltro, ByRef query As IQueryable(Of T))
            ' --- ESPECIFICO ---
            Dim tipoEnt As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDTiposEntidade, GetType(Long))
            Dim IDTipoEnt As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDTipoEntidade, GetType(Long))
            Dim ID As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.ID, GetType(Long))

            If tipoEnt > 0 Then
                Dim funcWhere As Func(Of T, Boolean) = Function(w) CObj(w).IDTipoEntidade.Equals(tipoEnt)
                query = query.Where(funcWhere).AsQueryable
            End If

            If IDTipoEnt > 0 Then
                Dim funcWhere1 As Func(Of T, Boolean) = Function(w) CObj(w).IDTipoEntidade.Equals(IDTipoEnt) And CObj(w).Ativo = True
                query = query.Where(funcWhere1).AsQueryable
            End If

            If ID <> 0 Then
                Dim funcWhere1 As Func(Of T, Boolean) = Function(w) CObj(w).ID.Equals(ID)
                query = query.Where(funcWhere1).AsQueryable
            End If

            AplicaFiltrosEOrdenacoesDasVistas(inFiltro, query, True)
        End Sub

        ' LISTA COMBO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of Oticas.Fornecedores)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbFornecedores)
            Dim query As IQueryable(Of tbFornecedores) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            ' COMBO
            If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
                query = query.Where(Function(w) w.Nome.Contains(filtroTxt))
            End If

            AplicaFiltrosEOrdenacoesDasVistas(inFiltro, query)

            ' --- ESPECIFICO ---
            Dim tipoEnt As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDTiposEntidade, GetType(Long))
            Dim ID As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.ID, GetType(Long))
            Dim IDTipoEntidade As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDTipoEntidade", GetType(Long)) 'CABECALHO GENERICO

            If tipoEnt > 0 OrElse IDTipoEntidade <> 0 Then
                query = query.Where(Function(w) w.IDTipoEntidade.Equals(tipoEnt) OrElse w.IDTipoEntidade = IDTipoEntidade)
            End If

            'DocumentosStock || DocumentosCompras
            If ID <> 0 Then
                query = query.Where(Function(f) f.ID = ID)
            End If

            Return query
        End Function

        ' GET BY ID
        Public Overrides Function ObtemPorObjID(objID As Object) As Oticas.Fornecedores
            Dim lngObjID As Long = CLng(objID)
            Return ListaCamposTodos(tabela.AsNoTracking.Where(Function(w) w.ID.Equals(lngObjID))).FirstOrDefault
        End Function
#End Region

#Region "ESCRITA"
        ' ADICIONA POR OBJETO
        Public Overrides Sub AdicionaObj(ByRef o As Oticas.Fornecedores, inFiltro As ClsF3MFiltro)

            Dim lngIDPais = o.IDPais
            Dim p As Paises = BDContexto.tbPaises.Where(Function(f) f.IDSigla = CLng(lngIDPais)).Select(Function(y) New Paises With {.ID = y.ID, .Descricao = y.Descricao}).FirstOrDefault()

            If p IsNot Nothing Then
                o.IDPais = p.ID
                o.DescricaoPais = p.Descricao
            Else
                o.IDPais = 184
                o.DescricaoPais = "Portugal"
            End If

            If o.Codigo.Trim.Replace(" ", "") = "999999990" Then
                Throw New Exception(Traducao.EstruturaDocumentos.CodigoConsumidorFinal)
            End If

            AcaoObjTransacao(o, AcoesFormulario.Adicionar)
        End Sub

        ' EDITA POR OBJETO
        Public Overrides Sub EditaObj(ByRef o As Oticas.Fornecedores, inFiltro As ClsF3MFiltro)

            If o.Codigo.Trim.Replace(" ", "") = "999999990" Then
                Throw New Exception(Traducao.EstruturaDocumentos.CodigoConsumidorFinal)
            End If

            AcaoObjTransacao(o, AcoesFormulario.Alterar)
        End Sub

        ' REMOVE POR OBJETO
        Public Overrides Sub RemoveObj(ByRef o As Oticas.Fornecedores, inFiltro As ClsF3MFiltro)
            AcaoObjTransacao(o, AcoesFormulario.Remover)
        End Sub

        ' GRAVA LINHAS
        Protected Overrides Sub GravaLinhasTodas(ByRef inCtx As Oticas.BD.Dinamica.Aplicacao, ByRef o As Oticas.Fornecedores,
                                                 e As tbFornecedores, inAcao As AcoesFormulario)
            Try
                Dim dict As Dictionary(Of String, Object) = New Dictionary(Of String, Object)
                dict.Add("IDFornecedor", e.ID)

                If inAcao.Equals(AcoesFormulario.Adicionar) Or inAcao.Equals(AcoesFormulario.Alterar) Then
                    GravaLinhas(Of tbFornecedoresMoradas, FornecedoresMoradas)(inCtx, e, o, dict)
                    GravaLinhas(Of tbFornecedoresContatos, FornecedoresContatos)(inCtx, e, o, dict)
                    GravaLinhas(Of tbFornecedoresTiposFornecimento, FornecedoresTiposFornecimentos)(inCtx, e, o, dict)
                ElseIf inAcao.Equals(AcoesFormulario.Remover) Then
                    GravaLinhasEntidades(Of tbFornecedoresMoradas)(inCtx, e.tbFornecedoresMoradas.ToList, AcoesFormulario.Remover, Nothing)
                    GravaLinhasEntidades(Of tbFornecedoresContatos)(inCtx, e.tbFornecedoresContatos.ToList, AcoesFormulario.Remover, Nothing)
                    GravaLinhasEntidades(Of tbFornecedoresTiposFornecimento)(inCtx, e.tbFornecedoresTiposFornecimento.ToList, AcoesFormulario.Remover, Nothing)
                End If
            Catch
                Throw
            End Try
        End Sub
#End Region

#Region "ESPECIFICO"
        ' LISTA por tipo de documento
        Public Function ListaPorTipoDoc(inFiltro As ClsF3MFiltro) As IQueryable(Of Oticas.Fornecedores)
            Dim IDTipoDoc As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDTipoDocumento, GetType(Long))
            Dim codMod As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "CodigoModulo", GetType(String))
            Dim fltTxt As String = inFiltro.FiltroTexto

            If IDTipoDoc > 0 AndAlso Not ClsTexto.ENuloOuVazio(codMod) Then
                Dim query As IQueryable(Of tbFornecedores) =
                    (From td In BDContexto.tbTiposDocumento
                        Join tdp In BDContexto.tbTiposDocumentoTipEntPermDoc On td.ID Equals tdp.IDTiposDocumento
                        Join tem In BDContexto.tbSistemaTiposEntidadeModulos On tem.ID Equals tdp.IDSistemaTiposEntidadeModulos
                        Join m In BDContexto.tbSistemaModulos On m.ID Equals tem.IDSistemaModulos
                        Join te In BDContexto.tbSistemaTiposEntidade On te.ID Equals tem.IDSistemaTiposEntidade
                        Join c In tabela.AsNoTracking On c.IDTipoEntidade Equals te.ID
                        Where m.Codigo = codMod AndAlso td.ID = IDTipoDoc
                        Select c)

                If query IsNot Nothing Then
                    If Not ClsTexto.ENuloOuVazio(fltTxt) Then
                        query = query.Where(Function(w) w.Nome.Contains(fltTxt))
                    End If

                    Return ListaCamposTodos(query)
                End If
            End If

            Return Nothing
        End Function

        Public Function AtribuirCodigo() As String
            Try
                Dim strQry As String = "select cast(isnull(max(cast(isnull(codigo,0) as bigint)),0)+1 as nvarchar) as codigo from tbfornecedores where codigo<>'999999990' and codigo not like '%[^0-9]%'"
                Return BDContexto.Database.SqlQuery(Of String)(strQry).FirstOrDefault()
            Catch
                Throw
            End Try
        End Function
#End Region
    End Class
End Namespace