Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports F3M.Repositorios.Administracao
Imports F3M.Repositorio.TabelasAuxiliaresComum

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioArmazens
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbArmazens, Armazens)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"

        Public Function ObtemArmazemPorIdLocalizacao(idLocalizacao As Long)

            Dim armazem = BDContexto.tbArmazens.
                Include("tbArmazensLocalizacoes").
                Where(Function(x) x.tbArmazensLocalizacoes.Any(Function(y) y.ID = idLocalizacao)).FirstOrDefault()


            Return armazem
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of Armazens)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        Protected Overrides Function ListaCamposTodos(inQuery As IQueryable(Of tbArmazens)) As IQueryable(Of Armazens)
            'Return RepositorioArm(Of tbArmazens, Oticas.Armazens, tbArtigosArmazensLocalizacoes).MapeiaLista(inQuery)

            Dim listaArms As IQueryable(Of Armazens) = inQuery.Select(Function(e) New Armazens With {
            .ID = e.ID,
            .Codigo = e.Codigo,
            .Descricao = e.Descricao,
            .Morada = e.Morada,
            .IDCodigoPostal = e.IDCodigoPostal,
            .DescricaoCodigoPostal = If(e.tbCodigosPostais IsNot Nothing, e.tbCodigosPostais.Descricao, Nothing),
            .CodigoCodigoPostal = If(e.tbCodigosPostais IsNot Nothing, e.tbCodigosPostais.Codigo, Nothing),
            .IDConcelho = e.IDConcelho,
            .DescricaoConcelho = If(e.tbConcelhos IsNot Nothing, e.tbConcelhos.Descricao, Nothing),
            .IDDistrito = e.IDDistrito,
            .DescricaoDistrito = If(e.tbDistritos IsNot Nothing, e.tbDistritos.Descricao, Nothing),
            .IDPais = e.IDPais,
            .DescricaoPais = If(e.tbPaises IsNot Nothing, e.tbPaises.Descricao, Nothing),
            .Ativo = e.Ativo,
            .UtilizadorCriacao = e.UtilizadorCriacao,
            .DataCriacao = e.DataCriacao,
            .UtilizadorAlteracao = e.UtilizadorAlteracao,
            .DataAlteracao = e.DataAlteracao,
            .F3MMarcador = e.F3MMarcador})

            Return listaArms.AsQueryable
        End Function

        ' LISTA COMBO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of Armazens)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        Protected Overrides Function ListaCamposCombo(inQuery As IQueryable(Of tbArmazens)) As IQueryable(Of Armazens)
            Return RepositorioArm(Of tbArmazens, Oticas.Armazens, tbArtigosArmazensLocalizacoes).MapeiaLista(inQuery, True)
        End Function

        ' LISTA FILTRADO
        Public Function ListaF4(inFiltro As ClsF3MFiltro) As IQueryable(Of Armazens)
            Return ListaCombo(inFiltro)
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbArmazens)
            Dim query As IQueryable(Of tbArmazens) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto
            Dim blnSemArea As Boolean
            ' --- GENERICO ---
            ' COMBO
            If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
                query = query.Where(Function(w) w.Descricao.Contains(filtroTxt))
            End If

            Dim listaArmazensComAcesso As New List(Of Long?)
            Using rep As New RepositorioMenus
                listaArmazensComAcesso = rep.ListaMenusAreasEmpresa(GetType(tbArmazens).Name, blnSemArea)
            End Using

            If Not blnSemArea Then
                query.Where(Function(f) f.Ativo And listaArmazensComAcesso.Contains(f.ID))
            End If

            AplicaFiltrosEOrdenacoesDasVistas(inFiltro, query)

            Return query
        End Function

        Public Function ImportaArmazemSelecionarMorada(inIDArmazem As Long) As Armazens

            armSel = (From a In BDContexto.tbArmazens
                      Where a.ID = inIDArmazem).
                        Select(Function(e) New Armazens With {
                            .Morada = e.Morada,
                            .IDConcelho = e.IDConcelho, .DescricaoConcelho = If(e.tbConcelhos.Descricao Is Nothing, String.Empty, e.tbConcelhos.Descricao),
                            .IDDistrito = e.IDDistrito, .DescricaoDistrito = If(e.tbDistritos.Descricao Is Nothing, String.Empty, e.tbDistritos.Descricao),
                            .IDCodigoPostal = e.IDCodigoPostal, .CodigoCodigoPostal = If(e.tbCodigosPostais.Codigo Is Nothing, String.Empty, e.tbCodigosPostais.Codigo), .DescricaoCodigoPostal = If(e.tbCodigosPostais.Descricao Is Nothing, String.Empty, e.tbCodigosPostais.Descricao)}
                        ).FirstOrDefault()
            Return armSel
        End Function

#End Region

#Region "ESCRITA"
        ' ADICIONA POR OBJETO
        Public Overrides Sub AdicionaObj(ByRef o As Armazens, inFiltro As ClsF3MFiltro)
            AcaoObjTransacao(o, AcoesFormulario.Adicionar)
        End Sub

        ' EDITA POR OBJETO
        Public Overrides Sub EditaObj(ByRef o As Armazens, inFiltro As ClsF3MFiltro)

            o.ExecutaListaCamposEvitaMapear = True
            o.ListaCamposEvitaMapear = New List(Of String)
            o.ListaCamposEvitaMapear.Add("IDLoja")

            AcaoObjTransacao(o, AcoesFormulario.Alterar)
        End Sub

        ' REMOVE POR OBJETO
        Public Overrides Sub RemoveObj(ByRef o As Armazens, inFiltro As ClsF3MFiltro)
            AcaoObjTransacao(o, AcoesFormulario.Remover)
        End Sub

        ' GRAVA LINHAS
        Protected Overrides Sub GravaLinhasTodas(ByRef inCtx As Oticas.BD.Dinamica.Aplicacao, ByRef o As Armazens,
                                                 e As tbArmazens, inAcao As AcoesFormulario)
            Dim dict As Dictionary(Of String, Object) = New Dictionary(Of String, Object)
            dict.Add("IDArmazem", e.ID)

            If inAcao.Equals(AcoesFormulario.Adicionar) Or inAcao.Equals(AcoesFormulario.Alterar) Then
                GravaLinhas(Of tbArmazensLocalizacoes, ArmazensLocalizacoes)(inCtx, e, o, dict)
            ElseIf inAcao.Equals(AcoesFormulario.Remover) Then
                GravaLinhasEntidades(Of tbArmazensLocalizacoes)(inCtx, e.tbArmazensLocalizacoes.ToList, AcoesFormulario.Remover, Nothing)
            End If
        End Sub
#End Region

#Region "Auxiliares"
#End Region
    End Class
End Namespace