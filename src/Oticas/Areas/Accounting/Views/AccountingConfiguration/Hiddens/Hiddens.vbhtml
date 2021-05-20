@Imports F3M.Modelos.Constantes
@Modeltype Oticas.AccountingConfiguration

@Code
    Dim atrHTML As New Dictionary(Of String, Object) From {{"class", CssClasses.InputF3M}}

    'M A I N
    Html.F3M().Hidden("ID", Model.ID, atrHTML)
    Html.F3M().Hidden("EmExecucao", CInt(Model.AcaoFormulario))
    Html.F3M().Hidden("F3MMarker", Model.F3MMarker, atrHTML)
    Html.F3M().Hidden("IsOnCopyMode", Model.IsCopyMode)

    'C O N D I T I O N S
    Html.F3M().Hidden("ModuleCodeOnUpdate", Model.ModuleCode)
    'Html.F3M().Hidden("ModuleDescriptionOnUpdate", Model.ModuleDescription)
    Html.F3M().Hidden("ModuleDescriptionOnUpdate", Model.ModuleDescription)



    Html.F3M().Hidden("TypeCodeOnUpdate", Model.TypeCode)
    Html.F3M().Hidden("TypeDescriptionOnUpdate", Model.TypeDescription)
End Code
