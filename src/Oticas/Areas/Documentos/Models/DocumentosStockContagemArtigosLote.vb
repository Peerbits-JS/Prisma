Imports F3M.Modelos.Base

Public Class DocumentosStockContagemArtigosLote
    Inherits ClsF3MModelo

    Public Property Codigo As String
    Public Property Descricao As String

    Public Sub New(iD As Long, descricao As String, codigo As String,
                   ativo As Boolean, sistema As Boolean?, dataCriacao As Date,
                   dataAlteracao As Date?, utilizadorCriacao As String, utilizadorAlteracao As String,
                   f3MMarcador() As Byte)

        Me.ID = iD
        Me.Descricao = descricao
        Me.Codigo = codigo
        Me.Ativo = ativo
        Me.Sistema = sistema
        Me.DataCriacao = dataCriacao
        Me.DataAlteracao = dataAlteracao
        Me.UtilizadorCriacao = utilizadorCriacao
        Me.UtilizadorAlteracao = utilizadorAlteracao
        Me.F3MMarcador = f3MMarcador
    End Sub

    Public Sub New()

    End Sub

    Public Shared Function Criar(lote As tbArtigosLotes) As DocumentosStockContagemArtigosLote

        If (lote Is Nothing) Then
            Return New DocumentosStockContagemArtigosLote()
        End If

        Return New DocumentosStockContagemArtigosLote(lote.ID, lote.Descricao, lote.Codigo,
                                                     lote.Ativo, lote.Sistema, lote.DataCriacao,
                                                     lote.DataAlteracao, lote.UtilizadorCriacao, lote.UtilizadorAlteracao,
                                                     lote.F3MMarcador)
    End Function
End Class
