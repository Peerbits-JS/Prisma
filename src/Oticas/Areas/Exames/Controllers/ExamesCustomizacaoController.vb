Imports System.Reflection
Imports System.Reflection.Emit
Imports System.Runtime.CompilerServices
Imports F3M.Areas.Comum.Controllers
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio.Exames

Namespace Areas.Exames.Controllers
    Public Class ExamesCustomizacaoController
        Inherits SimpleFormController

        Const ExamesTemplateViewsPath As String = "~/Areas/Exames/Views/ExamesCustomizacao/"

        Public Shared Function CreateClassAtRuntime(ByVal inComponent As Components) As Object

            'get all props
            Dim info() As PropertyInfo = inComponent.GetType().GetProperties()


            Dim ClassProperties As New Dictionary(Of String, Type)


            If inComponent.TipoComponente = "F3MLookup" OrElse inComponent.TipoComponente = "F3MDropDownList" Then
                ClassProperties.Add(inComponent.ModelPropertyName.Replace("ID", "Descricao"), GetType(System.String))

                ClassProperties.Add(inComponent.ModelPropertyName, GetType(System.Nullable(Of Long)))

            Else
                ClassProperties.Add(inComponent.ModelPropertyName, Type.GetType(inComponent.ModelPropertyType))
            End If

            With ClassProperties
                .Add("ID", GetType(Long))
                .Add("ModelPropertyName", GetType(System.String))
                .Add("Label", GetType(System.String))
                .Add("EObrigatorio", GetType(Nullable(Of Boolean)))
                .Add("EEditavel", GetType(Nullable(Of Boolean)))
                .Add("ECustomizacao", GetType(Nullable(Of Boolean)))
                .Add("AtributosHtml", GetType(System.String))
                .Add("ViewClassesCSS", GetType(System.String))
                .Add("StartCol", GetType(System.Int32))
                .Add("EndCol", GetType(System.Int32))
                .Add("Controlador", GetType(System.String))
                .Add("ControladorAcaoExtra", GetType(System.String))
                .Add("CampoTexto", GetType(System.String))
                .Add("ValorPorDefeito", GetType(System.String))
                .Add("AcaoFormulario", GetType(System.Int32))
                .Add("EElementoGridLinhas", GetType(Nullable(Of Boolean)))
                .Add("ValorMinimo", GetType(Nullable(Of Double)))
                .Add("ValorMaximo", GetType(Nullable(Of Double)))
                .Add("Steps", GetType(Nullable(Of Double)))
                .Add("DesenhaBotaoLimpar", GetType(Nullable(Of Boolean)))
                .Add("FuncaoJSChange", GetType(System.String))
                .Add("FuncaoJSEnviaParametros", GetType(System.String))
                .Add("F3MBDID", GetType(System.Int64))
            End With



            Dim CustomClass As Type = CreateClass("NewModel", ClassProperties)

            Dim RuntimeClass As Object = Activator.CreateInstance(CustomClass)

            Extensions.SetProperty(RuntimeClass, "AcaoFormulario", 0)
            Extensions.SetProperty(RuntimeClass, "F3MBDID", inComponent.F3MBDID)
            Extensions.SetProperty(RuntimeClass, "Label", inComponent.Label)
            Extensions.SetProperty(RuntimeClass, "ModelPropertyName", inComponent.ModelPropertyName)
            Extensions.SetProperty(RuntimeClass, "StartCol", inComponent.StartCol)
            Extensions.SetProperty(RuntimeClass, "EndCol", inComponent.EndCol)
            Extensions.SetProperty(RuntimeClass, "AtributosHtml", inComponent.AtributosHtml)
            Extensions.SetProperty(RuntimeClass, "ViewClassesCSS", inComponent.ViewClassesCSS)
            Extensions.SetProperty(RuntimeClass, "EObrigatorio", inComponent.EObrigatorio)
            Extensions.SetProperty(RuntimeClass, "EEditavel", inComponent.EEditavel)

            Extensions.SetProperty(RuntimeClass, "ECustomizacao", inComponent.ECustomizacao)


            Extensions.SetProperty(RuntimeClass, "Controlador", inComponent.Controlador)
            Extensions.SetProperty(RuntimeClass, "ControladorAcaoExtra", inComponent.ControladorAcaoExtra)
            Extensions.SetProperty(RuntimeClass, "CampoTexto", inComponent.CampoTexto)

            Extensions.SetProperty(RuntimeClass, "ValorMinimo", inComponent.ValorMinimo)
            Extensions.SetProperty(RuntimeClass, "ValorMaximo", inComponent.ValorMaximo)
            Extensions.SetProperty(RuntimeClass, "Steps", inComponent.Steps)

            Extensions.SetProperty(RuntimeClass, "EElementoGridLinhas", inComponent.EElementoGridLinhas)
            Extensions.SetProperty(RuntimeClass, "DesenhaBotaoLimpar", inComponent.DesenhaBotaoLimpar)


            Extensions.SetProperty(RuntimeClass, "FuncaoJSChange", inComponent.FuncaoJSChange)
            Extensions.SetProperty(RuntimeClass, "FuncaoJSEnviaParametros", inComponent.FuncaoJSEnviaParametros)


            If Not String.IsNullOrEmpty(inComponent.ValorID) Then
                Select Case inComponent.TipoComponente
                    Case "F3MNumeroInteiro"
                        Extensions.SetProperty(RuntimeClass, inComponent.ModelPropertyName, CInt(inComponent.ValorID))

                    Case "F3MNumeroDecimal"
                        Extensions.SetProperty(RuntimeClass, inComponent.ModelPropertyName, CInt(inComponent.ValorID))

                    Case "F3MData"
                        Extensions.SetProperty(RuntimeClass, inComponent.ModelPropertyName, CDate(inComponent.ValorID))

                    Case "F3MLookup", "F3MDropDownList"
                        Extensions.SetProperty(RuntimeClass, inComponent.ModelPropertyName, CLng(inComponent.ValorID))
                        Extensions.SetProperty(RuntimeClass, inComponent.ModelPropertyName.Replace("ID", "Descricao"), inComponent.ValorDescricao)

                    Case "F3MCheckBox"
                        Extensions.SetProperty(RuntimeClass, inComponent.ModelPropertyName, CBool(inComponent.ValorID))

                    Case Else
                        Extensions.SetProperty(RuntimeClass, inComponent.ModelPropertyName, inComponent.ValorID)
                End Select
            End If

            Extensions.SetProperty(RuntimeClass, "ValorPorDefeito", inComponent.ValorPorDefeito)

            Return RuntimeClass
        End Function

        Public Shared Function CreateClass(ByVal inClassName As String, ByVal inProps As Dictionary(Of String, Type)) As Type
            Dim myDomain As AppDomain = AppDomain.CurrentDomain
            Dim myAsmName As New AssemblyName("MyAssembly")
            Dim myAssembly As AssemblyBuilder = myDomain.DefineDynamicAssembly(myAsmName, AssemblyBuilderAccess.Run)
            Dim myModule As ModuleBuilder = myAssembly.DefineDynamicModule("MyModule")
            Dim myType As TypeBuilder = myModule.DefineType(inClassName, TypeAttributes.Public)

            myType.DefineDefaultConstructor(MethodAttributes.Public)

            For Each prop In inProps
                Dim propBuilder As PropertyBuilder = myType.DefineProperty(prop.Key, PropertyAttributes.HasDefault, prop.Value, Nothing)
                Dim field As FieldBuilder = myType.DefineField("_" + prop.Key, prop.Value, FieldAttributes.[Private])

                'define getter
                Dim getter As MethodBuilder = myType.DefineMethod("get_" + prop.Key, MethodAttributes.[Public] Or MethodAttributes.SpecialName Or MethodAttributes.HideBySig, prop.Value, Type.EmptyTypes)
                Dim getterIL As ILGenerator = getter.GetILGenerator()
                With getterIL
                    .Emit(OpCodes.Ldarg_0)
                    .Emit(OpCodes.Ldfld, field)
                    .Emit(OpCodes.Ret)
                End With

                'define setter
                Dim setter As MethodBuilder = myType.DefineMethod("set_" + prop.Key, MethodAttributes.[Public] Or MethodAttributes.SpecialName Or MethodAttributes.HideBySig, Nothing, New Type() {prop.Value})
                Dim setterIL As ILGenerator = setter.GetILGenerator()
                With setterIL
                    .Emit(OpCodes.Ldarg_0)
                    .Emit(OpCodes.Ldarg_1)
                    .Emit(OpCodes.Stfld, field)
                    .Emit(OpCodes.Ret)
                End With

                'attr methods get and set
                With propBuilder
                    .SetGetMethod(getter)
                    .SetSetMethod(setter)
                End With
            Next

            'return my type created
            Return myType.CreateType()
        End Function
    End Class


    Public Module Extensions
        <Extension()>
        Public Function GetProperty(ByVal Instance As Object, ByVal PropertyName As String) As Object
            Return Instance.GetType().GetProperty(PropertyName).GetValue(Instance)
        End Function

        <Extension()>
        Public Sub SetProperty(ByVal Instance As Object, ByVal PropertyName As String, ByVal Value As Object)
            Instance.GetType().GetProperty(PropertyName).SetValue(Instance, Value)
        End Sub
    End Module
End Namespace