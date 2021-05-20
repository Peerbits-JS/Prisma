@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports Traducao.Traducao
@Scripts.Render("~/bundles/f3m/jsFormularioSetoresAtividade")
@Code
    Dim funcJS As String = Mvc.Grelha.Javascript.EnviaParams
    Dim bool As Boolean = (ViewBag.VistaParcial IsNot Nothing AndAlso ViewBag.VistaParcial)
    Dim listaCol = New List(Of ClsF3MCampo)

    If Not bool Then
        Layout = URLs.SharedLayoutTabelas
    End If
 
    listaCol.Add(New ClsF3MCampo With {.Id = "Ordem",
        .LarguraColuna = 200,
        .EVisivel = False})
    
    listaCol.Add(New ClsF3MCampo With {.Id = "IDIdioma",
        .TipoEditor = Mvc.Componentes.F3MLookup,
        .Controlador = "../TabelasAuxiliares/Idiomas",
        .OpcaoMenuDescAbrev = Menus.SetoresAtividade,
        .LarguraColuna = 300})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Descricao,
        .LarguraColuna = 300})
    
    Dim gf As New ClsMvcKendoGrid With {
        .Tipo = New SetoresAtividadeIdiomas().GetType,
        .FuncaoJavascriptEnviaParams = "SetoresAtividadeEnviaParametros",
        .FuncaoJavascriptGridEdit = "SetoresAtividadeEditaGrelha",
        .Altura = 350,
        .TituloGrelhaDeLinhas = Traducao.EstruturaAplicacaoTermosBase.Idiomas,
        .GravaNoCliente = True,
        .Campos = listaCol,
        .CamposOrdenar = New Dictionary(Of String, String) From {{CamposGenericos.Ordem, "asc"}}}

    gf.GrelhaHTML = Html.F3M().GrelhaLinhas(Of SetoresAtividadeIdiomas)(gf).ToHtmlString()

    If bool Then
        @<script>
            GrelhaLinhasInit('@gf.Id', { '@CamposGenericos.ID': '@CamposGenericos.IDSetorAtividade' }, resources.Idioma);
        </script>
    End If

    @Html.Partial(gf.PartialViewInterna, gf)
End Code
