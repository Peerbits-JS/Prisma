Imports System.Runtime.CompilerServices
Imports F3M.Modelos.Autenticacao
Imports Newtonsoft.Json

Public Module TbDocumentoStockContagemExtensoes
    <Extension()>
    Public Function AtualizaValores(ByVal documento As tbDocumentosStockContagem, modelo As DocumentosStockContagem)

        With documento
            .IDArmazem = modelo.IDArmazem
            .DataDocumento = modelo.DataDocumento
            .IDEstado = modelo.IDEstado
            .IDLocalizacao = modelo.IDLocalizacao
            .Filtro = JsonConvert.SerializeObject(modelo.Filtro)
            .Observacoes = modelo.Observacoes
            .FaltamContar = modelo.FaltamContar
            .Contados = modelo.Contados
            .Diferencas = modelo.Diferencas
            .DataAlteracao = Now()
            .UtilizadorAlteracao = ClsF3MSessao.RetornaUtilizadorNome
        End With

        Return documento
    End Function

    <Extension()>
    Public Function AtualizaValores(ByVal linha As tbDocumentosStockContagemLinhas, modelo As DocumentosStockContagemArtigos)
        If modelo IsNot Nothing AndAlso modelo.QuantidadeEmStock IsNot Nothing AndAlso modelo.QuantidadeContada IsNot Nothing AndAlso modelo.Diferenca IsNot Nothing Then
            With linha
                .IDArtigo = modelo.IDArtigo
                .CodigoArtigo = modelo.Codigo
                .DescricaoArtigo = modelo.Descricao
                .IDLote = modelo.IDLote
                .DescricaoLote = modelo.DescricaoLote
                .IDUnidade = modelo.IDUnidade
                .DescricaoUnidade = modelo.DescricaoUnidade
                .QuantidadeEmStock = modelo.QuantidadeEmStock
                .QuantidadeContada = modelo.QuantidadeContada
                .QuantidadeDiferenca = modelo.Diferenca
                .DataAlteracao = Now()
                .UtilizadorAlteracao = ClsF3MSessao.RetornaUtilizadorNome
            End With
        Else
            Return linha
        End If
        Return linha
    End Function
End Module