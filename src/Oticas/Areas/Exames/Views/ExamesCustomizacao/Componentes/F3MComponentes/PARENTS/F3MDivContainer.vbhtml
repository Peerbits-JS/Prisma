@Modeltype Components

@Code
    Dim UrlSonsEngine As String = "~/Areas/Exames/Views/ExamesCustomizacao/Componentes/F3MEngine/F3MSonsEngine.vbhtml"
End Code

<!-- DESENHA DIV CONTAINER DO TIPO -> @Model.ViewClassesCSS -->
<div data-f3mbdid="@Model.F3MBDID" id="@Model.IDElemento" class="@Model.ViewClassesCSS" onclick="@Model.FuncaoJSOnClick">
    @Html.Partial(UrlSonsEngine, Model)
</div>