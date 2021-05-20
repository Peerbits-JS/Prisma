@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Modeltype Oticas.DocumentosStockContagem

@Code
    Dim F3MBarLoading As String = URLs.F3MFrontEndComponentes & "BarLoading.vbhtml"

    Dim clsHiddenHandsontable As String = " hidden"
    Dim clsHiddenSemArmazemLocalizacao As String = String.Empty

    If Not Model.IDLocalizacao Is Nothing AndAlso Model.IDLocalizacao <> 0 Then
        clsHiddenHandsontable = String.Empty
        clsHiddenSemArmazemLocalizacao = " hidden"
    End If
End Code

<div role="tabpanel" Class="tab-pane fade" id="tabArtigos">
    <div Class="obs-holder">  

        <div class="clsF3MHadnsontable @clsHiddenHandsontable">
            <div class="f3m-top submenu clearfix">
                <div class="float-left f3m-top__left">
                    <label>@Traducao.EstruturaDocumentosStockContagem.Artigos&nbsp;</label>
                    <div id="group" class="btn-group btn-group-toggle " data-toggle="buttons">
                        <label class="btn f3m-btn-xs btn-line active">
                            <input type="radio" id="opTodos" name="optionsArtigos" autocomplete="off" checked="checked">@Traducao.EstruturaDocumentosStockContagem.Todos
                        </label>
                        <label class="btn f3m-btn-xs btn-line">
                            <input type="radio" id="opContados" name="optionsArtigos" autocomplete="off">@Traducao.EstruturaDocumentosStockContagem.Contados
                        </label>
                        <label class="btn f3m-btn-xs btn-line">
                            <input type="radio" id="opComDiferencas" name="optionsArtigos" autocomplete="off">@Traducao.EstruturaDocumentosStockContagem.ComDiferencas
                        </label>
                    </div>
                </div>

                <div class="float-right f3m-top__right ">
                    <button id="btnContar" type="button" class="btn f3m-btn-xs main-btn" @Model.AttrButtons()>@Traducao.EstruturaDocumentosStockContagem.Contar</button>
                    <button id="importar-artigos-contagem" type="button" class="btn f3m-btn-xs main-btn" @Model.AttrButtons()>@Traducao.EstruturaDocumentosStockContagem.ImportarContagem</button>
                    <button id="btnAtualizar" type="button" class="btn f3m-btn-xs main-btn" @Model.AttrButtons()>
                        <span title="@Traducao.EstruturaDocumentosStockContagem.Atualizar" class="fm f3icon-refresh"></span>
                    </button>
                </div>
            </div>

            @*<div class="table-holder handson-table">*@
            <div id="procura" class="handson-pesquisa f3m-input-icon f3m-input-icon--left">
                <form action="#">
                    <input type="text" id="search_field" class="form-control input-sm" placeholder="@(Traducao.EstruturaAplicacaoTermosBase.Pesquisa)">
                    <span class="fm f3icon-search2 form-control-feedback" aria-hidden="true"></span>
                </form>
            </div>
            @* LOADING *@
            @Html.Partial(F3MBarLoading)
            <div class="@(ConstHT.ClassesHT.Container)">
                <div id="hdsnArtigos"></div>
            </div>
        </div>

        <span class="texto-sem-linhas clsF3MSemArmazemLocalizacao @clsHiddenSemArmazemLocalizacao">
            @Traducao.EstruturaDocumentosStockContagem.SemLinhas<br />
            @Traducao.EstruturaDocumentosStockContagem.IndicarArmazemLocalizacao
        </span>
    </div>
</div>

<div id="drag-and-drop-zone" class="hidden">
    <input id="ContagemUpload" type="file" name="files[]" multiple="multiple">
</div>

<style>
    .handson-container {
        border: 0.1px solid #ccc;
    }
</style>