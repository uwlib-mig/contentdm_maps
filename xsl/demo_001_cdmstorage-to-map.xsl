<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:cdmstore="https://uwlib-mig.github.io/contentdm_storage/xsd/"
    xmlns:cdmmap="https://uwlib-mig.github.io/contentdm_maps/xsd/"
    exclude-result-prefixes="xs math cdmstore cdmmap" version="3.0">

    <!-- OUTPUT METHOD, CHARACTER-MAP -->
    <xsl:output method="html" html-version="5.0" indent="yes" use-character-maps="angleBrackets"/>
    <xsl:character-map name="angleBrackets">
        <xsl:output-character character="&lt;" string="&lt;"/>
        <xsl:output-character character="&gt;" string="&gt;"/>
    </xsl:character-map>

    <!-- INCLUDE cc-by-zero stylesheet > CC0 template from webviews -->
    <xsl:include href="https://uwlib-cams.github.io/webviews/xsl/CC0-footer.xsl"/>

    <!-- GLOBAL VARS -->
    <!-- [!] CAUTION temporary MAP base URL -->
    <xsl:variable name="map_base_url"
        select="'https://uwlib-cams.github.io/webviews/html/temp_001.html'"/>
    <xsl:param name="map_file"/>
    <xsl:variable name="map_xml" select="document(concat('../xml/', $map_file))"/>
    <xsl:variable name="alias" select="$map_xml/cdmmap:contentdm_map/cdmmap:cdm_alias"/>
    <!-- [!] CAUTION local file path to elements xml, using local data [!] -->
    <xsl:variable name="elements" select="collection('../../contentdm_storage/xml/?select=*.xml')"/>
    <xsl:variable name="uw_object_types">
        <xsl:for-each select="
                distinct-values($elements/cdmstore:uwldc_element/cdmstore:contentdm/cdmstore:implementation_set/
                cdmstore:use_for[@cdm_alias = $alias]/@uw_object_type)">
            <uw_object_type>
                <xsl:value-of select="."/>
            </uw_object_type>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="cdm_object_types">
        <xsl:for-each select="
                distinct-values($elements/cdmstore:uwldc_element/cdmstore:contentdm/cdmstore:implementation_set/
                cdmstore:use_for[@cdm_alias = $alias]/@cdm_object_type)">
            <cdm_object_type>
                <xsl:value-of select="."/>
            </cdm_object_type>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="uw_coitem_types">
        <xsl:for-each select="
                distinct-values($elements/cdmstore:uwldc_element/cdmstore:contentdm/cdmstore:implementation_set/
                cdmstore:use_for[@cdm_alias = $alias]/@uw_coitem_type)">
            <uw_coitem_type>
                <xsl:value-of select="."/>
            </uw_coitem_type>
        </xsl:for-each>
    </xsl:variable>

    <xsl:template match="/">
        <xsl:result-document href="../html/temp_001_tjls.html">
            <html>
                <head>
                    <!-- favicon, css from webviews -->
                    <link rel="icon" type="image/png"
                        href="https://uwlib-cams.github.io/webviews/images/metadata.png"/>
                    <link href="https://uwlib-cams.github.io/webviews/css/SP2MAP.css"
                        rel="stylesheet" type="text/css"/>
                    <title>
                        <xsl:value-of select="$map_xml/cdmmap:contentdm_map/cdmmap:cdm_alias"/>
                    </title>
                </head>
                <body>



                    <!-- prop_list_all -->
                    <xsl:for-each select="$elements/cdmstore:uwldc_element">
                        <div class="prop_list_heading"
                            id="{concat(cdmstore:name, '_prop_list_all')}">
                            <p>
                                <xsl:choose>
                                    <xsl:when test="
                                            cdmstore:contentdm/cdmstore:default_field_label/@customizable = 'true'
                                            and
                                            cdmstore:contentdm/cdmstore:coll_field_label[@cdm_alias = $alias]">
                                        <xsl:value-of
                                            select="cdmstore:contentdm/cdmstore:coll_field_label[@cdm_alias = $alias]"
                                        />
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of
                                            select="cdmstore:contentdm/cdmstore:default_field_label"
                                        />
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:text> / </xsl:text>
                                <span class="italic">
                                    <a href="{concat($map_base_url, '#', 
                                    cdmstore:name, '_prop_list_all')}">
                                        <xsl:text>COPY LINK TO ELEMENT LIST ENTRY FOR </xsl:text>
                                        <span class="bold">
                                            <xsl:choose>
                                                <xsl:when test="
                                                        cdmstore:contentdm/cdmstore:default_field_label/@customizable = 'true'
                                                        and
                                                        cdmstore:contentdm/cdmstore:coll_field_label[@cdm_alias = $alias]">
                                                  <xsl:value-of
                                                  select="cdmstore:contentdm/cdmstore:coll_field_label[@cdm_alias = $alias]"
                                                  />
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <xsl:value-of
                                                  select="cdmstore:contentdm/cdmstore:default_field_label"
                                                  />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </span>
                                    </a>
                                </span>
                            </p>
                        </div>
                        <xsl:call-template name="prop_list_all_details">
                            <xsl:with-param name="element" select="."/>
                        </xsl:call-template>
                    </xsl:for-each>



                    <!-- ... -->

                    <!-- CC0 footer -->
                    <xsl:call-template name="CC0-footer">
                        <xsl:with-param name="resource_title">
                            <xsl:text>UWL MIG CONTENTdm Metadata Application Profile: </xsl:text>
                            <xsl:value-of select="$map_xml/cdmmap:contentdm_map/cdmmap:coll_title"/>
                        </xsl:with-param>
                        <xsl:with-param name="org" select="'mig'"/>
                    </xsl:call-template>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>

    <xsl:template name="prop_list_all_details">
        <xsl:param name="element"/>
        <ul>
            <xsl:for-each select="$uw_object_types/uw_object_type">
                <li>
                    <xsl:text>USE WITH </xsl:text>
                    <!-- ??? HOW do I want to format these IDs for uw_object_type section headings?? -->
                    <a href="{concat('#', .)}">
                        <!-- need mechanism to pull formatted labels for object type -->
                        <xsl:value-of select="."/>
                    </a>
                </li>
                <ul>
                    <xsl:if test="
                            $element/cdmstore:contentdm/cdmstore:implementation_set
                            [cdmstore:use_for
                            [matches(@cdm_alias, $alias)]
                            [matches(@uw_object_type, .)]
                            [matches(@cdm_object_type, 'co')]
                            ]">
                        <li>
                            <xsl:text>compound objects</xsl:text>
                        </li>
                    </xsl:if>
                    <xsl:if test="
                            $element/cdmstore:contentdm/cdmstore:implementation_set
                            [cdmstore:use_for
                            [matches(@cdm_alias, $alias)]
                            [matches(@uw_object_type, .)]
                            [matches(@cdm_object_type, 'coitem')]
                            ]">
                        <xsl:for-each select="
                                $element/cdmstore:contentdm/cdmstore:implementation_set
                                /cdmstore:use_for
                                [matches(@cdm_alias, $alias)]
                                [matches(@uw_object_type, .)]
                                [matches(@cdm_object_type, 'coitem')]
                                /@uw_coitem_type">
                            <li>
                                <xsl:text>compound-object items >>></xsl:text>
                                <xsl:value-of select="."/>
                            </li>
                        </xsl:for-each>
                    </xsl:if>
                </ul>
            </xsl:for-each>
        </ul>
    </xsl:template>

    <!--
    <xsl:template match="cdmstore:definition">
        <xsl:param name="def"/>
        <ul>
            <xsl:apply-templates>
                <xsl:with-param name="def" select="$def"/>
            </xsl:apply-templates>
        </ul>
    </xsl:template>

    <xsl:template match="cdmstore:definition//*">
        <xsl:param name="def"/>
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    -->



</xsl:stylesheet>
