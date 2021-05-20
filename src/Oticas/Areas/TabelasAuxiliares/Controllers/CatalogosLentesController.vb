Imports Kendo.Mvc.UI
Imports F3M.Areas.Comum.Controllers
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Utilitarios
Imports Oticas.Repositorio.Artigos
Imports Oticas.Repositorio.Documentos
Imports Oticas.Repositorio.TabelasAuxiliares
Imports Oticas.Repositorio.Sistema
Imports F3M.Modelos.Constantes

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class CatalogosLentesController
        Inherits SimpleFormController

        ReadOnly _repositorioMarcas As RepositorioMarcas
        ReadOnly _repositorioSistemaTiposLentes As RepositorioSistemaTiposLentes
        ReadOnly _repositorioSistemaMateriasLentes As RepositorioSistemaMateriasLentes
        ReadOnly _repositorioModelosArtigos As RepositorioModelosArtigos
        ReadOnly _repositorioTratamentosLentes As RepositorioTratamentosLentes
        ReadOnly _repositorioCoresLentes As RepositorioCoresLentes
        ReadOnly _repositorioSuplementosLentes As RepositorioSuplementosLentes
        ReadOnly _repositorioPrecosLentes As RepositorioPrecosLentes

#Region "CONSTRUCTOR"
        Sub New()
            _repositorioMarcas = New RepositorioMarcas()
            _repositorioSistemaTiposLentes = New RepositorioSistemaTiposLentes()
            _repositorioSistemaMateriasLentes = New RepositorioSistemaMateriasLentes()
            _repositorioModelosArtigos = New RepositorioModelosArtigos()
            _repositorioTratamentosLentes = New RepositorioTratamentosLentes()
            _repositorioCoresLentes = New RepositorioCoresLentes()
            _repositorioSuplementosLentes = New RepositorioSuplementosLentes()
            _repositorioPrecosLentes = New RepositorioPrecosLentes()
        End Sub
#End Region

#Region "VIEWS"
        <F3MAcesso>
        Public Function Index() As ActionResult
            ViewBag.IDTipoLenteOftalmica = 1
            ViewBag.IDTipoLenteContato = 3

            Return View()
        End Function
#End Region

#Region "READS"
        <F3MAcesso>
        Public Function ListaCombo(<DataSourceRequest> request As DataSourceRequest, inObjFiltro As ClsF3MFiltro) As JsonResult
            Try
                Dim result As IQueryable(Of Oticas.Artigos) = Nothing

                Using rep As New RepositorioArtigos
                    result = rep.ListaComboCodigo(inObjFiltro)
                End Using

                Return Json(result, System.Web.Mvc.JsonRequestBehavior.AllowGet)
            Catch ex As Exception
                Return RetornaJSONErrorsTamMaximo(ex)
            End Try
        End Function

        <F3MAcesso>
        Function LerMarcas(inObjFiltro As ClsF3MFiltro, Optional ByVal Origem As String = "") As JsonResult
            Try
                inObjFiltro.FiltroTexto = Origem
                Return RetornaJSONTamMaximo(_repositorioMarcas.Lista(inObjFiltro).OrderBy(Function(x) x.Descricao).ToList())
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function

        <F3MAcesso>
        Function LerTiposLentes(ByVal IDTipoLenteClassificacao As Long, Optional IDTipoServico As Long = 0, Optional IDTipoOlho As Long = 0) As JsonResult
            Try
                Return RetornaJSONTamMaximo(_repositorioSistemaTiposLentes.ListaTiposLentes(IDTipoLenteClassificacao, IDTipoServico, IDTipoOlho))
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function

        <F3MAcesso>
        Function LerMateriasLentes() As JsonResult
            Try
                Return RetornaJSONTamMaximo(_repositorioSistemaMateriasLentes.ListaMateriasLentes())
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function

        <F3MAcesso>
        Function LerModelos(LenteOftalmica As Boolean, IDMarca As Long,
                            IDTiposLentes As Long,
                            Optional IDMateriaLentes As Long = 0,
                            Optional Indice As Double? = Nothing,
                            Optional Fotocromatica As Boolean = False)
            Try
                Return RetornaJSONTamMaximo(_repositorioModelosArtigos.ListaModelos(LenteOftalmica, IDMarca, IDTiposLentes, IDMateriaLentes, Indice, Fotocromatica))
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function

        <F3MAcesso>
        Function LerIndices(
                           Optional LenteOftalmica As Boolean = False,
                           Optional IDMarca As Long = Nothing,
                           Optional IDTiposLentes As Long = Nothing,
                           Optional IDMateriaLentes As Long = 0,
                           Optional ByVal Fotocromatica As Boolean = False)
            Try
                Return RetornaJSONTamMaximo(_repositorioModelosArtigos.ListaIndices(LenteOftalmica, IDMarca, IDTiposLentes, IDMateriaLentes, Fotocromatica))
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function

        <F3MAcesso>
        Function LerTratamentos(IDModelo As Long?) As JsonResult
            Try
                Return RetornaJSONTamMaximo(_repositorioTratamentosLentes.ListaTratamentosLentes(IDModelo))
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function

        <F3MAcesso>
        Function LerCores(IDModelo As Long?, IDMarca As Long?, IDTiposLentes As Long?, IDMateriaLentes As Long?) As JsonResult
            Try
                Return RetornaJSONTamMaximo(_repositorioCoresLentes.ListaCoresLentes(IDModelo, IDMarca, IDTiposLentes, IDMateriaLentes))
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function

        <F3MAcesso>
        Function LerSuplementos(IDModelo As Long?, IDMarca As Long?, IDTiposLentes As Long?, IDMateriaLentes As Long?) As JsonResult
            Try
                Return RetornaJSONTamMaximo(_repositorioSuplementosLentes.ListaSuplementos(IDModelo, IDMarca, IDTiposLentes, IDMateriaLentes))
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function
#End Region

#Region "FUNCOES AUXILIARES"
        <F3MAcesso>
        Function GetPrecos(inObjFiltro As ClsF3MFiltro) As JsonResult
            Try
                Dim _PrecosArtigos As New PrecosArtigos
                Dim DescricaoModelo As String = String.Empty
                Dim DescricaoTratamento As String = String.Empty
                Dim DescricaoCor As String = String.Empty

                Dim IDMarca As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "IDMarca", GetType(Long))
                Dim Diametro As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "Diametro", GetType(String))
                Dim IDTipoLente As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "IDTipoLente", GetType(Long))
                Dim IDMateriaLente As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "IDMateriaLente", GetType(Long))

                Dim IndiceRefracao As Double? = Nothing
                Dim IndiceRefracaoAux As String = ClsUtilitarios.RetornaValorKeyDicionario(inObjFiltro.CamposFiltrar, "IndiceRefracao", CamposGenericos.CampoValor)
                If Not String.IsNullOrEmpty(IndiceRefracaoAux) Then
                    IndiceRefracao = CDbl(IndiceRefracaoAux)
                End If

                Dim Fotocromatica As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "Fotocromatica", GetType(Boolean))

                Dim IDModelo As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "IDModelo", GetType(Long))

                Dim TipoDeLente As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "TipoDeLente", GetType(String))

                Dim IDTipoOlho As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "IDTipoOlho", GetType(String))
                Dim IDTipoGraduacao As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "IDTipoGraduacao", GetType(String))

                Dim PotenciaPrismatica As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "PotenciaPrismatica", GetType(String))
                Dim Adicao As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "Adicao", GetType(String))
                Dim Eixo As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "Eixo", GetType(String))
                Dim Raio As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "Raio", GetType(String))

                DescricaoModelo = _repositorioModelosArtigos.getDescricaoModelo(IDModelo)

                Dim IDTratamento As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "IDTratamentoLente", GetType(Long))
                DescricaoTratamento = _repositorioTratamentosLentes.getDescricaoTratamento(IDTratamento)

                Dim IDCor As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "IDCorLente", GetType(Long))
                DescricaoCor = _repositorioCoresLentes.getDescricaoCor(IDCor)

                Dim IDsSuplementos As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "IDsSuplementos", GetType(String))
                Dim SuplementosLentes() As String = If(String.IsNullOrEmpty(IDsSuplementos), Nothing, IDsSuplementos.Split("-"))

                'ORDENAÇÃO DOS ID'S DOS SUPLEMENTOS (EX. 913-914-915)
                If Not SuplementosLentes Is Nothing Then
                    System.Array.Sort(Of String)(SuplementosLentes)
                    IDsSuplementos = String.Join("-", SuplementosLentes)
                End If

                Dim PotenciaCilindricaOE As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "PotenciaCilindricaOE", GetType(String))
                Dim PotenciaEsfericaOE As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "PotenciaEsfericaOE", GetType(String))

                Dim PotenciaCilindricaOD As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "PotenciaCilindricaOD", GetType(String))
                Dim PotenciaEsfericaOD As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "PotenciaEsfericaOD", GetType(String))

                Dim lst As New List(Of String)
                lst.Add(DescricaoModelo)
                If Not IsNothing(DescricaoTratamento) Then lst.Add(DescricaoTratamento)
                If Not IsNothing(DescricaoCor) Then lst.Add(DescricaoCor)

                If Not IsNothing(SuplementosLentes) Then
                    lst.AddRange(_repositorioSuplementosLentes.getArrayDescricaoByIDs(SuplementosLentes))
                End If

                Dim descricao As String = String.Join(", ", lst)

                Dim PotEsf = If(IDTipoOlho = 1, PotenciaEsfericaOD, PotenciaEsfericaOE)
                Dim PotCil = If(IDTipoOlho = 1, PotenciaCilindricaOD, PotenciaCilindricaOE)

                If TipoDeLente = "LO" Then
                    descricao += " Diam:" & Diametro
                    If PotEsf <> 0 Then descricao += " Esf:" & PotEsf
                    If PotCil <> 0 Then descricao += " Cil:" & PotCil
                    If Adicao <> 0 Then descricao += " Add:" & Adicao
                    'If Eixo <> 0 Then descricao += " AX:" & Eixo
                    If PotenciaPrismatica <> 0 Then descricao += " Prism:" & PotenciaPrismatica
                Else
                    descricao += " Diam:" & Diametro
                    descricao += " Raio:" & Raio
                    If PotEsf <> 0 Then descricao += " Esf:" & PotEsf
                    If PotCil <> 0 Then descricao += " Cil:" & PotCil
                    If Adicao <> 0 Then descricao += " Add:" & Adicao
                    If Eixo <> 0 Then descricao += " AX:" & Eixo
                End If

                With _PrecosArtigos
                    .Diametro = Diametro
                    .IDMarca = IDMarca
                    .DescricaoMarca = _repositorioMarcas.getDescricaoMarca(IDMarca)
                    .IDTipoLenteSelected = IDTipoLente
                    .IDMateriaLenteSelected = IDMateriaLente
                    .IndiceRefracao = IndiceRefracao
                    .Fotocromatica = Fotocromatica
                    .IDModelo = IDModelo
                    .IDTratamentoLente = IDTratamento
                    .IDCorLente = IDCor
                    .IDsSuplementos = SuplementosLentes
                    .Descricao = descricao
                    .PrecoUnitOD = _repositorioMarcas.LerPrecoVenda(TipoDeLente, IDModelo, IDTratamento, IDCor, SuplementosLentes, Diametro, PotenciaEsfericaOD, PotenciaCilindricaOD, Raio, 0)
                    .PrecoUnitOE = _repositorioMarcas.LerPrecoVenda(TipoDeLente, IDModelo, IDTratamento, IDCor, SuplementosLentes, Diametro, PotenciaEsfericaOE, PotenciaCilindricaOE, Raio, 0)
                    .Total = Math.Round(.PrecoUnitOD + .PrecoUnitOE, 4)
                    .IDArtigo = _repositorioMarcas.LerIDArtigo(TipoDeLente, IDModelo, String.Empty, String.Empty, String.Empty, String.Empty, IDTratamento, IDCor, IDsSuplementos, Diametro, PotEsf, PotCil, PotenciaPrismatica, Adicao, Eixo, Raio)
                    .CodigoArtigo = String.Empty
                End With

                If _PrecosArtigos.IDArtigo <> "0" Then
                    'Using rp As New RepositorioArtigos
                    '    _PrecosArtigos.CodigoArtigo = rp.GetCodigoArtigo(_PrecosArtigos.IDArtigo)
                    '    '_PrecosArtigos.Descricao = 
                    'End Using

                    Using rp As New RepositorioDocumentosVendasServicos
                        Dim Art As Oticas.Artigos = rp.GetArtigosAux(_PrecosArtigos.IDArtigo)

                        With _PrecosArtigos
                            .CodigoArtigo = Art.Codigo
                            .Descricao = Art.Descricao
                            .PrecoArtigo = rp.RetornaPreco(Art.ID)
                        End With
                    End Using

                Else
                    _PrecosArtigos.CodigoArtigo = String.Empty 'TipoDeLente
                End If

                Return RetornaJSONTamMaximo(_PrecosArtigos)
            Catch ex As Exception
                Return RetornaJSONErrorsTamMaximo(ex)
            End Try
        End Function
#End Region

#Region "MATRIZ PRECOS"

        <F3MAcesso>
        Public Function IndexMatrizPrecos(IDModelo As Long, IDTratamento As Long) As ActionResult
            Dim matrizPrecos As New CatalogosLentesMatrizPrecos

            Dim modelo As ModelosArtigos = _repositorioModelosArtigos.ObtemPorObjID(IDModelo)
            Dim tratamento As TratamentosLentes = _repositorioTratamentosLentes.ObtemPorObjID(IDTratamento)

            matrizPrecos.IDModelo = If(modelo IsNot Nothing, modelo.ID, 0)
            matrizPrecos.DescricaoModelo = If(modelo IsNot Nothing, modelo.Descricao, "---")
            matrizPrecos.IDTratamento = If(tratamento IsNot Nothing, tratamento.ID, 0)
            matrizPrecos.DescricaoTratamento = If(tratamento IsNot Nothing, tratamento.Descricao, "---")
            matrizPrecos.VerPrecoCusto = ClsF3MSessao.TemAcessoPorDescricao(AcoesFormulario.Consultar, "VerPrecoCusto", True)

            Return View(matrizPrecos)
        End Function

        <F3MAcesso>
        Public Function MatrizPrecosPorModeloTratamento(ByVal idModelo As Long, ByVal idTratamento As Long, ByVal diametroDe As Double, ByVal diametroAte As Double, Optional ByVal raio As Double? = Nothing) As JsonResult
            Try
                Dim tratamentoID As Long? = Nothing

                If idTratamento > 0 Then
                    tratamentoID = idTratamento
                End If

                Dim precosLentes As List(Of PrecosLentes) =
                    _repositorioPrecosLentes.PrecosLentesPorModeloTratamento(idModelo, tratamentoID, diametroDe, diametroAte, raio)

                Return RetornaJSONTamMaximo(precosLentes)
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function

        <F3MAcesso>
        Public Function GravaMatrizPrecos(<DataSourceRequest> request As DataSourceRequest, matrizPrecos As MatrizPrecos) As JsonResult
            Try
                _repositorioPrecosLentes.GuardaAlteracoesMatrizPrecos(matrizPrecos)

                Return RetornaJSONTamMaximo(True)
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function

        <F3MAcesso>
        Public Function RemoveMatrizPrecosPorModeloTratamento(ByVal idModelo As Long, ByVal idTratamento As Long, ByVal diametroDe As Double, ByVal diametroAte As Double, Optional ByVal raio As Double? = Nothing) As JsonResult
            Try
                Dim tratamentoID As Long? = Nothing

                If idTratamento > 0 Then
                    tratamentoID = idTratamento
                End If

                _repositorioPrecosLentes.RemovePrecosLentesPorModeloTratamento(idModelo, tratamentoID, diametroDe, diametroAte, raio)

                Return RetornaJSONTamMaximo(True)
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function

#End Region

        Public Structure PrecosArtigos
            Public Diametro As String
            Public IDMarca As Long
            Public DescricaoMarca As String
            Public IDTipoLenteSelected As Long
            Public IDMateriaLenteSelected As Long
            Public IndiceRefracao As Double
            Public Fotocromatica As Boolean
            Public IDModelo As Long
            Public IDTratamentoLente As Nullable(Of Long)
            Public IDCorLente As Nullable(Of Long)
            Public IDsSuplementos As String()
            Public Descricao As String
            Public PrecoUnitOD As Double
            Public PrecoUnitOE As Double
            Public Total As Double
            Public IDArtigo As String
            Public CodigoArtigo As String
            Public PrecoArtigo As Double
        End Structure
    End Class
End Namespace