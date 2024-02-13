<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:migdd="http://www.lib.washington.edu/msd/mig/schemas/dataDictionaries"
    xmlns:migprop="http://faculty.washington.edu/tgis/schemasProject/xsd4md"
    exclude-result-prefixes="xs math" expand-text="yes" version="3.0">

    <!-- GLOBAL VARIABLES -->
    <xsl:variable name="map" select="
            (: CAUTION local file path to MAP file  :)
            document('../../schemasProject/dataDictionaries/xml/becker.xml')"/>
    <xsl:variable name="alias" select="$map/migdd:migDataDictionary/migdd:cdmCode"/>
    <xsl:variable name="image_props"
        >^p88$|^p65$|^p21$|^p23$|^p26$|^p85$|^p53$|^p28$|^p59$|^p71$|^p72$|^p73$|^p57$|^p67$|^p31$|^p77$|^p75$|^p90$|^p44$|^p11$</xsl:variable>
    <xsl:variable name="document_props"
        >^p88$|^p65$|^p21$|^p23$|^p26$|^p85$|^p28$|^p59$|^p71$|^p72$|^p73$|^p57$|^p67$|^p31$|^p77$|^p75$|^p90$|^p44$|^p11$</xsl:variable>

    <!-- OUTPUT METHOD, CHARACTER-MAP -->
    <xsl:output method="html" html-version="5.0" indent="yes" use-character-maps="angleBrackets"/>
    <xsl:character-map name="angleBrackets">
        <xsl:output-character character="&lt;" string="&lt;"/>
        <xsl:output-character character="&gt;" string="&gt;"/>
    </xsl:character-map>

    <!-- INCLUDE from webviews
        cc-by-zero stylesheet > CC0 template; 
        index-backlink stylesheet > index-backlink template -->
    <xsl:include href="https://uwlib-cams.github.io/webviews/xsl/CC0-footer.xsl"/>
    <xsl:include href="https://uwlib-cams.github.io/webviews/xsl/index-backlink.xsl"/>

    <xsl:template match="/">
        <xsl:result-document href="{concat('../html/', $alias, '.html')}">
            <html>
                <head>
                    <link rel="icon" type="image/png"
                        href="https://uwlib-cams.github.io/webviews/images/metadata.png"/>
                    <!-- to do: change back to webviews CSS -->
                    <link href="../../webviews/css/schemasProject-to-map.css" rel="stylesheet"
                        type="text/css"/>
                    <title>{'MAP > ', $alias}</title>
                </head>
                <body>
                    <xsl:call-template name="top"/>
                    <xsl:call-template name="toc"/>
                    <xsl:call-template name="all-list-start">
                        <xsl:with-param name="map_props"
                            select="$map/migdd:migDataDictionary/migdd:properties"/>
                    </xsl:call-template>
                    <xsl:call-template name="image-prop-guidance-section-start">
                        <xsl:with-param name="map_props"
                            select="$map/migdd:migDataDictionary/migdd:properties"/>
                        <!-- @resource-type changed -->
                        <xsl:with-param name="resource-type" select="'image'"/>
                        <xsl:with-param name="object-type" select="'no'"/>
                    </xsl:call-template>
                    <xsl:call-template name="document-prop-guidance-section-start">
                        <xsl:with-param name="map_props"
                            select="$map/migdd:migDataDictionary/migdd:properties"/>
                        <!-- @resource-type changed -->
                        <xsl:with-param name="resource-type" select="'document'"/>
                        <xsl:with-param name="object-type" select="'no'"/>
                    </xsl:call-template>
                    <xsl:call-template name="prop-config">
                        <xsl:with-param name="map_props"
                            select="$map/migdd:migDataDictionary/migdd:properties"/>
                        <!-- object-type param different than for above template;
                        due to different data structure for admin notes; 
                        if all resources are standalone objects should this be no|false|0? -->
                        <xsl:with-param name="object-type" select="'^yes$|^1$|^true$'"/>
                    </xsl:call-template>
                    <xsl:call-template name="CC0-footer">
                        <xsl:with-param name="resource_title">
                            <xsl:text>UWL MIG CONTENTdm Metadata Application Profile: </xsl:text>
                            <xsl:value-of select="$map/migdd:migDataDictionary/migdd:ddName"/>
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
                    <xsl:value-of select="$map/migdd:migDataDictionary/migdd:originalCreationDate"/>
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
                <a href="#image-no-guidance">
                    <xsl:text>METADATA-CREATION GUIDANCE</xsl:text>
                </a>
                <xsl:text>: Images (standalone objects)</xsl:text>
            </li>
            <li class="toc_li">
                <a href="#document-no-guidance">
                    <xsl:text>METADATA-CREATION GUIDANCE</xsl:text>
                </a>
                <xsl:text>: Documents (standalone objects)</xsl:text>
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
        <table class="all_list_table center_align">
            <thead class="all_list_table_thead">
                <tr class="large_one">
                    <th scope="col">Field label</th>
                    <th scope="col">Field order</th>
                    <th scope="col">Recording values for images</th>
                    <th scope="col">Recording values for documents</th>
                    <th scope="col">Configuration</th>
                </tr>
            </thead>
            <tbody class="alt_rows">
                <xsl:for-each select="$map_props/migprop:property">
                    <tr>
                        <th scope="row" class="all_list_table_th">
                            <xsl:choose>
                                <xsl:when test="migprop:cdm/migprop:label/text()">
                                    <xsl:value-of select="migprop:cdm/migprop:label"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of
                                        select="migprop:labels/migprop:platformIndependent"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </th>
                        <td class="all_list_table_td">{position()}</td>
                        <td class="all_list_table_td">
                            <xsl:choose>
                                <xsl:when test="matches(migprop:uid, $image_props)">
                                    <xsl:text>record values </xsl:text>
                                    <a href="{concat('#', migprop:uid, '-image-no-guidance')}">for
                                        images</a>
                                </xsl:when>
                                <xsl:otherwise>n/a</xsl:otherwise>
                            </xsl:choose>
                        </td>
                        <td class="all_list_table_td">
                            <xsl:choose>
                                <xsl:when test="matches(migprop:uid, $document_props)">
                                    <xsl:text>record values </xsl:text>
                                    <a href="{concat('#', migprop:uid, '-document-no-guidance')}"
                                        >for documents</a>
                                </xsl:when>
                                <xsl:otherwise>n/a</xsl:otherwise>
                            </xsl:choose>
                        </td>
                        <td class="all_list_table_td">
                            <a href="{concat('#', migprop:uid, '-config')}">
                                <xsl:text>configuration details</xsl:text>
                            </a>
                        </td>
                    </tr>
                </xsl:for-each>
            </tbody>
        </table>
        <br/>
        <xsl:call-template name="cdm_map_backlink"/>
    </xsl:template>
    <xsl:template name="image-prop-guidance-section-start">
        <xsl:param name="map_props"/>
        <xsl:param name="resource-type"/>
        <xsl:param name="object-type"/>
        <br/>
        <div class="{concat($resource-type, '_color large_two')}">
            <br/>
            <h2 id="{concat($resource-type, '-', $object-type, '-guidance')}">
                <xsl:text>METADATA CREATION FOR IMAGES (STANDALONE OBJECTS)</xsl:text>
            </h2>
            <br/>
        </div>
        <xsl:call-template name="image-prop-guidance-section-tables">
            <xsl:with-param name="map_props" select="$map_props"/>
            <xsl:with-param name="resource-type" select="$resource-type"/>
            <xsl:with-param name="object-type" select="'^no$|^all$'"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template name="image-prop-guidance-section-tables">
        <xsl:param name="map_props"/>
        <xsl:param name="resource-type"/>
        <xsl:param name="object-type"/>
        <xsl:for-each select="$map_props/migprop:property">
            <xsl:if test="matches(migprop:uid, $image_props)">
                <br/>
                <table class="prop_table">
                    <thead>
                        <tr>
                            <th colspan="2"
                                id="{concat(migprop:uid, '-', $resource-type, '-no-guidance')}"
                                class="{concat('prop_table_head', ' ', $resource-type, '_color')}">
                                <div class="large_one">
                                    <xsl:text>IMAGES &gt; STANDALONE OBJECTS</xsl:text>
                                </div>
                                <br/>
                                <div class="large_two">
                                    <xsl:choose>
                                        <xsl:when test="migprop:cdm/migprop:label/text()">
                                            <xsl:value-of select="migprop:cdm/migprop:label"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of
                                                select="migprop:labels/migprop:platformIndependent"
                                            />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </div>
                            </th>
                        </tr>
                    </thead>
                    <!-- TO DO: will there be conflicts due to not matching on object type (co, item, no, all, etc.) below???-->
                    <tr>
                        <th scope="row" class="right_align">
                            <xsl:text>PROPERTY DEFINITION</xsl:text>
                        </th>
                        <td>
                            <ul class="no_bullets">
                                <xsl:for-each
                                    select="migprop:descriptions/migprop:definition/migprop:para">
                                    <li>
                                        <xsl:value-of select="."/>
                                    </li>
                                </xsl:for-each>
                            </ul>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row" class="right_align">
                            <xsl:text>INSTRUCTIONS FOR RECORDING VALUES</xsl:text>
                        </th>
                        <td>
                            <br/>
                            <ul class="no_bullets">
                                <xsl:if
                                    test="matches(migprop:cdm/migprop:hidden/text(), '^yes$|^1$|^true$')">
                                    <li>
                                        <span class="italic">
                                            <xsl:text>Values entered for this property are not visible in the public interface.</xsl:text>
                                            <br/>
                                            <br/>
                                        </span>
                                    </li>
                                </xsl:if>
                                <xsl:choose>
                                    <xsl:when test="
                                            migprop:descriptions/migprop:customization
                                            [matches(@co, $object-type)]
                                            [matches(@dd, $alias)]">
                                        <xsl:for-each select="
                                                migprop:descriptions/migprop:customization
                                                [matches(@co, $object-type)]
                                                [matches(@dd, $alias)]
                                                /migprop:para">
                                            <li>
                                                <xsl:value-of select="."/>
                                            </li>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:for-each select="
                                                migprop:descriptions/migprop:instructions
                                                [matches(@co, $object-type)]/migprop:para">
                                            <li>
                                                <xsl:value-of select="."/>
                                            </li>
                                        </xsl:for-each>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </ul>
                            <br/>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row" class="right_align">
                            <xsl:text>EXAMPLE(S) OF WELL-FORMED VALUES</xsl:text>
                        </th>
                        <td>
                            <br/>
                            <ul class="no_bullets">
                                <xsl:choose>
                                    <!-- NOTE that there are other possible permutations for matching
                                customization element may match on object type but have no collection value
                                also matching here does not take into account resource type -->
                                    <xsl:when test="
                                            migprop:examples/migprop:customization
                                            [matches(@co, $object-type)]
                                            [@dd = $alias]">
                                        <xsl:for-each select="
                                                migprop:examples/migprop:customization
                                                [matches(@co, $object-type)]
                                                [@dd = $alias]/migprop:para">
                                            <li>
                                                <xsl:value-of select="."/>
                                            </li>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:for-each select="
                                                migprop:examples/migprop:example
                                                [matches(@co, $object-type)]/migprop:para">
                                            <li>
                                                <xsl:value-of select="."/>
                                            </li>
                                        </xsl:for-each>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </ul>
                            <br/>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row" class="right_align">
                            <xsl:text>SEE ALSO</xsl:text>
                        </th>
                        <td>
                            <ul class="no_bullets">
                                <li>
                                    <a href="{concat('#', migprop:uid, '-config')}">
                                        <xsl:text>CONTENTdm FIELD SETTINGS for this field</xsl:text>
                                    </a>
                                </li>
                            </ul>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" class="center_align">
                            <br/>
                            <xsl:text>RIGHT CLICK TO COPY A </xsl:text>
                            <a href="{concat(
                            'https://uwlib-mig.github.io/contentdm_maps/html/', $alias, '.html#',
                            migprop:uid, '-', $resource-type, '-no-guidance')}">
                                <xsl:text>LINK TO THESE INSTRUCTIONS</xsl:text>
                            </a>
                        </td>
                    </tr>
                </table>
                <br/>
                <div class="toc_color">
                    <xsl:call-template name="cdm_map_backlink"/>
                    <br/>
                </div>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="document-prop-guidance-section-start">
        <xsl:param name="map_props"/>
        <xsl:param name="resource-type"/>
        <xsl:param name="object-type"/>
        <br/>
        <div class="{concat($resource-type, '_color large_two')}">
            <br/>
            <h2 id="{concat($resource-type, '-', $object-type, '-guidance')}">
                <xsl:text>METADATA CREATION FOR DOCUMENTS (STANDALONE OBJECTS)</xsl:text>
            </h2>
            <br/>
        </div>
        <xsl:call-template name="document-prop-guidance-section-tables">
            <xsl:with-param name="map_props" select="$map_props"/>
            <xsl:with-param name="resource-type" select="$resource-type"/>
            <xsl:with-param name="object-type" select="'^no$|^all$'"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template name="document-prop-guidance-section-tables">
        <xsl:param name="map_props"/>
        <xsl:param name="resource-type"/>
        <xsl:param name="object-type"/>
        <xsl:for-each select="$map_props/migprop:property">
            <xsl:if test="matches(migprop:uid, $document_props)">
                <br/>
                <table class="prop_table">
                    <thead>
                        <tr>
                            <th colspan="2"
                                id="{concat(migprop:uid, '-', $resource-type, '-no-guidance')}"
                                class="{concat('prop_table_head', ' ', $resource-type, '_color')}">
                                <div class="large_one">
                                    <xsl:text>DOCUMENTS &gt; STANDALONE OBJECTS</xsl:text>
                                </div>
                                <br/>
                                <div class="large_two">
                                    <xsl:choose>
                                        <xsl:when test="migprop:cdm/migprop:label/text()">
                                            <xsl:value-of select="migprop:cdm/migprop:label"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of
                                                select="migprop:labels/migprop:platformIndependent"
                                            />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </div>
                            </th>
                        </tr>
                    </thead>
                    <!-- TO DO: will there be conflicts due to not matching on object type (co, item, no, all, etc.) below???-->
                    <tr>
                        <th scope="row" class="right_align">
                            <xsl:text>PROPERTY DEFINITION</xsl:text>
                        </th>
                        <td>
                            <ul class="no_bullets">
                                <xsl:for-each
                                    select="migprop:descriptions/migprop:definition/migprop:para">
                                    <li>
                                        <xsl:value-of select="."/>
                                    </li>
                                </xsl:for-each>
                            </ul>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row" class="right_align">
                            <xsl:text>INSTRUCTIONS FOR RECORDING VALUES</xsl:text>
                        </th>
                        <td>
                            <br/>
                            <ul class="no_bullets">
                                <xsl:if
                                    test="matches(migprop:cdm/migprop:hidden/text(), '^yes$|^1$|^true$')">
                                    <li>
                                        <span class="italic">
                                            <xsl:text>Values entered for this property are not visible in the public interface.</xsl:text>
                                            <br/>
                                            <br/>
                                        </span>
                                    </li>
                                </xsl:if>
                                <xsl:choose>
                                    <xsl:when test="
                                            migprop:descriptions/migprop:customization
                                            [matches(@co, $object-type)]
                                            [matches(@dd, $alias)]">
                                        <xsl:for-each select="
                                                migprop:descriptions/migprop:customization
                                                [matches(@co, $object-type)]
                                                [matches(@dd, $alias)]
                                                /migprop:para">
                                            <li>
                                                <xsl:value-of select="."/>
                                            </li>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:for-each select="
                                                migprop:descriptions/migprop:instructions
                                                [matches(@co, $object-type)]/migprop:para">
                                            <li>
                                                <xsl:value-of select="."/>
                                            </li>
                                        </xsl:for-each>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </ul>
                            <br/>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row" class="right_align">
                            <xsl:text>EXAMPLE(S) OF WELL-FORMED VALUES</xsl:text>
                        </th>
                        <td>
                            <br/>
                            <ul class="no_bullets">
                                <xsl:choose>
                                    <!-- NOTE that there are other possible permutations for matching
                                customization element may match on object type but have no collection value
                                also matching here does not take into account resource type -->
                                    <xsl:when test="
                                            migprop:examples/migprop:customization
                                            [matches(@co, $object-type)]
                                            [@dd = $alias]">
                                        <xsl:for-each select="
                                                migprop:examples/migprop:customization
                                                [matches(@co, $object-type)]
                                                [@dd = $alias]/migprop:para">
                                            <li>
                                                <xsl:value-of select="."/>
                                            </li>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:for-each select="
                                                migprop:examples/migprop:example
                                                [matches(@co, $object-type)]/migprop:para">
                                            <li>
                                                <xsl:value-of select="."/>
                                            </li>
                                        </xsl:for-each>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </ul>
                            <br/>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row" class="right_align">
                            <xsl:text>SEE ALSO</xsl:text>
                        </th>
                        <td>
                            <ul class="no_bullets">
                                <li>
                                    <a href="{concat('#', migprop:uid, '-config')}">
                                        <xsl:text>CONTENTdm FIELD SETTINGS for this field</xsl:text>
                                    </a>
                                </li>
                            </ul>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" class="center_align">
                            <br/>
                            <xsl:text>RIGHT CLICK TO COPY A </xsl:text>
                            <a href="{concat(
                                'https://uwlib-mig.github.io/contentdm_maps/html/', $alias, '.html#',
                                migprop:uid, '-', $resource-type, '-no-guidance')}">
                                <xsl:text>LINK TO THESE INSTRUCTIONS</xsl:text>
                            </a>
                        </td>
                    </tr>
                </table>
                <br/>
                <div class="toc_color">
                    <xsl:call-template name="cdm_map_backlink"/>
                    <br/>
                </div>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="prop-config">
        <xsl:param name="map_props"/>
        <xsl:param name="object-type"/>
        <br/>
        <div class="settings_color">
            <br/>
            <h2 id="settings">
                <xsl:text>CONTENTdm FIELD CONFIGURATION</xsl:text>
            </h2>
            <p class="italic">
                <xsl:text>Information for CONTENTdm administrators configuring </xsl:text>
                <a
                    href="https://uwlib-mig.github.io/contentdm_maps/images/cdm_edit_field_properties.jpg">
                    <xsl:text>field properties</xsl:text>
                </a>
                <xsl:text> for the collection</xsl:text>
            </p>
            <br/>
        </div>
        <xsl:for-each select="$map_props/migprop:property">
            <br/>
            <div class="settings_color">
                <br/>
                <h3 id="{concat(migprop:uid, '-config')}">
                    <span class="large_one">
                        <xsl:text>CONTENTdm SETTINGS > </xsl:text>
                    </span>
                    <span class="large_two">
                        <xsl:choose>
                            <xsl:when test="migprop:cdm/migprop:label/text()">
                                <xsl:value-of select="migprop:cdm/migprop:label"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="migprop:labels/migprop:platformIndependent"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </span>
                </h3>
                <br/>
            </div>
            <ul>
                <!-- to do: if no cdm > label value exists, provide platformIndependent
                    and indicate that property not for display in the public UI -->
                <li>
                    <span class="bold">
                        <xsl:text>FIELD NAME: </xsl:text>
                    </span>
                    <span class="italic">
                        <xsl:value-of select="migprop:cdm/migprop:label"/>
                    </span>
                </li>
                <li>
                    <span class="bold">
                        <xsl:text>DC MAP SETTING: </xsl:text>
                    </span>
                    <span class="italic">
                        <xsl:value-of select="migprop:labels/migprop:dc"/>
                    </span>
                </li>
                <li>
                    <span class="bold">
                        <xsl:text>SHOW LARGE FIELD? </xsl:text>
                    </span>
                    <span class="italic">
                        <xsl:value-of select="migprop:cdm/migprop:cdmLarge"/>
                    </span>
                </li>
                <li>
                    <span class="bold">
                        <xsl:text>SEARCHABLE? </xsl:text>
                    </span>
                    <span class="italic">
                        <xsl:value-of select="migprop:cdm/migprop:searchable"/>
                    </span>
                </li>
                <li>
                    <span class="bold">
                        <xsl:text>HIDDEN? </xsl:text>
                    </span>
                    <span class="italic">
                        <xsl:value-of select="migprop:cdm/migprop:hidden"/>
                    </span>
                </li>
                <!-- not sure how to handle required, how required works in CONTENTdm admin interface -->
                <li>
                    <span class="bold">
                        <xsl:text>'CONTROLLED-VOCABULARY' FEATURE? </xsl:text>
                    </span>
                    <span class="italic">
                        <xsl:value-of select="migprop:cdm/migprop:cdmControlledVocab"/>
                    </span>
                </li>
                <xsl:if
                    test="migprop:additionalInfo/migprop:admin[matches(@co, $object-type)]/node()">
                    <li>
                        <span class="bold">
                            <xsl:text>ADDITIONAL ADMINISTRATIVE NOTES</xsl:text>
                        </span>
                    </li>
                    <ul>
                        <xsl:for-each
                            select="migprop:additionalInfo/migprop:admin[matches(@co, $object-type)]/migprop:para">
                            <li>
                                <xsl:value-of select="."/>
                            </li>
                        </xsl:for-each>
                    </ul>
                </xsl:if>
                <!-- anything else pertinent? -->
            </ul>
            <!-- perhaps ideally call the [...]-tables-links template here to provide links 
                to all guidance for the property
                but I don't think this will work with the template as it is now -->
            <xsl:call-template name="cdm_map_backlink"/>
        </xsl:for-each>
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
