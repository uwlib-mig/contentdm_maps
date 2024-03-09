<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:migdd="http://www.lib.washington.edu/msd/mig/schemas/dataDictionaries"
    xmlns:migprop="http://faculty.washington.edu/tgis/schemasProject/xsd4md"
    exclude-result-prefixes="xs math" expand-text="yes" version="3.0">

    <!-- OUTPUT METHOD, CHARACTER-MAP -->
    <xsl:output method="html" html-version="5.0" indent="yes" use-character-maps="angleBrackets"/>
    <xsl:character-map name="angleBrackets">
        <xsl:output-character character="&lt;" string="&lt;"/>
        <xsl:output-character character="&gt;" string="&gt;"/>
    </xsl:character-map>

    <!-- INCLUDE uwlib-cams/webviews -->
    <xsl:include href="https://uwlib-cams.github.io/webviews/xsl/CC0-footer.xsl"/>
    <xsl:include href="https://uwlib-cams.github.io/webviews/xsl/index-backlink.xsl"/>

    <!-- GLOBAL VARS -->
    <xsl:variable name="map" select="
            (: !! CAUTION local filepath to MAP file !!  :)
            document('../../schemasProject/dataDictionaries/xml/becker.xml')"/>
    <xsl:variable name="alias" select="$map/migdd:migDataDictionary/migdd:cdmCode"/>
    
    <xsl:variable name="guidance_sections">
        <!-- move this to xml MAP, validate with lcgft.xsd?? -->
        <section>
            <lcgft>Photographs</lcgft>
            <!-- TO DO: CHECK 'no' vs '^no$|^all$' -->
            <cdm_object_type>no</cdm_object_type>
            <cdm_object_type_label>standalone items</cdm_object_type_label>
            <exclude>^p6$|^p19$|^p99$|^p50$</exclude>
        </section>
        <section>
            <lcgft>Records_(Documents)</lcgft>
            <cdm_object_type>no</cdm_object_type>
            <cdm_object_type_label>standalone items</cdm_object_type_label>
            <exclude>^p65$|^p53$</exclude>
        </section>
        <section>
            <lcgft>Newsletters</lcgft>
            <cdm_object_type>no</cdm_object_type>
            <cdm_object_type_label>standalone items</cdm_object_type_label>
            <exclude>^p65$|^p53$</exclude>
        </section>
    </xsl:variable>

    <!-- BASE TEMPLATE -->
    <xsl:template match="/">
        <xsl:result-document href="{concat('../html/', $alias, '.html')}">
            <html>
                <head>
                    <link rel="icon" type="image/png"
                        href="https://uwlib-cams.github.io/webviews/images/metadata.png"/>
                    <link href="https://uwlib-cams.github.io/webviews/css/SP2MAP.css" rel="stylesheet" type="text/css"/>
                    <title>{'MAP > ', $alias}</title>
                </head>
                <body>
                    <xsl:call-template name="top"/>
                    <xsl:call-template name="toc"/>
                    <xsl:call-template name="all-list-start">
                        <xsl:with-param name="map_props"
                            select="$map/migdd:migDataDictionary/migdd:properties"/>
                    </xsl:call-template>
                    <xsl:for-each select="$guidance_sections/section">
                        <xsl:call-template name="guidance_section_start">
                            <xsl:with-param name="map_props"
                                select="$map/migdd:migDataDictionary/migdd:properties"/>
                            <xsl:with-param name="lcgft" select="lcgft"/>
                            <xsl:with-param name="cdm_object_type_notation" select="cdm_object_type"/>
                            <xsl:with-param name="cdm_object_type_label"
                                select="cdm_object_type_label"/>
                            <xsl:with-param name="exclude" select="exclude"/>
                        </xsl:call-template>
                    </xsl:for-each>
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
                    </xsl:call-template>                </body>
            </html>
        </xsl:result-document>
    </xsl:template>

    <!-- NAMED TEMPLATES -->
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
                    <xsl:text>Combined field list</xsl:text>
                </a>
            </li>
            <xsl:for-each select="$guidance_sections/section">
                <li class="toc_li">
                    <xsl:text>Metadata-creation guidance: </xsl:text>
                    <a href="{concat('#', translate(lcgft, ' _()', ''), '-no-guidance')}">
                        {translate(lcgft, '_', ' ')}
                    </a>
                </li>
            </xsl:for-each>
        </ul>
    </xsl:template>
    <xsl:template name="all-list-start">
        <xsl:param name="map_props"/>
        <div class="title_color">
            <h2 id="all-list">{'COMBINED FIELD LIST'}</h2>
        </div>
        <table class="all_list_table center_align">
            <thead class="all_list_table_thead">
                <tr class="large_one">
                    <th scope="col">{'Field label'}</th>
                    <th scope="col">{'Field order'}</th>
                    <xsl:for-each select="$guidance_sections/section">
                        <th scope="col">{translate(lcgft, '_', ' ')}</th>
                    </xsl:for-each>
                    <th scope="col">{'Field configuration'}</th>
                </tr>
            </thead>
            <tbody class="alt_rows">
                <xsl:for-each select="$map_props/migprop:property">
                    <xsl:variable name="uid" select="migprop:uid"/>
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
                        <xsl:for-each select="$guidance_sections/section">
                            <td class="all_list_table_td">
                                <xsl:choose>
                                    <xsl:when test="not(matches($uid, exclude))">
                                        <a href="{concat('#', $uid, '-', translate(lcgft, ' _()', ''), '-no-guidance')}">{'Record values'}</a>
                                    </xsl:when>
                                    <xsl:otherwise>{'n/a'}</xsl:otherwise>
                                </xsl:choose>
                            </td>
                        </xsl:for-each>
                        <td class="all_list_table_td">
                            <a href="{concat('#', migprop:uid, '-config')}">
                                <xsl:text>{'See details'}</xsl:text>
                            </a>
                        </td>
                    </tr>
                </xsl:for-each>
            </tbody>
        </table>
        <br/>
        <xsl:call-template name="cdm_map_backlink"/>
    </xsl:template>
    <xsl:template name="guidance_section_start">
        <xsl:param name="map_props"/>
        <xsl:param name="lcgft"/>
        <xsl:param name="cdm_object_type_notation"/>
        <xsl:param name="cdm_object_type_label"/>
        <xsl:param name="exclude"/>
        <br/>
        <div class="{concat(translate($lcgft, ' _()', ''), '_color large_two')}">
            <br/>
            <h2
                id="{concat(translate($lcgft, ' _()', ''), '-', $cdm_object_type_notation, '-guidance')}"
                >
                {'METADATA CREATION FOR ', upper-case($lcgft), ' : ', upper-case($cdm_object_type_label)}
            </h2>
            <br/>
        </div>
        <xsl:call-template name="guidance_section_tables">
            <xsl:with-param name="map_props" select="$map_props"/>
            <xsl:with-param name="lcgft" select="$lcgft"/>
            <xsl:with-param name="cdm_object_type_notation" select="$cdm_object_type_notation"/>
            <xsl:with-param name="cdm_object_type_label" select="$cdm_object_type_label"/>
            <xsl:with-param name="exclude" select="$exclude"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template name="guidance_section_tables">
        <xsl:param name="map_props"/>
        <xsl:param name="lcgft"/>
        <xsl:param name="cdm_object_type_notation"/>
        <xsl:param name="cdm_object_type_label"/>
        <xsl:param name="exclude"/>
        <xsl:for-each select="$map_props/migprop:property">
            <!-- would be better to eliminate xsl:if and add exclude to XPath above -->
            <xsl:if test="not(matches(migprop:uid, $exclude))">
                <br/>
                <table class="prop_table">
                    <thead>
                        <tr>
                            <th colspan="2"
                                id="{concat(migprop:uid, '-', translate($lcgft, ' _()', ''), '-no-guidance')}"
                                class="{concat('prop_table_head', ' ', translate($lcgft, ' _()', ''), '_color')}">
                                <div class="large_two">
                                    <xsl:choose>
                                        <xsl:when test="migprop:cdm/migprop:label/text()">
                                            {translate($lcgft, '_', ' '), ' : ', migprop:cdm/migprop:label}
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
                                            [matches(@co, $cdm_object_type_notation)]
                                            [matches(@dd, $alias) or matches(@dd, '\*')]
                                            [matches(@objectType, $lcgft)]">
                                        <xsl:for-each select="
                                                migprop:descriptions/migprop:customization
                                                [matches(@co, $cdm_object_type_notation)]
                                                [matches(@dd, $alias) or matches(@dd, '\*')]
                                                [matches(@objectType, $lcgft)]
                                                /migprop:para">
                                            <li>
                                                <xsl:value-of select="."/>
                                            </li>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:for-each select="
                                                migprop:descriptions/migprop:instructions
                                                [matches(@co, $cdm_object_type_notation)]/migprop:para">
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
                                            [matches(@co, $cdm_object_type_notation)]
                                            [matches(@dd, $alias)]">
                                        <xsl:for-each select="
                                                migprop:examples/migprop:customization
                                                [matches(@co, $cdm_object_type_notation)]
                                                [matches(@dd, $alias)]/migprop:para">
                                            <li>
                                                <xsl:value-of select="."/>
                                            </li>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:for-each select="
                                                migprop:examples/migprop:example
                                                [matches(@co, $cdm_object_type_notation)]/migprop:para">
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
                                migprop:uid, '-', translate($lcgft, ' _()', ''), '-no-guidance')}">
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
                    <span class="large_two">
                        <xsl:text>CONTENTdm field settings : </xsl:text>
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

</xsl:stylesheet>
