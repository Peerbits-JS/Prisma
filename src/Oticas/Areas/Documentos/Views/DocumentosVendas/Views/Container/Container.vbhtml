@Imports F3M.Modelos.Constantes
@Modeltype Oticas.DocumentosVendas

<div role="tabpanel" class="f3m-tabs clsF3MTabs">
    <ul class="nav nav-pills f3m-tabs__ul clsAreaFixed" role="tablist">
        @*TABS*@
        @Html.Partial("Views/Container/Tabs", Model)
    </ul>
    <div class="tab-content">
        @* HISTORICO *@
        @Html.Action(URLs.HistComumIndex, Menus.Historicos, New With {.Area = Modelos.Constantes.Menus.Historicos, .inModelo = Model})

        @* ARTIGOS *@
        @Html.Partial(URLs.DocumentosComum & "Artigos.vbhtml", Model)

        @* COMPARTICIPACAO *@
        @Html.Partial("Views/Container/Comparticipacao", Model)

        @* CARGA DESCARGA *@
        @Html.Partial(URLs.DocumentosComum & "CargaDescarga.vbhtml", Model)

        @* OBSERVACOES *@
        @Html.Partial(URLs.DocumentosComum & "Observacoes.vbhtml", Model)
    </div>
</div>