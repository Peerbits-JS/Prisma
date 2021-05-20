@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Base
@Imports F3M.Modelos.Componentes
@Code

End Code
<div class="lateral-fechada">
    <h4 class="text-center"><span class="fm @Model.LateralDirFechadaIcon"></span></h4>
    <div class="txt-resumo">@Model.LateralDirPrimeiroTxtResumo 
        <span class="badge badge-pill badge-secondary mr-3">@Model.LateralDirPrimeiroBadge</span> @Model.LateralDirSegundoTxtResumo 
        <span class="badge badge-pill badge-secondary mr-3">@Model.LateralDirSegundoBadge</span> @Model.LateralDirTerceiroTxtResumo 
        <span class="badge badge-pill badge-secondary mr-3">@Model.LateralDirTerceiroBadge</span>
    </div>
</div>