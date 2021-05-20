@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Modeltype Oticas.DocumentosStockContagem

@Code
    Dim AcaoForm As Int16 = Model.AcaoFormulario
End Code

<div class="f3m-lateral-botoes @(If(AcaoForm = AcoesFormulario.Adicionar, " hidden ", String.Empty))">
    <ul>
        <li>
            <div class="spriteLayout  AsideIconsPosition anexos">
                <a id="btnAnexos" class="anexContainer btn main-btn @Model.AttrTemAcessoAnexos" title="@(Traducao.EstruturaAplicacaoTermosBase.TOOLTIPAnexos)">
                    <span class="badge badge-anexos hidden"></span><span class="fm f3icon-paperclip"></span>
                </a>
            </div>
        </li>
        <li>
            <div class="spriteLayout AsideIconsPosition">
                <a id="btnEfetivar" class="btn btn-line btn-barra @Model.AttrButtonEfetivar" title="@Traducao.EstruturaDocumentosStockContagem.Efetivar">EFT</a>
            </div>
        </li>
    </ul>
</div>