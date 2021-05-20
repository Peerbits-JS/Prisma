@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Autenticacao
@ModelType TratamentosLentes

@Scripts.Render("~/bundles/f3m/jsTabelasAuxiliaresTratamentosLentes")

@Html.Partial(URLs.PartialTopo)

@Code
    Html.F3M().Hidden("View", "TratamentosLentes")

    Dim AcaoForm As Int16 = Model.AcaoFormulario
    Dim blnTemDocumentos As Boolean = False

    If AcaoForm = AcoesFormulario.Alterar Then
        blnTemDocumentos = ViewBag.blnTemDocumentos
    End If

    Dim strObs As String = String.Empty
    If Model Is Nothing Then
        strObs = String.Empty
    Else
        strObs = Model.Observacoes
    End If

End Code

<div class="@(ClassesCSS.FormPrinc)">
    <div class="FormularioAjudaScroll">
        <div class="container-fluid">
            <div class="row desContainer">
                @Code
                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = CamposGenericos.Codigo,
                        .Label = Traducao.EstruturaAplicacaoTermosBase.Codigo,
                        .Modelo = Model,
                        .TipoEditor = Mvc.Componentes.F3MTexto,
                        .EEditavel = Not blnTemDocumentos,
                        .AtributosHtml = New With {.class = "textbox-titulo"},
                        .ViewClassesCSS = {ClassesCSS.XS4}})

                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = CamposGenericos.Descricao,
                        .Label = Traducao.EstruturaAplicacaoTermosBase.Descricao,
                        .Modelo = Model,
                        .EEditavel = Not blnTemDocumentos,
                        .AtributosHtml = New With {.class = "textbox-titulo"},
                        .ViewClassesCSS = {ClassesCSS.XS6}})

                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = CamposGenericos.Ativo,
                        .Label = Traducao.EstruturaAplicacaoTermosBase.Ativo,
                        .Modelo = Model,
                        .TipoEditor = Mvc.Componentes.F3MCheckBoxBootstrap,
                        .AtributosHtml = New With {.class = "textbox-titulo"},
                        .ViewClassesCSS = {ClassesCSS.XS2}})
                End Code
            </div>

            <div>
                <div class="row form-container">
                    @Code
                        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDMarca",
                            .TipoEditor = Mvc.Componentes.F3MLookup,
                            .Label = Traducao.EstruturaAplicacaoTermosBase.Marca,
                            .Controlador = "../TabelasAuxiliares/" & Menus.Marcas,
                            .Modelo = Model,
                            .FuncaoJSChange = "TratamentosLentesIDMarcaChange",
                            .EEditavel = Model.AcaoFormulario = AcoesFormulario.Adicionar,
                            .ViewClassesCSS = {ClassesCSS.XS4}})

                        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDModelo",
                                                    .TipoEditor = Mvc.Componentes.F3MLookup,
                                                    .Label = Traducao.EstruturaAplicacaoTermosBase.Modelo,
                                                    .Controlador = "../TabelasAuxiliares/ModelosArtigos",
                                                    .ControladorAccaoExtra = .Controlador & "/" & URLs.ViewIndexGrelha,
                                                    .FuncaoJSEnviaParams = "TratamentosLentesModeloEnviaParams",
                                                    .EEditavel = AcaoForm <> AcoesFormulario.Adicionar AndAlso Not blnTemDocumentos,
                                                    .Modelo = Model,
                                                    .ViewClassesCSS = {ClassesCSS.XS3}})

                        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDTipo",
                                                                            .TipoEditor = Mvc.Componentes.F3MDropDownList,
                                                                            .Label = Traducao.EstruturaAplicacaoTermosBase.Tipo,
                                                                            .Controlador = "../TabelasAuxiliares/TiposTratamentosLentes",
                                                                            .ControladorAccaoExtra = .Controlador & "/" & URLs.ViewIndexGrelha,
                                                                            .FuncaoJSEnviaParams = "",
                                                                            .Modelo = Model,
                                                                            .ViewClassesCSS = {ClassesCSS.XS3}})

                        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Cor",
                                                                .Label = Traducao.EstruturaAplicacaoTermosBase.Cor,
                                                                .Modelo = Model,
                                                                .TipoEditor = Mvc.Componentes.F3MCheckBoxBootstrap,
                                                                .ViewClassesCSS = {ClassesCSS.XS2}})

                    End Code
                </div>

                <div class="obs-holder sem-tab-obs">
                    @Code
                        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = CamposGenericos.Observacoes,
                            .Label = Traducao.EstruturaArtigos.Observacoes,
                            .TipoEditor = Mvc.Componentes.F3MTextArea,
                            .Modelo = Model,
                            .ValorDescricao = strObs,
                            .ControladorAccaoExtra = "../TabelasAuxiliares/" & F3M.Modelos.Constantes.Menus.TextosBase & "/IndexGrelha",
                            .CampoValor = "Texto"})
                    End Code
                </div>
            </div>
        </div>
    </div>
</div>
