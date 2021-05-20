@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports Oticas.Areas.Communication.Models
@ModelType CommunicationSmsTemplates

@Code
    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Nome",
        .Label = "Nome",
        .Modelo = Model,
        .DesenhaBotaoLimpar = False,
        .ViewClassesCSS = {ClassesCSS.XS3},
        .EEditavel = Model.ID = 0,
        .AtributosHtml = New With {.class = CssClasses.TextBoxTitulo}})

    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDSistemaEnvio",
        .Label = "Sistema de envio",
        .TipoEditor = Mvc.Componentes.F3MDropDownList,
        .Controlador = URLs.Areas.TabAux & "ComunicacaoSms",
        .ValorID = Model.IDSistemaEnvio,
        .ValorDescricao = Model.DescricaoSistemaEnvio,
        .Modelo = Model,
        .DesenhaBotaoLimpar = False,
        .ViewClassesCSS = {ClassesCSS.XS3},
        .EEditavel = Model.ID = 0,
        .AtributosHtml = New With {.class = CssClasses.TextBoxTitulo}})

    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDParametrizacaoConsentimentosPerguntas",
        .Label = "Consentimento à questão",
        .TipoEditor = Mvc.Componentes.F3MDropDownList,
        .Controlador = URLs.Areas.TabAux & "ParametrizacaoConsentimentosPerguntas",
        .ValorID = Model.IDParametrizacaoConsentimentosPerguntas,
        .ValorDescricao = Model.DescricaoParametrizacaoConsentimentosPerguntas,
        .Modelo = Model,
        .DesenhaBotaoLimpar = False,
        .ViewClassesCSS = {ClassesCSS.XS6},
        .EEditavel = Model.ID = 0,
        .AtributosHtml = New With {.class = CssClasses.TextBoxTitulo}})
End code