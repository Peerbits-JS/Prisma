@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Base
@Imports F3M.Modelos.Utilitarios
@Imports F3M.Modelos.Componentes

@Code
    Dim NovoModelo As New F3M.Planeamento
    Dim Modelo As New F3M.Modelos.Calendario.ClsMvcKendoScheduler
    Dim strProjeto As String = If(ChavesWebConfig.Projeto.EmDesenv, String.Empty, Operadores.Slash & ChavesWebConfig.Projeto.ProjCliente)
    Dim opcDescAbrev As String = ClsF3MSessao.RetornaOpcaoMenu(Menus.Planificacao)
    Dim Abertura As DateTime = New DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, 0, 0, 0)
    Dim Fecho As DateTime = New DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, 23, 59, 59)

    Dim ListaLojasDefeito As New List(Of Long) From {ClsF3MSessao.RetornaLojaID()}
    Dim DescricaoLoja As String = ClsF3MSessao.RetornaLojaNome

    'Model.ViewEventTemplate = "<span class='titulo-planifica'>#=title#</span>"

    Modelo.CaminhoTemplateEvento = "~/Areas/Planeamento/Views/Planeamento/TemplateEvento.vbhtml"

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
    Html.F3M().Calendario(Of F3M.Planeamento)(Modelo) _
.StartTime(Abertura) _
.EndTime(Fecho) _
.Editable(Sub(e)
              e.Create(IIf(Not ClsF3MSessao.RetornaLojaAtiva, False, ClsF3MSessao.TemAcesso(AcoesFormulario.Adicionar, opcDescAbrev)))
              e.Update(IIf(Not ClsF3MSessao.RetornaLojaAtiva, False, ClsF3MSessao.TemAcesso(AcoesFormulario.Alterar, opcDescAbrev)))
              e.Destroy(IIf(Not ClsF3MSessao.RetornaLojaAtiva, False, ClsF3MSessao.TemAcesso(AcoesFormulario.Remover, opcDescAbrev)))
              e.Resize(IIf(Not ClsF3MSessao.RetornaLojaAtiva, False, ClsF3MSessao.TemAcesso(AcoesFormulario.Alterar, opcDescAbrev)))
              e.Move(IIf(Not ClsF3MSessao.RetornaLojaAtiva, False, ClsF3MSessao.TemAcesso(AcoesFormulario.Alterar, opcDescAbrev)))
          End Sub) _
.Resources(Sub(resource)
               resource.Add(Function(m) m.IDMedicoTecnico) _
                                                                                                            .Title("Medico") _
                                                                                                            .DataTextField("Text") _
                                                                                                            .DataValueField("Value") _
                                                                                                            .DataColorField("Color") _
                                                                                                            .BindTo(dsMedicosTecnicos)
               resource.Add(Function(m) m.IDLoja) _
                                                                                                            .Title("Loja") _
                                                                                                            .DataTextField("Text") _
                                                                                                            .DataValueField("Value") _
                                                                                                            .DataColorField("Color") _
                                                                                                            .BindTo(dsLojas)
           End Sub).Render()
End Code

<script id="template" type="text/x-kendo-template">
        #var uid = target.attr("data-uid");#
        #var scheduler = $("div[data-role=scheduler]").data("kendoScheduler");#
        #var model = scheduler.occurrenceByUid(uid);#
        #if(model) {#
        <strong>Hora:</strong> #=kendo.toString(kendo.parseDate(model.start), "HH:mm")# - #=kendo.toString(kendo.parseDate(model.end), "HH:mm")#
        <br />
        <strong>Loja:</strong> #=model.DescricaoLoja#
        <br />
        <strong>Médico / Técnico:</strong> #=model.DescricaoMedicoTecnico#
        <br />
        <strong>Cliente:</strong> #=model.DescricaoCliente#
        <br />
        #} else {#
        <strong>Sem informação</strong>
        #}#
    </script>