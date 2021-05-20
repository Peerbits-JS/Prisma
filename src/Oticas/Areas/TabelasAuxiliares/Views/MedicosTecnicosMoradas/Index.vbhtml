@Imports F3M.Modelos.Constantes
@Imports Oticas.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas



@Code

    Dim funcJSMoradaChange = "ValidaMoradaChange"
    Dim funcJS As String = "MedicosTecnicosEnviaParametros"
    Dim bool As Boolean = (ViewBag.VistaParcial IsNot Nothing AndAlso ViewBag.VistaParcial)

    If Not bool Then
        Layout = URLs.SharedLayoutTabelas
    End If

    Dim listaCol = New List(Of ClsF3MCampo)

    Dim URLCodigosPostais As String = "../TabelasAuxiliares/CodigosPostais"
    Dim URLConcelhos As String = "../TabelasAuxiliares/Concelhos"
    Dim URLDistritos As String = "../TabelasAuxiliares/Distritos"
    Dim URLPaises As String = "../TabelasAuxiliares/Paises"

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
        .FuncaoJSEnviaParams = funcJS,
        .OpcaoMenuDescAbrev = Menus.CodigosPostais,
        .LarguraColuna = 200})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.IDConcelho,
        .TipoEditor = Mvc.Componentes.F3MLookup,
        .Controlador = URLConcelhos,
        .FuncaoJSChange = funcJSMoradaChange,
        .FuncaoJSEnviaParams = funcJS,
        .OpcaoMenuDescAbrev = Menus.Concelhos,
        .LarguraColuna = 200})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.IDDistrito,
        .TipoEditor = Mvc.Componentes.F3MLookup,
        .Controlador = URLDistritos,
        .FuncaoJSChange = funcJSMoradaChange,
        .FuncaoJSEnviaParams = funcJS,
        .OpcaoMenuDescAbrev = Menus.Distritos,
        .LarguraColuna = 200})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.IDPais,
        .TipoEditor = Mvc.Componentes.F3MLookup,
        .Controlador = URLPaises,
        .OpcaoMenuDescAbrev = Menus.Paises,
        .LarguraColuna = 200})

    listaCol.Add(New ClsF3MCampo With {.Id = "GPS",
        .LarguraColuna = 200})

    listaCol.Add(New ClsF3MCampo With {
        .Id = CamposGenericos.Ativo,
        .EVisivel = False})

    Dim gf As New ClsMvcKendoGrid With {
        .Tipo = New MedicosTecnicosMoradas().GetType,
        .TituloGrelhaDeLinhas = Traducao.EstruturaAplicacaoTermosBase.Moradas,
        .FuncaoJavascriptEnviaParams = funcJS,
        .FuncaoJavascriptGridEdit = "MedicosTecnicosEditaGrelhaMoradas",
        .FuncaoJavascriptGridDataBound = "MedicosTecnicosDataBound",
        .GravaNoCliente = True,
        .Altura = 350,
        .Campos = listaCol,
        .CamposOrdenar = New Dictionary(Of String, String) From {{CamposGenericos.Ordem, "asc"}}}

    gf.GrelhaHTML = Html.F3M().GrelhaLinhas(Of MedicosTecnicosMoradas)(gf).ToHtmlString()

    If bool Then
    @<script>
        GrelhaLinhasInit('@gf.Id', { '@CamposGenericos.ID': '@CamposGenericos.IDMedicoTecnico' }, resources.Morada);
    </script>
End If

End Code

@Html.Partial(gf.PartialViewInterna, gf)