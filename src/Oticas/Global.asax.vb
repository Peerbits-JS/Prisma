Imports System.Reflection
Imports System.Runtime.CompilerServices
Imports System.Web.Optimization
Imports Autofac
Imports Autofac.Integration.Mvc
Imports AutoMapper
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.BaseDados
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Logging
Imports F3M.Modelos.Modulos
Imports F3M.Modelos.Utilitarios
Imports F3M.Oticas.Component.IOC
Imports F3M.Oticas.Data.Context
Imports Microsoft.ApplicationInsights.Extensibility
Imports F3M.Core.Business.Documents.IoC

Module MapperExtensions
    Private Sub IgnoreUnmappedProperties(ByVal map As TypeMap, ByVal expr As IMappingExpression)
        For Each propName As String In map.GetUnmappedPropertyNames()

            If map.SourceType.GetProperty(propName) IsNot Nothing Then
                expr.ForSourceMember(propName, Sub(opt) opt.DoNotValidate())
            End If

            If map.DestinationType.GetProperty(propName) IsNot Nothing Then
                expr.ForMember(propName, Sub(opt) opt.Ignore())
            End If
        Next
    End Sub

    <Extension()>
    Sub IgnoreUnmapped(ByVal profile As IProfileExpression)
        profile.ForAllMaps(AddressOf IgnoreUnmappedProperties)
    End Sub

    <Extension()>
    Sub IgnoreUnmapped(ByVal profile As IProfileExpression, ByVal filter As Func(Of TypeMap, Boolean))
        profile.ForAllMaps(Sub(map, expr)
                               If filter(map) Then IgnoreUnmappedProperties(map, expr)
                           End Sub)
    End Sub

    <Extension()>
    Sub IgnoreUnmapped(ByVal profile As IProfileExpression, ByVal src As Type, ByVal dest As Type)
        profile.IgnoreUnmapped(Function(ByVal map As TypeMap) map.SourceType = src AndAlso map.DestinationType = dest)
    End Sub

    <Extension()>
    Sub IgnoreUnmapped(Of TSrc, TDest)(ByVal profile As IProfileExpression)
        profile.IgnoreUnmapped(GetType(TSrc), GetType(TDest))
    End Sub
End Module


Public Class MvcApplication
    Inherits HttpApplication

    Sub Application_Start()

        TelemetryConfiguration.Active.InstrumentationKey = If(Environment.GetEnvironmentVariable("APPINSIGHTS_INSTRUMENTATIONKEY",
                                                              EnvironmentVariableTarget.Machine), "")
        AreaRegistration.RegisterAllAreas()
        RegisterGlobalFilters(GlobalFilters.Filters)
        RegisterRoutes(RouteTable.Routes)
        RegisterBundles(BundleTable.Bundles)
        F3M.Core.Business.Documents.BundleConfig.RegisterBundles(BundleTable.Bundles)
        ViewEngines.Engines.Clear()
        ViewEngines.Engines.Add(New RazorViewEngine())
        ViewEngines.Engines.Add(New F3M.Core.Business.Documents.App_Start.ViewsConfig())
        BundleTable.EnableOptimizations = Not ClsF3MSessao.EmDesenvolvimento
        PreencheModulosAplicacao()
        InitializeContainer()

        InitializeMap()

    End Sub

    Private Sub InitializeContainer()
        Dim builder = New ContainerBuilder()
        With builder
            .RegisterControllers(Assembly.GetExecutingAssembly())
            .RegisterSource(New ViewRegistrationSource())
        End With

        InitializeContainerPrisma(builder)
        InitializeContainerBusinessDocuments(builder)

        DependencyResolver.SetResolver(New AutofacDependencyResolver(builder.Build()))
    End Sub

    Private Sub InitializeContainerPrisma(builder As ContainerBuilder)
        Dim funcContext As Func(Of IComponentContext, OticasContext) = Function()
                                                                           Return New OticasContext(ClsBaseDados.RetornaConnectionStringEmpresa(), ClsF3MSessao.RetornaUtilizadorNome)
                                                                       End Function

        DependencyInjection.RegisterTypes(builder, funcContext)
    End Sub

    Private Sub InitializeContainerBusinessDocuments(builder As ContainerBuilder)
        Dim funcContext As Func(Of IComponentContext,
            F3M.Core.Business.Documents.Data.Context.ApplicationDbContext) = Function()
                                                                                 Return New F3M.Core.Business.Documents.Data.Context.ApplicationDbContext(ClsBaseDados.RetornaConnectionStringEmpresa(), ClsF3MSessao.RetornaUtilizadorNome)
                                                                             End Function

        BusinessDocumentsIoC.RegisterTypes(builder, funcContext)
    End Sub

    Private Sub InitializeMap()
        Mapper.Initialize(Function(config)
                              With config
                                  .CreateMissingTypeMaps = True
                                  .AllowNullCollections = True
                                  .IgnoreUnmapped()
                              End With
                              Return config
                          End Function)
    End Sub

    '''' <summary>
    '''' Licenciamento
    '''' Indica quais os módulos da aplicação
    '''' </summary>
    Private Sub PreencheModulosAplicacao()

        'Base
        Dim acessoModuloBase As New List(Of Acesso) From {
            New Acesso With {.NomeArea = "Documentos", .NomeControlador = "DocumentosVendasServicos"},
            New Acesso With {.NomeArea = "Documentos", .NomeControlador = "DocumentosVendas"},
            New Acesso With {.NomeArea = "Documentos", .NomeControlador = "DocumentosStock"},
            New Acesso With {.NomeArea = "Documentos", .NomeControlador = "DocumentosCompras"},
            New Acesso With {.NomeArea = "Documentos", .NomeControlador = "DocumentosPagamentosCompras"},
            New Acesso With {.NomeArea = "Artigos", .NomeControlador = "Artigos"},
            New Acesso With {.NomeArea = "Clientes", .NomeControlador = "Clientes"},
            New Acesso With {.NomeArea = "Fornecedores", .NomeControlador = "Fornecedores"},
            New Acesso With {.NomeArea = "TabelasAuxiliares", .NomeControlador = "MedicosTecnicos"},
            New Acesso With {.NomeArea = "TabelasAuxiliares", .NomeControlador = "Especialidades"},
            New Acesso With {.NomeArea = "TabelasAuxiliares", .NomeControlador = "Entidades"},
            New Acesso With {.NomeArea = "TabelasAuxiliares", .NomeControlador = "ComunicacaoSms"},
            New Acesso With {.NomeArea = "Communication", .NomeControlador = "Comunicacaosetting"},
            New Acesso With {.NomeArea = "Caixas", .NomeControlador = "AberturaCaixa"},
            New Acesso With {.NomeArea = "Caixas", .NomeControlador = "MovimentosCaixa"},
            New Acesso With {.NomeArea = "Etiquetas", .NomeControlador = "Etiquetas"},
            New Acesso With {.NomeArea = "Recalculos", .NomeControlador = "Recalculos"},
            New Acesso With {.NomeArea = "Utilitarios", .NomeControlador = "Consultas"},
            New Acesso With {.NomeArea = "Utilitarios", .NomeControlador = "ImportarFicheiros"},
            New Acesso With {.NomeArea = "Utilitarios", .NomeControlador = "SAFTPT"},
            New Acesso With {.NomeArea = "Utilitarios", .NomeControlador = "SAFTPTMensal"},
            New Acesso With {.NomeArea = "Utilitarios", .NomeControlador = "SAFTPTGestao"}
        }

        'Marcações
        Dim acessosModuloMarcacoes As New List(Of Acesso) From {
            New Acesso With {.NomeArea = "Agendamento", .NomeControlador = "Agendamento"},
            New Acesso With {.NomeArea = "Planeamento", .NomeControlador = "Planeamento"},
            New Acesso With {.NomeArea = "Clientes", .NomeControlador = "Clientes"},
            New Acesso With {.NomeArea = "TabelasAuxiliares", .NomeControlador = "MedicosTecnicos"},
            New Acesso With {.NomeArea = "TabelasAuxiliares", .NomeControlador = "Especialidades"}
        }

        'Consultas
        Dim acessosModuloConsultas As New List(Of Acesso) From {
            New Acesso With {.NomeArea = "Exames", .NomeControlador = "Exames"},
            New Acesso With {.NomeArea = "Agendamento", .NomeControlador = "Agendamento"},
            New Acesso With {.NomeArea = "Clientes", .NomeControlador = "Clientes"},
            New Acesso With {.NomeArea = "TabelasAuxiliares", .NomeControlador = "MedicosTecnicos"},
            New Acesso With {.NomeArea = "TabelasAuxiliares", .NomeControlador = "Especialidades"}
        }

        'Contabilidade
        Dim acessosModuloContabilidade As New List(Of Acesso) From {
            New Acesso With {.NomeArea = "Accounting", .NomeControlador = "AccountingExport"},
            New Acesso With {.NomeArea = "Accounting", .NomeControlador = "AccountingConfiguration"}
        }

        'Oficina
        Dim acessosModuloOficina As New List(Of Acesso) From {
            New Acesso With {.NomeArea = "TabelasAuxiliares", .NomeControlador = "TiposFases"},
            New Acesso With {.NomeArea = "Documentos", .NomeControlador = "DocumentosVendasServicosSubstituicao"}
        }

        ModulosAplicacao.InsereModulo(ModulosLicenciamento.Prisma.Base, True, acessoModuloBase)
        ModulosAplicacao.InsereModulo(ModulosLicenciamento.Prisma.Marcacoes, True, acessosModuloMarcacoes)
        ModulosAplicacao.InsereModulo(ModulosLicenciamento.Prisma.Consultas, True, acessosModuloConsultas)
        ModulosAplicacao.InsereModulo(ModulosLicenciamento.Prisma.Contabilidade, True, acessosModuloContabilidade)
        ModulosAplicacao.InsereModulo(ModulosLicenciamento.Prisma.MultiEmpresa)
        ModulosAplicacao.InsereModulo(ModulosLicenciamento.Prisma.Oficina, True, acessosModuloOficina)
    End Sub

    Protected Sub Application_Error()
        Dim ex As Exception = Server.GetLastError()

        ClsLogging.Loggar(ex.Message, TipoErroLog4Net.Log4Error, ex)

        'If HttpContext.Current.Request.Headers("X-Requested-With").Equals("XMLHttpRequest") Then
        '    Dim listaRMSC As New List(Of ClsF3MRespostaMensagemServidorCliente)

        '    listaRMSC.Add(
        '        New ClsF3MRespostaMensagemServidorCliente() With {
        '            .Tipo = TipoAlerta.Erro,
        '            .Mensagem = ex.Message})

        '    Context.ClearError()
        '    Context.Response.ContentType = "application/json"
        '    Context.Response.StatusCode = 200
        '    Context.Response.Write(New JsonResult With {
        '        .JsonRequestBehavior = JsonRequestBehavior.AllowGet,
        '        .Data = New With {.Erros = listaRMSC, .Excepcao = ex}})
        'End If

        If (TypeOf ex Is HttpAntiForgeryException) Then
            Response.Clear()
            Server.ClearError()
            ClsF3MSessao.LimpaSessao()
        End If
    End Sub

    Sub Application_Disposed()
    End Sub

    Sub Application_End()
    End Sub

    Sub Application_BeginRequest()
    End Sub

    Sub Application_EndRequest()
    End Sub

    Sub Application_AcquireRequestState()
    End Sub

    Sub Session_Start()

        'If (_container Is Nothing) Then
        '    Exit Sub
        'End If

        'Dim connectionFactory = _container.GetInstance(Of ConnectionFactory)

        'If (connectionFactory IsNot Nothing) Then
        '    connectionFactory.ChangeConnectionString(ClsBaseDados.RetornaConnectionStringEmpresa())
        'End If

        If ClsF3MSessao.EmDesenvolvimento Then
            F3M.HomeController.ConfiguraKeysWebConfig(ChavesWebConfig.Projeto.Proj)
        End If

        Dim codigoClienteSAAS = If(ChavesWebConfig.Projeto.ModoSAAS, ClsF3MSessao.RetornaCodClienteSAAS(), String.Empty)
        Me.Session.Add("CodigoSAAS", codigoClienteSAAS)
    End Sub

    Sub Session_End(sender As Object, e As EventArgs)
        If Not ClsF3MSessao.EmDesenvolvimento Then ' NOTA: Quando compilamos o projeto o IIS dispara Session_End
            Dim chaveSessao As String = ClsTexto.ConcatenaStrings(New String() {F3M.Modelos.Constantes.ConstAplicacao.ChaveSessaoApp, Me.Session.SessionID})
            ModulosSessao.RemoveTerminadoPor(chaveSessao, Me.Session("CodigoSAAS"))
        End If
    End Sub
End Class