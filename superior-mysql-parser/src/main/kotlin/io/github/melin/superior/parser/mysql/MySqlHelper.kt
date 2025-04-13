package com.github.melin.superior.sql.parser.mysql

import com.github.melin.superior.sql.parser.util.CommonUtils
import io.github.melin.superior.common.antlr4.AntlrCaches
import io.github.melin.superior.common.antlr4.ParseErrorListener
import io.github.melin.superior.common.antlr4.ParseException
import io.github.melin.superior.common.antlr4.UpperCaseCharStream
import io.github.melin.superior.common.relational.Statement
import io.github.melin.superior.parser.mysql.AbstractSqlParser
import io.github.melin.superior.parser.mysql.MySqlAntlr4Visitor
import io.github.melin.superior.parser.mysql.antlr4.MySqlLexer
import io.github.melin.superior.parser.mysql.antlr4.MySqlParser
import io.github.melin.superior.parser.mysql.antlr4.MySqlParserBaseVisitor
import org.antlr.v4.runtime.CharStreams
import org.antlr.v4.runtime.CommonTokenStream
import org.antlr.v4.runtime.atn.PredictionMode
import org.antlr.v4.runtime.misc.ParseCancellationException
import org.apache.commons.lang3.StringUtils

/** Created by libinsong on 2018/1/10. */
object MySqlHelper {

    @JvmStatic
    fun sqlKeywords(): List<String> {
        val keywords = hashSetOf<String>()
        (0 until MySqlLexer.VOCABULARY.maxTokenType).forEach { idx ->
            val name = MySqlLexer.VOCABULARY.getLiteralName(idx)
            if (name != null) {
                val matchResult = CommonUtils.KEYWORD_REGEX.find(name)
                if (matchResult != null) {
                    keywords.add(matchResult.groupValues.get(1))
                }
            }
        }

        return keywords.sorted()
    }

    @JvmStatic
    fun parseStatement(command: String): Statement {
        val statements = this.parseMultiStatement(command)
        if (statements.size != 1) {
            throw IllegalStateException("only parser one sql, sql count: " + statements.size)
        } else {
            return statements.get(0)
        }
    }

    @JvmStatic
    fun parseMultiStatement(command: String): List<Statement> {
        val trimCmd = StringUtils.trim(command)
        val sqlVisitor = MySqlAntlr4Visitor(false)
        innerParseStatement(trimCmd, sqlVisitor)
        return sqlVisitor.getSqlStatements()
    }

    @JvmStatic
    fun splitSql(command: String): List<String> {
        val trimCmd = StringUtils.trim(command)
        val sqlVisitor = MySqlAntlr4Visitor(true)
        innerParseStatement(trimCmd, sqlVisitor)
        return sqlVisitor.getSplitSqls()
    }

    @JvmStatic
    fun checkSqlSyntax(command: String) {
        val sqlVisitor = MySqlParserBaseVisitor<Statement>()
        innerParseStatement(command, sqlVisitor)
    }

    private fun innerParseStatement(command: String, sqlVisitor: MySqlParserBaseVisitor<Statement>) {
        val charStream = UpperCaseCharStream(CharStreams.fromString(command))
        val lexer = MySqlLexer(charStream)
        lexer.removeErrorListeners()
        lexer.addErrorListener(ParseErrorListener())

        val tokenStream = CommonTokenStream(lexer)
        val parser = MySqlParser(tokenStream)
        AbstractSqlParser.installCaches(parser)
        parser.removeErrorListeners()
        parser.addErrorListener(ParseErrorListener())

        try {
            try {
                // first, try parsing with potentially faster SLL mode
                sqlVisitor.visitSqlStatements(parser.sqlStatements())
            } catch (e: ParseCancellationException) {
                tokenStream.seek(0) // rewind input stream
                parser.reset()

                // Try Again.
                parser.interpreter.predictionMode = PredictionMode.LL
                sqlVisitor.visitSqlStatements(parser.sqlStatements())
            }
        } catch (e: ParseException) {
            if (StringUtils.isNotBlank(e.command)) {
                throw e
            } else {
                throw e.withCommand(command)
            }
        } finally {
            val releaseAntlrCache = System.getenv(AntlrCaches.RELEASE_ANTLR_CACHE_AFTER_PARSING)
            if (releaseAntlrCache == null || "true".equals(releaseAntlrCache)) {
                AbstractSqlParser.refreshParserCaches()
            }
        }
    }
}
