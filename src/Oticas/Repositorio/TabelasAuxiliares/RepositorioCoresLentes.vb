Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports System.Data.Entity
Imports F3M

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioCoresLentes
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, tbCoresLentes, CoresLentes)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbCoresLentes)) As IQueryable(Of CoresLentes)
            Return query.Select(Function(entity) New CoresLentes With {
                .ID = entity.ID, .Codigo = entity.Codigo, .Descricao = entity.Descricao, .IDMarca = entity.IDMarca, .DescricaoMarca = entity.tbMarcas.Descricao,
                .IDModelo = entity.IDModelo, .DescricaoModelo = entity.tbModelos.Descricao, .Cor = entity.Cor, .PrecoVenda = entity.PrecoVenda, .PrecoCusto = entity.PrecoCusto,
                .IDTipoLente = entity.IDTipoLente, .DescricaoTipoLente = entity.tbSistemaTiposLentes.Descricao,
                .IDMateriaLente = entity.IDMateriaLente, .DescricaoMateriaLente = entity.tbSistemaMateriasLentes.Descricao,
                .CodForn = entity.CodForn, .Referencia = entity.Referencia, .ModeloForn = entity.ModeloForn, .Observacoes = entity.Observacoes,
                .Sistema = entity.Sistema, .Ativo = entity.Ativo, .DataCriacao = entity.DataCriacao, .UtilizadorCriacao = entity.UtilizadorCriacao,
                .DataAlteracao = entity.DataAlteracao, .UtilizadorAlteracao = entity.UtilizadorAlteracao, .F3MMarcador = entity.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbCoresLentes)) As IQueryable(Of CoresLentes)
            Return query.
                Select(Function(entity) New CoresLentes With {.ID = entity.ID, .Descricao = entity.Descricao}).
                Take(TamanhoDados.NumeroMaximo)
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of CoresLentes)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of CoresLentes)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        Public Function ListaCoresLentes(IDModelo As Long, IDMarca As Long, IDTipoLente As Long, IDMateriaLente As Long) As List(Of CoresLentes)
            Return FiltraQueryCoresLentes(tabela.AsNoTracking(), IDModelo, IDMarca, IDTipoLente, IDMateriaLente).
                Select(Function(entity) New CoresLentes With {.ID = entity.ID, .Descricao = entity.Descricao}).
                OrderBy(Function(dto) dto.Descricao).
                ToList()
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbCoresLentes)
            Dim query As IQueryable(Of tbCoresLentes) = tabela.AsNoTracking

            'Especifico -  Modelos catalogo lentes
            Dim isFromCatalogoLentes As Boolean = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "catalogolentes", GetType(Boolean))
            If isFromCatalogoLentes Then
                Dim IDModeloCL As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDModelo", GetType(Long))
                Dim IDMarcaCL As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDMarca", GetType(Long))
                Dim IDTipoLenteCL As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDTipoLente", GetType(Long))
                Dim IDMateriaLenteCL As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDMateriaLente", GetType(Long))

                query = FiltraQueryCoresLentes(query, IDModeloCL, IDMarcaCL, IDTipoLenteCL, IDMateriaLenteCL)

            Else
                ' --- GENERICO ---
                ' COMBO
                Dim filtroTxt As String = inFiltro.FiltroTexto
                If Not String.IsNullOrEmpty(filtroTxt) Then query = query.Where(Function(entity) entity.Descricao.Contains(filtroTxt))

                Dim IDModelo As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDModelo", GetType(Long))
                If IDModelo <> 0 Then query = query.Where(Function(entity) entity.IDModelo = IDModelo OrElse entity.IDModelo Is Nothing)
            End If

            Return query.OrderBy(Function(entity) entity.Descricao)
        End Function

        Private Function FiltraQueryCoresLentes(query As IQueryable(Of tbCoresLentes),
                                 IDModelo As Long,
                                 IDMarca As Long,
                                 IDTiposLentes As Long,
                                 IDMateriaLentes As Long) As IQueryable(Of tbCoresLentes)

            Return query.
                Where(Function(entity) entity.Ativo = True AndAlso
                entity.IDMarca = IDMarca AndAlso
                entity.IDTipoLente = IDTiposLentes AndAlso
                entity.IDMateriaLente = IDMateriaLentes AndAlso
                (entity.IDModelo = IDModelo OrElse entity.IDModelo Is Nothing))
        End Function
#End Region

#Region "ESCRITA"
#End Region

#Region "FUNLÇÕES AUXILIARES"
        Public Function getDescricaoCor(ByVal IDCor As Long) As String
            Return tabela.AsNoTracking().FirstOrDefault(Function(entity) entity.ID = IDCor)?.Descricao
        End Function

        Public Function ProximoCodigo() As String
            Return ClsUtilitarios.AtribuirCodigo(BDContexto, "tbCoresLentes")
        End Function
#End Region
    End Class
End Namespace