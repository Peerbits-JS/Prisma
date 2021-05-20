@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@ModelType Oticas.Clientes
@Code
    Dim AcaoForm As AcoesFormulario = Model.AcaoFormulario
    Dim boolTemAcessoAnexos As Boolean = ClsF3MSessao.TemAcessoPorDescricao(AcoesFormulario.Consultar, Menus.ClientesAnexos)
End Code

<div class="f3m-lateral-botoes @(If(AcaoForm <> AcoesFormulario.Adicionar, String.Empty, CssClasses.Hidden))">
    <ul>
        <li>
            <div class="spriteLayout AsideIconsPosition anexos">
                <a class="anexContainer btn main-btn @(If(boolTemAcessoAnexos, String.Empty, CssClasses.Hidden))" title="@Traducao.EstruturaAplicacaoTermosBase.Anexos">
                    <span class="badge badge-anexos hidden"></span><span class="fm f3icon-paperclip"></span>
                </a>
            </div>
        </li>
        <li>
            <div class="spriteLayout AsideIconsPosition">
                <a id="NovoServico" class="btn btn-line btn-barra InativaOnDirty" title="@Traducao.EstruturaAplicacaoTermosBase.NovoServico">SV</a>
            </div>
        </li>
        <li>
            <div class="spriteLayout AsideIconsPosition">
                <a id="NovoDocVenda" class="btn btn-line btn-barra InativaOnDirty" title="@Traducao.EstruturaAplicacaoTermosBase.NovoDocumentoVenda">FT</a>
            </div>
        </li>
        <li>
            <div class="spriteLayout AsideIconsPosition">
                <a id="contacorrente" class="btn main-btn InativaOnDirty" title="@Traducao.EstruturaAplicacaoTermosBase.ContaCorrente">CC</a>
            </div>
        </li>
        <li>
            <div class="spriteLayout AsideIconsPosition">
                <a id="fichaconsentimento" class="btn main-btn InativaOnDirty" title="@Traducao.EstruturaAplicacaoTermosBase.FichaConsentimento">FC</a>
            </div>
        </li>
        @*<li>
            <div class="spriteLayout AsideIconsPosition email">
                <a id="EnvioEmail" class="btn main-btn InativaOnDirty" title="Envia Email">
                    <span class="fm f3icon-fm f3icon-envelope"></span>
                </a>
            </div>
        </li>*@
    </ul>
</div>