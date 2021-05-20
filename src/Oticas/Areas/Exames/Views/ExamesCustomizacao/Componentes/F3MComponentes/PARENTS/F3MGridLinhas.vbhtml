@Modeltype Components

@Code
    Dim UrlComponentesEngine As String = "~/Areas/Exames/Views/ExamesCustomizacao/Componentes/F3MEngine/F3MDesenhaComponentes.vbhtml"
    Dim UrlSonsEngine As String = "~/Areas/Exames/Views/ExamesCustomizacao/Componentes/F3MEngine/F3MSonsEngine.vbhtml"
End Code

<!-- DESENHA GRELHA DE LINHAS -->
<table data-f3mbdid="@Model.F3MBDID" class="table table-sm">
    @Html.Partial(UrlSonsEngine, Model)
</table>