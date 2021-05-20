Imports System.Threading.Tasks
Imports F3M.Areas.Comum.Controllers
Imports F3M.Core.Components.Extensions
Imports F3M.Core.Domain.Entity
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Repositorio
Imports F3M.Oticas.Component.Kendo
Imports F3M.Oticas.Component.Kendo.Models
Imports F3M.Oticas.Domain.Enum
Imports F3M.Oticas.DTO
Imports F3M.Oticas.DTO.TaxAuthorityComunication
Imports F3M.Oticas.Interfaces.Application
Imports Kendo.Mvc.UI
Imports Oticas.BD.Dinamica

Namespace Areas.Utilitarios.Controllers
    Public Class InventarioATController
        Inherits GrelhaFormController(Of Aplicacao, tbComunicacaoAutoridadeTributaria, InventarioAT)

        Private ReadOnly _taxAuthorityComunicationApplication As IApplicationTaxAuthorityComunication

        Public Sub New(taxAuthorityComunicationApplication As IApplicationTaxAuthorityComunication)
            MyBase.New(New RepositorioGenerico(Of Aplicacao, tbComunicacaoAutoridadeTributaria, InventarioAT))
            _taxAuthorityComunicationApplication = taxAuthorityComunicationApplication
        End Sub

        <F3MAcesso>
        Public Async Function ListaAsync(<DataSourceRequest> request As DataSourceRequest) As Task(Of JsonResult)
            Dim resultado = Await _taxAuthorityComunicationApplication.GetAsync(F3MDataSourceRequest.Create(request))
            Dim inventarioAt = resultado.Map(Of Paged(Of InventarioAT))

            inventarioAt.Data = inventarioAt.Data.Select(Function(item)
                                                             Dim filter = item.Filter
                                                             item.DateFilter = filter.FilterDate
                                                             item.WareHousesFilterName = If(filter.Warehouses.Any(), String.Join("; ", filter.Warehouses.Select(Function(wherehoue) wherehoue.Description)), Traducao.EstruturaUtilitarios.Todos)
                                                             Return item
                                                         End Function)

            Return RetornaJSONTamMaximo(inventarioAt)
        End Function

        <F3MAcesso>
        Public Async Function PesquisaArtigosAsync(filtro As ComunicacaoAutoridadeTributariaFiltro) As Task(Of JsonResult)
            Dim artigos = Await _taxAuthorityComunicationApplication.GetProductsAsync(filtro.Map(Of TaxAuthorityComunicationFilterDto))
            Return RetornaJSONTamMaximo(artigos.Map(Of IList(Of ComunicacaoAutoridadeTributariaArtigos)))
        End Function

        <F3MAcesso>
        <HttpPost>
        Public Async Function AdicionaAsync(<DataSourceRequest> request As DataSourceRequest, <Bind> modelo As InventarioAT) As Task(Of JsonResult)
            Try
                Dim f3mKendoDataSource = F3MDataSourceRequest.Create(request)
                Dim data = modelo.Map(Of TaxAuthorityComunicationDto)
                Dim resultado = Await _taxAuthorityComunicationApplication.CreateAsync(KendoCreatedModel(Of TaxAuthorityComunicationDto).Create(data, f3mKendoDataSource))

                resultado.ResultDataSource.Data = resultado.ResultDataSource.Data.Map(Of List(Of InventarioAT))

                Return RetornaJSONTamMaximo(resultado)
            Catch ex As Exception
                Return RetornaJSONErrorsTamMaximo(ex)
            End Try
        End Function

        <F3MAcesso>
        <HttpGet>
        Public Async Function AdicionaAsync() As Task(Of ActionResult)
            Return Await Task.FromResult(PartialView(NameOf(Adiciona), New InventarioAT With {.AcaoFormulario = F3M.Modelos.Constantes.AcoesFormulario.Adicionar}))
        End Function

        <F3MAcesso>
        Public Async Function EditaAsync(Optional ID As Long = 0) As Task(Of ActionResult)
            Dim modelo = Await _taxAuthorityComunicationApplication.GetAsync(ID)
            Dim result = modelo.Map(Of InventarioAT)
            result.AcaoFormulario = F3M.Modelos.Constantes.AcoesFormulario.Alterar
            result.Warehouses = result.Filter.Warehouses.Select(Function(warehouse)
                                                                    Return warehouse.Id
                                                                End Function).ToList()
            Return PartialView(F3M.Modelos.ConstantesKendo.Mvc.Grelha.AccaoVisualizacao, result)
        End Function

        <F3MAcesso>
        Public Overrides Function Edita(<DataSourceRequest> request As DataSourceRequest, <Bind> modelo As InventarioAT, filtro As ClsF3MFiltro) As JsonResult
            Try
                Throw New NotImplementedException()
            Catch ex As Exception
                Return RetornaJSONErrorsTamMaximo(ex)
            End Try
        End Function

        <F3MAcesso>
        Public Async Function RemoveAsync(<DataSourceRequest> request As DataSourceRequest, <Bind> modelo As InventarioAT, filtro As ClsF3MFiltro) As Task(Of JsonResult)
            Try
                Dim resultado = Await _taxAuthorityComunicationApplication.RemoveAsync(KendoRemoveModel.Create(modelo.ID, F3MDataSourceRequest.Create(request)))

                resultado.ResultDataSource.Data = resultado.ResultDataSource.Data.Map(Of List(Of InventarioAT))

                Return RetornaJSONTamMaximo(resultado)
            Catch ex As Exception
                Return RetornaJSONErrorsTamMaximo(ex)
            End Try
        End Function

        <F3MAcesso>
        Public Async Function PrepareFileExport(id As Long, fileType As TaxAuthorityComunicationFileType) As Task(Of JsonResult)
            Dim loja = ClsF3MSessao.RetornaParametros().Lojas

            Dim resultado = Await _taxAuthorityComunicationApplication.ExportAsync(New ExportTaxAuthorityComunicationDto With {
                                                                            .FileType = fileType,
                                                                            .Id = id,
                                                                            .Nif = loja.NIF
                                                                        })

            Dim mimiType = If(fileType = TaxAuthorityComunicationFileType.Csv, "text/csv", "text/xml")

            Dim tempDataId = Guid.NewGuid()

            TempData.Add(tempDataId.ToString, New With {.FileBytes = resultado.File, mimiType, resultado.FileName})

            Return RetornaJSONTamMaximo(New With {.id = tempDataId})
        End Function

        <F3MAcesso>
        Public Function DownloadFile(id As Guid) As FileContentResult
            Dim result As New Object
            TempData.TryGetValue(id.ToString(), result)

            Response.AppendHeader("content-disposition", String.Format("attachment;filename={0}", result.FileName))
            Return New FileContentResult(result.FileBytes, result.MimiType)
        End Function

        Function BuildKendoDataSource(modelo As InventarioAT)
            Dim resultadoDataSource = New With {
                        .ResultDataSource = New With {
                            .Data = New List(Of InventarioAT) From {
                                modelo
                            }
                        }
                }
            Return resultadoDataSource
        End Function
    End Class
End Namespace