Imports F3M.Modelos.Base

Public Class DocumentosStockContagemArtigosUnidade
    Inherits ClsF3MModelo

    Public Property Codigo As String
    Public Property Descricao As String

    Public Sub New(iD As Long, codigo As String, descricao As String, ativo As Boolean, sistema As Boolean, dataCriacao As Date, dataAlteracao As Date?, utilizadorCriacao As String, utilizadorAlteracao As String, f3MMarcador() As Byte)
        Me.ID = iD
        Me.Codigo = codigo
        Me.Descricao = descricao
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

    Friend Shared Function Criar(unidade As tbUnidades) As DocumentosStockContagemArtigosUnidade

        If (unidade Is Nothing) Then
            Return New DocumentosStockContagemArtigosUnidade()
        End If

        Return New DocumentosStockContagemArtigosUnidade(unidade.ID, unidade.Codigo, unidade.Descricao,
                                                        unidade.Ativo, unidade.Sistema, unidade.DataCriacao,
                                                        unidade.DataAlteracao, unidade.UtilizadorCriacao, unidade.UtilizadorAlteracao,
                                                        unidade.F3MMarcador)
    End Function
End Class
