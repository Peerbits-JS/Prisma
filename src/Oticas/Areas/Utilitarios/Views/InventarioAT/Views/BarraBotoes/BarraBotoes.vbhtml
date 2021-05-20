@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Modeltype Oticas.InventarioAT

@Code
    Dim AcaoForm As Int16 = Model.AcaoFormulario
End Code

<div class="f3m-lateral-botoes @(If(AcaoForm = AcoesFormulario.Adicionar, " hidden ", String.Empty))">
    <ul>
        <li>
            <div class="spriteLayout  AsideIconsPosition anexos">
                <a id="btnAnexos" class="anexContainer btn main-btn" title="@(Traducao.EstruturaAplicacaoTermosBase.TOOLTIPAnexos)">
                    <span class="badge badge-anexos hidden"></span><span class="fm f3icon-paperclip"></span>
                </a>
            </div>
        </li>
    </ul>
</div>