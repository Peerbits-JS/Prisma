@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Base
@Imports F3M.Modelos.Componentes

@Code
    Dim NovoModelo As New F3M.Agendamento
    Dim strProjeto As String = If(ChavesWebConfig.Projeto.EmDesenv, String.Empty, Operadores.Slash & ChavesWebConfig.Projeto.ProjCliente)
    Dim opcDescAbrev As String = ClsF3MSessao.RetornaOpcaoMenu(Menus.Planificacao)
    Dim Abertura As DateTime = New DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, 0, 0, 0)
    Dim Fecho As DateTime = New DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, 23, 59, 59)

    Dim IDMedicoTecnicoUtilizador As Nullable(Of Long)
    Dim DescricaoMedicoTecnicoUtilizador As String = String.Empty
    Dim IntervaloConsulta As Long = If(ClsF3MSessao.RetornaParametros.Intervalo_Consulta = 0, 30, ClsF3MSessao.RetornaParametros.Intervalo_Consulta)
    Dim TicksMedicoTecnico As Long = IntervaloConsulta
    Dim ListaMedicoTecnicoDefeito As New List(Of Long)
    Dim ListaLojasDefeito As New List(Of Long) From {ClsF3MSessao.RetornaLojaID()}
    Dim DescricaoLoja As String = ClsF3MSessao.RetornaLojaNome

    'Model.FuncaoJavascriptTemplateSlot = "KendoSchedulerTemplateSlot"
    ''Model.ViewEventTemplate = "<span class='agenda-event-name'># if (IDMedicoTecnico != null && document.getElementById('IDMedicoTecnicoUtilizador') != undefined && IDMedicoTecnico == document.getElementById('IDMedicoTecnicoUtilizador').value) { # <span class="" edit-event"" data-uid="" #=uid#""><a class="" k-link f3m-event-view"" title="" Ver detalhe do evento"" aria-label="" Ver detalhe do evento""><span>#=title# </span><span class="" fm f3icon-arrow-circle-right""></span></a></span> # } else { # <span>#=title# </span> # } #</span>"
    'Model.TemPlanificacao = True

    Dim ItemTemplateMultiselect = "<img class="" img-circle"" src="" #:data.FotoCaminho#"" style="" width: 20px; height: 20px; background:white; border: 1px solid \#ccc;""><span class='k-state-default'> #: data.Nome #</span>"

    ' MEDICOS TECNICOS
    Dim dsMedicosTecnicos As IEnumerable(Of Object)

    Using rp As New Repositorio.TabelasAuxiliares.RepositorioMedicosTecnicos

        dsMedicosTecnicos = rp.Lista(New F3M.Modelos.Comunicacao.ClsF3MFiltro()).Where(Function(f) f.TemAgenda And f.Ativo).Take(100).Select(Function(s) New With {.Text = s.Codigo, .Value = s.ID, .Color = s.Cor}).ToList()

        Dim IDUtilizador = ClsF3MSessao.RetornaUtilizadorID
        Dim MedicoTecnico = rp.Lista(New F3M.Modelos.Comunicacao.ClsF3MFiltro()).Where(Function(f) f.IDUtilizador = IDUtilizador).FirstOrDefault
        If MedicoTecnico IsNot Nothing Then
            IDMedicoTecnicoUtilizador = MedicoTecnico.ID
            DescricaoMedicoTecnicoUtilizador = MedicoTecnico.Nome
            TicksMedicoTecnico = If(MedicoTecnico.Tempoconsulta Is Nothing Or MedicoTecnico.Tempoconsulta = 0, IntervaloConsulta, MedicoTecnico.Tempoconsulta)
            ListaMedicoTecnicoDefeito.Add(MedicoTecnico.ID)
        End If

    End Using

    ' LOJAS
    Dim dsLojas As IEnumerable(Of Object)

    Using rp As New F3M.Repositorios.Administracao.RepositorioLojas

        dsLojas = rp.ListaLojasDaEmpresaEmSessao(New F3M.Modelos.Comunicacao.ClsF3MFiltro()).Take(100).ToList().Select(Function(s) New With {.Text = s.Codigo, .Value = s.ID, .Color = s.Cor}).ToList()

        Dim dict As New Dictionary(Of String, String) From {{"IDEmpresa", ClsF3MSessao.RetornaEmpresaID}}
        Dim dictionary As New Dictionary(Of String, Dictionary(Of String, String)) From {{"CamposFiltrar", dict}}
        Dim IDLoja As Long = ClsF3MSessao.RetornaLojaID
        Dim LojaSessao = rp.Lista(New F3M.Modelos.Comunicacao.ClsF3MFiltro With {.CamposFiltrar = dictionary}).Where(Function(f) f.ID = IDLoja).FirstOrDefault

        Abertura = IIf(Not IsNothing(LojaSessao.Abertura), LojaSessao.Abertura, New DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, 0, 0, 0))
        Fecho = IIf(Not IsNothing(LojaSessao.Fecho), LojaSessao.Fecho, New DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, 23, 59, 59))
    End Using

    Html.F3M().Hidden("IDMedicoTecnicoUtilizador", IDMedicoTecnicoUtilizador)

End Code


@Code
    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDLojaC",
        .Label = Traducao.EstruturaAplicacaoTermosBase.Loja,
        .CampoTexto = CamposGenericos.Descricao,
        .CampoValor = CamposGenericos.ID,
        .TipoEditor = Mvc.Componentes.F3MMultiSelect,
        .Controlador = "../../" & strProjeto & "/F3M/Administracao/Lojas",
        .Accao = "ListaCombo",
        .ValorID = ListaLojasDefeito,
        .ValorDescricao = DescricaoLoja,
        .Modelo = NovoModelo,
        .ClearButton = True,
        .AtributosHtml = New With {.class = "clsF3MValidaEmGrupo textbox-titulo"},
        .OpcaoMenuDescAbrev = Menus.Lojas,
        .FuncaoJSChange = "KendoSchedulerChangeFiltrosCabecalho",
        .FuncaoJSEnviaParams = "KendoSchedulerLojasEnviaParams"})

    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDEspecialidadeC",
        .Label = Traducao.EstruturaExames.Especialidade,
        .CampoTexto = CamposGenericos.Descricao,
        .CampoValor = CamposGenericos.ID,
        .TipoEditor = Mvc.Componentes.F3MMultiSelect,
        .Controlador = "../TabelasAuxiliares/Especialidades",
        .Accao = "ListaCombo",
        .Modelo = NovoModelo,
        .ClearButton = True,
        .AtributosHtml = New With {.class = "clsF3MValidaEmGrupo textbox-titulo"},
        .OpcaoMenuDescAbrev = Menus.Lojas,
        .FuncaoJSChange = "KendoSchedulerChangeFiltrosCabecalho"})

    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDMedicoTecnicoC",
.Label = OticasTraducao.EstruturaMedicosTecnicos.MedicoTecnico,
.CampoTexto = CamposGenericos.Nome,
.CampoValor = CamposGenericos.ID,
.TipoEditor = Mvc.Componentes.F3MMultiSelect,
.Controlador = "../TabelasAuxiliares/MedicosTecnicos",
.Accao = "ListaCombo",
.ValorID = ListaMedicoTecnicoDefeito,
.ValorDescricao = DescricaoMedicoTecnicoUtilizador,
.Modelo = NovoModelo,
.ClearButton = True,
.TemplateColuna = ItemTemplateMultiselect,
.AtributosHtml = New With {.class = "clsF3MValidaEmGrupo textbox-titulo"},
.OpcaoMenuDescAbrev = F3M.Modelos.Constantes.Menus.MedicosTecnicos,
.FuncaoJSChange = "KendoSchedulerChangeFiltrosCabecalho",
.FuncaoJSEnviaParams = "KendoSchedulerMedicoTecnicoPesquisaEnviaParams"})
End Code
