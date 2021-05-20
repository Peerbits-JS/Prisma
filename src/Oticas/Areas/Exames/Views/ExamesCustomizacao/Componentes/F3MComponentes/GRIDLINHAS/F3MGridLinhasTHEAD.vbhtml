@Code
    Dim UrlSonsEngine As String = "~/Areas/Exames/Views/ExamesCustomizacao/Componentes/F3MEngine/F3MSonsEngine.vbhtml"
End Code

<thead data-f3mbdid="@Model.F3MBDID" class="@Model.ViewClassesCSS">
    @Html.Partial(UrlSonsEngine, Model)
</thead>