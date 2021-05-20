@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Modeltype Oticas.Components

@Code
    Dim UrlSonsEngine As String = "~/Areas/Exames/Views/ExamesCustomizacao/Componentes/F3MEngine/F3MSonsEngine.vbhtml"

    Dim atrHTML As New Dictionary(Of String, Object) From {{"class", CssClasses.InputF3M}}
    Html.F3M().Hidden(Model.IDElemento, Model.ValorID, atrHTML)

    Dim t As String = Model.Label
    If String.IsNullOrEmpty(t) Then t = Model.ValorID

    @<span data-f3mbdid="@Model.ID" id="F3MSpan_@Model.IDElemento" class="@Model.ViewClassesCSS">
        @t
        @Html.Partial(UrlSonsEngine, Model)
    </span>
End Code