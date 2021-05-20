@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Modeltype Oticas.AccountingConfiguration

@Scripts.Render("~/bundles/f3m/jsAccountingConfigurationEntities")

<div class="mt-3">
    <div id="procura" class="handson-pesquisa f3m-input-icon f3m-input-icon--left">
        <form action="#">
            <input type="text" id="search_field" class="form-control input-sm" placeholder="@(Traducao.EstruturaAplicacaoTermosBase.Pesquisa)">
            <span class="fm f3icon-search2 form-control-feedback" aria-hidden="true"></span>
        </form>
    </div>

    <div Class="@(ConstHT.ClassesHT.Container)">
        <div id="hdsnEntities"></div>
    </div>
</div>

@* elemento temporário para preenchimento da hansontable *@
<div id="tempHdsnDS">
    <script>
        $accountingconfigentities.ajax.SetHT(@Html.Raw(Json.Encode(Model.Entities)))
    </script>
</div>

<style>
    .handson-container {
        border: 0.1px solid #ccc;
    }
</style>
