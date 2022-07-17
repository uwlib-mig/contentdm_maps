<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:cdmstore="https://uwlib-mig.github.io/contentdm_storage/xsd/"
    xmlns:cdmmap="https://uwlib-mig.github.io/contentdm_maps/xsd/"
    exclude-result-prefixes="xs math cdmstore cdmmap" version="3.0">
    
    <xsl:output method="xml" indent="true"/>

    <xsl:variable name="map" select="document('../xml/temp_alias_001_tjls.xml')"/>
    <!-- [!] CAUTION local file path to elements xml, using local data -->
    <xsl:variable name="elements" select="collection('../../contentdm_storage/xml/?select=*.xml')"/>
    <xsl:variable name="cdm_object_types">
        <xsl:for-each 
            select="distinct-values($elements/cdmstore:uwldc_element/cdmstore:contentdm/cdmstore:implementation_set/
            cdmstore:use_for[@cdm_alias = $map/cdmmap:contentdm_map/cdmmap:cdm_alias]/@cdm_object_type)">
            <cdm_object_type>
                <xsl:value-of select="."/>
            </cdm_object_type>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="uw_object_types">
        <xsl:for-each
            select="distinct-values($elements/cdmstore:uwldc_element/cdmstore:contentdm/cdmstore:implementation_set/
            cdmstore:use_for[@cdm_alias = $map/cdmmap:contentdm_map/cdmmap:cdm_alias]/@uw_object_type)">
            <uw_object_type>
                <xsl:value-of select="."/>
            </uw_object_type>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="uw_coitem_types">
        <xsl:for-each
            select="distinct-values($elements/cdmstore:uwldc_element/cdmstore:contentdm/cdmstore:implementation_set/
            cdmstore:use_for[@cdm_alias = $map/cdmmap:contentdm_map/cdmmap:cdm_alias]/@uw_coitem_type)">
            <uw_coitem_type>
                <xsl:value-of select="."/>
            </uw_coitem_type>
        </xsl:for-each>
    </xsl:variable>
    
    


</xsl:stylesheet>
