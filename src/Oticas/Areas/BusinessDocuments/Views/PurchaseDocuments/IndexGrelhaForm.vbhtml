@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@ModelType F3M.Modelos.Grelhas.ClsMvcKendoGrid

@Scripts.Render("~/bundles/businessdocuments/utils")
@Scripts.Render("~/bundles/businessdocuments/purchasedocuments/index")

@Code
    'actions
    With Model
        .AccaoCustomizavelLeitura = "ListAsync"
        .AccaoCustomizavelEdicao = "EditAsync"
        .AccaoCustomizavelAdicao = "CreateAsync"
        .AccaoCustomizavelRemocao = "RemoveAsync"
        .Tipo = GetType(F3M.Core.Business.Documents.Models.PurchaseDocuments.PurchaseDocumentsList)
        .ControladorCustomizavel = "PurchaseDocuments"
        .Campos.Add(New ClsF3MCampo With {.Id = "Ativo", .EVisivel = False})
        .CamposOrdenar = New Dictionary(Of String, String) From {{"DocumentDate", "desc"}}
        .DesenhaColunaExtra = False
    End With


    Dim campoDataDoc As ClsF3MCampo = Model.Campos.FirstOrDefault(Function(f) f.Id.Equals("DocumentDate"))
    If campoDataDoc IsNot Nothing Then campoDataDoc.TipoEditor = Mvc.Componentes.F3MData

    'get grid
    Dim grid As Fluent.GridBuilder(Of F3M.Core.Business.Documents.Models.PurchaseDocuments.PurchaseDocumentsList)
    grid = Html.F3M().GrelhaFormulario(Of F3M.Core.Business.Documents.Models.PurchaseDocuments.PurchaseDocumentsList)(Model)
    'render grid
    With grid
        .Render()
    End With
End Code