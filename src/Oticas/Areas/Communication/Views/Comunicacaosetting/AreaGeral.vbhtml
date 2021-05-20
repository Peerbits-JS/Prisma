@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports F3M.Models.Communication
@Imports Oticas.Areas.Communication.Models
@ModelType ComunHistoryCommnModels

@Scripts.Render("~/bundles/f3m/jsCommunicationSmsTemplatesHistoric")

<div class="container-fluid">
    <div class="row desContainer">
        <div class="@ClassesCSS.XS4 sem-tracejado">
            <div class="row formul-group">
                @code
                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Datade",
                        .Label = "Data de",
                        .TipoEditor = Mvc.Componentes.F3MData,
                        .Modelo = Model,
                        .EEditavel = True,
                        .FuncaoJSChange = "CommunicationSettingsDateChange",
                        .AtributosHtml = New With {.class = "textbox-titulo"},
                        .ViewClassesCSS = {ClassesCSS.XS6}})

                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Dataa",
                        .Label = "Data a",
                        .TipoEditor = Mvc.Componentes.F3MData,
                        .Modelo = Model,
                        .EEditavel = True,
                        .FuncaoJSChange = "CommunicationSettingsDateChange",
                        .AtributosHtml = New With {.class = "textbox-titulo"},
                        .ViewClassesCSS = {ClassesCSS.XS6}})
                End code

            </div>
        </div>
        <div class="@ClassesCSS.XS6 sem-tracejado">
            <div class="row formul-group">

                @code
                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDTemplate",
                                                .Label = "Template",
                                                .TipoEditor = Mvc.Componentes.F3MDropDownList,
                                                .Controlador = "/CommunicationSmsTemplates",
                                                .Accao = "GetTemplates",
                                                .Modelo = Model,
                                                .ViewClassesCSS = {ClassesCSS.XS4 + " sem-tracejado"},
                                                .AtributosHtml = New With {.class = "textbox-titulo"}})

                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Destinatarios",
                                .Label = "Destinatarios",
                                .TipoEditor = Mvc.Componentes.F3MDropDownListStatic,
                                .Modelo = Model,
                                .F3MDropDownListStatic = Model.DestinatariosDropdownListStatic,
                                .DesenhaBotaoLimpar = False,
                                .ViewClassesCSS = {ClassesCSS.XS4 + " sem-tracejado"},
                                .AtributosHtml = New With {.class = "textbox-titulo"}})

                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Status",
                                .Label = "Status",
                                .TipoEditor = Mvc.Componentes.F3MDropDownListStatic,
                                .Modelo = Model,
                                .F3MDropDownListStatic = Model.StatusDropdownListStatic,
                                .DesenhaBotaoLimpar = False,
                                .ViewClassesCSS = {ClassesCSS.XS4 + " sem-tracejado"},
                                .AtributosHtml = New With {.class = "textbox-titulo"}})
                End code
            </div>
        </div>
       
        <div>
            <button id="btnFilters" class="btn main-btn btn-cabecalho-simples">Aplicar filtros</button>
        </div>
    </div>
    <div class="@(ConstHT.ClassesHT.Container)">
        <div id="hdsnSms"></div>
    </div>
</div>