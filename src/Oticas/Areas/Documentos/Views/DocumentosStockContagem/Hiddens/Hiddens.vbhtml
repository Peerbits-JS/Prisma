@Imports F3M.Modelos.Constantes
@Modeltype Oticas.DocumentosStockContagem

@Code
    Dim atrHTML As New Dictionary(Of String, Object) From {{"class", CssClasses.InputF3M}}

    'MAIN HIDDENS
    Html.F3M().Hidden("ID", Model.ID, atrHTML)
    Html.F3M().Hidden("EmExecucao", CInt(Model.AcaoFormulario))
    Html.F3M().Hidden("F3MGrelha", "F3MGrelhaFormDocumentosStockContagem")

    'TIPOS DOCUMENTO
    Html.F3M().Hidden("IDModulo", Model.IDModulo)
    Html.F3M().Hidden("CodigoModulo", SistemaCodigoModulos.Stocks)
    Html.F3M().Hidden("IDSistemaTipoDocumento", Model.IDSistemaTipoDocumento)
    Html.F3M().Hidden("CodigoSistemaTiposDocumento", "StkContagemStock")
    Html.F3M().Hidden("DocSeriesFirstDataBound", True)
    Html.F3M().Hidden("DataOrdemFabrico", DateTime.Now.ToString(FormatoData.DataHora)) '? REPOSITORIO TIPOS DOCS SERIES -> FILTRA QUERY

    'ESTADOS
    Html.F3M().Hidden("EstadoInicialRascunho", "1") ' ? 0
    Html.F3M().Hidden("Inicial", "1") '? 1
    Html.F3M().Hidden("CodTipoEstadoRascunho", TiposEstados.Rascunho)
    Html.F3M().Hidden("CodTipoEstadoEfetivo", TiposEstados.Efetivo)
    Html.F3M().Hidden("IDEstado", Model.IDEstado, atrHTML)
    Html.F3M().Hidden("IDEstadoEdicao", Model.ID)
    Html.F3M().Hidden("CodSistemaTipoEstado", Model.CodigoTipoEstado)
    Html.F3M().Hidden("CodigoTipoEstado", Model.CodigoTipoEstado, atrHTML)
    Html.F3M().Hidden("tipoentidadeestado", TiposEntidadeEstados.DocumentosStockContagem)
    Html.F3M().Hidden("labelentidadeestado", TiposEntidadeEstados.DocumentosStockContagem)
    Html.F3M().Hidden("EstadoInicialAux", Model.CodigoTipoEstado)

    'LADO DIREITO
    Html.F3M().Hidden("FaltamContar", Model.FaltamContar, New Dictionary(Of String, Object) From {{"class", CssClasses.InputF3M & " " & "CLSF3MLadoDirFaltam"}})
    Html.F3M().Hidden("Contados", Model.Contados, New Dictionary(Of String, Object) From {{"class", CssClasses.InputF3M & " " & "CLSF3MLadoDirContados"}})
    Html.F3M().Hidden("Diferencas", Model.Diferencas, New Dictionary(Of String, Object) From {{"class", CssClasses.InputF3M & " " & "lado-dir-diferencas"}})

    'CRUD - HIDDEN DE CONTROLO PARA QUANDO SE CLICA NO BOTAO DE EFETIVAR
    Html.F3M().Hidden("GravouViaEfetivar", Model.GravouViaEfetivar, atrHTML)
End Code