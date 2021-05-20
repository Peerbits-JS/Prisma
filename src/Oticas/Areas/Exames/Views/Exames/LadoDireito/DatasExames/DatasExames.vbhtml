@Modeltype List(Of Oticas.HistoricoExamesDatas)

@Code
    Dim strDisabled As String = String.Empty
    If Model.Count = 0 Then strDisabled = " disabled"
End Code

<div class="text-center">
    <div class="input-group mb-3 mt-2">
        <div class="input-group-prepend">
            <button id="btnPreviousDate" class="btn main-btn mr-1 rounded-circle f3m-plr-10" type="button" @strDisabled>
                <span class="fm f3icon-arrow-left"></span>
            </button>
        </div>
        <select id="IDDatasExames" class="form-control  lado-direito-historico-datas" @strDisabled>
            @Code
                If Model.Count Then
                    For Each item As HistoricoExamesDatas In Model
                        @<option id="@item.IDExame">@item.DataExame.ToString("dd/MM/yyyy HH:mm")</option>
                    Next

                Else
                    @<option id="0" selected @strDisabled>---</option>
                End If
            End Code
        </select>
        <div class="input-group-append">
            <button id="btnNextDate" class="btn main-btn ml-1 rounded-circle f3m-plr-10" type="button" @strDisabled>
                <span class="fm f3icon-arrow-right"></span>
            </button>
        </div>
    </div>
</div>