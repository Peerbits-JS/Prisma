Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports F3M.Repositorios.Administracao

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioParametrosEmpresa
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbParametrosEmpresa, ParametrosEmpresa)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbParametrosEmpresa)) As IQueryable(Of ParametrosEmpresa)
            Return query.Select(Function(e) New ParametrosEmpresa With {
                .ID = e.ID, .Morada = e.Morada, .CasasDecimaisPercentagem = e.CasasDecimaisPercentagem,
                .Ativo = e.Ativo, .Sistema = e.Sistema, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao,
                .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbParametrosEmpresa)) As IQueryable(Of ParametrosEmpresa)
            Return query.Select(Function(e) New ParametrosEmpresa With {
                .ID = e.ID, .Morada = e.Morada, .CasasDecimaisPercentagem = e.CasasDecimaisPercentagem
            }).Take(F3M.Modelos.Constantes.TamanhoDados.NumeroMaximo)
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of ParametrosEmpresa)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA COMBO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of ParametrosEmpresa)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbParametrosEmpresa)
            Dim query As IQueryable(Of tbParametrosEmpresa) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            ' COMBO
            If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
                query = query.Where(Function(w) w.Morada.Contains(filtroTxt))
            End If

            AplicaFiltroAtivo(inFiltro, query)

            Return query
        End Function

        ' GET BY ID
        Public Overrides Function ObtemPorObjID(objID As Object) As ParametrosEmpresa
            Dim lngObjID As Long = CLng(objID)
            Return ListaCamposTodos(tabela.AsNoTracking.Where(Function(w) w.ID.Equals(lngObjID))).FirstOrDefault
        End Function
#End Region

#Region "ESCRITA"
        ' ADICIONA POR OBJETO
        Public Overrides Sub AdicionaObj(ByRef o As ParametrosEmpresa, inFiltro As ClsF3MFiltro)
            AcaoObjTransacao(o, AcoesFormulario.Adicionar)
        End Sub

        ' EDITA POR OBJETO
        Public Overrides Sub EditaObj(ByRef o As ParametrosEmpresa, inFiltro As ClsF3MFiltro)
            AcaoObjTransacao(o, AcoesFormulario.Alterar)
        End Sub

        ' REMOVE POR OBJETO
        Public Overrides Sub RemoveObj(ByRef o As ParametrosEmpresa, inFiltro As ClsF3MFiltro)
            AcaoObjTransacao(o, AcoesFormulario.Remover)
        End Sub

#End Region

    End Class
End Namespace