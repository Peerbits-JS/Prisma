@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports Oticas.Repositorio.Exames
@ModelType ClsMvcKendoGrid

@Code
    Layout = URLs.SharedLayoutTabelas
    Dim botaoHtml As String = Mvc.BotoesGrelha.BotaoHTMLVisivel

    Dim boolTemAcessoImprimir As Boolean = ClsF3MSessao.TemAcessoPorDescricao(AcoesFormulario.Imprimir, "Exames")
    Html.F3M().Hidden("TemAcessoImprimir", boolTemAcessoImprimir)

    Dim boolTemAcessoConsultas As Boolean = ClsF3MSessao.TemAcessoPorDescricao(AcoesFormulario.Consultar, "Exames")

    Dim boolUtilizadorEmSessaoEMedTec As Boolean = True
    Using rpExames As New RepositorioExames
        If rpExames.RetornaMedicoTecnicoUtilizadorSessao() Is Nothing Then
            boolUtilizadorEmSessaoEMedTec = False
        End If
    End Using
End Code

@Scripts.Render("~/bundles/f3m/jsAppointments")

<div id="importacao">
    <div class="f3m-top submenu clearfix">
        <div class="float-left f3m-top__left">
            <div id="tituloimportacao" class="f3m-top__title">Consultas</div>
        </div>
        <div class="float-right f3m-top__right f3mgrelhabts">
            @Html.Raw(String.Format(botaoHtml, Mvc.BotoesGrelha.Refrescar, "", Traducao.EstruturaAplicacaoTermosBase.TOOLTIPRefrescar, "refresh"))

            <div class="dropdown grelha-bts permImpr btsCRUD">
                <a class="dropdown-toggle f3mlink" type="button" id="printdropdown" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
                    <span class="fm f3icon-print"></span>
                    <span class="fm f3icon-chevron-down-2"></span>
                </a>
                <ul class="dropdown-menu dropdown-menu-right" aria-labelledby="">
                    <a href="#" class="dropdown-item CLSF3MImprimir" id="receita">
                        <span class="fm f3icon-file-text-o mr-1"></span>
                        Receita
                    </a>
                    <a href="#" class="dropdown-item CLSF3MImprimir" id="relatorio">
                        <span class="fm f3icon-ficha mr-1"></span>
                        Relatório
                    </a>
                </ul>
            </div>
        </div>
    </div>
    @Code
        'get cols
        Dim listaCol = New List(Of ClsF3MCampo)
        With listaCol
            .Add(New ClsF3MCampo With {.Id = CamposGenericos.Ativo, .EVisivel = False})
            .Add(New ClsF3MCampo With {.Id = "DataExame", .LarguraColuna = 200, .EVisivel = True, .TipoEditor = Mvc.Componentes.F3MData, .Formato = "{dd:MM}"})
            .Add(New ClsF3MCampo With {.Id = "Hora", .LarguraColuna = 150, .EVisivel = True, .TipoEditor = Mvc.Componentes.F3MTexto})
            .Add(New ClsF3MCampo With {.Id = "IDMedicoTecnico", .LarguraColuna = 300, .EVisivel = True})
            .Add(New ClsF3MCampo With {.Id = "Tipo", .LarguraColuna = 200, .EVisivel = True})
            .Add(New ClsF3MCampo With {.Id = "IDEspecialidade", .LarguraColuna = 200, .EVisivel = True})
        End With

        'model 4 (taste) grid
        With Model
            .Tipo = GetType(Oticas.Exames)
            .Paginacao = False
            .CamposOrdenar = New Dictionary(Of String, String) From {{"DataExame", "desc"}, {"Hora", "desc"}}
            .Campos = listaCol
            .AccaoCustomizavelLeitura = "ListaEspecifico"
            .FuncaoJavascriptEnviaParams = "AppointmentsFilter"
            .FuncaoJavascriptGridEdit = "GrelhaFormEdit"
            .FuncaoJavascriptGridChange = "GrelhaFormChange"
            .ControladorCustomizavel = "../Exames/Exames"
        End With

        If (boolTemAcessoConsultas AndAlso boolUtilizadorEmSessaoEMedTec) Then
            'get html download column
            Dim HTMLDownload As String = String.Empty
            HTMLDownload += "<button class=""btn btn-sm btn-line btn-block""  f3m-data-id=#=data.ID# onclick =""AppointmentsOpenAppointment(this)"">Ver consulta</button>"
            'add download column
            Model.Campos.Add(New ClsF3MCampo With {.Id = "VerConsulta", .LarguraColuna = 200, .Label = " ", .Alinhamento = "alinhamentocentro", .TipoEditor = Mvc.Componentes.F3MHTML, .HTML = HTMLDownload})
        End If

        'get grid
        Dim grid As Fluent.GridBuilder(Of Oticas.Exames) = Html.F3M().GrelhaFormulario(Of Oticas.Exames)(Model)
        'render grid
        grid.Render()
    End Code
</div>