Imports F3M.Modelos.Repositorio

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioPrecosLentes
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbPrecosLentes, PrecosLentes)

        Sub New()
            MyBase.New()
        End Sub


        Public Function PrecosLentesPorModeloTratamento(ByVal idModelo As Long, ByVal idTratamento As Long?, ByVal diametroDe As Double, ByVal diametroAte As Double, Optional ByVal raio As Double? = Nothing) As List(Of PrecosLentes)
            Dim precosLentes As New List(Of PrecosLentes)

            Dim diametroDeDB As String = If(diametroDe Mod 1 > 0, diametroDe.ToString("0.00", Globalization.CultureInfo.InvariantCulture), diametroDe.ToString("0", Globalization.CultureInfo.InvariantCulture))
            Dim diametroAteDB As String = If(diametroAte Mod 1 > 0, diametroAte.ToString("0.00", Globalization.CultureInfo.InvariantCulture), diametroAte.ToString("0", Globalization.CultureInfo.InvariantCulture))
            Dim raioDB As String = If(raio IsNot Nothing, CDbl(raio).ToString("0.00", Globalization.CultureInfo.InvariantCulture), "0")

            Dim dbSetPrecosLentes As New List(Of tbPrecosLentes)
            If raio IsNot Nothing Then
                dbSetPrecosLentes = tabela.AsNoTracking _
                        .Where(Function(pl) _
                            pl.IDModelo = idModelo) _
                        .ToList
            Else

                dbSetPrecosLentes = tabela.AsNoTracking _
                        .Where(Function(pl) _
                            pl.IDModelo = idModelo AndAlso
                            pl.IDTratamentoLente = idTratamento AndAlso
                            Not String.IsNullOrEmpty(pl.DiamDe) AndAlso Not String.IsNullOrEmpty(pl.DiamAte) AndAlso
                            ((diametroDe >= pl.DiamDe AndAlso diametroDe <= pl.DiamAte) OrElse
                            (diametroAte >= pl.DiamDe AndAlso diametroAte <= pl.DiamAte) OrElse
                            (diametroDe <= pl.DiamDe AndAlso diametroAte >= pl.DiamAte)) AndAlso
                            pl.Raio = raioDB) _
                        .ToList
            End If

            For Each precoLenteDB In dbSetPrecosLentes
                Dim precoLente As New PrecosLentes With {
                    .PotEsfDe = If(precoLenteDB.PotEsfDe, 0.0),
                    .PotEsfAte = If(precoLenteDB.PotEsfAte, 0.0),
                    .PotCilDe = If(precoLenteDB.PotCilDe, 0.0),
                    .PotCilAte = If(precoLenteDB.PotCilAte, 0.0),
                    .PrecoVenda = If(precoLenteDB.PrecoVenda, 0.0),
                    .PrecoCusto = If(precoLenteDB.PrecoCusto, 0.0)
                }

                Double.TryParse(precoLenteDB.DiamDe.Replace(".", ","), precoLente.DiamDe)
                Double.TryParse(precoLenteDB.DiamAte.Replace(".", ","), precoLente.DiamAte)

                precosLentes.Add(precoLente)
            Next

            Return precosLentes
        End Function

        Public Sub GuardaAlteracoesMatrizPrecos(ByRef matrizPrecos As MatrizPrecos)
            Using ctx As New BD.Dinamica.Aplicacao
                Dim idModelo As Long = matrizPrecos.IDModelo
                Dim idTratamento As Long? = Nothing

                Dim diametroDe As String = If(matrizPrecos.DiametroDe Mod 1 > 0, matrizPrecos.DiametroDe.ToString("0.00", Globalization.CultureInfo.InvariantCulture), matrizPrecos.DiametroDe.ToString("0", Globalization.CultureInfo.InvariantCulture))
                Dim diametroAte As String = If(matrizPrecos.DiametroAte Mod 1 > 0, matrizPrecos.DiametroAte.ToString("0.00", Globalization.CultureInfo.InvariantCulture), matrizPrecos.DiametroAte.ToString("0", Globalization.CultureInfo.InvariantCulture))
                Dim raio As String = If(matrizPrecos.Raio IsNot Nothing, CDbl(matrizPrecos.Raio).ToString("0.00", Globalization.CultureInfo.InvariantCulture), "0")

                If matrizPrecos.IDTratamento > 0 Then
                    idTratamento = matrizPrecos.IDTratamento
                End If

                Dim dbSetPrecosLentes As IQueryable(Of tbPrecosLentes)
                If raio IsNot Nothing AndAlso raio <> "0" AndAlso idTratamento Is Nothing AndAlso matrizPrecos.DiametroDe < 20 Then
                    dbSetPrecosLentes = ctx.tbPrecosLentes.Where(Function(pl) _
                        pl.IDModelo = idModelo AndAlso
                        pl.IDTratamentoLente = idTratamento)
                Else

                    dbSetPrecosLentes = ctx.tbPrecosLentes.Where(Function(pl) _
                        pl.IDModelo = idModelo AndAlso
                        pl.IDTratamentoLente = idTratamento AndAlso
                        pl.DiamDe = diametroDe AndAlso
                        pl.DiamAte = diametroAte AndAlso
                        pl.Raio = raio)
                End If
                ctx.tbPrecosLentes.RemoveRange(dbSetPrecosLentes)
                ctx.SaveChanges()

                If matrizPrecos.LinhasMatrizPrecos IsNot Nothing Then
                    For Each linhaPreco In matrizPrecos.LinhasMatrizPrecos
                        Dim novoPrecoLente As New tbPrecosLentes With {
                            .IDModelo = idModelo,
                            .IDTratamentoLente = idTratamento,
                            .DiamDe = diametroDe,
                            .DiamAte = diametroAte,
                            .Raio = raio,
                            .PotEsfDe = linhaPreco.PotEsfDe,
                            .PotEsfAte = linhaPreco.PotEsfAte,
                            .PotCilDe = linhaPreco.PotCilDe,
                            .PotCilAte = linhaPreco.PotCilAte,
                            .PrecoVenda = linhaPreco.PrecoVenda,
                            .PrecoCusto = linhaPreco.PrecoCusto,
                            .Ativo = True
                        }

                        PreeEntDadosUtilizador(novoPrecoLente, 0, F3M.Modelos.Constantes.AcoesFormulario.Adicionar)

                        ctx.tbPrecosLentes.Add(novoPrecoLente)
                    Next

                    ctx.SaveChanges()
                End If
            End Using
        End Sub

        Public Sub RemovePrecosLentesPorModeloTratamento(ByVal idModelo As Long, ByVal idTratamento As Long?, ByVal diametroDe As Double, ByVal diametroAte As Double, Optional ByVal raio As Double? = Nothing)
            Dim diametroDeDB As String = If(diametroDe Mod 1 > 0, diametroDe.ToString("0.00", Globalization.CultureInfo.InvariantCulture), diametroDe.ToString("0", Globalization.CultureInfo.InvariantCulture))
            Dim diametroAteDB As String = If(diametroAte Mod 1 > 0, diametroAte.ToString("0.00", Globalization.CultureInfo.InvariantCulture), diametroAte.ToString("0", Globalization.CultureInfo.InvariantCulture))
            Dim raioDB As String = If(raio IsNot Nothing, CDbl(raio).ToString("0.00", Globalization.CultureInfo.InvariantCulture), "0")

            Using ctx As New BD.Dinamica.Aplicacao
                Dim dbSetPrecosLentes As IQueryable(Of tbPrecosLentes) =
                    ctx.tbPrecosLentes.Where(Function(pl) _
                        pl.IDModelo = idModelo AndAlso
                        pl.IDTratamentoLente = idTratamento AndAlso
                        pl.DiamDe = diametroDeDB AndAlso
                        pl.DiamAte = diametroAteDB AndAlso
                        pl.Raio = raioDB)

                ctx.tbPrecosLentes.RemoveRange(dbSetPrecosLentes)
                ctx.SaveChanges()
            End Using
        End Sub

    End Class
End Namespace