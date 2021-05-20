@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Constantes
@Code
    Layout = URLs.SharedLayoutTabelas
    Dim cssClassArtDimTiposOps As String = "cssArtDimTiposOperacao"
    Dim cssClassArtDimDimensoes As String = "cssArtDimDimensoes"
    Dim botaoHtml As String = Mvc.BotoesGrelha.BotaoHTML.Replace("invisivel", "")

    @Styles.Render("~/Content/handsontablestyle")
    @Scripts.Render("~/bundles/handsontable")
    @Scripts.Render("~/bundles/f3m/jsFormularioArtigosDimensoes")
End Code

 <div class="f3m-window">
    <div class="clsCabecalhoFixo">
        <div class="f3m-top submenu clearfix">
            <div class="float-left f3m-top__left">
                <div id="tituloLinhaGrelhas" class="titulo-form">@(Traducao.EstruturaAplicacaoTermosBase.TOOLTIPInfPorDimensões)</div>
            </div>
            <div class="float-right f3m-top__right f3mgrelhabts">
                <div class="bts-modo-edita float-left">
                    @Html.Raw(String.Format(botaoHtml, "btnGuardaGrelha", "clsBtSave disabled", Traducao.EstruturaAplicacaoTermosBase.TOOLTIPGravarDimensoes, "floppy-o"))
                </div>
                @Html.Raw(String.Format(botaoHtml, "btnCopiaHorizontal", "btnCopia disabled ", Traducao.EstruturaAplicacaoTermosBase.TOOLTIPCopiaHorizontal, "copycells-h"))
                @Html.Raw(String.Format(botaoHtml, "btnCopiaVertical", "btnCopia disabled ", Traducao.EstruturaAplicacaoTermosBase.TOOLTIPCopiaVertical, "copycells-v"))
                @Html.Raw(String.Format(botaoHtml, "btnDimensao", "mais ", Traducao.EstruturaAplicacaoTermosBase.TOOLTIPLinhasDimensões, "dimensoes"))
            </div>
        </div>
    </div>
    <div class="row mb-3">
        <div class="col-4">
            @Code
                Html.F3M().DropDownList(New ClsF3MCampo With {
                    .Id = CamposEspecificos.TipoOperacoesDimensoes,
                    .Controlador = "../Artigos/" & MenusComuns.ArtigosDimensoes,
                    .Accao = "ListaAcessos",
                    .OpcaoMenuDescAbrev = MenusComuns.ArtigosDimensoes,
                    .FuncaoJSChange = "ArtigosDimensoesTiposOperacoesChange",
                    .FuncaoJSDataBound = "ArtigosDimensoesTiposOperacoesDataBound",
                    .AtributosHtml = New With {.style = "width:250px;"}}).Render()
            End Code
        </div>
    </div>
     <div class="handson-container">
         <div id="grelhaArtigosDimensoes"></div>
     </div>
</div>
<div class="handson-f3m"></div>