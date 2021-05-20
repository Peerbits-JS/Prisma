@Imports F3M.Modelos.Constantes
@Modeltype Oticas.DocumentosStockContagem

@Html.Partial("~/F3M/Areas/Comum/Views/Estados/LadoDireito.vbhtml", New With {
                        .URLTotaisFechados = "~/Areas/Documentos/Views/DocumentosStockContagem/Views/LadoDireito/LadoDireitoFechado.vbhtml",
                        .URLTotaisAbertos = "~/Areas/Documentos/Views/DocumentosStockContagem/Views/LadoDireito/LadoDireitoAberto.vbhtml",
                        .AbrevFuncionalidade = TiposEntidadeEstados.DocumentosStockContagem,
                        .IDEstadoInicialDefeito = Model.IDEstado,
                        .DescricaoEstadoInicialDefeito = Model.DescricaoEstado,
                        .FlagAdicionaEstado = False,
                        .Modelo = Model})