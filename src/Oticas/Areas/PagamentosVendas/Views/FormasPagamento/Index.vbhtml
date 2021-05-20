@Code
    Dim ListOfVendasFormasPagamentos As List(Of PagamentosVendasFormasPagamento) = ViewBag.ListOfVendasFormasPagamentos
    Dim Moeda As Moedas = ViewBag.Moeda
    Dim Opcao = ViewBag.Opcao
    Dim ValorPagoNumerario As Double = ViewBag.ValorPagoNumerario

    Dim SimboloMoeda As String = Moeda.Simbolo
    Dim CasasDecimais As Byte = Moeda.CasasDecimaisTotais

    If ListOfVendasFormasPagamentos IsNot Nothing AndAlso ListOfVendasFormasPagamentos.Count > 0 Then
        @<form>
            @For Each lin In ListOfVendasFormasPagamentos
                @<div class=form-group>
                    <div class="input-group f3m-input-group">
                        <!--descrição das formas de pagamento-->
                        <div class="input-group-prepend f3m-input-group__prepend">
                            <label class="input-group-text f3m-input-group__text f3m-input-group__text--width-fixed text-left text-uppercase" title="@lin.DescricaoFormaPagamento">@lin.DescricaoFormaPagamento</label>
                        </div>

                        @If Opcao = "recebimentos" Then
                            @<!--valor das formas de pagamento-->
                            @<input type="text" value=@FormatNumber(lin.Valor, CasasDecimais) class="form-control text-right" disabled="disabled">
                            @<a class="input-group-prepend disabled"><span class="input-group-text f3m-input-group__text fm f3icon-moedas"></span></a>

                        Else
                            If ValorPagoNumerario <> 0 AndAlso lin.CodigoSistemaTipoFormaPagamento = "NU" Then
                                Dim val As String = ValorPagoNumerario.ToString().Replace(",", ".")
                                @<input id="@lin.IDFormaPagamento" type="number" step="0.01" value="@val" min="@val" class="form-control text-right FormPag">

                            Else
                                @<input id="@lin.IDFormaPagamento" type="number" step="0.01" value="0.00" min="0.00" class="form-control text-right FormPag">
                            End If

                            @<a class="input-group-prepend Distribuicao" style="color:#0098d2;"><span class="input-group-text f3m-input-group__text fm f3icon-moedas"></span></a>
                        End If
                    </div>
                </div>
            Next
        </form>
    End If
End Code