@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@ModelType MedicosTecnicos
@Code
    Dim AcaoForm As Int16 = Model.AcaoFormulario
    Dim boolTemAcessoAnexos As Boolean = ClsF3MSessao.TemAcessoPorDescricao(AcoesFormulario.Consultar, Menus.MedicosTecnicosAnexos)

    ViewBag.VistaParcial = True

    @<div class="@(ClassesCSS.FormPrinc) @IIf(AcaoForm <> AcoesFormulario.Adicionar, ClassesCSS.ComBts, String.Empty)">
        <div class="FormularioAjudaScroll">
            @Html.Partial("DetalheComum", Model)
        </div>
    </div>
    @<div class="f3m-lateral-botoes @IIf(AcaoForm = AcoesFormulario.Adicionar, " hidden ", String.Empty) ">
        <ul>
            <li>
                <div class="spriteLayout anexos AsideIconsPosition">
                    <a id="btnAnexos" class="anexContainer btn main-btn @IIf(boolTemAcessoAnexos, String.Empty, "hidden")" title="Anexos">
                        <span class="badge badge-anexos hidden"></span>
                        <span class="fm f3icon-paperclip"></span>
                    </a>
                </div>
            </li>
        </ul>
    </div>
End Code