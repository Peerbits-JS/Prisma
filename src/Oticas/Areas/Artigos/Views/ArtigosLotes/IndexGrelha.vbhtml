@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Utilitarios
@Code
    Dim funcJS As String = Mvc.Grelha.Javascript.EnviaParams
    Dim bool As Boolean = (ViewBag.VistaParcial IsNot Nothing AndAlso ViewBag.VistaParcial)
    Dim ControloOrigem As String = ClsUtilitarios.RetornaControloOrigem(Me.Context.Request.UrlReferrer.AbsolutePath)
    Dim listaCol = New List(Of ClsF3MCampo)

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Ordem,
        .LarguraColuna = 200,
        .EVisivel = False})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Codigo,
        .Label = Traducao.EstruturaArtigos.Lote,
        .LarguraColuna = 200})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Descricao,
        .LarguraColuna = 350})

    listaCol.Add(New ClsF3MCampo With {.Id = "DataFabrico",
        .TipoEditor = Mvc.Componentes.F3MData,
        .LarguraColuna = 200})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.DataValidade,
        .TipoEditor = Mvc.Componentes.F3MData,
        .LarguraColuna = 200})

    If Not bool Then
        Layout = URLs.SharedLayoutTabelas

        If ControloOrigem.Equals(GetType(F3M.DocumentosStock).Name.ToLower) Or ControloOrigem.Equals(GetType(F3M.DocumentosCompras).Name.ToLower) Then
            funcJS = "window.parent.DocumentosStockEnviaParamsLotesArmazens"

        ElseIf ControloOrigem.Equals(GetType(F3M.DocumentosVendas).Name.ToLower) Or ControloOrigem.Equals(GetType(Oticas.DocumentosVendasServicos).Name.ToLower) Then
            funcJS = "window.parent.DocumentosVendasEnviaParamsLotesArmazens"

        ElseIf ControloOrigem.Equals(GetType(Oticas.DocumentosStockContagem).Name.ToLower) Then
            funcJS = "window.parent.$docsstockscontagemgrelha.ajax.EnviaParamsLote"

        ElseIf ControloOrigem.Equals(GetType(Oticas.DocumentosStockContagemContar).Name.ToLower) Then
            funcJS = "window.parent.$docsstockscontagemcontar.ajax.LoteEnviaParams"
        End If
    End If

    Dim gf As New ClsMvcKendoGrid With {
.FuncaoJavascriptEnviaParams = funcJS,
.Campos = listaCol}

    gf.GrelhaHTML = Html.F3M().Grelha(Of ArtigosLotes)(gf).ToHtmlString()

    @Html.Partial(gf.PartialViewInterna, gf)
End Code