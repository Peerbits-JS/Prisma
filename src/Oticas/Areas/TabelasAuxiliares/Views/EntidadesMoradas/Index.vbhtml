@Imports F3M.Modelos.Constantes
@Imports Oticas.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas

@Code

    Dim funcJSMoradaChange = "ValidaMoradaChange"
    Dim funcJS As String = "EntidadesEnviaParametros"
    Dim bool As Boolean = (ViewBag.VistaParcial IsNot Nothing AndAlso ViewBag.VistaParcial)
    Dim listaCol = New List(Of ClsF3MCampo)

    If Not bool Then
        Layout = URLs.SharedLayoutTabelas
    End If

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
        .ControladorAccaoExtra = URLs.Areas.TabAux & Menus.CodigosPostais,
        .Controlador = .ControladorAccaoExtra & "/ListaComboCodigo",
        .CampoTexto = CamposGenericos.Codigo,
        .FuncaoJSChange = funcJSMoradaChange,
        .FuncaoJSEnviaParams = "EntidadesEnviaParametros",
        .OpcaoMenuDescAbrev = Menus.CodigosPostais,
        .LarguraColuna = 200})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.IDConcelho,
        .TipoEditor = Mvc.Componentes.F3MLookup,
        .Controlador = "../TabelasAuxiliares/Concelhos",
        .FuncaoJSChange = funcJSMoradaChange,
        .FuncaoJSEnviaParams = "EntidadesEnviaParametros",
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

    'listaCol.Add(New ClsF3MCampo With {.Id = "Ordem",
    '    .LarguraColuna = 150})

    Dim gf As New ClsMvcKendoGrid With {
        .Tipo = New EntidadesMoradas().GetType,
        .TituloGrelhaDeLinhas = Traducao.EstruturaAplicacaoTermosBase.Moradas,
        .FuncaoJavascriptEnviaParams = funcJS,
        .FuncaoJavascriptGridEdit = "EntidadesEditaGrelhaMoradas",
        .FuncaoJavascriptGridDataBound = "EntidadesDataBound",
        .GravaNoCliente = True,
        .Altura = 350,
        .Campos = listaCol,
        .CamposOrdenar = New Dictionary(Of String, String) From {{CamposGenericos.Ordem, "asc"}}}

    gf.GrelhaHTML = Html.F3M().GrelhaLinhas(Of EntidadesMoradas)(gf).ToHtmlString()

    If bool Then
    @<script>
        GrelhaLinhasInit('@gf.Id', { '@CamposGenericos.ID': '@CamposGenericos.IDEntidade' }, resources.Morada);
    </script>
End If

End Code

@Html.Partial(gf.PartialViewInterna, gf)