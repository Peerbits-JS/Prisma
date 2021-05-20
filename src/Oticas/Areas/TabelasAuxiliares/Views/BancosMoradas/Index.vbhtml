@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Scripts.Render("~/bundles/f3m/jsTabelasAuxiliaresBancos")

@Code
    Dim funcJSMoradaChange = "ValidaMoradaChange"
    Dim funcJS As String = "BancosEnviaParametros"
    Dim bool As Boolean = (ViewBag.VistaParcial IsNot Nothing AndAlso ViewBag.VistaParcial)
    Dim listaCol = New List(Of ClsF3MCampo)

    If Not bool Then
        Layout = URLs.SharedLayoutTabelas
    End If

    @*@Scripts.Render("~/bundles/f3m/jsFormularioClientes")*@


    listaCol.Add(New ClsF3MCampo With {.Id = "OrdemMorada",
        .LarguraColuna = 80})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Descricao,
        .LarguraColuna = 300})

    listaCol.Add(New ClsF3MCampo With {.Id = "Rota",
        .LarguraColuna = 200})

    listaCol.Add(New ClsF3MCampo With {.Id = "Morada",
    .LarguraColuna = 300})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.IDCodigoPostal,
        .TipoEditor = Mvc.Componentes.F3MLookup,
        .Controlador = "../TabelasAuxiliares/" & Menus.CodigosPostais,
        .FuncaoJSChange = funcJSMoradaChange,
        .FuncaoJSEnviaParams = funcJS,
        .OpcaoMenuDescAbrev = Menus.CodigosPostais,
        .LarguraColuna = 200})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.IDConcelho,
        .TipoEditor = Mvc.Componentes.F3MLookup,
        .Controlador = "../TabelasAuxiliares/" & Menus.Concelhos,
        .FuncaoJSChange = funcJSMoradaChange,
        .FuncaoJSEnviaParams = funcJS,
        .OpcaoMenuDescAbrev = Menus.Concelhos,
        .LarguraColuna = 200})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.IDDistrito,
        .TipoEditor = Mvc.Componentes.F3MLookup,
        .Controlador = "../TabelasAuxiliares/" & Menus.Distritos,
        .FuncaoJSChange = funcJSMoradaChange,
        .OpcaoMenuDescAbrev = Menus.Distritos,
        .LarguraColuna = 200})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.IDPais,
        .TipoEditor = Mvc.Componentes.F3MLookup,
        .Controlador = "../TabelasAuxiliares/" & Menus.Paises,
        .OpcaoMenuDescAbrev = Menus.Paises,
        .LarguraColuna = 200})

    listaCol.Add(New ClsF3MCampo With {.Id = "GPS",
        .LarguraColuna = 200})

    Dim gf As New ClsMvcKendoGrid With {
        .FuncaoJavascriptEnviaParams = funcJS,
        .FuncaoJavascriptGridEdit = "BancosEditaGrelhaMoradas",
        .Altura = 350,
        .TituloGrelhaDeLinhas = Traducao.EstruturaAplicacaoTermosBase.Moradas,
        .GravaNoCliente = True,
        .Campos = listaCol,
        .CamposOrdenar = New Dictionary(Of String, String) From {{CamposGenericos.Ordem, "asc"}}}

    gf.GrelhaHTML = Html.F3M().GrelhaLinhas(Of F3M.BancosMoradas)(gf).ToHtmlString()

    If bool Then
        @<script>
            GrelhaLinhasInit('@gf.Id', { '@CamposGenericos.ID': '@CamposGenericos.IDBanco' }, resources.Morada);
        </script>
    End If

    @Html.Partial(gf.PartialViewInterna, gf)
End Code