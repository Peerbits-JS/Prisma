@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Grelhas
@Code
    Dim NovoModelo As New F3M.Planeamento

    Dim strProjeto As String = If(ChavesWebConfig.Projeto.EmDesenv, String.Empty, Operadores.Slash & ChavesWebConfig.Projeto.ProjCliente)

    Dim IDLoja As Nullable(Of Long) = ClsF3MSessao.RetornaLojaID
    Dim DescricaoLoja As String = ClsF3MSessao.RetornaLojaNome
End code

<div class="row form-container formul-group">
    @Code
        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDLojaC",
            .Label = Traducao.EstruturaAplicacaoTermosBase.Loja,
            .Controlador = "../../" & strProjeto & "/F3M/Administracao/Lojas",
            .ControladorAccaoExtra = "../../" & strProjeto & "/F3M/Administracao/Lojas/IndexGrelha",
            .ValorID = IDLoja,
            .ValorDescricao = DescricaoLoja,
            .ValorPorDefeito = IDLoja,
            .OpcaoMenuDescAbrev = Menus.Lojas,
            .TipoEditor = Mvc.Componentes.F3MLookup,
            .FuncaoJSChange = "KendoSchedulerRead",
            .FuncaoJSEnviaParams = "KendoSchedulerLojasEnviaParams",
            .Modelo = NovoModelo,
            .ViewClassesCSS = {ClassesCSS.XS4}})

        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDMedicoTecnicoC",
        .Label = OticasTraducao.EstruturaMedicosTecnicos.MedicoTecnico,
        .TipoEditor = Mvc.Componentes.F3MLookup,
        .FuncaoJSChange = "KendoSchedulerRead",
        .Controlador = "../TabelasAuxiliares/MedicosTecnicos",
        .ControladorAccaoExtra = .Controlador & Operadores.Slash & URLs.ViewIndexGrelha,
        .OpcaoMenuDescAbrev = F3M.Modelos.Constantes.Menus.MedicosTecnicos,
        .CampoTexto = CamposGenericos.Nome,
        .Modelo = NovoModelo,
        .ViewClassesCSS = {ClassesCSS.XS4}})
    End Code
</div>