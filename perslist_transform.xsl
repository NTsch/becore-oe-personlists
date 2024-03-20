<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" version="2.0">
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="tei:reg">
        <xsl:copy-of select='.'/>
    </xsl:template>
    <xsl:template match="tei:date">
        <xsl:copy-of select='.'/>
    </xsl:template>
    <xsl:template match="tei:note">
        <xsl:copy-of select='.'/>
    </xsl:template>
    <xsl:template match="tei:person">
        <tei:person>
            <xsl:copy-of select="@*"/>
            <xsl:variable name="attrn" select="normalize-space(tei:persName/@n)"/>
            <xsl:variable name="attrkey" select="tei:persName/@key"/>
            <xsl:variable name="date" select="tei:persName/tei:date"/>
            <xsl:variable name="reg" select="tei:persName/tei:reg"/>
            <xsl:for-each select="tokenize(normalize-space(tei:persName/tei:name/text()), ', ')">
                <xsl:choose>
                    <xsl:when test="position() = 1">
                        <tei:persName>
                            <xsl:if test="$attrn != ''">
                                <xsl:attribute name="n" select="$attrn"/>
                            </xsl:if>
                            <xsl:if test="$attrkey != ''">
                                <xsl:attribute name="key" select="$attrkey"/>
                            </xsl:if>
                            <xsl:value-of select="."/>
                            <xsl:copy-of select="$date"/>
                            <xsl:copy-of select="$reg"/>
                        </tei:persName>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="matches(., '^Bürger')">
                                <tei:residence>
                                    <xsl:value-of select="."/>
                                </tei:residence>
                            </xsl:when>
                            <xsl:when
                                test="matches(., '^(Abt|Herzog|Prior|\w*[Bb]ischof|Dechant|Propst|Probst|Kardinal|Papst|König|\w*[Hh]erzog|Bürgermeister|Richter|Rat|\w*[Ss]chreiber|Pfleger)')">
                                <tei:occupation>
                                    <xsl:value-of select="."/>
                                </tei:occupation>
                            </xsl:when>
                            <xsl:when
                                test="matches(., '^(Frau|Gattin|Bruder|Schwester|Sohn|Tochter|Witwe|Vater|Mutter)')">
                                <tei:note>
                                    <xsl:attribute name="type">relation</xsl:attribute>
                                    <xsl:value-of select="."/>
                                </tei:note>
                            </xsl:when>
                            <xsl:otherwise>
                                <tei:note>
                                    <xsl:attribute name="type">misc</xsl:attribute>
                                    <xsl:value-of select="."/>
                                </tei:note>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            <xsl:apply-templates select="tei:note"/>
        </tei:person>
    </xsl:template>
</xsl:stylesheet>
