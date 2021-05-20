@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Code
    Dim simbMoedaAux As String = " " & Model.Simbolo
    Dim casasDecTotais As Byte = ClsF3MSessao.RetornaParametros.MoedaReferencia.CasasDecimaisTotais
End Code

<div>
    <strong>
        <span class="soma-resumo-valor" id="Resumo">@(FormatNumber(Model.TotalMoedaDocumento, casasDecTotais) & simbMoedaAux)</span>
        <span class="Currency soma-resumo-valor">&nbsp;</span>
    </strong>
    <span>@(Traducao.EstruturaAplicacaoTermosBase.Totais)</span>
</div>