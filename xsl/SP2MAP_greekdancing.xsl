<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:mig="http://www.lib.washington.edu/msd/mig/schemas/dataDictionaries"
    xmlns:mig2="http://faculty.washington.edu/tgis/schemasProject/xsd4md"
    exclude-result-prefixes="xs mig mig2" version="3.0">

    <!-- INCLUDE cc-by-zero stylesheet > CC0 template; index-backlink stylesheet > index-backlink template from webviews -->
    <xsl:include href="https://uwlib-cams.github.io/webviews/xsl/CC0-footer.xsl"/>
    <xsl:include href="https://uwlib-cams.github.io/webviews/xsl/index-backlink.xsl"/>

    <!-- OUTPUT METHOD, CHARACTER-MAP -->
    <xsl:output method="html" html-version="5.0" indent="yes" use-character-maps="angleBrackets"/>
    <xsl:character-map name="angleBrackets">
        <xsl:output-character character="&lt;" string="&lt;"/>
        <xsl:output-character character="&gt;" string="&gt;"/>
    </xsl:character-map>

    <!-- variables -->
    <!-- NEED CDM ALIAS / URL WILL CHANGE FOLLOWING ASSIGNMENT OF CDM ALIAS -->
    <!-- to do add collection alias once Greek Dances collection is created in CONTENTdm -->
    <xsl:variable name="collection" select="'greekdancing'"/>
    <xsl:variable name="greekDances-dd"
        select="document('../../schemasProject/dataDictionaries/xml/greekDances-dd.xml')"/>
    <!-- use uid-list regexes in vars with fn:matches() to control prop lists per resource and object type -->
    <xsl:variable name="default-co-prop"
        select="'^p88$|^p101$|^p102$|^p103$|^p23$|^p21$|^p26$|^p104$|^p105$|^p106$|^p55$|^p111$|^p144$|^p108$|^p145$|^p128$|^p57$|^p28$|^p30$|^p90$|^p59$|^p77$|^p75$|^p71$|^p79$|^p109$|^p44$'"/>
    <xsl:variable name="default-coitem-prop"
        select="'^p88$|^p55$|^p28$|^p30$|^p90$|^p37$|^p29$|^p62$|^p31$|^p79$|^p134$'"/>

    <!-- ROOT TEMPLATE -->
    <xsl:template match="/">
        <xsl:result-document href="{concat('../html/', $collection, '.html')}">
            <html>
                <head>
                    <!-- favicon will be same for all MIG MAPs -->
                    <link rel="icon" type="image/png" href="https://uwlib-cams.github.io/webviews/images/metadata.png"/>
                    <!-- bring brief title from contentdm_maps.xml or similar -->
                    <title>HGFDC MAP</title>
                    <!-- use webviews > contentdm_maps.css -->
                    <link href="https://uwlib-cams.github.io/webviews/css/schemasProject-to-map.css"
                        rel="stylesheet" type="text/css"/>
                    <!-- future schema.org? -->
                </head>
                <body>
                    <xsl:call-template name="top"/>
                    <xsl:call-template name="toc"/>
                    <xsl:call-template name="all-list-start">
                        <xsl:with-param name="greekDances-dd"
                            select="$greekDances-dd/mig:migDataDictionary/mig:properties"/>
                    </xsl:call-template>
                    <xsl:call-template name="prop-guidance-section-start">
                        <xsl:with-param name="greekDances-dd"
                            select="$greekDances-dd/mig:migDataDictionary/mig:properties"/>
                        <xsl:with-param name="resource-type" select="'default'"/>
                        <xsl:with-param name="co-prop" select="$default-co-prop"/>
                        <xsl:with-param name="coitem-prop" select="$default-coitem-prop"/>
                    </xsl:call-template>
                    <xsl:call-template name="prop-settings">
                        <xsl:with-param name="greekDances-dd"
                            select="$greekDances-dd/mig:migDataDictionary/mig:properties"/>
                    </xsl:call-template>
                    <xsl:call-template name="CC0-footer">
                        <xsl:with-param name="resource_title">
                            <xsl:text>UWL MIG CONTENTdm Metadata Application Profile: </xsl:text>
                            <xsl:value-of select="$greekDances-dd/mig:migDataDictionary/mig:ddName"/>
                            <xsl:text> - </xsl:text>
                            <xsl:value-of select="$collection"/>
                        </xsl:with-param>
                        <xsl:with-param name="org" select="'mig'"/>
                    </xsl:call-template>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>

    <!-- NAMED TEMPLATES -->
    <xsl:template name="top">
        <h1 class="title_color" id="top">
            <xsl:text>UWL MIG CONTENTdm Metadata Application Profile:</xsl:text>
            <br/>
            <xsl:value-of select="$greekDances-dd/mig:migDataDictionary/mig:ddName"/>
            <br/>
            <!-- TO DO / NEED CDM ALIAS / -->
            <xsl:text>CONTENTdm collection alias: </xsl:text>
            <xsl:value-of select="$collection"/>
        </h1>
        <div class="large_one">
            <ul>
                <li>
                    <xsl:text>Original creation date: </xsl:text>
                    <xsl:value-of
                        select="$greekDances-dd/mig:migDataDictionary/mig:originalCreationDate"/>
                </li>
                <li>
                    <xsl:text>Most recent revision: </xsl:text>
                    <xsl:value-of select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
                </li>
                <li>
                    <xsl:text>Collection Manager(s): </xsl:text>
                    <ul>
                        <!-- pull from a contentdm_map.xml or similar file in future -->
                        <xsl:text>Mary St. Germain - &lt;a href="mailto:marys@uw.edu"&gt;marys@uw.edu&lt;/a&gt;</xsl:text>
                    </ul>
                </li>
                <li>
                    <xsl:text>Metadata liaison(s): </xsl:text>
                    <ul>
                        <xsl:for-each
                            select="$greekDances-dd/mig:migDataDictionary/mig:metadataLiaisons/mig:metadataLiaison">
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
            <li class="title_color toc_li">
                <a href="#all-list">
                    <xsl:text>ALL PROPERTIES</xsl:text>
                </a>
                <xsl:text>: Combined property list</xsl:text>
            </li>
            <li class="default_color toc_li">
                <a href="#default">
                    <xsl:text>AUDIOVISUAL RESOURCES - GREEK FOLK DANCES</xsl:text>
                </a>
                <xsl:text>: Guidance for metadata creation for compound objects and compound-object items</xsl:text>
            </li>
            <li class="settings_color toc_li">
                <a href="#settings">
                    <xsl:text>CONTENTdm FIELD SETTINGS</xsl:text>
                </a>
                <xsl:text>: Requested CONTENTdm field settings for the collection</xsl:text>
            </li>
        </ul>
    </xsl:template>
    <xsl:template name="all-list-start">
        <xsl:param name="greekDances-dd"/>
        <div class="title_color">
            <br/>
            <h2 id="all-list">
                <xsl:text>COMBINED PROPERTY LIST</xsl:text>
            </h2>
            <p class="italic">Use this order when setting fields in CONTENTdm administration</p>
            <br/>
        </div>
        <ol>
            <xsl:for-each select="$greekDances-dd/mig2:property">
                <!-- to do [?] add "link to this TOC entry", etc.? -->
                <li>
                    <span class="bold large_one">
                        <xsl:choose>
                            <xsl:when test="mig2:cdm/mig2:label/text()">
                                <xsl:value-of select="mig2:cdm/mig2:label"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="mig2:labels/mig2:platformIndependent"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </span>
                    <br/>
                    <ul>
                        <xsl:call-template name="all-list-details">
                            <xsl:with-param name="property" select="."/>
                        </xsl:call-template>
                    </ul>
                </li>
                <br/>
            </xsl:for-each>
        </ol>
        <xsl:call-template name="cdm_map_backlink"/>
    </xsl:template>
    <xsl:template name="all-list-details">
        <xsl:param name="property"/>
        <xsl:if test="matches($property/mig2:uid, $default-co-prop)">
            <li>
                <xsl:text> [</xsl:text>
                <a href="{concat('#', $property/mig2:uid, '-default-co')}">
                    <xsl:text>COMPOUND OBJECTS</xsl:text>
                </a>
                <xsl:text>] </xsl:text>
            </li>
        </xsl:if>
        <xsl:if test="matches($property/mig2:uid, $default-coitem-prop)">
            <li>
                <xsl:text> [</xsl:text>
                <a href="{concat('#', $property/mig2:uid, '-default-coitem')}">
                    <xsl:text>COMPOUND-OBJECT ITEMS</xsl:text>
                </a>
                <xsl:text>] </xsl:text>
            </li>
        </xsl:if>
        <li>
            <xsl:text> [</xsl:text>
            <a href="{concat('#', $property/mig2:uid, '-settings')}">
                <xsl:text>CONTENTdm SETTINGS</xsl:text>
            </a>
            <xsl:text>] </xsl:text>
        </li>
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
                <xsl:text>COMBINED PROPERTY LIST</xsl:text>
            </a>
            <br/>
            <a href="#default">
                <xsl:text>AUDIOVISUAL RESOURCES</xsl:text>
            </a>
            <xsl:text> | </xsl:text>
            <a href="#settings">
                <xsl:text>CONTENTdm PROPERTY SETTINGS</xsl:text>
            </a>
            <br/>
            <xsl:call-template name="index-backlink">
                <xsl:with-param name="site" select="'contentdm_maps'"/>
            </xsl:call-template>
        </div>
    </xsl:template>
    <xsl:template name="prop-guidance-section-start">
        <xsl:param name="greekDances-dd"/>
        <xsl:param name="resource-type"/>
        <xsl:param name="co-prop"/>
        <xsl:param name="coitem-prop"/>
        <xsl:variable name="heading">
            <xsl:text>AUDIOVISUAL RESOURCES</xsl:text>
        </xsl:variable>
        <br/>
        <div class="{concat($resource-type, '_color')}">
            <br/>
            <h2 id="{$resource-type}">
                <xsl:value-of select="$heading"/>
            </h2>
            <!-- to do if possible: center the two lists (table columns) on the page -->
            <table>
                <thead class="large_two">
                    <tr>
                        <th colspan="1" scope="colgroup">
                            <xsl:text>Describing compound objects</xsl:text>
                        </th>
                        <th colspan="1" scope="colgroup">
                            <xsl:text>Describing compound-object items</xsl:text>
                        </th>
                    </tr>
                </thead>
                <tr valign="top">
                    <td width="50%">
                        <ul class="no_bullets large_one">
                            <xsl:for-each
                                select="$greekDances-dd/mig2:property[matches(mig2:uid, $default-co-prop)]">
                                <li>
                                    <a href="{concat('#', mig2:uid, '-default-co')}">
                                        <xsl:choose>
                                            <xsl:when test="mig2:cdm/mig2:label/text()">
                                                <xsl:value-of select="mig2:cdm/mig2:label"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of
                                                  select="mig2:labels/mig2:platformIndependent"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </a>
                                </li>
                            </xsl:for-each>
                        </ul>
                    </td>
                    <td width="50%">
                        <ul class="no_bullets large_one">
                            <xsl:for-each
                                select="$greekDances-dd/mig2:property[matches(mig2:uid, $default-coitem-prop)]">
                                <li>
                                    <a href="{concat('#', mig2:uid, '-default-coitem')}">
                                        <xsl:choose>
                                            <xsl:when test="mig2:cdm/mig2:label/text()">
                                                <xsl:value-of select="mig2:cdm/mig2:label"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of
                                                  select="mig2:labels/mig2:platformIndependent"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </a>
                                </li>
                            </xsl:for-each>
                        </ul>
                    </td>
                </tr>
            </table>
            <br/>
            <xsl:call-template name="cdm_map_backlink"/>
            <br/>
        </div>
        <br/>
        <div class="{concat($resource-type, '_color large_two')}">
            <br/>
            <h3 id="{concat($resource-type, '-co')}">
                <xsl:value-of select="$heading"/>
                <xsl:text> > COMPOUND OBJECT PROPERTY GUIDANCE</xsl:text>
            </h3>
            <br/>
        </div>
        <xsl:call-template name="prop-guidance-section-tables">
            <xsl:with-param name="greekDances-dd" select="$greekDances-dd"/>
            <xsl:with-param name="list-per-resource-and-object-type" select="$co-prop"/>
            <xsl:with-param name="resource-type" select="$resource-type"/>
            <xsl:with-param name="object-type" select="'co'"/>
        </xsl:call-template>
        <br/>
        <div class="{concat($resource-type, '_color large_two')}">
            <br/>
            <h3 id="{concat($resource-type, '-coitem')}">
                <xsl:value-of select="$heading"/>
                <xsl:text> > COMPOUND-OBJECT ITEM PROPERTY GUIDANCE</xsl:text>
            </h3>
            <br/>
        </div>
        <xsl:call-template name="prop-guidance-section-tables">
            <xsl:with-param name="greekDances-dd" select="$greekDances-dd"/>
            <xsl:with-param name="list-per-resource-and-object-type" select="$coitem-prop"/>
            <xsl:with-param name="resource-type" select="$resource-type"/>
            <xsl:with-param name="object-type" select="'coitem'"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template name="prop-guidance-section-tables">
        <xsl:param name="greekDances-dd"/>
        <xsl:param name="list-per-resource-and-object-type"/>
        <xsl:param name="resource-type"/>
        <xsl:param name="object-type"/>
        <xsl:variable name="obj-type-in-prop-file">
            <xsl:choose>
                <xsl:when test="$object-type = 'co'">object</xsl:when>
                <xsl:when test="$object-type = 'coitem'">item</xsl:when>
                <!-- <xsl:when test="$object-type = 'standalone'">no</xsl:when> -->
            </xsl:choose>
        </xsl:variable>
        <xsl:for-each
            select="$greekDances-dd/mig2:property[matches(mig2:uid, $list-per-resource-and-object-type)]">
            <br/>
            <table class="prop_table">
                <thead>
                    <tr>
                        <th colspan="2"
                            id="{concat(mig2:uid, '-', $resource-type, '-', $object-type)}"
                            class="{concat('prop_table_head', ' ', $resource-type, '_color')}">
                            <div class="large_one">
                                <xsl:text>AUDIOVISUAL RESOURCES > </xsl:text>
                                <xsl:choose>
                                    <xsl:when test="$object-type = 'co'">
                                        <xsl:text>COMPOUND OBJECT > </xsl:text>
                                    </xsl:when>
                                    <xsl:when test="$object-type = 'coitem'">
                                        <xsl:text>COMPOUND-OBJECT ITEM > </xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise/>
                                </xsl:choose>
                            </div>
                            <br/>
                            <div class="large_two">
                                <xsl:choose>
                                    <xsl:when test="mig2:cdm/mig2:label/text()">
                                        <xsl:value-of select="mig2:cdm/mig2:label"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="mig2:labels/mig2:platformIndependent"
                                        />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </div>
                        </th>
                    </tr>
                </thead>
                <!-- to do [?] new: add UID? Or just wait until props (concepts, etc.) are published? -->
                <tr>
                    <th scope="row" class="right_align">
                        <xsl:text>PROPERTY DEFINITION</xsl:text>
                    </th>
                    <td>
                        <ul class="no_bullets">
                            <xsl:for-each select="mig2:descriptions/mig2:definition/mig2:para">
                                <li>
                                    <xsl:value-of select="."/>
                                </li>
                            </xsl:for-each>
                        </ul>
                    </td>
                </tr>
                <tr>
                    <th scope="row" class="right_align">
                        <xsl:text>INSTRUCTIONS FOR CREATING VALUES</xsl:text>
                    </th>
                    <td>
                        <br/>
                        <ul class="no_bullets">
                            <!-- NEW HERE indicate whether property is hidden in guidance section -->
                            <xsl:if test="mig2:cdm/mig2:hidden/text() = 'yes'">
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
                                        mig2:descriptions/mig2:customization
                                        [@co = $obj-type-in-prop-file]
                                        [@dd = $collection]">
                                    <xsl:for-each select="
                                            mig2:descriptions/mig2:customization
                                            [@co = $obj-type-in-prop-file]
                                            [@dd = $collection]/mig2:para">
                                        <li>
                                            <xsl:value-of select="."/>
                                        </li>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:for-each select="
                                            mig2:descriptions/mig2:instructions
                                            [@co = $obj-type-in-prop-file]/mig2:para">
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
                                <xsl:when test="
                                        mig2:examples/mig2:customization
                                        [@co = $obj-type-in-prop-file]
                                        [@dd = $collection]">
                                    <xsl:for-each select="
                                            mig2:examples/mig2:customization
                                            [@co = $obj-type-in-prop-file]
                                            [@dd = $collection]/mig2:para">
                                        <li>
                                            <xsl:value-of select="."/>
                                        </li>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:for-each select="
                                            mig2:examples/mig2:example
                                            [@co = $obj-type-in-prop-file]/mig2:para">
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
                    <td colspan="2" class="center_align">
                        <xsl:text>RIGHT CLICK TO COPY A </xsl:text>
                        <a href="{concat(
                            'https://uwlib-mig.github.io/contentdm_maps/html/', 
                            $collection, 
                            '.html#',
                            mig2:uid, 
                            '-', $resource-type,
                            '-', $object-type)}">
                            <xsl:text>LINK TO THESE INSTRUCTIONS</xsl:text>
                        </a>
                    </td>
                </tr>
            </table>
            <br/>
            <div class="toc_color">
                <xsl:call-template name="prop-guidance-section-tables-links">
                    <xsl:with-param name="property" select="."/>
                    <!-- <xsl:with-param name="resource-type" select="$resource-type"/> -->
                    <xsl:with-param name="object-type" select="$object-type"/>
                </xsl:call-template>
                <xsl:call-template name="cdm_map_backlink"/>
                <br/>
            </div>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="prop-guidance-section-tables-links">
        <xsl:param name="property"/>
        <xsl:param name="object-type"/>
        <div class="right_align">
            <br/>
            <xsl:choose>
                <xsl:when test="$object-type = 'co'">
                    <xsl:if test="matches($property/mig2:uid, $default-coitem-prop)">
                        <xsl:text>See also guidance for using </xsl:text>
                        <span class="bold large_one">
                            <xsl:choose>
                                <xsl:when test="$property/mig2:cdm/mig2:label/text()">
                                    <xsl:value-of select="$property/mig2:cdm/mig2:label"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of
                                        select="$property/mig2:labels/mig2:platformIndependent"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </span>
                        <xsl:text> with</xsl:text>
                        <xsl:text> [</xsl:text>
                        <a href="{concat('#', $property/mig2:uid, '-default-coitem')}">
                            <xsl:text>AUDIOVISUAL RESOURCES > COMPOUND-OBJECT ITEMS</xsl:text>
                        </a>
                        <xsl:text>] </xsl:text>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="$object-type = 'coitem'">
                    <xsl:if test="matches($property/mig2:uid, $default-co-prop)">
                        <xsl:text>See also guidance for using </xsl:text>
                        <span class="bold large_one">
                            <xsl:choose>
                                <xsl:when test="$property/mig2:cdm/mig2:label/text()">
                                    <xsl:value-of select="$property/mig2:cdm/mig2:label"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of
                                        select="$property/mig2:labels/mig2:platformIndependent"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </span>
                        <xsl:text> with</xsl:text>
                        <xsl:text> [</xsl:text>
                        <a href="{concat('#', $property/mig2:uid, '-default-co')}">
                            <xsl:text>AUDIOVISUAL RESOURCES > COMPOUND OBJECTS</xsl:text>
                        </a>
                        <xsl:text>] </xsl:text>
                    </xsl:if>
                </xsl:when>
            </xsl:choose>
        </div>
    </xsl:template>
    <xsl:template name="prop-settings">
        <xsl:param name="greekDances-dd"/>
        <br/>
        <div class="settings_color">
            <br/>
            <h2 id="settings">
                <xsl:text>CONTENTdm FIELD SETTINGS</xsl:text>
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
        <xsl:for-each select="$greekDances-dd/mig2:property">
            <br/>
            <div class="settings_color">
                <br/>
                <h3 id="{concat(mig2:uid, '-settings')}">
                    <span class="large_one">
                        <xsl:text>CONTENTdm SETTINGS > </xsl:text>
                    </span>
                    <span class="large_two">
                        <xsl:choose>
                            <xsl:when test="mig2:cdm/mig2:label/text()">
                                <xsl:value-of select="mig2:cdm/mig2:label"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="mig2:labels/mig2:platformIndependent"/>
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
                        <xsl:value-of select="mig2:cdm/mig2:label"/>
                    </span>
                </li>
                <li>
                    <span class="bold">
                        <xsl:text>DC MAP SETTING: </xsl:text>
                    </span>
                    <span class="italic">
                        <xsl:value-of select="mig2:labels/mig2:dc"/>
                    </span>
                </li>
                <li>
                    <span class="bold">
                        <xsl:text>SHOW LARGE FIELD? </xsl:text>
                    </span>
                    <span class="italic">
                        <xsl:value-of select="mig2:cdm/mig2:cdmLarge"/>
                    </span>
                </li>
                <li>
                    <span class="bold">
                        <xsl:text>SEARCHABLE? </xsl:text>
                    </span>
                    <span class="italic">
                        <xsl:value-of select="mig2:cdm/mig2:searchable"/>
                    </span>
                </li>
                <li>
                    <span class="bold">
                        <xsl:text>HIDDEN? </xsl:text>
                    </span>
                    <span class="italic">
                        <xsl:value-of select="mig2:cdm/mig2:hidden"/>
                    </span>
                </li>
                <!-- not sure how to handle required, how required works in CONTENTdm admin interface -->
                <li>
                    <span class="bold">
                        <xsl:text>'CONTROLLED-VOCABULARY' FEATURE? </xsl:text>
                    </span>
                    <span class="italic">
                        <xsl:value-of select="mig2:cdm/mig2:cdmControlledVocab"/>
                    </span>
                </li>
                <xsl:if
                    test="mig2:additionalInfo/mig2:admin[@co = 'all'][@dd4para = $collection]/node()">
                    <li>
                        <span class="bold">
                            <xsl:text>ADDITIONAL ADMINISTRATIVE NOTES</xsl:text>
                        </span>
                    </li>
                    <ul>
                        <xsl:for-each
                            select="mig2:additionalInfo/mig2:admin[@co = 'all'][@dd4para = $collection]/mig2:para">
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
