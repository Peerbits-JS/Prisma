@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo

@Code
    Dim c As String = ""
    If Not String.IsNullOrEmpty(Model.ViewClassesCSS) Then c = Model.ViewClassesCSS

    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = Model.ModelPropertyName,
.Label = Model.Label,
.TipoEditor = Mvc.Componentes.F3MDropDownList,
.Controlador = Model.Controlador,
.Modelo = Model,
.EObrigatorio = Model.EObrigatorio,
.EEditavel = Model.EEditavel,
.DesenhaBotaoLimpar = Model.DesenhaBotaoLimpar,
.FuncaoJSChange = Model.FuncaoJSChange,
.FuncaoJSEnviaParams = Model.FuncaoJSEnviaParametros,
.CampoTexto = Model.CampoTexto,
.ViewClassesCSS = {c},
.AtributosHtml = New With {.class = Model.AtributosHtml}})
End Code
