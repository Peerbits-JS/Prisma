@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@ModelType Oticas.DocumentosVendas

@Code
    Dim boolTemAcessoAnexos As Boolean = ClsF3MSessao.TemAcessoPorDescricao(AcoesFormulario.Consultar, Modelos.Constantes.Menus.ComprasAnexos)
    Dim AcaoForm As AcoesFormulario = Model.AcaoFormulario
End Code

<div class="f3m-lateral-botoes @(If(AcaoForm = AcoesFormulario.Adicionar, CssClasses.Hidden, String.Empty))">
    <ul>
        <li>
            <div class="spriteLayout anexos AsideIconsPosition">
                <a class="anexContainer btn main-btn @(If(boolTemAcessoAnexos, String.Empty, CssClasses.Hidden))" title="@Traducao.EstruturaAplicacaoTermosBase.Anexos">
                    <span class="badge badge-anexos hidden"></span><span class="fm f3icon-paperclip"></span>
                </a>
            </div>
        </li>
        <li>
            <div class="spriteLayout  AsideIconsPosition">
                <a id="pagamento" class="btn btn-line btn-barra InativaOnDirty" title="@Traducao.EstruturaAplicacaoTermosBase.Pagar">PG</a>
            </div>
        </li>
        <li>
            <div class="spriteLayout  AsideIconsPosition">
                <a id="editarPagamento" class="btn btn-line btn-barra" title="@Traducao.EstruturaAplicacaoTermosBase.Recebimentos">RC</a>
            </div>
        </li>

        @Code
            'VALIDA QUANDO APARECE O BOTAO PARA CRIAR / CONSULTAR AS NCS TO DOC VENDA (EFETIVO, DOC FINANCEIRO E EM FTs, FSs e FRs)
            With Model
                If .CodSistemaTipoEstado = TiposEstados.Efetivo AndAlso
                    .Adiantamento <> True AndAlso
                    .CodigoSistemaTiposDocumento = TiposSistemaTiposDocumento.VendasFinanceiro AndAlso
                    (.TipoSistemaTipoDocumentoFiscal = TiposDocumentosFiscal.Fatura OrElse
                    .TipoSistemaTipoDocumentoFiscal = TiposDocumentosFiscal.FaturaSimplificada OrElse
                    .TipoSistemaTipoDocumentoFiscal = TiposDocumentosFiscal.FaturaRecibo) Then

                    @<li>
                        <div class="spriteLayout  AsideIconsPosition">
                            <a id="notacredito" class="btn main-btn InativaOnDirty" title="@Traducao.EstruturaAplicacaoTermosBase.NotaDeCredito">NC</a>
                        </div>
                    </li>

                End If
            End With
        End Code
    </ul>
</div>