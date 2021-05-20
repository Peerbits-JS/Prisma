@Modeltype Components

<!-- DESENHA CABECALHO -->
<div class="row desContainer">
    @Code
        For intCol As Integer = 1 To 12
            Dim component As List(Of Components) = Model.ListOfComponentesFilhos.Where(Function(w) w.StartCol = intCol).ToList

            If component IsNot Nothing AndAlso component.Count Then
                @Html.Partial("~/Areas/Exames/Views/ExamesCustomizacao/Componentes/F3MLogic/F3MDesenhaJanela.vbhtml", component)
                intCol = component.FirstOrDefault().EndCol

            Else
                @<div class="col-f3m col-1" style="visibility: hidden"></div>
            End If
        Next
    End Code
</div>