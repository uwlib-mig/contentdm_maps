<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:cdmm="https://uwlib-mig.github.io/contentdm_maps/xsd/"
    xmlns:schemas="https://uwlib-mig.github.io/schemasProject/xsd/" exclude-result-prefixes="#all"
    expand-text="yes" version="3.0">
    <xsl:output method="xml" indent="yes"/>

    <!-- specify XML MAP filename in param -->
    <xsl:param name="xml_map_filename">greekdancing.xml</xsl:param>

    <xsl:variable name="ssdc_map" select="
            document(concat('../xml/', $xml_map_filename))/cdmm:xml_map"/>

    <xsl:template match="/">
        <xsl:for-each select="$ssdc_map/cdmm:properties/schemas:property">
            <xsl:element name="{concat('property-', format-number(position(), '001'))}"
                >{schemas:labels/schemas:platformIndependent, ' : ', schemas:uid}</xsl:element>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
