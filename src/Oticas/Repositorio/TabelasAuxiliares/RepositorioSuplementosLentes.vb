Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports System.Data.Entity
Imports F3M

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioSuplementosLentes
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbSuplementosLentes, SuplementosLentes)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbSuplementosLentes)) As IQueryable(Of SuplementosLentes)
            Return query.Select(Function(entity) New SuplementosLentes With {
                .ID = entity.ID, .Codigo = entity.Codigo, .Descricao = entity.Descricao, .IDMarca = entity.IDMarca, .DescricaoMarca = entity.tbMarcas.Descricao,
                .IDModelo = entity.IDModelo, .DescricaoModelo = entity.tbModelos.Descricao, .Cor = entity.Cor, .PrecoVenda = entity.PrecoVenda, .PrecoCusto = entity.PrecoCusto,
                .IDTipoLente = entity.IDTipoLente, .DescricaoTipoLente = entity.tbSistemaTiposLentes.Descricao,
                .IDMateriaLente = entity.IDMateriaLente, .DescricaoMateriaLente = entity.tbSistemaMateriasLentes.Descricao,
                .CodForn = entity.CodForn, .Referencia = entity.Referencia, .ModeloForn = entity.ModeloForn, .Observacoes = entity.Observacoes,
                .Sistema = entity.Sistema, .Ativo = entity.Ativo, .DataCriacao = entity.DataCriacao, .UtilizadorCriacao = entity.UtilizadorCriacao,
                .DataAlteracao = entity.DataAlteracao, .UtilizadorAlteracao = entity.UtilizadorAlteracao, .F3MMarcador = entity.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbSuplementosLentes)) As IQueryable(Of SuplementosLentes)
            Return query.
                Select(Function(entity) New SuplementosLentes With {.ID = entity.ID, .Descricao = entity.Descricao}).
                Take(TamanhoDados.NumeroMaximo)
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of SuplementosLentes)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of SuplementosLentes)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        Public Function ListaSuplementos(IDModelo As Long, IDMarca As Long, IDTipoLente As Long, IDMateriaLente As Long) As List(Of SuplementosLentes)
            Return FiltraQuerySuplementosLentes(tabela.AsNoTracking(), IDModelo, IDMarca, IDTipoLente, IDMateriaLente).
                Select(Function(entity) New SuplementosLentes With {.ID = entity.ID, .Descricao = entity.Descricao}).
                OrderBy(Function(entity) entity.Descricao).
                ToList()
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbSuplementosLentes)
            Dim query As IQueryable(Of tbSuplementosLentes) = tabela.AsNoTracking

            'Especifico -  Modelos catalogo lentes
            Dim isFromCatalogoLentes As Boolean = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "catalogolentes", GetType(Boolean))
            If isFromCatalogoLentes Then
                Dim IDModeloCL As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDModelo", GetType(Long))
                Dim IDMarcaCL As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDMarca", GetType(Long))
                Dim IDTipoLenteCL As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDTipoLente", GetType(Long))
                Dim IDMateriaLenteCL As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDMateriaLente", GetType(Long))

                query = FiltraQuerySuplementosLentes(query, IDModeloCL, IDMarcaCL, IDTipoLenteCL, IDMateriaLenteCL)

            Else
                ' --- GENERICO ---
                ' COMBO
                Dim filtroTxt As String = inFiltro.FiltroTexto
                If Not String.IsNullOrEmpty(filtroTxt) Then query = query.Where(Function(entity) entity.Descricao.Contains(filtroTxt))
            End If

            Return query.OrderBy(Function(entity) entity.Descricao)
        End Function

        Private Function FiltraQuerySuplementosLentes(query As IQueryable(Of tbSuplementosLentes),
                                 IDModelo As Long,
                                 IDMarca As Long,
                                 IDTiposLentes As Long,
                                 IDMateriaLentes As Long) As IQueryable(Of tbSuplementosLentes)

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

#Region "FUNÇÕES AUXILIARES"
        Public Function getArrayDescricaoByIDs(array() As String)
            Return tabela.
                AsNoTracking().
                Where(Function(entity) array.Contains(entity.ID)).
                Select(Function(entity) entity.Descricao)
        End Function

        Public Function ProximoCodigo() As String
            Return ClsUtilitarios.AtribuirCodigo(BDContexto, "tbSuplementosLentes")
        End Function
#End Region
    End Class
End Namespace