@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Base
@Imports F3M.Modelos.Componentes

@Code
    Dim NovoModelo As New F3M.Planeamento
    Dim strProjeto As String = If(ChavesWebConfig.Projeto.EmDesenv, String.Empty, Operadores.Slash & ChavesWebConfig.Projeto.ProjCliente)
    Dim opcDescAbrev As String = ClsF3MSessao.RetornaOpcaoMenu(Menus.Planificacao)
    Dim Abertura As DateTime = New DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, 0, 0, 0)
    Dim Fecho As DateTime = New DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, 23, 59, 59)

    Dim ListaLojasDefeito As New List(Of Long) From {ClsF3MSessao.RetornaLojaID()}
    Dim DescricaoLoja As String = ClsF3MSessao.RetornaLojaNome

    'Model.ViewEventTemplate = "<span class='titulo-planifica'>#=title#</span>"

    Dim ItemTemplateMultiselect = "<img class=""img-circle"" src=""#:data.FotoCaminho#"" style=""width: 20px; height: 20px; background:white; border: 1px solid \#ccc;""><span class='k-state-default'> #: data.Nome #</span>"


    ' MEDICOS TECNICOS
    Dim dsMedicosTecnicos As IEnumerable(Of Object)

    Using rp As New Repositorio.TabelasAuxiliares.RepositorioMedicosTecnicos

        dsMedicosTecnicos = rp.Lista(New F3M.Modelos.Comunicacao.ClsF3MFiltro()).Where(Function(f) f.TemAgenda And f.Ativo).Select(Function(s) New With {.Text = s.Codigo, .Value = s.ID, .Color = s.Cor}).ToList()

    End Using

    ' LOJAS
    Dim dsLojas As IEnumerable(Of Object)

    Using rp As New F3M.Repositorios.Administracao.RepositorioLojas

        dsLojas = rp.ListaLojasDaEmpresaEmSessao(New F3M.Modelos.Comunicacao.ClsF3MFiltro()).ToList().Select(Function(s) New With {.Text = s.Codigo, .Value = s.ID, .Color = s.Cor}).ToList()
        Dim IDEmpresa = ClsF3MSessao.RetornaLojaID
        Dim LojaSessao = rp.Lista(New F3M.Modelos.Comunicacao.ClsF3MFiltro).Where(Function(f) f.ID = IDEmpresa).FirstOrDefault

        Abertura = IIf(Not IsNothing(LojaSessao.Abertura), LojaSessao.Abertura, New DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, 0, 0, 0))
        Fecho = IIf(Not IsNothing(LojaSessao.Fecho), LojaSessao.Fecho, New DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, 23, 59, 59))
    End Using
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
        .AtributosHtml = New With {.class = "textbox-titulo"},
        .OpcaoMenuDescAbrev = Menus.Lojas,
        .FuncaoJSChange = "KendoSchedulerChangeFiltrosCabecalho",
        .FuncaoJSEnviaParams = "KendoSchedulerLojasEnviaParams"})

    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDMedicoTecnicoC",
        .Label = OticasTraducao.EstruturaMedicosTecnicos.MedicoTecnico,
        .CampoTexto = CamposGenericos.Nome,
        .CampoValor = CamposGenericos.ID,
        .TipoEditor = Mvc.Componentes.F3MMultiSelect,
        .Controlador = "../TabelasAuxiliares/MedicosTecnicos",
        .Accao = "ListaCombo",
        .Modelo = NovoModelo,
        .ClearButton = True,
        .TemplateColuna = ItemTemplateMultiselect,
        .AtributosHtml = New With {.class = "textbox-titulo"},
        .OpcaoMenuDescAbrev = F3M.Modelos.Constantes.Menus.MedicosTecnicos,
        .FuncaoJSEnviaParams = "KendoSchedulerMedicoTecnicoPesquisaEnviaParams",
        .FuncaoJSChange = "KendoSchedulerChangeFiltrosCabecalho"})
End Code