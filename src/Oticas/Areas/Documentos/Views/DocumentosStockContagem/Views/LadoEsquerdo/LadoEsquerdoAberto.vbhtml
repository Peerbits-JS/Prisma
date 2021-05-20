@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Modeltype Oticas.DocumentosStockContagem

@Code
    Dim strDisabled As String = "disabled"
    If (Not Model.EstaEfetivo) OrElse Model.AcaoFormulario = AcoesFormulario.Adicionar Then strDisabled = String.Empty

    Dim strTextoBotao As String = Traducao.EstruturaDocumentosStockContagem.Carregar
    If Not Model.EEditavel Then strTextoBotao = Traducao.EstruturaDocumentosStockContagem.ReiniciarContagem

    Dim strAttr As String = "carregar"
    If Not Model.EEditavel Then strAttr = "reiniciar"
End Code

<div id="condicoes">

    <p class="titulo">@Traducao.EstruturaDocumentosStockContagem.Condicoes</p>


    <div class="form-container">
        @Code
            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDTipoArtigo",
                .Label = Traducao.EstruturaDocumentosStockContagem.TipoArtigo,
                .TipoEditor = Mvc.Componentes.F3MMultiSelect,
                .Controlador = URLs.Areas.TabAux & F3M.Modelos.Constantes.Menus.TiposArtigos,
                .Accao = "ListaCombo",
                .Modelo = Model.Filtro,
                .ClearButton = True,
                .EEditavel = Model.EEditavel(),
                .FuncaoJSChange = "DocsStocksContagemCondicoesChangeTipoArtigo",
                .AtributosHtml = New With {.class = "clsF3MValidaEmGrupo"}})
        End Code
    </div>

    <div class="form-container">
        @Code
            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDMarca",
                .Label = Traducao.EstruturaDocumentosStockContagem.Marca,
                .TipoEditor = Mvc.Componentes.F3MMultiSelect,
                .OpcaoMenuDescAbrev = F3M.Modelos.Constantes.Menus.Marcas,
                .Controlador = URLs.Areas.TabAux & F3M.Modelos.Constantes.Menus.Marcas,
                .Accao = "ListaCombo",
                .Modelo = Model.Filtro,
                .ClearButton = True,
                .EEditavel = Model.EEditavel(),
                .FuncaoJSChange = "DocsStocksContagemCondicoesChangeMarca",
                .AtributosHtml = New With {.class = "clsF3MValidaEmGrupo"}})
        End Code
    </div>

    <div class="clsF3MOutrasCondicoes">
        @Code
            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "NaoMovimentados",
                .Label = Traducao.EstruturaDocumentosStockContagem.NaoMovimentados,
                .Modelo = Model.Filtro,
                .EEditavel = Model.EEditavel(),
                .FuncaoJSChange = "DocsStocksContagemCondicoesChangeOutrasCondicoes",
                .TipoEditor = Mvc.Componentes.F3MCheckBoxBootstrap})

            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Inativos",
                .Label = Traducao.EstruturaDocumentosStockContagem.Inativos,
                .Modelo = Model.Filtro,
                .EEditavel = Model.EEditavel(),
                .FuncaoJSChange = "DocsStocksContagemCondicoesChangeOutrasCondicoes",
                .TipoEditor = Mvc.Componentes.F3MCheckBoxBootstrap,
                .ViewClassesCSS = {"f3m-checkbox-sem-top"}})
        End Code
    </div>
    <div class="btn-fixo">
        <button id="btnAplicarFiltros" type="button" class="btn main-btn btn-sm btn-block" data-f3mtype="@strAttr" @strDisabled title="@strTextoBotao">
            @strTextoBotao
        </button>
    </div>
</div>