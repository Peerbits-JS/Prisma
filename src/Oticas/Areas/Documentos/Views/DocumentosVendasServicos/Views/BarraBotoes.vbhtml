@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Modeltype Oticas.DocumentosVendasServicos
@Code
    Dim AcaoForm As AcoesFormulario = Model.AcaoFormulario
    Dim boolTemAcessoAnexos As Boolean = ClsF3MSessao.TemAcessoPorDescricao(AcoesFormulario.Consultar, Menus.DocumentosVendasServicosAnexos)
    Dim boolTemAcessoAdiantamentos As Boolean = ViewBag.blnAdiantamentos

    Dim strDisabledEntidade2 As String = AtributosHTML.Disabled
    Dim strDisabledPagamentos As String = AtributosHTML.Disabled

    If AcaoForm <> AcoesFormulario.Adicionar Then
        If Model.CodigoTipoEstado <> TiposEstados.Rascunho AndAlso Not Model.IDEntidade2 Is Nothing AndAlso Model.IDEntidade2 <> 0 AndAlso Model.TotalEntidade2 <> 0 Then
            strDisabledEntidade2 = String.Empty
        End If
    End If
End Code

<div class="f3m-lateral-botoes @(If(AcaoForm = AcoesFormulario.Adicionar, CssClasses.Hidden, String.Empty))">
    <ul>
        @*BOTAO ANEXOS*@
        <li>
            <div class="spriteLayout anexos AsideIconsPosition">
                <a class="anexContainer btn main-btn @(If(boolTemAcessoAnexos, String.Empty, CssClasses.Hidden))" title="@Traducao.EstruturaAplicacaoTermosBase.Anexos">
                    <span class="badge badge-anexos hidden"></span><span class="fm f3icon-paperclip"></span>
                </a>
            </div>
        </li>
        @Code
            If Not ViewBag.BlnExitemEntidade1ou2 AndAlso Not ViewBag.BlnExistemDocsAssociados Then
                @*BOTAO ADIANTAMENTOS*@
                @<li>
                    <div class="spriteLayout  AsideIconsPosition">
                        <a id="adiantamentos" class="btn btn-line btn-barra InativaOnDirty adiantamentoPagamento @(If(boolTemAcessoAdiantamentos, String.Empty, CssClasses.Hidden))" title="@Traducao.EstruturaAplicacaoTermosBase.Adiantamentos">AD</a>
                    </div>
                </li>
            Else
                If ViewBag.BlnExistemDocsAssociados Then strDisabledPagamentos = String.Empty
                @*BOTAO PAGAMENTOS*@
                @<li>
                    <div class="spriteLayout  AsideIconsPosition">
                        <a id="pagamentos" class="btn btn-line btn-barra InativaOnDirty adiantamentoPagamento @strDisabledPagamentos" title="@Traducao.EstruturaAplicacaoTermosBase.Pagamentos">PG</a>
                    </div>
                </li>
            End If
        End Code
        @*BOTAO DOC VENDA*@
        <li>
            <div class="spriteLayout AsideIconsPosition">
                <a id="documentoVenda" class="btn btn-line btn-barra InativaOnDirty" title="@Traducao.EstruturaAplicacaoTermosBase.DocumentoDeVenda">FT</a>
            </div>
        </li>
        @*BOTAO FATURA 2*@
        <li>
            <div class="spriteLayout AsideIconsPosition">
                <a id="entidade2" class="btn main-btn @strDisabledEntidade2" title="@Traducao.EstruturaAplicacaoTermosBase.DocumentoVendaEntidade2">FT<sub style="margin-left: 2px;">2</sub></a>
            </div>
        </li>
    </ul>
</div>