// Copyright 2021-present StarRocks, Inc. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

parser grammar StarRocksParser;
options { tokenVocab = StarRocksLexer; }

sqlStatements
    : singleStatement* EOF
    ;

singleStatement
    : statement SEMICOLON?
    ;

statement
    // Query Statement
    : queryStatement

    // Database Statement
    | useDatabaseStatement
    | useCatalogStatement
    | setCatalogStatement
    | showDatabasesStatement
    | alterDbQuotaStatement
    | createDbStatement
    | dropDbStatement
    | showCreateDbStatement
    | alterDatabaseRenameStatement
    | recoverDbStmt
    | showDataStmt
    | showDataDistributionStmt

    // Table Statement
    | createTableStatement
    | createTableAsSelectStatement
    | createTableLikeStatement
    | showCreateTableStatement
    | dropTableStatement
    | cleanTemporaryTableStatement
    | recoverTableStatement
    | truncateTableStatement
    | showTableStatement
    | descTableStatement
    | showTableStatusStatement
    | showColumnStatement
    | refreshTableStatement
    | alterTableStatement
    | cancelAlterTableStatement
    | showAlterStatement
    | showTemporaryTablesStatement

    // View Statement
    | createViewStatement
    | alterViewStatement
    | dropViewStatement

    // Partition Statement
    | showPartitionsStatement
    | recoverPartitionStatement

    // Index Statement
    | createIndexStatement
    | dropIndexStatement
    | showIndexStatement

    // Task Statement
    | submitTaskStatement
    | dropTaskStatement

    // Materialized View Statement
    | createMaterializedViewStatement
    | showMaterializedViewsStatement
    | dropMaterializedViewStatement
    | alterMaterializedViewStatement
    | refreshMaterializedViewStatement
    | cancelRefreshMaterializedViewStatement

    // Catalog Statement
    | createExternalCatalogStatement
    | dropExternalCatalogStatement
    | showCatalogsStatement
    | showCreateExternalCatalogStatement
    | alterCatalogStatement

    // DML Statement
    | insertStatement
    | updateStatement
    | deleteStatement

    // Routine Statement
    | createRoutineLoadStatement
    | alterRoutineLoadStatement
    | stopRoutineLoadStatement
    | resumeRoutineLoadStatement
    | pauseRoutineLoadStatement
    | showRoutineLoadStatement
    | showRoutineLoadTaskStatement
    | showCreateRoutineLoadStatement

    // StreamLoad Statement
    | showStreamLoadStatement

    // Admin Statement
    | adminSetConfigStatement
    | adminSetReplicaStatusStatement
    | adminShowConfigStatement
    | adminShowReplicaDistributionStatement
    | adminShowReplicaStatusStatement
    | adminRepairTableStatement
    | adminCancelRepairTableStatement
    | adminCheckTabletsStatement
    | adminSetPartitionVersion
    | killStatement
    | syncStatement
    | executeScriptStatement
    | adminSetAutomatedSnapshotOnStatement
    | adminSetAutomatedSnapshotOffStatement

    // Cluster Management Statement
    | alterSystemStatement
    | cancelAlterSystemStatement
    | showComputeNodesStatement

    // Analyze Statement
    | analyzeStatement
    | dropStatsStatement
    | createAnalyzeStatement
    | dropAnalyzeJobStatement
    | analyzeHistogramStatement
    | dropHistogramStatement
    | showAnalyzeStatement
    | showStatsMetaStatement
    | showHistogramMetaStatement
    | killAnalyzeStatement

    // Profile Statement
    | analyzeProfileStatement

    // Resource Group Statement
    | createResourceGroupStatement
    | dropResourceGroupStatement
    | alterResourceGroupStatement
    | showResourceGroupStatement
    | showResourceGroupUsageStatement

    // External Resource Statement
    | createResourceStatement
    | alterResourceStatement
    | dropResourceStatement
    | showResourceStatement

    // UDF Statement
    | showFunctionsStatement
    | dropFunctionStatement
    | createFunctionStatement

    // Load Statement
    | loadStatement
    | showLoadStatement
    | showLoadWarningsStatement
    | cancelLoadStatement
    | alterLoadStatement

    // Show Statement
    | showAuthorStatement
    | showBackendsStatement
    | showBrokerStatement
    | showCharsetStatement
    | showCollationStatement
    | showDeleteStatement
    | showDynamicPartitionStatement
    | showEventsStatement
    | showEnginesStatement
    | showFrontendsStatement
    | showPluginsStatement
    | showRepositoriesStatement
    | showOpenTableStatement
    | showPrivilegesStatement
    | showProcedureStatement
    | showProcStatement
    | showProcesslistStatement
    | showProfilelistStatement
    | showRunningQueriesStatement
    | showStatusStatement
    | showTabletStatement
    | showTransactionStatement
    | showTriggersStatement
    | showUserPropertyStatement
    | showVariablesStatement
    | showWarningStatement
    | helpStatement

    // authz Statement
    | createUserStatement
    | dropUserStatement
    | alterUserStatement
    | showUserStatement
    | showAuthenticationStatement
    | executeAsStatement
    | createRoleStatement
    | alterRoleStatement
    | dropRoleStatement
    | showRolesStatement
    | grantRoleStatement
    | revokeRoleStatement
    | setRoleStatement
    | setDefaultRoleStatement
    | grantPrivilegeStatement
    | revokePrivilegeStatement
    | showGrantsStatement

    // Security Integration Statement
    | createSecurityIntegrationStatement
    | alterSecurityIntegrationStatement
    | dropSecurityIntegrationStatement
    | showSecurityIntegrationStatement
    | showCreateSecurityIntegrationStatement

    // Group Provider Statement
    | createGroupProviderStatement
    | dropGroupProviderStatement
    | showGroupProvidersStatement
    | showCreateGroupProviderStatement

    // Backup Restore Statement
    | backupStatement
    | cancelBackupStatement
    | showBackupStatement
    | restoreStatement
    | cancelRestoreStatement
    | showRestoreStatement
    | showSnapshotStatement
    | createRepositoryStatement
    | dropRepositoryStatement

    // Sql BlackList And WhiteList Statement
    | addSqlBlackListStatement
    | delSqlBlackListStatement
    | showSqlBlackListStatement
    | showWhiteListStatement

    // Backend BlackList
    | addBackendBlackListStatement
    | delBackendBlackListStatement
    | showBackendBlackListStatement

    // Data Cache management statement
    | createDataCacheRuleStatement
    | showDataCacheRulesStatement
    | dropDataCacheRuleStatement
    | clearDataCacheRulesStatement
    | dataCacheSelectStatement

    // Export Statement
    | exportStatement
    | cancelExportStatement
    | showExportStatement

    // Plugin Statement
    | installPluginStatement
    | uninstallPluginStatement

    // File Statement
    | createFileStatement
    | dropFileStatement
    | showSmallFilesStatement

    // Set Statement
    | setStatement
    | setUserPropertyStatement

    // Storage Volume Statement
    | createStorageVolumeStatement
    | alterStorageVolumeStatement
    | dropStorageVolumeStatement
    | showStorageVolumesStatement
    | descStorageVolumeStatement
    | setDefaultStorageVolumeStatement

    // Pipe Statement
    | createPipeStatement
    | dropPipeStatement
    | alterPipeStatement
    | showPipeStatement
    | descPipeStatement

    // Compaction Statement
    | cancelCompactionStatement

    // FailPoint Statement
    | updateFailPointStatusStatement
    | showFailPointStatement

    // prepare_stmt
    | prepareStatement
    | executeStatement
    | deallocateStatement

    // Dictionary Statement
    | createDictionaryStatement
    | dropDictionaryStatement
    | refreshDictionaryStatement
    | showDictionaryStatement
    | cancelRefreshDictionaryStatement

    // Plan advisor statement
    | alterPlanAdvisorAddStatement
    | truncatePlanAdvisorStatement
    | alterPlanAdvisorDropStatement
    | showPlanAdvisorStatement

    // Warehouse Statement
    | createWarehouseStatement
    | dropWarehouseStatement
    | suspendWarehouseStatement
    | resumeWarehouseStatement
    | setWarehouseStatement
    | showWarehousesStatement
    | showClustersStatement
    | showNodesStatement
    | alterWarehouseStatement

    // CNGroup Statement
    | createCNGroupStatement
    | dropCNGroupStatement
    | enableCNGroupStatement
    | disableCNGroupStatement
    | alterCNGroupStatement

    // Transaction Statement
    | beginStatement
    | commitStatement
    | rollbackStatement

    // Translate Statement
    | translateStatement

    // SQL Plan Management Statement
    | createBaselinePlanStatement
    | dropBaselinePlanStatement
    | showBaselinePlanStatement
    | disableBaselinePlanStatement
    | enableBaselinePlanStatement

    // Unsupported Statement
    | unsupportedStatement
    ;

// ---------------------------------------- DataBase Statement ---------------------------------------------------------

useDatabaseStatement
    : USE qualifiedName
    ;

useCatalogStatement
    : USE string
    ;

setCatalogStatement
    : SET CATALOG identifierOrString
    ;

showDatabasesStatement
    : SHOW DATABASES ((FROM | IN) catalog=qualifiedName)? ((LIKE pattern=string) | (WHERE expression))?
    | SHOW SCHEMAS ((LIKE pattern=string) | (WHERE expression))?
    ;

alterDbQuotaStatement
    : ALTER DATABASE identifier SET DATA QUOTA identifier
    | ALTER DATABASE identifier SET REPLICA QUOTA INTEGER_VALUE
    ;

createDbStatement
    : CREATE (DATABASE | SCHEMA) (IF NOT EXISTS)? (catalog=identifier DOT)? database=qualifiedName charsetDesc? collateDesc? properties?
    ;

dropDbStatement
    : DROP (DATABASE | SCHEMA) (IF EXISTS)? (catalog=identifier DOT)? database=qualifiedName FORCE?
    ;

showCreateDbStatement
    : SHOW CREATE (DATABASE | SCHEMA) identifier
    ;

alterDatabaseRenameStatement
    : ALTER DATABASE identifier RENAME identifier
    ;

recoverDbStmt
    : RECOVER (DATABASE | SCHEMA) identifier
    ;

showDataStmt
    : SHOW DATA
    | SHOW DATA FROM qualifiedName
    ;

showDataDistributionStmt
    : SHOW DATA DISTRIBUTION FROM qualifiedName partitionNames?
    ;

// ------------------------------------------- Table Statement ---------------------------------------------------------

createTableStatement
    : CREATE (TEMPORARY | EXTERNAL)? TABLE (IF NOT EXISTS)? qualifiedName
          LEFT_PAREN columnDesc (COMMA columnDesc)* (COMMA indexDesc)* RIGHT_PAREN
          engineDesc?
          charsetDesc?
          keyDesc?
          comment?
          partitionDesc?
          distributionDesc?
          orderByDesc?
          rollupDesc?
          properties?
          extProperties?
     ;


columnDesc
    : identifier type? charsetName? KEY? aggDesc? columnNullable?
    (defaultDesc | AUTO_INCREMENT | generatedColumnDesc)?
    comment?
    ;

charsetName
    : CHAR SET identifier
    | CHARSET identifier
    | CHARACTER SET identifier
    ;

defaultDesc
    : DEFAULT (string | NULL | CURRENT_TIMESTAMP (LEFT_PAREN (INTEGER_VALUE)? RIGHT_PAREN)? | LEFT_PAREN qualifiedName LEFT_PAREN RIGHT_PAREN RIGHT_PAREN)
    ;

generatedColumnDesc
    : AS expression
    ;

indexDesc
    : INDEX indexName=identifier identifierList (indexType propertyList?)? comment?
    ;

engineDesc
    : ENGINE EQ identifier
    ;

charsetDesc
    : DEFAULT? (CHAR SET | CHARSET | CHARACTER SET) EQ? identifierOrString
    ;

collateDesc
    : DEFAULT? COLLATE EQ? identifierOrString
    ;

keyDesc
    : (AGGREGATE | UNIQUE | PRIMARY | DUPLICATE) KEY identifierList
    ;

orderByDesc
    : ORDER BY identifierList
    ;

columnNullable
    : NULL
    | NOT NULL
    ;

typeWithNullable
    : type columnNullable?
    ;

aggStateDesc
    : identifier LEFT_PAREN typeWithNullable (COMMA typeWithNullable)* RIGHT_PAREN
    ;

aggDesc
    : SUM
    | MAX
    | MIN
    | REPLACE
    | HLL_UNION
    | BITMAP_UNION
    | PERCENTILE_UNION
    | REPLACE_IF_NOT_NULL
    | aggStateDesc
    ;

rollupDesc
    : ROLLUP LEFT_PAREN rollupItem (COMMA rollupItem)* RIGHT_PAREN
    ;

rollupItem
    : rollupName=identifier identifierList (dupKeys)? (fromRollup)? properties?
    ;

dupKeys
    : DUPLICATE KEY identifierList
    ;

fromRollup
    : FROM identifier
    ;

orReplace:
    (OR REPLACE)?
    ;
ifNotExists:
    (IF NOT EXISTS)?
    ;

createTableAsSelectStatement
    : CREATE TEMPORARY? TABLE (IF NOT EXISTS)? qualifiedName
        (LEFT_PAREN (identifier (COMMA identifier)*  (COMMA indexDesc)* | indexDesc (COMMA indexDesc)*) RIGHT_PAREN)?
        keyDesc?
        comment?
        partitionDesc?
        distributionDesc?
        orderByDesc?
        properties?
        AS queryStatement
    ;


dropTableStatement
    : DROP TEMPORARY? TABLE (IF EXISTS)? qualifiedName FORCE?
    ;

cleanTemporaryTableStatement
    : CLEAN TEMPORARY TABLE ON SESSION string
    ;

alterTableStatement
    : ALTER TABLE qualifiedName alterClause (COMMA alterClause)*
    | ALTER TABLE qualifiedName ADD ROLLUP rollupItem (COMMA rollupItem)*
    | ALTER TABLE qualifiedName DROP ROLLUP identifier (COMMA identifier)*
    ;

createIndexStatement
    : CREATE INDEX indexName=identifier
        ON qualifiedName identifierList (indexType propertyList?)?
        comment?
    ;

dropIndexStatement
    : DROP INDEX indexName=identifier ON qualifiedName
    ;

indexType
    : USING (BITMAP | GIN | NGRAMBF | VECTOR)
    ;

showTableStatement
    : SHOW FULL? TABLES ((FROM | IN) db=qualifiedName)? ((LIKE pattern=string) | (WHERE expression))?
    ;

showTemporaryTablesStatement
    : SHOW TEMPORARY TABLES ((FROM | IN) db=qualifiedName)? ((LIKE pattern=string) | (WHERE expression))?
    ;

showCreateTableStatement
    : SHOW CREATE (TABLE | VIEW | MATERIALIZED VIEW) table=qualifiedName
    ;

showColumnStatement
    : SHOW FULL? (COLUMNS | FIELDS) ((FROM | IN) table=qualifiedName) ((FROM | IN) db=qualifiedName)?
        ((LIKE pattern=string) | (WHERE expression))?
    ;

showTableStatusStatement
    : SHOW TABLE STATUS ((FROM | IN) db=qualifiedName)? ((LIKE pattern=string) | (WHERE expression))?
    ;

refreshTableStatement
    : REFRESH EXTERNAL TABLE qualifiedName (PARTITION LEFT_PAREN string (COMMA string)* RIGHT_PAREN)?
    ;

showAlterStatement
    : SHOW ALTER TABLE (COLUMN | ROLLUP | OPTIMIZE) ((FROM | IN) db=qualifiedName)?
        (WHERE expression)? (ORDER BY sortItem (COMMA sortItem)*)? (limitElement)?
    | SHOW ALTER MATERIALIZED VIEW ((FROM | IN) db=qualifiedName)?
              (WHERE expression)? (ORDER BY sortItem (COMMA sortItem)*)? (limitElement)?
    ;

descTableStatement
    : (DESC | DESCRIBE) ((table=qualifiedName ALL?) | (FILES propertyList))
    ;

createTableLikeStatement
    : CREATE (TEMPORARY | EXTERNAL)? TABLE (IF NOT EXISTS)? qualifiedName
        partitionDesc?
        distributionDesc?
        properties?
        LIKE qualifiedName
    ;

showIndexStatement
    : SHOW (INDEX | INDEXES | KEY | KEYS) ((FROM | IN) table=qualifiedName) ((FROM | IN) db=qualifiedName)?
    ;

recoverTableStatement
    : RECOVER TABLE qualifiedName
    ;

truncateTableStatement
    : TRUNCATE TABLE qualifiedName partitionNames?
    ;

cancelAlterTableStatement
    : CANCEL ALTER TABLE (COLUMN | ROLLUP | OPTIMIZE)? FROM qualifiedName (LEFT_PAREN INTEGER_VALUE (COMMA INTEGER_VALUE)* RIGHT_PAREN)?
    | CANCEL ALTER MATERIALIZED VIEW FROM qualifiedName
    ;

showPartitionsStatement
    : SHOW TEMPORARY? PARTITIONS FROM table=qualifiedName
    (WHERE expression)?
    (ORDER BY sortItem (COMMA sortItem)*)? limitElement?
    ;

recoverPartitionStatement
    : RECOVER PARTITION identifier FROM table=qualifiedName
    ;

// ------------------------------------------- View Statement ----------------------------------------------------------

createViewStatement
    : CREATE (OR REPLACE)? VIEW (IF NOT EXISTS)? qualifiedName
    (LEFT_PAREN columnNameWithComment (COMMA columnNameWithComment)* RIGHT_PAREN)?
    comment?
    (SECURITY (NONE | INVOKER))?
    AS queryStatement
    ;

alterViewStatement
    : ALTER VIEW qualifiedName (LEFT_PAREN columnNameWithComment (COMMA columnNameWithComment)* RIGHT_PAREN)? AS queryStatement
    | ALTER VIEW qualifiedName SET SECURITY (NONE | INVOKER)
    | ALTER VIEW qualifiedName SET properties
    | ALTER VIEW qualifiedName (ADD | MODIFY) DIALECT (STARROCKS)?  queryStatement
    ;

dropViewStatement
    : DROP VIEW (IF EXISTS)? qualifiedName
    ;

columnNameWithComment
    : columnName=identifier comment?
    ;

// ------------------------------------------- Task Statement ----------------------------------------------------------

submitTaskStatement
    : SUBMIT TASK qualifiedName?
        taskClause*
        AS (createTableAsSelectStatement | insertStatement | dataCacheSelectStatement)
    ;

taskClause
    : properties
    | taskScheduleDesc
    ;

dropTaskStatement
    : DROP TASK qualifiedName FORCE?
    ;

taskScheduleDesc
    : SCHEDULE (START LEFT_PAREN string RIGHT_PAREN)? EVERY LEFT_PAREN taskInterval RIGHT_PAREN
    ;

// ------------------------------------------- Materialized View Statement ---------------------------------------------

createMaterializedViewStatement
    : CREATE MATERIALIZED VIEW (IF NOT EXISTS)? mvName=qualifiedName
    (LEFT_PAREN columnNameWithComment (COMMA columnNameWithComment)* (COMMA indexDesc)* RIGHT_PAREN)?
    comment?
    materializedViewDesc*
    AS queryStatement
    ;

mvPartitionExprs:
    primaryExpression
    | LEFT_PAREN primaryExpression (COMMA primaryExpression)* RIGHT_PAREN
    ;

materializedViewDesc
    : (PARTITION BY mvPartitionExprs)
    | distributionDesc
    | orderByDesc
    | refreshSchemeDesc
    | properties
    ;

showMaterializedViewsStatement
    : SHOW MATERIALIZED VIEWS ((FROM | IN) db=qualifiedName)? ((LIKE pattern=string) | (WHERE expression))?
    ;

dropMaterializedViewStatement
    : DROP MATERIALIZED VIEW (IF EXISTS)? mvName=qualifiedName
    ;

alterMaterializedViewStatement
    : ALTER MATERIALIZED VIEW mvName=qualifiedName (
        refreshSchemeDesc |
        tableRenameClause |
        modifyPropertiesClause |
        swapTableClause )
    | ALTER MATERIALIZED VIEW mvName=qualifiedName statusDesc
    ;

refreshMaterializedViewStatement
    : REFRESH MATERIALIZED VIEW mvName=qualifiedName (PARTITION (partitionRangeDesc | listPartitionValues))? FORCE? (WITH (SYNC | ASYNC) MODE)? (WITH PRIORITY priority=INTEGER_VALUE)?
    ;

cancelRefreshMaterializedViewStatement
    : CANCEL REFRESH MATERIALIZED VIEW mvName=qualifiedName FORCE?
    ;

// ------------------------------------------- Admin Statement ---------------------------------------------------------

adminSetConfigStatement
    : ADMIN SET FRONTEND CONFIG LEFT_PAREN property RIGHT_PAREN (WITH PERSISTENT)?
    ;
adminSetReplicaStatusStatement
    : ADMIN SET REPLICA STATUS properties
    ;
adminShowConfigStatement
    : ADMIN SHOW FRONTEND CONFIG (LIKE pattern=string)?
    ;

adminShowReplicaDistributionStatement
    : ADMIN SHOW REPLICA DISTRIBUTION FROM qualifiedName partitionNames?
    ;

adminShowReplicaStatusStatement
    : ADMIN SHOW REPLICA STATUS FROM qualifiedName partitionNames? (WHERE where=expression)?
    ;

adminRepairTableStatement
    : ADMIN REPAIR TABLE qualifiedName partitionNames?
    ;

adminCancelRepairTableStatement
    : ADMIN CANCEL REPAIR TABLE qualifiedName partitionNames?
    ;

adminCheckTabletsStatement
    : ADMIN CHECK tabletList PROPERTIES LEFT_PARENpropertyRIGHT_PAREN
    ;

adminSetPartitionVersion
    : ADMIN SET TABLE qualifiedName PARTITION LEFT_PAREN(partitionName=identifierOrString | partitionId=INTEGER_VALUE)RIGHT_PAREN VERSION TO version=INTEGER_VALUE
    ;

killStatement
    : KILL (CONNECTION? | QUERY) (connId=INTEGER_VALUE | queryId=string)
    ;

syncStatement
    : SYNC
    ;

adminSetAutomatedSnapshotOnStatement
    : ADMIN SET AUTOMATED CLUSTER SNAPSHOT ON (STORAGE VOLUME svName=identifier)?
    ;

adminSetAutomatedSnapshotOffStatement
    : ADMIN SET AUTOMATED CLUSTER SNAPSHOT OFF
    ;

// ------------------------------------------- Cluster Management Statement ---------------------------------------------

alterSystemStatement
    : ALTER SYSTEM alterClause
    ;

cancelAlterSystemStatement
    : CANCEL DECOMMISSION BACKEND string (COMMA string)*
    ;

showComputeNodesStatement
    : SHOW COMPUTE NODES
    ;

// ------------------------------------------- Catalog Statement -------------------------------------------------------

createExternalCatalogStatement
    : CREATE EXTERNAL CATALOG (IF NOT EXISTS)? catalogName=identifierOrString comment? properties
    ;

showCreateExternalCatalogStatement
    : SHOW CREATE CATALOG catalogName=identifierOrString
    ;

dropExternalCatalogStatement
    : DROP CATALOG (IF EXISTS)? catalogName=identifierOrString
    ;

showCatalogsStatement
    : SHOW CATALOGS (LIKE pattern=string)?
    ;

alterCatalogStatement
    : ALTER CATALOG catalogName=identifierOrString modifyPropertiesClause
    ;

// ---------------------------------------- Storage Volume Statement ---------------------------------------------------

createStorageVolumeStatement
    : CREATE STORAGE VOLUME (IF NOT EXISTS)? storageVolumeName=identifierOrString typeDesc locationsDesc
          comment? properties?
    ;

typeDesc
    : TYPE EQ identifier
    ;

locationsDesc
    : LOCATIONS EQ stringList
    ;

showStorageVolumesStatement
    : SHOW STORAGE VOLUMES (LIKE pattern=string)?
    ;

dropStorageVolumeStatement
    : DROP STORAGE VOLUME (IF EXISTS)? storageVolumeName=identifierOrString
    ;

alterStorageVolumeStatement
    : ALTER STORAGE VOLUME identifierOrString alterStorageVolumeClause (COMMA alterStorageVolumeClause)*
    ;

alterStorageVolumeClause
    : modifyStorageVolumeCommentClause
    | modifyStorageVolumePropertiesClause
    ;

modifyStorageVolumePropertiesClause
    : SET propertyList
    ;

modifyStorageVolumeCommentClause
    : COMMENT '=' string
    ;

descStorageVolumeStatement
    : (DESC | DESCRIBE) STORAGE VOLUME identifierOrString
    ;

setDefaultStorageVolumeStatement
    : SET identifierOrString AS DEFAULT STORAGE VOLUME
    ;

// ------------------------------------------- FailPoint Statement -----------------------------------------------------

updateFailPointStatusStatement
    : ADMIN (DISABLE | ENABLE) FAILPOINT string
      (WITH (times=INTEGER_VALUE TIMES | prob=DECIMAL_VALUE PROBABILITY))?
      (ON (BACKEND string | FRONTEND))?
    ;

showFailPointStatement
    : SHOW FAILPOINTS ((LIKE pattern=string))? (ON BACKEND string)?
    ;

// ------------------------------------------- Dictionary Statement -----------------------------------------------------

createDictionaryStatement
    : CREATE DICTIONARY dictionaryName USING qualifiedName
        LEFT_PAREN dictionaryColumnDesc (COMMA dictionaryColumnDesc)* RIGHT_PAREN
        properties?
    ;

dropDictionaryStatement
    : DROP DICTIONARY qualifiedName CACHE?
    ;

refreshDictionaryStatement
    : REFRESH DICTIONARY qualifiedName
    ;

showDictionaryStatement
    : SHOW DICTIONARY qualifiedName?
    ;

cancelRefreshDictionaryStatement
    : CANCEL REFRESH DICTIONARY qualifiedName;

dictionaryColumnDesc
    : qualifiedName KEY
    | qualifiedName VALUE
    ;

dictionaryName
    : qualifiedName
    ;

// ------------------------------------------- Alter Clause ------------------------------------------------------------

alterClause
    //Alter system clause
    : addFrontendClause
    | dropFrontendClause
    | modifyFrontendHostClause
    | addBackendClause
    | dropBackendClause
    | decommissionBackendClause
    | modifyBackendClause
    | addComputeNodeClause
    | dropComputeNodeClause
    | modifyBrokerClause
    | alterLoadErrorUrlClause
    | createImageClause
    | cleanTabletSchedQClause
    | decommissionDiskClause
    | cancelDecommissionDiskClause
    | disableDiskClause
    | cancelDisableDiskClause

    //Alter table clause
    | createIndexClause
    | dropIndexClause
    | tableRenameClause
    | swapTableClause
    | modifyPropertiesClause
    | addColumnClause
    | addColumnsClause
    | dropColumnClause
    | modifyColumnCommentClause
    | modifyColumnClause
    | columnRenameClause
    | reorderColumnsClause
    | rollupRenameClause
    | compactionClause
    | modifyCommentClause
    | optimizeClause
    | addFieldClause
    | dropFieldClause
    | createOrReplaceBranchClause
    | createOrReplaceTagClause
    | dropBranchClause
    | dropTagClause
    | tableOperationClause
    | dropPersistentIndexClause

    //Alter partition clause
    | addPartitionClause
    | dropPartitionClause
    | distributionClause
    | truncatePartitionClause
    | modifyPartitionClause
    | replacePartitionClause
    | partitionRenameClause
    ;

// ---------Alter system clause---------

addFrontendClause
   : ADD (FOLLOWER | OBSERVER) string
   ;

dropFrontendClause
   : DROP (FOLLOWER | OBSERVER) string
   ;

modifyFrontendHostClause
  : MODIFY FRONTEND HOST string TO string
  ;

addBackendClause
   : ADD BACKEND string (COMMA string)* (INTO WAREHOUSE warehouseName=identifierOrString (CNGROUP cngroupName=identifierOrString)?)?
   ;

dropBackendClause
   : DROP BACKEND string (COMMA string)* (FROM WAREHOUSE warehouseName=identifierOrString (CNGROUP cngroupName=identifierOrString)?)? FORCE?
   ;

decommissionBackendClause
   : DECOMMISSION BACKEND string (COMMA string)*
   ;

modifyBackendClause
   : MODIFY BACKEND HOST string TO string
   | MODIFY BACKEND string SET propertyList
   ;

addComputeNodeClause
   : ADD COMPUTE NODE string (COMMA string)* (INTO WAREHOUSE warehouseName=identifierOrString (CNGROUP cngroupName=identifierOrString)?)?
   ;

dropComputeNodeClause
   : DROP COMPUTE NODE string (COMMA string)* (FROM WAREHOUSE warehouseName=identifierOrString (CNGROUP cngroupName=identifierOrString)?)?
   ;

modifyBrokerClause
    : ADD BROKER identifierOrString string (COMMA string)*
    | DROP BROKER identifierOrString string (COMMA string)*
    | DROP ALL BROKER identifierOrString
    ;

alterLoadErrorUrlClause
    : SET LOAD ERRORS HUB properties?
    ;

createImageClause
    : CREATE IMAGE
    ;

cleanTabletSchedQClause
    : CLEAN TABLET SCHEDULER QUEUE
    ;

decommissionDiskClause
    : DECOMMISSION DISK string (COMMA string)* ON BACKEND string
    ;

cancelDecommissionDiskClause
    : CANCEL DECOMMISSION DISK string (COMMA string)* ON BACKEND string
    ;

disableDiskClause
    : DISABLE DISK string (COMMA string)* ON BACKEND string
    ;

cancelDisableDiskClause
    : CANCEL DISABLE DISK string (COMMA string)* ON BACKEND string
    ;

// ---------Alter table clause---------

createIndexClause
    : ADD INDEX indexName=identifier identifierList (indexType propertyList?)? comment?
    ;

dropIndexClause
    : DROP INDEX indexName=identifier
    ;

tableRenameClause
    : RENAME identifier
    ;

swapTableClause
    : SWAP WITH identifier
    ;

modifyPropertiesClause
    : SET propertyList
    ;

modifyCommentClause
    : COMMENT '=' string
    ;

optimizeRange
    : BETWEEN start=string AND end=string
    ;

optimizeClause
    : partitionNames?
      keyDesc?
      partitionDesc?
      orderByDesc?
      distributionDesc?
      optimizeRange?
     ;

addColumnClause
    : ADD COLUMN columnDesc (FIRST | AFTER identifier)? ((TO | IN) rollupName=identifier)? properties?
    ;

addColumnsClause
    : ADD COLUMN LEFT_PAREN columnDesc (COMMA columnDesc)* RIGHT_PAREN ((TO | IN) rollupName=identifier)? properties?
    ;

dropColumnClause
    : DROP COLUMN identifier (FROM rollupName=identifier)? properties?
    ;

modifyColumnClause
    : MODIFY COLUMN columnDesc (FIRST | AFTER identifier)? (FROM rollupName=identifier)? properties?
    ;

modifyColumnCommentClause
    : MODIFY COLUMN identifier comment
    ;

columnRenameClause
    : RENAME COLUMN oldColumn=identifier TO newColumn=identifier
    ;

reorderColumnsClause
    : ORDER BY identifierList (FROM rollupName=identifier)? properties?
    ;

rollupRenameClause
    : RENAME ROLLUP rollupName=identifier newRollupName=identifier
    ;

compactionClause
    : (BASE | CUMULATIVE)? COMPACT (identifier | identifierList)?
    ;

subfieldName
    : identifier | ARRAY_ELEMENT
    ;

nestedFieldName
    : subfieldName (DOT_IDENTIFIER | DOT subfieldName)*
    ;

addFieldClause
    : MODIFY COLUMN identifier ADD FIELD subfieldDesc (FIRST | AFTER identifier)? properties?
    ;

dropFieldClause
    : MODIFY COLUMN identifier DROP FIELD nestedFieldName properties?
    ;

createOrReplaceTagClause
    : (CREATE OR)? REPLACE TAG identifier tagOptions
    | CREATE TAG (IF NOT EXISTS)? identifier tagOptions
    ;

createOrReplaceBranchClause
    : (CREATE OR)? REPLACE BRANCH identifier branchOptions
    | CREATE BRANCH (IF NOT EXISTS)? identifier branchOptions
    ;

dropBranchClause
    : DROP BRANCH (IF EXISTS)? identifier
    ;

dropTagClause
    : DROP TAG (IF EXISTS)? identifier
    ;

tableOperationClause
    : EXECUTE functionCall
    ;

tagOptions
    : (AS OF VERSION snapshotId)? (refRetain)?
    ;

branchOptions
    : (AS OF VERSION snapshotId)? (refRetain)? (snapshotRetention)?
    ;

snapshotRetention
    : WITH SNAPSHOT RETENTION minSnapshotsToKeep
    | WITH SNAPSHOT RETENTION maxSnapshotAge
    | WITH SNAPSHOT RETENTION minSnapshotsToKeep maxSnapshotAge
    ;

refRetain
    : RETAIN number timeUnit
    ;

maxSnapshotAge
    : number timeUnit
    ;

minSnapshotsToKeep
    : number SNAPSHOTS
    ;

snapshotId
    : number
    ;

timeUnit
    : DAYS
    | HOURS
    | MINUTES
    ;

integer_list
    : LEFT_PAREN INTEGER_VALUE (COMMA INTEGER_VALUE)* RIGHT_PAREN
    ;

dropPersistentIndexClause
    : DROP PERSISTENT INDEX ON TABLETS integer_list
    ;

// ---------Alter partition clause---------

addPartitionClause
    : ADD TEMPORARY? (singleRangePartition | PARTITIONS multiRangePartition) distributionDesc? properties?
    | ADD TEMPORARY? (singleItemListPartitionDesc | multiItemListPartitionDesc) distributionDesc? properties?
    ;

dropPartitionClause
    : DROP TEMPORARY? (PARTITION (IF EXISTS)? identifier | PARTITIONS (IF EXISTS)? identifierList) FORCE?
    | DROP TEMPORARY? PARTITIONS (IF EXISTS)? multiRangePartition FORCE?
    | DROP TEMPORARY? PARTITIONS (IF EXISTS)? WHERE where=expression FORCE?
    | DROP ALL TEMPORARY PARTITIONS FORCE?
    ;

truncatePartitionClause
    : TRUNCATE partitionNames
    ;

modifyPartitionClause
    : MODIFY PARTITION (identifier | identifierList | LEFT_PAREN ASTERISK_SYMBOL RIGHT_PAREN) SET propertyList
    | MODIFY PARTITION distributionDesc
    ;

replacePartitionClause
    : REPLACE parName=partitionNames WITH tempParName=partitionNames properties?
    ;

partitionRenameClause
    : RENAME PARTITION parName=identifier newParName=identifier
    ;

// ------------------------------------------- DML Statement -----------------------------------------------------------

insertStatement
    : explainDesc? INSERT (INTO | OVERWRITE) (qualifiedName writeBranch? partitionNames? | (FILES propertyList) | (BLACKHOLE LEFT_PAREN RIGHT_PAREN))
        insertLabelOrColumnAliases* properties?
        (queryStatement | (VALUES expressionsWithDefault (COMMA expressionsWithDefault)*))
    ;

// for compatibility with the case 'LABEL before columnAliases'
insertLabelOrColumnAliases
    : columnAliasesOrByName
    | WITH LABEL label=identifier
    ;

columnAliasesOrByName
    : columnAliases
    | BY NAME
    ;

updateStatement
    : explainDesc? withClause? UPDATE qualifiedName SET assignmentList fromClause (WHERE where=expression)?
    ;

deleteStatement
    : explainDesc? withClause? DELETE FROM qualifiedName partitionNames? (USING using=relations)? (WHERE where=expression)?
    ;

// ------------------------------------------- Routine Statement -----------------------------------------------------------
createRoutineLoadStatement
    : CREATE ROUTINE LOAD (db=qualifiedName DOT)? name=identifier ON table=qualifiedName
        loadPropertiesExpr
        jobProperties?
        FROM source=identifier
        dataSourceProperties?
    ;

alterRoutineLoadStatement
    : ALTER ROUTINE LOAD FOR (db=qualifiedName DOT)? name=identifier
        loadPropertiesExpr
        jobProperties?
        dataSource?
    ;

loadPropertiesExpr
    : (loadProperties (COMMA loadProperties)*)?
    ;

dataSource
    : FROM source=identifier dataSourceProperties
    ;

loadProperties
    : colSeparatorProperty
    | rowDelimiterProperty
    | importColumns
    | WHERE expression
    | partitionNames
    ;

colSeparatorProperty
    : COLUMNS TERMINATED BY string
    ;

rowDelimiterProperty
    : ROWS TERMINATED BY string
    ;

importColumns
    : COLUMNS columnProperties
    ;

columnProperties
    : LEFT_PAREN
        (qualifiedName | assignment) (COMMA (qualifiedName | assignment))*
      RIGHT_PAREN
    ;

jobProperties
    : properties
    ;

dataSourceProperties
    : propertyList
    ;

stopRoutineLoadStatement
    : STOP ROUTINE LOAD FOR (db=qualifiedName DOT)? name=identifier
    ;

resumeRoutineLoadStatement
    : RESUME ROUTINE LOAD FOR (db=qualifiedName DOT)? name=identifier
    ;

pauseRoutineLoadStatement
    : PAUSE ROUTINE LOAD FOR (db=qualifiedName DOT)? name=identifier
    ;

showRoutineLoadStatement
    : SHOW ALL? ROUTINE LOAD (FOR (db=qualifiedName DOT)? name=identifier)?
        (FROM db=qualifiedName)?
        (WHERE expression)? (ORDER BY sortItem (COMMA sortItem)*)? (limitElement)?
    ;

showRoutineLoadTaskStatement
    : SHOW ROUTINE LOAD TASK
        (FROM db=qualifiedName)?
        WHERE expression
    ;

showCreateRoutineLoadStatement
    : SHOW CREATE ROUTINE LOAD (db=qualifiedName DOT)? name=identifier
    ;

showStreamLoadStatement
    : SHOW ALL? STREAM LOAD (FOR (db=qualifiedName DOT)? name=identifier)?
        (FROM db=qualifiedName)?
        (WHERE expression)? (ORDER BY sortItem (COMMA sortItem)*)? (limitElement)?
    ;
// ------------------------------------------- Analyze Statement -------------------------------------------------------

analyzeStatement
    : ANALYZE (FULL | SAMPLE)? TABLE tableName analyzeColumnClause? partitionNames?
        (WITH (SYNC | ASYNC) MODE)?
        properties?
    ;

analyzeColumnClause
    : LEFT_PAREN qualifiedName  (COMMA qualifiedName)* RIGHT_PAREN               #regularColumns
    | qualifiedName  (COMMA qualifiedName)*                       #regularColumns
    | ALL COLUMNS                                               #allColumns
    | PREDICATE COLUMNS                                         #predicateColumns
    | MULTIPLE COLUMNS LEFT_PAREN qualifiedName  (COMMA qualifiedName)* RIGHT_PAREN #multiColumnSet
    ;

dropStatsStatement
    : DROP (MULTIPLE COLUMNS)? STATS qualifiedName
    ;

histogramStatement:
    ANALYZE TABLE tableName UPDATE HISTOGRAM ON analyzeColumnClause
        (WITH bucket=INTEGER_VALUE BUCKETS)?
        properties?
    ;

analyzeHistogramStatement
    : histogramStatement
        (WITH (SYNC | ASYNC) MODE)?
    ;

dropHistogramStatement
    : ANALYZE TABLE qualifiedName DROP HISTOGRAM ON qualifiedName (COMMA qualifiedName)*
    ;

createAnalyzeStatement
    : CREATE ANALYZE (FULL | SAMPLE)? ALL properties?
    | CREATE ANALYZE (FULL | SAMPLE)? DATABASE db=identifier properties?
    | CREATE ANALYZE (FULL | SAMPLE)? TABLE qualifiedName (LEFT_PAREN qualifiedName (COMMA qualifiedName)* RIGHT_PAREN)? properties?
    | CREATE histogramStatement
    ;

dropAnalyzeJobStatement
    : DROP ANALYZE INTEGER_VALUE
    | DROP ALL ANALYZE JOB
    ;

showAnalyzeStatement
    : SHOW ANALYZE (JOB | STATUS)? (WHERE expression)? (ORDER BY sortItem (COMMA sortItem)*)? limitElement?
    ;

showStatsMetaStatement
    : SHOW (MULTIPLE COLUMNS)? STATS META (WHERE expression)? (ORDER BY sortItem (COMMA sortItem)*)? limitElement?
    ;

showHistogramMetaStatement
    : SHOW HISTOGRAM META (WHERE expression)? (ORDER BY sortItem (COMMA sortItem)*)? limitElement?
    ;

killAnalyzeStatement
    : KILL ANALYZE INTEGER_VALUE
    ;

// ----------------------------------------- Analyze Profile Statement -------------------------------------------------

analyzeProfileStatement
    : ANALYZE PROFILE FROM string
    | ANALYZE PROFILE FROM string COMMA INTEGER_VALUE (COMMA INTEGER_VALUE)*
    ;


// ----------------------------------------- SQL Plan Manager Statement -------------------------------------------------
createBaselinePlanStatement
    : CREATE GLOBAL? BASELINE (ON queryRelation)? USING queryRelation properties?
    ;

dropBaselinePlanStatement
    : DROP BASELINE INTEGER_VALUE (COMMA INTEGER_VALUE)*
    ;

showBaselinePlanStatement
    : SHOW BASELINE (WHERE expression)?

    ;

disableBaselinePlanStatement
    : DISABLE BASELINE INTEGER_VALUE (COMMA INTEGER_VALUE)*
    ;

enableBaselinePlanStatement
    : ENABLE BASELINE INTEGER_VALUE (COMMA INTEGER_VALUE)*
    ;

// ------------------------------------------- Work Group Statement ----------------------------------------------------

createResourceGroupStatement
    : CREATE RESOURCE GROUP (IF NOT EXISTS)? (OR REPLACE)? identifier
        (TO classifier (COMMA classifier)*)?  WITH LEFT_PAREN property (COMMA property)* RIGHT_PAREN
    ;

dropResourceGroupStatement
    : DROP RESOURCE GROUP identifier
    ;

alterResourceGroupStatement
    : ALTER RESOURCE GROUP identifier ADD classifier (COMMA classifier)*
    | ALTER RESOURCE GROUP identifier DROP LEFT_PAREN INTEGER_VALUE (COMMA INTEGER_VALUE)* RIGHT_PAREN
    | ALTER RESOURCE GROUP identifier DROP ALL
    | ALTER RESOURCE GROUP identifier WITH LEFT_PAREN property (COMMA property)* RIGHT_PAREN
    ;

showResourceGroupStatement
    : SHOW VERBOSE? RESOURCE GROUP identifier
    | SHOW VERBOSE? RESOURCE GROUPS ALL?
    ;

showResourceGroupUsageStatement
    : SHOW USAGE RESOURCE GROUP identifier
    | SHOW USAGE RESOURCE GROUPS
    ;

createResourceStatement
    : CREATE EXTERNAL? RESOURCE resourceName=identifierOrString properties?
    ;

alterResourceStatement
    : ALTER RESOURCE resourceName=identifierOrString SET properties
    ;

dropResourceStatement
    : DROP RESOURCE resourceName=identifierOrString
    ;

showResourceStatement
    : SHOW RESOURCES
    ;

classifier
    : LEFT_PAREN expressionList RIGHT_PAREN
    ;

// ------------------------------------------- UDF Statement ----------------------------------------------------

showFunctionsStatement
    : SHOW FULL? (BUILTIN|GLOBAL)? FUNCTIONS ((FROM | IN) db=qualifiedName)? ((LIKE pattern=string) | (WHERE expression))?
    ;

dropFunctionStatement
    : DROP GLOBAL? FUNCTION (IF EXISTS)?  qualifiedName LEFT_PAREN typeList RIGHT_PAREN
    ;

createFunctionStatement
    : CREATE orReplace GLOBAL? functionType=(TABLE | AGGREGATE)? FUNCTION ifNotExists qualifiedName LEFT_PAREN typeList RIGHT_PAREN RETURNS returnType=type (properties|inlineProperties)?? inlineFunction?
    ;
inlineFunction
    : AS ATTACHMENT
    ;

typeList
    : type?  ( COMMA type)* (COMMA DOTDOTDOT) ?
    ;

// ------------------------------------------- Load Statement ----------------------------------------------------------

loadStatement
    : LOAD LABEL label=labelName
        data=dataDescList?
        broker=brokerDesc?
        (BY system=identifierOrString)?
        (PROPERTIES props=propertyList)?
    | LOAD LABEL label=labelName
        data=dataDescList?
        resource=resourceDesc
        (PROPERTIES props=propertyList)?
    ;

labelName
    : (db=identifier DOT)? label=identifier
    ;

dataDescList
    : LEFT_PAREN dataDesc (COMMA dataDesc)* RIGHT_PAREN
    ;

dataDesc
    : DATA INFILE srcFiles=stringList
        NEGATIVE?
        INTO TABLE dstTableName=identifier
        partitions=partitionNames?
        (COLUMNS TERMINATED BY colSep=string)?
        (ROWS TERMINATED BY rowSep=string)?
        format=fileFormat?
        (formatPropsField=formatProps)?
        colList=columnAliases?
        (COLUMNS FROM PATH AS colFromPath=identifierList)?
        (SET colMappingList=classifier)?
        (WHERE where=expression)?
    | DATA FROM TABLE srcTableName=identifier
        NEGATIVE?
        INTO TABLE dstTableName=identifier
        partitions=partitionNames?
        (SET colMappingList=classifier)?
        (WHERE where=expression)?
    ;

formatProps
    :  LEFT_PAREN
            (SKIP_HEADER '=' INTEGER_VALUE)?
            (TRIM_SPACE '=' booleanValue)?
            (ENCLOSE '=' encloseCharacter=string)?
            (ESCAPE '=' escapeCharacter=string)?
        RIGHT_PAREN
    ;

brokerDesc
    : WITH BROKER props=propertyList?
    | WITH BROKER name=identifierOrString props=propertyList?
    ;

resourceDesc
    : WITH RESOURCE name=identifierOrString props=propertyList?
    ;

showLoadStatement
    : SHOW LOAD (ALL)? (FROM identifier)? (WHERE expression)? (ORDER BY sortItem (COMMA sortItem)*)? limitElement?
    ;

showLoadWarningsStatement
    : SHOW LOAD WARNINGS (FROM identifier)? (WHERE expression)? limitElement?
    | SHOW LOAD WARNINGS ON string
    ;

cancelLoadStatement
    : CANCEL LOAD (FROM identifier)? (WHERE expression)?
    ;

alterLoadStatement
    : ALTER LOAD FOR (db=qualifiedName DOT)? name=identifier
        jobProperties?
    ;

// ------------------------------------------- Compaction Statement ----------------------------------------------------------

cancelCompactionStatement
    : CANCEL COMPACTION WHERE expression
    ;

// ------------------------------------------- Show Statement ----------------------------------------------------------

showAuthorStatement
    : SHOW AUTHORS
    ;

showBackendsStatement
    : SHOW BACKENDS
    ;

showBrokerStatement
    : SHOW BROKER
    ;

showCharsetStatement
    : SHOW (CHAR SET | CHARSET | CHARACTER SET) ((LIKE pattern=string) | (WHERE expression))?
    ;

showCollationStatement
    : SHOW COLLATION ((LIKE pattern=string) | (WHERE expression))?
    ;

showDeleteStatement
    : SHOW DELETE ((FROM | IN) db=qualifiedName)?
    ;

showDynamicPartitionStatement
    : SHOW DYNAMIC PARTITION TABLES ((FROM | IN) db=qualifiedName)?
    ;

showEventsStatement
    : SHOW EVENTS ((FROM | IN) catalog=qualifiedName)? ((LIKE pattern=string) | (WHERE expression))?
    ;

showEnginesStatement
    : SHOW ENGINES
    ;

showFrontendsStatement
    : SHOW FRONTENDS
    ;

showPluginsStatement
    : SHOW PLUGINS
    ;

showRepositoriesStatement
    : SHOW REPOSITORIES
    ;

showOpenTableStatement
    : SHOW OPEN TABLES
    ;
showPrivilegesStatement
    : SHOW PRIVILEGES
    ;

showProcedureStatement
    : SHOW (PROCEDURE | FUNCTION) STATUS ((LIKE pattern=string) | (WHERE where=expression))?
    ;

showProcStatement
    : SHOW PROC path=string
    ;

showProcesslistStatement
    : SHOW FULL? PROCESSLIST (FOR string)?
    ;

showProfilelistStatement
    : SHOW PROFILELIST (LIMIT limit =INTEGER_VALUE)?
    ;

showRunningQueriesStatement
    : SHOW RUNNING QUERIES (LIMIT limit =INTEGER_VALUE)?
    ;

showStatusStatement
    : SHOW varType? STATUS ((LIKE pattern=string) | (WHERE expression))?
    ;

showTabletStatement
    : SHOW TABLET INTEGER_VALUE
    | SHOW (TABLET | TABLETS) FROM qualifiedName partitionNames? (WHERE expression)? (ORDER BY sortItem (COMMA sortItem)*)? (limitElement)?
    ;

showTransactionStatement
    : SHOW TRANSACTION ((FROM | IN) db=qualifiedName)? (WHERE expression)?
    ;

showTriggersStatement
    : SHOW FULL? TRIGGERS ((FROM | IN) catalog=qualifiedName)? ((LIKE pattern=string) | (WHERE expression))?
    ;

showUserPropertyStatement
    : SHOW PROPERTY (FOR string)? (LIKE string)?
    | SHOW PROPERTIES (FOR string)? (LIKE string)?
    ;

showVariablesStatement
    : SHOW varType? VARIABLES ((LIKE pattern=string) | (WHERE expression))?
    ;

showWarningStatement
    : SHOW (WARNINGS | ERRORS) (limitElement)?
    ;

helpStatement
    : HELP identifierOrString
    ;

// ------------------------------------------- Authz Statement -----------------------------------------------------

createUserStatement
    : CREATE USER (IF NOT EXISTS)? user authOption? (DEFAULT ROLE roleList)? properties?
    ;

dropUserStatement
    : DROP USER (IF EXISTS)? user
    ;

alterUserStatement
    : ALTER USER (IF EXISTS)? user authOption
    | ALTER USER (IF EXISTS)? user DEFAULT ROLE (NONE| ALL | roleList)
    | ALTER USER (IF EXISTS)? user SET properties
    ;

showUserStatement
    : SHOW (USER | USERS)
    ;

showAuthenticationStatement
    : SHOW ALL AUTHENTICATION                                                                           #showAllAuthentication
    | SHOW AUTHENTICATION (FOR user)?                                                                   #showAuthenticationForUser
    ;

executeAsStatement
    : EXECUTE AS user (WITH NO REVERT)?
    ;

createRoleStatement
    : CREATE ROLE (IF NOT EXISTS)? roleList comment?
    ;

alterRoleStatement
    : ALTER ROLE (IF EXISTS)? roleList SET COMMENT '=' string
    ;

dropRoleStatement
    : DROP ROLE (IF EXISTS)? roleList
    ;

showRolesStatement
    : SHOW ROLES
    ;

grantRoleStatement
    : GRANT identifierOrStringList TO USER? user                                                        #grantRoleToUser
    | GRANT identifierOrStringList TO ROLE identifierOrString                                           #grantRoleToRole
    ;

revokeRoleStatement
    : REVOKE identifierOrStringList FROM USER? user                                                     #revokeRoleFromUser
    | REVOKE identifierOrStringList FROM ROLE identifierOrString                                        #revokeRoleFromRole
    ;

setRoleStatement
    : SET ROLE DEFAULT
    | SET ROLE NONE
    | SET ROLE ALL (EXCEPT roleList)?
    | SET ROLE roleList
    ;

setDefaultRoleStatement
    : SET DEFAULT ROLE (NONE | ALL | roleList) TO user;

grantRevokeClause
    : (USER? user | ROLE identifierOrString)
    ;

grantPrivilegeStatement
    : GRANT IMPERSONATE ON USER user (COMMA user)* TO grantRevokeClause (WITH GRANT OPTION)?              #grantOnUser
    | GRANT privilegeTypeList ON privObjectNameList TO grantRevokeClause (WITH GRANT OPTION)?           #grantOnTableBrief

    | GRANT privilegeTypeList ON GLOBAL? FUNCTION privFunctionObjectNameList
        TO grantRevokeClause (WITH GRANT OPTION)?                                                       #grantOnFunc
    | GRANT privilegeTypeList ON SYSTEM TO grantRevokeClause (WITH GRANT OPTION)?                       #grantOnSystem
    | GRANT privilegeTypeList ON privObjectType privObjectNameList
        TO grantRevokeClause (WITH GRANT OPTION)?                                                       #grantOnPrimaryObj
    | GRANT privilegeTypeList ON ALL privObjectTypePlural
        (IN isAll=ALL DATABASES| IN DATABASE identifierOrString)? TO grantRevokeClause
        (WITH GRANT OPTION)?                                                                            #grantOnAll
    ;

revokePrivilegeStatement
    : REVOKE IMPERSONATE ON USER user (COMMA user)* FROM grantRevokeClause                                #revokeOnUser
    | REVOKE privilegeTypeList ON privObjectNameList FROM grantRevokeClause                             #revokeOnTableBrief
    | REVOKE privilegeTypeList ON GLOBAL? FUNCTION privFunctionObjectNameList
        FROM grantRevokeClause                                                                          #revokeOnFunc
    | REVOKE privilegeTypeList ON SYSTEM FROM grantRevokeClause                                         #revokeOnSystem
    | REVOKE privilegeTypeList ON privObjectType privObjectNameList
        FROM grantRevokeClause                                                                          #revokeOnPrimaryObj
    | REVOKE privilegeTypeList ON ALL privObjectTypePlural
        (IN isAll=ALL DATABASES| IN DATABASE identifierOrString)? FROM grantRevokeClause                #revokeOnAll
    ;

showGrantsStatement
    : SHOW GRANTS
    | SHOW GRANTS FOR USER? user
    | SHOW GRANTS FOR ROLE identifierOrString
    ;

authOption
    : IDENTIFIED BY PASSWORD? string                                                                    #authWithoutPlugin
    | IDENTIFIED WITH identifierOrString ((BY | AS) string)?                                            #authWithPlugin
    ;

privObjectName
    : identifierOrStringOrStar (DOT identifierOrStringOrStar)?
    ;

privObjectNameList
    : privObjectName (COMMA privObjectName)*
    ;

privFunctionObjectNameList
    : qualifiedName LEFT_PAREN typeList RIGHT_PAREN (COMMA qualifiedName LEFT_PAREN typeList RIGHT_PAREN)*
    ;

privilegeTypeList
    :  privilegeType (COMMA privilegeType)*
    ;

privilegeType
    : ALL PRIVILEGES?
    | ALTER | APPLY | BLACKLIST
    | CREATE (
        DATABASE| TABLE| VIEW| FUNCTION| GLOBAL FUNCTION| MATERIALIZED VIEW|
        RESOURCE| RESOURCE GROUP| EXTERNAL CATALOG | STORAGE VOLUME | WAREHOUSE | CNGROUP | PIPE )
    | DELETE | DROP | EXPORT | FILE | IMPERSONATE | INSERT | GRANT | NODE | OPERATE
    | PLUGIN | REPOSITORY| REFRESH | SELECT | UPDATE | USAGE
    ;

privObjectType
    : CATALOG | DATABASE | MATERIALIZED VIEW | RESOURCE | RESOURCE GROUP | STORAGE VOLUME | SYSTEM | TABLE | VIEW | WAREHOUSE
    | PIPE
    ;

privObjectTypePlural
    : CATALOGS | DATABASES | FUNCTIONS | GLOBAL FUNCTIONS | MATERIALIZED VIEWS | POLICIES | RESOURCES | RESOURCE GROUPS
    | STORAGE VOLUMES | TABLES | USERS | VIEWS | WAREHOUSES | PIPES
    ;

// ------------------------------------------- Security Integration Statement ----------------------------------------------------

createSecurityIntegrationStatement
    : CREATE SECURITY INTEGRATION identifier properties
    ;

alterSecurityIntegrationStatement
    : ALTER SECURITY INTEGRATION identifier SET propertyList
    ;

dropSecurityIntegrationStatement
    : DROP SECURITY INTEGRATION identifier
    ;

showSecurityIntegrationStatement
    : SHOW SECURITY INTEGRATIONS
    ;

showCreateSecurityIntegrationStatement
    : SHOW CREATE SECURITY INTEGRATION identifier
    ;

// ------------------------------------------- Group Provider Statement ------------------------------------------

createGroupProviderStatement
    : CREATE GROUP PROVIDER identifier properties
    ;

dropGroupProviderStatement
    : DROP GROUP PROVIDER identifier
    ;

showGroupProvidersStatement
    : SHOW GROUP PROVIDERS
    ;

showCreateGroupProviderStatement
    : SHOW CREATE GROUP PROVIDER identifier
    ;

// ---------------------------------------- Backup Restore Statement ---------------------------------------------------

backupStatement
    : BACKUP (ALL EXTERNAL CATALOGS | EXTERNAL (CATALOG | CATALOGS) identifierList)? (DATABASE dbName=identifier)?
    SNAPSHOT qualifiedName TO repoName=identifier
    (ON LEFT_PAREN backupRestoreObjectDesc (COMMA backupRestoreObjectDesc) * RIGHT_PAREN)?
    (PROPERTIES propertyList)?
    ;

cancelBackupStatement
    : CANCEL BACKUP ((FROM | IN) identifier | FOR EXTERNAL CATALOG)?
    ;

showBackupStatement
    : SHOW BACKUP ((FROM | IN) identifier)?
    ;

restoreStatement
    : RESTORE SNAPSHOT qualifiedName
    FROM repoName=identifier
    (ALL EXTERNAL CATALOGS | EXTERNAL (CATALOG | CATALOGS) identifierWithAliasList)?
    (DATABASE dbName=identifier (AS dbAlias=identifier)?)?
    (ON LEFT_PAREN backupRestoreObjectDesc (COMMA backupRestoreObjectDesc) * RIGHT_PAREN)?
    (PROPERTIES propertyList)?
    ;

cancelRestoreStatement
    : CANCEL RESTORE ((FROM | IN) identifier | FOR EXTERNAL CATALOG)?
    ;

showRestoreStatement
    : SHOW RESTORE ((FROM | IN) identifier)? (WHERE where=expression)?
    ;

showSnapshotStatement
    : SHOW SNAPSHOT ON identifier
    (WHERE expression)?
    ;

createRepositoryStatement
    : CREATE (READ ONLY)? REPOSITORY repoName=identifier
    WITH BROKER brokerName=identifierOrString?
    ON LOCATION location=string
    (PROPERTIES propertyList)?
    ;

dropRepositoryStatement
    : DROP REPOSITORY identifier
    ;

// ------------------------------------ Sql BlackList And WhiteList Statement ------------------------------------------

addSqlBlackListStatement
    : ADD SQLBLACKLIST string
    ;

delSqlBlackListStatement
    : DELETE SQLBLACKLIST INTEGER_VALUE (COMMA INTEGER_VALUE)*
    ;

showSqlBlackListStatement
    : SHOW SQLBLACKLIST
    ;

showWhiteListStatement
    : SHOW WHITELIST
    ;

// ------------------------------------ backend BlackList Statement ---------------------------------------------------

addBackendBlackListStatement
    : ADD BACKEND BLACKLIST INTEGER_VALUE (COMMA INTEGER_VALUE)*
    ;

delBackendBlackListStatement
    : DELETE BACKEND BLACKLIST INTEGER_VALUE (COMMA INTEGER_VALUE)*
    ;

showBackendBlackListStatement
    : SHOW BACKEND BLACKLIST
    ;

// -------------------------------------- DataCache Management Statement --------------------------------------------

dataCacheTarget
    : identifierOrStringOrStar DOT identifierOrStringOrStar DOT identifierOrStringOrStar
    ;

createDataCacheRuleStatement
    : CREATE DATACACHE RULE dataCacheTarget (WHERE expression)? PRIORITY '=' MINUS_SYMBOL? INTEGER_VALUE properties?
    ;

showDataCacheRulesStatement
    : SHOW DATACACHE RULES
    ;

dropDataCacheRuleStatement
    : DROP DATACACHE RULE INTEGER_VALUE
    ;

clearDataCacheRulesStatement
    : CLEAR DATACACHE RULES
    ;

dataCacheSelectStatement
    : CACHE SELECT selectItem (COMMA selectItem)* FROM qualifiedName (WHERE where=expression)? properties?
    ;

// ------------------------------------------- Export Statement --------------------------------------------------------

exportStatement
    : EXPORT TABLE tableDesc columnAliases? TO string (WITH (SYNC | ASYNC) MODE)? properties? brokerDesc?
    ;

cancelExportStatement
    : CANCEL EXPORT ((FROM | IN) catalog=qualifiedName)? ((LIKE pattern=string) | (WHERE expression))?
    ;

showExportStatement
    : SHOW EXPORT ((FROM | IN) catalog=qualifiedName)?
        ((LIKE pattern=string) | (WHERE expression))?
        (ORDER BY sortItem (COMMA sortItem)*)? (limitElement)?
    ;

// ------------------------------------------- Plugin Statement --------------------------------------------------------

installPluginStatement
    : INSTALL PLUGIN FROM identifierOrString properties?
    ;

uninstallPluginStatement
    : UNINSTALL PLUGIN identifierOrString
    ;

// ------------------------------------------- File Statement ----------------------------------------------------------

createFileStatement
    : CREATE FILE string ((FROM | IN) catalog=qualifiedName)? properties
    ;

dropFileStatement
    : DROP FILE string ((FROM | IN) catalog=qualifiedName)? properties
    ;

showSmallFilesStatement
    : SHOW FILE ((FROM | IN) catalog=qualifiedName)?
    ;

// -------------------------------------------- Pipe Statement ---------------------------------------------------------

createPipeStatement
    : CREATE orReplace PIPE ifNotExists qualifiedName
        properties?
        AS insertStatement
    ;

dropPipeStatement
    : DROP PIPE (IF EXISTS)? qualifiedName
    ;

alterPipeClause
    : SUSPEND |
        RESUME |
        RETRY ALL |
        RETRY FILE fileName=string |
        SET propertyList
    ;

alterPipeStatement
    : ALTER PIPE qualifiedName alterPipeClause
    ;

descPipeStatement
    : (DESC | DESCRIBE) PIPE qualifiedName
    ;

showPipeStatement
    : SHOW PIPES ((LIKE pattern=string) | (WHERE expression) | (FROM qualifiedName))?
        (ORDER BY sortItem (COMMA sortItem)*)? limitElement?
    ;


// ------------------------------------------- Set Statement -----------------------------------------------------------

setStatement
    : SET setVar (COMMA setVar)*
    ;

setVar
    : (CHAR SET | CHARSET | CHARACTER SET) (identifierOrString | DEFAULT)                       #setNames
    | NAMES (charset = identifierOrString | DEFAULT)
        (COLLATE (collate = identifierOrString | DEFAULT))?                                     #setNames
    | PASSWORD '=' (string | PASSWORD LEFT_PAREN string RIGHT_PAREN)                                           #setPassword
    | PASSWORD FOR user '=' (string | PASSWORD LEFT_PAREN string RIGHT_PAREN)                                  #setPassword
    | userVariable '=' expression                                                               #setUserVar
    | varType? identifier '=' setExprOrDefault                                                  #setSystemVar
    | systemVariable '=' setExprOrDefault                                                       #setSystemVar
    | varType? TRANSACTION transaction_characteristics                                          #setTransaction
    ;

transaction_characteristics
    : transaction_access_mode
    | isolation_level
    | transaction_access_mode COMMA isolation_level
    | isolation_level COMMA transaction_access_mode
    ;

transaction_access_mode
    : READ ONLY
    | READ WRITE
    ;

isolation_level
    : ISOLATION LEVEL isolation_types
    ;

isolation_types
    : READ UNCOMMITTED
    | READ COMMITTED
    | REPEATABLE READ
    | SERIALIZABLE
    ;

setExprOrDefault
    : DEFAULT
    | ON
    | ALL
    | expression
    ;

setUserPropertyStatement
    : SET PROPERTY (FOR string)? userPropertyList
    ;

roleList
    : identifierOrString (COMMA identifierOrString)*
    ;

executeScriptStatement
    : ADMIN EXECUTE ON (FRONTEND | INTEGER_VALUE) string
    ;

unsupportedStatement
    : LOCK TABLES lock_item (COMMA lock_item)*
    | UNLOCK TABLES
    ;

lock_item
    : identifier (AS? alias=identifier)? lock_type
    ;

lock_type
    : READ LOCAL?
    | LOW_PRIORITY? WRITE
    ;

// ------------------------------------------- Plan Tuning Statement ---------------------------------------------------
alterPlanAdvisorAddStatement
    : ALTER PLAN ADVISOR ADD queryStatement;

truncatePlanAdvisorStatement
    : TRUNCATE PLAN ADVISOR;

alterPlanAdvisorDropStatement
    : ALTER PLAN ADVISOR DROP string;

showPlanAdvisorStatement
    : SHOW PLAN ADVISOR;

// ---------------------------------------- Warehouse Statement ---------------------------------------------------------

createWarehouseStatement
    : CREATE (WAREHOUSE) (IF NOT EXISTS)? warehouseName=identifierOrString
    comment? properties?
    ;

dropWarehouseStatement
    : DROP WAREHOUSE (IF EXISTS)? warehouseName=identifierOrString
    ;

suspendWarehouseStatement
    : SUSPEND WAREHOUSE (IF EXISTS)? identifier
    ;

resumeWarehouseStatement
    : RESUME WAREHOUSE (IF EXISTS)? identifier
    ;

setWarehouseStatement
    : SET SESSION? WAREHOUSE EQ? identifierOrString
    ;

showWarehousesStatement
    : SHOW WAREHOUSES (LIKE pattern=string)?
    ;

showClustersStatement
    : SHOW (CLUSTERS | CNGROUPS) FROM WAREHOUSE identifier
    ;

showNodesStatement
    : SHOW NODES FROM WAREHOUSES (LIKE pattern=string)?
    | SHOW NODES FROM WAREHOUSE identifier (CNGROUP cngroupName=identifierOrString)?
    ;

alterWarehouseStatement
    : ALTER WAREHOUSE warehouseName=identifierOrString modifyPropertiesClause
    ;

createCNGroupStatement
    : ALTER WAREHOUSE warehouseName=identifierOrString ADD CNGROUP (IF NOT EXISTS)? cngroupName=identifierOrString
    comment? properties?
    ;

dropCNGroupStatement
    : ALTER WAREHOUSE warehouseName=identifierOrString DROP CNGROUP (IF EXISTS)? cngroupName=identifierOrString FORCE?
    ;

enableCNGroupStatement
    : ALTER WAREHOUSE warehouseName=identifierOrString ENABLE CNGROUP cngroupName=identifierOrString
    ;

disableCNGroupStatement
    : ALTER WAREHOUSE warehouseName=identifierOrString DISABLE CNGROUP cngroupName=identifierOrString
    ;

alterCNGroupStatement
    : ALTER WAREHOUSE warehouseName=identifierOrString MODIFY CNGROUP cngroupName=identifierOrString modifyPropertiesClause
    ;

// ------------------------------------------- Transaction Statement ---------------------------------------------------

beginStatement
    : START TRANSACTION (WITH CONSISTENT SNAPSHOT)?
    | BEGIN WORK?
    ;

commitStatement
    : COMMIT WORK? (AND NO? CHAIN)? (NO? RELEASE)?
    ;

rollbackStatement
    : ROLLBACK WORK? (AND NO? CHAIN)? (NO? RELEASE)?
    ;


// ------------------------------------------- Translate Statement -----------------------------------------------------
translateStatement
    : TRANSLATE dialect translateSQL
    ;

dialect
    : identifier
    ;

translateSQL
    : .+
    ;

// ------------------------------------------- Query Statement ---------------------------------------------------------

queryStatement
    : (explainDesc | optimizerTrace) ? queryRelation outfile?;

queryRelation
    : withClause? queryNoWith
    ;

withClause
    : WITH commonTableExpression (COMMA commonTableExpression)*
    ;

queryNoWith
    : queryPrimary (ORDER BY sortItem (COMMA sortItem)*)? (limitElement)?
    ;

queryPeriod
    : FOR? periodType BETWEEN expression AND expression
    | FOR? periodType FROM expression TO expression
    | FOR? periodType ALL
    | FOR? periodType AS OF end=expression
    ;

periodType
    : SYSTEM_TIME
    | TIMESTAMP
    | VERSION
    ;

queryPrimary
    : querySpecification                                                                    #queryPrimaryDefault
    | subquery                                                                              #queryWithParentheses
    | left=queryPrimary operator=INTERSECT setQuantifier? right=queryPrimary                #setOperation
    | left=queryPrimary operator=(UNION | EXCEPT | MINUS)
        setQuantifier? right=queryPrimary                                                   #setOperation
    ;

subquery
    : LEFT_PAREN queryRelation RIGHT_PAREN
    ;

rowConstructor
     :LEFT_PAREN expressionList RIGHT_PAREN
     ;

sortItem
    : expression ordering = (ASC | DESC)? (NULLS nullOrdering=(FIRST | LAST))?
    ;

limitConstExpr
    : INTEGER_VALUE
    | PARAMETER
    | userVariable
    ;

limitElement
    : LIMIT limit=limitConstExpr (OFFSET offset=limitConstExpr)?
    | LIMIT offset=limitConstExpr COMMA limit=limitConstExpr
    ;

querySpecification
    : SELECT setQuantifier? selectItem (COMMA selectItem)*
      fromClause
      ((WHERE where=expression)? (GROUP BY groupingElement)? (HAVING having=expression)?
       (QUALIFY qualifyFunction=selectItem comparisonOperator limit=INTEGER_VALUE)?)
    ;

fromClause
    : (FROM relations pivotClause?)?                                                    #from
    | FROM DUAL                                                                         #dual
    ;

groupingElement
    : ROLLUP LEFT_PAREN (expressionList)? RIGHT_PAREN                                                  #rollup
    | CUBE LEFT_PAREN (expressionList)? RIGHT_PAREN                                                    #cube
    | GROUPING SETS LEFT_PAREN groupingSet (COMMA groupingSet)* RIGHT_PAREN                              #multipleGroupingSets
    | expressionList                                                                    #singleGroupingSet
    ;

groupingSet
    : LEFT_PAREN expression? (COMMA expression)* RIGHT_PAREN
    ;

commonTableExpression
    : name=identifier (columnAliases)? AS LEFT_PAREN queryRelation RIGHT_PAREN
    ;

setQuantifier
    : DISTINCT
    | ALL
    ;

selectItem
    : expression (AS? (identifier | string))?                                            #selectSingle
    | qualifiedName DOT ASTERISK_SYMBOL excludeClause?                                   #selectAll
    | ASTERISK_SYMBOL excludeClause?                                                     #selectAll
    ;

excludeClause
    : ( EXCEPT | EXCLUDE ) LEFT_PAREN identifier (COMMA identifier)* RIGHT_PAREN
    ;

relations
    : relation (COMMA LATERAL? relation)*
    ;

relation
    : relationPrimary joinRelation*
    | LEFT_PAREN relationPrimary joinRelation* RIGHT_PAREN
    ;

relationPrimary
    : qualifiedName queryPeriod? partitionNames? tabletList? replicaList? sampleClause? (
        AS? alias=identifier)? bracketHint? (BEFORE ts=string)?                          #tableAtom
    | LEFT_PAREN VALUES rowConstructor (COMMA rowConstructor)* RIGHT_PAREN
        (AS? alias=identifier columnAliases?)?                                          #inlineTable
    | ASSERT_ROWS? subquery (AS? alias=identifier columnAliases?)?                      #subqueryWithAlias
    | qualifiedName LEFT_PAREN expressionList RIGHT_PAREN
        (AS? alias=identifier columnAliases?)?                                          #tableFunction
    | TABLE LEFT_PAREN qualifiedName LEFT_PAREN argumentList RIGHT_PAREN RIGHT_PAREN
        (AS? alias=identifier columnAliases?)?                                          #normalizedTableFunction
    | FILES propertyList
        (AS? alias=identifier columnAliases?)?                                          #fileTableFunction
    | LEFT_PAREN relations RIGHT_PAREN                                                                 #parenthesizedRelation
    ;

pivotClause
    : PIVOT LEFT_PAREN pivotAggregationExpression (COMMA pivotAggregationExpression)*
        FOR (identifier | identifierList) IN LEFT_PAREN pivotValue (COMMA pivotValue)* RIGHT_PAREN RIGHT_PAREN
    ;

pivotAggregationExpression
    : functionCall (AS? (identifier | string))?
    ;


pivotValue
    : (literalExpression | literalExpressionList) (AS? (identifier | string))?
    ;

sampleClause
    : SAMPLE propertyList?
    ;

argumentList
    : expressionList
    | namedArgumentList
    ;

namedArgumentList
    : namedArgument (COMMA namedArgument)*
    ;

namedArgument
    : identifier FAT_ARROW expression                                                        #namedArguments
    ;

joinRelation
    : crossOrInnerJoinType bracketHint?
            LATERAL? rightRelation=relationPrimary joinCriteria?
    | outerAndSemiJoinType bracketHint?
            LATERAL? rightRelation=relationPrimary joinCriteria
    ;

crossOrInnerJoinType
    : JOIN | INNER JOIN
    | CROSS | CROSS JOIN
    ;

outerAndSemiJoinType
    : LEFT JOIN | RIGHT JOIN | FULL JOIN
    | LEFT OUTER JOIN | RIGHT OUTER JOIN
    | FULL OUTER JOIN
    | LEFT SEMI JOIN | RIGHT SEMI JOIN
    | LEFT ANTI JOIN | RIGHT ANTI JOIN
    | NULL AWARE LEFT ANTI JOIN
    ;

bracketHint
    : LEFT_BRACKET identifier (COMMA identifier)* RIGHT_BRACKET
    | LEFT_BRACKET identifier '|' primaryExpression literalExpressionList RIGHT_BRACKET
    ;

hintMap
    : k=identifierOrString '=' v=literalExpression
    ;

joinCriteria
    : ON expression
    | USING LEFT_PAREN identifier (COMMA identifier)* LEFT_PAREN
    ;

columnAliases
    : LEFT_PAREN identifier (COMMA identifier)* RIGHT_PAREN
    ;

// partitionNames should not support string, it should be identifier here only for compatibility with historical bugs
partitionNames
    : TEMPORARY? (PARTITION | PARTITIONS) LEFT_PAREN identifierOrString (COMMA identifierOrString)* RIGHT_PAREN
    | TEMPORARY? (PARTITION | PARTITIONS) identifierOrString
    | keyPartitions
    ;

keyPartitions
    : PARTITION LEFT_PAREN keyPartition (COMMA keyPartition)* RIGHT_PAREN                              #keyPartitionList
    ;

tabletList
    : TABLET LEFT_PAREN INTEGER_VALUE (COMMA INTEGER_VALUE)* RIGHT_PAREN
    ;

prepareStatement
    : PREPARE identifier FROM prepareSql
    ;

prepareSql
    : statement
    | SINGLE_QUOTED_TEXT
    ;

executeStatement
    : EXECUTE identifier (USING  '@'identifierOrString (COMMA '@'identifierOrString)*)?
    ;

deallocateStatement
    : (DEALLOCATE | DROP) PREPARE identifier
    ;

replicaList
    : REPLICA LEFT_PAREN INTEGER_VALUE (COMMA INTEGER_VALUE)* RIGHT_PAREN
    ;

// ------------------------------------------- Expression --------------------------------------------------------------

/**
 * Operator precedences are shown in the following list, from highest precedence to the lowest.
 *
 * !
 * - (unary minus), ~ (unary bit inversion)
 * ^
 * *, /, DIV, %, MOD
 * -, +
 * &
 * |
 * = (comparison), <=>, >=, >, <=, <, <>, !=, IS, LIKE, REGEXP
 * BETWEEN, CASE WHEN
 * NOT
 * AND, &&
 * XOR
 * OR, ||
 * = (assignment)
 */

expressionsWithDefault
    : LEFT_PAREN expressionOrDefault (COMMA expressionOrDefault)* RIGHT_PAREN
    ;

expressionOrDefault
    : expression | DEFAULT
    ;

mapExpressionList
    : mapExpression (COMMA mapExpression)*
    ;

mapExpression
    : key=expression COLON value=expression
    ;

expressionSingleton
    : expression EOF
    ;

expression
    : (BINARY)? booleanExpression                                                         #expressionDefault
    | NOT expression                                                                      #logicalNot
    | left=expression operator=(AND|LOGICAL_AND) right=expression                         #logicalBinary
    | left=expression operator=(OR|LOGICAL_OR) right=expression                           #logicalBinary
    ;

expressionList
    : expression (COMMA expression)*
    ;

booleanExpression
    : predicate                                                                           #booleanExpressionDefault
    | booleanExpression IS NOT? NULL                                                      #isNull
    | left = booleanExpression comparisonOperator right = predicate                       #comparison
    | booleanExpression comparisonOperator LEFT_PAREN queryRelation RIGHT_PAREN                          #scalarSubquery
    ;

predicate
    : valueExpression (predicateOperations[$valueExpression.ctx])?
    | tupleInSubquery
    ;

tupleInSubquery
    : LEFT_PAREN expression (COMMA expression)+ RIGHT_PAREN NOT? IN LEFT_PAREN queryRelation RIGHT_PAREN
    ;

predicateOperations [ParserRuleContext value]
    : NOT? IN LEFT_PAREN queryRelation RIGHT_PAREN                                                       #inSubquery
    | NOT? IN LEFT_PAREN expressionList RIGHT_PAREN                                                      #inList
    | NOT? BETWEEN lower = valueExpression AND upper = predicate                          #between
    | NOT? (LIKE | RLIKE | REGEXP) pattern=valueExpression                                #like
    ;

valueExpression
    : primaryExpression                                                                   #valueExpressionDefault
    | left = valueExpression operator = BITXOR right = valueExpression                    #arithmeticBinary
    | left = valueExpression operator = (
              ASTERISK_SYMBOL
            | SLASH_SYMBOL
            | PERCENT_SYMBOL
            | INT_DIV
            | MOD)
      right = valueExpression                                                             #arithmeticBinary
    | left = valueExpression operator = (PLUS_SYMBOL | MINUS_SYMBOL)
        right = valueExpression                                                           #arithmeticBinary
    | left = valueExpression operator = BITAND right = valueExpression                    #arithmeticBinary
    | left = valueExpression operator = BITOR right = valueExpression                     #arithmeticBinary
    | left = valueExpression operator = BIT_SHIFT_LEFT right = valueExpression              #arithmeticBinary
    | left = valueExpression operator = BIT_SHIFT_RIGHT right = valueExpression             #arithmeticBinary
    | left = valueExpression operator = BIT_SHIFT_RIGHT_LOGICAL right = valueExpression     #arithmeticBinary
    ;

primaryExpression
    : userVariable                                                                        #userVariableExpression
    | systemVariable                                                                      #systemVariableExpression
    | DICTIONARY_GET LEFT_PAREN expressionList RIGHT_PAREN                                               #dictionaryGetExpr
    | functionCall                                                                        #functionCallExpression
    | LEFT_BRACE FN functionCall RIGHT_BRACE                                                             #odbcFunctionCallExpression
    | primaryExpression COLLATE (identifier | string)                                     #collate
    | literalExpression                                                                   #literal
    | columnReference                                                                     #columnRef
    | base = primaryExpression (DOT_IDENTIFIER | DOT fieldName = identifier )             #dereference
    | left = primaryExpression CONCAT right = primaryExpression                           #concat
    | operator = (MINUS_SYMBOL | PLUS_SYMBOL | BITNOT) primaryExpression                  #arithmeticUnary
    | operator = LOGICAL_NOT primaryExpression                                            #arithmeticUnary
    | LEFT_PAREN expression RIGHT_PAREN                                                                  #parenthesizedExpression
    | EXISTS LEFT_PAREN queryRelation RIGHT_PAREN                                                        #exists
    | subquery                                                                            #subqueryExpression
    | CAST LEFT_PAREN expression AS type RIGHT_PAREN                                                     #cast
    | CONVERT LEFT_PAREN expression COMMA type RIGHT_PAREN                                                 #convert
    | CASE caseExpr=expression whenClause+ (ELSE elseExpression=expression)? END          #simpleCase
    | CASE whenClause+ (ELSE elseExpression=expression)? END                              #searchedCase
    | arrayType? LEFT_BRACKET (expressionList)? RIGHT_BRACKET                                                #arrayConstructor
    | mapType LEFT_BRACE (mapExpressionList)? RIGHT_BRACE                                                #mapConstructor
    | MAP LEFT_BRACE (mapExpressionList)? RIGHT_BRACE                                                    #mapConstructor
    | value=primaryExpression LEFT_BRACKET index=valueExpression RIGHT_BRACKET                               #collectionSubscript
    | primaryExpression LEFT_BRACKET start=INTEGER_VALUE? COLON end=INTEGER_VALUE? RIGHT_BRACKET               #arraySlice
    | primaryExpression ARROW string                                                      #arrowExpression
    | (identifier | identifierList) LEFT_PAREN expression                                       #lambdaFunctionExpr
    | identifierList ARROW LEFT_PAREN(expressionList)?RIGHT_PAREN                                         #lambdaFunctionExpr
    | left = primaryExpression NOT? MATCH right = primaryExpression                       #matchExpr
    ;

literalExpression
    : NULL                                                                                #nullLiteral
    | booleanValue                                                                        #booleanLiteral
    | number                                                                              #numericLiteral
    | (DATE | DATETIME) string                                                            #dateLiteral
    | string                                                                              #stringLiteral
    | interval                                                                            #intervalLiteral
    | unitBoundary                                                                        #unitBoundaryLiteral
    | binary                                                                              #binaryLiteral
    | PARAMETER                                                                           #Parameter
    ;

functionCall
    : EXTRACT LEFT_PAREN identifier FROM valueExpression RIGHT_PAREN                                     #extract
    | GROUPING LEFT_PAREN (expression (COMMA expression)*)? RIGHT_PAREN                                    #groupingOperation
    | GROUPING_ID LEFT_PAREN (expression (COMMA expression)*)? RIGHT_PAREN                                 #groupingOperation
    | informationFunctionExpression                                                       #informationFunction
    | specialDateTimeExpression                                                           #specialDateTime
    | specialFunctionExpression                                                           #specialFunction
    | aggregationFunction filter? over?                                                   #aggregationFunctionCall
    | windowFunction over                                                                 #windowFunctionCall
    | TRANSLATE LEFT_PAREN (expression (COMMA expression)*)? RIGHT_PAREN                                   #translateFunctionCall
    | qualifiedName LEFT_PAREN (expression (COMMA expression)*)? RIGHT_PAREN  over?                        #simpleFunctionCall
    ;

aggregationFunction
    : AVG LEFT_PAREN setQuantifier? expression RIGHT_PAREN
    | COUNT LEFT_PAREN ASTERISK_SYMBOL? RIGHT_PAREN
    | COUNT LEFT_PAREN (setQuantifier bracketHint?)? (expression (COMMA expression)*)? RIGHT_PAREN
    | MAX LEFT_PAREN setQuantifier? expression RIGHT_PAREN
    | MIN LEFT_PAREN setQuantifier? expression RIGHT_PAREN
    | SUM LEFT_PAREN setQuantifier? expression RIGHT_PAREN
    | ARRAY_AGG LEFT_PAREN setQuantifier? expression (ORDER BY sortItem (COMMA sortItem)*)? RIGHT_PAREN
    | ARRAY_AGG_DISTINCT LEFT_PAREN expression (ORDER BY sortItem (COMMA sortItem)*)? RIGHT_PAREN
    | GROUP_CONCAT LEFT_PAREN setQuantifier? expression (COMMA expression)* (ORDER BY sortItem (COMMA sortItem)*)? (SEPARATOR expression)? RIGHT_PAREN
    ;

userVariable
    : AT identifierOrString
    ;

systemVariable
    : AT AT (varType DOT)? identifier
    ;

columnReference
    : identifier
    ;

informationFunctionExpression
    : name = CATALOG LEFT_PAREN RIGHT_PAREN
    | name = DATABASE LEFT_PAREN RIGHT_PAREN
    | name = SCHEMA LEFT_PAREN RIGHT_PAREN
    | name = USER LEFT_PAREN RIGHT_PAREN
    | name = CURRENT_USER (LEFT_PAREN RIGHT_PAREN)?
    | name = CURRENT_ROLE (LEFT_PAREN RIGHT_PAREN)?
    | name = CURRENT_GROUP (LEFT_PAREN RIGHT_PAREN)?
    ;

specialDateTimeExpression
    : name = CURRENT_DATE (LEFT_PAREN RIGHT_PAREN)?
    | name = CURRENT_TIME (LEFT_PAREN RIGHT_PAREN)?
    | name = CURRENT_TIMESTAMP (LEFT_PAREN (INTEGER_VALUE)? RIGHT_PAREN)?
    | name = LOCALTIME (LEFT_PAREN RIGHT_PAREN)?
    | name = LOCALTIMESTAMP (LEFT_PAREN RIGHT_PAREN)?
    ;

specialFunctionExpression
    : CHAR LEFT_PAREN expression RIGHT_PAREN
    | DAY LEFT_PAREN expression RIGHT_PAREN
    | HOUR LEFT_PAREN expression RIGHT_PAREN
    | IF LEFT_PAREN (expression (COMMA expression)*)? RIGHT_PAREN
    | LEFT LEFT_PAREN expression COMMA expression RIGHT_PAREN
    | LIKE LEFT_PAREN expression COMMA expression RIGHT_PAREN
    | MINUTE LEFT_PAREN expression RIGHT_PAREN
    | MOD LEFT_PAREN expression COMMA expression RIGHT_PAREN
    | MONTH LEFT_PAREN expression RIGHT_PAREN
    | QUARTER LEFT_PAREN expression RIGHT_PAREN
    | REGEXP LEFT_PAREN expression COMMA expression RIGHT_PAREN
    | REPLACE LEFT_PAREN (expression (COMMA expression)*)? RIGHT_PAREN
    | RIGHT LEFT_PAREN expression COMMA expression RIGHT_PAREN
    | RLIKE LEFT_PAREN expression COMMA expression RIGHT_PAREN
    | SECOND LEFT_PAREN expression RIGHT_PAREN
    | TIMESTAMPADD LEFT_PAREN unitIdentifier COMMA expression COMMA expression RIGHT_PAREN
    | TIMESTAMPDIFF LEFT_PAREN unitIdentifier COMMA expression COMMA expression RIGHT_PAREN
    //| WEEK LEFT_PAREN expression RIGHT_PAREN TODO: Support week(expr) function
    | YEAR LEFT_PAREN expression RIGHT_PAREN
    | PASSWORD LEFT_PAREN string RIGHT_PAREN
    | FLOOR LEFT_PAREN expression RIGHT_PAREN
    | CEIL LEFT_PAREN expression RIGHT_PAREN
    ;

windowFunction
    : name = ROW_NUMBER LEFT_PAREN RIGHT_PAREN
    | name = RANK LEFT_PAREN RIGHT_PAREN
    | name = DENSE_RANK LEFT_PAREN RIGHT_PAREN
    | name = CUME_DIST LEFT_PAREN RIGHT_PAREN
    | name = PERCENT_RANK LEFT_PAREN RIGHT_PAREN
    | name = NTILE  LEFT_PAREN expression? RIGHT_PAREN
    | name = LEAD  LEFT_PAREN (expression ignoreNulls? (COMMA expression)*)? RIGHT_PAREN ignoreNulls?
    | name = LAG LEFT_PAREN (expression ignoreNulls? (COMMA expression)*)? RIGHT_PAREN ignoreNulls?
    | name = FIRST_VALUE LEFT_PAREN (expression ignoreNulls? (COMMA expression)*)? RIGHT_PAREN ignoreNulls?
    | name = LAST_VALUE LEFT_PAREN (expression ignoreNulls? (COMMA expression)*)? RIGHT_PAREN ignoreNulls?
    ;

whenClause
    : WHEN condition=expression THEN result=expression
    ;

filter
    : FILTER LEFT_PAREN WHERE booleanExpression RIGHT_PAREN
    ;

over
    : OVER LEFT_PAREN
        (bracketHint? PARTITION BY partition+=expression (COMMA partition+=expression)*)?
        (ORDER BY sortItem (COMMA sortItem)*)?
        windowFrame?
      RIGHT_PAREN
    ;

ignoreNulls
    : IGNORE NULLS
    ;

windowFrame
    : frameType=RANGE start=frameBound
    | frameType=ROWS start=frameBound
    | frameType=RANGE BETWEEN start=frameBound AND end=frameBound
    | frameType=ROWS BETWEEN start=frameBound AND end=frameBound
    ;

frameBound
    : UNBOUNDED boundType=PRECEDING                 #unboundedFrame
    | UNBOUNDED boundType=FOLLOWING                 #unboundedFrame
    | CURRENT ROW                                   #currentRowBound
    | expression boundType=(PRECEDING | FOLLOWING)  #boundedFrame
    ;

// ------------------------------------------- COMMON AST --------------------------------------------------------------

backupRestoreObjectDesc
    : backupRestoreTableDesc
    | (ALL (FUNCTION | FUNCTIONS) | (FUNCTION | FUNCTIONS) qualifiedName (AS identifier)?)
    | (ALL (TABLE | TABLES) | (TABLE | TABLES) backupRestoreTableDesc)
    | (ALL MATERIALIZED (VIEW | VIEWS) | MATERIALIZED (VIEW | VIEWS) qualifiedName (AS identifier)?)
    | (ALL (VIEW | VIEWS) | (VIEW | VIEWS) qualifiedName (AS identifier)?)
    ;

tableDesc
    : qualifiedName partitionNames?
    ;

backupRestoreTableDesc
    : qualifiedName partitionNames? (AS identifier)?
    ;

explainDesc
    : (DESC | DESCRIBE | EXPLAIN) (LOGICAL | ANALYZE | VERBOSE | COSTS | SCHEDULER)?
    ;

optimizerTrace
    : TRACE (ALL | LOGS | TIMES | VALUES | REASON) identifier?
    ;

partitionExpr
    : identifier
    | functionCall
    ;

partitionDesc
    : PARTITION BY RANGE identifierList LEFT_PAREN (rangePartitionDesc (COMMA rangePartitionDesc)*)? RIGHT_PAREN
    | PARTITION BY RANGE primaryExpression LEFT_PAREN (rangePartitionDesc (COMMA rangePartitionDesc)*)? RIGHT_PAREN
    | PARTITION BY LIST? identifierList LEFT_PAREN (listPartitionDesc (COMMA listPartitionDesc)*)? RIGHT_PAREN
    | PARTITION BY LIST? identifierList
    | PARTITION BY functionCall LEFT_PAREN (rangePartitionDesc (COMMA rangePartitionDesc)*)? RIGHT_PAREN
    | PARTITION BY functionCall
    | PARTITION BY partitionExpr (COMMA partitionExpr)*
    ;

listPartitionDesc
    : singleItemListPartitionDesc
    | multiItemListPartitionDesc
    ;

singleItemListPartitionDesc
    : PARTITION (IF NOT EXISTS)? identifier VALUES IN singleListPartitionValues propertyList?
    ;

multiItemListPartitionDesc
    : PARTITION (IF NOT EXISTS)? identifier VALUES IN  multiListPartitionValues propertyList?
    ;

multiListPartitionValues
    :LEFT_PAREN singleListPartitionValues (COMMA singleListPartitionValues)* RIGHT_PAREN // list partition values with multi partition columns: ('a, 'b', 'c'), ('d', 'e', 'f')
    ;

singleListPartitionValues
    : LEFT_PAREN listPartitionValue (COMMA listPartitionValue)* RIGHT_PAREN // list partition value: ('a, 'b', 'c')
    ;

listPartitionValues // list partition values which can be with single or multi partition columns
    : singleListPartitionValues
    | multiListPartitionValues
    ;

listPartitionValue
    : NULL | string
    ;

stringList
    : LEFT_PAREN string (COMMA string)* RIGHT_PAREN
    ;

literalExpressionList
    : LEFT_PAREN literalExpression (COMMA literalExpression)* RIGHT_PAREN
    ;

rangePartitionDesc
    : singleRangePartition
    | multiRangePartition
    ;

singleRangePartition
    : PARTITION (IF NOT EXISTS)? identifier VALUES partitionKeyDesc propertyList?
    ;

multiRangePartition
    : START LEFT_PAREN string RIGHT_PAREN END LEFT_PAREN string RIGHT_PAREN EVERY LEFT_PAREN interval RIGHT_PAREN
    | START LEFT_PAREN string RIGHT_PAREN END LEFT_PAREN string RIGHT_PAREN EVERY LEFT_PAREN INTEGER_VALUE RIGHT_PAREN
    ;

partitionRangeDesc
    : START LEFT_PAREN string RIGHT_PAREN END LEFT_PAREN string RIGHT_PAREN
    ;

partitionKeyDesc
    : LESS THAN (MAXVALUE | partitionValueList)
    | LEFT_BRACKET partitionValueList COMMA partitionValueList RIGHT_PAREN
    ;

partitionValueList
    : LEFT_PAREN partitionValue (COMMA partitionValue)* RIGHT_PAREN
    ;

keyPartition
    : partitionColName=identifier '=' partitionColValue=literalExpression
    ;

partitionValue
    : MAXVALUE | string
    ;

distributionClause
    : DISTRIBUTED BY HASH identifierList (BUCKETS INTEGER_VALUE)?
    | DISTRIBUTED BY HASH identifierList
    ;

distributionDesc
    : DISTRIBUTED BY HASH identifierList (BUCKETS INTEGER_VALUE)?
    | DISTRIBUTED BY HASH identifierList
    | DISTRIBUTED BY RANDOM (BUCKETS INTEGER_VALUE)?
    ;

refreshSchemeDesc
    : REFRESH (IMMEDIATE | DEFERRED)? (ASYNC
    | ASYNC (START LEFT_PAREN string RIGHT_PAREN)? EVERY LEFT_PAREN interval RIGHT_PAREN
    | INCREMENTAL
    | MANUAL)
    ;

statusDesc
    : ACTIVE
    | INACTIVE
    ;

properties
    : PROPERTIES LEFT_PAREN property (COMMA property)* RIGHT_PAREN
    ;

extProperties
    : BROKER properties
    ;

propertyList
    : LEFT_PAREN property (COMMA property)* RIGHT_PAREN
    ;

userPropertyList
    : property (COMMA property)*
    ;

property
    : key=string '=' value=string
    ;

inlineProperties
    : inlineProperty ( inlineProperty)*
    ;

inlineProperty
    : key=identifier '=' value=string
    ;

varType
    : GLOBAL
    | LOCAL
    | SESSION
    | VERBOSE
    ;

comment
    : COMMENT string
    ;

outfile
    : INTO OUTFILE file=string fileFormat? properties?
    ;

fileFormat
    : FORMAT AS (identifier | string)
    ;

string
    : SINGLE_QUOTED_TEXT
    | DOUBLE_QUOTED_TEXT
    ;

binary
    : BINARY_SINGLE_QUOTED_TEXT
    | BINARY_DOUBLE_QUOTED_TEXT
    ;

comparisonOperator
    : EQ | NEQ | LT | LTE | GT | GTE | EQ_FOR_NULL
    ;

booleanValue
    : TRUE | FALSE
    ;

interval
    : INTERVAL value=expression from=unitIdentifier
    ;

taskInterval
    : INTERVAL value=expression from=taskUnitIdentifier
    ;

taskUnitIdentifier
    : DAY | HOUR | MINUTE | SECOND
    ;

unitIdentifier
    : YEAR | MONTH | WEEK | DAY | HOUR | MINUTE | SECOND | QUARTER | MILLISECOND | MICROSECOND
    ;

unitBoundary
    : FLOOR | CEIL
    ;

type
    : baseType
    | decimalType
    | arrayType
    | structType
    | mapType
    ;

arrayType
    : ARRAY '<' type '>'
    ;

mapType
    : MAP '<' type COMMA type '>'
    ;

subfieldDesc
    : (identifier | nestedFieldName) type
    ;

subfieldDescs
    : subfieldDesc (COMMA subfieldDesc)*
    ;

structType
    : STRUCT '<' subfieldDescs '>'
    ;

typeParameter
    : LEFT_PAREN INTEGER_VALUE RIGHT_PAREN
    ;

baseType
    : BOOLEAN
    | TINYINT typeParameter?
    | SMALLINT typeParameter?
    | SIGNED INT?
    | SIGNED INTEGER?
    | UNSIGNED INT?
    | UNSIGNED INTEGER?
    | INT typeParameter?
    | INTEGER typeParameter?
    | BIGINT typeParameter?
    | LARGEINT typeParameter?
    | FLOAT
    | DOUBLE
    | DATE
    | DATETIME
    | TIME
    | CHAR typeParameter?
    | VARCHAR typeParameter?
    | STRING
    | TEXT
    | BITMAP
    | HLL
    | PERCENTILE
    | JSON
    | VARBINARY typeParameter?
    | BINARY typeParameter?
    ;

decimalType
    : (DECIMAL | DECIMALV2 | DECIMAL32 | DECIMAL64 | DECIMAL128 | NUMERIC | NUMBER )
        (LEFT_PAREN precision=INTEGER_VALUE (COMMA scale=INTEGER_VALUE)? RIGHT_PAREN)?
    ;

qualifiedName
    : identifier (DOT_IDENTIFIER | DOT identifier)*
    ;

tableName
    : qualifiedName
    ;

writeBranch
    : FOR? VERSION AS OF identifier
    ;

identifier
    : LETTER_IDENTIFIER      #unquotedIdentifier
    | nonReserved            #unquotedIdentifier
    | DIGIT_IDENTIFIER       #digitIdentifier
    | BACKQUOTED_IDENTIFIER  #backQuotedIdentifier
    ;

identifierWithAlias
    : originalName=identifier (AS alias=identifier)?
    ;

identifierWithAliasList
    : LEFT_PAREN identifierWithAlias (COMMA identifierWithAlias)* RIGHT_PAREN
    ;

identifierList
    : LEFT_PAREN identifier (COMMA identifier)* RIGHT_PAREN
    ;

identifierOrString
    : identifier
    | string
    ;

identifierOrStringList
    : identifierOrString (COMMA identifierOrString)*
    ;

identifierOrStringOrStar
    : ASTERISK_SYMBOL
    | identifier
    | string
    ;

user
    : identifierOrString                                     # userWithoutHost
    | identifierOrString '@' identifierOrString              # userWithHost
    | identifierOrString '@' LEFT_BRACKET identifierOrString RIGHT_BRACKET      # userWithHostAndBlanket
    ;

assignment
    : identifier EQ expressionOrDefault
    ;

assignmentList
    : assignment (COMMA assignment)*
    ;

number
    : DECIMAL_VALUE  #decimalValue
    | DOUBLE_VALUE   #doubleValue
    | INTEGER_VALUE  #integerValue
    ;

nonReserved
    : ACCESS | ACTIVE | ADVISOR | AFTER | AGGREGATE | APPLY | ASYNC | AUTHORS | AVG | ADMIN | ANTI | AUTHENTICATION | AUTO_INCREMENT | AUTOMATED
    | ARRAY_AGG | ARRAY_AGG_DISTINCT | ASSERT_ROWS | AWARE
    | BACKEND | BACKENDS | BACKUP | BEGIN | BITMAP_UNION | BLACKLIST | BLACKHOLE | BINARY | BODY | BOOLEAN | BRANCH | BROKER | BUCKETS
    | BUILTIN | BASE | BEFORE | BASELINE
    | CACHE | CAST | CANCEL | CATALOG | CATALOGS | CEIL | CHAIN | CHARSET | CLEAN | CLEAR | CLUSTER | CLUSTERS | CNGROUP | CNGROUPS | CURRENT | COLLATION | COLUMNS
    | CUME_DIST | CUMULATIVE | COMMENT | COMMIT | COMMITTED | COMPUTE | CONNECTION | CONSISTENT | COSTS | COUNT
    | CONFIG | COMPACT
    | DATA | DATE | DATACACHE | DATETIME | DAY | DAYS | DECOMMISSION | DIALECT | DISABLE | DISK | DISTRIBUTION | DUPLICATE | DYNAMIC | DISTRIBUTED | DICTIONARY | DICTIONARY_GET | DEALLOCATE
    | ENABLE | END | ENGINE | ENGINES | ERRORS | EVENTS | EXECUTE | EXTERNAL | EXTRACT | EVERY | ENCLOSE | ESCAPE | EXPORT
    | FAILPOINT | FAILPOINTS | FIELDS | FILE | FILTER | FIRST | FLOOR | FOLLOWING | FORMAT | FN | FRONTEND | FRONTENDS | FOLLOWER | FREE
    | FUNCTIONS
    | GLOBAL | GRANTS | GROUP_CONCAT
    | HASH | HISTOGRAM | HELP | HLL_UNION | HOST | HOUR | HOURS | HUB
    | IDENTIFIED | IMAGE | IMPERSONATE | INACTIVE | INCREMENTAL | INDEXES | INSTALL | INTEGRATION | INTEGRATIONS | INTERMEDIATE
    | INTERVAL | ISOLATION
    | JOB
    | LABEL | LAST | LESS | LEVEL | LIST | LOCAL | LOCATION | LOGS | LOGICAL | LOW_PRIORITY | LOCK | LOCATIONS
    | MANUAL | MAP | MAPPING | MAPPINGS | MASKING | MATCH | MAPPINGS | MATERIALIZED | MAX | META | MIN | MINUTE | MINUTES | MODE | MODIFY | MONTH | MERGE | MINUS | MULTIPLE
    | NAME | NAMES | NEGATIVE | NO | NODE | NODES | NONE | NULLS | NUMBER | NUMERIC
    | OBSERVER | OF | OFFSET | ONLY | OPTIMIZER | OPEN | OPERATE | OPTION | OVERWRITE | OFF
    | PARTITIONS | PASSWORD | PATH | PAUSE | PENDING | PERCENTILE_UNION | PIVOT | PLAN | PLUGIN | PLUGINS | POLICY | POLICIES
    | PERCENT_RANK | PREDICATE | PRECEDING | PRIORITY | PROC | PROCESSLIST | PROFILE | PROFILELIST | PROVIDER | PROVIDERS | PRIVILEGES | PROBABILITY | PROPERTIES | PROPERTY | PIPE | PIPES
    | QUARTER | QUERY | QUERIES | QUEUE | QUOTA | QUALIFY
    | REASON | REMOVE | REWRITE | RANDOM | RANK | RECOVER | REFRESH | REPAIR | REPEATABLE | REPLACE_IF_NOT_NULL | REPLICA | REPOSITORY
    | REPOSITORIES
    | RESOURCE | RESOURCES | RESTORE | RESUME | RETAIN | RETENTION | RETURNS | RETRY | REVERT | ROLE | ROLES | ROLLUP | ROLLBACK | ROUTINE | ROW | RUNNING | RULE | RULES
    | SAMPLE | SCHEDULE | SCHEDULER | SECOND | SECURITY | SEPARATOR | SERIALIZABLE |SEMI | SESSION | SETS | SIGNED | SNAPSHOT | SNAPSHOTS | SQLBLACKLIST | START | STARROCKS
    | STREAM | SUM | STATUS | STOP | SKIP_HEADER | SWAP
    | STORAGE| STRING | STRUCT | STATS | SUBMIT | SUSPEND | SYNC | SYSTEM_TIME
    | TABLES | TABLET | TABLETS | TAG | TASK | TEMPORARY | TIMESTAMP | TIMESTAMPADD | TIMESTAMPDIFF | THAN | TIME | TIMES | TRANSACTION | TRACE | TRANSLATE
    | TRIM_SPACE
    | TRIGGERS | TRUNCATE | TYPE | TYPES
    | UNBOUNDED | UNCOMMITTED | UNSET | UNINSTALL | USAGE | USER | USERS | UNLOCK
    | VALUE | VARBINARY | VARIABLES | VIEW | VIEWS | VERBOSE | VERSION | VOLUME | VOLUMES
    | WARNINGS | WEEK | WHITELIST | WORK | WRITE  | WAREHOUSE | WAREHOUSES
    | YEAR
    | DOTDOTDOT | NGRAMBF | VECTOR
    | FIELD
    | ARRAY_ELEMENT
    | PERSISTENT
    | EXCLUDE | EXCEPT
    ;
