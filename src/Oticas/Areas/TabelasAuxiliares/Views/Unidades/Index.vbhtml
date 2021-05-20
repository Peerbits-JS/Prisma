@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Utilitarios
@Code
    Layout = URLs.SharedLayoutTabelas
    Dim listaCol = New List(Of ClsF3MCampo)
    Dim tabURL As String = "../Sistema/SistemaClassificacoesTiposArtigos"

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Codigo,
        .LarguraColuna = 150})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Descricao,
        .LarguraColuna = 300})

    listaCol.Add(New ClsF3MCampo With {.Id = "NumeroDeCasasDecimais",
       .ValorMinimo = 0,
       .ValorMaximo = 6,
       .LarguraColuna = 200})

    listaCol.Add(New ClsF3MCampo With {.Id = "PorDefeito",
        .LarguraColuna = 200})

    Dim gf As New ClsMvcKendoGrid With {
        .Tipo = New Unidades().GetType,
        .Campos = listaCol}

    Dim ControloOrigem As String = ClsUtilitarios.RetornaControloOrigem(Me.Context.Request.UrlReferrer.AbsolutePath)

    Select Case ControloOrigem.ToLower
        Case "documentosstock", "documentoscompras"
            gf.FuncaoJavascriptEnviaParams = "window.parent.$docTodos.ajax.EnviaParamsUnidade"
    End Select

    gf.GrelhaHTML = Html.F3M().Grelha(Of Unidades)(gf).ToHtmlString()
End Code

@Html.Partial(gf.PartialViewInterna, gf)