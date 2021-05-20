@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@ModelType FormasPagamento

@Html.Partial("~/F3M/Areas/TabelasAuxiliaresComum/Views/FormasPagamento/Detalhe.vbhtml", Model)

@Code
    Dim AcaoForm As Int16 = Model.AcaoFormulario
    Dim blnSistema As Boolean = False
    
    If AcaoForm <> AcoesFormulario.Adicionar Then
        blnSistema = Model.Sistema
    End If
End Code

<div class="@(ClassesCSS.FormPrinc)">
    <div class="FormularioAjudaScroll">
        <div class="container-fluid">
            <div class="row desContainer">
                @Code
                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = CamposGenericos.Codigo,
                                .Label = Traducao.EstruturaAplicacaoTermosBase.Codigo,
                                .Modelo = Model,
                                .EEditavel = Not blnSistema,
                                .AtributosHtml = New With {.class = "textbox-titulo"},
                                .ViewClassesCSS = {ClassesCSS.XS3}})

                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = CamposGenericos.Descricao,
                        .Label = Traducao.EstruturaAplicacaoTermosBase.Descricao,
                        .Modelo = Model,
                        .EEditavel = Not blnSistema,
                        .AtributosHtml = New With {.class = "textbox-titulo"},
                        .ViewClassesCSS = {ClassesCSS.XS4}})

                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDTipoFormaPagamento",
                         .Label = Traducao.EstruturaAplicacaoTermosBase.Tipo,
                         .Modelo = Model,
                        .EEditavel = Not blnSistema,
                         .TipoEditor = Mvc.Componentes.F3MDropDownList,
                         .Controlador = "../Sistema/SistemaTiposFormasPagamento",
                         .AtributosHtml = New With {.class = "textbox-titulo"},
                         .ViewClassesCSS = {ClassesCSS.XS3}})

                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = CamposGenericos.Ativo,
                        .Label = Traducao.EstruturaAplicacaoTermosBase.Ativo,
                        .Modelo = Model,
                        .TipoEditor = Mvc.Componentes.F3MCheckBoxBootstrap,
                        .ViewClassesCSS = {ClassesCSS.XS2}})
                End Code
            </div>
          
            @Code ViewBag.VistaParcial = True End Code
            @Html.Partial("~/Areas/TabelasAuxiliares/Views/FormasPagamentoIdiomas/Index.vbhtml")

        </div>
    </div>
</div>