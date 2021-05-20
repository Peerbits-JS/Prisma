@Imports F3M.Modelos.Constantes
@Imports Oticas.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Code

    Dim funcJS As String = "EntidadesEnviaParametros"
    Dim bool As Boolean = (ViewBag.VistaParcial IsNot Nothing AndAlso ViewBag.VistaParcial)

    If Not bool Then
        Layout = URLs.SharedLayoutTabelas
    End If

    Dim listaCol = New List(Of ClsF3MCampo)
    
    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Ordem,
        .LarguraColuna = 200,
        .EVisivel = False})
    
    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.IDTipo,
        .TipoEditor = Mvc.Componentes.F3MLookup,
        .Controlador = "../TabelasAuxiliares/TiposContatos",
        .OpcaoMenuDescAbrev = Menus.TiposContatos,
        .LarguraColuna = 300})

    'listaCol.Add(New ClsF3MCampo With {.Id = "Descricao",
    '    .LarguraColuna = 300})

    listaCol.Add(New ClsF3MCampo With {.Id = "Contato",
        .LarguraColuna = 300})

    listaCol.Add(New ClsF3MCampo With {.Id = "Telefone",
        .LarguraColuna = 200})

    listaCol.Add(New ClsF3MCampo With {.Id = "Telemovel",
        .LarguraColuna = 200})

    listaCol.Add(New ClsF3MCampo With {.Id = "Fax",
        .LarguraColuna = 200})

    listaCol.Add(New ClsF3MCampo With {.Id = "Email",
        .LarguraColuna = 300})

    listaCol.Add(New ClsF3MCampo With {.Id = "Mailing",
        .LarguraColuna = 100})

    listaCol.Add(New ClsF3MCampo With {.Id = "PagWeb",
        .LarguraColuna = 300})

    listaCol.Add(New ClsF3MCampo With {.Id = "PagRedeSocial",
        .LarguraColuna = 300})

    Dim gf As New ClsMvcKendoGrid With {
        .Tipo = New EntidadesContatos().GetType,
        .TituloGrelhaDeLinhas = Traducao.EstruturaAplicacaoTermosBase.Contatos,
        .FuncaoJavascriptEnviaParams = funcJS,
        .GravaNoCliente = True,
        .Altura = 200,
        .Campos = listaCol,
        .CamposOrdenar = New Dictionary(Of String, String) From {{CamposGenericos.Ordem, "asc"}}}

    gf.GrelhaHTML = Html.F3M().GrelhaLinhas(Of EntidadesContatos)(gf).ToHtmlString()

    If bool Then
    @<script>
        GrelhaLinhasInit('@gf.Id', { '@CamposGenericos.ID': '@CamposGenericos.IDEntidade' }, resources.Contato);
    </script>
End If

End Code

@Html.Partial(gf.PartialViewInterna, gf)