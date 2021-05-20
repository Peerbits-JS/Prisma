Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports F3M.Modelos.Autenticacao

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioTiposDocumentoSeriesPermissoes
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, tbTiposDocumentoSeriesPermissoes, TiposDocumentoSeriesPermissoes)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbTiposDocumentoSeriesPermissoes)) As IQueryable(Of TiposDocumentoSeriesPermissoes)
            Return query.Select(Function(e) New TiposDocumentoSeriesPermissoes With {
                .ID = e.ID, .Ativo = e.Ativo, .Sistema = e.Sistema,
                .IDPerfil = e.IDPerfil, .IDSerie = e.IDSerie,
                .PermissaoAdicionar = e.PermissaoAdicionar, .PermissaoAlterar = e.PermissaoAlterar, .PermissaoRemover = e.PermissaoRemover, .PermissaoConsultar = e.PermissaoConsultar,
                .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao, .DataAlteracao = e.DataAlteracao,
                .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador
            })
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbTiposDocumentoSeriesPermissoes)) As IQueryable(Of TiposDocumentoSeriesPermissoes)
            Return query.Select(Function(e) New TiposDocumentoSeriesPermissoes With {
                .ID = e.ID
            }).Take(F3M.Modelos.Constantes.TamanhoDados.NumeroMaximo)
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of TiposDocumentoSeriesPermissoes)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of TiposDocumentoSeriesPermissoes)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA QUERY
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbTiposDocumentoSeriesPermissoes)
            Dim query As IQueryable(Of tbTiposDocumentoSeriesPermissoes) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            ' COMBO
            If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
                'query = query.Where(Function(w) w.Descricao.Contains(filtroTxt))
            End If

            AplicaFiltroAtivo(inFiltro, query)


            Return query
        End Function

        Public Shared Function RetornaPermissoesTabela(IDSerie As Long) As List(Of F3M.PerfisAcessosAreasEmpresa)
            Dim lstPermissoes As New List(Of F3M.PerfisAcessosAreasEmpresa)
            Using rep As New RepositorioTiposDocumentoSeriesPermissoes
                lstPermissoes = rep.getPermissoes(IDSerie)
            End Using
            Return lstPermissoes
        End Function
#End Region

#Region "ESCRITA"
#End Region


        'FUNÇÕES AUXILIARES
        Public Function getPermissoes(IDSerie As Long) As List(Of F3M.PerfisAcessosAreasEmpresa)
            Dim dicPerfis As New Dictionary(Of Long, String)
            Dim listPermissoesBySerie As New List(Of TiposDocumentoSeriesPermissoes)
            Dim listPermissoesByPerfilArea As New List(Of F3M.PerfisAcessosAreasEmpresa)
            Dim IDMenuAreaEmpresa As Long = 0

            Using rp As New F3M.Repositorios.Administracao.RepositorioPerfis
                dicPerfis = rp.getDicPerfis()
            End Using

            Using rpMenuAreaEmpseries As New F3M.Repositorios.Administracao.RepositorioMenusAreas
                IDMenuAreaEmpresa = rpMenuAreaEmpseries.getIDDocSerieMenusAreasEmpresasAtual("DocumentosSeries")
            End Using

            Using rpA As New F3M.Repositorios.Administracao.RepositorioPerfisAcessosEmpresa
                listPermissoesByPerfilArea = rpA.getList(IDSerie, IDMenuAreaEmpresa)
            End Using

            For Each lin In dicPerfis
                Dim TiposPermissoes As New F3M.PerfisAcessosAreasEmpresa
                Dim blnExistePerfil As Boolean = If(listPermissoesByPerfilArea.Where(Function(f) f.IDPerfis = lin.Key).Count > 0, True, False)

                If (Not blnExistePerfil) Then
                    With TiposPermissoes : .IDLinhaTabela = IDSerie : .IDPerfis = lin.Key : .IDMenusAreasEmpresa = IDMenuAreaEmpresa
                        .Adicionar = False : .Alterar = False : .Remover = False : .Consultar = False
                        .Sistema = False : .Ativo = True : .UtilizadorCriacao = ClsF3MSessao.RetornaUtilizadorNome : .Descricao = String.Empty
                    End With

                    listPermissoesByPerfilArea.Add(TiposPermissoes)
                End If
            Next

            For Each x In listPermissoesByPerfilArea
                x.Descricao = If(dicPerfis.ContainsKey(x.IDPerfis), dicPerfis.Item(x.IDPerfis), String.Empty)
            Next

            listPermissoesByPerfilArea = (listPermissoesByPerfilArea.Where(Function(x) Not String.IsNullOrEmpty(x.Descricao)).OrderBy(Function(f) f.Descricao)).ToList()

            Return listPermissoesByPerfilArea
        End Function
    End Class
End Namespace