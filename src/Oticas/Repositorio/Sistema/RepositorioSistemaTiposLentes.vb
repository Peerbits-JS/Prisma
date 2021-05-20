Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios

Namespace Repositorio.Sistema
    Public Class RepositorioSistemaTiposLentes
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaTiposLentes, SistemaTiposLentes)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbSistemaTiposLentes)) As IQueryable(Of SistemaTiposLentes)
            Return query.Select(Function(entity) New SistemaTiposLentes With {
                .ID = entity.ID, .Codigo = entity.Codigo, .Descricao = entity.Descricao,
                 .IDSistemaClassificacao = entity.IDSistemaClassificacao,
                 .Sistema = entity.Sistema, .Ativo = entity.Ativo,
                 .DataCriacao = entity.DataCriacao, .UtilizadorCriacao = entity.UtilizadorCriacao, .DataAlteracao = entity.DataAlteracao,
                .UtilizadorAlteracao = entity.UtilizadorAlteracao, .F3MMarcador = entity.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbSistemaTiposLentes)) As IQueryable(Of SistemaTiposLentes)
            Return query.Select(Function(entity) New SistemaTiposLentes With {.ID = entity.ID, .Descricao = entity.Descricao, .Codigo = entity.Codigo, .IDSistemaClassificacao = entity.IDSistemaClassificacao})
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of SistemaTiposLentes)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of SistemaTiposLentes)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA QUERY
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbSistemaTiposLentes)
            Dim query As IQueryable(Of tbSistemaTiposLentes) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            AplicaFiltroAtivo(inFiltro, query)

            Dim strView As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "View", GetType(String))
            If Not String.IsNullOrEmpty(strView) Then
                query = query.Where(Function(x) x.tbSistemaClassificacoesTiposArtigos.Codigo = "LO")
            End If

            Dim IDTipoArtigo As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDTipoArtigo", GetType(Long))
            If IDTipoArtigo <> 0 Then
                query = query.Where(Function(entity) entity.tbSistemaClassificacoesTiposArtigos.ID = IDTipoArtigo)
            End If

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region

#Region "FUNÇÕES AUXILIARES"
        Public Function ListaTiposLentes(ByVal IDTipoLenteClassificacao As Long, ByVal IDTipoServico As Long, ByVal IDTipoOlho As Long) As List(Of SistemaTiposLentes)
            Dim list As New List(Of SistemaTiposLentes)
            Dim IDTipoLente As Long = 0
            Dim IDTipoLente2 As Long = 0

            If IDTipoServico <> 0 Then
                Select Case IDTipoServico
                    Case 1, 2, 3, 7 And IDTipoOlho = 2, 8 And IDTipoOlho = 1, 9 And IDTipoOlho = 2, 10 And IDTipoOlho = 1 'UNIFOCAL
                        IDTipoLente = 1
                        IDTipoLente2 = 4

                    Case 4, 7 And IDTipoOlho = 1, 8 And IDTipoOlho = 2 'BIFOCAL (AMBOS / OD / OE)
                        IDTipoLente = 2

                    Case 5, 9 And IDTipoOlho = 1, 10 And IDTipoOlho = 2 'PROGRESSIVA (AMBOS / OD / OE)
                        IDTipoLente = 3
                        IDTipoLente2 = 4
                End Select

                list = BDContexto.tbSistemaTiposLentes.Where(
                    Function(w) w.ID = IDTipoLente Or w.ID = IDTipoLente2).Select(
                    Function(s) New SistemaTiposLentes With {.ID = s.ID, .Descricao = s.Descricao}).OrderBy(
                    Function(o) o.Descricao).ToList()

            Else
                list = BDContexto.tbSistemaTiposLentes.Where(
                    Function(f) f.IDSistemaClassificacao = IDTipoLenteClassificacao).Select(
                    Function(s) New SistemaTiposLentes With {.ID = s.ID, .Descricao = s.Descricao}).OrderBy(
                    Function(o) o.Descricao).ToList()
            End If

            Return list
        End Function
#End Region
    End Class
End Namespace