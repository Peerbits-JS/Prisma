@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Modeltype Oticas.AccountingConfiguration

<div id="condicoes">
    <p class="titulo">@Traducao.EstruturaDocumentosStockContagem.Condicoes</p>
    <div class="form-container">
        @Code
            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Year",
                .Label = Traducao.EstruturaContabilidadeConfiguracao.Ano,
                .Modelo = Model,
                .CampoValor = "Description",
                .CampoTexto = "Description",
                .TipoEditor = Mvc.Componentes.F3MDropDownList,
                .Controlador = "../Accounting/AccountingConfiguration",
                .Accao = "GetYears",
                .EObrigatorio = True,
                .EEditavel = Model.ID = 0 OrElse Model.IsCopyMode,
                .DesenhaBotaoLimpar = False,
                .FuncaoJSChange = "AccountingConfigConditionsYearChange"})
        End Code
    </div>

    <div class="form-container">
        @Code
            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "ModuleDescription",
                .Label = Traducao.EstruturaContabilidadeConfiguracao.Tabela,
                .Modelo = Model,
                .CampoValor = "Description",
                .CampoTexto = "Description",
                .TipoEditor = Mvc.Componentes.F3MDropDownList,
                .Controlador = "../Accounting/AccountingConfiguration",
                .Accao = "GetModules",
                .EObrigatorio = True,
                .EEditavel = Model.ID = 0 OrElse Model.IsCopyMode,
                .DesenhaBotaoLimpar = False,
                .FuncaoJSChange = "AccountingConfigConditionsModuleChange",
                .FuncaoJSSelect = "AccountingConfigConditionsModuleSelect",
                .FuncaoJSDataBound = "AccountingConfigConditionsModuleDataBound"})
        End Code
    </div>
    @*LIST VIEW*@
    <div class="form-container f3m-caixa-multiselect">
        <div class="caixa-listview" id="TypeDescription"></div>
    </div>
</div>

<script type="text/x-kendo-template" id="template">
    <div class="items">
        <label id=#:kendo.toString(ID,"")# style="display:none"></label>
        <label>  #:kendo.toString(Description,"")#</label>
    </div>
</script>