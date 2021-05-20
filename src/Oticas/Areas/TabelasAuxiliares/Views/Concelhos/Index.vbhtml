@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Utilitarios
@Imports Oticas.Modelos.Constantes
@Imports F3M.Modelos.Autenticacao
@Code
    Layout = URLs.SharedLayoutTabelas
    Dim listaCol = New List(Of ClsF3MCampo)

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Codigo,
        .LarguraColuna = 150})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Descricao,
        .LarguraColuna = 300})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.IDDistrito,
        .TipoEditor = Mvc.Componentes.F3MLookup,
        .Controlador = "../TabelasAuxiliares/" & Menus.Distritos,
        .OpcaoMenuDescAbrev = Menus.Distritos,
        .LarguraColuna = 300})

    Dim ControloOrigem As String = ClsUtilitarios.RetornaControloOrigem(Me.Context.Request.UrlReferrer.AbsolutePath)

    Dim gf As New ClsMvcKendoGrid With {
        .Campos = listaCol}

    If ControloOrigem.Equals("vendedores") Then
        @Scripts.Render("~/bundles/f3m/jsFormularioVendedores")
        gf.FuncaoJavascriptEnviaParams = "VendedoresEnviaParametros"
        gf.FuncaoJavascriptGridEdit = "ValidaMoradaEdit"
        gf.FuncaoJavascriptGridDataBound = "ValidaMoradaDataBound"

    ElseIf ControloOrigem.Equals("armazens") Then
        @Scripts.Render("~/bundles/f3m/jsTabelasAuxiliaresArmazens")
        gf.FuncaoJavascriptEnviaParams = "ArmazensEnviaParametros"
        gf.FuncaoJavascriptGridEdit = "ValidaMoradaEdit"
        gf.FuncaoJavascriptGridDataBound = "ValidaMoradaDataBound"

    ElseIf ControloOrigem.Equals("clientes") Then
        @Scripts.Render("~/bundles/f3m/jsFormularioClientes")
        gf.FuncaoJavascriptEnviaParams = "ClientesEnviaParametros"
        gf.FuncaoJavascriptGridEdit = "ValidaMoradaEdit"
        gf.FuncaoJavascriptGridDataBound = "ValidaMoradaDataBound"

    ElseIf ControloOrigem.Equals("fornecedores") Then
        @Scripts.Render("~/bundles/f3m/jsFormularioFornecedores")
        gf.FuncaoJavascriptEnviaParams = "FornecedoresEnviaParametros"
        gf.FuncaoJavascriptGridEdit = "ValidaMoradaEdit"
        gf.FuncaoJavascriptGridDataBound = "ValidaMoradaDataBound"

    ElseIf ControloOrigem.Equals("bancos") Then
        @Scripts.Render("~/bundles/f3m/jsTabelasAuxiliaresBancos")
        gf.FuncaoJavascriptEnviaParams = "BancosEnviaParametros"
        gf.FuncaoJavascriptGridEdit = "ValidaMoradaEdit"
        gf.FuncaoJavascriptGridDataBound = "ValidaMoradaDataBound"

    ElseIf ControloOrigem.Equals("entidades") Then
        @Scripts.Render("~/bundles/f3m/jsTabelasAuxiliaresEntidades")
        gf.FuncaoJavascriptEnviaParams = "EntidadesEnviaParametros"
        gf.FuncaoJavascriptGridEdit = "ValidaMoradaEdit"
        gf.FuncaoJavascriptGridDataBound = "ValidaMoradaDataBound"

    ElseIf ControloOrigem.Equals("contasbancarias") Then
        @Scripts.Render("~/bundles/f3m/jsTabelasAuxiliaresContasBancarias")
        gf.FuncaoJavascriptEnviaParams = "ContasBancariasEnviaParametros"
        gf.FuncaoJavascriptGridEdit = "ValidaMoradaEdit"
        gf.FuncaoJavascriptGridDataBound = "ValidaMoradaDataBound"

    ElseIf ControloOrigem.Equals("medicostecnicos") Then
        @Scripts.Render("~/bundles/f3m/jsTabelasAuxiliaresMedicosTecnicos")
        gf.FuncaoJavascriptEnviaParams = "MedicosTecnicosEnviaParametros"
        gf.FuncaoJavascriptGridEdit = "ValidaMoradaEdit"
        gf.FuncaoJavascriptGridDataBound = "ValidaMoradaDataBound"

    ElseIf ControloOrigem = "documentosstock" OrElse ControloOrigem = "documentoscompras" OrElse
        ControloOrigem = "documentosvendas" OrElse ControloOrigem = "documentospagamentoscompras" Then
        gf.FuncaoJavascriptEnviaParams = "window.parent.$documento.ajax.EnviaParamsGrelha"
    End If

    gf.GrelhaHTML = Html.F3M().Grelha(Of Concelhos)(gf).ToHtmlString()

    @Html.Partial(gf.PartialViewInterna, gf)
End Code