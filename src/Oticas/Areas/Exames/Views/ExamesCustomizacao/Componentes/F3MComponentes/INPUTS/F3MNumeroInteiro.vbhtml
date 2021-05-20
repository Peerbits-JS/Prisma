@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo

@Code
    Dim calcXS As Integer = Model.EndCol - Model.StartCol + 1
    If Model.EElementoGridLinhas Then calcXS = 12

    Dim Max As Decimal = Mvc.Componentes.ValoresMaximos.F3MNumeroInt
    If Not Model.ValorMaximo Is Nothing Then Max = CDec(Model.ValorMaximo)

    Dim Min As Decimal = CDec(0)
    If Not Model.ValorMinimo Is Nothing Then Min = CDec(Model.ValorMinimo)

    Dim Steps As Decimal = 1
    If Not Model.Steps Is Nothing Then Steps = CDec(Model.Steps)

    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = Model.ModelPropertyName,
        .Label = Model.Label,
        .TipoEditor = Mvc.Componentes.F3MNumeroInt,
        .Modelo = Model,
        .ValorMaximo = Max,
        .ValorMinimo = Min,
        .Steps = Steps,
        .EObrigatorio = Model.EObrigatorio,
        .EEditavel = Model.EEditavel AndAlso Not Model.ECustomizacao,
        .ViewClassesCSS = {"col-f3m col-" & calcXS},
        .AtributosHtml = New With {.class = Model.AtributosHtml}})
End Code