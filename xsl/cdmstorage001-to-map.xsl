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
    
    


</xsl:stylesheet>
