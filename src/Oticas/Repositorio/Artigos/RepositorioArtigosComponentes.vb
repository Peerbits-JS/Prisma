Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios

Namespace Repositorio.Artigos
    Public Class RepositorioArtigosComponentes
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, tbArtigosComponentes, ArtigosComponentes)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbArtigosComponentes)) As IQueryable(Of ArtigosComponentes)
            Return query.Select(Function(e) New ArtigosComponentes With {
                .ID = e.ID, .IDArtigo = e.IDArtigo, .DescricaoArtigo = e.tbArtigos.Descricao, .IDSistemaTiposComponente = e.IDSistemaTiposComponente,
                .IDArtigoDimensaoLinha1 = e.IDArtigoDimensaoLinha1,
                .DescricaoArtigoDimensaoLinha1 = If(String.IsNullOrEmpty(e.tbDimensoesLinhas.Descricao), "", e.tbDimensoesLinhas.Descricao),
                .IDArtigoDimensaoLinha2 = e.IDArtigoDimensaoLinha2,
                .DescricaoArtigoDimensaoLinha2 = If(String.IsNullOrEmpty(e.tbDimensoesLinhas2.Descricao), "", e.tbDimensoesLinhas2.Descricao),
                .IDArtigoComponente = e.IDArtigoComponente, .DescricaoArtigoComponente = e.tbArtigos1.Descricao,
                .IDArtigoDimensaoLinha1Componente = e.IDArtigoDimensaoLinha1Componente,
                .DescricaoArtigoDimensaoLinha1Componente = If(String.IsNullOrEmpty(e.tbDimensoesLinhas1.Descricao), "", e.tbDimensoesLinhas1.Descricao),
                .IDArtigoDimensaoLinha2Componente = e.IDArtigoDimensaoLinha2Componente,
                .DescricaoArtigoDimensaoLinha2Componente = If(String.IsNullOrEmpty(e.tbDimensoesLinhas3.Descricao), "", e.tbDimensoesLinhas3.Descricao),
                .Quantidade = e.Quantidade, .UltimoPrecoCusto = e.UltimoPrecoCusto, .PrecoCustoPadrao = e.PrecoCustoPadrao, .PrecoCustoMedio = e.PrecoCustoMedio,
                .Sistema = e.Sistema, .Ativo = e.Ativo, .DataCriacao = e.DataCriacao,
                .UtilizadorCriacao = e.UtilizadorCriacao, .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao,
                .F3MMarcador = e.F3MMarcador, .CodigoSistemaTipoDim = e.tbArtigos1.tbSistemaTiposDimensoes.Codigo, .Ordem = e.Ordem})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbArtigosComponentes)) As IQueryable(Of ArtigosComponentes)
            Return query.Select(Function(e) New ArtigosComponentes With {
                .ID = e.ID
            })
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of ArtigosComponentes)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of ArtigosComponentes)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ''' <summary>
        ''' Para filtrar a tabela
        ''' </summary>
        ''' <param name="inFiltro"></param>
        ''' <returns></returns>
        ''' <remarks></remarks>
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbArtigosComponentes)
            Dim query As IQueryable(Of tbArtigosComponentes) = tabela.AsNoTracking
            Dim IDArt As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDArtigo, GetType(Long))
            Dim IDTipoComponente As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDTipoComponente, GetType(Long))

            AplicaFiltroAtivo(inFiltro, query)

            query = query.Where(Function(o) o.IDArtigo = IDArt And o.tbSistemaTiposComponente.ID = IDTipoComponente)

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region

#Region "FUNÇÕES AUXILIARES"
        Public Function ExistemComponentes(ByVal IDArtigo As Long) As Boolean
            Dim query As IQueryable(Of tbArtigosComponentes) = tabela.AsNoTracking
            Dim result As Boolean = False

            query = query.Where(Function(o) o.IDArtigo = IDArtigo)

            result = If(query.Count > 0, True, False)

            Return result
        End Function
#End Region
    End Class
End Namespace

