Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Constantes

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioDocumentosVendasPendentes
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbDocumentosVendasPendentes, DocumentosVendasPendentes)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

        'FUNÇÕES AUXILIARES
        Public Function GetDocumentosVendasPendentes(ByVal IDDocumentoVenda As Long, ByVal IDEntidade As Long, ByVal IDMoeda As Long) As List(Of DocumentosVendasPendentes)
            Try
                Dim strDocumento As String = (From x In BDContexto.tbDocumentosVendas Where x.ID = IDDocumentoVenda).FirstOrDefault.Documento

                Dim DV = (From x In BDContexto.tbDocumentosVendas Where x.ID = IDDocumentoVenda).FirstOrDefault()
                If DV.tbEstados.tbSistemaTiposEstados.tbSistemaEntidadesEstados.Codigo = TiposEntidadeEstados.Servicos Then
                    strDocumento = (From x In BDContexto.tbDocumentosVendas
                                    Join y In BDContexto.tbDocumentosVendasLinhas On y.IDDocumentoVenda Equals x.ID
                                    Where y.IDDocumentoOrigem = IDDocumentoVenda And x.tbEstados.tbSistemaTiposEstados.Codigo <> TiposEstados.Anulado
                                    Select x.Documento).FirstOrDefault()
                End If

                Dim t As List(Of DocumentosVendasPendentes) = (From x In BDContexto.tbDocumentosVendasPendentes
                        Join y In BDContexto.tbDocumentosVendas On y.ID Equals x.IDDocumentoVenda
                        Join z In BDContexto.tbEstados On z.ID Equals y.IDEstado
                        Join f In BDContexto.tbMoedas On f.ID Equals x.IDMoeda
                        Where x.IDEntidade = IDEntidade And x.IDMoeda = IDMoeda And x.ValorPendente > 0 And z.tbSistemaTiposEstados.Codigo = TiposEstados.Efetivo
                        Select New DocumentosVendasPendentes With {
                             .ID = x.ID, .IDEntidade = x.IDEntidade, .IDTipoDocumento = x.IDTipoDocumento, .Documento = x.Documento,
                             .NumeroDocumento = x.NumeroDocumento, .DataVencimento = x.DataVencimento,
                             .DataDocumento = x.DataDocumento,
                             .TotalMoedaDocumento = Math.Round(CDbl(x.TotalClienteMoedaDocumento), CInt(f.CasasDecimaisTotais)),
                             .TotalMoedaReferencia = Math.Round(CDbl(x.TotalClienteMoedaReferencia), CInt(f.CasasDecimaisTotais)),
                             .ValorPendente = x.ValorPendente, .ValorPendenteAux = x.ValorPendente, .ValorPago = 0,
                             .GereContaCorrente = x.tbDocumentosVendas.tbTiposDocumento.GereContaCorrente,
                             .IDDocumentoVenda = x.IDDocumentoVenda, .IDTiposDocumentoSeries = x.tbDocumentosVendas.IDTiposDocumentoSeries,
                             .NomeFiscal = y.NomeFiscal, .MoradaFiscal = y.MoradaFiscal, .IDCodigoPostalFiscal = y.IDCodigoPostalFiscal, .IDConcelhoFiscal = y.IDConcelhoFiscal,
                             .IDDistritoFiscal = y.IDDistritoFiscal, .CodigoPostalFiscal = y.CodigoPostalFiscal, .DescricaoCodigoPostalFiscal = y.DescricaoCodigoPostalFiscal,
                             .DescricaoConcelhoFiscal = y.DescricaoConcelhoFiscal, .DescricaoDistritoFiscal = y.DescricaoDistritoFiscal, .ContribuinteFiscal = y.ContribuinteFiscal,
                             .SiglaPaisFiscal = y.SiglaPaisFiscal,
                             .CodigoSistemaNaturezas = x.tbSistemaNaturezas.Codigo,
                             .DescricaoSistemaNaturezas = If(x.tbSistemaNaturezas.Descricao = "APagar", "C", "D")
                         }).ToList()

                Return t.OrderByDescending(Function(f) f.Documento.Contains(strDocumento)).ToList()

            Catch ex As Exception
                Throw
            End Try
        End Function

    End Class
End Namespace