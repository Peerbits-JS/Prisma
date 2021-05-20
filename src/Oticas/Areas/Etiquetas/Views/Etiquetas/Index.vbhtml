@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Modeltype Oticas.Areas.Etiquetas.Models.Etiquetas

@Code
    Layout = ClsConstantes.RetornaSharedLayoutFunc(Me.Context)
End Code

<div id="janelaEtiquetas">
    <div class="f3m-top submenu clearfix dashed-base">
        <div class="float-left f3m-top__left">
            @Html.Partial("~/F3M/Views/Partials/F3MMenuFavoritoHomepageTitulo.vbhtml")
        </div>
        <div class="float-right f3m-top__right">
            <a id="EtiquetasBtPrintMapa" class="f3mlink grelha-bts clsBtPrintMapa dropdown-toggle" href="#" title="Imprimir Mapa" data-display="static" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                <span class="fm f3icon-angle-down"></span>
            </a>
            <div id="lstDropPrintMapa" class="clsF3MListedMapas f3m-dropdown-menu dropdown-menu" aria-labelledby="EtiquetasBtPrintMapa"></div>

            @Code
                Html.F3M().Botao("BtImprimir", Mvc.BotoesGrelha.Imprimir & Mvc.BotoesGrelha.BtsCRUD, Traducao.EstruturaAplicacaoTermosBase.TOOLTIPImprimir, "print")
            End Code
        </div>
    </div>
    <div class="area-vazia sem-border">
        @Html.Partial("Detalhe", Model)
    </div>
</div>
