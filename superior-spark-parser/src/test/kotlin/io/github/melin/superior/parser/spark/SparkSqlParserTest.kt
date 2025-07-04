package io.github.melin.superior.parser.spark

import io.github.melin.superior.common.*
import io.github.melin.superior.common.relational.*
import io.github.melin.superior.common.relational.alter.*
import io.github.melin.superior.common.relational.common.*
import io.github.melin.superior.common.relational.create.*
import io.github.melin.superior.common.relational.create.CreateView
import io.github.melin.superior.common.relational.dml.*
import io.github.melin.superior.common.relational.drop.*
import io.github.melin.superior.common.relational.io.ExportTable
import io.github.melin.superior.common.relational.table.*
import io.github.melin.superior.parser.spark.relational.*
import java.io.File
import org.apache.commons.io.FileUtils
import org.junit.Assert
import org.junit.Test

/** Created by libinsong on 2018/1/10. */
class SparkSqlParserTest {

    @Test
    fun splitSqlTest() {
        val sql =
            """
            CREATE DATABASE IF NOT EXISTS bigdata1;    
            drop DATABASE IF EXISTS bigdata2
        """
                .trimIndent()

        val statements = SparkSqlHelper.splitSql(sql)

        Assert.assertEquals(2, statements.size)
        Assert.assertEquals("CREATE DATABASE IF NOT EXISTS bigdata1", statements.get(0))
    }

    @Test
    fun createDatabaseTest() {
        val sql =
            """
            CREATE DATABASE IF NOT EXISTS bigdata1;
            drop DATABASE IF EXISTS bigdata2
        """
                .trimIndent()

        val statements = SparkSqlHelper.parseMultiStatement(sql)

        val createDatabse = statements.get(0)
        val dropDatabase = statements.get(1)
        if (createDatabse is CreateDatabase) {
            Assert.assertEquals("bigdata1", createDatabse.databaseName)
            Assert.assertEquals("CREATE DATABASE IF NOT EXISTS bigdata1", createDatabse.getSql())
        }
        if (dropDatabase is CreateDatabase) {
            Assert.assertEquals("bigdata2", dropDatabase.databaseName)
            Assert.assertEquals("drop DATABASE IF EXISTS bigdata2", dropDatabase.getSql())
        }
    }

    @Test
    fun createDatabaseTest2() {
        val sql = "CREATE DATABASE IF NOT EXISTS bigdata location 's3a://hive/s3/'"

        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is CreateDatabase) {
            Assert.assertEquals("bigdata", statement.databaseName)
            val location = statement.location
            Assert.assertEquals("s3a://hive/s3/", location)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun dropDatabaseTest() {
        val sql = "drop DATABASE IF EXISTS bigdata"

        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is DropDatabase) {
            Assert.assertEquals("bigdata", statement.databaseName)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun createTableTest() {
        val sql =
            """CREATE TABLE if not exists test.users (
                name         STRING COMMENT 'Employee name',
                address      int COMMENT 'address',
                item1      double,
                item2      DECIMAL(9, 2),
                item3      TIMESTAMP,
                item4      BIGINT,
                item5      BOOLEAN
            )
            COMMENT 'hello world'
            PARTITIONED BY (ds varchar(50) COMMENT 'part sdf')
            STORED AS ORC
            TBLPROPERTIES ('dataCenter'='hangzhou')
            lifecycle 7
            """

        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is CreateTable) {
            val schemaName = statement.tableId.schemaName
            Assert.assertEquals("test", schemaName)
            Assert.assertEquals("hello world", statement.comment)
            Assert.assertNull(statement.location)
            Assert.assertFalse(statement.external)
            Assert.assertEquals(statement.fileFormat, "ORC")
            Assert.assertFalse(statement.temporary)
            Assert.assertEquals(7, statement.lifeCycle)
            Assert.assertEquals(PartitionType.LIST, statement.partitionType)

            Assert.assertEquals(1, statement.partitionColumnNames.size)
            Assert.assertEquals("ds", statement.partitionColumnNames.get(0))
            Assert.assertEquals("part sdf", statement.partitionColumnRels?.get(0)?.comment)
            Assert.assertEquals(PartitionType.LIST, statement.partitionType)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun createTableTest1() {
        val sql =
            """create table if not exists platformtool.test_users_dt(
                    name string comment '姓名',
                    address string comment '地址',
                    image binary comment 'image'
                )
                comment 'user info'
                PARTITIONED BY (ds string, event_type string)
                lifecycle 7
            """

        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is CreateTable) {
            val schemaName = statement.tableId.schemaName
            Assert.assertEquals("platformtool", schemaName)
            Assert.assertEquals(7, statement.lifeCycle)
            Assert.assertEquals("姓名", statement.columnRels?.get(0)?.comment)
            Assert.assertEquals(TableType.HIVE, statement.tableType)
            Assert.assertEquals(2, statement.partitionColumnNames.size)
            Assert.assertEquals("ds", statement.partitionColumnNames.get(0))
            Assert.assertEquals("event_type", statement.partitionColumnNames.get(1))
            Assert.assertEquals(PartitionType.LIST, statement.partitionType)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun createTableTest2() {
        val sql =
            """
            CREATE TABLE dc_cluster_compute (
                id	    bigint	comment	'id',
                data_center	string	comment	'数据中心',
                code	string	comment	'code',
                name	string	comment	'集群名称'
            ) 
            comment	'计算集群'
            lifecycle 100; 
            """

        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is CreateTable) {
            val tableName = statement.tableId.tableName
            Assert.assertEquals("dc_cluster_compute", tableName)
            Assert.assertEquals(100, statement.lifeCycle)
            Assert.assertEquals(TableType.HIVE, statement.tableType)
            Assert.assertEquals("数据中心", statement.columnRels?.get(1)?.comment)

            Assert.assertNull(statement.partitionType)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun createTableTest3() {
        val sql =
            """
            CREATE TABLE bigdata.iceberg_test_dt (
            id bigint,
            data string)
            stored as iceberg
            PARTITIONED BY (ds string)
            lifecycle 100;
            """

        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is CreateTable) {
            val tableName = statement.tableId.tableName
            Assert.assertEquals("iceberg_test_dt", tableName)
            Assert.assertEquals(100, statement.lifeCycle)
            Assert.assertEquals(TableType.HIVE, statement.tableType)
            Assert.assertEquals(1, statement.partitionColumnNames.size)
            Assert.assertEquals("ds", statement.partitionColumnNames.get(0))
        } else {
            Assert.fail()
        }
    }

    @Test
    fun createTableTest4() {
        val sql =
            """
            CREATE TABLE `bigdata`.`export_test_dt` (
            `message` STRING COMMENT '',
            `collect_time` TIMESTAMP COMMENT '',
            `ds` STRING COMMENT '')
            USING orc
            LOCATION 's3a://superior2025/iceberg/warehouse/aws_iceberg.db/iceberg_demo_1'
            PARTITIONED BY (ds)
            TBLPROPERTIES (
            'transient_lastDdlTime' = '1627281671')
            lifeCycle 100
            """

        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is CreateTable) {
            val tableName = statement.tableId.tableName
            Assert.assertEquals("export_test_dt", tableName)
            Assert.assertEquals(100, statement.lifeCycle)
            Assert.assertEquals("orc", statement.fileFormat)
            Assert.assertEquals("spark", statement.modelType)
            Assert.assertEquals(1, statement.partitionColumnNames.size)
            Assert.assertEquals("ds", statement.partitionColumnNames.get(0))
            Assert.assertEquals(
                statement.location,
                "s3a://superior2025/iceberg/warehouse/aws_iceberg.db/iceberg_demo_1",
            )
        } else {
            Assert.fail()
        }
    }

    @Test
    fun createTableTest5() {
        val sql =
            """
            CREATE TABLE `bigdata`.`export_test_dt` (
              `message` STRING COMMENT '',
              `collect_time` TIMESTAMP COMMENT '',
              `the_date` STRING COMMENT '',
              `the_nums` STRING COMMENT '')
            USING orc
            PARTITIONED BY (the_date, the_nums)
            TBLPROPERTIES (
              'transient_lastDdlTime' = '1627288235')
            lifeCycle 100
            """

        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is CreateTable) {
            val tableName = statement.tableId.tableName
            Assert.assertEquals("export_test_dt", tableName)
            Assert.assertEquals(100, statement.lifeCycle)
            Assert.assertEquals("orc", statement.fileFormat)
            Assert.assertEquals("spark", statement.modelType)
            Assert.assertEquals(2, statement.partitionColumnNames.size)
            Assert.assertEquals("the_date", statement.partitionColumnNames.get(0))
            Assert.assertEquals("the_nums", statement.partitionColumnNames.get(1))
        } else {
            Assert.fail()
        }
    }

    @Test
    fun createTableTest7() {
        val sql =
            """
            CREATE TABLE test_demo_test (name string, age int)
            using orc
            LIFECYCLE 10;
            """

        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is CreateTable) {
            val tableName = statement.tableId.tableName
            Assert.assertEquals("test_demo_test", tableName)
            Assert.assertEquals(10, statement.lifeCycle)
            Assert.assertEquals("orc", statement.fileFormat)
            Assert.assertEquals("spark", statement.modelType)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun createTableTest9() {
        val sql =
            """
            create table dzlog_test_dt (
                message string,
                collect_time timestamp
            ) 
            using parquet
            partitioned by (ds string) 
            lifeCycle 14;
            """

        try {
            SparkSqlHelper.parseStatement(sql)
            Assert.fail()
        } catch (e: Exception) {
            Assert.assertTrue(true)
        }
    }

    @Test
    fun createTableTest10() {
        val sql =
            """
            CREATE TABLE my_table
            USING io.github.spark_redshift_community.spark.redshift
            OPTIONS (
              dbtable 'my_table',
              tempdir 's3n://path/for/temp/data',
              url 'jdbc:redshift://redshifthost:5439/database?user=username&password=pass'
            );
        """

        val statement = SparkSqlHelper.parseStatement(sql)
        Assert.assertEquals(StatementType.CREATE_TABLE, statement.statementType)
        if (statement is CreateTable) {
            val tableName = statement.tableId.tableName
            Assert.assertEquals("io.github.spark_redshift_community.spark.redshift", statement.fileFormat)
            Assert.assertEquals("my_table", tableName)
            Assert.assertEquals(3, statement.options?.size)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun createTableTest11() {
        val sql =
            """
            CREATE TABLE my_table
            USING io.github.spark_redshift_community.spark.redshift
            OPTIONS (
              dbtable 'my_table',
              tempdir 's3n://path/for/temp/data',
              url 'jdbc:redshift://redshifthost:5439/database?user=username&password=pass'
            )
            AS SELECT * FROM tabletosave;
        """

        val statement = SparkSqlHelper.parseStatement(sql)
        Assert.assertEquals(StatementType.CREATE_TABLE_AS_SELECT, statement.statementType)
        if (statement is CreateTableAsSelect) {
            val tableName = statement.tableId.tableName
            Assert.assertEquals("io.github.spark_redshift_community.spark.redshift", statement.fileFormat)
            Assert.assertEquals("my_table", tableName)
            Assert.assertEquals(3, statement.options?.size)
            Assert.assertEquals("SELECT * FROM tabletosave", statement.queryStmt.getSql())
        } else {
            Assert.fail()
        }
    }

    @Test
    fun createTableTest12() {
        val sql =
            """
            create table user(id Int, info String) clustered by (id) sorted by (id) into  4 buckets; 
        """

        val statement = SparkSqlHelper.parseStatement(sql)
        Assert.assertEquals(StatementType.CREATE_TABLE, statement.statementType)
        if (statement is CreateTable) {
            val tableName = statement.tableId.tableName
            Assert.assertEquals("user", tableName)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun createTableTest13() {
        val sql =
            """
            CREATE TABLE cyj123.pipeline_normal99 (
                id int,
                name string,
                class string,
                area_code int,
                pt string,
                is_delete int,
                age int
            )
            STORED BY 'org.apache.paimon.hive.PaimonStorageHandler' 
            TBLPROPERTIES (
                'table_type' = 'PAIMON',
                'bucket' = '2',
                'transient_lastDdlTime' = '1717400524'
            ) 
        """

        val statement = SparkSqlHelper.parseStatement(sql)
        Assert.assertEquals(StatementType.CREATE_TABLE, statement.statementType)
        if (statement is CreateTable) {
            val tableName = statement.tableId.tableName
            Assert.assertEquals("pipeline_normal99", tableName)
            Assert.assertEquals("org.apache.paimon.hive.PaimonStorageHandler", statement.storageHandler)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun createHudiTableTest5() {
        val sql =
            """
            create table test_hudi_table ( id int, name string, price double, ts long, dt string) 
            using hudi
            tblproperties (
              type = 'MOR',
              primaryKey = 'id, name',
              preCombineField = 'ts'
             )
            partitioned by (dt)
            lifeCycle 300
            """

        val statement = SparkSqlHelper.parseStatement(sql)

        Assert.assertEquals(StatementType.CREATE_TABLE, statement.statementType)
        if (statement is CreateTable) {
            val tableName = statement.tableId.tableName
            Assert.assertEquals("test_hudi_table", tableName)
            Assert.assertEquals("id, name", statement.properties?.get("primaryKey"))
            Assert.assertEquals("MOR", statement.properties?.get("type"))

            Assert.assertEquals(300, statement.lifeCycle)
            Assert.assertEquals("hudi", statement.fileFormat)
            Assert.assertEquals(1, statement.partitionColumnNames.size)
            Assert.assertEquals("dt", statement.partitionColumnNames.get(0))
        } else {
            Assert.fail()
        }
    }

    @Test
    fun createHudiTableTest6() {
        val sql =
            """
            create table test_hudi_table ( id int, name string, price double, ts long, dt string) 
            using hudi
            tblproperties (
              type = 'cow',
              primaryKey = 'id, name',
              preCombineField = 'ts'
             )
            partitioned by (dt)
            lifeCycle 300
            """

        val statement = SparkSqlHelper.parseStatement(sql)

        Assert.assertEquals(StatementType.CREATE_TABLE, statement.statementType)
        if (statement is CreateTable) {
            val name = statement.tableId.tableName
            Assert.assertEquals("test_hudi_table", name)
            Assert.assertEquals("id, name", statement.properties?.get("primaryKey"))
            Assert.assertEquals("cow", statement.properties?.get("type"))

            Assert.assertEquals(300, statement.lifeCycle)
            Assert.assertEquals("hudi", statement.fileFormat)
            Assert.assertEquals(1, statement.partitionColumnNames.size)
            Assert.assertEquals("dt", statement.partitionColumnNames.get(0))
        } else {
            Assert.fail()
        }
    }

    @Test
    fun createIcebergTable() {
        val sql =
            """
            CREATE TABLE IF NOT EXISTS iceberg_melin.test_table_02 (
                id bigint, data string, ds timestamp) 
            USING iceberg PARTITIONED BY (days(ts))
            lifeCycle 300
        """
                .trimIndent()

        val statement = SparkSqlHelper.parseStatement(sql)

        Assert.assertEquals(StatementType.CREATE_TABLE, statement.statementType)
        if (statement is CreateTable) {
            val tableName = statement.tableId.tableName
            Assert.assertEquals("test_table_02", tableName)

            Assert.assertEquals(300, statement.lifeCycle)
            Assert.assertEquals("iceberg", statement.fileFormat)
            Assert.assertEquals(1, statement.partitionColumnNames.size)
            Assert.assertEquals("days(ts)", statement.partitionColumnNames.get(0))
        } else {
            Assert.fail()
        }
    }

    @Test
    fun replaceHudiTableTest() {
        val sql =
            """
            create or replace table test_hudi_table ( id int, name string, price double, ts long, dt string) 
            using hudi
            tblproperties (
              type = 'mor',
              primaryKey = 'id, name',
              preCombineField = 'ts'
             )
            partitioned by (dt)
            lifeCycle 300
            """

        val statement = SparkSqlHelper.parseStatement(sql)

        Assert.assertEquals(StatementType.CREATE_TABLE, statement.statementType)
        if (statement is CreateTable) {
            val tableName = statement.tableId.tableName
            Assert.assertTrue(statement.replace)
            Assert.assertEquals("test_hudi_table", tableName)
            Assert.assertEquals("id, name", statement.properties?.get("primaryKey"))
            Assert.assertEquals("mor", statement.properties?.get("type"))

            Assert.assertEquals(300, statement.lifeCycle)
            Assert.assertEquals("hudi", statement.fileFormat)
            Assert.assertEquals(1, statement.partitionColumnNames.size)
            Assert.assertEquals("dt", statement.partitionColumnNames.get(0))
        } else {
            Assert.fail()
        }
    }

    @Test
    fun descTableTest0() {
        val sql = "desc table users"
        val statement = SparkSqlHelper.parseStatement(sql)
        Assert.assertEquals(StatementType.DESC_TABLE, statement.statementType)
    }

    @Test
    fun createTableLikeTest() {
        val sql = "create table IF NOT EXISTS test.sale_detail_like  like demo.sale_detail"

        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is CreateTableLike) {
            Assert.assertEquals(TableId("demo", "sale_detail"), statement.oldTableId)
            Assert.assertEquals(TableId("test", "sale_detail_like"), statement.tableId)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun createTableSelectTest() {
        val sql =
            "create table \nIF NOT EXISTS tdl_users_1 STORED AS ORC as select *, bigdata.TEST(name) from bigdata.users a left outer join address b on a.addr_id = b.id"

        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is CreateTableAsSelect) {
            Assert.assertEquals(StatementType.CREATE_TABLE_AS_SELECT, statement.statementType)
            Assert.assertEquals(statement.fileFormat, "ORC")
            Assert.assertEquals("tdl_users_1", statement.tableId.tableName)
            Assert.assertEquals(
                "select *, bigdata.TEST(name) from bigdata.users a left outer join address b on a.addr_id = b.id",
                statement.queryStmt.getSql(),
            )
            Assert.assertEquals(2, statement.queryStmt.inputTables.size)
            Assert.assertEquals("users", statement.queryStmt.inputTables.get(0).tableName)
            Assert.assertEquals("address", statement.queryStmt.inputTables.get(1).tableName)

            Assert.assertTrue(statement.ifNotExists)

            Assert.assertEquals(FunctionId("bigdata", "test"), statement.queryStmt.functionNames.first())
        } else {
            Assert.fail()
        }
    }

    @Test
    fun createTableSelectTest1() {
        val sql =
            """
               CREATE TABLE t
               USING ICEBERG
               PARTITIONED BY (b)
               AS SELECT 1 as a, "a" as b
               """

        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is CreateTableAsSelect) {
            val tableName = statement.tableId.tableName
            Assert.assertEquals(StatementType.CREATE_TABLE_AS_SELECT, statement.statementType)
            Assert.assertEquals("ICEBERG", statement.fileFormat)
            Assert.assertEquals("t", tableName)
            Assert.assertEquals("SELECT 1 as a, \"a\" as b", statement.queryStmt.getSql())
            Assert.assertEquals("b", statement.partitionColumnNames.get(0))
        } else {
            Assert.fail()
        }
    }

    @Test
    fun createTableSelectTest2() {
        val sql =
            "create table \nIF NOT EXISTS tdl_users_1 using parquet as (select * from users a left outer join address b on a.addr_id = b.id)"

        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is CreateTableAsSelect) {
            val tableName = statement.tableId.tableName
            Assert.assertEquals(StatementType.CREATE_TABLE_AS_SELECT, statement.statementType)
            Assert.assertEquals("tdl_users_1", tableName)
            Assert.assertEquals(
                "select * from users a left outer join address b on a.addr_id = b.id",
                statement.queryStmt.getSql(),
            )
            Assert.assertEquals(2, statement.queryStmt.inputTables.size)
            Assert.assertEquals("parquet", statement.fileFormat)
            Assert.assertEquals("address", statement.queryStmt.inputTables.get(1).tableName)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun createTableSelectTest3() {
        val sql =
            "create table \nIF NOT EXISTS tdl_users_1 using parquet as (select * from users a left outer join address b on a.addr_id = b.id" +
                " left outer join `bigdata`.users c on c.userid_id = a.id)"

        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is CreateTableAsSelect) {
            val tableName = statement.tableId.tableName
            Assert.assertEquals(StatementType.CREATE_TABLE_AS_SELECT, statement.statementType)
            Assert.assertEquals("tdl_users_1", tableName)
            // Assert.assertEquals("select * from users a left outer join address b on a.addr_id =
            // b.id",
            // statement.querySql)
            Assert.assertEquals(3, statement.queryStmt.inputTables.size)
            Assert.assertEquals("address", statement.queryStmt.inputTables.get(1).tableName)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun createTableSelectTest4() {
        val sql =
            "create table huaixin_rp.bigdata.test_iceberg_1 using iceberg PARTITIONED BY(ds) as " +
                "SELECT 'xxx' as name, 23 as price, '20211203' as ds"

        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is CreateTableAsSelect) {
            val tableName = statement.tableId.tableName
            Assert.assertEquals(StatementType.CREATE_TABLE_AS_SELECT, statement.statementType)
            Assert.assertEquals("test_iceberg_1", tableName)
            Assert.assertEquals("SELECT 'xxx' as name, 23 as price, '20211203' as ds", statement.queryStmt.getSql())
        } else {
            Assert.fail()
        }
    }

    @Test
    fun replaceTableSelectTest() {
        val sql =
            "create or replace table tdl_users_1 STORED AS ORC as select * from bigdata.users a left outer join address b on a.addr_id = b.id"

        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is CreateTableAsSelect) {
            val tableName = statement.tableId.tableName
            Assert.assertTrue(statement.replace)
            Assert.assertEquals(StatementType.CREATE_TABLE_AS_SELECT, statement.statementType)
            Assert.assertEquals(statement.fileFormat, "ORC")
            Assert.assertEquals("tdl_users_1", tableName)
            Assert.assertEquals(
                "select * from bigdata.users a left outer join address b on a.addr_id = b.id",
                statement.queryStmt.getSql(),
            )
            Assert.assertEquals(2, statement.queryStmt.inputTables.size)
            Assert.assertEquals("users", statement.queryStmt.inputTables.get(0).tableName)
            Assert.assertEquals("address", statement.queryStmt.inputTables.get(1).tableName)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun dropTableTest() {
        val sql = "drop table if exists sale_detail_drop2"

        val statement = SparkSqlHelper.parseStatement(sql)

        Assert.assertEquals(StatementType.DROP_TABLE, statement.statementType)
        if (statement is DropTable) {
            val name = statement.tableId?.tableName
            Assert.assertEquals("sale_detail_drop2", name)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun dropViewTest() {
        val sql = "drop view if exists sale_detail_drop2"

        val statement = SparkSqlHelper.parseStatement(sql)

        Assert.assertEquals(StatementType.DROP_VIEW, statement.statementType)
        if (statement is DropView) {
            Assert.assertEquals("sale_detail_drop2", statement.tableId?.tableName)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun truncateTableTest() {
        val sql = "TRUNCATE TABLE test.user partition(ds='20170403')"

        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is TruncateTable) {
            val name = statement.tableId.tableName
            Assert.assertEquals("user", name)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun msckTableTest() {
        val sql = "MSCK REPAIR TABLE test.user"

        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is RepairTable) {
            val name = statement.tableId.tableName
            Assert.assertEquals("user", name)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun createViewTest0() {
        val sql =
            """CREATE View view_users
            comment 'view test'
            as
            select * from account
            """

        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is CreateView) {
            Assert.assertEquals(StatementType.CREATE_VIEW, statement.statementType)
            Assert.assertEquals("view_users", statement.tableId.tableName)
            Assert.assertEquals("view test", statement.comment)
            Assert.assertEquals("select * from account", statement.queryStmt.getSql())
        } else {
            Assert.fail()
        }
    }

    @Test
    fun createViewTest1() {
        val sql =
            """CREATE View if not exists view_users
            comment 'view test'
            as
            select *, bigdata.test(name) from account
            """

        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is CreateView) {
            Assert.assertEquals(StatementType.CREATE_VIEW, statement.statementType)
            Assert.assertEquals("view_users", statement.tableId.tableName)
            Assert.assertEquals("view test", statement.comment)
            Assert.assertEquals(1, statement.queryStmt.functionNames.size)
            Assert.assertEquals(FunctionId("bigdata", "test"), statement.queryStmt.functionNames.first())

            Assert.assertEquals("select *, bigdata.test(name) from account", statement.queryStmt.getSql())
            Assert.assertEquals("account", statement.queryStmt.inputTables.get(0).tableName)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun createTemporaryViewTest0() {
        val sql =
            """
            CREATE TEMPORARY VIEW jdbcTable
            USING org.apache.spark.sql.jdbc
            OPTIONS (
              url "jdbc:postgresql:dbserver",
              dbtable "schema.tablename",
              user 'username',
              password 'password'
            )
            """

        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is CreateTempViewUsing) {
            Assert.assertEquals(StatementType.CREATE_TEMP_VIEW_USING, statement.statementType)
            Assert.assertEquals("jdbcTable", statement.tableId.tableName)
            Assert.assertEquals("org.apache.spark.sql.jdbc", statement.fileFormat)
            Assert.assertEquals(4, statement.properties.size)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun alterViewTest0() {
        val sql = "ALTER VIEW v1 AS SELECT x, UPPER(s) s FROM t2"

        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is AlterTable) {
            Assert.assertEquals("v1", statement.tableId.tableName)
            val action = statement.firstAction() as AlterViewAction
            Assert.assertEquals(AlterActionType.ALTER_VIEW_QUERY, statement.firstAction().alterType)
            Assert.assertEquals("SELECT x, UPPER(s) s FROM t2", action.queryStmt.getSql())
            Assert.assertEquals("t2", action.queryStmt.inputTables.get(0).tableName)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun renameTableTest() {
        val sql = "alter table test.table_name rename to new_table_name"

        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is AlterTable) {
            val action = statement.firstAction() as RenameAction
            Assert.assertEquals(AlterActionType.RENAME, action.alterType)
            Assert.assertEquals("new_table_name", action.newTableId.tableName)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun touchTableTest() {
        val sql = "alter table test.table_name TOUCH"

        val statement = SparkSqlHelper.parseStatement(sql)

        Assert.assertEquals(StatementType.ALTER_TABLE, statement.statementType)
        if (statement is AlterTable) {
            Assert.assertEquals("table_name", statement.tableId.tableName)
            Assert.assertEquals(AlterActionType.TOUCH_TABLE, statement.firstAction().alterType)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun touchTablePrtitionTest() {
        val sql = "alter table test.table_name TOUCH partition(ds=20210812, type='login')"

        val statement = SparkSqlHelper.parseStatement(sql)

        Assert.assertEquals(StatementType.ALTER_TABLE, statement.statementType)
        if (statement is AlterTable) {
            Assert.assertEquals("table_name", statement.tableId.tableName)
            val action = statement.firstAction() as AlterTouchPartitionAction
            Assert.assertEquals(AlterActionType.TOUCH_TABLE, action.alterType)
            Assert.assertEquals(2, action.partitionVals?.size)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun alterTablePropertiesTest() {
        var sql =
            "ALTER TABLE test.sale_detail SET TBLPROPERTIES ('comment' = 'new coments for statement sale_detail', 'lifeCycle' = '7')"

        var statement = SparkSqlHelper.parseStatement(sql)

        if (statement is AlterTable) {
            Assert.assertEquals(StatementType.ALTER_TABLE, statement.statementType)
            Assert.assertEquals("sale_detail", statement.tableId.tableName)
            val action = statement.firstAction() as AlterPropsAction
            Assert.assertEquals(2, action.properties.size)
        } else {
            Assert.fail()
        }

        sql = "ALTER TABLE aaa.bbb SET SERDEPROPERTIES ('field.delim' = ',')"
        statement = SparkSqlHelper.parseStatement(sql)

        if (statement is AlterTable) {
            Assert.assertEquals(StatementType.ALTER_TABLE, statement.statementType)
            Assert.assertEquals("bbb", statement.tableId.tableName)
            val action = statement.firstAction() as AlterSerDeAction
            Assert.assertEquals(1, action.properties.size)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun addColumnsTest() {
        val sql =
            "alter table test.sale_detail add columns (col_name1 string comment 'col_name1', col_name2 string comment 'col_name2')"

        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is AlterTable) {
            Assert.assertEquals(StatementType.ALTER_TABLE, statement.statementType)
            Assert.assertEquals("sale_detail", statement.tableId.tableName)
            val cols = statement.actions as List<AlterColumnAction>
            Assert.assertEquals(2, cols.size)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun addColumnTest() {
        val sql = "ALTER TABLE db.sample ADD COLUMN age int FIRST"

        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is AlterTable) {
            Assert.assertEquals(StatementType.ALTER_TABLE, statement.statementType)
            Assert.assertEquals("sample", statement.tableId.tableName)
            val action = statement.firstAction() as AlterColumnAction
            Assert.assertEquals("first", action.position)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun renameColumnTest() {
        val sql = "ALTER TABLE db.sample RENAME COLUMN data TO payload"

        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is AlterTable) {
            Assert.assertEquals(StatementType.ALTER_TABLE, statement.statementType)
            Assert.assertEquals("sample", statement.tableId.tableName)
            val action = statement.firstAction() as AlterColumnAction
            Assert.assertEquals("payload", action.newColumName)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun changeColumnTest() {
        var sql = "ALTER TABLE db.sample ALTER COLUMN location.lat TYPE double"
        var statement = SparkSqlHelper.parseStatement(sql)
        if (statement is AlterTable) {
            Assert.assertEquals(StatementType.ALTER_TABLE, statement.statementType)
            Assert.assertEquals("sample", statement.tableId.tableName)
            val action = statement.firstAction() as AlterColumnAction
            Assert.assertEquals("double", action.dataType)
        } else {
            Assert.fail()
        }

        sql = "ALTER TABLE db.sample ALTER COLUMN id DROP NOT NULL"
        statement = SparkSqlHelper.parseStatement(sql)
        if (statement is AlterTable) {
            Assert.assertEquals(StatementType.ALTER_TABLE, statement.statementType)
            Assert.assertEquals("sample", statement.tableId.tableName)
            val action = statement.firstAction() as AlterColumnAction
            Assert.assertEquals("id", action.columName)
        } else {
            Assert.fail()
        }

        sql = "ALTER TABLE db.sample ALTER COLUMN point.z AFTER y"
        statement = SparkSqlHelper.parseStatement(sql)
        if (statement is AlterTable) {
            Assert.assertEquals(StatementType.ALTER_TABLE, statement.statementType)
            Assert.assertEquals("sample", statement.tableId.tableName)

            val action = statement.firstAction() as AlterColumnAction
            Assert.assertEquals("after", action.position)
            Assert.assertEquals("y", action.afterCol)
        } else {
            Assert.fail()
        }

        sql = "ALTER TABLE db.sample ALTER COLUMN id COMMENT 'unique id'"
        statement = SparkSqlHelper.parseStatement(sql)
        if (statement is AlterTable) {
            Assert.assertEquals(StatementType.ALTER_TABLE, statement.statementType)
            Assert.assertEquals("sample", statement.tableId.tableName)

            val action = statement.firstAction() as AlterColumnAction
            Assert.assertEquals("unique id", action.comment)
        } else {
            Assert.fail()
        }

        sql = "ALTER TABLE demo CHANGE COLUMN price Type float COMMENT '价格'"
        statement = SparkSqlHelper.parseStatement(sql)
        if (statement is AlterTable) {
            Assert.assertEquals(StatementType.ALTER_TABLE, statement.statementType)
            Assert.assertEquals("demo", statement.tableId.tableName)

            val action = statement.firstAction() as AlterColumnAction
            Assert.assertEquals("float", action.dataType)
            Assert.assertEquals("价格", action.comment)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun changeColumnTest1() {
        val sql = "ALTER TABLE test_user11_dt ALTER COLUMN ds comment 'ddd'"
        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is AlterTable) {
            Assert.assertEquals(StatementType.ALTER_TABLE, statement.statementType)
            Assert.assertEquals("test_user11_dt", statement.tableId.tableName)

            val action = statement.firstAction() as AlterColumnAction
            Assert.assertEquals("ds", action.columName)
            Assert.assertNull(action.newColumName)
            Assert.assertNull(action.dataType)
            Assert.assertEquals("ddd", action.comment)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun dropColumnTest() {
        val sql = "ALTER TABLE db.sample DROP COLUMN id"

        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is AlterTable) {
            Assert.assertEquals(StatementType.ALTER_TABLE, statement.statementType)
            Assert.assertEquals("sample", statement.tableId.tableName)

            val action = statement.firstAction() as DropColumnAction
            Assert.assertEquals("id", action.columNames.get(0))
        } else {
            Assert.fail()
        }
    }

    @Test
    fun setTableLocationTest() {
        val sql = "alter table demo partition(ds='20180317') set location '/user/hive'"

        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is AlterTable) {
            Assert.assertEquals(StatementType.ALTER_TABLE, statement.statementType)
            Assert.assertEquals("demo", statement.tableId.tableName)
            val action = statement.firstAction() as AlterPropsAction
            Assert.assertEquals("/user/hive", action.location)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun updateColumnTest() {
        val sql = "ALTER TABLE sale_detail CHANGE COLUMN old_col_name new_col_name string comment 'sdsd'"

        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is AlterTable) {
            Assert.assertEquals("sale_detail", statement.tableId.tableName)

            val action = statement.firstAction() as AlterColumnAction
            Assert.assertEquals("new_col_name", action.newColumName)
            Assert.assertEquals("sdsd", action.comment)
        } else {
            Assert.fail()
        }

        val sql1 = "ALTER TABLE test_users_dt CHANGE age2 age3 int"

        val statement1 = SparkSqlHelper.parseStatement(sql1)
        if (statement1 is AlterTable) {
            Assert.assertEquals("test_users_dt", statement1.tableId.tableName)

            val action = statement1.firstAction() as AlterColumnAction
            Assert.assertEquals("age3", action.newColumName)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun dropPartitionTest0() {
        val sql =
            "ALTER TABLE page_view DROP IF EXISTS PARTITION (dt='2008-08-08', country='us'), PARTITION (dt='2008-08-09', country='us')"

        val statement = SparkSqlHelper.parseStatement(sql)

        Assert.assertEquals(StatementType.ALTER_TABLE, statement.statementType)
        if (statement is AlterTable) {
            Assert.assertEquals("page_view", statement.tableId.tableName)
            val action = statement.firstAction() as DropPartitionAction
            Assert.assertTrue(action.ifExists)
            Assert.assertEquals(AlterActionType.DROP_PARTITION, action.alterType)
            // Assert.assertEquals(2, action.partitions.size)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun dropPartitionTest1() {
        val sql =
            "ALTER TABLE page_view DROP PARTITION (dt='2008-08-08', country='us'), PARTITION (dt='2008-08-09', country='us')"

        val statement = SparkSqlHelper.parseStatement(sql)

        Assert.assertEquals(StatementType.ALTER_TABLE, statement.statementType)
        if (statement is AlterTable) {
            Assert.assertEquals("page_view", statement.tableId.tableName)
            val action = statement.firstAction() as DropPartitionAction
            Assert.assertFalse(action.ifExists)
            Assert.assertEquals(AlterActionType.DROP_PARTITION, action.alterType)
            // Assert.assertEquals(2, action.partitions.size)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun dropPartitionTest2() {
        val sql = "ALTER TABLE page_view DROP PARTITION (dt='2008-08-08')"

        val statement = SparkSqlHelper.parseStatement(sql)

        Assert.assertEquals(StatementType.ALTER_TABLE, statement.statementType)
        if (statement is AlterTable) {
            Assert.assertEquals("page_view", statement.tableId.tableName)
            val action = statement.firstAction() as DropPartitionAction
            Assert.assertFalse(action.ifExists)
            Assert.assertEquals(AlterActionType.DROP_PARTITION, action.alterType)
            // Assert.assertEquals(2, action.partitions.size)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun addPartitionTest0() {
        val sql = "ALTER TABLE page_view ADD PARTITION (partCol = 'value1') "

        val statement = SparkSqlHelper.parseStatement(sql)

        Assert.assertEquals(StatementType.ALTER_TABLE, statement.statementType)
        if (statement is AlterTable) {
            Assert.assertEquals("page_view", statement.tableId.tableName)
            val action = statement.firstAction() as AddPartitionAction
            Assert.assertFalse(action.ifNotExists)
            Assert.assertEquals(AlterActionType.ADD_PARTITION, action.alterType)
            Assert.assertEquals(1, action.partitions.size)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun addPartitionTest1() {
        val sql = "ALTER TABLE page_view add IF NOT EXISTS PARTITION (dt='2008-08-08', country='us')"

        val statement = SparkSqlHelper.parseStatement(sql)

        Assert.assertEquals(StatementType.ALTER_TABLE, statement.statementType)
        if (statement is AlterTable) {
            Assert.assertEquals("page_view", statement.tableId.tableName)
            val action = statement.firstAction() as AddPartitionAction
            Assert.assertTrue(action.ifNotExists)
            Assert.assertEquals(AlterActionType.ADD_PARTITION, action.alterType)
            Assert.assertEquals(1, action.partitions.size)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun renamePartitionTest() {
        val sql = "ALTER TABLE page_view PARTITION (dt='2008-08-08')  RENAME TO PARTITION (dt='20080808')"

        val statement = SparkSqlHelper.parseStatement(sql)

        Assert.assertEquals(StatementType.ALTER_TABLE, statement.statementType)
        if (statement is AlterTable) {
            Assert.assertEquals("page_view", statement.tableId.tableName)
            val action = statement.firstAction() as RenamePartitionAction
            Assert.assertEquals(AlterActionType.RENAME_PARTITION, action.alterType)
            Assert.assertEquals(1, action.fromPartitionVals.size)
            Assert.assertEquals(1, action.toPartitionVals.size)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun createFuncTest() {
        val sql =
            "CREATE FUNCTION test.train_perceptron AS 'hivemall.classifier.PerceptronUDTF' " +
                "using jar 'hdfs://tdhdfs/user/datacompute/platformtool/resources/132/latest/hivemall-spark.jar'"

        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is CreateFunction) {
            Assert.assertEquals("test", statement.functionId.schemaName)
            Assert.assertEquals("train_perceptron", statement.functionId.functionName)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun createFuncTest1() {
        val sql =
            "CREATE TEMPORARY FUNCTION IF NOT EXISTS stream_json_extract_value " +
                "AS 'com.dataworker.spark.jobserver.driver.udf.GenericUDTFJsonExtractValue'"

        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is CreateFunction) {
            Assert.assertEquals("stream_json_extract_value", statement.functionId.functionName)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun dropFuncTest() {
        val sql = "drop FUNCTION train_perceptron"

        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is DropFunction) {
            Assert.assertEquals("train_perceptron", statement.functionId.functionName)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun queryTest0() {
        val sql =
            """
            select * from `demo_rp`.bigdata.users a join address b on a.addr_id=b.id limit 101 OFFSET 10
            select * from `demo_rp`.bigdata.users1 a join address1 b on a.addr_id=b.id limit 102
            select transform(name,idcard) USING 'python udf-python.py'  AS (name,id_card,gre) from db_mxy.person
        """
                .trimIndent()

        val statements = SparkSqlHelper.parseMultiStatement(sql)

        Assert.assertEquals(3, statements.size)

        val query0 = statements.get(0)
        val query1 = statements.get(1)
        if (query0 is QueryStmt) {
            Assert.assertEquals(StatementType.SELECT, query0.statementType)
            Assert.assertEquals(2, query0.inputTables.size)
            Assert.assertEquals("users", query0.inputTables.get(0).tableName)
            Assert.assertEquals("demo_rp.bigdata.users", query0.inputTables.get(0).getFullTableName())
            Assert.assertEquals("address", query0.inputTables.get(1).tableName)
            Assert.assertEquals(101, query0.limit)
            Assert.assertEquals(10, query0.offset)
        }
        if (query1 is QueryStmt) {
            Assert.assertEquals(StatementType.SELECT, query1.statementType)
            Assert.assertEquals(2, query1.inputTables.size)
            Assert.assertEquals("users1", query1.inputTables.get(0).tableName)
            Assert.assertEquals("demo_rp.bigdata.users1", query1.inputTables.get(0).getFullTableName())
            Assert.assertEquals("address1", query1.inputTables.get(1).tableName)
            Assert.assertEquals(102, query1.limit)
            Assert.assertNull(query1.offset)
        }
    }

    @Test
    fun queryTest1() {
        val sql = "select * from (select * from users where name='melin') a limit 1001"
        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is QueryStmt) {
            Assert.assertEquals(StatementType.SELECT, statement.statementType)
            Assert.assertEquals(1, statement.inputTables.size)
            Assert.assertEquals("users", statement.inputTables.get(0).tableName)
            Assert.assertEquals(1001, statement.limit)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun queryTest2() {
        val sql =
            "select * from users a join (select * from address where type='hangzhou') b on a.addr_id=b.id limit 101"
        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is QueryStmt) {
            Assert.assertEquals(StatementType.SELECT, statement.statementType)
            Assert.assertEquals(2, statement.inputTables.size)
            Assert.assertEquals("users", statement.inputTables.get(0).tableName)
            Assert.assertEquals("address", statement.inputTables.get(1).tableName)
            Assert.assertEquals(101, statement.limit)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun queryTest3() {
        val sql =
            """
            select bzdys, bzhyyh, bzdy, week, round((bzdy-bzdys)*100/bzdys, 2)
            from (
                select lag(bzdy) over (order by week) bzdys, bzhyyh, bzdy, week
                from (
                    select count(distinct partner_code) bzhyyh, count(1) bzdy, week from tdl_dt2x_table
                ) a
            ) b limit 111
        """
                .trimIndent()

        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is QueryStmt) {
            Assert.assertEquals(StatementType.SELECT, statement.statementType)
            Assert.assertEquals(1, statement.inputTables.size)
            Assert.assertEquals("tdl_dt2x_table", statement.inputTables.get(0).tableName)
            Assert.assertEquals(111, statement.limit)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun queryTest4() {
        val sql = "select 2-1"

        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is QueryStmt) {
            Assert.assertEquals(StatementType.SELECT, statement.statementType)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun queryTest5() {
        val sql =
            "select \n" +
                "     t.table_name\n" +
                "     ,concat_ws('.',t.database_name,t.table_name) tab_name\n" +
                "     ,t.database_name\n" +
                "     ,t.owner \n" +
                "     ,count(distinct t2.project_code) prj_cnt\n" +
                "     ,count(distinct t1.obj_name) app_user_cnt\n" +
                "     from tidb_datacompute.t_table t \n" +
                "     left join tidb_datacompute.sec_table_privs t1\n" +
                "            on t.table_name = t1.table_name\n" +
                "           and t1.status=1\n" +
                "           and t1.expire_date >= current_date()\n" +
                "     left join tidb_datacompute.dc_project_member t2\n" +
                "             on t1.obj_id = t2.user_id\n" +
                "     where t.`lifecycle` == 1" +
                "     group by t.table_name,t.owner,t.database_name "

        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is QueryStmt) {
            Assert.assertEquals(StatementType.SELECT, statement.statementType)
            Assert.assertEquals(3, statement.inputTables.size)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun queryTest6() {
        val sql = "select * from test"

        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is QueryStmt) {
            Assert.assertEquals(StatementType.SELECT, statement.statementType)
            Assert.assertEquals(1, statement.inputTables.size)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun queryTest7() {
        val sql = "select true is false"

        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is QueryStmt) {
            Assert.assertEquals(StatementType.SELECT, statement.statementType)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun queryTest8() {
        val sql = "select 'test' as name"

        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is QueryStmt) {
            Assert.assertEquals(StatementType.SELECT, statement.statementType)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun insertIntoTest0() {
        val sql =
            "insert into TABLE users PARTITION(ds='20170220') values('libinsong', 12, 'test'), ('libinsong', 13, 'test')"
        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is InsertTable) {
            Assert.assertEquals(StatementType.INSERT, statement.statementType)
            Assert.assertEquals(InsertMode.INTO, statement.mode)
            Assert.assertEquals("users", statement.tableId.tableName)
            Assert.assertEquals(2, statement.rows?.size)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun insertIntoTest1() {
        val sql = "insert into bigdata.delta_lsw_test values('lsw'),('lsw1')"
        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is InsertTable) {
            Assert.assertEquals(StatementType.INSERT, statement.statementType)
            Assert.assertEquals(InsertMode.INTO, statement.mode)
            Assert.assertEquals("delta_lsw_test", statement.tableId.tableName)
            Assert.assertEquals(2, statement.rows?.size)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun insertIntoTest2() {
        val sql = "insert into demo SELECT * FROM hudi_table_changes('db.table', 'latest_state', 'earliest')"
        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is InsertTable) {
            Assert.assertEquals(StatementType.INSERT, statement.statementType)
            Assert.assertEquals(InsertMode.INTO, statement.mode)

            Assert.assertEquals("demo", statement.tableId.tableName)
            Assert.assertEquals(1, statement.queryStmt.functionNames.size)
            Assert.assertEquals("hudi_table_changes", statement.queryStmt.functionNames.first().functionName)
            Assert.assertEquals("TVF", statement.queryStmt.functionNames.first().funcType)
            Assert.assertEquals(3, statement.queryStmt.functionNames.first().functionArguments.size)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun insertTableCustomColumn() {
        val sql = "INSERT INTO test_demo_test (name) VALUES('lisi')"
        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is InsertTable) {
            Assert.assertEquals(StatementType.INSERT, statement.statementType)
            Assert.assertEquals(InsertMode.INTO, statement.mode)
            Assert.assertEquals("test_demo_test", statement.tableId?.tableName)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun insertOverwriteTest0() {
        val sql = "insert OVERWRITE TABLE users PARTITION(ds='20170220', type='login') values('libinsong')"
        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is InsertTable) {
            Assert.assertEquals(StatementType.INSERT, statement.statementType)
            Assert.assertEquals(InsertMode.OVERWRITE, statement.mode)
            Assert.assertEquals(2, statement.partitionVals?.size)
            Assert.assertEquals("users", statement.tableId.tableName)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun insertOverwriteTest1() {
        val sql = "insert OVERWRITE TABLE users PARTITION(ds) values('libinsong', '20170220')"
        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is InsertTable) {
            Assert.assertEquals(StatementType.INSERT, statement.statementType)
            Assert.assertEquals(InsertMode.OVERWRITE, statement.mode)
            Assert.assertEquals(1, statement.partitionVals?.size)
            Assert.assertEquals("users", statement.tableId.tableName)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun insertOverwriteQueryTest2() {
        val sql =
            "insert INTO users PARTITION(ds='20170220', type='login') select * from account a join address b on a.addr_id=b.id"
        val statement = SparkSqlHelper.parseStatement(sql)
        if (statement is InsertTable) {
            Assert.assertEquals(StatementType.INSERT, statement.statementType)
            Assert.assertEquals("users", statement.tableId.tableName)
            Assert.assertEquals(InsertMode.INTO, statement.mode)
            Assert.assertEquals(2, statement.partitionVals?.size)

            Assert.assertEquals(2, statement.queryStmt.inputTables.size)
            Assert.assertEquals("account", statement.queryStmt.inputTables.get(0).tableName)
            Assert.assertEquals("address", statement.queryStmt.inputTables.get(1).tableName)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun insertOverwriteQueryTest3() {
        val sql = "insert INTO users select *, bigdata.Test(id) from account a join address b on a.addr_id=b.id"
        val statement = SparkSqlHelper.parseStatement(sql)
        if (statement is InsertTable) {
            Assert.assertEquals(StatementType.INSERT, statement.statementType)
            Assert.assertEquals("users", statement.tableId?.tableName)
            Assert.assertEquals(InsertMode.INTO, statement.mode)
            Assert.assertEquals(0, statement.partitionVals?.size)
            Assert.assertEquals(
                statement.queryStmt.getSql(),
                "select *, bigdata.Test(id) from account a join address b on a.addr_id=b.id",
            )

            Assert.assertEquals(2, statement.queryStmt.inputTables.size)
            Assert.assertEquals("account", statement.queryStmt.inputTables.get(0).tableName)
            Assert.assertEquals("address", statement.queryStmt.inputTables.get(1).tableName)

            Assert.assertEquals(FunctionId("bigdata", "test"), statement.queryStmt.functionNames.first())
        } else {
            Assert.fail()
        }
    }

    @Test
    fun insertOverwriteQueryTest4() {
        val sql =
            "insert OVERWRITE TABLE users PARTITION(ds='20170220') select * from account1 union all " +
                "select * from account2"
        val statement = SparkSqlHelper.parseStatement(sql)
        if (statement is InsertTable) {
            Assert.assertEquals(StatementType.INSERT, statement.statementType)
            Assert.assertEquals("users", statement.tableId?.tableName)
            Assert.assertEquals(InsertMode.OVERWRITE, statement.mode)
            Assert.assertEquals(1, statement.partitionVals?.size)

            Assert.assertEquals(2, statement.queryStmt.inputTables.size)
            Assert.assertEquals("account1", statement.queryStmt.inputTables.get(0).tableName)
            Assert.assertEquals("account2", statement.queryStmt.inputTables.get(1).tableName)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun mutilInsertTest() {
        val sql =
            """
            FROM default.sample_07
            INSERT OVERWRITE TABLE toodey1 SELECT sample_07.code,sample_07.salary
            INSERT OVERWRITE TABLE toodey2 SELECT sample_07.code,sample_07.salary WHERE sample_07.salary >= 50000
            INSERT OVERWRITE TABLE toodey3 SELECT sample_07.total_emp,sample_07.salary WHERE sample_07.salary <= 50000
        """
                .trimIndent()

        val statement = SparkSqlHelper.parseStatement(sql)
        if (statement is InsertTable) {
            Assert.assertEquals(StatementType.INSERT, statement.statementType)
            Assert.assertEquals(3, statement.outputTables.size)
            Assert.assertEquals("sample_07", statement.queryStmt.inputTables.get(0).tableName)
            Assert.assertEquals("toodey3", statement.outputTables.get(2).tableName)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun useTest() {
        val sql = "use bigdata"

        val statement = SparkSqlHelper.parseStatement(sql)
        Assert.assertEquals(StatementType.USE, statement.statementType)

        if (statement is UseDatabase) {
            Assert.assertEquals("bigdata", statement.databaseName)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun setTest() {
        val sql =
            """
            set spark.executor.memory = '30g'
            set spark.sql.enabled=true;
            set spark.sql.test="ddsd";
            set spark.sql.test2;
            reset spark.sql.test;
        """
                .trimIndent()

        val statements = SparkSqlHelper.parseMultiStatement(sql)
        Assert.assertEquals(5, statements.size)
    }

    @Test
    fun mergeTest() {
        val sql = "merge table test OPTIONS (mergefile=2)"
        SparkSqlHelper.parseStatement(sql)
    }

    @Test
    fun substrFile() {
        val sql = "SELECT substring('Spark SQL' from 5)"

        val statement = SparkSqlHelper.parseStatement(sql)
        Assert.assertEquals(StatementType.SELECT, statement.statementType)
    }

    @Test
    fun druidSql() {
        val sql = "SELECT * from druid.`select * from test`"

        val statement = SparkSqlHelper.parseStatement(sql)
        Assert.assertEquals(StatementType.SELECT, statement.statementType)

        if (statement is QueryStmt) {
            Assert.assertEquals("druid", statement.inputTables.get(0).schemaName)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun druidSql1() {
        val sql = "SELECT * from tdl_xdsd_sd"

        val statement = SparkSqlHelper.parseStatement(sql)
        Assert.assertEquals(StatementType.SELECT, statement.statementType)
        if (statement is QueryStmt) {
            Assert.assertNull(statement.inputTables.get(0).schemaName)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun deleteTest() {
        val sql =
            """
            DELETE FROM films
            WHERE producer_id IN (SELECT id FROM producers WHERE name = 'foo');
        """
                .trimIndent()

        val statement = SparkSqlHelper.parseStatement(sql)
        if (statement is DeleteTable) {
            Assert.assertEquals(StatementType.DELETE, statement.statementType)
            Assert.assertEquals("films", statement.tableId?.tableName)
            Assert.assertEquals(1, statement.inputTables.size)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun updateTest0() {
        val sql =
            """
            UPDATE employees SET sales_count = sales_count + 1 WHERE id =
            (SELECT sales_person FROM accounts WHERE name = 'Acme Corporation');
        """
                .trimIndent()

        val statement = SparkSqlHelper.parseStatement(sql)
        if (statement is UpdateTable) {
            Assert.assertEquals(StatementType.UPDATE, statement.statementType)
            Assert.assertEquals("employees", statement.tableId?.tableName)
            Assert.assertEquals(1, statement.inputTables.size)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun updateTest1() {
        val sql = "update user set name='xxx'"

        val statement = SparkSqlHelper.parseStatement(sql)
        if (statement is UpdateTable) {
            Assert.assertEquals(StatementType.UPDATE, statement.statementType)
            Assert.assertEquals("user", statement.tableId?.tableName)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun deltaMergeTest() {
        val sql =
            """
            MERGE INTO logs
            USING updates
            ON logs.uniqueId = updates.uniqueId
            WHEN NOT MATCHED
              THEN INSERT *
        """
                .trimIndent()

        val statement = SparkSqlHelper.parseStatement(sql)
        if (statement is MergeTable) {
            Assert.assertEquals(StatementType.MERGE, statement.statementType)
            Assert.assertEquals("logs", statement.targetTable.tableName)
            Assert.assertEquals(1, statement.inputTables.size)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun deltaMergeTest0() {
        val sql =
            """
            MERGE INTO logs
            USING updates
            ON logs.uniqueId = updates.uniqueId AND logs.date > current_date() - INTERVAL 7 DAYS
            WHEN NOT MATCHED AND updates.date > current_date() - INTERVAL 7 DAYS
              THEN INSERT *
        """
                .trimIndent()

        val statement = SparkSqlHelper.parseStatement(sql)
        if (statement is MergeTable) {
            Assert.assertEquals(StatementType.MERGE, statement.statementType)
            Assert.assertEquals("logs", statement.targetTable.tableName)
            Assert.assertEquals(1, statement.inputTables.size)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun deltaMergeTest1() {
        val sql =
            """
            MERGE INTO customers
            USING (
              SELECT updates.customerId as mergeKey, updates.*
              FROM updates
              UNION ALL
              SELECT NULL as mergeKey, updates.*
              FROM updates JOIN customers
              ON updates.customerid = customers.customerid 
              WHERE customers.current = true AND updates.address <> customers.address
            ) staged_updates
            ON customers.customerId = mergeKey
            WHEN MATCHED AND customers.current = true AND customers.address <> staged_updates.address THEN  
              UPDATE SET current = false, endDate = staged_updates.effectiveDate
            WHEN NOT MATCHED THEN 
              INSERT(customerid, address, current, effectivedate, enddate) 
              VALUES(staged_updates.customerId, staged_updates.address, true, staged_updates.effectiveDate, null)
        """
                .trimIndent()

        val statement = SparkSqlHelper.parseStatement(sql)
        if (statement is MergeTable) {
            Assert.assertEquals(StatementType.MERGE, statement.statementType)
            Assert.assertEquals("customers", statement.targetTable.tableName)
            Assert.assertEquals(2, statement.inputTables.size)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun deltaMergeTest2() {
        val sql =
            """
            MERGE INTO target t
            USING (
              SELECT key, latest.newValue as newValue, latest.deleted as deleted FROM (    
                SELECT key, max(struct(time, newValue, deleted)) as latest FROM changes GROUP BY key
              )
            ) s
            ON s.key = t.key
            WHEN MATCHED AND s.deleted = true THEN DELETE
            WHEN MATCHED THEN UPDATE SET key = s.key, value = s.newValue
            WHEN NOT MATCHED AND s.deleted = false THEN INSERT (key, value) VALUES (key, newValue)
        """
                .trimIndent()

        val statement = SparkSqlHelper.parseStatement(sql)
        if (statement is MergeTable) {
            Assert.assertEquals(StatementType.MERGE, statement.statementType)
            Assert.assertEquals("target", statement.targetTable.tableName)
            Assert.assertEquals(1, statement.inputTables.size)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun deltaMergeTest3() {
        val sql =
            """
            MERGE INTO
               bigdata.merge_test a1
            USING
               bigdata.merge_test1 a2
            ON
               a1.name = a2.name
            WHEN MATCHED THEN UPDATE SET a1.age = a2.age
        """
                .trimIndent()

        val statement = SparkSqlHelper.parseStatement(sql)
        if (statement is MergeTable) {
            Assert.assertEquals(StatementType.MERGE, statement.statementType)
            Assert.assertEquals("merge_test", statement.targetTable.tableName)
            Assert.assertEquals(1, statement.inputTables.size)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun cetSelectTest0() {
        val sql =
            """
            with q1 as ( select key from q2 where key = '5'),
            q2 as ( select key from test where key = '5')
            select * from (select key from q1) a
        """
                .trimIndent()

        val statement = SparkSqlHelper.parseStatement(sql)
        if (statement is QueryStmt) {
            Assert.assertEquals(2, statement.inputTables.size)
            Assert.assertEquals(StatementType.SELECT, statement.statementType)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun cetInsertTest0() {
        val sql =
            """
            with
            a as (select * from src where key is not null),
            b as (select  * from src2 where value>0),
            c as (select * from src3 where value>0),
            d as (select a.key,b.value from a join b on a.key=b.key),
            e as (select a.key,c.value from a left outer join c on a.key=c.key and c.key is not null)
            insert overwrite table srcp partition (p='abc')
            select * from d union all select * from e
        """
                .trimIndent()

        val statement = SparkSqlHelper.parseStatement(sql)
        if (statement is InsertTable) {
            Assert.assertEquals(3, statement.queryStmt.inputTables.size)
            Assert.assertEquals(StatementType.INSERT, statement.statementType)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun exportTest0() {
        val sql =
            """
           with 
                a as (select * from test),
                druid_result as (select * from a)
           export table druid_result TO 'druid_result.csv'
        """
                .trimIndent()

        val statement = SparkSqlHelper.parseStatement(sql)
        if (statement is ExportTable) {
            Assert.assertEquals(1, statement.inputTables.size)
            Assert.assertEquals(StatementType.EXPORT_TABLE, statement.statementType)
            Assert.assertEquals("druid_result", statement.tableId.tableName)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun createExternalTableTest1() {
        val sql =
            """CREATE EXTERNAL TABLE s3Db.test_zc_s3(
                        name String COMMENT 'name',
                        cnt INT COMMENT 'cnt'
                    ) COMMENT '原始数据表'
                    LOCATION 's3a://hive/test/'
            """

        val statement = SparkSqlHelper.parseStatement(sql)
        if (statement is CreateTable) {
            val schemaName = statement.tableId.schemaName
            Assert.assertEquals(statement.location, "s3a://hive/test/")
            Assert.assertEquals("s3Db", schemaName)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun createTableTbl() {
        val sql =
            """create table bigdata.test_orc9_dt (
                        name string comment '',
                        name2 String comment ''
                    )
                    TBLPROPERTIES ('compression'='ZSTD', 'fileFormat'='orc', 'encryption'='0', "orc.encrypt"="hz_admin_key:name2", "orc.mask"='nullify:name')
                    STORED AS orc
                    comment 'orc测试'
                    lifecycle 7
            """

        val statement = SparkSqlHelper.parseStatement(sql)
        if (statement is CreateTable) {
            val prop = statement.properties
            Assert.assertEquals("ZSTD", prop?.get("compression"))
        } else {
            Assert.fail()
        }
    }

    @Test
    fun countCondTest() {
        val sql = "select count(type='mac' or null) From test_table where a=2"

        val statement = SparkSqlHelper.parseStatement(sql)
        if (statement is QueryStmt) {
            Assert.assertEquals(StatementType.SELECT, statement.statementType)
            Assert.assertEquals("test_table", statement.inputTables.get(0).tableName)
        } else {
            Assert.fail()
        }
    }

    // @Test
    fun queryLakeTableMetaTest0() {
        val sql = "select * from dc.user.history limit 101"
        val statement = SparkSqlHelper.parseStatement(sql)
        if (statement is QueryStmt) {
            Assert.assertEquals(StatementType.SELECT, statement.statementType)
            Assert.assertEquals(1, statement.inputTables.size)
            Assert.assertEquals("user", statement.inputTables.get(0).tableName)
            // Assert.assertEquals("history", statement.inputTables.get(0).metaAction)
            Assert.assertEquals(101, statement.limit)
        } else {
            Assert.fail()
        }
    }

    // @Test
    fun queryLakeTableMetaTest1() {
        val sql =
            """
            select h.made_current_at, s.operation, h.snapshot_id, h.is_current_ancestor, s.summary['spark.app.id']
            from db.table.history h
            join db.table.snapshots s on h.snapshot_id = s.snapshot_id
            order by made_current_at
        """
                .trimIndent()

        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is QueryStmt) {
            Assert.assertEquals(StatementType.SELECT, statement.statementType)
            Assert.assertEquals(2, statement.inputTables.size)
            Assert.assertEquals("table", statement.inputTables.get(0).tableName)
            // Assert.assertEquals("history", statement.inputTables.get(0).metaAction)

            Assert.assertEquals("table", statement.inputTables.get(1).tableName)
            // Assert.assertEquals("snapshots", statement.inputTables.get(1).metaAction)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun dtunnelTest0() {
        val sql =
            "datatunnel source('sftp') options(host='x.x.x.x') sink('hive') options(table='demo', columns=['id', 'name'])"
        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is DataTunnelExpr) {
            Assert.assertEquals(StatementType.DATATUNNEL, statement.statementType)
            Assert.assertEquals("sftp", statement.sourceType)
            Assert.assertEquals("x.x.x.x", statement.sourceOptions.get("host"))

            Assert.assertEquals("hive", statement.sinkType)
            Assert.assertEquals("demo", statement.sinkOptions.get("table"))

            val list = statement.sinkOptions.get("columns") as List<String>
            Assert.assertEquals(2, list.size)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun dtunnelTest1() {
        val sql =
            """
            datatunnel source('sftp') options(host='x.x.x.x') 
            transform = "select * from result where type='sql'"
            sink('hive') options(table='demo', columns=['id', 'name'])
        """
                .trimIndent()
        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is DataTunnelExpr) {
            Assert.assertEquals(StatementType.DATATUNNEL, statement.statementType)
            Assert.assertEquals("sftp", statement.sourceType)
            Assert.assertEquals("x.x.x.x", statement.sourceOptions.get("host"))

            Assert.assertEquals("select * from result where type='sql'", statement.transformSql)

            Assert.assertEquals("hive", statement.sinkType)
            Assert.assertEquals("demo", statement.sinkOptions.get("table"))

            val list = statement.sinkOptions.get("columns") as List<String>
            Assert.assertEquals(2, list.size)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun dtunnelTest2() {
        val sql = "datatunnel source('sftp') options(host='x.x.x.x') sink('log')"
        val statement = SparkSqlHelper.parseStatement(sql)
        if (statement is DataTunnelExpr) {
            Assert.assertEquals(StatementType.DATATUNNEL, statement.statementType)
            Assert.assertEquals("sftp", statement.sourceType)
            Assert.assertEquals("x.x.x.x", statement.sourceOptions.get("host"))

            Assert.assertEquals("log", statement.sinkType)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun dtunnelTest3() {
        val sql =
            """
            WITH tmp_demo_test2 AS (SELECT *, test(id) FROM bigdata.test_demo_test2 where name is not null), 
                 tmp_demo_test3 AS (select * from tmp_demo_test2) 
                datatunnel SOURCE('hive') OPTIONS(
                databaseName='bigdata',
                tableName='tmp_demo_test2',
                columns=['*'])
            SINK('log') OPTIONS(numRows = 10)
        """
                .trimIndent()
        val statement = SparkSqlHelper.parseStatement(sql)
        if (statement is DataTunnelExpr) {
            Assert.assertEquals(StatementType.DATATUNNEL, statement.statementType)
            Assert.assertEquals("hive", statement.sourceType)

            Assert.assertEquals("log", statement.sinkType)
            Assert.assertEquals(1, statement.inputTables.size)
            Assert.assertEquals(1, statement.functionNames.size)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun dtunnelTest4() {
        val sql =
            """
            DATATUNNEL SOURCE('oracle') OPTIONS(
                username='flinkuser',
                password='flinkpw',
                host='172.18.1.56',
                port=1521,
                serviceName='XE',
                databaseName='FLINKUSER',    tableName='ORDERS', 
                columns=[{'name' : "pk", "type" : "id"},
                          { "name" : "col_ip","type" : "ip" },
                          { "name" : "col_double","type" : "double" },
                          { "name" : "col_long","type" : "long" },
                          { "name" : "col_keyword", "type" : "keyword" },
                          { "name" : "col_text", "type" : "text", "analyzer" : "ik_max_word"},
                          { "name" : "col_geo_point", "type" : "geo_point" },
                          { "name" : "col_date", "type" : "date", "format" : "yyyy-MM-dd HH:mm:ss"},
                          { "name" : "col_nested1", "type" : "nested" },
                          { "name" : "col_object1", "type" : "object" },
                          { "name" : "col_integer_array", "type" : "integer", "array" : TRUE},
                          { "name" : "col_geo_shape", "type" : "geo_shape", "tree" : "quadtree", "precision" : "10m"}
                        ])
                SINK('log') OPTIONS(numRows = 10)
        """
                .trimIndent()
        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is DataTunnelExpr) {
            Assert.assertEquals(StatementType.DATATUNNEL, statement.statementType)
            Assert.assertEquals("oracle", statement.sourceType)

            Assert.assertEquals("log", statement.sinkType)
            val list = statement.sourceOptions.get("columns") as List<HashMap<String, String>>
            Assert.assertEquals(12, list.size)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun dtunnelHelpTest() {
        val sql = "datatunnel help source('sftp')"
        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is DataTunnelHelp) {
            Assert.assertEquals(StatementType.HELP, statement.statementType)

            Assert.assertEquals("source", statement.type)
            Assert.assertEquals("sftp", statement.value)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun callTest0() {
        val sql =
            "CALL catalog_name.system.create_savepoint(table => 'test_hudi_table', instant_time => '20220109225319449')"
        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is CallProcedure) {
            Assert.assertEquals(StatementType.CALL, statement.statementType)
            Assert.assertEquals("catalog_name", statement.procedureIds.first().catalogName)
            Assert.assertEquals("system", statement.procedureIds.first().schemaName)
            Assert.assertEquals("create_savepoint", statement.procedureIds.first().procedureName)
            Assert.assertEquals(2, statement.properties.size)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun callTest1() {
        val sql = "call stats_file_sizes(table => 'test_hudi_demo')"
        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is CallProcedure) {
            Assert.assertEquals(StatementType.CALL, statement.statementType)
            Assert.assertEquals("stats_file_sizes", statement.procedureIds.first().procedureName)
            Assert.assertEquals(1, statement.properties.size)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun callTest2() {
        val sql =
            """
            CALL system.remove_orphan_files(
              table => 'bigdata.ods_iceberg_01',
              older_than => CURRENT_TIMESTAMP - INTERVAL '5' DAYS,
              dry_run => true
            )
        """
                .trimIndent()
        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is CallProcedure) {
            Assert.assertEquals(StatementType.CALL, statement.statementType)
            Assert.assertEquals("remove_orphan_files", statement.procedureIds.first().procedureName)
            Assert.assertEquals(3, statement.properties.size)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun callHelpTest1() {
        val sql = "CALL help"
        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is CallHelp) {
            Assert.assertEquals(StatementType.HELP, statement.statementType)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun callHelpTest2() {
        val sql = "CALL help(cmd => 'show_commits')"
        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is CallHelp) {
            Assert.assertEquals(StatementType.HELP, statement.statementType)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun callHelpTest3() {
        val sql = "CALL help show_commits"
        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is CallHelp) {
            Assert.assertEquals(StatementType.HELP, statement.statementType)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun syncSchemaTest() {
        val sql = "SYNC Database FROM hive_metastore.my_db SET OWNER wangwu"
        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is SyncDatabaseMetadata) {
            Assert.assertEquals(StatementType.SYNC_META, statement.statementType)
            Assert.assertEquals("hive_metastore", statement.catalogName)
            Assert.assertEquals("my_db", statement.databaseName)
            Assert.assertEquals("wangwu", statement.owner)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun syncTableMetaTest() {
        val sql = "SYNC TABLE FROM hive_metastore.default.my_tbl"
        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is SyncTableMetadata) {
            Assert.assertEquals(StatementType.SYNC_META, statement.statementType)
            Assert.assertEquals("hive_metastore", statement.tableId.catalogName)
            Assert.assertEquals("default", statement.tableId.schemaName)
            Assert.assertEquals("my_tbl", statement.tableId.tableName)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun typeConstructor() {
        var sql = "select date '20220-02-13' as demo"
        SparkSqlHelper.parseStatement(sql)

        sql = "select timestamp '20220-02-13' as demo"
        SparkSqlHelper.parseStatement(sql)

        sql = "select time '20220-02-13' as demo"
        SparkSqlHelper.parseStatement(sql)
    }

    @Test
    fun createIndexTest() {
        val sql = "CREATE INDEX test_index ON demo.orders (column_name)"

        val statement = SparkSqlHelper.parseStatement(sql)
        Assert.assertEquals(StatementType.ALTER_TABLE, statement.statementType)

        if (statement is AlterTable) {
            Assert.assertEquals(TableId("demo", "orders"), statement.tableId)
            val createIndex = statement.firstAction() as CreateIndex
            Assert.assertEquals("test_index", createIndex.indexName)
        }
    }

    @Test
    fun dropIndexTest() {
        val sql = "DROP INDEX test_index ON demo.orders"

        val statement = SparkSqlHelper.parseStatement(sql)
        Assert.assertEquals(StatementType.ALTER_TABLE, statement.statementType)

        if (statement is AlterTable) {
            Assert.assertEquals(TableId("demo", "orders"), statement.tableId)
            val dropIndex = statement.firstAction() as DropIndex
            Assert.assertEquals("test_index", dropIndex.indexName)
        }
    }

    @Test
    fun createFileViewTest() {
        val sql =
            """
            create view tdl_spark_test using csv File '/user/dataworks/users/qianxiao/demo.csv' Options( delimiter=',',header='true')
            COMPRESSION gz;
        """
                .trimIndent()

        val statement = SparkSqlHelper.parseStatement(sql)
        Assert.assertEquals(StatementType.CREATE_FILE_VIEW, statement.statementType)

        if (statement is CreateFileView) {
            Assert.assertEquals("tdl_spark_test", statement.tableId.tableName)
            Assert.assertEquals("/user/dataworks/users/qianxiao/demo.csv", statement.path)
            Assert.assertEquals("csv", statement.fileFormat)
            Assert.assertEquals("gz", statement.compression)
        }
    }

    @Test
    fun tvfTest() {
        val sql =
            """
            SELECT * FROM range(6 + cos(3));
        """
                .trimIndent()

        val statement = SparkSqlHelper.parseStatement(sql)

        if (statement is QueryStmt) {
            Assert.assertEquals(0, statement.inputTables.size)
        }
    }

    @Test
    fun cacheTest() {
        val sql =
            """
            cache lazy table fire_service_calls_tbl_cache OPTIONS ('storageLevel' 'DISK_ONLY') as 
            select * from (select * from demo.db.fire_service_calls_tbl) a
        """
                .trimIndent()

        val statement = SparkSqlHelper.parseStatement(sql)
        if (statement is CacheTable) {
            Assert.assertEquals("fire_service_calls_tbl_cache", statement.tableId.tableName)
            Assert.assertEquals(1, statement.options.size)
            Assert.assertEquals(1, statement.queryStmt?.inputTables?.size)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun uncacheTest() {
        val sql =
            """
            uncache table fire_service_calls_tbl_cache;
        """
                .trimIndent()

        val statement = SparkSqlHelper.parseStatement(sql)
        if (statement is UnCacheTable) {
            Assert.assertEquals("fire_service_calls_tbl_cache", statement.tableId.tableName)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun resourceManagerTest() {
        val sql =
            """
            ADD ARCHIVE /tmp/test.tar.gz;
            ADD ARCHIVE "/path/to/some.zip";
            ADD ARCHIVE '/some/other.tgz';
            ADD ARCHIVE "/path with space/abc.tar";
            ADD ARCHIVES "/path with space/def.tgz" '/path with space/ghi.zip';
            
            LIST JAR;
            LIST JAR /tmp/test.jar /some/random.jar /another/random.jar;
        """
                .trimIndent()

        val statements = SparkSqlHelper.parseMultiStatement(sql)
        Assert.assertEquals(7, statements.size)
        val addResource = statements.get(4) as AddResourceStatement
        Assert.assertEquals(2, addResource.fileNames.size)

        val listResource = statements.get(6) as ListResourceStatement
        Assert.assertEquals(3, listResource.fileNames.size)
    }

    @Test
    fun insertOverwriteDirTest() {
        val sql =
            """
            with test as (
                select a, b from aaa
            )
            insert overwrite directory 'hdfs://xxx' row format delimited fields terminated by '\t'
            select a, b from test
        """
                .trimIndent()

        val statement = SparkSqlHelper.parseStatement(sql)
        if (statement is InsertTable) {
            Assert.assertEquals("hdfs://xxx", statement.tableId.tableName)
            Assert.assertEquals(1, statement.queryStmt.inputTables.size)
        } else {
            Assert.fail()
        }
    }

    @Test
    fun loadDataTest() {
        val sql =
            """
            load data inpath 'hdfs:///user/xxx.txt' into table aaa.bbb partition(ds='2024-02-27');
        """
                .trimIndent()

        val statement = SparkSqlHelper.parseStatement(sql)
        if (statement is LoadData) {
            Assert.assertEquals("hdfs:///user/xxx.txt", statement.inPath)
            Assert.assertEquals("aaa.bbb", statement.tableId.getFullTableName())
        } else {
            Assert.fail()
        }
    }

    @Test
    fun distCpTest() {
        val sql =
            """
            SET SPARK.HADOOP.FS.OSS.ENDPOINT = OSS-CN-HANGZHOU.ALIYUNCS.COM;
            set spark.hadoop.fs.oss.accessKeyId = xxx;
            set spark.hadoop.fs.oss.accessKeySecret = xxxx;
            set spark.hadoop.fs.oss.attempts.maximum = 3;
            set spark.hadoop.fs.oss.connection.timeout = 10000;
            set spark.hadoop.fs.oss.connection.establish.timeout = 10000;
            set spark.hadoop.fs.oss.impl = org.apache.hadoop.fs.aliyun.oss.AliyunOSSFileSystem;
            set spark.hadoop.fs.sftp.host = "172.24.5.213"
            set spark.hadoop.fs.sftp.host.port = 22
            set spark.hadoop.fs.sftp.user.172.24.5.213 = root
            DISTCP OPTIONS (
              srcPaths = ['oss://melin1204/users'],
              destPath = "hdfs://cdh1:8020/temp",
              overwrite = true
            )
        """
                .trimIndent()

        val statements = SparkSqlHelper.parseMultiStatement(sql)
        Assert.assertEquals(11, statements.size)
    }

    @Test
    fun querySqlTest0() {
        val sql1 = FileUtils.readFileToString(File("./src/test/resources/demo.sql"), "UTF-8")
        val statement = SparkSqlHelper.parseStatement(sql1)

        if (statement is InsertTable) {
            Assert.assertEquals(StatementType.INSERT, statement.statementType)
            Assert.assertEquals(10, statement.queryStmt.inputTables.size)
            Assert.assertEquals(TableId("DWB", "DWB_FOREX_TRADE_A_D"), statement.outputTables.get(0))
        } else {
            Assert.fail()
        }
    }
}
