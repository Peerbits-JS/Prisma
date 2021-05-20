Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioEntidadesComparticipacoes
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, tbEntidadesComparticipacoes, EntidadesComparticipacoes)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbEntidadesComparticipacoes)) As IQueryable(Of EntidadesComparticipacoes)
            Return query.Select(Function(e) New EntidadesComparticipacoes With {
                .ID = e.ID, .IDEntidade = e.IDEntidade, .DescricaoEntidade = e.tbEntidades.Descricao, .IDTipoArtigo = e.IDTipoArtigo, .DescricaoTipoArtigo = e.tbTiposArtigos.Descricao,
                .IDTipoLente = e.IDTipoLente, .DescricaoTipoLente = If(e.tbSistemaTiposLentes.Descricao Is Nothing, String.Empty, e.tbSistemaTiposLentes.Descricao),
                .Duracao = e.Duracao, .ValorMaximo = e.ValorMaximo, .Quantidade = e.Quantidade, .Percentagem = e.Percentagem, .PotenciaEsfericaDe = e.PotenciaEsfericaDe, .PotenciaEsfericaAte = e.PotenciaEsfericaAte,
                .PotenciaCilindricaDe = e.PotenciaCilindricaDe, .PotenciaCilindricaAte = e.PotenciaCilindricaAte, .PotenciaPrismaticaDe = e.PotenciaPrismaticaDe, .PotenciaPrismaticaAte = e.PotenciaPrismaticaAte,
                .Sistema = e.Sistema, .Ativo = e.Ativo, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao,
                .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbEntidadesComparticipacoes)) As IQueryable(Of EntidadesComparticipacoes)
            Return query.Select(Function(e) New EntidadesComparticipacoes With {
                .ID = e.ID, .IDEntidade = e.IDEntidade
            }).Take(F3M.Modelos.Constantes.TamanhoDados.NumeroMaximo)
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of EntidadesComparticipacoes)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA COMBO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of EntidadesComparticipacoes)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ''' <summary>
        ''' Para filtrar a tabela
        ''' </summary>
        ''' <param name="inFiltro"></param>
        ''' <returns></returns>
        ''' <remarks></remarks>
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbEntidadesComparticipacoes)
            Dim query As IQueryable(Of tbEntidadesComparticipacoes) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            ' COMBO
            If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
                query = query.Where(Function(w) w.tbEntidades.Descricao.Contains(filtroTxt))
            End If

            AplicaFiltroAtivo(inFiltro, query)

            ' --- ESPECIFICO ---
            Dim IDFT As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDEntidade, GetType(Long))
            query = query.Where(Function(o) o.IDEntidade = IDFT).OrderBy(Function(o) o.ID)

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace