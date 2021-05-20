Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios

Namespace Repositorio.Sistema
    Public Class RepositorioSistemaTiposEstados
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaTiposEstados, SistemaTiposEstados)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbSistemaTiposEstados)) As IQueryable(Of SistemaTiposEstados)
            Return F3M.Repositorios.Sistema.RepositorioSistemaTiposEstados.ListaCamposTodosDocs(Of tbSistemaTiposEstados, SistemaTiposEstados, tbEstados)(BDContexto, query)
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbSistemaTiposEstados)) As IQueryable(Of SistemaTiposEstados)
            Return F3M.Repositorios.Sistema.RepositorioSistemaTiposEstados.ListaCamposComboDocs(Of tbSistemaTiposEstados, SistemaTiposEstados, tbEstados)(BDContexto, query)
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of SistemaTiposEstados)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of SistemaTiposEstados)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA QUERY
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbSistemaTiposEstados)
            Dim query As IQueryable(Of tbSistemaTiposEstados) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            AplicaFiltroAtivo(inFiltro, query)


            '-- ESPECIFICO
            Dim IDEntidadeEstados As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposEspecificos.IDEntidadeEstado, GetType(Long))
            Dim strTipoEstados As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposEspecificos.tipoentidadeestado, GetType(String))

            If Not ClsTexto.ENuloOuVazio(strTipoEstados) Then
                query = query.Where(Function(w) w.tbSistemaEntidadesEstados.Codigo.Equals(strTipoEstados))
            End If
            If IDEntidadeEstados > 0 Then
                query = query.Where(Function(w) w.IDEntidadeEstado = IDEntidadeEstados)
            End If

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace