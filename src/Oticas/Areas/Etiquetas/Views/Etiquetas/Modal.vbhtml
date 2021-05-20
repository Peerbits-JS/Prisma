@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Constantes
@Modeltype Oticas.Areas.Etiquetas.Models.Etiquetas

@Code
    Layout = ClsConstantes.RetornaSharedLayoutFunc(Me.Context)
    Dim botaoHtml As String = Mvc.BotoesGrelha.BotaoHTML.Replace("invisivel", "")
    Html.F3M().Hidden("Modal", True)
End Code

<div id="janelaEtiquetas" class="container-fluid container-fluid-window">
    <div class="f3m-top  submenu clearfix">
        <div class="float-left f3m-top__left">
            <div id="tituloLinhaGrelhas" class="titulo-form">@Traducao.EstruturaMenus.Etiquetas</div>
        </div>
        <div class="float-right f3m-top__right f3mgrelhabts">
            <a id="EtiquetasBtPrintMapa" class="grelha-bts clsBtPrintMapa" title="Imprimir Mapa">
                <span class="fm f3icon-angle-down dropdown-toggle" id="dropdownMapas" data-toggle="dropdown" aria-expanded="true"></span>
            </a>
            @Html.Raw(String.Format(botaoHtml, "BtImprimir", Mvc.BotoesGrelha.Imprimir, Traducao.Cliente.Imprimir, "print"))
        </div>
    </div>
    @Html.Partial("Detalhe", Model)
</div>