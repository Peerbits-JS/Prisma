@Imports F3M.Modelos.Constantes
@Modeltype Oticas.DocumentosVendasServicosSubstituicao

@Html.Partial("~/F3M/Areas/Comum/Views/Estados/LadoDireito.vbhtml", New With {
                            .URLTotaisFechados = "~/Areas/Documentos/Views/DocumentosVendasServicosSubstituicao/Views/LadoDireito/LadoDireitoFechado.vbhtml",
                            .URLTotaisAbertos = "~/Areas/Documentos/Views/DocumentosVendasServicosSubstituicao/Views/LadoDireito/LadoDireitoAberto.vbhtml",
                            .AbrevFuncionalidade = TiposEntidadeEstados.ServicosSubstituicao,
                            .IDEstadoInicialDefeito = Model.IDEstado,
                            .DescricaoEstadoInicialDefeito = Model.DescricaoEstado,
                            .FlagAdicionaEstado = False,
                            .TemBotoes = False,
                            .Modelo = Model})