@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Modeltype Oticas.DocumentosStockContagem

@Code
    Dim strClasses As String = String.Concat(CssClasses.InputF3M, Operadores.EspacoEmBranco,
    CssClasses.TextBoxTitulo, " txt-def-resumo ", AlinhamentoColuna.Esquerda, Operadores.EspacoEmBranco,
    AtributosHTML.Disabled, Operadores.EspacoEmBranco, CssClasses.F3MSemAcesso)


    Dim lblDocumento As String = Traducao.Cliente.Documento
    If Not String.IsNullOrEmpty(Model.DescricaoTipoDocumento) Then lblDocumento = Model.DescricaoTipoDocumento

End Code

<div class="@(ClassesCSS.XS3)">
    <div class="form-btn">
        <div id="elemFloatingDocumento" class="@CssClasses.F3MFloatingDiv @CssClasses.CaixaTexto @AlinhamentoColuna.Esquerda">
            <label for="Documento" class="" textolabelrequired="">
                @lblDocumento
            </label>
            <a class="@CssClasses.F3MFloatingText" title="@(Traducao.EstruturaAplicacaoTermosBase.Documento)">
                <input class="k-textbox @(strClasses)" data-val="true" data-val-required="@Traducao.EstruturaErros.CampoDocumentoNecessario" disabled="disabled" id="Documento" name="Documento" readonly="readonly" value="@Model.Documento">
            </a>
            <div class="set-resumo">
                <div class="row form-container">
                    @Code
                        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = CamposGenericos.IDTipoDocumento,
                            .Label = Traducao.EstruturaTiposDocumento.TiposDocumento,
                            .Controlador = URLs.Areas.TabAux & Menus.TiposDocumento,
                            .ControladorAccaoExtra = .Controlador & Operadores.Slash & URLs.ViewIndexGrelha,
                            .TipoEditor = Mvc.Componentes.F3MLookup,
                            .Modelo = Model,
                            .ValorID = Model.IDTipoDocumento,
                            .ValorDescricao = Model.CodigoDescricaoTipoDocumento,
                            .CampoTexto = "CodigoDescricao",
                            .OpcaoMenuDescAbrev = Menus.TiposDocumento,
                            .EObrigatorio = True,
                            .EEditavel = Model.AcaoFormulario = AcoesFormulario.Adicionar,
                            .FuncaoJSChange = "DocStocksContagemCabTiposDocChange",
                            .FuncaoJSEnviaParams = "DocStocksContagemCabTiposDocEnviaParams",
                            .EstadoBotoes = New ClsF3MEstadoBotoes With {.PermBtnAdd = 2},
                            .ViewClassesCSS = {ClassesCSS.XS12}})
                    End Code
                </div>
                <div class="row form-container">
                    @Code
                        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDTiposDocumentoSeries",
                                                    .Label = Traducao.EstruturaTiposDocumento.Serie,
                                                    .Controlador = URLs.Areas.TabAux & "TiposDocumentoSeries",
                                                    .TipoEditor = Mvc.Componentes.F3MDropDownList,
                                                    .Modelo = Model,
                                                    .CampoTexto = CamposGenericos.Codigo & "Serie",
                                                    .OpcaoMenuDescAbrev = Menus.TiposDocumento,
                                                    .EObrigatorio = True,
                                                    .EEditavel = Model.AcaoFormulario = AcoesFormulario.Adicionar,
                                                    .DesenhaBotaoLimpar = False,
                                                    .FuncaoJSEnviaParams = "DocStocksContagemCabTiposDocSeriesEnviaParams",
                                                    .FuncaoJSDataBound = "DocStocksContagemCabTipoDocSeriesDataBound",
                                                    .ViewClassesCSS = {ClassesCSS.XS12}})
                    End Code
                </div>
                <div class="row form-container">
                    @Code
                        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = CamposGenericos.NumeroDocumento,
                            .Label = Traducao.EstruturaDocumentos.NumeroDocumento,
                            .TipoEditor = Mvc.Componentes.F3MNumero,
                            .Modelo = Model,
                            .EEditavel = False,
                            .ViewClassesCSS = {ClassesCSS.XS12}})
                    End Code
                </div>
            </div>
        </div>
        <div id="elemFloatingDocumentoBt" class="@CssClasses.F3MFloatingDiv">
            <a class="btn main-btn btn-icon-titulo btn-pills">
                <span class="fm f3icon-pencil" aria-hidden="true"></span>
            </a>
        </div>
    </div>
</div>

@Code
    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "DataDocumento",
        .Label = Traducao.EstruturaDocumentosStockContagem.Data,
        .TipoEditor = Mvc.Componentes.F3MData,
        .Modelo = Model,
        .EObrigatorio = True,
        .EEditavel = Model.EstaComoRascunho() OrElse Model.ID = 0,
        .FuncaoJSChange = "DocStocksContagemCabDataDocChange",
        .AtributosHtml = New With {.class = "textbox-titulo"},
        .ViewClassesCSS = {ClassesCSS.XS3}})
End Code

<div class="@ClassesCSS.XS6">
    <div class="row formul-group">
        <div class="@ClassesCSS.XS6">
            @Code
                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDArmazem",
                    .Label = Traducao.EstruturaDocumentosStockContagem.Armazem,
                    .Modelo = Model,
                    .TipoEditor = Mvc.Componentes.F3MLookup,
                    .Controlador = URLs.Areas.TabAux & Menus.Armazens,
                    .ControladorAccaoExtra = .Controlador & Operadores.Slash & URLs.ViewIndexGrelha,
                    .EObrigatorio = True,
                    .EEditavel = Model.EEditavel(),
                    .FuncaoJSChange = "DocStocksContagemCabArmazemChange",
                    .AtributosHtml = New With {.class = "textbox-titulo"}})

            End Code
        </div>
        <div class="@ClassesCSS.XS6">
            @Code
                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDLocalizacao",
                    .Label = Traducao.EstruturaDocumentosStockContagem.Localizacao,
                    .Modelo = Model,
                    .TipoEditor = Mvc.Componentes.F3MLookup,
                    .Controlador = URLs.Areas.TabAux & F3M.Modelos.Constantes.Menus.ArmazensLocalizacoes & "/ListaComboCodigo",
                    .ControladorAccaoExtra = URLs.Areas.TabAux & MenusComuns.Localizacoes,
                    .EEditavel = Model.IDArmazem IsNot Nothing AndAlso Model.EEditavel(),
                    .EObrigatorio = True,
                    .FuncaoJSEnviaParams = "DocStocksContagemCabLocalizacaoEnviaParams",
                    .FuncaoJSChange = "DocStocksContagemCabLocalizacaoChange",
                    .AtributosHtml = New With {.class = "textbox-titulo"}})
            End Code
        </div>
    </div>
</div>