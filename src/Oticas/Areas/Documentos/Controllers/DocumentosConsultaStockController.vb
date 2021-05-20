Imports F3M.Areas.Documentos.Controllers
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Repositorio

Namespace Areas.Documentos.Controllers
    Public Class DocumentosConsultaStockController
        Inherits DocumentosConsultaStockController(Of BD.Dinamica.Aplicacao, tbStockArtigos, F3M.DocumentosConsultaStock)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioGenerico(Of BD.Dinamica.Aplicacao, tbStockArtigos, F3M.DocumentosConsultaStock))
        End Sub
#End Region

#Region "ACOES DEFAULT GET CRUD"
        <F3MAcesso>
        Public Function IndexConsultaStock(inIDArtigo As Long?) As ActionResult
            Return MyBase.IndexConsStock(Of tbArtigos)(inIDArtigo)
        End Function
#End Region

#Region "FUNCOES AUXILIARES"
        <F3MAcesso>
        Public Function RetornaListaDims1ouDims2(tipoDim As String, IDArtigo As Long) As JsonResult
            Return MyBase.RetornaListaDims(repositorio.BDContexto, tipoDim, IDArtigo)
        End Function

        <F3MAcesso>
        Public Function RetornaInformacaoArtigoAConsultarStock(modelo As List(Of F3M.DocumentosConsultaStock),
                                                               selecionadosDim1 As List(Of Long), selecionadosDim2 As List(Of Long)) As JsonResult
            Return MyBase.RetornaInfoArtAConsultarStock(Of tbArtigos, tbArtigosDimensoes, tbArtigosDimensoesEmpresa)(
                repositorio.BDContexto, modelo, selecionadosDim1, selecionadosDim2)
        End Function

        <F3MAcesso>
        Public Function PreencherStockArmazem(modelo As List(Of F3M.DocumentosConsultaStock), SemDetalheDims As Boolean) As JsonResult
            Return MyBase.PreencheStockArm(repositorio.BDContexto, modelo, SemDetalheDims)
        End Function

        Public Function PreencheInfCB(CodBarras As String) As JsonResult
            Return MyBase.PreencheInfCBGeral(Of tbArtigos, tbArtigosDimensoes, tbArtigosDimensoesEmpresa)(
                                repositorio.BDContexto, CodBarras)
        End Function
#End Region

    End Class
End Namespace