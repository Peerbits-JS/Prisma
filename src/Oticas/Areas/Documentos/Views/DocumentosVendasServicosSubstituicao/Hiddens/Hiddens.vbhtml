@Imports F3M.Modelos.Constantes
@Modeltype Oticas.DocumentosVendasServicosSubstituicao

@Code
    Dim atrHTML As New Dictionary(Of String, Object) From {{"class", CssClasses.InputF3M}}

    'MAIN HIDDENS
    Html.F3M().Hidden("ID", Model.ID, atrHTML)
    Html.F3M().Hidden("EmExecucao", CInt(Model.AcaoFormulario))
    Html.F3M().Hidden("AcaoFormulario", CInt(Model.AcaoFormulario))

    'TIPOS DOCUMENTO
    Html.F3M().Hidden("IDModulo", Model.IDModulo)
    Html.F3M().Hidden("CodigoModulo", SistemaCodigoModulos.Oficina)
    Html.F3M().Hidden("IDSistemaTipoDocumento", Model.IDSistemaTipoDocumento)
    Html.F3M().Hidden("CodigoSistemaTiposDocumento", "SubstituicaoArtigos")
    Html.F3M().Hidden("DocSeriesFirstDataBound", True)
    Html.F3M().Hidden("DataOrdemFabrico", DateTime.Now.ToString(FormatoData.DataHora)) '? REPOSITORIO TIPOS DOCS SERIES -> FILTRA QUERY

    'ESTADOS
    Html.F3M().Hidden("EstadoInicialRascunho", "1") ' ? 0
    Html.F3M().Hidden("Inicial", "1") '? 1
    Html.F3M().Hidden("CodTipoEstadoAnulado", TiposEstados.Anulado)
    Html.F3M().Hidden("CodTipoEstadoRascunho", TiposEstados.Rascunho)
    Html.F3M().Hidden("CodTipoEstadoEfetivo", TiposEstados.Efetivo)
    Html.F3M().Hidden("IDEstado", Model.IDEstado, atrHTML)
    Html.F3M().Hidden("IDEstadoEdicao", Model.ID)
    Html.F3M().Hidden("CodSistemaTipoEstado", Model.CodigoTipoEstado)
    Html.F3M().Hidden("CodigoTipoEstado", Model.CodigoTipoEstado, atrHTML)
    Html.F3M().Hidden("tipoentidadeestado", TiposEntidadeEstados.ServicosSubstituicao)
    Html.F3M().Hidden("labelentidadeestado", TiposEntidadeEstados.ServicosSubstituicao)
    Html.F3M().Hidden("EstadoInicialAux", Model.CodigoTipoEstado)

    'SERVICO ORIGEM
    Html.F3M().Hidden("IDServico", Model.IDServico, atrHTML)
    Html.F3M().Hidden("DescricaoTipoServico", Model.DescricaoTipoServico)
End Code