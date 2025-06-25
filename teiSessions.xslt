<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>

<xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'" />
<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

<xsl:template match="/">
    <DIVS>
        <xsl:for-each select="//div1[@type='trialAccount']">
            <DIV id="{@id}">
                <xsl:apply-templates/>
            </DIV>
        </xsl:for-each>
    </DIVS>
</xsl:template>

<xsl:template match="persName[@type='defendantName']">
    <!--<xsl:if test="not(ancestor::persName)"> no overlapping labels -->
        <DEFENDANT id="{@id}"><xsl:apply-templates/></DEFENDANT>
    <!--</xsl:if>-->
</xsl:template>

<xsl:template match="persName[@type='victimName']">
        <VICTIM id="{@id}"><xsl:apply-templates/></VICTIM>
</xsl:template>

<xsl:template match="rs[@type='occupation']">
        <OCCUPATION id="{@id}"><xsl:apply-templates/></OCCUPATION>
</xsl:template>

<xsl:template match="rs[@type='crimeDate']">
    <CRIMEDATE id="{@id}"><xsl:apply-templates/></CRIMEDATE>
</xsl:template>

<xsl:template match="placeName">
    <xsl:variable name="tagname">
        <xsl:choose>
            <xsl:when test="contains(./@id, 'defloc')">DEFENDANTHOME</xsl:when>
            <xsl:otherwise>CRIMELOCATION</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:element name="{$tagname}">
        <xsl:attribute name="id"><xsl:value-of select="./@id"/></xsl:attribute>
        <xsl:apply-templates/>
    </xsl:element>
</xsl:template>

<xsl:template match="rs[@type='offenceDescription']">
    <xsl:variable name="tagname">
        <xsl:choose>
            <xsl:when test="./interp[@type='offenceSubcategory'] and ./interp[@type='offenceSubcategory']/@value != 'other'">
                <xsl:value-of select="translate(./interp[@type='offenceSubcategory']/@value, $lowercase, $uppercase)"/>
            </xsl:when>
            <xsl:when test="./interp[@type='offenceCategory']">
                <xsl:value-of select="translate(./interp[@type='offenceCategory']/@value, $lowercase, $uppercase)"/>
            </xsl:when>
            <xsl:otherwise>OFFENCE</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:element name="{$tagname}">
        <xsl:attribute name="id"><xsl:value-of select="./@id"/></xsl:attribute>
        <xsl:apply-templates/>
    </xsl:element>
</xsl:template>

<xsl:template match="rs[@type='verdictDescription']">
    <xsl:if test="not(ancestor::rs)">
        <xsl:variable name="tagname">
            <xsl:choose>
                <xsl:when test="./interp[@type='verdictCategory']">
                    <xsl:value-of select="translate(./interp[@type='verdictCategory']/@value, $lowercase, $uppercase)"/>
                </xsl:when>
                <xsl:otherwise>VERDICT</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="{$tagname}">
            <xsl:attribute name="id"><xsl:value-of select="./@id"/></xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:if>
</xsl:template>

<xsl:template match="rs[@type='punishmentDescription']">
    <xsl:if test="not(ancestor::rs)">
        <xsl:variable name="tagname">
            <xsl:choose>
                <xsl:when test="./interp[@type='punishmentSubcategory'] and ./interp[@type='punishmentSubcategory']/@value != 'other'">
                    <xsl:value-of select="translate(./interp[@type='punishmentSubcategory']/@value, $lowercase, $uppercase)"/>
                </xsl:when>
                <xsl:when test="./interp[@type='punishmentCategory']">
                    <xsl:value-of select="translate(./interp[@type='punishmentCategory']/@value, $lowercase, $uppercase)"/>
                </xsl:when>
                <xsl:otherwise>PUNISHMENT</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="{$tagname}">
            <xsl:attribute name="id"><xsl:value-of select="./@id"/></xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:if>
</xsl:template>

<xsl:template match="join[@result='criminalCharge']">
    <CHARGE targets="{@targets}"/>
</xsl:template>

<xsl:template match="join[@result='persNamePlace']">
    <PERSPLACE targets="{@targets}"/>
</xsl:template>

<xsl:template match="join[@result='persNameOccupation']">
    <PERSOCC targets="{@targets}"/>
</xsl:template>

<xsl:template match="join[@result='offenceCrimeDate']">
    <OCCDATE targets="{@targets}"/>
</xsl:template>

<xsl:template match="join[@result='offenceVictim']">
    <OFFVIC targets="{@targets}"/>
</xsl:template>

<xsl:template match="join[@result='defendantPunishment']">
    <DEFPUN targets="{@targets}"/>
</xsl:template>

</xsl:stylesheet>
