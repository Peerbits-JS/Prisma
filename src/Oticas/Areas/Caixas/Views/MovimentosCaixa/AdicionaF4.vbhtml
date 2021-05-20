@Imports F3M.Modelos.Constantes
@Code
    @Html.Partial(ClsConstantes.RetornaURL(URLs.PartialF3MAdicionaF4, Me.Context), New With {
                                                                                                                    .JSBundle = String.Empty,
                                                                                                                    .Titulo = "MovimentosCaixa",
                                                                                                                    .TipoNome = "MovimentosCaixa",
                                                                                                                    .Modelo = Model,
                                                                                                                    .TemHT = False})
End Code