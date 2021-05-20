@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Grelhas

@Code
    Dim funcJS As String = Mvc.Grelha.Javascript.EnviaParams
    'Dim funcJSedit As String = Mvc.Grelha.Javascript.GriEdit
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
        .LarguraColuna = 300,
        .OpcaoMenuDescAbrev = Menus.TiposContatos})

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
    
    'listaCol.Add(New ClsF3MCampo With {
    '    .Id = CamposGenericos.Ativo,
    '    .EVisivel = False})

    Dim gf As New ClsMvcKendoGrid With {
        .Tipo = New MedicosTecnicosContatos().GetType,
        .TituloGrelhaDeLinhas = Traducao.EstruturaAplicacaoTermosBase.Contatos,
        .FuncaoJavascriptEnviaParams = "MedicosTecnicosEnviaParametros",
        .GravaNoCliente = True,
        .Altura = 200,
        .Campos = listaCol,
        .CamposOrdenar = New Dictionary(Of String, String) From {{CamposGenericos.Ordem, "asc"}}}
    '        .FuncaoJavascriptGridEdit = "MedicosTecnicosEditaGrelha",
    
    
    gf.GrelhaHTML = Html.F3M().GrelhaLinhas(Of MedicosTecnicosContatos)(gf).ToHtmlString()

    If bool Then
    @<script>
        GrelhaLinhasInit('@gf.Id', { '@CamposGenericos.ID': "IDMedicoTecnico" }, resources.Contato);
    </script>
End If

End Code

@Html.Partial(gf.PartialViewInterna, gf)