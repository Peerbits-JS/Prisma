@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Autenticacao
@ModelType ModelosArtigos

@Scripts.Render("~/bundles/f3m/jsTabelasAuxiliaresModelosArtigos")

@Html.Partial(URLs.PartialTopo)

@Code
    Html.F3M().Hidden("View", "ModelosLentes")
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
                        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDTipoArtigo",
                            .TipoEditor = Mvc.Componentes.F3MDropDownList,
                            .Label = Traducao.EstruturaAplicacaoTermosBase.TipoArtigo,
                            .Controlador = "../TabelasAuxiliares/TiposArtigos",
                            .FuncaoJSChange = "ModelosArtigosTipoArtigoChange",
                            .Modelo = Model,
                            .EEditavel = Not blnTemDocumentos,
                            .ViewClassesCSS = {ClassesCSS.XS4}})

                        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDMarca",
                            .TipoEditor = Mvc.Componentes.F3MLookup,
                            .Label = Traducao.EstruturaAplicacaoTermosBase.Marca,
                            .Controlador = "../TabelasAuxiliares/" & Menus.Marcas,
                            .Modelo = Model,
                            .EEditavel = Not blnTemDocumentos,
                            .OpcaoMenuDescAbrev = Menus.Marcas,
                            .ViewClassesCSS = {ClassesCSS.XS4}})

                        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDTipoLente",
                            .TipoEditor = Mvc.Componentes.F3MDropDownList,
                            .Label = Traducao.EstruturaAplicacaoTermosBase.Tipo,
                            .Controlador = "../Sistema/SistemaTiposLentes",
                            .FuncaoJSEnviaParams = "ModelosArtigosTipoArtigoEnviaParams",
                            .Modelo = Model,
                            .EEditavel = Not blnTemDocumentos,
                            .ViewClassesCSS = {ClassesCSS.XS4}})
                    End Code
                </div>

                <div class="row form-container">
                    @Code
                        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDMateriaLente",
                            .TipoEditor = Mvc.Componentes.F3MDropDownList,
                            .Label = Traducao.EstruturaAplicacaoTermosBase.Materia,
                            .Controlador = "../Sistema/SistemaMateriasLentes",
                            .Modelo = Model,
                            .EEditavel = Not blnTemDocumentos,
                            .ViewClassesCSS = {ClassesCSS.XS4}})

                        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDSuperficieLente",
                            .TipoEditor = Mvc.Componentes.F3MDropDownList,
                            .Label = Traducao.EstruturaAplicacaoTermosBase.Superficie,
                            .Controlador = "../Sistema/SistemaSuperficiesLentes",
                            .Modelo = Model,
                            .ViewClassesCSS = {ClassesCSS.XS4}})

                        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IndiceRefracao",
                            .Label = Traducao.EstruturaAplicacaoTermosBase.IndiceRefracao,
                            .TipoEditor = Mvc.Componentes.F3MNumero,
                            .ValorPorDefeito = 1.5,
                            .CasasDecimais = 3,
                            .Modelo = Model,
                            .ViewClassesCSS = {ClassesCSS.XS2}})

                        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Fotocromatica",
                            .Label = Traducao.EstruturaAplicacaoTermosBase.Fotocromatica,
                            .TipoEditor = Mvc.Componentes.F3MCheckBoxBootstrap,
                            .Modelo = Model,
                            .ViewClassesCSS = {ClassesCSS.XS1}})

                        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Stock",
                            .Label = Traducao.EstruturaAplicacaoTermosBase.Stock,
                            .Modelo = Model,
                            .TipoEditor = Mvc.Componentes.F3MCheckBoxBootstrap,
                            .ViewClassesCSS = {ClassesCSS.XS1}})
                    End Code
                </div>

                <div class="row form-container">
                    @Code
                        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "UVA",
                            .Label = Traducao.EstruturaAplicacaoTermosBase.UVA,
                            .Modelo = Model,
                            .TipoEditor = Mvc.Componentes.F3MTexto,
                            .ViewClassesCSS = {ClassesCSS.XS4}})

                        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "UVB",
                            .Label = Traducao.EstruturaAplicacaoTermosBase.UVB,
                            .Modelo = Model,
                            .ViewClassesCSS = {ClassesCSS.XS4}})

                        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Infravermelhos",
                            .Label = Traducao.EstruturaAplicacaoTermosBase.Infravermelhos,
                            .Modelo = Model,
                            .ViewClassesCSS = {ClassesCSS.XS4}})
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

