@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Modeltype Oticas.Areas.Etiquetas.Models.Etiquetas
@Code
    Dim F3MBarLoading As String = F3M.Modelos.Constantes.URLs.F3MFrontEndComponentes & "BarLoading.vbhtml"
End Code

@Styles.Render("~/Content/handsontablestyle")
@Scripts.Render("~/bundles/handsontable")
@Scripts.Render("~/bundles/f3m/jsEtiquetas")

<div class="row form-container">
    <div class="@ClassesCSS.XS2">
        <label for="Entidade">@Traducao.EstruturaAplicacaoTermosBase.Modelo</label>
        <select class="form-control" id="Entidade" style="height: 30px; padding-top: 4px;">
            <option id="Etiquetas_A4_2_Colunas">A4 - 2 Colunas</option>
            <option id="Etiquetas_A4_5_Colunas">A4 - 5 Colunas</option>
            <option id="Etiquetas_A4_6_Colunas">A4 - 6 Colunas</option>
            <option id="Etiquetas_Rolo">Rolo</option>
        </select>
    </div>
    <div id="OpcaoA4" class="col-10">
        <div class="row">
            <div class="col-3">
                <span class="indicativo-input" title="Linha">
                    <span class="label-btn-acoes">
                        <span>Linha</span>
                    </span>
                </span>
                @Code
                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Linha",
                    .Label = Traducao.EstruturaAplicacaoTermosBase.InicioImpressao,
                    .Modelo = Model,
                    .ValorMinimo = 1,
                    .ValorMaximo = 99})
                end code
            </div>
            <div class="col-3">
                <span class="indicativo-input em-formul-group" title="Coluna">
                    <span class="label-btn-acoes">
                        <span>Coluna</span>
                    </span>
                </span>
                @Code
                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Coluna",
                                    .Label = "&nbsp;",
                                    .Modelo = Model,
                                    .ValorMinimo = 1,
                                    .ValorMaximo = 2})
                End Code
            </div>
        </div>
    </div>
</div>
<label for="hdsnArtigos">@Traducao.EstruturaAplicacaoTermosBase.Artigos</label>
@* L O A D I N G *@
@Html.Partial(F3MBarLoading)
<div class="@(ConstHT.ClassesHT.Container)">
    <div id="hdsnArtigos"></div>
</div>

<script>
    EtiquetasConstroiHT(@Html.Raw(Json.Encode(Model.EtiquetasArtigos)))
</script>