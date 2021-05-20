Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Sistema
Imports F3M.Modelos.Autenticacao

Namespace Areas.Sistema.Controllers
    Public Class SistemaCamposFormulasController
        Inherits GrelhaSistemaController(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaCamposFormulas, SistemaCamposFormulas)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioSistemaCamposFormulas)
        End Sub
#End Region

        <F3MAcesso>
        Function Detalhe(Optional ByVal IDVista As Long = 0) As ActionResult
            Using rp As New RepositorioSistemaCamposFormulas

                Dim objTb As List(Of SistemaCamposFormulas) = rp.ObtemPorObjIDEntidade(IDVista).Select(Function(e) New SistemaCamposFormulas With {.Codigo = e.Codigo,
                                                                                                                                                   .Descricao = e.Descricao,
                                                                                                                                                   .IDEntidadesFormulas = e.IDEntidadesFormulas}).ToList
                ViewBag.ListaBotoes = objTb
            End Using
            Return View()
        End Function

    End Class
End Namespace