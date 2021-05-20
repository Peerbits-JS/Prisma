Imports System.Threading.Tasks
Imports F3M.Areas.Comum.Controllers
Imports F3M.Modelos.Autenticacao
Imports F3M.Oticas.DTO
Imports F3M.Oticas.Interfaces.Application

Namespace Areas.Accounting.Controllers
    Public Class AccountingExportController
        Inherits SimpleFormController

        ReadOnly _accountingExportApplication As IAccountingExportApplication
        ReadOnly _accountingConfigurationApplication As IAccountingConfigurationApplication

#Region "CONSTRUCTOR"
        Public Sub New(
                      accountingExportApplication As IAccountingExportApplication,
                      accountingConfigurationApplication As IAccountingConfigurationApplication)

            _accountingExportApplication = accountingExportApplication
            _accountingConfigurationApplication = accountingConfigurationApplication
        End Sub
#End Region

#Region "CRUD"
        <F3MAcesso>
        Public Function Index() As ActionResult
            Return View(New AccountingExportDto)
        End Function

        <F3MAcesso, HttpPost>
        Public Function GetDocuments(model As AccountingExportDto) As JsonResult
            Try
                Return RetornaJSONTamMaximo(_accountingExportApplication.GetDocuments(model.Filter))
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function

        <F3MAcesso>
        Public Function GenerateMovements(model As AccountingExportDto) As JsonResult
            Try
                _accountingExportApplication.GenerateMovements(model)
                Return RetornaJSONTamMaximo(_accountingExportApplication.GetDocuments(model.Filter))
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function

        <F3MAcesso>
        Public Function GetDocumentsDetails(model As AccountingExportDto) As JsonResult
            Try
                Return RetornaJSONTamMaximo(_accountingExportApplication.GetDocumentsDetails(model))
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function

        <F3MAcesso>
        Public Function ExportFile(model As AccountingExportDto) As JsonResult
            Try
                Dim resultFile = _accountingExportApplication.ExportFile(model)

                Dim tempDataId = Guid.NewGuid()
                TempData.Add(tempDataId.ToString, New With {
                                 .FileBytes = resultFile,
                                 .MimiType = "text/plain",
                                 .FileName = $"PR09_{Now.ToString("ddMMyyyy")}.txt"
                             })

                Return RetornaJSONTamMaximo(New With {.id = tempDataId})
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function

        <F3MAcesso>
        Public Function DownloadFile(id As Guid) As FileContentResult
            Dim result As New Object
            TempData.TryGetValue(id.ToString(), result)

            Response.AppendHeader("content-disposition", String.Format("attachment;filename={0}", result.FileName))
            Return New FileContentResult(result.FileBytes, result.MimiType)
        End Function
#End Region

#Region "AUX"
        <F3MAcesso, HttpPost>
        Public Function GetModules(<Bind> filter As AccountingExportFilterDto) As JsonResult
            Dim result = _accountingExportApplication.GetModulesByFilter(filter)
            Return RetornaJSONTamMaximo(result)
        End Function

        <F3MAcesso, HttpPost>
        Public Function GetDocumentTypes(<Bind> filter As AccountingExportFilterDto) As JsonResult
            Dim result = _accountingExportApplication.GetDocumentTypesByFilter(filter)
            Return RetornaJSONTamMaximo(result)
        End Function

        <F3MAcesso>
        Public Function GetGeneratedList() As JsonResult
            Return RetornaJSONTamMaximo(_accountingExportApplication.GetGeneratedList())
        End Function

        <F3MAcesso>
        Public Function GetExportedList() As JsonResult
            Return RetornaJSONTamMaximo(_accountingExportApplication.GetExportedList())
        End Function

        <F3MAcesso>
        Public Function GetEntityTypesList() As JsonResult
            Return RetornaJSONTamMaximo(_accountingExportApplication.GetEntityTypesList())
        End Function

        <F3MAcesso>
        Public Function GetFormatsList() As JsonResult
            Return RetornaJSONTamMaximo(_accountingExportApplication.GetFormatsList())
        End Function
#End Region
    End Class
End Namespace