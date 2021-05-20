@Modeltype Oticas.HistoricoExames
@Imports F3M.Modelos.Componentes

@Code
    Dim URLAccordionComponente As String = "~/F3M/Areas/Componentes/Views/F3MAccordion/View.vbhtml"

    If Not Model.IDExameSelecionado Is Nothing Then
        Dim listOfAccordions As List(Of F3MAccordion) = Model.ExamesAccordions.ListOfExamesAccordionsInfo.Where(Function(w)
                                                                                                                    Return Not w.IDElemento Is Nothing AndAlso
                                                                                                                    w.IDElemento.Contains("CT_TAB")
                                                                                                                End Function).OrderBy(Function(o)
                                                                                                                                          Return o.Ordem
                                                                                                                                      End Function).Select(Function(s)
                                                                                                                                                               Dim _accordion As New F3MAccordion

                                                                                                                                                               With _accordion
                                                                                                                                                                   .Titulo = s.Label
                                                                                                                                                                   .Modelo = Model
                                                                                                                                                                   .ID = s.IDElemento
                                                                                                                                                                   .URLPartialBodyContent = "LadoDireito/Accordions/" & s.IDElemento.Split("_")(2)
                                                                                                                                                                   .ExpandidoPorDefeito = s.IDElemento = "CT_TAB_ResultadoFinal"
                                                                                                                                                               End With

                                                                                                                                                               Return _accordion
                                                                                                                                                           End Function).ToList()

        For Each item As F3MAccordion In listOfAccordions
            @Html.Partial(URLAccordionComponente, item)
        Next

    Else
        @Html.Partial(URLAccordionComponente, New F3MAccordion With {.ID = "Anamnese", .Titulo = "Anamnsese", .URLPartialBodyContent = "LadoDireito/Accordions/Anamnese", .Modelo = Model})

        @Html.Partial(URLAccordionComponente, New F3MAccordion With {.ID = "GraduacaoAtual", .Titulo = "Graduação atual", .URLPartialBodyContent = "LadoDireito/Accordions/GraduacaoAtual", .Modelo = Model})

        @Html.Partial(URLAccordionComponente, New F3MAccordion With {.ID = "ExamesComplementares", .Titulo = "Exames complementares", .URLPartialBodyContent = "LadoDireito/Accordions/ExamesComplementares", .Modelo = Model})

        @Html.Partial(URLAccordionComponente, New F3MAccordion With {.ID = "TestesSubjetivos", .Titulo = "Testes subjetivos", .URLPartialBodyContent = "LadoDireito/Accordions/TestesSubjetivos", .Modelo = Model})

        @Html.Partial(URLAccordionComponente, New F3MAccordion With {.ID = "ResultadoFinal", .Titulo = "Resultado final", .URLPartialBodyContent = "LadoDireito/Accordions/ResultadoFinal", .Modelo = Model, .ExpandidoPorDefeito = True})
    End If
End Code