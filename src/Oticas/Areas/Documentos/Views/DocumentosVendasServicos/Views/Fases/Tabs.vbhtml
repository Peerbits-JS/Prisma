@Modeltype Oticas.DocumentosVendasServicos

@Code

    @<div id="estadosloader" class="circle-loader float-right hidden">
        <div class="checkmark draw"></div>
    </div>

    @<ul class="nav nav-pills f3m-tabs__ul" role="tablist">
        @For index As Integer = 0 To Model.ServicoFases.Count - 1
            Dim sv As Oticas.ServicosFases = Model.ServicoFases(index)
            Dim tabId As String = "tabServicosFases_" & sv.IDServico & sv.IDTipoServico

            @<li role="presentation" class="nav-item">
                <a href="#@(tabId)" class="nav-link clsF3MTabEstados" role="tab" data-toggle="tab" aria-expanded="true">@sv.Descricao</a>
            </li>
        Next
    </ul>
End Code