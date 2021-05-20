@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Base
@Imports F3M.Modelos.Utilitarios
@Imports F3M.Modelos.Componentes

@Code
    Dim NovoModelo As New F3M.Agendamento
    Dim Modelo As New F3M.Modelos.Calendario.ClsMvcKendoScheduler
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

    Modelo.FuncaoJavascriptTemplateSlot = "KendoSchedulerTemplateSlot"
    'Model.ViewEventTemplate = "<span class='agenda-event-name'># if (IDMedicoTecnico != null && document.getElementById('IDMedicoTecnicoUtilizador') != undefined && IDMedicoTecnico == document.getElementById('IDMedicoTecnicoUtilizador').value) { # <span class="" edit-event"" data-uid="" #=uid#""><a class="" k-link f3m-event-view"" title="" Ver detalhe do evento"" aria-label="" Ver detalhe do evento""><span>#=title# </span><span class="" fm f3icon-arrow-circle-right""></span></a></span> # } else { # <span>#=title# </span> # } #</span>"
    Modelo.TemPlanificacao = True
    Modelo.CaminhoTemplateEvento = "~/Areas/Agendamento/Views/Agendamento/TemplateEvento.vbhtml"



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
    Html.F3M().Calendario(Of F3M.Agendamento)(Modelo) _
.StartTime(Abertura) _
.EndTime(Fecho) _
.MajorTick(TicksMedicoTecnico) _
.MinorTickCount(1) _
.Views(Sub(v)
           v.DayView(Sub(dv)
                         If IDMedicoTecnicoUtilizador IsNot Nothing Then
                             dv.Selected(True)
                         End If
                         If Not ClsTexto.ENuloOuVazio(Modelo.ViewEventTemplate) Then
                             dv.EventTemplate(Modelo.ViewEventTemplate)
                         End If
                         If Not ClsTexto.ENuloOuVazio(Modelo.FuncaoJavascriptTemplateSlot) Then
                             dv.SlotTemplate(Modelo.FuncaoJavascriptTemplateSlot)
                         End If
                     End Sub)
           v.WeekView(Sub(wv)
                          If IDMedicoTecnicoUtilizador Is Nothing Then
                              wv.Selected(True)
                          End If
                          If Not ClsTexto.ENuloOuVazio(Modelo.ViewEventTemplate) Then
                              wv.EventTemplate(Modelo.ViewEventTemplate)
                          End If
                          If Not ClsTexto.ENuloOuVazio(Modelo.FuncaoJavascriptTemplateSlot) Then
                              wv.SlotTemplate(Modelo.FuncaoJavascriptTemplateSlot)
                          End If
                      End Sub)
       End Sub) _
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
    #if(model.DescricaoCliente != null) {#
    <strong>Cliente:</strong> #=model.DescricaoCliente#
    #} else {#
    <strong>Nome:</strong> #=model.Nome#
    #}#
    <br />
    #if(model.Observacoes != null) {#
    <strong>Observações:</strong> #=model.Observacoes#
    #}#
    #} else {#
    <strong>Sem informação</strong>
    #}#
</script>