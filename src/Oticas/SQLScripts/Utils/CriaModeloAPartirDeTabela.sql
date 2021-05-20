use f3m

DECLARE 
@Tabela as nvarchar(100)

SELECT @Tabela = 'Artigos'

SELECT 'Imports System.Runtime.Serialization' UNION ALL
SELECT 'Imports System.ComponentModel.DataAnnotations' UNION ALL
SELECT 'Imports F3M.Base' UNION ALL
SELECT 'Imports F3M.Base.Servidor.Atributos' UNION ALL
SELECT 'Imports F3M.Externas.KendoUI.Constantes' UNION ALL

SELECT 'Public Class ' + @Tabela+ '' UNION ALL
SELECT ' Inherits ClsF3MModelo ' UNION ALL

select '<DataMember> ' + char(13)+char(10)+
(CASE WHEN ((tipos.name = 'nvarchar' OR tipos.name = 'varchar' OR tipos.name = 'char') AND colunas.max_length >0 ) THEN '<StringLength('+RTRIM(LTRIM(STR(colunas.max_length/2)))+')>'+ char(13)+char(10) ELSE '' END) +
(case when colunas.is_nullable = 0 then '<Required>'+ char(13)+char(10) else '' end) +
(case when isnull(fks.[column],'') = '' then '<AnotacaoF3M()>' else '  <AnotacaoF3M(ChaveEstrangeira:=True, CaminhoControlador:="../TabelasAuxiliares/'+RIGHT(fks.[referenced_table],LEN(fks.[referenced_table]) - 2)+'", TipoEditor:=Mvc.Componentes.F3MLookup, MapearTabelaChaveEstrangeira:="'+fks.[referenced_table]+'", MapearDescricaoChaveEstrangeira:="Descricao'+RIGHT(fks.[column],LEN(fks.[column]) - 2)+'")>' end) + char(13)+char(10)+
' Public Property ' + colunas.name + ' As ' + 
 (CASE WHEN tipos.name = 'bigint' THEN 'Long' +(CASE WHEN colunas.is_nullable = 0 THEN '?' ELSE '' END)
    WHEN (tipos.name = 'nvarchar' OR tipos.name = 'varchar' OR tipos.name = 'char') THEN 'String'
    WHEN tipos.name = 'bit' THEN 'Boolean'+(CASE WHEN colunas.is_nullable = 0 THEN '?' ELSE '' END)
    WHEN (tipos.name = 'datetime' OR tipos.name = 'date') THEN 'Date'+(CASE WHEN colunas.is_nullable = 0 THEN '?' ELSE '' END)
    WHEN tipos.name = 'timestamp' THEN 'Byte()'
    ELSE '_TEMOS_DE_CONFIRMAR_O_TIPO_DE_DADOS_' END )
from sys.columns as colunas
left join sys.objects as objectos on colunas.object_id = objectos.object_id
left join sys.types as tipos on tipos.system_type_id = colunas.system_type_id  and tipos.user_type_id = colunas.user_type_id 
left join ( SELECT  obj.name AS FK_NAME,    sch.name AS [schema_name],    tab1.name AS [table],    col1.name AS [column],    tab2.name AS [referenced_table],    col2.name AS [referenced_column]
FROM sys.foreign_key_columns fkc
INNER JOIN sys.objects obj ON obj.object_id = fkc.constraint_object_id
INNER JOIN sys.tables tab1 ON tab1.object_id = fkc.parent_object_id
INNER JOIN sys.schemas sch ON tab1.schema_id = sch.schema_id
INNER JOIN sys.columns col1 ON col1.column_id = parent_column_id AND col1.object_id = tab1.object_id
INNER JOIN sys.tables tab2 ON tab2.object_id = fkc.referenced_object_id
INNER JOIN sys.columns col2 ON col2.column_id = referenced_column_id AND col2.object_id = tab2.object_id
WHERE   tab1.name = 'tb' + @Tabela  ) As fks on fks.[column] = colunas.name
where objectos.name = 'tb' + @Tabela and colunas.name not in ('ID', 'Ativo', 'Sistema', 'F3MMarcador', 'UtilizadorCriacao','DataCriacao','UtilizadorAlteracao','DataAlteracao')
UNION ALL
SELECT '''Descrição das Chaves Estrangeiras' UNION ALL
SELECT  '<DataMember> Public Property Descricao'+RIGHT(col1.name,LEN(col1.name) - 2)+' As String'
FROM sys.foreign_key_columns fkc
INNER JOIN sys.objects obj ON obj.object_id = fkc.constraint_object_id
INNER JOIN sys.tables tab1 ON tab1.object_id = fkc.parent_object_id
INNER JOIN sys.schemas sch ON tab1.schema_id = sch.schema_id
INNER JOIN sys.columns col1 ON col1.column_id = parent_column_id AND col1.object_id = tab1.object_id
INNER JOIN sys.tables tab2 ON tab2.object_id = fkc.referenced_object_id
INNER JOIN sys.columns col2 ON col2.column_id = referenced_column_id AND col2.object_id = tab2.object_id
WHERE   tab1.name = 'tb' + @Tabela
UNION ALL
SELECT 'End Class'