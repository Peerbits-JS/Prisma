@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.Utilitarios
@Code
    Dim f3mC As New ClsF3MCampo

    If Not ClsTexto.ENuloOuVazio(ViewData("Id")) Then
        For Each prop In f3mC.GetType.GetProperties
            prop.SetValue(f3mC, ViewData(prop.Name))
        Next
        ' TODO: VERIFICAR MANEIRA DE PASSAR ACAO ADICIONAR/EDITAR
        f3mC.AcaoFormulario = AcoesFormulario.Adicionar
        Html.F3M().GrelhaTipoEditor(f3mC)
    End If
End Code