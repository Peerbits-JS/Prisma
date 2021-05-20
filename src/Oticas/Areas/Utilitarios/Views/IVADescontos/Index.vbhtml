@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Modeltype List(Of IVA)

@*R E N D E R S*@
@Styles.Render("~/Content/handsontablestyle")
@Scripts.Render("~/bundles/handsontable")
@Scripts.Render("~/bundles/f3m/jsIVADescontos")

@*F O R M U L A R I O*@
<div id="F3MFormIVADescontos" class="win-notifica">
    @*T I T U L O *@
    <div class="f3m-top submenu clearfix">
        <div class="float-left f3m-top__left">
            <div id="tituloModulo" class="f3m-top__title">Configuração de descontos</div>
        </div>
        @*B O T O E S     D E     A C O E S*@
        <div class="float-right f3m-top__right">
            @*A T U A L I Z A R*@
            <a id="btnRefresh" class="f3mlink grelha-bts clsBtRefresh @(Mvc.BotoesGrelha.BtsCRUD)" title="@(Traducao.EstruturaAplicacaoTermosBase.TOOLTIPAtualizar)">
                <span class="fm f3icon-refresh"></span>
            </a>
            @*G R A V A R*@
            <a id="btnSave" class="f3mlink grelha-bts @(Mvc.BotoesGrelha.BtsCRUD) disabled" title="">
                <span class="fm f3icon-floppy-o"></span>
            </a>
        </div>
    </div>

    @*H A N D S O N T A B L E*@
    <div class="@(ConstHT.ClassesHT.Container)">
        <div id="hdsnIVA"></div>
    </div>
</div>

@*D E F A U L T     H A N D S O N T A B L E     D S*@
<div id="tempHdsnDS">
    <script>
            DescontosIVAConstroiHT(@Html.Raw(Json.Encode(Model)))
    </script>
</div>