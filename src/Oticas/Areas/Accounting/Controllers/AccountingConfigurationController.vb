Imports System.Threading.Tasks
Imports System.Web.Http
Imports F3M.Areas.Comum.Controllers
Imports F3M.Core.Components.Extensions
Imports F3M.Core.Domain.Entity
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Repositorio
Imports F3M.Oticas.Component.Kendo
Imports F3M.Oticas.Component.Kendo.Models
Imports F3M.Oticas.DTO
Imports F3M.Oticas.Interfaces.Application
Imports Kendo.Mvc.UI
Imports Oticas.BD.Dinamica

Namespace Areas.Accounting.Controllers
    Public Class AccountingConfigurationController
        Inherits GrelhaFormController(Of Aplicacao, Object, AccountingConfiguration)

        ReadOnly _accountingConfigurationApplication As IAccountingConfigurationApplication

#Region "CONSTRUCTOR"
        Public Sub New(accountingConfigurationApplication As IAccountingConfigurationApplication)
            MyBase.New(New RepositorioGenerico(Of Aplicacao, Object, AccountingConfiguration))
            _accountingConfigurationApplication = accountingConfigurationApplication
        End Sub
#End Region

#Region "CRUD"
        <F3MAcesso, HttpPost>
        Public Async Function ListaAsync(<DataSourceRequest> request As DataSourceRequest) As Task(Of JsonResult)
            Dim resultado = Await _accountingConfigurationApplication.GetAsync(F3MDataSourceRequest.Create(request))
            Dim contabilidadeConf = resultado.Map(Of Paged(Of AccountingConfiguration))
            Return RetornaJSONTamMaximo(contabilidadeConf)
        End Function

        <F3MAcesso, HttpGet>
        Public Async Function AdicionaAsync() As Task(Of ActionResult)
            Return Await Task.FromResult(PartialView(NameOf(Adiciona), New AccountingConfiguration With {.AlternativeCode = "1", .IsPreset = True, .AcaoFormulario = F3M.Modelos.Constantes.AcoesFormulario.Adicionar}))
        End Function

        <F3MAcesso, HttpPost>
        Public Async Function CreateWithDocumentTypesAsync(<DataSourceRequest> request As DataSourceRequest, <Bind> modelo As AccountingConfigurationDto) As Task(Of JsonResult)
            Try
                Dim f3mKendoDataSource = F3MDataSourceRequest.Create(request)
                Dim data = modelo.Map(Of AccountingConfigurationDto)

                Dim domainResult = Await _accountingConfigurationApplication.CreateWithDocumentTypesAsync(KendoCreatedModel(Of AccountingConfigurationDto).Create(data, f3mKendoDataSource))

                If (domainResult.Success) Then
                    Dim resultado = domainResult.Value
                    resultado.ResultDataSource.Data = resultado.ResultDataSource.Data.Map(Of List(Of AccountingConfiguration))
                    Return RetornaJSONTamMaximo(resultado)
                End If

                Return domainResult.ToPrismaErrors()
            Catch ex As Exception
                Return RetornaJSONErrorsTamMaximo(ex)
            End Try
        End Function

        <F3MAcesso, HttpPost>
        Public Async Function CreateWithAccountsAsync(<DataSourceRequest> request As DataSourceRequest, <Bind> modelo As AccountingConfigurationDto) As Task(Of JsonResult)
            Try
                Dim f3mKendoDataSource = F3MDataSourceRequest.Create(request)
                Dim data = modelo.Map(Of AccountingConfigurationDto)

                Dim domainResult = Await _accountingConfigurationApplication.CreateWithAccountsAsync(KendoCreatedModel(Of AccountingConfigurationDto).Create(data, f3mKendoDataSource))

                If (domainResult.Success) Then
                    Dim resultado = domainResult.Value
                    resultado.ResultDataSource.Data = resultado.ResultDataSource.Data.Map(Of List(Of AccountingConfiguration))
                    Return RetornaJSONTamMaximo(resultado)
                End If

                Return domainResult.ToPrismaErrors()
            Catch ex As Exception
                Return RetornaJSONErrorsTamMaximo(ex)
            End Try
        End Function

        <F3MAcesso, HttpGet>
        Public Async Function EditaAsync(Optional ID As Long = 0) As Task(Of ActionResult)
            Dim data = Await _accountingConfigurationApplication.GetAsync(ID)
            Dim result = data.Map(Of AccountingConfiguration)
            Return Await Task.FromResult(PartialView(NameOf(Edita), result))
        End Function

        <F3MAcesso, HttpPost>
        Public Async Function UpdateWithDocumentTypesAsync(<DataSourceRequest> request As DataSourceRequest, <Bind> modelo As AccountingConfigurationDto) As Task(Of JsonResult)
            Try
                Dim f3mKendoDataSource = F3MDataSourceRequest.Create(request)
                Dim data = modelo.Map(Of AccountingConfigurationDto)

                Dim domainResult = Await _accountingConfigurationApplication.UpdateWithDocumentTypesAsync(KendoCreatedModel(Of AccountingConfigurationDto).Create(data, f3mKendoDataSource))

                If (domainResult.Success) Then
                    Dim resultado = domainResult.Value
                    resultado.ResultDataSource.Data = resultado.ResultDataSource.Data.Map(Of List(Of AccountingConfiguration))
                    Return RetornaJSONTamMaximo(resultado)
                End If

                Return domainResult.ToPrismaErrors()
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function

        <F3MAcesso, HttpPost>
        Public Async Function UpdateWithAccountsAsync(<DataSourceRequest> request As DataSourceRequest, <Bind> modelo As AccountingConfigurationDto) As Task(Of JsonResult)
            Try
                Dim f3mKendoDataSource = F3MDataSourceRequest.Create(request)
                Dim data = modelo.Map(Of AccountingConfigurationDto)
                Dim resultado As KendoResultModel(Of AccountingConfigurationDto)

                resultado = Await _accountingConfigurationApplication.UpdateWithAccountsAsync(KendoCreatedModel(Of AccountingConfigurationDto).Create(data, f3mKendoDataSource))

                resultado.ResultDataSource.Data = resultado.ResultDataSource.Data.Map(Of List(Of AccountingConfiguration))

                Return RetornaJSONTamMaximo(resultado)
            Catch ex As Exception
                Return RetornaJSONErrorsTamMaximo(ex)
            End Try
        End Function

        <F3MAcesso, HttpPost>
        Public Async Function RemoveAsync(<DataSourceRequest> request As DataSourceRequest, <Bind> modelo As AccountingConfiguration, filtro As ClsF3MFiltro) As Task(Of JsonResult)
            Try
                Dim resultado = Await _accountingConfigurationApplication.RemoveAsync(KendoRemoveModel.Create(modelo.ID, F3MDataSourceRequest.Create(request)))

                resultado.ResultDataSource.Data = resultado.ResultDataSource.Data.Map(Of List(Of InventarioAT))

                Return RetornaJSONTamMaximo(resultado)
            Catch ex As Exception
                Return RetornaJSONErrorsTamMaximo(ex)
            End Try
        End Function

        <F3MAcesso, HttpGet>
        Public Async Function DuplicaAsync(ID As Long, IDVista As Long, inObjFiltro As ClsF3MFiltro, CampoValorPorDefeito As String, IDDuplica As Long) As Task(Of ActionResult)

            Dim data = Await _accountingConfigurationApplication.GetAsync(IDDuplica)
            Dim result = data.Map(Of AccountingConfiguration)

            With result
                .ID = 0
                .IsCopyMode = True
                .AlternativeCode = _accountingConfigurationApplication.GetAlternative(data)
            End With

            If result.ModuleCode = "008" Then
                For Each lin In result.Entities
                    lin.Id = 0
                Next
            Else
                For Each lin In result.DocumentTypes
                    lin.Id = 0
                Next
            End If

            Return Await Task.FromResult(PartialView(NameOf(Adiciona), result))
        End Function
#End Region

#Region "AUX"
        <F3MAcesso, HttpGet>
        Public Function GetDocumentTypes() As ActionResult
            Return View("Views/Container/DocumentTypes/DocumentTypes", New AccountingConfiguration)
        End Function

        <F3MAcesso, HttpGet>
        Public Function GetAccounts() As ActionResult
            Return View("Views/Container/Entities/Entities", New AccountingConfiguration)
        End Function

        <F3MAcesso, HttpPost>
        Public Async Function GetYears() As Task(Of JsonResult)
            Dim resultado = Await _accountingConfigurationApplication.GetYearsAsync()
            Return RetornaJSONTamMaximo(resultado)
        End Function

        <F3MAcesso, HttpPost>
        Public Async Function GetModules() As Task(Of JsonResult)
            Dim resultado = Await _accountingConfigurationApplication.GetModulesAsync()
            Return RetornaJSONTamMaximo(resultado)
        End Function

        <F3MAcesso, HttpPost>
        Public Async Function GetTypes(<Bind> modelo As AccountingConfigurationModulesDto) As Task(Of JsonResult)
            Dim resultado = Await _accountingConfigurationApplication.GetTypesAsync(modelo)
            Return RetornaJSONTamMaximo(resultado)
        End Function

        <F3MAcesso, HttpPost>
        Public Function GetAlternative(<Bind> modelo As AccountingConfigurationDto) As JsonResult
            Return RetornaJSONTamMaximo(_accountingConfigurationApplication.GetAlternative(modelo))
        End Function

        <F3MAcesso, HttpPost>
        Public Function GetEntities(<Bind> model As AccountingConfigurationTypesDto) As JsonResult
            Return RetornaJSONTamMaximo(_accountingConfigurationApplication.GetEntities(model))
        End Function
#End Region
    End Class
End Namespace