@Imports F3M.Modelos.Constantes
@Modeltype Oticas.DocumentosVendas

@Code
    Dim boolPermiteEditarEstado As Boolean = Not (Model.flgImpFromServicosToDV OrElse Model.flgImpFromServicosToFT2 OrElse Model.flgImpFromVendasToNC)

    @Html.Partial(URLs.EstadosComum & "LadoDireito.vbhtml", New With {
                               .URLTotaisFechados = "Views/LadoDireito/LadoDireitoFechado",
                               .URLTotaisAbertos = "Views/LadoDireito/LadoDireitoAberto",
                               .AbrevFuncionalidade = TiposEntidadeEstados.DocumentosVenda,
                               .IDEstadoInicialDefeito = Model.IDEstado,
                               .DescricaoEstadoInicialDefeito = Model.DescricaoEstado,
                               .FlagAdicionaEstado = False,
                               .PermiteEditarEstado = boolPermiteEditarEstado,
                               .Modelo = Model})
End Code