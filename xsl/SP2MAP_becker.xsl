<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:migdd="http://www.lib.washington.edu/msd/mig/schemas/dataDictionaries"
    xmlns:migprop="http://faculty.washington.edu/tgis/schemasProject/xsd4md"
    exclude-result-prefixes="xs math"
    expand-text="yes"
    version="3.0">
    
    <!-- OUTPUT METHOD, CHARACTER-MAP -->
    <xsl:output method="html" html-version="5.0" indent="yes" use-character-maps="angleBrackets"/>
    <xsl:character-map name="angleBrackets">
        <xsl:output-character character="&lt;" string="&lt;"/>
        <xsl:output-character character="&gt;" string="&gt;"/>
    </xsl:character-map>
    
    <!-- INCLUDE cc-by-zero stylesheet > CC0 template; index-backlink stylesheet > index-backlink template from webviews -->
    <xsl:include href="https://uwlib-cams.github.io/webviews/xsl/CC0-footer.xsl"/>
    <xsl:include href="https://uwlib-cams.github.io/webviews/xsl/index-backlink.xsl"/>
    
    <!-- vars -->
    <xsl:variable name="map" select="
        (: CAUTION local file path to MAP file  :)
        document('../../schemasProject/dataDictionaries/xml/becker.xml')"/>
    <xsl:variable name="alias" select="$map/migdd:migDataDictionary/migdd:cdmCode"/>
    
    <xsl:template match="/">
        <xsl:result-document href="{concat('../html/', $alias, '.html')}">
            <html>
                <head>
                    <link rel="icon" type="image/png"
                        href="https://uwlib-cams.github.io/webviews/images/metadata.png"/>
                    <link href="https://uwlib-cams.github.io/webviews/css/schemasProject-to-map.css"
                        rel="stylesheet" type="text/css"/>
                    <title>{'MAP > ', $alias}</title>
                </head>
                <body>
                    <xsl:call-template name="top"/>
                    <xsl:call-template name="toc"/>
                    <xsl:call-template name="all-list-start">
                        <xsl:with-param name="map_props" select="$map/migdd:migDataDictionary/migdd:properties"/>
                    </xsl:call-template>
                    
                    <xsl:call-template name="CC0-footer">
                        <xsl:with-param name="resource_title">
                            <xsl:text>UWL MIG CONTENTdm Metadata Application Profile: </xsl:text>
                            <xsl:value-of
                                select="$map/migdd:migDataDictionary/migdd:ddName"/>
                            <xsl:text> - </xsl:text>
                            <xsl:value-of select="$alias"/>
                        </xsl:with-param>
                        <xsl:with-param name="org" select="'mig'"/>
                    </xsl:call-template>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template name="top">
        <h1 class="title_color" id="top">
            <xsl:text>UWL MIG CONTENTdm Metadata Application Profile</xsl:text>
            <br/>
            <xsl:text>Collection title: </xsl:text>
            <xsl:value-of select="$map/migdd:migDataDictionary/migdd:ddName"/>
            <br/>
            <xsl:text>CONTENTdm collection alias: </xsl:text>
            <xsl:value-of select="$alias"/>
        </h1>
        <div class="large_one">
            <ul>
                <li>
                    <xsl:text>Original creation date: </xsl:text>
                    <xsl:value-of
                        select="$map/migdd:migDataDictionary/migdd:originalCreationDate"/>
                </li>
                <li>
                    <xsl:text>Most recent revision: </xsl:text>
                    <xsl:value-of select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
                </li>
                <li>
                    <xsl:text>Metadata liaison(s): </xsl:text>
                    <ul>
                        <xsl:for-each
                            select="$map/migdd:migDataDictionary/migdd:metadataLiaisons/migdd:metadataLiaison">
                            <li>
                                <xsl:value-of select="."/>
                            </li>
                        </xsl:for-each>
                    </ul>
                </li>
            </ul>
        </div>
    </xsl:template>
    <xsl:template name="toc">
        <h2 id="toc" class="toc_color">
            <xsl:text>TABLE OF CONTENTS</xsl:text>
        </h2>
        <ul class="large_one bold">
            <li class="toc_li">
                <a href="#all-list">
                    <xsl:text>ALL PROPERTIES</xsl:text>
                </a>
                <xsl:text>: Combined property list</xsl:text>
            </li>
            <li class="toc_li">
                <a href="#default-standalone-guidance">
                    <xsl:text>METADATA-CREATION GUIDANCE</xsl:text>
                </a>
                <xsl:text>: Digital images (standalone objects)</xsl:text>
            </li>
            <li class="toc_li">
                <a href="#settings">
                    <xsl:text>CONTENTdm FIELD SETTINGS</xsl:text>
                </a>
                <xsl:text>: CONTENTdm field configurations for the collection</xsl:text>
            </li>
        </ul>
    </xsl:template>
    <xsl:template name="all-list-start">
        <xsl:param name="map_props"/>
        <div class="title_color">
            <h2 id="all-list">{'ORDERED FIELD LIST'}</h2>
        </div>
        <ol>
            <xsl:for-each select="$map_props/migprop:property">
                <li>
                    <span class="bold large_one">
                        <xsl:choose>
                            <xsl:when test="migprop:cdm/migprop:label/text()">
                                <xsl:value-of select="migprop:cdm/migprop:label"/>
                                <xsl:text>: </xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="migprop:labels/migprop:platformIndependent"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </span>
                    <xsl:call-template name="all-list-details">
                        <xsl:with-param name="property" select="."/>
                    </xsl:call-template>
                </li>
            </xsl:for-each>
        </ol>
        <xsl:call-template name="cdm_map_backlink"/>
    </xsl:template>
    <xsl:template name="all-list-details">
        <xsl:param name="property"/>
        <xsl:text>[ </xsl:text>
        <!-- IDs for navigation -->
        <a href="{concat('#', $property/migprop:uid, '-guidance')}">
            <xsl:text>Metadata-creation guidance</xsl:text>
        </a>
        <xsl:text> ] [ </xsl:text>
        <!-- IDs for navigation -->
        <a href="{concat('#', $property/migprop:uid, '-config')}">
            <xsl:text>CONTENTdm field configuration</xsl:text>
        </a>
        <xsl:text> ]</xsl:text>
    </xsl:template>
    
    <xsl:template name="cdm_map_backlink">
        <div class="italic right_align bold">
            <a href="#top">
                <xsl:text>MAP info</xsl:text>
            </a>
            <xsl:text> | </xsl:text>
            <a href="#toc">
                <xsl:text>TOC</xsl:text>
            </a>
            <xsl:text> | </xsl:text>
            <a href="#all-list">
                <xsl:text>PROPERTY LIST</xsl:text>
            </a>
            <br/>
            <xsl:call-template name="index-backlink">
                <xsl:with-param name="site" select="'contentdm_maps'"/>
            </xsl:call-template>
        </div>
    </xsl:template>
    
</xsl:stylesheet>