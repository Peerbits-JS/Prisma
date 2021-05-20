@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Modeltype Oticas.DocumentosStockContagemContar

@Styles.Render("~/Content/handsontablestyle")
@Scripts.Render("~/bundles/handsontable")
@Scripts.Render("~/bundles/f3m/jsDocsStockContagemContar")

@*<script src='https://cdn.rawgit.com/admsev/jquery-play-sound/master/jquery.playSound.js'></script>*@
@Code
    Layout = URLs.SharedLayoutFuncionalidades

    Dim botaoHtml As String = Mvc.BotoesGrelha.BotaoHTMLVisivel
    Dim F3MBarLoading As String = URLs.F3MFrontEndComponentes & "BarLoading.vbhtml"

    ' H ID D E N     F I EL D S
    Html.F3M().Hidden("IDArtigo", Nothing)
End Code

<div class="f3m-top submenu clearfix">
    <div class="float-left f3m-top__left">
        <div class="f3m-top__title"></div>
    </div>
    <div class="float-right f3m-top__right f3mgrelhabts">
        <a id="btnSelecionarArtigos" class="f3mlink grelha-bts" title="">
            <span class="fm f3icon-fm f3icon-check-square"></span>
        </a>
    </div>
</div>
<div class="container-fluid container-fluid-window">
    <div class="row desContainer">
        @code
            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Quantidade",
                            .Label = Traducao.EstruturaArtigos.QUANTIDADE,
                            .TipoEditor = Mvc.Componentes.F3MNumero,
                            .Modelo = Model,
                            .ValorMinimo = 1,
                            .AtributosHtml = New With {.class = "textbox-titulo"},
                            .ViewClassesCSS = {ClassesCSS.XS3}})

            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "CodigoArtigo",
                        .Label = Traducao.EstruturaArtigos.CODIGO,
                        .Modelo = Model,
                        .EObrigatorio = True,
                        .AtributosHtml = New With {.class = "textbox-titulo"},
                        .ViewClassesCSS = {ClassesCSS.XS3}})

            'Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDArtigo",
            '    .Label = "Artigo",
            '    .Controlador = "./../Artigos/Artigos/ListaComboCodigo",
            '    .ControladorAccaoExtra = "./../../Artigos/Artigos/" & URLs.ViewIndexGrelha,
            '    .TipoEditor = Mvc.Componentes.F3MLookup,
            '    .Modelo = Model,
            '    .CampoTexto = "Codigo",
            '    .FuncaoJSChange = "DocsStocksContagemContarChangeArtigo",
            '    .FuncaoJSEnviaParams = "DocsStocksContagemContarEnviaParamsArtigo",
            '    .AtributosHtml = New With {.class = "textbox-titulo"},
            '    .EstadoBotoes = New ClsF3MEstadoBotoes With {.PermBtnAdd = 2},
            '    .ViewClassesCSS = {ClassesCSS.XS5}})

            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDLote",
                        .Label = Traducao.EstruturaArtigos.Lote,
                        .Controlador = "./../Artigos/ArtigosLotes/",
                        .ControladorAccaoExtra = "./../../Artigos/ArtigosLotes/" & URLs.ViewIndexGrelha,
                        .TipoEditor = Mvc.Componentes.F3MLookup,
                        .Modelo = Model,
                        .EEditavel = False,
                        .FuncaoJSChange = "DocsStocksContagemContarLoteChange",
                        .FuncaoJSEnviaParams = "DocsStocksContagemContarLoteEnviaParams",
                        .AtributosHtml = New With {.class = "textbox-titulo"},
                        .EstadoBotoes = New ClsF3MEstadoBotoes With {.PermBtnAdd = 2},
                        .ViewClassesCSS = {ClassesCSS.XS3}})

        End Code
        <a id="btnConfirmarArtigo" Class="btn main-btn btn-cabecalho-simples" title="OK">
            <span>OK</span>
        </a>
    </div>
    @*<div class="form-row">
        <div class="form-group col-2 pr-3">
            <label>@Traducao.EstruturaArtigos.QUANTIDADE</label>
            @code
                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Quantidade",
                                .TipoEditor = Mvc.Componentes.F3MNumero,
                                .Modelo = Model,
                                .ValorMinimo = 1,
                                .AtributosHtml = New With {.class = "textbox-titulo"}})
            End Code

        </div>
        <div class="form-group col-5 pr-3">
            <label>@Traducao.EstruturaArtigos.CODIGO</label>
            @code
                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "CodigoArtigo",
                        .Modelo = Model,
                        .EObrigatorio = True,
                        .AtributosHtml = New With {.class = "textbox-titulo"}})

                'Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDArtigo",
                '    .Label = "Artigo",
                '    .Controlador = "./../Artigos/Artigos/ListaComboCodigo",
                '    .ControladorAccaoExtra = "./../../Artigos/Artigos/" & URLs.ViewIndexGrelha,
                '    .TipoEditor = Mvc.Componentes.F3MLookup,
                '    .Modelo = Model,
                '    .CampoTexto = "Codigo",
                '    .FuncaoJSChange = "DocsStocksContagemContarChangeArtigo",
                '    .FuncaoJSEnviaParams = "DocsStocksContagemContarEnviaParamsArtigo",
                '    .AtributosHtml = New With {.class = "textbox-titulo"},
                '    .EstadoBotoes = New ClsF3MEstadoBotoes With {.PermBtnAdd = 2},
                '    .ViewClassesCSS = {ClassesCSS.XS5}})

            End Code
        </div>
        <div class="form-group col-3 pr-2">
            <label>@Traducao.EstruturaArtigos.Lote</label>
            @code
                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDLote",
                            .Controlador = "./../Artigos/ArtigosLotes/",
                            .ControladorAccaoExtra = "./../../Artigos/ArtigosLotes/" & URLs.ViewIndexGrelha,
                            .TipoEditor = Mvc.Componentes.F3MLookup,
                            .Modelo = Model,
                            .EEditavel = False,
                            .FuncaoJSChange = "DocsStocksContagemContarLoteChange",
                            .FuncaoJSEnviaParams = "DocsStocksContagemContarLoteEnviaParams",
                            .AtributosHtml = New With {.class = "textbox-titulo"},
                            .EstadoBotoes = New ClsF3MEstadoBotoes With {.PermBtnAdd = 2}})
            End Code
        </div>
        <a id="btnConfirmarArtigo" Class="btn main-btn btn-cabecalho-simples" title="OK">
            <span>OK</span>
        </a>

    </div>*@

    @Html.Partial(F3MBarLoading)
    <div Class="@(ConstHT.ClassesHT.Container) handson-color">
        <div id="hdsnArtigosContar"></div>
    </div>
</div>

<div id="tempHdsnDS">
    <script>
        DocsStocksContagemContarConstroiHT([]);
    </script>
</div>
