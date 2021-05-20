Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios

Namespace Repositorio.Sistema
    Public Class RepositorioSistemaCompostoTransformacaoMetodoCusto
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaCompostoTransformacaoMetodoCusto, SistemaCompostoTransformacaoMetodoCusto)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbSistemaCompostoTransformacaoMetodoCusto)) As IQueryable(Of SistemaCompostoTransformacaoMetodoCusto)
            Return query.Select(Function(e) New SistemaCompostoTransformacaoMetodoCusto With {
                .ID = e.ID, .Codigo = e.Codigo, .Descricao = e.Descricao
            })
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbSistemaCompostoTransformacaoMetodoCusto)) As IQueryable(Of SistemaCompostoTransformacaoMetodoCusto)
            Return query.Select(Function(e) New SistemaCompostoTransformacaoMetodoCusto With {
                .ID = e.ID, .Descricao = e.Descricao
            })
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of SistemaCompostoTransformacaoMetodoCusto)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of SistemaCompostoTransformacaoMetodoCusto)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbSistemaCompostoTransformacaoMetodoCusto)
            Dim query As IQueryable(Of tbSistemaCompostoTransformacaoMetodoCusto) = tabela.AsNoTracking

            ' COMBO (GENERICO)
            'If Not ClsTexto.ENuloOuVazio(inFiltro.FiltroTexto) Then
            '    'DEFINE FILTRO DOS RESOURCES
            '    Dim resourceByValue As List(Of String) = Traducao.Traducao.ClsTraducao.ReturnKeysByValues(inFiltro.FiltroTexto, ClsF3MSessao.Idioma, Nothing)
            '    query = query.Where(Function(o) resourceByValue.Contains(o.Descricao))
            'End If

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace