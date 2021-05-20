@Modeltype Oticas.Components

@Code
    Dim UrlSonsEngine As String = "~/Areas/Exames/Views/ExamesCustomizacao/Componentes/F3MEngine/F3MSonsEngine.vbhtml"

    @<a data-f3mbdid="@Model.ID" id="@Model.IDElemento" class="@Model.ViewClassesCSS" onclick="@Model.FuncaoJSOnClick">
        @Model.Label
        @Html.Partial(UrlSonsEngine, Model)
    </a>
End Code