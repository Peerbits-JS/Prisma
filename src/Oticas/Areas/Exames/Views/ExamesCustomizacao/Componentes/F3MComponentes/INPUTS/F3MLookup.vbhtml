@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo


<div data-f3mdbid="@Model.ID">

    @Code
        Dim c = ""
        If Not String.IsNullOrEmpty(Model.ViewClassesCSS) Then c = Model.ViewClassesCSS

        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = Model.ModelPropertyName,
    .Label = Model.Label,
    .Controlador = Model.Controlador,
    .ControladorAccaoExtra = Model.ControladorAcaoExtra,
    .TipoEditor = Mvc.Componentes.F3MLookup,
    .Modelo = Model,
    .EObrigatorio = Model.EObrigatorio,
    .EEditavel = Model.EEditavel,
    .CampoTexto = Model.CampoTexto,
    .FuncaoJSChange = Model.FuncaoJSChange,
.FuncaoJSEnviaParams = Model.FuncaoJSEnviaParametros,
    .ViewClassesCSS = {c},
    .AtributosHtml = New With {.class = Model.AtributosHtml}})
    End Code

</div>