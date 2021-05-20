@Imports F3M.Modelos.Constantes
@ModelType Oticas.AccountingConfiguration

@Scripts.Render("~/bundles/f3m/jsbaseformulariosopcoes")
@Scripts.Render("~/bundles/f3m/jsAccountingConfiguration")

@Html.Partial("Hiddens/Hiddens", Model)

@Html.Partial("Views/LeftSideBar/LeftSideBar", Model)

<div class="@(ClassesCSS.FormPrincLEsqAberto) f3m-aside-esq--open-larger" id="FormularioPrincipalOpcoes">
    <div class="FormularioAjudaScroll">
        <div class="container-fluid">
            @Html.Partial("Views/Container/Container", Model)
        </div>
    </div>
</div>

