Public Class DocumentosStockContagemFiltro
    Public Property NaoMovimentados As Boolean = True
    Public Property Inativos As Boolean = True
    Public Property IDTipoArtigo As List(Of Long)
    Public Property IDMarca As List(Of Long)
    Public Property DataDocumento As Date?
    Public Property IDArmazem As Double?
    Public Property IDLocalizacao As Double?

    Sub New()
        IDTipoArtigo = New List(Of Long)
        IDMarca = New List(Of Long)
    End Sub

    Function RetornaBadgeLadoEsqOutro() As Short
        Dim _count As Short = 0

        If NaoMovimentados Then _count += 1
        If Inativos Then _count += 1

        Return _count
    End Function

    Function RetornaBadgeMarca() As Short
        Dim _count As Short = 0

        If Not IDMarca Is Nothing Then
            _count = IDMarca.Count()
        End If

        Return _count
    End Function

    Function RetornaBadgeTipoArtigo() As Short
        Dim _count As Short = 0

        If Not IDTipoArtigo Is Nothing Then
            _count = IDTipoArtigo.Count()
        End If

        Return _count
    End Function

End Class
