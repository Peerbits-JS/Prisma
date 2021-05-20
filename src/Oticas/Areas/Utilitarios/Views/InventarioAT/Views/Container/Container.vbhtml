@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Utilitarios

<div role="tabpanel" class="f3m-tabs clsF3MTabs">
    <ul class="nav nav-pills f3m-tabs__ul f3m-tabs__ul--margin-top clsAreaFixed" role="tablist">
        @* TABS *@
        @Html.Partial("Views/Container/Tabs")
    </ul>
    <div class="tab-content">
        @* HISTORICO *@
        @Html.Action(URLs.HistComumIndex, F3M.Modelos.Constantes.Menus.Historicos,
                                                      New With {.Area = F3M.Modelos.Constantes.Menus.Historicos, .inModelo = Model})

        @* ARTIGOS *@
        @Html.Partial("Views/Container/Artigos", Model)

        @* OBSERVACOES *@
        @Html.Partial("Views/Container/Observacoes", Model)
    </div>
</div>