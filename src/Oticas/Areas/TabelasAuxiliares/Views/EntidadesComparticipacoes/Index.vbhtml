@Imports F3M.Modelos.Constantes
@Imports Oticas.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas

@Code
    Dim funcJS As String = "EntidadesEnviaParametros"
    Dim bool As Boolean = (ViewBag.VistaParcial IsNot Nothing AndAlso ViewBag.VistaParcial)
    Dim listaCol = New List(Of ClsF3MCampo)

    If Not bool Then
        Layout = URLs.SharedLayoutTabelas
    End If

    listaCol.Add(New ClsF3MCampo With {.Id = "IDTipoArtigo",
        .Label = Traducao.EstruturaAplicacaoTermosBase.TipoArtigo,
        .TipoEditor = Mvc.Componentes.F3MDropDownList,
        .Controlador = "../TabelasAuxiliares/TiposArtigos",
        .FuncaoJSChange = "EntidadesComparticipacoesIDTipoArtigoChange",
        .LarguraColuna = 150})

    listaCol.Add(New ClsF3MCampo With {.Id = "IDTipoLente",
        .Label = Traducao.EstruturaAplicacaoTermosBase.TipoLente,
        .TipoEditor = Mvc.Componentes.F3MDropDownList,
        .FuncaoJSEnviaParams = "EntidadesComparticipacoesTipoLenteEnviaParametros",
        .Controlador = "../Sistema/SistemaTiposLentes",
        .Cascata = "IDTipoArtigo",
        .LarguraColuna = 150})

    listaCol.Add(New ClsF3MCampo With {.Id = "Percentagem",
        .Label = "(%) Compart",
        .TipoEditor = Mvc.Componentes.F3MNumero,
        .CasasDecimais = 2,
        .ValorMinimo = 0,
        .ValorMaximo = 100,
        .LarguraColuna = 100})

    listaCol.Add(New ClsF3MCampo With {.Id = "ValorMaximo",
        .Label = "(€) Limite",
        .TipoEditor = Mvc.Componentes.F3MNumero,
        .CasasDecimais = 2,
        .LarguraColuna = 100})

    listaCol.Add(New ClsF3MCampo With {.Id = "Quantidade",
        .Label = Traducao.EstruturaAplicacaoTermosBase.Quantidade,
        .TipoEditor = Mvc.Componentes.F3MNumeroInt,
        .ValorMinimo = 0,
        .ValorMaximo = 999,
        .LarguraColuna = 100})

    listaCol.Add(New ClsF3MCampo With {.Id = "Duracao",
        .TipoEditor = Mvc.Componentes.F3MNumeroInt,
        .Label = "Meses",
        .ValorMinimo = 0,
        .ValorMaximo = 999,
        .LarguraColuna = 100})

    listaCol.Add(New ClsF3MCampo With {.Id = "PotenciaEsfericaDe",
        .TipoEditor = Mvc.Componentes.F3MNumero,
        .Label = Traducao.EstruturaAplicacaoTermosBase.EsfDe,
        .ValorMinimo = -50,
        .ValorMaximo = 50,
        .CasasDecimais = 2,
        .LarguraColuna = 100})

    listaCol.Add(New ClsF3MCampo With {.Id = "PotenciaEsfericaAte",
        .TipoEditor = Mvc.Componentes.F3MNumero,
        .Label = Traducao.EstruturaAplicacaoTermosBase.EsfAte,
        .ValorMinimo = -50,
        .ValorMaximo = 50,
        .CasasDecimais = 2,
        .LarguraColuna = 100})

    listaCol.Add(New ClsF3MCampo With {.Id = "PotenciaCilindricaDe",
        .TipoEditor = Mvc.Componentes.F3MNumero,
        .Label = Traducao.EstruturaAplicacaoTermosBase.CilDe,
        .ValorMinimo = -50,
        .ValorMaximo = 50,
        .CasasDecimais = 2,
        .LarguraColuna = 100})

    listaCol.Add(New ClsF3MCampo With {.Id = "PotenciaCilindricaAte",
        .TipoEditor = Mvc.Componentes.F3MNumero,
        .Label = Traducao.EstruturaAplicacaoTermosBase.CilAte,
        .ValorMinimo = -50,
        .ValorMaximo = 50,
        .CasasDecimais = 2,
        .LarguraColuna = 100})

    listaCol.Add(New ClsF3MCampo With {.Id = "PotenciaPrismaticaDe",
        .TipoEditor = Mvc.Componentes.F3MNumero,
        .Label = Traducao.EstruturaAplicacaoTermosBase.PrismDe,
        .ValorMinimo = 0,
        .ValorMaximo = 30,
        .CasasDecimais = 2,
        .LarguraColuna = 100})

    listaCol.Add(New ClsF3MCampo With {.Id = "PotenciaPrismaticaAte",
        .TipoEditor = Mvc.Componentes.F3MNumero,
        .Label = Traducao.EstruturaAplicacaoTermosBase.PrismAte,
        .ValorMinimo = 0,
        .ValorMaximo = 30,
        .CasasDecimais = 2,
        .LarguraColuna = 100})

    Dim gf As New ClsMvcKendoGrid With {
        .Tipo = New EntidadesComparticipacoes().GetType,
        .FuncaoJavascriptEnviaParams = funcJS,
        .TituloGrelhaDeLinhas = Traducao.EstruturaAplicacaoTermosBase.Comparticipacoes,
        .Altura = 600,
        .GravaNoCliente = True,
        .Campos = listaCol}

    gf.GrelhaHTML = Html.F3M().GrelhaLinhas(Of EntidadesComparticipacoes)(gf).ToHtmlString()

    If bool Then
    @<script>
        GrelhaLinhasInit('@gf.Id', { '@CamposGenericos.ID': '@CamposGenericos.IDEntidade' }, resources.Comparticipacao);
    </script>
End If

    @Html.Partial(gf.PartialViewInterna, gf)
End Code