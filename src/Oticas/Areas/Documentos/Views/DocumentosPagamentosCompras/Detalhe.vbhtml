@Imports F3M.Modelos.Constantes
@Modeltype DocumentosPagamentosCompras

@Html.Partial("~/F3M/Areas/DocumentosComum/Views/DocumentosPagamentosComprasPart/Detalhe.vbhtml", Model)

@Code
    If Model.AcaoFormulario <> AcoesFormulario.Adicionar Then
        @<script>
            DocumentosPagamentosComprasEditarControiHT(@Html.Raw(Json.Encode(Model.ListOfDocumentosPagamentosComprasLinhas)))
        </script>
    End If
End Code