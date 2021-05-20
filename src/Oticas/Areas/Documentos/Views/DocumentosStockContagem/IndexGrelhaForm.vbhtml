@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@ModelType F3M.Modelos.Grelhas.ClsMvcKendoGrid
@Code
    If Not Model.OrigemF4.IsEmpty Then
        Model.FuncaoJavascriptGridDataBound = "GrelhaParaGrelhaFormDataBound"

        Html.F3M().Grelha(Of Oticas.DocumentosStockContagem)(Model).Render()
    Else

        Dim campoDataDoc As ClsF3MCampo = Model.Campos.Where(Function(f) f.Id.Equals(CamposGenericos.DataDocumento)).FirstOrDefault

        If campoDataDoc IsNot Nothing Then
            campoDataDoc.TipoEditor = Mvc.Componentes.F3MData
        End If

        With Model
            .AccaoCustomizavelAdicao = "AdicionaComprimidoBase64"
            .AccaoCustomizavelEdicao = "EditaComprimidoBase64"
            .Campos.Add(New ClsF3MCampo With {.Id = "Ativo", .EVisivel = False})
        End With

        Html.F3M().GrelhaFormulario(Of Oticas.DocumentosStockContagem)(Model).Render()
    End If
End Code