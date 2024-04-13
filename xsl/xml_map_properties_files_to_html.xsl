<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:cdmm="https://uwlib-mig.github.io/contentdm_maps/xsd/"
    xmlns:schemas="https://uwlib-mig.github.io/schemasProject/xsd/"
    xmlns:bmrxml="https://briesenberg07.github.io/"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" exclude-result-prefixes="#all"
    expand-text="yes" version="3.0">

    <!-- ! xml_map_filename must be supplied in CLI/transformation scenario,
         ! include file type extension -->
    <xsl:param name="xml_map_filename"/>

    <!-- GLOBAL VARS -->
    <xsl:variable name="xml_map"
        select="document(concat('../xml/', $xml_map_filename))/cdmm:xml_map"/>
    <xsl:variable name="alias" select="$xml_map/cdmm:coll_alias"/>
    <xsl:variable name="collection_list" select="
            unparsed-text('https://uwlib-mig.github.io/schemasProject/json/collection_list.json')
            => fn:json-to-xml()"/>

    <xsl:output method="html" html-version="5.0" indent="yes" use-character-maps="angleBrackets"/>

    <xsl:character-map name="angleBrackets">
        <xsl:output-character character="&lt;" string="&lt;"/>
        <xsl:output-character character="&gt;" string="&gt;"/>
    </xsl:character-map>

    <!-- INCLUDE uwlib-cams/webviews -->
    <xsl:include href="https://uwlib-cams.github.io/webviews/xsl/CC0-footer.xsl"/>
    <xsl:include href="https://uwlib-cams.github.io/webviews/xsl/index-backlink.xsl"/>

    <!-- function -->
    <xsl:function name="bmrxml:coll_name">
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

    <!-- base template -->
    <xsl:template match="/">
        <xsl:result-document href="{concat('../html/', $alias, '.html')}">
            <html>
                <head>
                    <link href="https://uwlib-cams.github.io/webviews/images/metadata.png"
                        rel="icon" type="image/png"/>
                    <!-- TO DO: replace local path to CSS with webviews URL once stable -->
                    <link href="../../webviews/css/xml_map_properties_files_to_html.css"
                        rel="stylesheet" type="text/css"/>
                    <title>{$alias, ' MAP'}</title>
                </head>
                <body>
                    <xsl:call-template name="top"/>
                    <xsl:call-template name="toc"/>
                    <xsl:call-template name="all_list"/>
                    <!--  -->
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>

    <xsl:template name="top">
        <h1 class="color_top" id="top">
            <xsl:text>UWL MIG CONTENTdm Metadata Application Profile</xsl:text>
            <br/>
            <xsl:text>Collection title: </xsl:text>
            <xsl:value-of select="bmrxml:coll_name($xml_map/cdmm:coll_alias)"/>
            <br/>
            <xsl:text>CONTENTdm collection alias: </xsl:text>
            <xsl:value-of select="$alias"/>
        </h1>
        <div class="large_1">
            <ul>
                <li>
                    <xsl:text>Created: </xsl:text>
                    <xsl:value-of select="$xml_map/cdmm:originalCreationDate"/>
                </li>
                <li>
                    <xsl:text>Last updated: </xsl:text>
                    <xsl:value-of select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
                </li>
                <xsl:for-each select="$xml_map/cdmm:related_staff">
                    <xsl:choose>
                        <xsl:when test="cdmm:metadata">
                            <li>{'Metadata staff: ', .}</li>
                        </xsl:when>
                        <xsl:when test="cdmm:project_staff">
                            <li>{'Collections/project staff: ', .}</li>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each>
            </ul>
        </div>
    </xsl:template>

    <xsl:template name="toc">
        <h2 id="toc" class="color_top">{'TABLE OF CONTENTS'}</h2>
        <ul class="large_one bold">
            <li class="toc_li">
                <a href="#all-list">{'Combined field list'}</a>
            </li>
            <xsl:for-each select="$xml_map/cdmm:map_structure/cdmm:section">
                <li class="{concat('toc_li color_', position())}">
                    <xsl:text>Metadata-creation guidance: </xsl:text>
                    <!-- for compound objects, add additional link to co-item guidance within section? -->
                    <a
                        href="{concat('#', translate(cdmm:genre_form, ' _\()', ''), '-', cdmm:cdm_object_type, '-guidance')}"
                        >
                        {translate(cdmm:genre_form, '_\', ' ')}
                    </a>
                </li>
            </xsl:for-each>
            <li class="{concat('color_', count($xml_map/cdmm:map_structure/cdmm:section) + 1)}">
                <a href="#config">Field configuration details</a>
            </li>
        </ul>
        <xsl:call-template name="cdm_map_backlink"/>
    </xsl:template>

    <xsl:template name="all_list">
        <div class="color_top">
            <h2 id="all-list">{'COMBINED PROPERTY LIST'}</h2>
            <p class="italic bold">Use this order when configuring fields for the collection</p>
            <table class="all_list_table center_align">
                <thead class="color_table_thead">
                    <tr>
                        <th scope="col">{'Field label'}</th>
                        <th scope="col">{'Field order'}</th>
                        <xsl:for-each select="$xml_map/cdmm:map_structure/cdmm:section">
                            <th scope="col">{translate(cdmm:genre_form, '_\', ' ')}</th>
                        </xsl:for-each>
                    </tr>
                </thead>
                <tbody class="color_alt_rows">
                    <xsl:for-each select="$xml_map/cdmm:properties/schemas:property">
                        <xsl:variable name="uid" select="schemas:uid"/>
                        <tr>
                            <th scope="row" class="all_list_table_th">
                                <xsl:choose>
                                    <xsl:when test="schemas:cdm/schemas:label/text()"
                                        >{schemas:cdm/schemas:label}</xsl:when>
                                    <xsl:otherwise>{schemas:labels/schemas:platformIndependent}</xsl:otherwise>
                                </xsl:choose>
                            </th>
                            <td class="all_list_table_td">{position()}</td>
                            <xsl:for-each select="$xml_map/cdmm:map_structure/cdmm:section">
                                <td class="all_list_table_td">
                                    <xsl:choose>
                                        <xsl:when
                                            test="cdmm:cdm_object_type = 'object' and cdmm:exclude_for_co">
                                            <xsl:if test="not(matches($uid, cdmm:exclude_for_co))">
                                                <a href="{concat('#', $uid, '-',translate(cdmm:genre_form, ' _()\', ''),
                                                        '-', cdmm:cdm_object_type, '-guidance')}">{'Record values - CO'}</a>
                                                <br/>
                                            </xsl:if>
                                            <xsl:if test="matches($uid, cdmm:include_for_co_items)">
                                                <a href="{concat('#', $uid, '-',translate(cdmm:genre_form, ' _()\', ''),
                                                    '-coitem-guidance')}">{'Record values - CO-item'}</a>
                                            </xsl:if>
                                            <xsl:if test="matches($uid, cdmm:exclude_for_co) and not(matches($uid, cdmm:include_for_co_items))">{'n/a'}</xsl:if>
                                        </xsl:when>
                                        <xsl:when
                                            test="cdmm:cdm_object_type = 'object' and not(cdmm:exclude_for_co)">
                                            <a href="{concat('#', $uid, '-',translate(cdmm:genre_form, ' _()\', ''),
                                                '-', cdmm:cdm_object_type, '-guidance')}">{'Record values - CO'}</a>
                                            <br/>
                                            <xsl:if test="matches($uid, cdmm:include_for_co_items)">
                                                <a href="{concat('#', $uid, '-',translate(cdmm:genre_form, ' _()\', ''),
                                                    '-coitem-guidance')}">{'Record values - CO-item'}</a>
                                            </xsl:if>
                                        </xsl:when>
                                        <xsl:when test="cdmm:cdm_object_type = 'no' and cdmm:exclude_for_genre_form">
                                            <xsl:if test="not(matches($uid, cdmm:exclude_for_genre_form))">
                                                <a href="{concat('#', $uid, '-',translate(cdmm:genre_form, ' _()\', ''),
                                                    '-', cdmm:cdm_object_type, '-guidance')}">{'Record values'}</a>
                                                <br/>
                                            </xsl:if>
                                            <xsl:if test="matches($uid, cdmm:exclude_for_genre_form)">{'n/a'}</xsl:if>
                                        </xsl:when>
                                        <xsl:when test="cdmm:cdm_object_type = 'no' and not(cdmm:exclude_for_genre_form)">
                                            <a href="{concat('#', $uid, '-',translate(cdmm:genre_form, ' _()\', ''),
                                                '-', cdmm:cdm_object_type, '-guidance')}">{'Record values'}</a>
                                            <br/>
                                        </xsl:when>
                                    </xsl:choose>
                                </td>
                            </xsl:for-each>
                        </tr>
                    </xsl:for-each>
                </tbody>
                <!-- ... -->
            </table>
        </div>
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
