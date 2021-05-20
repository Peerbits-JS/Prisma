@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@ModelType Oticas.Artigos
@Code
    Dim blnExistemMovimentosStock As Boolean = ViewBag.ExistemMovimentosStock
End Code
<div role="tabpanel" class="tab-pane fade" id="tabDefinicao">
    <div class="row form-container">
        <div class="col-3">
            <label>&nbsp;</label>
            <div class="arrayChecks">
                @Code
                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "GereStock",
                                        .Label = Traducao.EstruturaArtigos.GERESTOCKS,
                                        .Modelo = Model,
                                        .EEditavel = Not blnExistemMovimentosStock,
                                        .TipoEditor = Mvc.Componentes.F3MCheckBoxBootstrap,
                                        .ViewClassesCSS = {"f3m-checkbox-sem-top"}})

                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Inventariado",
                                                        .Label = Traducao.EstruturaArtigos.Inventariado,
                                                        .Modelo = Model,
                                                        .TipoEditor = Mvc.Componentes.F3MCheckBoxBootstrap,
                                                        .ViewClassesCSS = {"f3m-checkbox-sem-top"}})

                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "GereLotes",
                                                        .Label = Traducao.EstruturaArtigos.GereLotes,
                                                        .Modelo = Model,
                                                        .TipoEditor = Mvc.Componentes.F3MCheckBoxBootstrap,
                                                        .ValorID = Model.GereLotes,
                                                        .EEditavel = Not blnExistemMovimentosStock,
                                                        .ViewClassesCSS = {"f3m-checkbox-sem-top"}})

                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "DescricaoVariavel",
                                .Label = Traducao.EstruturaArtigos.DESCRICAOVARIAVEL,
                                .TipoEditor = Mvc.Componentes.F3MCheckBoxBootstrap,
                                .Modelo = Model,
                                .ViewClassesCSS = {"f3m-checkbox-sem-top"}})
                End Code
            </div>
        </div>
        <div class="@(ClassesCSS.XS9)">
            <div class="row form-container">
                @Code
                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDImpostoSelo",
                        .Label = Traducao.EstruturaArtigos.ImpostoSelo,
                        .Controlador = "../TabelasAuxiliares/" & F3M.Modelos.Constantes.MenusComuns.ImpostoSelo,
                        .OpcaoMenuDescAbrev = F3M.Modelos.Constantes.MenusComuns.ImpostoSelo,
                        .TipoEditor = Mvc.Componentes.F3MLookup,
                        .Modelo = Model,
                        .EVisivel = False,
                        .ViewClassesCSS = {ClassesCSS.XS4}})

                    'Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "VariavelContabilidade",
                    '    .Label = Traducao.EstruturaArtigos.VARIAVELCONTABILIDADE,
                    '    .Modelo = Model,
                    '    .ViewClassesCSS = {ClassesCSS.XS4}})
                End Code
            </div>
        </div>
    </div>
</div>