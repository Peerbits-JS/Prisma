@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@ModelType F3M.ParametrosContexto
@Code
    Dim boolURL As Boolean = Me.Context.Request.FilePath.StartsWith("/F3M")
    Dim NovoUrl As String = URLs.SharedLayoutFuncionalidades
    If boolURL Then
        NovoUrl = URLs.SharedLayoutFuncionalidades.Replace("~/F3M", "~")
    End If
    Layout = NovoUrl
End Code
    
@Styles.Render("~/Content/handsontablestyle")
@Scripts.Render("~/bundles/f3m/jsFormularios")
@Scripts.Render("~/bundles/f3m/jsParametrosContexto")
@Scripts.Render("~/bundles/handsontable")

@Html.Partial("~/F3M/Areas/Administracao/Views/ParametrosContexto/Index.vbhtml", Model)