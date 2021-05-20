Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports System.Data.Entity
Imports F3M

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioSegmentosMarcas
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbSegmentosMarcas, SegmentosMarcas)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbSegmentosMarcas)) As IQueryable(Of SegmentosMarcas)
            Return query.Select(Function(entity) New SegmentosMarcas With {
                .ID = entity.ID, .Codigo = entity.Codigo, .Descricao = entity.Descricao,
                .Sistema = entity.Sistema, .Ativo = entity.Ativo, .DataCriacao = entity.DataCriacao, .UtilizadorCriacao = entity.UtilizadorCriacao,
                .DataAlteracao = entity.DataAlteracao, .UtilizadorAlteracao = entity.UtilizadorAlteracao, .F3MMarcador = entity.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbSegmentosMarcas)) As IQueryable(Of SegmentosMarcas)
            Return query.
                Select(Function(entity) New SegmentosMarcas With {.ID = entity.ID, .Codigo = entity.Codigo, .Descricao = entity.Descricao}).
                Take(TamanhoDados.NumeroMaximo)
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of SegmentosMarcas)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of SegmentosMarcas)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        Public Function ListaSegmentosMarcas(IDModelo As Long?) As List(Of SegmentosMarcas)
            'Return tabela.
            '    Where(Function(entity) entity.IDModelo = IDModelo AndAlso entity.Ativo).
            '    Select(Function(entity) New SegmentosMarcas With {.ID = entity.ID, .Descricao = entity.Descricao}).
            '    OrderBy(Function(entity) entity.Descricao).
            '    ToList()
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbSegmentosMarcas)
            Dim query As IQueryable(Of tbSegmentosMarcas) = tabela.AsNoTracking()

            'Especifico -  Modelos catalogo lentes
            Dim isFromCatalogoLentes As Boolean = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "catalogolentes", GetType(Boolean))
            If isFromCatalogoLentes Then
                Dim IDModeloCL As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDModelo", GetType(Long))
                'query = query.Where(Function(entity) entity.IDModelo = IDModeloCL)

            Else
                ' --- GENERICO ---
                ' COMBO
                Dim filtroTxt As String = inFiltro.FiltroTexto
                If Not String.IsNullOrEmpty(filtroTxt) Then query = query.Where(Function(w) w.Descricao.Contains(filtroTxt))

                Dim IDModelo As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDModelo", GetType(Long))
                If IDModelo <> 0 Then
                    'query = query.Where(Function(entity) entity.IDModelo = IDModelo)
                End If
            End If

            Return query.OrderBy(Function(entity) entity.Descricao)
        End Function
#End Region

#Region "ESCRITA"
#End Region

#Region "FUNÇÕES AUXILIARES"
        Public Function getDescricaoTratamento(IDTratamento As Long) As String
            Return tabela.AsNoTracking().FirstOrDefault(Function(entity) entity.ID = IDTratamento)?.Descricao
        End Function

        Public Function ProximoCodigo() As String
            Return ClsUtilitarios.AtribuirCodigo(BDContexto, "tbSegmentosMarcas")
        End Function
#End Region
    End Class
End Namespace