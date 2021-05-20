@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Modeltype List(Of Components)



@Code
    'U R L S     P A R T I A L S     C O M P O N E N T E S
    Dim UrlComponentesElementos As String = "~/Areas/Exames/Views/ExamesCustomizacao/Componentes/F3MComponentes/ELEMENTOS/"
    Dim UrlComponentesInputs As String = "~/Areas/Exames/Views/ExamesCustomizacao/Componentes/F3MComponentes/INPUTS/"
    Dim UrlComponentesParents As String = "~/Areas/Exames/Views/ExamesCustomizacao/Componentes/F3MComponentes/PARENTS/"
    Dim UrlComponentesGridLinhas As String = "~/Areas/Exames/Views/ExamesCustomizacao/Componentes/F3MComponentes/GRIDLINHAS/"

    For Each componente As Components In Model
        'E S C O L H E     T I P O     D E     C O M P O N E N T E
        Select Case componente.TipoComponente
            'C O M P O N E N T E S     -     P A R E N T S
            Case TiposComponentes.Cabecalho
                @Html.Partial(UrlComponentesParents & "F3MCabecalho.vbhtml", componente)

            Case TiposComponentes.Tabs
                @Html.Partial(UrlComponentesParents & "F3MTabs.vbhtml", componente)

            Case TiposComponentes.Accordion
                @Html.Partial(UrlComponentesParents & "F3MAccordeon.vbhtml", componente)

            Case "F3MDivContainer"
                @Html.Partial(UrlComponentesParents & "F3MDivContainer.vbhtml", componente)

            Case TiposComponentes.GridLinhas
                @Html.Partial(UrlComponentesParents & "F3MGridLinhas.vbhtml", componente)

            Case TiposComponentes.ArrayChecks
                @Html.Partial(UrlComponentesParents & "F3MArrayChecks.vbhtml", componente)

                'C O M P O N E N T E S     -     E L E M E N T O S
            Case TiposComponentes.TituloSecundario
                @Html.Partial(UrlComponentesElementos & "F3MTituloSecundario.vbhtml", componente)

            Case TiposComponentes.ArrayChecksTitulo
                @Html.Partial(UrlComponentesElementos & "F3MArrayChecksTitulo.vbhtml", componente)

            Case "F3MSimpleHR"
                @Html.Partial(UrlComponentesElementos & "F3MSimpleHR.vbhtml", componente)

            Case "F3MSpanText"
                @Html.Partial(UrlComponentesElementos & "F3MSpanText.vbhtml", componente)

            Case "F3MStrongText"
                @Html.Partial(UrlComponentesElementos & "F3MStrongText.vbhtml", componente)

            Case "F3MLabel"
                @Html.Partial(UrlComponentesElementos & "F3MLabel.vbhtml", componente)

            Case "F3MA"
                @Html.Partial(UrlComponentesElementos & "F3MA.vbhtml", componente)

                'C O M P O N E N T E S     -     I N P U T S
            Case TiposComponentes.NumeroInteiro
                Dim ModelInput = Areas.Exames.Controllers.ExamesCustomizacaoController.CreateClassAtRuntime(componente)
                @Html.Partial(UrlComponentesInputs & "F3MNumeroInteiro.vbhtml", ModelInput)

            Case TiposComponentes.NumeroDecimal
                Dim ModelInput = Areas.Exames.Controllers.ExamesCustomizacaoController.CreateClassAtRuntime(componente)
                @Html.Partial(UrlComponentesInputs & "F3MNumeroDecimal.vbhtml", ModelInput)

            Case TiposComponentes.Texto
                Dim ModelInput = Areas.Exames.Controllers.ExamesCustomizacaoController.CreateClassAtRuntime(componente)
                @Html.Partial(UrlComponentesInputs & "F3MTexto.vbhtml", ModelInput)

            Case TiposComponentes.CheckBox
                Dim ModelInput = Areas.Exames.Controllers.ExamesCustomizacaoController.CreateClassAtRuntime(componente)
                @Html.Partial(UrlComponentesInputs & "F3MCheckBox.vbhtml", ModelInput)

            Case TiposComponentes.Data
                Dim ModelInput = Areas.Exames.Controllers.ExamesCustomizacaoController.CreateClassAtRuntime(componente)
                @Html.Partial(UrlComponentesInputs & "F3MData.vbhtml", ModelInput)

            Case TiposComponentes.ObservacoesTab
                Dim ModelInput = Areas.Exames.Controllers.ExamesCustomizacaoController.CreateClassAtRuntime(componente)
                @Html.Partial(UrlComponentesInputs & "F3MObservacoesTab.vbhtml", ModelInput)

            Case TiposComponentes.Lookup
                Dim ModelInput = Areas.Exames.Controllers.ExamesCustomizacaoController.CreateClassAtRuntime(componente)
                @Html.Partial(UrlComponentesInputs & "F3MLookup.vbhtml", ModelInput)

            Case TiposComponentes.DropdDownList
                Dim ModelInput = Areas.Exames.Controllers.ExamesCustomizacaoController.CreateClassAtRuntime(componente)
                @Html.Partial(UrlComponentesInputs & "F3MDropDownList.vbhtml", ModelInput)

            Case TiposComponentes.TextoCaixa
                Dim ModelInput = Areas.Exames.Controllers.ExamesCustomizacaoController.CreateClassAtRuntime(componente)
                @Html.Partial(UrlComponentesInputs & "F3MTextoCaixa.vbhtml", ModelInput)

            Case TiposComponentes.Foto
                Dim ModelInput = Areas.Exames.Controllers.ExamesCustomizacaoController.CreateClassAtRuntime(componente)
                @Html.Partial(UrlComponentesInputs & "F3MFoto.vbhtml", ModelInput)

            Case "F3MEditorWYSIWYG"
                Dim ModelInput = Areas.Exames.Controllers.ExamesCustomizacaoController.CreateClassAtRuntime(componente)
                @Html.Partial(UrlComponentesInputs & "F3MEditorWYSIWYG.vbhtml", ModelInput)

            Case "F3MGroupNum"
                @Html.Partial(UrlComponentesInputs & "F3MGroupNum.vbhtml", componente)

            Case "F3MFotoGrid"
                @Html.Partial(UrlComponentesInputs & "F3MFotoGrid.vbhtml", componente)

                'G R E L H A     D E     L I N H A S
            Case "F3MGridLinhasTHEAD"
                @Html.Partial(UrlComponentesGridLinhas & "F3MGridLinhasTHEAD.vbhtml", componente)

            Case "F3MGridLinhasTBODY"
                @Html.Partial(UrlComponentesGridLinhas & "F3MGridLinhasTBODY.vbhtml", componente)

            Case "F3MGridLinhasTH"
                @Html.Partial(UrlComponentesGridLinhas & "F3MGridLinhasTH.vbhtml", componente)

            Case "F3MGridLinhasTR"
                @Html.Partial(UrlComponentesGridLinhas & "F3MGridLinhasTR.vbhtml", componente)

            Case "F3MGridLinhasTD"
                @Html.Partial(UrlComponentesGridLinhas & "F3MGridLinhasTD.vbhtml", componente)
        End Select
    Next
End Code