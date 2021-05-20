@Code
    Dim UrlSonsEngine As String = "~/Areas/Exames/Views/ExamesCustomizacao/Componentes/F3MEngine/F3MSonsEngine.vbhtml"
    Dim calcColSpan As Integer = Model.EndCol - Model.StartCol + 1
    Dim calcRowSpan As Integer = Model.EndRow - Model.StartRow + 1
End Code

<th data-f3mbdid="@Model.F3MBDID" rowspan="@calcRowSpan" colspan="@calcColSpan" class="@Model.ViewClassesCSS">@Model.Label</th>