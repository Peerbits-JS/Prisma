@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Constantes
@Code
    Dim funcJSEP As String = "ArtigosComponentesDimensoesEnviaParametros"
    Dim funcJSEPA As String = "ArtigosComponentesEnviaParametros"
    Dim bool As Boolean = (ViewBag.VistaParcial IsNot Nothing AndAlso ViewBag.VistaParcial)
    Dim listaCol = New List(Of ClsF3MCampo)
    Dim tabURL As String = "../TabelasAuxiliares/" & MenusComuns.DimensoesLinhas

    listaCol.Add(New ClsF3MCampo With {.Id = "IDArtigoDimensaoLinha1",
        .TipoEditor = Mvc.Componentes.F3MLookup,
        .Controlador = tabURL,
        .ControladorAccaoExtra = tabURL & "/" & URLs.ViewIndexGrelha,
        .FuncaoJSEnviaParams = funcJSEPA,
        .OpcaoMenuDescAbrev = MenusComuns.DimensoesLinhas,
        .LarguraColuna = 150})

    listaCol.Add(New ClsF3MCampo With {.Id = "IDArtigoDimensaoLinha2",
        .TipoEditor = Mvc.Componentes.F3MLookup,
        .Controlador = tabURL,
        .ControladorAccaoExtra = tabURL & "/" & URLs.ViewIndexGrelha,
        .FuncaoJSEnviaParams = funcJSEPA,
        .OpcaoMenuDescAbrev = MenusComuns.DimensoesLinhas,
        .LarguraColuna = 150})

    listaCol.Add(New ClsF3MCampo With {.Id = "IDArtigoComponente",
        .TipoEditor = Mvc.Componentes.F3MLookup,
        .Controlador = "../" & Menus.Artigos & "/" & Menus.Artigos,
        .ControladorAccaoExtra = .Controlador & "/" & URLs.ViewIndexGrelha,
        .FuncaoJSChange = "ArtigosComponentesChange",
        .OpcaoMenuDescAbrev = Menus.Artigos,
        .LarguraColuna = 150})

    listaCol.Add(New ClsF3MCampo With {.Id = "IDArtigoDimensaoLinha1Componente",
        .TipoEditor = Mvc.Componentes.F3MLookup,
        .Controlador = tabURL,
        .ControladorAccaoExtra = tabURL & "/" & URLs.ViewIndexGrelha,
        .FuncaoJSEnviaParams = funcJSEPA,
        .OpcaoMenuDescAbrev = MenusComuns.DimensoesLinhas,
        .LarguraColuna = 150})

    listaCol.Add(New ClsF3MCampo With {.Id = "IDArtigoDimensaoLinha2Componente",
        .TipoEditor = Mvc.Componentes.F3MLookup,
        .Controlador = tabURL,
        .ControladorAccaoExtra = tabURL & "/" & URLs.ViewIndexGrelha,
        .FuncaoJSEnviaParams = funcJSEPA,
        .OpcaoMenuDescAbrev = MenusComuns.DimensoesLinhas,
        .LarguraColuna = 150})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Quantidade,
        .ValorMinimo = 0,
        .LarguraColuna = 100})

    listaCol.Add(New ClsF3MCampo With {.Id = "UltimoPrecoCusto",
        .TipoEditor = Mvc.Componentes.F3MNumero,
        .CasasDecimais = ClsF3MSessao.RetornaParametros.MoedaReferencia.CasasDecimaisPrecosUnitarios,
        .EEditavel = False,
        .LarguraColuna = 100})

    listaCol.Add(New ClsF3MCampo With {.Id = "PrecoCustoMedio",
        .TipoEditor = Mvc.Componentes.F3MNumero,
        .CasasDecimais = ClsF3MSessao.RetornaParametros.MoedaReferencia.CasasDecimaisPrecosUnitarios,
        .EEditavel = False,
        .LarguraColuna = 100})

    listaCol.Add(New ClsF3MCampo With {.Id = "PrecoCustoPadrao",
        .TipoEditor = Mvc.Componentes.F3MNumero,
        .CasasDecimais = ClsF3MSessao.RetornaParametros.MoedaReferencia.CasasDecimaisPrecosUnitarios,
        .EEditavel = False,
        .LarguraColuna = 100})

    If Not bool Then
        Layout = URLs.SharedLayoutFuncionalidades
    End If

    Dim gf As New ClsMvcKendoGrid With {
        .FuncaoJavascriptGridDataBound = "ArtigosComponentesDataBound",
        .FuncaoJavascriptEnviaParams = "ArtigosComponentesEnviaParametros",
        .FuncaoJavascriptGridEdit = "ArtigosComponentesEditaGrelha",
        .Altura = 200,
        .Campos = listaCol}

    gf.GrelhaHTML = Html.F3M().GrelhaLinhas(Of Oticas.ArtigosComponentes)(gf).ToHtmlString()
    @<div class="f3m-window">
        @Html.Partial(gf.PartialViewInterna, gf)
    </div>
End Code