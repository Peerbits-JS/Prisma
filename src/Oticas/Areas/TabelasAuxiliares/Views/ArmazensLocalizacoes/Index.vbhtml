@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Code
    Dim funcJS As String = Mvc.Grelha.Javascript.EnviaParams
    Dim bool As Boolean = (ViewBag.VistaParcial IsNot Nothing AndAlso ViewBag.VistaParcial)

    Dim listaCol = New List(Of ClsF3MCampo)

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Codigo,
        .LarguraColuna = 200})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Descricao,
        .LarguraColuna = 350})

    listaCol.Add(New ClsF3MCampo With {.Id = "CodigoBarras",
        .LarguraColuna = 200})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Ordem,
        .EEscondido = True})

    If bool Then
        funcJS = "ArmazensEnviaParametros"
    Else
        Layout = URLs.SharedLayoutTabelas
    End If

    Dim gf As New ClsMvcKendoGrid With {
        .TituloGrelhaDeLinhas = Traducao.EstruturaAplicacaoTermosBase.Localizacoes,
        .FuncaoJavascriptEnviaParams = funcJS,
        .GravaNoCliente = True,
        .Campos = listaCol}

    gf.GrelhaHTML = Html.F3M().GrelhaLinhas(Of ArmazensLocalizacoes)(gf).ToHtmlString()

    If bool Then
    @<script>
        GrelhaLinhasInit('@gf.Id', { '@CamposGenericos.ID': '@CamposGenericos.IDArmazem' }, resources.Localizacao);
    </script>
End If
End Code

@Html.Partial(gf.PartialViewInterna, gf)