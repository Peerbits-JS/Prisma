@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Utilitarios
@Code
    Dim lst As New List(Of Oticas.ArtigosLentesOftalmicasSuplementos)
    lst = ViewBag.Suplementos
End Code

@Code
If Not IsNothing(lst) Then
End Code
<div class="col-3">
    <label>@Traducao.EstruturaArtigos.Suplementos</label>
    <div class="arrayChecks" style="height:200px; overflow-y:auto; overflow-x:hidden">
        @Code
                For Each lin In lst
        End Code
        <div class="checkbox">
            <label>
                <input type="checkbox" class="clsF3MInput supsClass" name="@lin.IDSuplementoLente" id="@lin.IDSuplementoLente"
                       @Code If lin.ID <> 0 Then End Code
                       checked="checked">
                @Code
                Else
                End Code
                >
                @Code
                End If
                End Code
                @lin.DescricaoSuplementoLente
            </label>
        </div>
        @Code
                Next
        End Code
    </div>
</div>
@Code
End If
End Code