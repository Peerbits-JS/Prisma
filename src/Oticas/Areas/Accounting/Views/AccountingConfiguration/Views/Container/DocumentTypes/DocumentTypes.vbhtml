@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Modeltype AccountingConfiguration

@Scripts.Render("~/bundles/f3m/jsAccountingConfigurationDocumentTypes")

<div id="containerCabecalho" class="row desContainer">
    @Html.Partial("Views/Container/DocumentTypes/Header", Model)
</div>

<div Class="@(ConstHT.ClassesHT.Container)">
    <div id="hdsnTiposDocumentos"></div>
</div>

@* elemento temporário para preenchimento da hansontable *@
<div id="tempHdsnDS">
    <script>
        $accountingconfigdocstypes.ajax.SetHT(@Html.Raw(Json.Encode(Model.DocumentTypes)))
    </script>
</div>