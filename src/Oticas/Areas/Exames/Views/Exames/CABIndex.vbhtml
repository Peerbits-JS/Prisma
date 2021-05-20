@Code
    Dim data As String = String.Empty
    If Me.Context.Request.QueryString("DataMarcacao") IsNot Nothing Then
        data = Me.Context.Request.QueryString("DataMarcacao")
    End If

    If String.IsNullOrEmpty(data) Then
        data = DateAndTime.Now.ToString("dd/MM/yyyy")
    End If
End Code

<div class="tableheader-sem-lista clearfix">
    <div class="float-left">
        <input id="data" class="" value="@data" title="@Traducao.EstruturaAplicacaoTermosBase.Data" />
    </div>
    <div class="float-right">
        <button id="btnNovaConsulta" type="button" class="btn f3m-btn-outline-secondary btn-sm">
            <span class="fm f3icon-calendar-plus-o"></span>
            &nbsp;
            @Traducao.EstruturaExames.AgendarConsulta
        </button>
        <button id="btnRefresh" type="button" class="btn f3m-btn-outline-secondary btn-sm " title="@Traducao.EstruturaAplicacaoTermosBase.TOOLTIPAtualizar">
            <span class="fm f3icon-refresh"></span>
        </button>
    </div>
</div>