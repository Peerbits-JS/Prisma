﻿'------------------------------------------------------------------------------
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
<Global.System.CodeDom.Compiler.GeneratedCodeAttribute("System.Resources.Tools.StronglyTypedResourceBuilder", "16.0.0.0"),  _
 Global.System.Diagnostics.DebuggerNonUserCodeAttribute(),  _
 Global.System.Runtime.CompilerServices.CompilerGeneratedAttribute()>  _
Public Class EstruturaServicos
    
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
                Dim temp As Global.System.Resources.ResourceManager = New Global.System.Resources.ResourceManager("OticasTraducao.EstruturaServicos", GetType(EstruturaServicos).Assembly)
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
    '''  Looks up a localized string similar to Balcão.
    '''</summary>
    Public Shared ReadOnly Property Balcao() As String
        Get
            Return ResourceManager.GetString("Balcao", resourceCulture)
        End Get
    End Property
    
    '''<summary>
    '''  Looks up a localized string similar to Controlo.
    '''</summary>
    Public Shared ReadOnly Property Controlo() As String
        Get
            Return ResourceManager.GetString("Controlo", resourceCulture)
        End Get
    End Property
    
    '''<summary>
    '''  Looks up a localized string similar to Entrega.
    '''</summary>
    Public Shared ReadOnly Property Entrega() As String
        Get
            Return ResourceManager.GetString("Entrega", resourceCulture)
        End Get
    End Property
    
    '''<summary>
    '''  Looks up a localized string similar to Importar consulta.
    '''</summary>
    Public Shared ReadOnly Property ImportarReceita() As String
        Get
            Return ResourceManager.GetString("ImportarReceita", resourceCulture)
        End Get
    End Property
    
    '''<summary>
    '''  Looks up a localized string similar to Importar subserviço.
    '''</summary>
    Public Shared ReadOnly Property ImportarSubservico() As String
        Get
            Return ResourceManager.GetString("ImportarSubservico", resourceCulture)
        End Get
    End Property
    
    '''<summary>
    '''  Looks up a localized string similar to Localização.
    '''</summary>
    Public Shared ReadOnly Property Localizacao() As String
        Get
            Return ResourceManager.GetString("Localizacao", resourceCulture)
        End Get
    End Property
    
    '''<summary>
    '''  Looks up a localized string similar to Montagem.
    '''</summary>
    Public Shared ReadOnly Property Montagem() As String
        Get
            Return ResourceManager.GetString("Montagem", resourceCulture)
        End Get
    End Property
    
    '''<summary>
    '''  Looks up a localized string similar to Pedido aro.
    '''</summary>
    Public Shared ReadOnly Property PedidoAro() As String
        Get
            Return ResourceManager.GetString("PedidoAro", resourceCulture)
        End Get
    End Property
    
    '''<summary>
    '''  Looks up a localized string similar to Pedido lente direita.
    '''</summary>
    Public Shared ReadOnly Property PedidoLenteDireita() As String
        Get
            Return ResourceManager.GetString("PedidoLenteDireita", resourceCulture)
        End Get
    End Property
    
    '''<summary>
    '''  Looks up a localized string similar to Pedido lente esquerda.
    '''</summary>
    Public Shared ReadOnly Property PedidoLenteEsquerda() As String
        Get
            Return ResourceManager.GetString("PedidoLenteEsquerda", resourceCulture)
        End Get
    End Property
    
    '''<summary>
    '''  Looks up a localized string similar to Receção aro.
    '''</summary>
    Public Shared ReadOnly Property RececaoAro() As String
        Get
            Return ResourceManager.GetString("RececaoAro", resourceCulture)
        End Get
    End Property
    
    '''<summary>
    '''  Looks up a localized string similar to Receção lente direita.
    '''</summary>
    Public Shared ReadOnly Property RececaoLenteDireita() As String
        Get
            Return ResourceManager.GetString("RececaoLenteDireita", resourceCulture)
        End Get
    End Property
    
    '''<summary>
    '''  Looks up a localized string similar to Receção lente esquerda.
    '''</summary>
    Public Shared ReadOnly Property RececaoLenteEsquerda() As String
        Get
            Return ResourceManager.GetString("RececaoLenteEsquerda", resourceCulture)
        End Get
    End Property
    
    '''<summary>
    '''  Looks up a localized string similar to Subserviço.
    '''</summary>
    Public Shared ReadOnly Property Subservico() As String
        Get
            Return ResourceManager.GetString("Subservico", resourceCulture)
        End Get
    End Property
End Class