@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Modeltype Oticas.DocumentosVendasServicos

@Code
    Dim acaoForm As AcoesFormulario = Model.AcaoFormulario
    Dim trocaAcaoForm As Boolean = False

    'TROCA ACAO FORM PARA PODER EDITAR AS OBSERVACOES
    If Model.ID <> 0 AndAlso Model.RegistoBloqueado AndAlso Model.AcaoFormulario = AcoesFormulario.Consultar Then
        trocaAcaoForm = True
        Model.AcaoFormulario = AcoesFormulario.Alterar
    End If

End Code

<div role="tabpanel" Class="tab-pane fade" id="tabObservacoes">
    <div Class="obs-holder">
        @Code
            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = CamposGenericos.Observacoes,
                    .Label = Traducao.EstruturaAplicacaoTermosBase.Observacoes,
                    .AcaoFormulario = acaoForm,
                    .TipoEditor = Mvc.Componentes.F3MTextArea,
                    .Modelo = Model,
                    .ControladorAccaoExtra = URLs.Areas.TabAux & F3M.Modelos.Constantes.Menus.TextosBase & "/IndexGrelha",
                    .CampoValor = "Texto",
                    .EEditavel = True,
                    .IgnoraBloqueioAssinatura = True})

            'REPOE ACAO FORM
            If trocaAcaoForm Then Model.AcaoFormulario = AcoesFormulario.Consultar
        End Code
    </div>
</div>