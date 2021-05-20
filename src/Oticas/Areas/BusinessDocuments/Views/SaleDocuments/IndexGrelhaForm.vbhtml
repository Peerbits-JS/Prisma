@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@ModelType F3M.Modelos.Grelhas.ClsMvcKendoGrid

@Scripts.Render("~/bundles/businessdocuments/utils")
@Scripts.Render("~/bundles/businessdocuments/saledocuments/index")

@Code
    'actions
    With Model
        .AccaoCustomizavelLeitura = "ListAsync"
        .AccaoCustomizavelEdicao = "EditAsync"
        .AccaoCustomizavelAdicao = "CreateAsync"
        .AccaoCustomizavelRemocao = "RemoveAsync"
        .Tipo = GetType(F3M.Core.Business.Documents.Models.SaleDocuments.SaleDocumentsList)
        .ControladorCustomizavel = "SaleDocuments"
        .Campos.Add(New ClsF3MCampo With {.Id = "Ativo", .EVisivel = False})
        .CamposOrdenar = New Dictionary(Of String, String) From {{"DocumentDate", "desc"}}
        .DesenhaColunaExtra = False
    End With

    Dim campoDataDoc As ClsF3MCampo = Model.Campos.FirstOrDefault(Function(f) f.Id.Equals("DocumentDate"))
    If campoDataDoc IsNot Nothing Then campoDataDoc.TipoEditor = Mvc.Componentes.F3MData

    Dim grid As Fluent.GridBuilder(Of F3M.Core.Business.Documents.Models.SaleDocuments.SaleDocumentsList)
    grid = Html.F3M().GrelhaFormulario(Of F3M.Core.Business.Documents.Models.SaleDocuments.SaleDocumentsList)(Model)

    With grid
        .Render()
    End With
End Code