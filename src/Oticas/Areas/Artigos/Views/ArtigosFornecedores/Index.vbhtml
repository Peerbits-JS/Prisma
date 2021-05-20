@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas

<div role="tabpanel" class="tab-pane fade" id="tabFornecedores">
    @Code
        Dim funcJS As String = Mvc.Grelha.Javascript.EnviaParams
        Dim bool As Boolean = (ViewBag.VistaParcial IsNot Nothing AndAlso ViewBag.VistaParcial)
        Dim listaCol = New List(Of ClsF3MCampo)

        If bool Then
            funcJS = "ArtigosEnviaParametros"
        Else
            Layout = URLs.SharedLayoutTabelas
        End If

        listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Ordem,
            .LarguraColuna = 200,
            .EVisivel = False})

        listaCol.Add(New ClsF3MCampo With {.Id = "IDFornecedor",
            .TipoEditor = Mvc.Componentes.F3MLookup,
            .Controlador = "../Fornecedores/Fornecedores",
            .ControladorAccaoExtra = .Controlador & "/" & URLs.ViewIndexGrelha,
            .CampoTexto = CamposGenericos.Nome,
            .LarguraColuna = 300})

        listaCol.Add(New ClsF3MCampo With {.Id = "Referencia",
            .LarguraColuna = 200})

        listaCol.Add(New ClsF3MCampo With {.Id = "CodigoBarras",
            .LarguraColuna = 200})

        Dim gf As New ClsMvcKendoGrid With {
            .FuncaoJavascriptEnviaParams = funcJS,
            .GravaNoCliente = True,
            .Altura = 200,
            .Campos = listaCol}

        gf.GrelhaHTML = Html.F3M().GrelhaLinhas(Of Oticas.ArtigosFornecedores)(gf).ToHtmlString()

        If bool Then
        @<script>
            GrelhaLinhasInit('@gf.Id', { '@CamposGenericos.ID': '@CamposGenericos.IDArtigo' }, resources.Fornecedor);
        </script>
        End If

        @Html.Partial(gf.PartialViewInterna, gf)
    End Code
</div>