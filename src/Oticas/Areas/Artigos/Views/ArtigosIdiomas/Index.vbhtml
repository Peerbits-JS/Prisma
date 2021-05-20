@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Code
    Dim funcJS As String = Mvc.Grelha.Javascript.EnviaParams
    Dim bool As Boolean = (ViewBag.VistaParcial IsNot Nothing AndAlso ViewBag.VistaParcial)
    Dim listaCol = New List(Of ClsF3MCampo)
    
    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Ordem,
        .LarguraColuna = 200,
        .EVisivel = False})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.IDIdioma,
        .TipoEditor = Mvc.Componentes.F3MLookup,
        .Controlador = "../TabelasAuxiliares/" & Menus.Idiomas,
        .OpcaoMenuDescAbrev = Menus.Idiomas,
        .LarguraColuna = 300})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Descricao,
        .LarguraColuna = 300})
    
    listaCol.Add(New ClsF3MCampo With {.Id = "DescricaoAbreviada",
        .LarguraColuna = 200})
    
    If bool Then
        funcJS = "ArtigosEnviaParametros"
    Else
        Layout = URLs.SharedLayoutTabelas
    End If

    Dim gf As New ClsMvcKendoGrid With {
        .FuncaoJavascriptEnviaParams = funcJS,
        .GravaNoCliente = True,
        .Campos = listaCol}
    
    gf.GrelhaHTML = Html.F3M().GrelhaLinhas(Of Oticas.ArtigosIdiomas)(gf).ToHtmlString()

    If bool Then
        @<script>
            GrelhaLinhasInit('@gf.Id', { '@CamposGenericos.ID': '@CamposGenericos.IDArtigo' }, resources.Idioma);
        </script>
    End If

    @Html.Partial(gf.PartialViewInterna, gf)
End Code