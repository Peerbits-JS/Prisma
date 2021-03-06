@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Autenticacao
@ModelType CoresLentes

@Scripts.Render("~/bundles/f3m/jsTabelasAuxiliaresCoresLentes")

@Html.Partial(URLs.PartialTopo)

@Code
    Html.F3M().Hidden("View", "CoresLentes")
    Html.F3M().Hidden("AcaoForm", CShort(Model.AcaoFormulario))

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
                        .EEditavel = Not blnTemDocumentos,
                        .TipoEditor = Mvc.Componentes.F3MTexto,
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
                        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDTipoLente",
                            .TipoEditor = Mvc.Componentes.F3MDropDownList,
                            .Label = Traducao.EstruturaAplicacaoTermosBase.Tipo,
                            .Controlador = "../Sistema/SistemaTiposLentes",
                            .FuncaoJSEnviaParams = "CoresLentesTipoLenteEnviaParams",
                            .FuncaoJSChange = "CoresLentesComboChange",
                            .Modelo = Model,
                            .EEditavel = Not blnTemDocumentos,
                            .ViewClassesCSS = {ClassesCSS.XS4}})

                        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDMateriaLente",
                            .TipoEditor = Mvc.Componentes.F3MDropDownList,
                            .Label = Traducao.EstruturaAplicacaoTermosBase.Materia,
                            .Controlador = "../Sistema/SistemaMateriasLentes",
                            .Modelo = Model,
                            .FuncaoJSChange = "CoresLentesComboChange",
                            .EEditavel = Not blnTemDocumentos,
                            .ViewClassesCSS = {ClassesCSS.XS4}})

                        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Cor",
                            .Label = Traducao.EstruturaAplicacaoTermosBase.Cor,
                            .Modelo = Model,
                            .EEditavel = False,
                            .TipoEditor = Mvc.Componentes.F3MCheckBoxBootstrap,
                            .ViewClassesCSS = {ClassesCSS.XS4}})
                    End Code
                </div>

                <div class="row form-container">
                    @Code
                        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDMarca",
                            .TipoEditor = Mvc.Componentes.F3MLookup,
                            .Label = Traducao.EstruturaAplicacaoTermosBase.Marca,
                            .Controlador = "../TabelasAuxiliares/" & Menus.Marcas,
                            .FuncaoJSChange = "CoresLentesComboChange",
                            .EEditavel = Model.AcaoFormulario = AcoesFormulario.Adicionar,
                            .Modelo = Model,
                            .ViewClassesCSS = {ClassesCSS.XS4}})

                        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDModelo",
                            .TipoEditor = Mvc.Componentes.F3MLookup,
                            .Label = Traducao.EstruturaAplicacaoTermosBase.Modelo,
                            .Controlador = "../TabelasAuxiliares/ModelosArtigos",
                            .ControladorAccaoExtra = .Controlador & "/" & URLs.ViewIndexGrelha,
                            .FuncaoJSEnviaParams = "CoresLentesModeloEnviaParams",
                            .EEditavel = AcaoForm <> AcoesFormulario.Adicionar AndAlso Not blnTemDocumentos,
                            .Modelo = Model,
                            .ViewClassesCSS = {ClassesCSS.XS4}})

                        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "PrecoVenda",
                                        .Label = Traducao.EstruturaAplicacaoTermosBase.PrecoVenda,
                                        .TipoEditor = Mvc.Componentes.F3MNumero,
                                        .CasasDecimais = ClsF3MSessao.RetornaParametros.MoedaReferencia.CasasDecimaisPrecosUnitarios,
                                        .Modelo = Model,
                                        .ViewClassesCSS = {ClassesCSS.XS2}})

                        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "PrecoCusto",
                                                                .Label = "Preço de Custo",
                                                                .TipoEditor = Mvc.Componentes.F3MNumero,
                                                                .CasasDecimais = ClsF3MSessao.RetornaParametros.MoedaReferencia.CasasDecimaisPrecosUnitarios,
                                                                .Modelo = Model,
                                                                .EVisivel = ClsF3MSessao.TemAcessoPorDescricao(AcoesFormulario.Consultar, "VerPrecoCusto", True),
                                                                .ViewClassesCSS = {ClassesCSS.XS2}})
                    End Code
                </div>
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
