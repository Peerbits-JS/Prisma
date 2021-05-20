@Modeltype Components

@Code
    Dim UrlSonsEngine As String = "~/Areas/Exames/Views/ExamesCustomizacao/Componentes/F3MEngine/F3MSonsEngine.vbhtml"
End Code

<div class="f3m-card">
    <div class="card-title f3m-card__title titulo-sec-tab">@Model.Label</div>
    <div data-f3mbdid="@Model.F3MBDID" class="card-body f3m-card__body @Model.ViewClassesCSS">
        <div class="arrayChecks">
            @Html.Partial(UrlSonsEngine, Model)
        </div>
    </div>
</div>
