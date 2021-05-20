@Code
    Dim UrlSonsEngine As String = "~/Areas/Exames/Views/ExamesCustomizacao/Componentes/F3MEngine/F3MSonsEngine.vbhtml"

    Dim calcColSpan As Integer = Model.EndCol - Model.StartCol + 1
    Dim calcRowSpan As Integer = Model.EndRow - Model.StartRow + 1
End Code

<!-- DESENHA TR -->
<tr data-f3mbdid="@Model.F3MBDID" id="@Model.ID"  class="@Model.ViewClassesCSS">
    @Html.Partial(UrlSonsEngine, Model)
</tr>