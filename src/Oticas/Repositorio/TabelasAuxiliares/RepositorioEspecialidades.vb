Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports Oticas.Modelos.Constantes

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioEspecialidades
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbEspecialidades, Especialidades)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbEspecialidades)) As IQueryable(Of Especialidades)
            Return query.Select(Function(e) New Especialidades With {
                .ID = e.ID, .Codigo = e.Codigo, .Descricao = e.Descricao, .Sistema = e.Sistema, .Ativo = e.Ativo, .EContactologia = e.EContactologia,
                .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao, .DataAlteracao = e.DataAlteracao,
                .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbEspecialidades)) As IQueryable(Of Especialidades)
            Return query.Select(Function(e) New Especialidades With {
                .ID = e.ID, .Descricao = e.Descricao
            }).Take(F3M.Modelos.Constantes.TamanhoDados.NumeroMaximo)
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of Especialidades)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of Especialidades)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbEspecialidades)
            Dim query As IQueryable(Of tbEspecialidades) = tabela.AsNoTracking
            Dim eLookup As Boolean = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.eLookup, GetType(Boolean))
            Dim filtroTxt As String = inFiltro.FiltroTexto
            Dim IDMedicoTecnico As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDMedicoTecnico", GetType(Long))

            ' --- GENERICO ---
            ' COMBO
            If Not ClsTexto.ENuloOuVazio(filtroTxt) AndAlso Not String.IsNullOrWhiteSpace(filtroTxt) Then
                query = query.Where(Function(w) w.Descricao.Contains(filtroTxt))
            End If

            'ESPECIFICO EXAMES
            If IDMedicoTecnico <> 0 Then
                query = query.Where(Function(f) f.tbMedicosTecnicosEspecialidades.Any(Function(a) a.IDMedicoTecnico = IDMedicoTecnico))
            End If

            AplicaFiltroAtivo(inFiltro, query)

            If eLookup Then
                query = query.OrderBy(Function(o) o.Descricao)
            End If

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace