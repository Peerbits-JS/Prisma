@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@ModelType F3M.Modelos.Grelhas.ClsMvcKendoGrid
@Code
    If Not Model.OrigemF4.IsEmpty Then
        Model.FuncaoJavascriptGridDataBound = "GrelhaParaGrelhaFormDataBound"

        Html.F3M().Grelha(Of MovimentosCaixa)(Model).Render()
    Else

        ' Verifica se existe coluna Descricao
        Dim campoDesc As ClsF3MCampo = Model.Campos.Where(Function(f) f.Id.Equals(CamposGenericos.Descricao)).FirstOrDefault

        If campoDesc IsNot Nothing Then
            campoDesc.LarguraColuna = 300
        End If

        ' Verifica se existe coluna Data Documento e atribui o tipo
        Dim campoDataDoc As ClsF3MCampo = Model.Campos.Where(Function(f) f.Id.Equals(CamposGenericos.DataDocumento)).FirstOrDefault

        If campoDataDoc IsNot Nothing Then
            campoDataDoc.TipoEditor = Mvc.Componentes.F3MData
        End If

        Model.CamposOrdenar = New Dictionary(Of String, String) From {{CamposGenericos.DataDocumento, "desc"}}
        Model.Campos.Add(New ClsF3MCampo With {.Id = CamposGenericos.Ativo, .EVisivel = False})

        Html.F3M().GrelhaFormulario(Of MovimentosCaixa)(Model).Render()
    End If
End Code