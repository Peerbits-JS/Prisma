@Modeltype Oticas.Exames

@Code
    Dim UrlComponentesEngine As String = "~/Areas/Exames/Views/ExamesCustomizacao/Componentes/F3MEngine/F3MDesenhaComponentes.vbhtml"
End Code

@Html.Partial(UrlComponentesEngine, Model.ExamesCustomizacaoComponents.Where(Function(w) Not w.ECabecalho Is Nothing AndAlso w.ECabecalho = True).ToList())