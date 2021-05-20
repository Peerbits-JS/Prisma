@Imports F3M.Modelos.Constantes
@Code
    Dim JSFunctionF4 As String = String.Empty

            If ViewBag.OrigemAdicionaF4.Equals("catalogoslentes") Then
                JSFunctionF4 = "CatalogosLentesFuncEspAdicionaF4Tratamentos"
            ElseIf ViewBag.OrigemAdicionaF4.Equals("artigos") Then
                JSFunctionF4 = "ArtigosFuncEspAdicionaF4Tratamentos"
            End If

    @Html.Partial(ClsConstantes.RetornaURL(URLs.PartialF3MAdicionaF4, Me.Context), New With {
                                .JSBundle = String.Empty,
                                .Titulo = Traducao.EstruturaAplicacaoTermosBase.TratamentosLentes,
                                .TipoNome = "TratamentosLentes",
                                .Modelo = Model,
                                .JSFuncaoF4 = JSFunctionF4,
                                .TemHT = False})
End Code