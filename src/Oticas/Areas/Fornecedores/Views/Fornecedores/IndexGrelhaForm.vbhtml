@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.Autenticacao

@ModelType F3M.Modelos.Grelhas.ClsMvcKendoGrid

@Code
    Dim podeVerPrecoCusto As Boolean = ClsF3MSessao.TemAcessoPorDescricao(AcoesFormulario.Consultar, "VerPrecoCusto", True)

    If Model.Campos IsNot Nothing AndAlso Not podeVerPrecoCusto Then
        Dim campoSaldo As ClsF3MCampo = Model.Campos.Where(Function(c) c.Id = "Saldo").FirstOrDefault

        If campoSaldo IsNot Nothing Then campoSaldo.EVisivel = False
    End If

    Dim grid As Fluent.GridBuilder(Of Oticas.Fornecedores)

    If Not Model.OrigemF4.IsEmpty Then
        Model.FuncaoJavascriptGridDataBound = "GrelhaParaGrelhaFormDataBound"

        ' Quando abre o cabeçalho de documentos
        If Model.OrigemF4.IndexOf("documentos") <> -1 Then
            @Scripts.Render("~/bundles/f3m/jsDocumentosComum")
            Model.FuncaoJavascriptEnviaParams = "DocumentoEntidadeEnviaParams"
        End If

        grid = Html.F3M().Grelha(Of Oticas.Fornecedores)(Model)
    Else
        grid = Html.F3M().GrelhaFormulario(Of Oticas.Fornecedores)(Model)
    End If

    With grid
        If Not (Me.Context.Request.QueryString("IDDrillDown") IsNot Nothing AndAlso Me.Context.Request.QueryString("IDDrillDown") <> 0) Then
            .DataSource(Function(ds) ds.Ajax.Filter(Function(ft) ft.Add(Function(model) model.Ativo).IsEqualTo(True)))
        End If
        .Render()
    End With
End Code