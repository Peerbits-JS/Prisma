'------------------------------------------------------------------------------
' <auto-generated>
'     This code was generated by a tool.
'     Runtime Version:4.0.30319.42000
'
'     Changes to this file may cause incorrect behavior and will be lost if
'     the code is regenerated.
' </auto-generated>
'------------------------------------------------------------------------------

Option Strict On
Option Explicit On

Imports System


'This class was auto-generated by the StronglyTypedResourceBuilder
'class via a tool like ResGen or Visual Studio.
'To add or remove a member, edit your .ResX file then rerun ResGen
'with the /str option, or rebuild your VS project.
'''<summary>
'''  A strongly-typed resource class, for looking up localized strings, etc.
'''</summary>
<Global.System.CodeDom.Compiler.GeneratedCodeAttribute("System.Resources.Tools.StronglyTypedResourceBuilder", "15.0.0.0"),  _
 Global.System.Diagnostics.DebuggerNonUserCodeAttribute(),  _
 Global.System.Runtime.CompilerServices.CompilerGeneratedAttribute()>  _
Public Class Estrutura
    
    Private Shared resourceMan As Global.System.Resources.ResourceManager
    
    Private Shared resourceCulture As Global.System.Globalization.CultureInfo
    
    <Global.System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1811:AvoidUncalledPrivateCode")>  _
    Friend Sub New()
        MyBase.New
    End Sub
    
    '''<summary>
    '''  Returns the cached ResourceManager instance used by this class.
    '''</summary>
    <Global.System.ComponentModel.EditorBrowsableAttribute(Global.System.ComponentModel.EditorBrowsableState.Advanced)>  _
    Public Shared ReadOnly Property ResourceManager() As Global.System.Resources.ResourceManager
        Get
            If Object.ReferenceEquals(resourceMan, Nothing) Then
                Dim temp As Global.System.Resources.ResourceManager = New Global.System.Resources.ResourceManager("OticasTraducao.Estrutura", GetType(Estrutura).Assembly)
                resourceMan = temp
            End If
            Return resourceMan
        End Get
    End Property
    
    '''<summary>
    '''  Overrides the current thread's CurrentUICulture property for all
    '''  resource lookups using this strongly typed resource class.
    '''</summary>
    <Global.System.ComponentModel.EditorBrowsableAttribute(Global.System.ComponentModel.EditorBrowsableState.Advanced)>  _
    Public Shared Property Culture() As Global.System.Globalization.CultureInfo
        Get
            Return resourceCulture
        End Get
        Set
            resourceCulture = value
        End Set
    End Property
    
    '''<summary>
    '''  Looks up a localized string similar to A caixa não está aberta..
    '''</summary>
    Public Shared ReadOnly Property CaixaNaoEstaAberta() As String
        Get
            Return ResourceManager.GetString("CaixaNaoEstaAberta", resourceCulture)
        End Get
    End Property
    
    '''<summary>
    '''  Looks up a localized string similar to Cor Fundo.
    '''</summary>
    Public Shared ReadOnly Property CorFundo() As String
        Get
            Return ResourceManager.GetString("CorFundo", resourceCulture)
        End Get
    End Property
    
    '''<summary>
    '''  Looks up a localized string similar to Cor Fundo 1ª Vez.
    '''</summary>
    Public Shared ReadOnly Property CorFundo1Vez() As String
        Get
            Return ResourceManager.GetString("CorFundo1Vez", resourceCulture)
        End Get
    End Property
    
    '''<summary>
    '''  Looks up a localized string similar to Cor Texto.
    '''</summary>
    Public Shared ReadOnly Property CorTexto() As String
        Get
            Return ResourceManager.GetString("CorTexto", resourceCulture)
        End Get
    End Property
    
    '''<summary>
    '''  Looks up a localized string similar to Cor Texto 1ª Vez.
    '''</summary>
    Public Shared ReadOnly Property CorTexto1Vez() As String
        Get
            Return ResourceManager.GetString("CorTexto1Vez", resourceCulture)
        End Get
    End Property
    
    '''<summary>
    '''  Looks up a localized string similar to Loja.
    '''</summary>
    Public Shared ReadOnly Property Loja() As String
        Get
            Return ResourceManager.GetString("Loja", resourceCulture)
        End Get
    End Property
    
    '''<summary>
    '''  Looks up a localized string similar to Médico.
    '''</summary>
    Public Shared ReadOnly Property Medico() As String
        Get
            Return ResourceManager.GetString("Medico", resourceCulture)
        End Get
    End Property
    
    '''<summary>
    '''  Looks up a localized string similar to Contribuinte.
    '''</summary>
    Public Shared ReadOnly Property NumContribuinte() As String
        Get
            Return ResourceManager.GetString("NumContribuinte", resourceCulture)
        End Get
    End Property
    
    '''<summary>
    '''  Looks up a localized string similar to A caixa é obrigatória.
    '''</summary>
    Public Shared ReadOnly Property ObrigatorioSelecionarCaixa() As String
        Get
            Return ResourceManager.GetString("ObrigatorioSelecionarCaixa", resourceCulture)
        End Get
    End Property
    
    '''<summary>
    '''  Looks up a localized string similar to Óculos.
    '''</summary>
    Public Shared ReadOnly Property Oculos() As String
        Get
            Return ResourceManager.GetString("Oculos", resourceCulture)
        End Get
    End Property
    
    '''<summary>
    '''  Looks up a localized string similar to Tem agenda.
    '''</summary>
    Public Shared ReadOnly Property TemAgenda() As String
        Get
            Return ResourceManager.GetString("TemAgenda", resourceCulture)
        End Get
    End Property
    
    '''<summary>
    '''  Looks up a localized string similar to Tempo por consulta.
    '''</summary>
    Public Shared ReadOnly Property Tempoporconsulta() As String
        Get
            Return ResourceManager.GetString("Tempoporconsulta", resourceCulture)
        End Get
    End Property
End Class
