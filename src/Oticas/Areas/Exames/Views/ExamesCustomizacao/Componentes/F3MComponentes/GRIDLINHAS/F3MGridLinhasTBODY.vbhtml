@Code
    Dim UrlSonsEngine As String = "~/Areas/Exames/Views/ExamesCustomizacao/Componentes/F3MEngine/F3MSonsEngine.vbhtml"
End Code

<tbody data-f3mbdid="@Model.F3MBDID" class="@Model.ViewClassesCSS">
    @Html.Partial(UrlSonsEngine, Model)
</tbody>