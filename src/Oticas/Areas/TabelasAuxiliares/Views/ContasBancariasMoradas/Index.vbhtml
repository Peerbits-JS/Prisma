@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Code
    Dim funcJSMoradaChange = "ValidaMoradaChange"
    Dim funcJS As String = Mvc.Grelha.Javascript.EnviaParams
    funcJS = "ContasBancariasEnviaParametros"
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
      .Controlador = "../TabelasAuxiliares/CodigosPostais",
      .FuncaoJSChange = funcJSMoradaChange,
      .FuncaoJSEnviaParams = funcJS,
      .OpcaoMenuDescAbrev = Menus.CodigosPostais,
      .LarguraColuna = 200})
    
    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.IDConcelho,
       .TipoEditor = Mvc.Componentes.F3MLookup,
       .Controlador = "../TabelasAuxiliares/Concelhos",
       .FuncaoJSChange = funcJSMoradaChange,
       .FuncaoJSEnviaParams = funcJS,
       .OpcaoMenuDescAbrev = Menus.Concelhos,
       .LarguraColuna = 200})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.IDDistrito,
       .TipoEditor = Mvc.Componentes.F3MLookup,
       .Controlador = "../TabelasAuxiliares/Distritos",
       .FuncaoJSChange = funcJSMoradaChange,
       .OpcaoMenuDescAbrev = Menus.Distritos,
       .LarguraColuna = 200})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.IDPais,
       .TipoEditor = Mvc.Componentes.F3MLookup,
       .Controlador = "../TabelasAuxiliares/Paises",
       .OpcaoMenuDescAbrev = Menus.Paises,
       .LarguraColuna = 200})

    listaCol.Add(New ClsF3MCampo With {.Id = "GPS",
        .LarguraColuna = 200})

    Dim gf As New ClsMvcKendoGrid With {
        .Tipo = New ContasBancariasMoradas().GetType,
        .FuncaoJavascriptEnviaParams = funcJS,
        .Altura = 200,
        .TituloGrelhaDeLinhas = Traducao.EstruturaClientes.Moradas,
        .GravaNoCliente = True,
        .Campos = listaCol,
        .CamposOrdenar = New Dictionary(Of String, String) From {{CamposGenericos.Ordem, "asc"}}}
     
    gf.GrelhaHTML = Html.F3M().GrelhaLinhas(Of ContasBancariasMoradas)(gf).ToHtmlString()

    If bool Then
    @<script>
        GrelhaLinhasInit('@gf.Id', { '@CamposGenericos.ID': '@CamposGenericos.IDContaBancaria' }, resources.Morada);
    </script>
End If

    @Html.Partial(gf.PartialViewInterna, gf)
End Code
