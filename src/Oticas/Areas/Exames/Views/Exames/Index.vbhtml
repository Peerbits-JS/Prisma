@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.Grelhas
@ModelType ClsMvcKendoGrid

@Scripts.Render("~/bundles/f3m/jsExamesIndex")

@Code
    Dim boolTemAcessoImprimir As Boolean = ClsF3MSessao.TemAcessoPorDescricao(AcoesFormulario.Imprimir, "Exames")
    Html.F3M().Hidden("TemAcessoImprimir", boolTemAcessoImprimir)

    Layout = URLs.SharedLayoutFuncionalidades
    Dim htmlStr As String = Html.Partial(URLs.ViewIndexGrelhaF, Model).ToHtmlString

    Model.GrelhaHTML = htmlStr
    @Html.Partial(Model.PartialViewInterna, Model)
End Code