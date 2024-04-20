<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:cdmm="https://uwlib-mig.github.io/contentdm_maps/xsd/"
    xmlns:schemas="https://uwlib-mig.github.io/schemasProject/xsd/"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" exclude-result-prefixes="#all"
    expand-text="yes" version="3.0">

    <xsl:output method="html" html-version="5.0" indent="yes" use-character-maps="angleBrackets"/>
    <xsl:character-map name="angleBrackets">
        <xsl:output-character character="&lt;" string="&lt;"/>
        <xsl:output-character character="&gt;" string="&gt;"/>
    </xsl:character-map>

    <!-- ! xml_map_filename must be supplied in CLI/transformation scenario,
         ! include file type extension -->
    <xsl:param name="xml_map_filename"/>

    <!-- global vars -->
    <xsl:variable name="xml_map"
        select="document(concat('../xml/', $xml_map_filename))/cdmm:xml_map"/>
    <xsl:variable name="alias" select="$xml_map/cdmm:coll_alias"/>

    <!-- include  -->
    <xsl:include href="functions.xsl"/>
    <xsl:include href="https://uwlib-cams.github.io/webviews/xsl/CC0-footer.xsl"/>
    <xsl:include href="https://uwlib-cams.github.io/webviews/xsl/index-backlink.xsl"/>

    <!-- base template -->
    <xsl:template match="/">
        <xsl:result-document href="{concat('../html/', $alias, '.html')}">
            <html>
                <head>
                    <link href="https://uwlib-cams.github.io/webviews/images/metadata.png"
                        rel="icon" type="image/png"/>
                    <link href="https://uwlib-cams.github.io/webviews/css/xml_map_properties_files_to_html.css"
                        rel="stylesheet" type="text/css"/>
                    <title>{$alias, ' MAP'}</title>
                </head>
                <body>
                    <xsl:call-template name="top"/>
                    <xsl:call-template name="toc"/>
                    <xsl:call-template name="all_list"/>
                    <xsl:for-each select="$xml_map/cdmm:map_structure/cdmm:section">
                        <xsl:call-template name="guidance_section_start">
                            <xsl:with-param name="position" select="fn:position()"/>
                            <xsl:with-param name="section">
                                <xsl:copy-of select="."/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:for-each>
                    <xsl:call-template name="config_details_section"/>
                    <xsl:call-template name="CC0-footer">
                        <xsl:with-param name="resource_title">
                            <xsl:text>UWL MIG CONTENTdm Metadata Application Profile: </xsl:text>
                            <xsl:value-of select="cdmm:coll_name($alias)"/>
                            <xsl:text> - </xsl:text>
                            <xsl:value-of select="$alias"/>
                        </xsl:with-param>
                        <xsl:with-param name="org" select="'mig'"/>
                    </xsl:call-template>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>

    <!-- named templates -->
    <xsl:template name="top">
        <div class="color_default">
            <h1 id="top">
                <xsl:text>UWL MIG CONTENTdm Metadata Application Profile</xsl:text>
                <br/>
                <xsl:text>Collection title: </xsl:text>
                <xsl:value-of select="cdmm:coll_name($xml_map/cdmm:coll_alias)"/>
                <br/>
                <xsl:text>CONTENTdm collection alias: </xsl:text>
                <xsl:value-of select="$alias"/>
            </h1>
        </div>
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
        <div class="color_default">
            <h2 id="toc">{'Table of contents'}</h2>
        </div>
        <ul class="large_one bold">
            <li class="toc_li">
                <a href="#all-list">{'Combined field list'}</a>
            </li>
            <xsl:for-each select="$xml_map/cdmm:map_structure/cdmm:section">
                <li class="{concat('toc_li color_', position())}">
                    <xsl:text>Metadata-creation guidance: </xsl:text>
                    <!-- for compound objects, add additional link to co-item guidance within section? -->
                    <a
                        href="{concat('#', translate(cdmm:genre_form, '\', ''), '-', cdmm:cdm_object_type, '-guidance')}"
                        >
                        {cdmm:render_genre_form(cdmm:genre_form)}
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
        <div class="color_default">
            <h2 id="all-list">{'Combined property list'}</h2>
            <p class="italic bold">Use this order when configuring fields for the collection</p>
            <p class="bold">KEY</p>
            <ul>
                <li><span class="bold"
                    >Record values</span>: Metadata-greation guidance for standalone items</li>
                <li><span class="bold"
                    >Record values - CO</span>: Metadata-greation guidance for compound objects</li>
                <li><span class="bold"
                    >Record values - CO-item</span>: Metadata-greation guidance for compound-object items</li>
                <li>For collections including only one category of resource, 'default' may be used in place of a genre/form term.</li>
            </ul>
            <p>For further information about compound objects and compound-object items, refer to &lt;a href="https://help.oclc.org/Metadata_Services/CONTENTdm/Compound_objects"&gt;Compound objects&lt;/a&gt;.</p>
            <table class="all_list_table center_align">
                <thead class="color_table_thead">
                    <tr>
                        <th scope="col">{'Field label'}</th>
                        <th scope="col">{'Field order'}</th>
                        <xsl:for-each select="$xml_map/cdmm:map_structure/cdmm:section">
                            <th scope="col">{cdmm:render_genre_form(cdmm:genre_form)}</th>
                        </xsl:for-each>
                        <th scope="col">{'Field configuration'}</th>
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
                                            test="cdmm:cdm_object_type = 'compound_object' and cdmm:exclude_for_co">
                                            <xsl:if test="not(matches($uid, cdmm:exclude_for_co))">
                                                <a
                                                  href="{concat('#', $uid, '-', translate(cdmm:genre_form, '\', ''),
                                                        '-', cdmm:cdm_object_type, '-guidance')}"
                                                  >{'Record values - CO'}</a>
                                                <br/>
                                            </xsl:if>
                                            <xsl:if test="matches($uid, cdmm:include_for_co_items)">
                                                <a
                                                  href="{concat('#', $uid, '-', translate(cdmm:genre_form, '\', ''), '-co_item-guidance')}"
                                                  >{'Record values - CO-item'}</a>
                                            </xsl:if>
                                            <xsl:if
                                                test="matches($uid, cdmm:exclude_for_co) and not(matches($uid, cdmm:include_for_co_items))"
                                                >{'n/a'}</xsl:if>
                                        </xsl:when>
                                        <xsl:when
                                            test="cdmm:cdm_object_type = 'compound_object' and not(cdmm:exclude_for_co)">
                                            <a
                                                href="{concat('#', $uid, '-', translate(cdmm:genre_form, '\', ''), '-', cdmm:cdm_object_type, '-guidance')}"
                                                >{'Record values - CO'}</a>
                                            <br/>
                                            <xsl:if test="matches($uid, cdmm:include_for_co_items)">
                                                <a
                                                  href="{concat('#', $uid, '-', translate(cdmm:genre_form, '\', ''), '-co_item-guidance')}"
                                                  >{'Record values - CO-item'}</a>
                                            </xsl:if>
                                        </xsl:when>
                                        <xsl:when
                                            test="cdmm:cdm_object_type = 'standalone_item' and cdmm:exclude_for_genre_form">
                                            <xsl:if
                                                test="not(matches($uid, cdmm:exclude_for_genre_form))">
                                                <a
                                                  href="{concat('#', $uid, '-',translate(cdmm:genre_form, '\', ''), '-', cdmm:cdm_object_type, '-guidance')}"
                                                  >{'Record values'}</a>
                                                <br/>
                                            </xsl:if>
                                            <xsl:if
                                                test="matches($uid, cdmm:exclude_for_genre_form)"
                                                >{'n/a'}</xsl:if>
                                        </xsl:when>
                                        <xsl:when
                                            test="cdmm:cdm_object_type = 'standalone_item' and not(cdmm:exclude_for_genre_form)">
                                            <a
                                                href="{concat('#', $uid, '-', translate(cdmm:genre_form, '\', ''), '-', cdmm:cdm_object_type, '-guidance')}"
                                                >{'Record values'}</a>
                                            <br/>
                                        </xsl:when>
                                    </xsl:choose>
                                </td>
                            </xsl:for-each>
                            <td class="all_list_table_td">
                                <a href="{concat('#', $uid, '-config')}">{'See details'}</a>
                            </td>
                        </tr>
                    </xsl:for-each>
                </tbody>
            </table>
        </div>
        <xsl:call-template name="cdm_map_backlink"/>
    </xsl:template>
    <xsl:template name="cdm_map_backlink">
        <div class="italic right_align bold color_default">
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
    <xsl:template name="guidance_section_start">
        <xsl:param name="position"/>
        <xsl:param name="section"/>
        <div class="{concat('color_', $position)}">
            <h2 id="{concat($section/cdmm:section/cdmm:genre_form, '-', 
                $section/cdmm:section/cdmm:cdm_object_type, '-guidance')}">
                <xsl:text>Metadata creation guidance: </xsl:text>
                <xsl:value-of select="cdmm:render_genre_form($section/cdmm:section/cdmm:genre_form)"/>
                <xsl:text> > </xsl:text>
                <xsl:choose>
                    <xsl:when test="$section/cdmm:section/cdmm:cdm_object_type = 'compound_object'"
                        >{'Compound objects and compound-object items'}</xsl:when>
                    <xsl:when test="$section/cdmm:section/cdmm:cdm_object_type = 'standalone_item'"
                        >{'Standalone items'}</xsl:when>
                </xsl:choose>
            </h2>
        </div>
        <xsl:choose>
            <xsl:when test="$section/cdmm:section/cdmm:cdm_object_type = 'compound_object'">
                <h3 class="color_default"
                    >{cdmm:render_genre_form($section/cdmm:section/cdmm:genre_form), ' > Compound objects'}</h3>
                <xsl:choose>
                    <xsl:when test="$section/cdmm:section/cdmm:exclude_for_co">
                        <xsl:call-template name="property_guidance_tables">
                            <xsl:with-param name="position" select="$position"/>
                            <xsl:with-param name="section" select="$section"/>
                            <xsl:with-param name="properties" select="
                                    $xml_map/cdmm:properties/schemas:property
                                    [not(matches(schemas:uid, $section/cdmm:section/cdmm:exclude_for_co))]"/>
                            <xsl:with-param name="cdm_object_type"
                                select="$section/cdmm:section/cdmm:cdm_object_type"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="property_guidance_tables">
                            <xsl:with-param name="position" select="$position"/>
                            <xsl:with-param name="section" select="$section"/>
                            <xsl:with-param name="properties"
                                select="$xml_map/cdmm:properties/schemas:property"/>
                            <xsl:with-param name="cdm_object_type"
                                select="$section/cdmm:section/cdmm:cdm_object_type"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
                <h3 class="color_default"
                    >{cdmm:render_genre_form($section/cdmm:section/cdmm:genre_form), ' > Compound-object items'}</h3>
                <xsl:call-template name="property_guidance_tables">
                    <xsl:with-param name="position" select="$position"/>
                    <xsl:with-param name="section" select="$section"/>
                    <xsl:with-param name="properties" select="
                            $xml_map/cdmm:properties/schemas:property
                            [matches(schemas:uid, $section/cdmm:section/cdmm:include_for_co_items)]"/>
                    <xsl:with-param name="cdm_object_type" select="'co_item'"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$section/cdmm:section/cdmm:cdm_object_type = 'standalone_item'">
                <xsl:choose>
                    <xsl:when test="$section/cdmm:section/cdmm:exclude_for_genre_form">
                        <xsl:call-template name="property_guidance_tables">
                            <xsl:with-param name="position" select="$position"/>
                            <xsl:with-param name="section" select="$section"/>
                            <xsl:with-param name="properties" select="
                                    $xml_map/cdmm:properties/schemas:property
                                    [not(matches(schemas:uid, $section/cdmm:section/cdmm:exclude_for_genre_form))]"/>
                            <xsl:with-param name="cdm_object_type"
                                select="$section/cdmm:section/cdmm:cdm_object_type"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="property_guidance_tables">
                            <xsl:with-param name="position" select="$position"/>
                            <xsl:with-param name="section" select="$section"/>
                            <xsl:with-param name="properties" select="
                                    $xml_map/cdmm:properties/schemas:property"/>
                            <xsl:with-param name="cdm_object_type"
                                select="$section/cdmm:section/cdmm:cdm_object_type"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>{'ERROR: xml_map/map_structure/section/cdm_object_type value not allowed'}</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="property_guidance_tables">
        <xsl:param name="position"/>
        <xsl:param name="section"/>
        <xsl:param name="properties"/>
        <xsl:param name="cdm_object_type"/>
        <xsl:for-each select="$properties">
            <table class="prop_table">
                <thead>
                    <tr>
                        <th colspan="2"
                            id="{concat(schemas:uid, '-', translate($section/cdmm:section/cdmm:genre_form, '\', ''),
                            '-', $cdm_object_type, '-guidance')}"
                            class="{concat('prop_table_head color_', $position)}">
                            <div class="large_2">
                                {cdmm:render_genre_form($section/cdmm:section/cdmm:genre_form), ' > '}
                                <xsl:choose>
                                    <xsl:when test="$cdm_object_type != 'co_item'"
                                        >{concat(translate($cdm_object_type, '_', ' '), 's: ')}</xsl:when>
                                    <xsl:when test="$cdm_object_type = 'co_item'"
                                        >{'compound-object items: '}</xsl:when>
                                    <xsl:otherwise>ERROR: param $cdm_object_type / xml_map/map_structure/section/cdm_object_type value</xsl:otherwise>
                                </xsl:choose>
                                <xsl:choose>
                                    <xsl:when test="schemas:cdm/schemas:label"
                                        >{schemas:cdm/schemas:label}</xsl:when>
                                    <xsl:otherwise>{schemas:labels/schemas:platformIndependent}</xsl:otherwise>
                                </xsl:choose>
                            </div>
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <th scope="row" class="right_align">{'Property definition'}</th>
                        <td>
                            <ul class="no_bullets">
                                <xsl:for-each
                                    select="schemas:descriptions/schemas:definition/schemas:para">
                                    <li>{.}</li>
                                </xsl:for-each>
                            </ul>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row" class="right_align">{'Recording values'}</th>
                        <td>
                            <ul class="no_bullets">
                                <xsl:if
                                    test="matches(schemas:cdm/schemas:hidden, '^yes$|^1$|^true$')">
                                    <li>
                                        <span class="italic"
                                            >{'Values entered for this property are not visible in the public interface.'}</span>
                                        <br/>
                                        <br/>
                                    </li>
                                </xsl:if>
                                <xsl:choose>
                                    <!-- match custom guidance -->
                                    <xsl:when test="
                                            schemas:descriptions/schemas:customization
                                            [contains(@dd, $alias) or contains(@dd, '*')]">
                                        <xsl:choose>
                                            <!-- if @co @dd @genre_form use-->
                                            <xsl:when test="
                                                schemas:descriptions/schemas:customization
                                                [contains(@co, cdmm:convert_object_type_notation($cdm_object_type)) or
                                                contains(@co, 'all')]
                                                [contains(@dd, $alias) or contains(@dd, '*')]
                                                [contains(@genre_form, $section/cdmm:section/cdmm:genre_form)]">
                                                <xsl:for-each select="
                                                    schemas:descriptions/schemas:customization
                                                    [contains(@co, cdmm:convert_object_type_notation($cdm_object_type)) or
                                                    contains(@co, 'all')]
                                                    [contains(@dd, $alias) or contains(@dd, '*')]
                                                    [contains(@genre_form, $section/cdmm:section/cdmm:genre_form)]
                                                    /schemas:para">
                                                    <li>{.}</li>
                                                </xsl:for-each>
                                            </xsl:when>
                                            <!-- else if @co and @dd use -->
                                            <xsl:when test="
                                                schemas:descriptions/schemas:customization
                                                [contains(@co, cdmm:convert_object_type_notation($cdm_object_type)) or
                                                contains(@co, 'all')]
                                                [contains(@dd, $alias) or contains(@dd, '*')]">
                                                <xsl:for-each select="
                                                    schemas:descriptions/schemas:customization
                                                    [contains(@co, cdmm:convert_object_type_notation($cdm_object_type)) or
                                                    contains(@co, 'all')]
                                                    [contains(@dd, $alias) or contains(@dd, '*')]
                                                    /schemas:para">
                                                    <li>{.}</li>
                                                </xsl:for-each>
                                            </xsl:when>
                                            <!-- else if @dd use -->
                                            <xsl:otherwise>
                                                <xsl:for-each select="
                                                    schemas:descriptions/schemas:customization
                                                    [contains(@dd, $alias) or contains(@dd, '*')]
                                                    /schemas:para">
                                                    <li>{.}</li>
                                                </xsl:for-each>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <!-- match default guidance on @co -->
                                        <xsl:for-each select="
                                                schemas:descriptions/schemas:instructions
                                                [contains(@co, cdmm:convert_object_type_notation($cdm_object_type)) or
                                                contains(@co, 'all')]
                                                /schemas:para">
                                            <li>{.}</li>
                                        </xsl:for-each>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </ul>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row" class="right_align">{'Examples / well-formed values'}</th>
                        <td>
                            <ul class="no_bullets">
                                <xsl:choose>
                                    <!-- match custom examples -->
                                    <xsl:when test="
                                            schemas:examples/schemas:customization
                                            [contains(@dd, $alias) or contains(@dd, '*')]">
                                        <!-- if @co @dd @genre_form use -->
                                        <xsl:choose>
                                            <xsl:when test="
                                                schemas:examples/schemas:customization
                                                [contains(@co, cdmm:convert_object_type_notation($cdm_object_type)) or
                                                contains(@co, 'all')]
                                                [contains(@dd, $alias) or contains(@dd, '*')]
                                                [contains(@genre_form, $section/cdmm:section/cdmm:genre_form)]">
                                                <xsl:for-each select="
                                                    schemas:examples/schemas:customization
                                                    [contains(@co, cdmm:convert_object_type_notation($cdm_object_type)) or
                                                    contains(@co, 'all')]
                                                    [contains(@dd, $alias) or contains(@dd, '*')]
                                                    [contains(@genre_form, $section/cdmm:section/cdmm:genre_form)]
                                                    /schemas:para">
                                                    <li>{.}</li>
                                                </xsl:for-each>
                                            </xsl:when>
                                            <!-- else if @co and @dd use -->
                                            <xsl:when test="
                                                schemas:examples/schemas:customization
                                                [contains(@co, cdmm:convert_object_type_notation($cdm_object_type)) or
                                                contains(@co, 'all')]
                                                [contains(@dd, $alias) or contains(@dd, '*')]">
                                                <xsl:for-each select="
                                                    schemas:examples/schemas:customization
                                                    [contains(@co, cdmm:convert_object_type_notation($cdm_object_type)) or
                                                    contains(@co, 'all')]
                                                    [contains(@dd, $alias) or contains(@dd, '*')]
                                                    /schemas:para">
                                                    <li>{.}</li>
                                                </xsl:for-each>
                                            </xsl:when>
                                            <!-- else if @dd use -->
                                            <xsl:otherwise>
                                                <xsl:for-each select="
                                                    schemas:examples/schemas:customization
                                                    [contains(@dd, $alias) or contains(@dd, '*')]
                                                    /schemas:para">
                                                    <li>{.}</li>
                                                </xsl:for-each>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <!-- match default examples on @co -->
                                        <xsl:for-each select="
                                                schemas:examples/schemas:example
                                                [contains(@co, cdmm:convert_object_type_notation($cdm_object_type)) or
                                                contains(@co, 'all')]
                                                /schemas:para">
                                            <li>{.}</li>
                                        </xsl:for-each>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </ul>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row" class="right_align">{'See also'}</th>
                        <td>
                            <ul class="no_bullets">
                                <li>
                                    <a href="{concat('#', schemas:uid, '-config')}"
                                        >{'Field configuration and further information'}</a>
                                </li>
                            </ul>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row" class="right_align">{'Shareable link'}</th>
                        <td>
                            <ul class="no_bullets">
                                <li>
                                    <a
                                        href="{concat('https://uwlib-mig.github.io/contentdm_maps/html/', $alias, '.html#', schemas:uid, '-', translate($section/cdmm:section/cdmm:genre_form, '\', ''),
                                    '-', $cdm_object_type, '-guidance')}"
                                        >{'Right-click to copy URL for these instructions'}</a>
                                </li>
                            </ul>
                        </td>
                    </tr>
                </tbody>
            </table>
            <xsl:call-template name="cdm_map_backlink"/>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="config_details_section">
        <!-- TO DO add Field order number value (1, 2, 3, ...) to details -->
        <div class="color_default">
            <h2 id="config">Field configuration details and further information</h2>
            <p class="italic">Information for CONTENTdm administrators and additional details.</p>
        </div>
        <xsl:for-each select="$xml_map/cdmm:properties/schemas:property">
            <h3 id="{concat(schemas:uid, '-config')}" class="prop_table_head color_default">
                <div class="large_2">
                    <xsl:text>Metadata field configuration: </xsl:text>
                    <xsl:choose>
                        <xsl:when test="schemas:cdm/schemas:label"
                            >{schemas:cdm/schemas:label}</xsl:when>
                        <xsl:otherwise>{schemas:labels/schemas:platformIndependent}</xsl:otherwise>
                    </xsl:choose>
                </div>
            </h3>
            <ul class="no_bullets">
                <span class="large_1">
                    <li>
                        <span class="bold">{'Field label'}</span>
                        <xsl:text> : </xsl:text>
                        <xsl:choose>
                            <xsl:when test="schemas:cdm/schemas:label"
                                >{schemas:cdm/schemas:label}</xsl:when>
                            <xsl:otherwise>{schemas:labels/schemas:platformIndependent}</xsl:otherwise>
                        </xsl:choose>
                        <br/>
                        <br/>
                    </li>
                </span>
                <li>
                    <span class="bold">{'CONTENTdm setting ''DC map'''}</span>
                    <xsl:text> : </xsl:text>
                    <span class="italic">
                        <xsl:value-of select="
                            translate(cdmm:get_dcmap_config(schemas:labels/schemas:dc), '_', ' ')"/>
                    </span>
                </li>
                <li>
                    <span class="bold">{'CONTENTdm setting ''Show large field'''}</span>
                    <xsl:text> : </xsl:text>
                    <span class="italic">{schemas:cdm/schemas:cdmLarge}</span>
                </li>
                <li>
                    <span class="bold">{'CONTENTdm setting ''Searchable'''}</span>
                    <xsl:text> : </xsl:text>
                    <span class="italic">{schemas:cdm/schemas:searchable}</span>
                </li>
                <li>
                    <span class="bold">{'CONTENTdm setting ''Hidden'''}</span>
                    <xsl:text> : </xsl:text>
                    <span class="italic">{schemas:cdm/schemas:hidden}</span>
                </li>
                <li>
                    <!-- unsure about the quality of data, and 
                        whether properties-files element 'cdmRequired' means what I think it means... -->
                    <span class="bold">{'CONTENTdm setting ''Required'''}</span>
                    <xsl:text> : </xsl:text>
                    <span class="italic">{schemas:cdm/schemas:cdmRequired}</span>
                </li>
                <li>
                    <!-- 1. incomplete data in schemasProject/properties-files
                                        2. additional options for configuration are not reflected in schemasProject/properties-files,
                                        so not reflected in HTML MAPs -->
                    <span class="bold">{'CONTENTdm setting ''Controlled vocabulary'''}</span>
                    <xsl:text> : </xsl:text>
                    <span class="italic">
                        <xsl:choose>
                            <xsl:when
                                test="upper-case(schemas:cdm/schemas:cdmControlledVocab) = 'YES'"
                                >
                                                {schemas:cdm/schemas:cdmControlledVocab}</xsl:when>
                            <xsl:otherwise>{'no'}</xsl:otherwise>
                        </xsl:choose>
                    </span>
                </li>
            </ul>
            <div class="center_align">
                <p>
                    <xsl:text>Source data for field '</xsl:text>
                    <a href="{concat('https://github.com/uwlib-mig/schemasProject/blob/main/properties-files/',
                        schemas:labels/schemas:platformIndependent, '.xml')}">{schemas:labels/schemas:platformIndependent}</a>
                    <xsl:text>' | </xsl:text>
                    <xsl:value-of select="schemas:uid"/>
                </p>
            </div>
            <xsl:call-template name="cdm_map_backlink"/>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
