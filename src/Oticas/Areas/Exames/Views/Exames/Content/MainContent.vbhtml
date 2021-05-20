@Modeltype Oticas.Exames

@Code
    'SET FOTOS TO VIEW BAG
    ViewBag.ExamesFotos = Model.ExamesFotos
End Code

@Scripts.Render("~/bundles/f3m/jsExamesComponentes")

@Code
    Dim UrlComponentesEngine As String = "~/Areas/Exames/Views/ExamesCustomizacao/Componentes/F3MEngine/F3MDesenhaComponentes.vbhtml"
End Code

@Html.Partial(UrlComponentesEngine, Model.ExamesCustomizacaoComponents.Where(Function(w) w.ECabecalho Is Nothing OrElse Not w.ECabecalho).ToList())