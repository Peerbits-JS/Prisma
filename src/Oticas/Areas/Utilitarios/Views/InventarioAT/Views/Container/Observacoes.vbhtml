@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Modeltype Oticas.InventarioAT

<div role="tabpanel" Class="tab-pane fade" id="tabObservacoes">
    <div Class="obs-holder">
        @Code
            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Observations",
                    .Label = Traducao.EstruturaAplicacaoTermosBase.Observacoes,
                    .TipoEditor = Mvc.Componentes.F3MTextArea,
                    .Modelo = Model,
                    .CampoValor = "Texto",
                    .EEditavel = Model.IsEnabled(),
                    .ControladorAccaoExtra = URLs.Areas.TabAux & F3M.Modelos.Constantes.Menus.TextosBase & "/IndexGrelha"})
        End Code
    </div>
</div>