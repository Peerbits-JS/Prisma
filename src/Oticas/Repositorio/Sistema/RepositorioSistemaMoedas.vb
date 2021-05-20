Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios

Namespace Repositorio.Sistema
    Public Class RepositorioSistemaMoedas
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaMoedas, F3M.SistemaMoedas)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbSistemaMoedas)) As IQueryable(Of F3M.SistemaMoedas)
            Return query.Select(Function(e) New F3M.SistemaMoedas With {
                .ID = e.ID, .Codigo = e.Codigo, .Descricao = e.Descricao,
                .Ativo = e.Ativo, .Sistema = e.Sistema, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao,
                .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador
            })
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbSistemaMoedas)) As IQueryable(Of F3M.SistemaMoedas)
            Return query.Select(Function(e) New F3M.SistemaMoedas With {
                .ID = e.ID, .Codigo = e.Codigo, .Descricao = e.Descricao
            })
        End Function

        Protected Function ListaCamposTodosEspecial(query As IQueryable(Of F3M.SistemaMoedas)) As IQueryable(Of F3M.SistemaMoedas)
            Return query.Select(Function(e) New F3M.SistemaMoedas With {
                .ID = e.ID, .Codigo = e.Codigo, .Descricao = e.Descricao,
                .CasasDecimaisTotais = e.CasasDecimaisTotais, .CasasDecimaisIva = e.CasasDecimaisIva,
                .CasasDecimaisPrecosUnitarios = e.CasasDecimaisPrecosUnitarios,
                .Ativo = e.Ativo, .Sistema = e.Sistema, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao,
                .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador
            })
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of F3M.SistemaMoedas)
            'Dim listaLM As IQueryable(Of SistemaMoedas) = ListaCamposTodos(FiltraQuery(inFiltro))
            Dim listaLM As IQueryable(Of F3M.SistemaMoedas) = Nothing

            ' LISTA LOGICA MOEDA DO F3MSGPGeralEntidades
            Using rep As New F3M.Repositorios.Sistema.RepositorioSistemaMoedas
                Dim queryLMGeral As IQueryable(Of F3M.SistemaMoedas) = rep.Lista(inFiltro)

                listaLM = ListaCamposTodosEspecial(queryLMGeral)
            End Using

            Return listaLM
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of F3M.SistemaMoedas)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA QUERY
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbSistemaMoedas)
            Dim query As IQueryable(Of tbSistemaMoedas) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            AplicaFiltroAtivo(inFiltro, query)

            'If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
            '    query = query.Where(Function(o) o.Descricao.Contains(filtroTxt))
            'End If

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace