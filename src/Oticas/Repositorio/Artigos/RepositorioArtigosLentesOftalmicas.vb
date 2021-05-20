Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios

Namespace Repositorio.Artigos
    Public Class RepositorioArtigosLentesOftalmicas
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, tbLentesOftalmicas, ArtigosLentesOftalmicas)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbLentesOftalmicas)) As IQueryable(Of ArtigosLentesOftalmicas)
            Return query.Select(Function(e) New ArtigosLentesOftalmicas With {
                .ID = e.ID, .IDArtigo = e.IDArtigo, .IDModelo = e.IDModelo, .DescricaoModelo = e.tbModelos.Descricao,
                .IDTratamentoLente = e.IDTratamentoLente, .DescricaoTratamentoLente = e.tbTratamentosLentes.Descricao, .Diametro = e.Diametro, .PotenciaEsferica = e.PotenciaEsferica,
                .PotenciaCilindrica = e.PotenciaCilindrica, .PotenciaPrismatica = e.PotenciaPrismatica, .Adicao = e.Adicao, .CodigosSuplementos = e.CodigosSuplementos,
                .IDCorLente = e.IDCorLente, .DescricaoCorLente = e.tbCoresLentes.Descricao, .IDTipoLente = e.tbModelos.IDTipoLente, .IdMateriaLente = e.tbModelos.IDMateriaLente,
                .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao, .DataAlteracao = e.DataAlteracao,
                .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbLentesOftalmicas)) As IQueryable(Of ArtigosLentesOftalmicas)
            Return query.Select(Function(e) New ArtigosLentesOftalmicas With {
                .ID = e.ID
            })
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of ArtigosLentesOftalmicas)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of ArtigosLentesOftalmicas)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbLentesOftalmicas)
            Dim query As IQueryable(Of tbLentesOftalmicas) = tabela.AsNoTracking
            Dim IDArt As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDArtigo, GetType(Long))

            AplicaFiltroAtivo(inFiltro, query)

            query = query.Where(Function(o) o.IDArtigo = IDArt)

            Return query
        End Function
#End Region

#Region "ESCRITA"
        Public Sub GravaObjEsp(ByRef inCtx As BD.Dinamica.Aplicacao, ByRef o As ArtigosLentesOftalmicas, inAcao As AcoesFormulario, lst As List(Of ArtigosLentesOftalmicasSuplementos))
            Try
                Dim e As tbLentesOftalmicas = GravaObjContexto(inCtx, o, inAcao)
                If e.ID = 0 Then
                    GravaEntidadeLinha(inCtx, e, AcoesFormulario.Adicionar, Nothing)
                End If

                inCtx.SaveChanges()
                ' GRAVA LINHAS
                GravaLinhasTodas(inCtx, o, e, inAcao, lst)
                o.ID = e.ID
            Catch
                Throw
            End Try
        End Sub

        ' GRAVA LINHAS
        Protected Shadows Sub GravaLinhasTodas(ByRef inCtx As BD.Dinamica.Aplicacao, ByRef o As ArtigosLentesOftalmicas, e As tbLentesOftalmicas, inAcao As AcoesFormulario, lst As List(Of ArtigosLentesOftalmicasSuplementos))
            Try
                GravaLinhasEntidades(Of tbLentesOftalmicasSuplementos)(inCtx, e.tbLentesOftalmicasSuplementos.ToList, AcoesFormulario.Remover, Nothing)

                    o.ArtigosLentesOftalmicasSuplementos = lst

                    For Each lin In o.ArtigosLentesOftalmicasSuplementos
                        lin.IDLenteOftalmica = e.ID
                        lin.UtilizadorCriacao = e.UtilizadorCriacao
                        lin.DataCriacao = Now
                    Next

                    GravaLinhas(Of tbLentesOftalmicasSuplementos, ArtigosLentesOftalmicasSuplementos)(inCtx, e, o, Nothing)
            Catch
                Throw
            End Try
        End Sub

        Public Sub DEL(ByRef inCtx As BD.Dinamica.Aplicacao, ByVal e As tbLentesOftalmicas)
            GravaLinhasEntidades(Of tbLentesOftalmicasSuplementos)(inCtx, e.tbLentesOftalmicasSuplementos.ToList, AcoesFormulario.Remover, Nothing)
        End Sub

#End Region

#Region "FUNÇÕES AUXILIARES"
        Public Function getIDLenteOftalmica(ByVal IDArtigo As Long) As Long
            Return (From x In BDContexto.tbLentesOftalmicas Where x.IDArtigo = IDArtigo Select x.ID).FirstOrDefault()
        End Function
#End Region
    End Class
End Namespace