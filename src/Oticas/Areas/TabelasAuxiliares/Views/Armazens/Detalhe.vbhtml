@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@ModelType Armazens

@Html.Partial("~/F3M/Areas/TabelasAuxiliaresComum/Views/Armazens/Detalhe.vbhtml", Model)

@CODE
    Dim funcJSMoradaChange = "ValidaMoradaChange"
    Dim AcaoForm As Int16 = Model.AcaoFormulario
End Code

<div class="@(ClassesCSS.FormPrinc)">
    <div class="FormularioAjudaScroll">
        <div class="container-fluid">
            <div class="row desContainer">
                @Code
                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = CamposGenericos.Codigo,
                                .Label = Traducao.EstruturaArtigos.CODIGO,
                                .Modelo = Model,
                                .AtributosHtml = New With {.class = "textbox-titulo"},
                                .ViewClassesCSS = {ClassesCSS.XS4}})

                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = CamposGenericos.Descricao,
                        .Label = Traducao.EstruturaArtigos.DESCRICAO,
                        .Modelo = Model,
                        .AtributosHtml = New With {.class = "textbox-titulo"},
                        .ViewClassesCSS = {ClassesCSS.XS6}})

                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = CamposGenericos.Ativo,
                        .Label = Traducao.EstruturaArtigos.ATIVO,
                        .TipoEditor = Mvc.Componentes.F3MCheckBoxBootstrap,
                        .Modelo = Model,
                        .ViewClassesCSS = {ClassesCSS.XS2}})
                End Code
            </div>

            <div class="row form-container">
                @Code
                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Morada",
                        .Label = Traducao.EstruturaAplicacaoTermosBase.Morada,
                        .Modelo = Model,
                        .ViewClassesCSS = {ClassesCSS.XS12}})
                End Code
            </div>
            <div class="row form-container">
                @Code
                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = CamposGenericos.IDCodigoPostal,
                        .TipoEditor = Mvc.Componentes.F3MLookup,
                        .ControladorAccaoExtra = URLs.Areas.TabAux & Menus.CodigosPostais,
                        .Controlador = .ControladorAccaoExtra & "/ListaComboCodigo",
                        .CampoTexto = CamposGenericos.Codigo,
                        .Label = Traducao.EstruturaUtilizadores.CodigoPostalCarga,
                        .FuncaoJSChange = funcJSMoradaChange,
                        .FuncaoJSEnviaParams = "ArmazensEnviaParametros",
                        .Modelo = Model,
                        .OpcaoMenuDescAbrev = Menus.CodigosPostais,
                        .ViewClassesCSS = {ClassesCSS.XS3}})

                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = CamposGenericos.IDConcelho,
                                        .Label = Traducao.EstruturaUtilizadores.ConcelhoCarga,
                                        .Controlador = "../TabelasAuxiliares/" & Menus.Concelhos,
                                        .FuncaoJSChange = funcJSMoradaChange,
                                        .FuncaoJSEnviaParams = "ArmazensEnviaParametros",
                                        .TipoEditor = Mvc.Componentes.F3MLookup,
                                        .Modelo = Model,
                                        .OpcaoMenuDescAbrev = Menus.Concelhos,
                                        .ViewClassesCSS = {ClassesCSS.XS3}})

                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = CamposGenericos.IDDistrito,
                                .Label = Traducao.EstruturaUtilizadores.DistritoCarga,
                                .Controlador = "../TabelasAuxiliares/" & Menus.Distritos,
                                .FuncaoJSChange = funcJSMoradaChange,
                                .TipoEditor = Mvc.Componentes.F3MLookup,
                                .Modelo = Model,
                                .OpcaoMenuDescAbrev = Menus.Distritos,
                                .ViewClassesCSS = {ClassesCSS.XS3}})

                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = CamposGenericos.IDPais,
                                .Label = Traducao.EstruturaAplicacaoTermosBase.Pais,
                                .Controlador = "../TabelasAuxiliares/" & Menus.Paises,
                                .TipoEditor = Mvc.Componentes.F3MLookup,
                                .Modelo = Model,
                                .OpcaoMenuDescAbrev = Menus.Paises,
                                .ViewClassesCSS = {ClassesCSS.XS3}})
                End Code
            </div>
            <div class="seguintesgrelhas">
                @Code ViewBag.VistaParcial = True End Code
                @Html.Partial("~/Areas/TabelasAuxiliares/Views/ArmazensLocalizacoes/Index.vbhtml")
            </div>
        </div>
    </div>
</div>