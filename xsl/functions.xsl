<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:cdmm="https://uwlib-mig.github.io/contentdm_maps/xsd/"
    xmlns:schemas="https://uwlib-mig.github.io/schemasProject/xsd/"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" exclude-result-prefixes="#all"
    expand-text="yes" version="3.0">
    
    
    <!-- coll_name -->
    <xsl:variable name="collection_list" select="
        unparsed-text('https://uwlib-mig.github.io/schemasProject/json/collection_list.json')
        => fn:json-to-xml()"/>
    
    <xsl:function name="cdmm:coll_name">
        <xsl:param name="coll_alias" as="xs:string"/>
        <xsl:choose>
            <xsl:when
                test="$collection_list/fn:array/fn:map[fn:string[@key = 'secondary_alias'] = $coll_alias]">
                <xsl:value-of select="
                    $collection_list/fn:array/fn:map
                    [fn:string[@key = 'secondary_alias'] = $coll_alias]/fn:string[@key = 'name']"
                />
            </xsl:when>
            <xsl:otherwise>TBD</xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- render_genre_form -->
    <xsl:function name="cdmm:render_genre_form">
        <xsl:param name="genre_form" as="xs:string"/>
        <xsl:value-of select="translate($genre_form, '_\', ' ')"/>
    </xsl:function>
    
    <!-- convert_object_type_notation -->
    <xsl:function name="cdmm:convert_object_type_notation">
        <xsl:param name="cdm_object_type"/>
        <xsl:choose>
            <xsl:when test="$cdm_object_type = 'compound_object'">object</xsl:when>
            <xsl:when test="$cdm_object_type = 'co_item'">item</xsl:when>
            <xsl:when test="$cdm_object_type = 'standalone_item'">no</xsl:when>
        </xsl:choose>
    </xsl:function>
    
    <!-- render_dc_map_options -->
    
    <!-- ... -->
    
</xsl:stylesheet>