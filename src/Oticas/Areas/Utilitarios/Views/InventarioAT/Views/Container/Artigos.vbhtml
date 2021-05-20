@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Modeltype Oticas.InventarioAT

@Code
    Dim F3MBarLoading As String = URLs.F3MFrontEndComponentes & "BarLoading.vbhtml"
End Code

<div role="tabpanel" Class="tab-pane fade" id="tabArtigos">
    <div Class="obs-holder">  

        <div class="clsF3MHadnsontable">
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

    </div>
</div>

<div id="drag-and-drop-zone" class="hidden">
    <input id="ContagemUpload" type="file" name="files[]" multiple="multiple">
</div>