@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@ModelType Oticas.ArtigosComponentes

@Scripts.Render("~/bundles/f3m/jsFormularioArtigos")
@Scripts.Render("~/bundles/f3m/jsFormularioArtigosComponentes")

@Code
    Layout = URLs.SharedLayoutTabelas
    Dim tipoPai = New Oticas.ArtigosComponentes().GetType
    Dim AcaoForm As Int16 = Model.AcaoFormulario
End Code

<div class="f3m-window">
    <div class="row form-container">
        <div class="@(ClassesCSS.XS12)">
            @Code ViewBag.VistaParcial = True End Code
            @Html.Partial("~/Areas/Artigos/Views/ArtigosComponentes/" & URLs.ViewIndexGrelha & ".vbhtml")
        </div>
    </div>
    <hr />
    <div class="row form-container" id="dvQuantidades">
        @Code
            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "QuantidadeUPC",
                .TipoPai = tipoPai,
                .Label = Traducao.EstruturaArtigos.QuantidadeUPC,
                .TipoEditor = Mvc.Componentes.F3MNumero,
                .CasasDecimais = ClsF3MSessao.RetornaParametros.MoedaReferencia.CasasDecimaisPrecosUnitarios,
                .Modelo = Model,
                .EEditavel = False,
                .AcaoFormulario = AcaoForm,
                .ViewClassesCSS = {ClassesCSS.XS4}})


            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "QuantidadePCM",
                .TipoPai = tipoPai,
                .Label = Traducao.EstruturaArtigos.QuantidadePCM,
                .TipoEditor = Mvc.Componentes.F3MNumero,
                .CasasDecimais = ClsF3MSessao.RetornaParametros.MoedaReferencia.CasasDecimaisPrecosUnitarios,
                .Modelo = Model,
                .EEditavel = False,
                .AcaoFormulario = AcaoForm,
                .ViewClassesCSS = {ClassesCSS.XS4}})


            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "QuantidadePCPadrao",
                .TipoPai = tipoPai,
                .Label = Traducao.EstruturaArtigos.QuantidadePCP,
                .TipoEditor = Mvc.Componentes.F3MNumero,
                .CasasDecimais = ClsF3MSessao.RetornaParametros.MoedaReferencia.CasasDecimaisPrecosUnitarios,
                .Modelo = Model,
                .EEditavel = False,
                .AcaoFormulario = AcaoForm,
                .ViewClassesCSS = {ClassesCSS.XS4}})
        End Code
    </div>
    <div class="row form-container" id="dvTotais">
        @Code
            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDMetodoCustoComposto",
                .TipoPai = tipoPai,
                .Label = Traducao.EstruturaArtigos.MetodoCustoComposto,
                .Controlador = "../Sistema/SistemaCompostoTransformacaoMetodoCusto",
                .FuncaoJSChange = "ArtigosComponentesMetodoCustoCompostoChange",
                .TipoEditor = Mvc.Componentes.F3MDropDownList,
                .FiltraNoServidor = False,
                .Modelo = Model,
                .AcaoFormulario = AcaoForm,
                .ViewClassesCSS = {ClassesCSS.XS4}})

            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "TotaisPreco",
                .TipoPai = tipoPai,
                .Label = Traducao.EstruturaArtigos.TotalPreco,
                .TipoEditor = Mvc.Componentes.F3MNumero,
                .ValorMinimo = 0,
                .CasasDecimais = ClsF3MSessao.RetornaParametros.MoedaReferencia.CasasDecimaisPrecosUnitarios,
                .Modelo = Model,
                .EEditavel = False,
                .AcaoFormulario = AcaoForm,
                .ViewClassesCSS = {ClassesCSS.XS4}})
        End Code
    </div>
</div>