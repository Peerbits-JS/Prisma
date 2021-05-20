@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Utilitarios
@Imports F3M.Modelos.Constantes
@Code
    Layout = URLs.SharedLayoutTabelas
    Dim listaCol = New List(Of ClsF3MCampo)
    Dim tabURL As String = "../TabelasAuxiliares/" & MenusComuns.Familias

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Codigo,
        .LarguraColuna = 150})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Descricao,
        .LarguraColuna = 300})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.IDFamilia,
        .TipoEditor = Mvc.Componentes.F3MLookup,
        .Controlador = tabURL,
        .OpcaoMenuDescAbrev = MenusComuns.Familias,
        .LarguraColuna = 300})

    'listaCol.Add(New ClsF3MCampo With {.Id = "VariavelContabilidade",
    '    .TooltipDaColunaNaGrelha = "VarCont",
    '    .LarguraColuna = 200})

    Dim ControloOrigem As String = ClsUtilitarios.RetornaControloOrigem(Me.Context.Request.UrlReferrer.AbsolutePath)

    Dim gf As New ClsMvcKendoGrid With {
        .Tipo = New SubFamilias().GetType,
        .Campos = listaCol}

    Select Case ControloOrigem.ToLower
        Case "escaloes"
            @Scripts.Render("~/bundles/f3m/jsFormularioEscaloes")
            gf.FuncaoJavascriptEnviaParams = "EscaloesEnviaParametros"
            gf.FuncaoJavascriptGridEdit = "EscaloesSubFamiliasEdit"
            gf.FuncaoJavascriptGridDataBound = "EscaloesSubFamiliasDataBound"
        Case "artigos"
            @Scripts.Render("~/bundles/f3m/jsFormularioArtigos")
            gf.FuncaoJavascriptEnviaParams = "ArtigosEnviaParametros"
            gf.FuncaoJavascriptGridEdit = "ArtigosSubFamiliasEdit"
            gf.FuncaoJavascriptGridDataBound = "ArtigosSubFamiliasDataBound"
    End Select

    gf.GrelhaHTML = Html.F3M().Grelha(Of SubFamilias)(gf).ToHtmlString()

    @Html.Partial(gf.PartialViewInterna, gf)
End Code