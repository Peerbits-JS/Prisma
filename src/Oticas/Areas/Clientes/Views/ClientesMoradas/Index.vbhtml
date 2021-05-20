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
    Dim OrdemMinMorada As Decimal = If(Model.Versao = 2, 2, 1)

    If Not bool Then
        Layout = URLs.SharedLayoutTabelas
    End If

    listaCol.Add(New ClsF3MCampo With {.Id = "OrdemMorada",
        .ValorMinimo = OrdemMinMorada,
        .LarguraColuna = 75})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Descricao,
.LarguraColuna = 200})

    'listaCol.Add(New ClsF3MCampo With {.Id = "Rota",
    '    .LarguraColuna = 200})

    listaCol.Add(New ClsF3MCampo With {.Id = "Morada",
.LarguraColuna = 350})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.IDCodigoPostal,
.TipoEditor = Mvc.Componentes.F3MLookup,
.ControladorAccaoExtra = URLs.Areas.TabAux & Menus.CodigosPostais,
.Controlador = .ControladorAccaoExtra & "/ListaComboCodigo",
.CampoTexto = CamposGenericos.Codigo,
.FuncaoJSChange = funcJSMoradaChange,
.FuncaoJSEnviaParams = "ClientesEnviaParametros",
.OpcaoMenuDescAbrev = Menus.CodigosPostais,
.LarguraColuna = 175})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.IDConcelho,
.TipoEditor = Mvc.Componentes.F3MLookup,
.Controlador = "../TabelasAuxiliares/Concelhos",
.FuncaoJSChange = funcJSMoradaChange,
.FuncaoJSEnviaParams = "ClientesEnviaParametros",
.OpcaoMenuDescAbrev = Menus.Concelhos,
.LarguraColuna = 175})

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
        .LarguraColuna = 175})

    '    listaCol.Add(New ClsF3MCampo With {.Id = "GPS",
    '.LarguraColuna = 200})

    Dim gf As New ClsMvcKendoGrid With {
.FuncaoJavascriptEnviaParams = "ClientesEnviaParametros",
.FuncaoJavascriptGridEdit = "ClientesEditaGrelhaMoradas",
.FuncaoJavascriptGridDataBound = "ClientesDataBound",
.Altura = 50,
.TituloGrelhaDeLinhas = Traducao.EstruturaClientes.Moradas,
.GravaNoCliente = True,
.Campos = listaCol,
.CamposOrdenar = New Dictionary(Of String, String) From {{CamposGenericos.Ordem, "asc"}}}

    gf.GrelhaHTML = Html.F3M().GrelhaLinhas(Of F3M.ClientesMoradas)(gf).ToHtmlString()

    If bool Then
        @<script>
            GrelhaLinhasInit('@gf.Id', { '@CamposGenericos.ID': '@CamposGenericos.IDCliente' }, resources.Morada);
        </script>
    End If

    @Html.Partial(gf.PartialViewInterna, gf)
End Code
