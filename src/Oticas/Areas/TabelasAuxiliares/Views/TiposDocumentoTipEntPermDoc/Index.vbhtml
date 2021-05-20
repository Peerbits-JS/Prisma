@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Code
    Dim tf As New ClsMvcKendoTreeview
    Dim funcJS As String = Mvc.Grelha.Javascript.EnviaParams
    Dim bool As Boolean = (ViewBag.VistaParcial IsNot Nothing AndAlso ViewBag.VistaParcial)

    If Not bool Then
        Layout = URLs.SharedLayoutTabelas
    End If

    Html.Partial("~/F3M/Areas/TabelasAuxiliaresComum/Views/TiposDocumentoTipEntPermDoc/Index.vbhtml", tf)

    tf.TreeHTML = Html.F3M().TreeView(Of TiposDocumentoTipEntPermDoc)(tf).ToHtmlString()
End Code

@Html.Partial(tf.PartialViewInterna, tf)