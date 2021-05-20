@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports F3M.Oticas.Domain.Enum
@ModelType F3M.Modelos.Grelhas.ClsMvcKendoGrid

@Code
    'actions
    With Model
        .AccaoCustomizavelLeitura = "ListaAsync"
        .AccaoCustomizavelEdicao = "EditaAsync"
        .AccaoCustomizavelAdicao = "AdicionaAsync"
        .AccaoCustomizavelRemocao = "RemoveAsync"
    End With

    'add ativo column to not display
    Model.Campos.Add(New ClsF3MCampo With {.Id = "Ativo", .EVisivel = False})

    'get grid
    Dim grid As Fluent.GridBuilder(Of Oticas.AccountingConfiguration) = Html.F3M().GrelhaFormulario(Of Oticas.AccountingConfiguration)(Model)
    'render grid
    grid.Render()
End Code