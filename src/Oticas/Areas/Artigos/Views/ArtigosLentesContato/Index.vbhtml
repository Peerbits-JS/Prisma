@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Utilitarios

@Code
    Dim AcaoForm As AcoesFormulario = Model.AcaoFormulario
    Dim blnEnable As Boolean = If(AcaoForm = AcoesFormulario.Adicionar, True, False)

    Html.F3M().Hidden("hdfIDTipoLente", Model.IDTipoLente)
    Html.F3M().Hidden("hdfIDModelo", Model.IDModelo)
    Html.F3M().Hidden("hdfDescricaoModelo", Model.DescricaoModelo)
End Code

<fieldset class="fsStyle">
    <legend class="legendStyle">@Traducao.EstruturaArtigos.LentesContato</legend>
    <div class="row form-container">
        @Code
            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDModelo",
                .Label = Traducao.EstruturaArtigos.Modelo,
                .Modelo = Model,
                .Controlador = "../TabelasAuxiliares/ModelosArtigos",
                .ControladorAccaoExtra = .Controlador & "/" & URLs.ViewIndexGrelha,
                .FuncaoJSEnviaParams = "ArtigosIDModeloEnviaParams",
                .CampoTexto = CamposGenericos.Descricao,
                .TipoEditor = Mvc.Componentes.F3MLookup,
                                                          .EEditavel = blnEnable,
                .ViewClassesCSS = {ClassesCSS.XS3}})
        End Code

    </div>
    <div class="row form-container">
        @Code
            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Diametro",
                .Label = Traducao.EstruturaArtigos.Diametro,
                .Modelo = Model,
                .CasasDecimais = 2,
                .ValorMaximo = 20,
                .ValorMinimo = 0,
                                .Steps = 0.5,
                .TipoEditor = Mvc.Componentes.F3MTexto,
                                                          .EEditavel = blnEnable,
                .ViewClassesCSS = {ClassesCSS.XS3}})

            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "PotenciaEsferica",
                .Label = Traducao.EstruturaArtigos.PotenciaEsferica,
                .Modelo = Model,
                .CasasDecimais = 2,
                .ValorMaximo = 50,
                .ValorMinimo = -50,
                .Steps = 0.25,
                .TipoEditor = Mvc.Componentes.F3MNumero,
                                                          .EEditavel = blnEnable,
                .ViewClassesCSS = {ClassesCSS.XS3}})

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
            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Raio",
                .Label = Traducao.EstruturaArtigos.RaioCurvatura,
                .Modelo = Model,
                .CasasDecimais = 2,
                .ValorMaximo = 20,
                .ValorMinimo = 0,
                .TipoEditor = Mvc.Componentes.F3MTexto,
                                                          .EEditavel = blnEnable,
                .ViewClassesCSS = {ClassesCSS.XS3}})

            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Raio2",
                .Label = Traducao.EstruturaArtigos.DetalheRaioCurvatura,
                .Modelo = Model,
                .TipoEditor = Mvc.Componentes.F3MTexto,
                                                          .EEditavel = blnEnable,
                .ViewClassesCSS = {ClassesCSS.XS3}})

            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Eixo",
              .Label = Traducao.EstruturaArtigos.Eixo,
              .Modelo = Model,
              .CasasDecimais = 0,
              .ValorMaximo = 180,
              .ValorMinimo = 0,
                .Steps = 1,
                .TipoEditor = Mvc.Componentes.F3MNumeroInt,
                                                          .EEditavel = blnEnable,
              .ViewClassesCSS = {ClassesCSS.XS2}})

            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Adicao",
                .Label = Traducao.EstruturaArtigos.Adicao,
                .Modelo = Model,
                .CasasDecimais = 2,
                .ValorMaximo = 20,
                .ValorMinimo = 0,
                .Steps = 0.25,
                .TipoEditor = Mvc.Componentes.F3MNumero,
                                                          .EEditavel = blnEnable,
                .ViewClassesCSS = {ClassesCSS.XS2}})
        End Code
    </div>
</fieldset>