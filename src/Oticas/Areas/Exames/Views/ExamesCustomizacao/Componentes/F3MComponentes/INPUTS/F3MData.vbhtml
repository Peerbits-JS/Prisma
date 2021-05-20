@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo

<div data-f3mdbid="@Model.ID">

    @Code
        Dim c As String = ""
        If Not String.IsNullOrEmpty(Model.ViewClassesCSS) Then c = Model.ViewClassesCSS

        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = Model.ModelPropertyName,
    .Label = Model.Label,
    .TipoEditor = Mvc.Componentes.F3MDataTempo,
    .Modelo = Model,
    .ValorPorDefeito = DateAndTime.Now(),
    .EObrigatorio = Model.EObrigatorio,
    .EEditavel = Model.EEditavel,
    .ViewClassesCSS = {c},
    .AtributosHtml = New With {.class = Model.AtributosHtml}})
    End Code

    </div>