@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo

@Scripts.Render("~/bundles/f3m/jsCatalogoLentesSubstituicaoArtigos")
@Styles.Render("~/Content/handsontablestyle")
@Scripts.Render("~/bundles/handsontable")

@Code
    Layout = URLs.SharedLayoutTabelas

    Dim botaoHtml As String = Mvc.BotoesGrelha.BotaoHTMLVisivel
    Dim clsCSSAcoes As String = Mvc.BotoesGrelha.BtsAcoes
    Html.F3M().Hidden("CatalogoLentes", True)
    Html.F3M().Hidden("F3MListView", True)

    Html.F3M().Hidden("IDTipoLenteOftalmica", ViewBag.IDTipoLenteOftalmica)
    Html.F3M().Hidden("IDTipoLenteContato", ViewBag.IDTipoLenteContato)

    Html.F3M().Hidden("hdfIDTipoArtigo", ViewBag.IDTipoLenteOftalmica)
    Html.F3M().Hidden("hdfCodigoTipoArtigo", "LO")
    Html.F3M().Hidden("hdfIDMarca", String.Empty)
    Html.F3M().Hidden("hdfIDTipoLente", String.Empty)
    Html.F3M().Hidden("hdfIDMateriaLente", String.Empty)
    Html.F3M().Hidden("hdfIDModelo", String.Empty)
    Html.F3M().Hidden("hdfDescricaoModelo", String.Empty)

    Html.F3M().Hidden("F3MListViewURL", ChavesWebConfig.Projeto.Proj & "/TabelasAuxiliares/CatalogosLentes/LerMarcas")
    Html.F3M().Hidden("F3MListViewFunctionChange", "CatalogoLentesMarcasChange")
End Code
<div id="catalogoLentes">
    <div class="f3m-top submenu clearfix">
        <div class="float-left f3m-top__left">
            <form class="form-inline">
                <div class="form-group area-diametro">
                    <div class="float-left f3m-top__title"><span id="tituloModulo">Catálogos de Lentes</span></div>
                    <label for="txtDiametro" id="spDiametroSymbol" class="symbol-diam" textolabelrequired="@Traducao.EstruturaDocumentos.DiametroObrigatorio">&oslash;</label>
                    <div id="spDiametro" class="area-diametro clsF3MCampo">
                        <input name="txtDiametro" id="txtDiametro" type="number" min="0" max="100" step="0.5" required="required" class="clsF3MInput k-select form-control input-sm required  k-input  alinhamentocentro obrigatorio" data-role="numerictextbox" />
                    </div>
                </div>
            </form>
        </div>
        <div class="float-right f3m-top__right">
            <a id="btnReset" class="f3mlink grelha-bts clsBtRefresh @(Mvc.BotoesGrelha.BtsCRUD)" title="@(Traducao.EstruturaAplicacaoTermosBase.TOOLTIPAtualizar)"><span class="fm f3icon-refresh"></span></a>
            <a id="btConfirm" class="f3mlink grelha-bts @(Mvc.BotoesGrelha.BtsCRUD)" style="display:none" title=""><span class="fm f3icon-check-square"></span></a>
        </div>
    </div>
    <div class="sem-formulario">
        <div class="FormularioAjudaScroll">
            <div class="container-fluid f3m-caixa-multiselect clsF3MCatalogoLentes">
                <div class="mb-2 mt-3">
                    <div id="btnsLentes" class="btn-group btn-group-toggle" data-toggle="buttons">
                        <label class="btn btn-line btn-sm active">
                            <input type="radio" name="options" id="option1" autocomplete="off" onchange="return CatalogoLentesChangeTiposLentes(true);" checked>@Traducao.EstruturaArtigos.LentesOftalmicas
                        </label>
                        <label class="btn btn-line btn-sm">
                            <input type="radio" name="options" id="option2" autocomplete="off" onchange="return CatalogoLentesChangeTiposLentes(false);">@Traducao.EstruturaArtigos.LentesContato
                        </label>
                    </div>
                </div>
                <div class="row form-container formul-group">
                    <div class="col optionLentes">
                        <label class="pLinha">
                            <a id="lblMarcas" onclick="CatalogoLentesLabelClick(this);">@Traducao.EstruturaArtigos.MARCA</a>
                        </label>
                        <div class="input-group input-group-sm">
                            <input id="marcas" class="search form-control" type="text" placeholder="" />
                            <div class="input-group-append">
                                <button type="button" class="btn btn-outline-secondary f3m-btn-outline-secondary input-btn-sm dropdown-toggle" data-toggle="dropdown" aria-expanded="false"><span class=" fm f3icon-filter"></span></button>
                                <div class="dropdown-menu dropdown-menu-right drop-filtro" role="menu">
                                    <a id="opContains" class="dropdown-item active menuMarcas">@Traducao.EstruturaAplicacaoTermosBase.Contem</a>
                                    <a id="opEq" class="dropdown-item menuMarcas">@Traducao.EstruturaAplicacaoTermosBase.IgualA</a>
                                </div>
                            </div>
                        </div>
                        <div class="caixa-listview" id="F3MListViewMarcas"></div>
                    </div>
                    <div class="col optionLentes">
                        <label>@Traducao.EstruturaAplicacaoTermosBase.Tipo</label>
                        <div class="caixa-listview-tres" id="F3MListViewTiposLentes"></div>
                        <div class="optionLentesOftalmicas">
                            <label class="mt-2">@Traducao.EstruturaAplicacaoTermosBase.Materia</label>
                            <div class="caixa-listview-tres" id="F3MListViewMateriasLentes"></div>
                        </div>
                        <label class="mt-2">Índice</label>
                        <div class="caixa-listview-tres" id="F3MListViewIndices"></div>
                        <div class="custom-control custom-checkbox f3m-checkbox">
                            <input type="checkbox" class="f3m-checkbox__input custom-control-input clsF3MInput" name="fotocromatica" id="fotocromatica" autocomplete="none">
                            <label for="fotocromatica" class="f3m-checkbox__label custom-control-label">Fotocromática</label>
                        </div>
                    </div>
                    <div class="col optionLentes ">
                        <label class="pLinha">
                            <a id="lblModelos" onclick="CatalogoLentesLabelClick(this);">@Traducao.EstruturaArtigos.Modelo</a>
                        </label>
                        <div class="input-group input-group-sm">
                            <input id="modelos" class="search form-control" type="text" placeholder="" />
                            <div class="input-group-append">
                                <button id="btModelos" type="button" class="btn btn-outline-secondary f3m-btn-outline-secondary input-btn-sm dropdown-toggle" data-toggle="dropdown" aria-expanded="false"><span class=" fm f3icon-filter"></span></button>
                                <div class="dropdown-menu dropdown-menu-right drop-filtro" role="menu">
                                    <a id="opContains" class="dropdown-item active menuModelos">@Traducao.EstruturaAplicacaoTermosBase.Contem</a>
                                    <a id="opEq" class="dropdown-item menuModelos">@Traducao.EstruturaAplicacaoTermosBase.IgualA</a>
                                </div>
                            </div>
                        </div>
                        <div class="caixa-listview" id="F3MListViewModelosArtigos"></div>
                    </div>

                    <div class="col optionLentesOftalmicas">
                        <label class="pLinha">
                            <a id="lblTratamentos" onclick="CatalogoLentesLabelClick(this);">@Traducao.EstruturaArtigos.Tratamentos</a>
                        </label>
                        <div class="input-group input-group-sm">
                            <input id="tratamentos" class="search form-control btsLO" type="text" placeholder="" />
                            <div class="input-group-append">
                                <button type="button" class="btn btn-outline-secondary f3m-btn-outline-secondary input-btn-sm dropdown-toggle btsLO" data-toggle="dropdown" aria-expanded="false"><span class=" fm f3icon-filter"></span></button>
                                <div class="dropdown-menu dropdown-menu-right drop-filtro" role="menu">
                                    <a id="opContains" class="dropdown-item active menuTratamentos">@Traducao.EstruturaAplicacaoTermosBase.Contem</a>
                                    <a id="opEq" class="dropdown-item menuTratamentos">@Traducao.EstruturaAplicacaoTermosBase.IgualA</a>
                                </div>
                            </div>
                        </div>
                        <div class="caixa-listview" id="F3MListViewTratamentosLentes"></div>
                    </div>
                    <div class="col optionLentesOftalmicas">
                        <label class="pLinha">
                            <a id="lblCores" onclick="CatalogoLentesLabelClick(this);">@Traducao.EstruturaAplicacaoTermosBase.CoresLentes</a>
                        </label>
                        <div class="input-group input-group-sm">
                            <input id="cores" class="search form-control btsLO" type="text" placeholder="" />
                            <div class="input-group-append">
                                <button type="button" class="btn btn-outline-secondary f3m-btn-outline-secondary input-btn-sm dropdown-toggle btsLO" data-toggle="dropdown" aria-expanded="false"><span class=" fm f3icon-filter"></span></button>
                                <div class="dropdown-menu dropdown-menu-right drop-filtro" role="menu">
                                    <a id="opContains" class="dropdown-item active menuCores">@Traducao.EstruturaAplicacaoTermosBase.Contem</a>
                                    <a id="opEq" class="dropdown-item menuCores">@Traducao.EstruturaAplicacaoTermosBase.IgualA</a>
                                </div>
                            </div>
                        </div>
                        <div class="caixa-listview" id="F3MListViewCoresLentes"></div>
                    </div>
                    <div class="col optionLentesOftalmicas">
                        <label class="pLinha">
                            <a id="lblSuplementos" onclick="CatalogoLentesLabelClick(this);">@Traducao.EstruturaArtigos.Suplementos</a>
                        </label>
                        <div class="input-group input-group-sm">
                            <input id="suplementos" class="search form-control btsLO" type="text" placeholder="" />
                            <div class="input-group-append">
                                <button type="button" class="btn btn-outline-secondary f3m-btn-outline-secondary input-btn-sm dropdown-toggle btsLO" data-toggle="dropdown" aria-expanded="false"><span class=" fm f3icon-filter"></span></button>
                                <div class="dropdown-menu dropdown-menu-right drop-filtro" role="menu">
                                    <a id="opContains" class="dropdown-item active menuSuplementos">@Traducao.EstruturaAplicacaoTermosBase.Contem</a>
                                    <a id="opEq" class="dropdown-item menuSuplementos">@Traducao.EstruturaAplicacaoTermosBase.IgualA</a>
                                </div>
                            </div>
                        </div>
                        <div class="caixa-listview" id="F3MListViewSuplementosLentes"></div>
                    </div>
                </div>
                <div id="htRow" class="row mt-2" style="display:none">
                    <div class="@ClassesCSS.XS10">
                        <div class="handson-container handson-color">
                            <div id="opcoesHT"></div>
                        </div>
                    </div>
                    <div class="@ClassesCSS.XS2">
                        <button id="novaOpcao" type="button" disabled="disabled" class="btn main-btn btn-block">NOVA OPÇÃO</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-kendo-template" id="template">
    <div class="items">
        <label id=#:kendo.toString(ID,"")# style="display:none"></label>
        <label>  #:kendo.toString(Descricao,"")#</label>
    </div>
</script>

<script type="text/x-kendo-template" id="template-indice">
    <div class="items">
        <label>  #:kendo.toString(IndiceRefracao,"")#</label>
    </div>
</script>