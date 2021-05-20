@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@ModelType F3M.Modelos.Grelhas.ClsMvcKendoGrid
@Code
    ' Descrição da tab do iframe
    Model.DescricaoTabIframe = "Nome"

    Dim grid As Fluent.GridBuilder(Of Oticas.Clientes)

    If Not Model.OrigemF4.IsEmpty Then
        Model.FuncaoJavascriptGridDataBound = "GrelhaParaGrelhaFormDataBound"

        ' Quando abre o cabeçalho de documentos
        If Model.OrigemF4.IndexOf("documentos") <> -1 Then
            @Scripts.Render("~/bundles/f3m/jsDocumentosComum")
            Model.FuncaoJavascriptEnviaParams = "DocumentoEntidadeEnviaParams"
            Model.AccaoCustomizavelLeitura = "ListaDadosPorTipoDoc"
        End If

        grid = Html.F3M().Grelha(Of Oticas.Clientes)(Model)

    Else
        Dim campoDataDoc As ClsF3MCampo = Model.Campos.Where(Function(f) f.Id.Equals(CamposGenericos.DataNascimento)).FirstOrDefault
        If campoDataDoc IsNot Nothing Then campoDataDoc.TipoEditor = Mvc.Componentes.F3MData

        grid = Html.F3M().GrelhaFormulario(Of Oticas.Clientes)(Model)
    End If

    With grid
        If Not (Me.Context.Request.QueryString("IDDrillDown") IsNot Nothing AndAlso Me.Context.Request.QueryString("IDDrillDown") <> 0) Then
            .DataSource(Function(ds) ds.Ajax.Filter(Function(ft) ft.Add(Function(model) model.Ativo).IsEqualTo(True)))
        End If
        .Render()
    End With
End Code