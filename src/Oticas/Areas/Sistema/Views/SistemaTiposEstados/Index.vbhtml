@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Utilitarios
@Code
    Layout = URLs.SharedLayoutTabelas
    Dim listaCol = New List(Of ClsF3MCampo)

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Codigo,
        .LarguraColuna = 150})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Descricao,
        .LarguraColuna = 300})

    Dim gf As New ClsMvcKendoGrid With {
        .Campos = listaCol}

    Dim ControloOrigem As String = ClsUtilitarios.RetornaControloOrigem(Me.Context.Request.UrlReferrer.AbsolutePath)
    
    If ControloOrigem.Equals("estados") Then
        @Scripts.Render("~/bundles/f3m/jsFormularioEstados")
        gf.FuncaoJavascriptEnviaParams = "EstadosEnviaParametros"
    End If
    
    gf.GrelhaHTML = Html.F3M().Grelha(Of SistemaTiposEstados)(gf).ToHtmlString()

    @Html.Partial(gf.PartialViewInterna, gf)
End Code