@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Utilitarios

@Code
    Html.F3M().Hidden("hdfIDTipoLente", Model.IDTipoLente)
    Html.F3M().Hidden("hdfIDMateriaLente", Model.IDMateriaLente)
    Html.F3M().Hidden("hdfIDModelo", Model.IDModelo)
    Html.F3M().Hidden("hdfDescricaoModelo", Model.DescricaoModelo)

    Dim AcaoForm As AcoesFormulario = Model.AcaoFormulario
    Dim blnEnable As Boolean = If(AcaoForm = AcoesFormulario.Adicionar, True, False)
    ViewBag.EnableSuplementos = blnEnable
End Code

<fieldset class="fsStyle">
    <legend class="legendStyle">@Traducao.EstruturaArtigos.LentesOftalmicas</legend>
    <div class="@ClassesCSS.SoXS9">
        <div class="row form-container">
            @Code
                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDModelo",
                    .Label = Traducao.EstruturaArtigos.Modelo,
                    .Modelo = Model,
                    .Controlador = "../TabelasAuxiliares/ModelosArtigos",
                    .ControladorAccaoExtra = .Controlador & "/" & URLs.ViewIndexGrelha,
                    .CampoTexto = CamposGenericos.Descricao,
                    .FuncaoJSChange = "ArtigosIDModeloChange",
                    .FuncaoJSEnviaParams = "ArtigosIDModeloEnviaParams",
                    .TipoEditor = Mvc.Componentes.F3MLookup,
                                                              .EEditavel = blnEnable,
                    .ViewClassesCSS = {ClassesCSS.XS4}})

                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDTratamentoLente",
                    .Label = Traducao.EstruturaArtigos.Tratamentos,
                    .Modelo = Model,
                    .Controlador = "../TabelasAuxiliares/TratamentosLentes",
                    .ControladorAccaoExtra = .Controlador & "/" & URLs.ViewIndexGrelha,
                    .CampoTexto = CamposGenericos.Descricao,
                    .FuncaoJSEnviaParams = "ArtigosIDTratamentosEnviaParams",
                    .TipoEditor = Mvc.Componentes.F3MLookup,
                                                              .EEditavel = blnEnable,
                    .ViewClassesCSS = {ClassesCSS.XS4}})

                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDCorLente",
                    .Label = Traducao.EstruturaArtigos.Cor,
                    .Modelo = Model,
                    .Controlador = "../TabelasAuxiliares/CoresLentes",
                    .ControladorAccaoExtra = .Controlador & "/" & URLs.ViewIndexGrelha,
                    .CampoTexto = CamposGenericos.Descricao,
                    .FuncaoJSEnviaParams = "ArtigosIDCorLenteEnviaParams",
                    .TipoEditor = Mvc.Componentes.F3MLookup,
                                                              .EEditavel = blnEnable,
                    .ViewClassesCSS = {ClassesCSS.XS4}})
            End Code

            @*<div class="@ClassesCSS.SoXS4">
                    <button type="button" class="btn main-btn btn-form-xs" id="btEspecificar">@Traducao.EstruturaArtigos.Especificar</button>
                </div>*@

        </div>
        <div class="row form-container">
            @Code
                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Diametro",
                    .Label = Traducao.EstruturaArtigos.Diametro,
                    .Modelo = Model,
                    .TipoEditor = Mvc.Componentes.F3MTexto,
                                                              .EEditavel = blnEnable,
                    .ViewClassesCSS = {ClassesCSS.XS4}})

                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "PotenciaEsferica",
                    .Label = Traducao.EstruturaArtigos.PotenciaEsferica,
                    .Modelo = Model,
                    .CasasDecimais = 2,
                    .ValorMaximo = 50,
                    .ValorMinimo = -50,
                .Steps = 0.25,
                    .TipoEditor = Mvc.Componentes.F3MNumero,
                                                              .EEditavel = blnEnable,
                    .ViewClassesCSS = {ClassesCSS.XS4}})

                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "PotenciaCilindrica",
                        .Label = Traducao.EstruturaArtigos.PotenciaCilindrica,
                        .Modelo = Model,
                        .CasasDecimais = 2,
                        .ValorMaximo = 50,
                        .ValorMinimo = -50,
                                        .Steps = 0.25,
                    .TipoEditor = Mvc.Componentes.F3MNumero,
                                                              .EEditavel = blnEnable,
                    .ViewClassesCSS = {ClassesCSS.XS4}})
            End Code
        </div>
        <div class="row form-container">
            @Code
                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Adicao",
                      .Label = Traducao.EstruturaArtigos.Adicao,
                      .Modelo = Model,
                      .CasasDecimais = 2,
                      .ValorMaximo = 20,
                      .ValorMinimo = 0,
                    .Steps = 0.25,
                      .TipoEditor = Mvc.Componentes.F3MNumero,
                                                                  .EEditavel = blnEnable,
                      .ViewClassesCSS = {ClassesCSS.XS4}})

                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "PotenciaPrismatica",
                        .Label = Traducao.EstruturaArtigos.PotenciaPrismatica,
                        .Modelo = Model,
                        .CasasDecimais = 2,
                        .ValorMaximo = 50,
                        .ValorMinimo = -50,
                    .Steps = 0.25,
                        .TipoEditor = Mvc.Componentes.F3MNumero,
                                                                  .EEditavel = blnEnable,
                        .ViewClassesCSS = {ClassesCSS.XS4}})
            End Code
        </div>
    </div>
    <div id="partialLentesOftalmicasSuplementos">
        <!-- H E R E    P A R T I A L -->
    </div>
</fieldset>