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

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Codigo,
        .LarguraColuna = 200})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Descricao,
        .LarguraColuna = 350})

    listaCol.Add(New ClsF3MCampo With {.Id = "DataFabrico",
        .TipoEditor = Mvc.Componentes.F3MData,
        .LarguraColuna = 200})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.DataValidade,
        .TipoEditor = Mvc.Componentes.F3MData,
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

    gf.GrelhaHTML = Html.F3M().GrelhaLinhas(Of Oticas.ArtigosLotes)(gf).ToHtmlString()

    If bool Then
        @<script>
            GrelhaLinhasInit('@gf.Id', { '@CamposGenericos.ID': '@CamposGenericos.IDArtigo' });
        </script>
    End If

    @Html.Partial(gf.PartialViewInterna, gf)
End Code