@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo


@Code
    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = Model.ModelPropertyName,
                                  .Label = Model.Label,
                                  .Modelo = Model,
                                  .TipoEditor = Mvc.Componentes.F3MCheckBoxBootstrap,
                                  .ValorPorDefeito = Model.ValorPorDefeito,
                                  .ViewClassesCSS = {"f3m-checkbox-sem-top"}})
End Code