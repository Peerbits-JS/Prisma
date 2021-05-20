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

    listaCol.Add(New ClsF3MCampo With {.Id = "IDLoja",
        .TipoEditor = Mvc.Componentes.F3MDropDownList,
        .Controlador = "./../../F3M/Administracao/Lojas",
        .OpcaoMenuDescAbrev = Menus.Lojas,
        .LarguraColuna = 150})

    listaCol.Add(New ClsF3MCampo With {.Id = "NumAssociado",
        .LarguraColuna = 300})

    listaCol.Add(New ClsF3MCampo With {.Id = "ServicosAdm",
        .LarguraColuna = 300})

    listaCol.Add(New ClsF3MCampo With {.Id = "TaxaIva",
        .LarguraColuna = 300})

    listaCol.Add(New ClsF3MCampo With {.Id = "Saldo",
        .LarguraColuna = 300})

    Dim gf As New ClsMvcKendoGrid With {
        .Tipo = New EntidadesLojas().GetType,
        .FuncaoJavascriptEnviaParams = funcJS,
        .TituloGrelhaDeLinhas = Traducao.EstruturaAplicacaoTermosBase.Lojas,
        .Altura = 350,
        .GravaNoCliente = True,
        .Campos = listaCol}

    gf.GrelhaHTML = Html.F3M().GrelhaLinhas(Of EntidadesLojas)(gf).ToHtmlString()

    If bool Then
    @<script>
        GrelhaLinhasInit('@gf.Id', { '@CamposGenericos.ID': '@CamposGenericos.IDEntidade' }, resources.IDLoja);
    </script>
End If

End Code

@Html.Partial(gf.PartialViewInterna, gf)