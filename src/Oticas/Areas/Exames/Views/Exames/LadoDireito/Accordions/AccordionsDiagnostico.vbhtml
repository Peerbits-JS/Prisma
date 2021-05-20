@Imports F3M.Modelos.Componentes

@Code
    Dim URLAccordionComponente As String = "~/F3M/Areas/Componentes/Views/F3MAccordion/View.vbhtml"
End Code

@Html.Partial(URLAccordionComponente, New F3MAccordion With {.ID = "Rastreio", .Titulo = "Rastreio", .URLPartialBodyContent = "LadoDireito/Accordions/Rastreio", .Modelo = Model})

@Html.Partial(URLAccordionComponente, New F3MAccordion With {.ID = "ResultadoFinal", .Titulo = "Resultado final", .URLPartialBodyContent = "LadoDireito/Accordions/ResultadoFinalDiag", .Modelo = Model, .ExpandidoPorDefeito = True})