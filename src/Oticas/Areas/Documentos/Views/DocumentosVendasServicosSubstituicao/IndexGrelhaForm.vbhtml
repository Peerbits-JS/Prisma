@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@ModelType F3M.Modelos.Grelhas.ClsMvcKendoGrid
@Code
    'set tipoeditor no campo data
    Model.Campos.Where(Function(w) w.Id = CamposGenericos.DataDocumento).FirstOrDefault.TipoEditor = Mvc.Componentes.F3MData
    'set visibility  to false in column ativo
    Model.Campos.Add(New ClsF3MCampo With {.Id = CamposGenericos.Ativo, .EVisivel = False})

    If Not Model.OrigemF4.IsEmpty Then
        Html.F3M().Grelha(Of Oticas.DocumentosVendasServicosSubstituicao)(Model).Render()
    Else
        Html.F3M().GrelhaFormulario(Of Oticas.DocumentosVendasServicosSubstituicao)(Model).Render()
    End If
End Code