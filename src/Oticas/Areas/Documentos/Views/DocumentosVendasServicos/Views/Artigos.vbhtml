@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Code
    Dim F3MBarLoading As String = URLs.F3MFrontEndComponentes & "BarLoading.vbhtml"
    Html.F3M().Hidden("ServicosArtigos", True)
    Html.F3M().Hidden("F3MListView", True)
End Code

<div role="tabpanel" class="tab-pane fade" id="tabArtigos">
    @* LOADING *@
    @Html.Partial(F3MBarLoading)
    <div class="@(ConstHT.ClassesHT.Container)">
        <div id="hdsnArtigos"></div>
    </div>
    @*FLOATING DIV DATAS*@
    <div id="elemFloatingEntregaArtigos" class="float-left def-resumo clsF3MElemFloating">
        <a class="clsF3MElemFloatingText" title="Configurações">
        </a>
        <div class="set-resumo  abre-dir" style="right: 22px;">
            <div class="row form-container">
                @Code
                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "DataEntregaLongeAux",
                        .Label = Traducao.EstruturaDocumentos.DataEntregaLonge,
                        .TipoEditor = Mvc.Componentes.F3MDataTempo,
                        .Modelo = Model.Modelo,
                        .ViewClassesCSS = {ClassesCSS.XS6}})

                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "DataEntregaPertoAux",
                        .Label = Traducao.EstruturaDocumentos.DataEntregaPerto,
                        .TipoEditor = Mvc.Componentes.F3MDataTempo,
                        .Modelo = Model.Modelo,
                        .ViewClassesCSS = {ClassesCSS.XS6}})
                End Code
            </div>
        </div>
    </div>
</div>