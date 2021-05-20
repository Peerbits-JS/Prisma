@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports Traducao.Traducao
@Code
    Dim funcJSMoradaChange = "ValidaMoradaChange"
    Dim funcJS As String = Mvc.Grelha.Javascript.EnviaParams
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
        .LarguraColuna = 400})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.IDCodigoPostal,
       .TipoEditor = Mvc.Componentes.F3MLookup,
        .ControladorAccaoExtra = URLs.Areas.TabAux & Menus.CodigosPostais,
        .Controlador = .ControladorAccaoExtra & "/ListaComboCodigo",
        .CampoTexto = CamposGenericos.Codigo,
       .FuncaoJSChange = funcJSMoradaChange,
       .FuncaoJSEnviaParams = "FornecedoresEnviaParametros",
       .OpcaoMenuDescAbrev = F3M.Modelos.Constantes.Menus.CodigosPostais,
       .LarguraColuna = 200})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.IDConcelho,
       .TipoEditor = Mvc.Componentes.F3MLookup,
       .Controlador = "../TabelasAuxiliares/Concelhos",
       .FuncaoJSChange = funcJSMoradaChange,
       .FuncaoJSEnviaParams = "FornecedoresEnviaParametros",
       .OpcaoMenuDescAbrev = F3M.Modelos.Constantes.Menus.Concelhos,
       .LarguraColuna = 200})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.IDDistrito,
       .TipoEditor = Mvc.Componentes.F3MLookup,
       .Controlador = "../TabelasAuxiliares/Distritos",
       .FuncaoJSChange = funcJSMoradaChange,
       .OpcaoMenuDescAbrev = F3M.Modelos.Constantes.Menus.Distritos,
       .LarguraColuna = 200})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.IDPais,
       .TipoEditor = Mvc.Componentes.F3MLookup,
       .Controlador = "../TabelasAuxiliares/Paises",
       .OpcaoMenuDescAbrev = F3M.Modelos.Constantes.Menus.Paises,
       .LarguraColuna = 200})

    listaCol.Add(New ClsF3MCampo With {.Id = "GPS",
       .LarguraColuna = 200})

    Dim gf As New ClsMvcKendoGrid With {
        .FuncaoJavascriptEnviaParams = "FornecedoresEnviaParametros",
        .FuncaoJavascriptGridEdit = "FornecedoresEditaGrelhaMoradas",
        .FuncaoJavascriptGridDataBound = "FornecedoresDataBound",
        .Altura = 150,
        .TituloGrelhaDeLinhas = Traducao.EstruturaAplicacaoTermosBase.Moradas,
        .GravaNoCliente = True,
        .Campos = listaCol,
        .CamposOrdenar = New Dictionary(Of String, String) From {{CamposGenericos.Ordem, "asc"}}}

    gf.GrelhaHTML = Html.F3M().GrelhaLinhas(Of Oticas.FornecedoresMoradas)(gf).ToHtmlString()

    If bool Then
        @<script>
            GrelhaLinhasInit('@gf.Id', { '@CamposGenericos.ID': '@CamposGenericos.IDFornecedor' }, resources.Morada);
        </script>
    End If

    @Html.Partial(gf.PartialViewInterna, gf)
End Code
