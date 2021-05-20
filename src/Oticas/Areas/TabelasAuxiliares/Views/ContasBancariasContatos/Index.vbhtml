@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Code
    Dim funcJS As String = "ContasBancariasEnviaParametros"
    Dim bool As Boolean = (ViewBag.VistaParcial IsNot Nothing AndAlso ViewBag.VistaParcial)
    Dim listaCol = New List(Of ClsF3MCampo)

    If Not bool Then
        Layout = URLs.SharedLayoutTabelas
    End If

    @*@Scripts.Render("~/bundles/f3m/jsFormularioClientes")*@

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Ordem,
        .LarguraColuna = 200,
        .EVisivel = False})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.IDTipo,
        .TipoEditor = Mvc.Componentes.F3MLookup,
        .LarguraColuna = 300,
        .Controlador = "../TabelasAuxiliares/TiposContatos",
        .OpcaoMenuDescAbrev = Menus.TiposContatos })


    listaCol.Add(New ClsF3MCampo With {.Id = "Contato",
        .LarguraColuna = 300})

    listaCol.Add(New ClsF3MCampo With {.Id = "Telefone",
        .LarguraColuna = 200})

    listaCol.Add(New ClsF3MCampo With {.Id = "Telemovel",
        .LarguraColuna = 200})

    listaCol.Add(New ClsF3MCampo With {.Id = "Fax",
        .LarguraColuna = 200})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Email,
        .LarguraColuna = 300})

    listaCol.Add(New ClsF3MCampo With {.Id = "Mailing",
        .LarguraColuna = 100})

    listaCol.Add(New ClsF3MCampo With {.Id = "PagWeb",
        .LarguraColuna = 300})

    listaCol.Add(New ClsF3MCampo With {.Id = "PagRedeSocial",
        .LarguraColuna = 300})

    Dim gf As New ClsMvcKendoGrid With {
        .Tipo = New ContasBancariasContatos().GetType,
        .FuncaoJavascriptEnviaParams = funcJS,
        .Altura = 200,
        .TituloGrelhaDeLinhas = Traducao.EstruturaAplicacaoTermosBase.Contatos,
        .GravaNoCliente = True,
        .Campos = listaCol,
        .CamposOrdenar = New Dictionary(Of String, String) From {{CamposGenericos.Ordem, "asc"}}}

    gf.GrelhaHTML = Html.F3M().GrelhaLinhas(Of ContasBancariasContatos)(gf).ToHtmlString()

    If bool Then
    @<script>
        GrelhaLinhasInit('@gf.Id', { '@CamposGenericos.ID': '@CamposGenericos.IDContaBancaria' }, resources.Contato);
    </script>
End If

    @Html.Partial(gf.PartialViewInterna, gf)
End Code
