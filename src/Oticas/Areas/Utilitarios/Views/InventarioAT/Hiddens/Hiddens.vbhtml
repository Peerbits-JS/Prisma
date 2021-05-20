@Imports F3M.Modelos.Constantes
@ModelType Oticas.InventarioAT
@Imports F3M.Modelos.Autenticacao

@Code
    Dim atrHTML As New Dictionary(Of String, Object) From {{"class", CssClasses.InputF3M}}

    'MAIN HIDDENS
    Html.F3M().Hidden("ID", Model.ID, atrHTML)
    Html.F3M().Hidden("EmExecucao", IIf(CInt(Model.AcaoFormulario) = 1 OrElse CInt(Model.AcaoFormulario) = 3, 3, CInt(Model.AcaoFormulario)))
End Code