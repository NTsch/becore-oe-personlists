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
    
    <xsl:template match="reg">
        <xsl:copy>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:person">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
        </xsl:copy>
        <tei:person>
            <xsl:variable name="attrn">
                <xsl:value-of select="normalize-space(tei:persName/@n)"/>
            </xsl:variable>
            <xsl:variable name="attrkey">
                <xsl:value-of select="tei:persName/@key"/>
            </xsl:variable>
            <xsl:for-each select="tokenize(normalize-space(tei:persName/tei:name/text()), ', ')">
                <xsl:choose>
                    <xsl:when test="position() = 1">
                        <tei:persName>
                            <xsl:attribute name="n" select="$attrn"/>
                            <xsl:if test="$attrkey != ''">
                                <xsl:attribute name="key" select="$attrkey"/>
                            </xsl:if>
                            <xsl:value-of select="."/>
                        </tei:persName>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="matches(., '^Bürger')">
                                <tei:residence>
                                    <xsl:value-of select="."/>
                                </tei:residence>
                            </xsl:when>
                            <xsl:when test="matches(., '^(Abt|Herzog|Prior|\w*[Bb]ischof|Dechant|Propst|Probst|Kardinal|Papst|König|\w*[Hh]erzog|Bürgermeister|Richter|Rat|\w*[Ss]chreiber|Pfleger)')">
                                <tei:occupation>
                                    <xsl:value-of select="."/>
                                </tei:occupation>
                            </xsl:when>
                            <xsl:when test="matches(., '^(Frau|Gattin|Bruder|Schwester|Sohn|Tochter|Witwe|Vater|Mutter)')">
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
            <xsl:apply-templates select="note"/>
        </tei:person>
    </xsl:template>
    
    <xsl:template match="note">
        <tei:note>
            <xsl:apply-templates/>
        </tei:note>
    </xsl:template>
    
</xsl:stylesheet>