@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports Producao.Modelos.Constantes
@Code
    Dim funcJS As String = Mvc.Grelha.Javascript.EnviaParams
    Dim bool As Boolean = (ViewBag.VistaParcial IsNot Nothing AndAlso ViewBag.VistaParcial)
    Const tabURL As String = URLs.Areas.TabAux & Menus.Armazens
    Dim listaCol As New List(Of ClsF3MCampo)

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Ordem,
        .LarguraColuna = 200,
        .EVisivel = False})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.IDArmazem,
        .TipoEditor = Mvc.Componentes.F3MLookup,
        .Controlador = tabURL,
        .ControladorAccaoExtra = .Controlador & Operadores.Slash & URLs.ViewIndexGrelha,
        .FuncaoJSChange = "ArtigosArmazensLocalizacoesIDArmazemChange",
        .FuncaoJSEnviaParams = "ArtigosArmazensLocalizacoesIDArmazemEnviaParams",
        .OpcaoMenuDescAbrev = Menus.Armazens,
        .LarguraColuna = 300})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.IDArmazem & "Localizacao",
        .TipoEditor = Mvc.Componentes.F3MLookup,
        .Cascata = CamposGenericos.IDArmazem,
        .Controlador = URLs.Areas.TabAux & F3M.Modelos.Constantes.Menus.ArmazensLocalizacoes & "/ListaComboCodigo",
        .ControladorAccaoExtra = URLs.Areas.TabAux & MenusComuns.Localizacoes,
        .CampoTexto = CamposGenericos.Codigo,
        .FuncaoJSEnviaParams = "ArtigosArmazensLocalizacoesIDArmazemLocalizacaoEnviaParams",
        .OpcaoMenuDescAbrev = MenusComuns.Localizacoes,
        .LarguraColuna = 300})

    listaCol.Add(New ClsF3MCampo With {.Id = "PorDefeito",
        .LarguraColuna = 150})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Ativo,
        .EVisivel = False})

    If bool Then
        funcJS = "ArtigosEnviaParametros"
    Else
        Layout = URLs.SharedLayoutTabelas
    End If

    Dim gf As New ClsMvcKendoGrid With {
        .FuncaoJavascriptEnviaParams = funcJS,
        .FuncaoJavascriptGridEdit = "ArtigosArmazensLocalizacoesEdit",
        .FuncaoJavascriptGridDataBinding = "ArtigosArmazensLocalizacoesDataBound",
        .TituloGrelhaDeLinhas = Traducao.EstruturaArtigos.Armazens,
        .GravaNoCliente = True,
        .Campos = listaCol}

    gf.GrelhaHTML = Html.F3M().GrelhaLinhas(Of ArtigosArmazensLocalizacoes)(gf).ToHtmlString()

    If bool Then
        @<script>
            GrelhaLinhasInit('@gf.Id', { '@CamposGenericos.ID': '@CamposGenericos.IDArtigo' });
        </script>
    End If

    @Html.Partial(gf.PartialViewInterna, gf)
End Code