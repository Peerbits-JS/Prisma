@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Modeltype Components

@Code
    Dim UrlComponentesEngine As String = "~/Areas/Exames/Views/ExamesCustomizacao/Componentes/F3MEngine/F3MDesenhaComponentes.vbhtml"
End Code

<!-- SONS ENGINE START -->
@*@For intCol As Integer = 1 To 12
    Dim son2 As List(Of Components) = Model.ListOfComponentesFilhos.Where(Function(w)
                                                                              Return Not w.StartRow Is Nothing AndAlso Not w.StartCol Is Nothing AndAlso w.StartCol = intCol
                                                                          End Function).ToList

    If son2 IsNot Nothing AndAlso son2.Count Then
        @Html.Partial(UrlComponentesEngine, son2)
        intCol = son2.FirstOrDefault().EndCol

    Else
    End If
Next*@

@Html.Partial(UrlComponentesEngine, Model.ListOfComponentesFilhos)