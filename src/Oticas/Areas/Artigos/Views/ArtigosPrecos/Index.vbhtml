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

    listaCol.Add(New ClsF3MCampo With {.Id = "IDCodigoPreco",
        .TipoEditor = Mvc.Componentes.F3MDropDownList,
        .Controlador = "../Sistema/SistemaCodigosPrecos",
        .LarguraColuna = 200})

    listaCol.Add(New ClsF3MCampo With {.Id = "ValorSemIva",
        .TipoEditor = Mvc.Componentes.F3MNumero,
        .ValorMinimo = 0,
        .CasasDecimais = ClsF3MSessao.RetornaParametros.MoedaReferencia.CasasDecimaisPrecosUnitarios,
        .LarguraColuna = 150})

    listaCol.Add(New ClsF3MCampo With {.Id = "ValorComIva",
        .TipoEditor = Mvc.Componentes.F3MNumero,
        .ValorMinimo = 0,
        .CasasDecimais = ClsF3MSessao.RetornaParametros.MoedaReferencia.CasasDecimaisPrecosUnitarios,
        .LarguraColuna = 150})

    listaCol.Add(New ClsF3MCampo With {.Id = "UPCPercentagem",
        .TipoEditor = Mvc.Componentes.F3MNumero,
        .CasasDecimais = ClsF3MSessao.RetornaParametros.CasasDecimaisPercentagem,
        .ValorMinimo = -99999,
        .ValorMaximo = 99999,
        .LarguraColuna = 200})

    'listaCol.Add(New ClsF3MCampo With {.Id = "IDAPUnidade",
    '    .TipoEditor = Mvc.Componentes.F3MLookup,
    '    .Label = Traducao.EstruturaArtigos.UNIDADE,
    '    .Controlador = "../TabelasAuxiliares/" & MenusComuns.Unidades,
    '    .OpcaoMenuDescAbrev = MenusComuns.Unidades,
    '    .LarguraColuna = 200})

    If bool Then
        funcJS = "ArtigosEnviaParametros"
    Else
        Layout = URLs.SharedLayoutTabelas
    End If

    Dim gf As New ClsMvcKendoGrid With {
        .FuncaoJavascriptGridEdit = "ArtigosPrecosGridEdit",
        .FuncaoJavascriptEnviaParams = funcJS,
        .GravaNoCliente = True,
        .Campos = listaCol}

    gf.GrelhaHTML = Html.F3M().GrelhaLinhas(Of Oticas.ArtigosPrecos)(gf).ToHtmlString()

    If bool Then
        @<script>
            GrelhaLinhasInit('@gf.Id', { '@CamposGenericos.ID': '@CamposGenericos.IDArtigo' }, resources.Preco);
        </script>
    End If

    @Html.Partial(gf.PartialViewInterna, gf)
End Code