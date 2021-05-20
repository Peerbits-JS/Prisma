@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Grelhas

@Code
    Dim NovoModelo As New F3M.Agendamento

    Dim strProjeto As String = If(ChavesWebConfig.Projeto.EmDesenv, String.Empty, Operadores.Slash & ChavesWebConfig.Projeto.ProjCliente)

    Dim IDMedicoTecnicoUtilizador As Nullable(Of Long)
    Dim DescricaoMedicoTecnicoUtilizador As String = String.Empty
    Dim IntervaloConsulta As Long = If(ClsF3MSessao.RetornaParametros.Intervalo_Consulta = 0, 30, ClsF3MSessao.RetornaParametros.Intervalo_Consulta)
    Dim TicksMedicoTecnico As Long = IntervaloConsulta
    Dim ListaMedicoTecnicoDefeito As New List(Of Long)
    Dim ListaLojasDefeito As New List(Of Long) From {ClsF3MSessao.RetornaLojaID()}


    Dim DescricaoLoja As String = ClsF3MSessao.RetornaLojaNome

    Using rp As New Repositorio.TabelasAuxiliares.RepositorioMedicosTecnicos
        Dim IDUtilizador = ClsF3MSessao.RetornaUtilizadorID
        Dim MedicoTecnico = rp.Lista(New F3M.Modelos.Comunicacao.ClsF3MFiltro()).Take(100).Where(Function(f) f.IDUtilizador = IDUtilizador).FirstOrDefault
        If MedicoTecnico IsNot Nothing Then
            IDMedicoTecnicoUtilizador = MedicoTecnico.ID
            DescricaoMedicoTecnicoUtilizador = MedicoTecnico.Nome
            ListaMedicoTecnicoDefeito.Add(MedicoTecnico.ID)
            TicksMedicoTecnico = If(MedicoTecnico.Tempoconsulta Is Nothing Or MedicoTecnico.Tempoconsulta = 0, IntervaloConsulta, MedicoTecnico.Tempoconsulta)
        End If
    End Using

    Html.F3M().Hidden("IDMedicoTecnicoUtilizador", IDMedicoTecnicoUtilizador)

    TempData("IDMTU") = IDMedicoTecnicoUtilizador
    TempData("TicksMT") = TicksMedicoTecnico
End code

<div class="row form-container formul-group">
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
    .AtributosHtml = New With {.class = "clsF3MValidaEmGrupo"},
    .OpcaoMenuDescAbrev = Menus.Lojas,
    .FuncaoJSChange = "KendoSchedulerChangeFiltrosCabecalho",
    .FuncaoJSEnviaParams = "KendoSchedulerLojasEnviaParams",
    .ViewClassesCSS = {ClassesCSS.XS4}})

    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDEspecialidadeC",
    .Label = Traducao.EstruturaExames.Especialidade,
    .CampoTexto = CamposGenericos.Descricao,
    .CampoValor = CamposGenericos.ID,
    .TipoEditor = Mvc.Componentes.F3MMultiSelect,
    .Controlador = "../TabelasAuxiliares/Especialidades",
    .Accao = "ListaCombo",
    .Modelo = NovoModelo,
    .ClearButton = True,
    .AtributosHtml = New With {.class = "clsF3MValidaEmGrupo"},
    .OpcaoMenuDescAbrev = Menus.Lojas,
    .FuncaoJSChange = "KendoSchedulerChangeFiltrosCabecalho",
    .ViewClassesCSS = {ClassesCSS.XS4}})

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
    .AtributosHtml = New With {.class = "clsF3MValidaEmGrupo"},
    .OpcaoMenuDescAbrev = F3M.Modelos.Constantes.Menus.MedicosTecnicos,
    .FuncaoJSChange = "KendoSchedulerChangeFiltrosCabecalho",
    .FuncaoJSEnviaParams = "KendoSchedulerLojasEnviaParams",
    .ViewClassesCSS = {ClassesCSS.XS4}})
    End Code
</div>