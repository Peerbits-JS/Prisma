@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Modeltype Oticas.InventarioAT

@Code
    Dim strDisabled As String = If(Not Model.IsEnabled(), "disabled", String.Empty)
    Dim strTextoBotao As String = Traducao.EstruturaDocumentosStockContagem.Atualizar
End Code

<div id="condicoes">
    <p class="titulo">@Traducao.EstruturaDocumentosStockContagem.Condicoes</p>

    <div class="form-container">
        @Code
            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "FilterDate",
                .Label = Traducao.EstruturaUtilitarios.Data,
                .TipoEditor = Mvc.Componentes.F3MData,
                .Modelo = Model.Filter,
                .ValorDescricao = Date.Now(),
                .EEditavel = Model.IsEnabled(),
                .FuncaoJSChange = "InventarioATChangeFilterDate",
                .AtributosHtml = New With {.class = "clsF3MValidaEmGrupo"}})
        End Code
    </div>

    <div class="form-container">
        @Code
            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Warehouses",
                .Label = Traducao.EstruturaUtilitarios.Armazens,
                .TipoEditor = Mvc.Componentes.F3MMultiSelect,
                .OpcaoMenuDescAbrev = F3M.Modelos.Constantes.Menus.Armazens,
                .Controlador = URLs.Areas.TabAux & F3M.Modelos.Constantes.Menus.Armazens,
                .Accao = "ListaCombo",
                .Modelo = If(Model.AcaoFormulario = AcoesFormulario.Adicionar, Model.Filter, Model),
                .CampoTexto = "Codigo",
                .ClearButton = True,
                .EEditavel = Model.IsEnabled(),
                .FuncaoJSChange = "InventarioATChangeWareHouse",
                .AtributosHtml = New With {.class = "clsF3MValidaEmGrupo"}})
        End Code
    </div>

    <div class="btn-fixo">
        <button id="btnAplicarFiltros" class="btn main-btn btn-sm btn-block" data-f3mtype="carregar" @strDisabled title="@strTextoBotao">
            @strTextoBotao
        </button>
    </div>
</div>