@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports F3M.Oticas.Domain.Enum
@ModelType F3M.Modelos.Grelhas.ClsMvcKendoGrid

@Scripts.Render("~/bundles/f3m/jsInventarioATIndex")

@Code
    'actions
    With Model
        .AccaoCustomizavelLeitura = "ListaAsync"
        .AccaoCustomizavelEdicao = "EditaAsync"
        .AccaoCustomizavelAdicao = "AdicionaAsync"
        .AccaoCustomizavelRemocao = "RemoveAsync"
    End With
    'get html download column
    Dim HTMLDownload As String = String.Empty
    HTMLDownload += "<a class=""btn btn-sm btn-line"" f3m-data-id=#=data.ID# f3m-data-file-type=""" & TaxAuthorityComunicationFileType.Xml & """ onclick=""InventarioATIndexExporta(this)"">.XML</a>"
    HTMLDownload += "&nbsp;"
    HTMLDownload += "<a class=""btn btn-sm btn-line"" f3m-data-id=#=data.ID# f3m-data-file-type=""" & TaxAuthorityComunicationFileType.Csv & """ onclick=""InventarioATIndexExporta(this)"">.CSV</a>"
    'add download column
    Model.Campos.Add(New ClsF3MCampo With {.Id = "Download", .LarguraColuna = 200, .Label = "Download", .Alinhamento = "alinhamentocentro", .TipoEditor = Mvc.Componentes.F3MHTML, .HTML = HTMLDownload})
    'add ativo column to not display
    Model.Campos.Add(New ClsF3MCampo With {.Id = "Ativo", .EVisivel = False})
    'set date do created col
    Dim createdAtCol As ClsF3MCampo = Model.Campos.Where(Function(f) f.Id.Equals("CreatedAt")).FirstOrDefault()
    If createdAtCol IsNot Nothing Then
        createdAtCol.TipoEditor = Mvc.Componentes.F3MData
    End If
    'set date to date col
    Dim dateAtCol As ClsF3MCampo = Model.Campos.Where(Function(f) f.Id.Equals("DateFilter")).FirstOrDefault()
    If dateAtCol IsNot Nothing Then
        dateAtCol.TipoEditor = Mvc.Componentes.F3MData
    End If
    'get grid
    Dim grid As Fluent.GridBuilder(Of Oticas.InventarioAT) = Html.F3M().GrelhaFormulario(Of Oticas.InventarioAT)(Model)
    'render grid
    grid.Render()
End Code
