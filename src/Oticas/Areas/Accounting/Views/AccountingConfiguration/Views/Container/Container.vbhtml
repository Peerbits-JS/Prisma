@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Modeltype Oticas.AccountingConfiguration

@Code
    Dim classeHiddenOnCopyMode As String = ""
    If Model.IsCopyMode Then
        classeHiddenOnCopyMode = " hidden"
    End If

    @<div id="container">
        @If Model.ID <> 0 OrElse Model.IsCopyMode Then

            Select Case Model.ModuleCode
                Case "008"
                    @Html.Partial("Views/Container/Entities/Entities", Model)

                Case Else
                    @Html.Partial("Views/Container/DocumentTypes/DocumentTypes", Model)
            End Select
        End If
    </div>

    If Model.ID = 0 Then
        @<span id="span-sem-linhas" class='texto-sem-linhas clsF3MSemLinhas @classeHiddenOnCopyMode'>
            @Traducao.EstruturaContabilidadeConfiguracao.IniciarNovaConfiguracao
        </span>
    End If
End Code