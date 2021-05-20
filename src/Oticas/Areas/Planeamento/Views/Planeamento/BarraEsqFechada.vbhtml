@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Base
@Imports F3M.Modelos.Componentes
@Code

End Code
<div class="lateral-fechada">
    <h4 class="text-center"><span class="fm @Model.LateralEsqFechadaIcon"></span></h4>
    <div class="txt-resumo">@Model.LateralEsqPrimeiroTxtResumo 
        <span id="badgeLojas" class="badge badge-pill badge-secondary mr-3">@Model.LateralEsqPrimeiroBadge</span> @Model.LateralEsqSegundoTxtResumo 
        <span id="badgeMedicosTecnicos" class="badge badge-pill badge-secondary mr-3">@Model.LateralEsqSegundoBadge</span>
    </div>
</div>