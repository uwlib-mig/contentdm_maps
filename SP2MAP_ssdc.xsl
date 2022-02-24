<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:mig="http://www.lib.washington.edu/msd/mig/schemas/dataDictionaries"
    xmlns:mig2="http://faculty.washington.edu/tgis/schemasProject/xsd4md"
    exclude-result-prefixes="xs mig mig2" version="3.0">

    <!-- see NOTES at bottom of stylesheet -->

    <!-- INCLUDE webviews > cc-by-zero stylesheet for CC0 template -->
    <xsl:include
        href="https://uwlib-cams.github.io/webviews/xslt/CC0-footer.xsl"/>

    <!-- OUTPUT METHOD, CHARACTER-MAP -->
    <xsl:output method="html" html-version="5.0" indent="yes" use-character-maps="angleBrackets"/>
    <xsl:character-map name="angleBrackets">
        <xsl:output-character character="&lt;" string="&lt;"/>
        <xsl:output-character character="&gt;" string="&gt;"/>
    </xsl:character-map>

    <!-- VARIABLES -->
    <xsl:variable name="collection" select="'p16786coll3'"/>
    <!-- Beware local filepath used to access property list in ssdc-combined-map variable below -->
    <!-- using single source doc here, will need to change when creating one transform to output multiple MAPs -->
    <xsl:variable name="ssdc-combined-map" select="
            document('../schemasProject/dataDictionaries/xml/ssdc-combined-map.xml')"/>
    <!-- use uid-list regexes in vars with fn:matches() to control prop lists per resource and object type -->
    <xsl:variable name="na-standalone-prop"
        select="'^p88$|^p130$|^p116$|^p117$|^p118$|^p45$|^p131$|^p132$|^p138$|^p139$|^p47$|^p140$|^p6$|^p114$|^p119$|^p120$|^p121$|^p122$|^p115$|^p125$|^p126$|^p127$|^p23$|^p21$|^p26$|^p46$|^p55$|^p85$|^p128$|^p124$|^p57$|^p141$|^p133$|^p136$|^p137$|^p53$|^p98$|^p135$|^p142$|^p50$|^p28$|^p123$|^p75$|^p77$|^p59$|^p90$|^p37$|^p29$|^p62$|^p67$|^p143$|^p31$|^p11$|^p79$|^p134$|^p80$'"/>
    <xsl:variable name="text-co-prop"
        select="'^p88$$|^p116$|^p117$|^p118$|^p6$|^p114$|^p119$|^p120$|^p121$|^p122$|^p115$|^p125$|^p126$|^p127$|^p23$|^p21$|^p26$|^p55$|^p85$|^p128$|^p124$|^p57$|^p133$|^p50$|^p28$|^p123$|^p75$|^p77$|^p59$|^p90$|^p67$|^p31$|^p11$|^p79$'"/>
    <xsl:variable name="text-coitem-prop"
        select="'^p88$|^p28$|^p90$|^p29$|^p134$'"/>
    <xsl:variable name="song-co-prop"
        select="'^p88|^p130$|^p132$|^p138$|^p139$|^p125$|^p126$|^p127$|^p23$|^p21$|^p26$|^p55$|^p128$|^p57$|^p141$|^p133$|^p142$|^p50$|^p28$|^p123$|^p75$|^p77$|^p59$|^p90$|^p11$|^p79$'"/>
    <xsl:variable name="song-coitem-prop"
        select="'^p88$|^p28$|^p90$|^p37$|^p29$|^p62$|^p67$|^p143$|^p31$|^p134$'"/>
    <xsl:variable name="oh-co-prop"
        select="'^p88$|^p45$|^p131$|^p47$|^p140$|^p125$|^p126$|^p127$|^p23$|^p21$|^p26$|^p46$|^p55$|^p85$|^p128$|^p57$|^p136$|^p137$|^p53$|^p98$|^p135$|^p142$|^p50$|^p28$|^p123$|^p75$|^p77$|^p59$|^p90$|^p11$|^p79$'"/>
    <xsl:variable name="oh-coitem-prop"
        select="'^p88$|^p28$|^p90$|^p37$|^p29$|^p62$|^p67$|^p143$|^p31$|^p134$'"/>

    <!-- ROOT TEMPLATE -->
    <xsl:template match="/">
        <html>
            <head>
                <!-- favicon will be same for all MIG MAPs -->
                <link rel="icon" type="image/png" href="images/Metadata.png"/>
                <!-- bring brief title from contentdm_maps.xml or similar -->
                <title>SSDC MAP</title>
                <!-- use webviews > contentdm_maps.css -->
                <link href="https://uwlib-cams.github.io/webviews/css/contentdm_maps.css" rel="stylesheet" type="text/css"/>
                <!-- future schema.org? -->
            </head>
            <body>
                <xsl:call-template name="top"/>
                <xsl:call-template name="toc"/>
                <!-- combined prop list -->
                <xsl:call-template name="all-list-start">
                    <xsl:with-param name="ssdc-combined-map"
                        select="$ssdc-combined-map/mig:migDataDictionary/mig:properties"/>
                </xsl:call-template>
                <!-- text -->
                <xsl:call-template name="prop-guidance-section-start">
                    <xsl:with-param name="ssdc-combined-map"
                        select="$ssdc-combined-map/mig:migDataDictionary/mig:properties"/>
                    <xsl:with-param name="resource-type" select="'text'"/>
                    <xsl:with-param name="co-prop" select="$text-co-prop"/>
                    <xsl:with-param name="coitem-prop" select="$text-coitem-prop"/>
                </xsl:call-template>
                <!-- song -->
                <xsl:call-template name="prop-guidance-section-start">
                    <xsl:with-param name="ssdc-combined-map"
                        select="$ssdc-combined-map/mig:migDataDictionary/mig:properties"/>
                    <xsl:with-param name="resource-type" select="'song'"/>
                    <xsl:with-param name="co-prop" select="$song-co-prop"/>
                    <xsl:with-param name="coitem-prop" select="$song-coitem-prop"/>
                </xsl:call-template>
                <!-- oh -->
                <xsl:call-template name="prop-guidance-section-start">
                    <xsl:with-param name="ssdc-combined-map"
                        select="$ssdc-combined-map/mig:migDataDictionary/mig:properties"/>
                    <xsl:with-param name="resource-type" select="'oh'"/>
                    <xsl:with-param name="co-prop" select="$oh-co-prop"/>
                    <xsl:with-param name="coitem-prop" select="$oh-coitem-prop"/>
                </xsl:call-template>
                <!-- standalone -->
                <xsl:call-template name="prop-guidance-section-start">
                    <xsl:with-param name="ssdc-combined-map"
                        select="$ssdc-combined-map/mig:migDataDictionary/mig:properties"/>
                    <xsl:with-param name="resource-type" select="'na/standalone'"/>
                    <xsl:with-param name="co-prop" select="'na/standalone'"/>
                    <xsl:with-param name="coitem-prop" select="'na/standalone'"/>
                </xsl:call-template>
                <!-- settings -->
                <xsl:call-template name="prop-settings">
                    <xsl:with-param name="ssdc-combined-map"
                        select="$ssdc-combined-map/mig:migDataDictionary/mig:properties"/>
                </xsl:call-template>
                <!-- license -->
                <xsl:call-template name="CC0-footer">
                    <xsl:with-param name="resource_title">
                        <xsl:text>UWL MIG CONTENTdm Metadata Application Profile: </xsl:text>
                        <xsl:value-of select="$ssdc-combined-map/mig:migDataDictionary/mig:ddName"/>
                        <xsl:text> - </xsl:text>
                        <xsl:value-of select="$collection"/>
                    </xsl:with-param>
                    <xsl:with-param name="org" select="'mig'"/>
                </xsl:call-template>
            </body>
        </html>
    </xsl:template>

    <!-- NAMED TEMPLATES -->
    <xsl:template name="top">
        <h1 class="title_color" id="top">
            <xsl:text>UWL MIG CONTENTdm Metadata Application Profile:</xsl:text>
            <br/>
            <xsl:value-of select="$ssdc-combined-map/mig:migDataDictionary/mig:ddName"/>
            <br/>
            <xsl:value-of select="$collection"/>
        </h1>
        <!-- link to the collection front page might be nice -->
        <div class="large_one">
            <ul>
                <li>
                    <xsl:text>Original creation date: </xsl:text>
                    <xsl:value-of
                        select="$ssdc-combined-map/mig:migDataDictionary/mig:originalCreationDate"/>
                </li>
                <li>
                    <xsl:text>Most recent revision: </xsl:text>
                    <xsl:value-of select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
                </li>
                <li>
                    <xsl:text>Collection Manager: </xsl:text>
                    <ul>
                        <xsl:text>Makena Mezistrano - &lt;a href="mailto:makflo@uw.edu"&gt;makflo@uw.edu&lt;/a&gt;</xsl:text>
                    </ul>
                </li>
                <li>
                    <xsl:text>Metadata liaison(s): </xsl:text>
                    <ul>
                        <xsl:for-each
                            select="$ssdc-combined-map/mig:migDataDictionary/mig:metadataLiaisons/mig:metadataLiaison">
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
            <li class="text_color toc_li">
                <a href="#text">
                    <xsl:text>TEXTUAL RESOURCES</xsl:text>
                </a>
                <xsl:text>: Guidance for metadata creation for compound objects and compound-object items</xsl:text>
            </li>
            <li class="song_color toc_li">
                <a href="#song">
                    <xsl:text>BALLADS</xsl:text>
                </a>
                <xsl:text>: Guidance for metadata creation for compound objects and compound-object items</xsl:text>
            </li>
            <li class="oh_color toc_li">
                <a href="#oh">
                    <xsl:text>ORAL HISTORIES</xsl:text>
                </a>
                <xsl:text>: Guidance for metadata creation for compound objects and compound-object items</xsl:text>
            </li>
            <li class="standalone_color toc_li">
                <a href="#standalone">
                    <xsl:text>STANDALONE OBJECTS</xsl:text>
                </a>
                <xsl:text>: DRAFT guidance for use of properties with standalone objects</xsl:text>
            </li>
            <li class="settings_color toc_li">
                <a href="#settings">
                    <xsl:text>CONTENTdm FIELD SETTINGS</xsl:text>
                </a>
                <xsl:text>: Requested CONTENTdm field settings for the collection</xsl:text>
            </li>
        </ul>
    </xsl:template>
    <xsl:template name="cdm_map_backlink">
        <div class="italic right_align bold title_color">
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
            <a href="#text">
                <xsl:text>TEXTUAL RESOURCES</xsl:text>
            </a>
            <xsl:text> | </xsl:text>
            <a href="#song">
                <xsl:text>BALLADS</xsl:text>
            </a>
            <xsl:text> | </xsl:text>
            <a href="#oh">
                <xsl:text>ORAL HISTORIES</xsl:text>
            </a>
            <br/>
            <a href="#standalone">
                <xsl:text>STANDALONE OBJECTS</xsl:text>
            </a>
            <xsl:text> | </xsl:text>
            <a href="#settings">
                <xsl:text>CONTENTdm PROPERTY SETTINGS</xsl:text>
            </a>
            <br/>
        </div>
    </xsl:template>
    <xsl:template name="all-list-start">
        <!-- could really be combined with all-list-details -->
        <xsl:param name="ssdc-combined-map"/>
        <div class="title_color">
            <br/>
            <h2 id="all-list">
                <xsl:text>COMBINED PROPERTY LIST</xsl:text>
            </h2>
            <p class="italic">Use this order when setting fields in CONTENTdm administration</p>
            <br/>
        </div>
        <ol>
            <xsl:for-each select="$ssdc-combined-map/mig2:property">
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
        <!-- Links to guidance for text co and coitem -->
        <xsl:if test="matches($property/mig2:uid, $text-co-prop)">
            <li>
                <xsl:text> [</xsl:text>
                <a href="{concat('#', $property/mig2:uid, '-text-co')}">
                    <xsl:text>TEXTUAL RESOURCES > COMPOUND OBJECTS</xsl:text>
                </a>
                <xsl:text>] </xsl:text>
            </li>
        </xsl:if>
        <xsl:if test="matches($property/mig2:uid, $text-coitem-prop)">
            <li>
                <xsl:text> [</xsl:text>
                <a href="{concat('#', $property/mig2:uid, '-text-coitem')}">
                    <xsl:text>TEXTUAL RESOURCES > COMPOUND-OBJECT ITEMS</xsl:text>
                </a>
                <xsl:text>] </xsl:text>
            </li>
        </xsl:if>
        <!-- Links to guidance for song co and coitem -->
        <xsl:if test="matches($property/mig2:uid, $song-co-prop)">
            <li>
                <xsl:text> [</xsl:text>
                <a href="{concat('#', $property/mig2:uid, '-song-co')}">
                    <xsl:text>BALLADS > COMPOUND OBJECTS</xsl:text>
                </a>
                <xsl:text>] </xsl:text>
            </li>
        </xsl:if>
        <xsl:if test="matches($property/mig2:uid, $song-coitem-prop)">
            <li>
                <xsl:text> [</xsl:text>
                <a href="{concat('#', $property/mig2:uid, '-song-coitem')}">
                    <xsl:text>BALLADS > COMPOUND-OBJECT ITEMS</xsl:text>
                </a>
                <xsl:text>] </xsl:text>
            </li>
        </xsl:if>
        <!-- Links to guidance for oh co and coitem -->
        <xsl:if test="matches($property/mig2:uid, $oh-co-prop)">
            <li>
                <xsl:text> [</xsl:text>
                <a href="{concat('#', $property/mig2:uid, '-oh-co')}">
                    <xsl:text>ORAL HISTORIES > COMPOUND OBJECTS</xsl:text>
                </a>
                <xsl:text>] </xsl:text>
            </li>
        </xsl:if>
        <xsl:if test="matches($property/mig2:uid, $oh-coitem-prop)">
            <li>
                <xsl:text> [</xsl:text>
                <a href="{concat('#', $property/mig2:uid, '-oh-coitem')}">
                    <xsl:text>ORAL HISTORIES > COMPOUND-OBJECT ITEMS</xsl:text>
                </a>
                <xsl:text>] </xsl:text>
            </li>
        </xsl:if>
        <li>
            <xsl:text> [</xsl:text>
            <a href="{concat('#', $property/mig2:uid, '-standalone')}">
                <xsl:text>STANDALONE OBJECTS</xsl:text>
            </a>
            <xsl:text>] </xsl:text>
        </li>
        <li>
            <xsl:text> [</xsl:text>
            <a href="{concat('#', $property/mig2:uid, '-settings')}">
                <xsl:text>CONTENTdm SETTINGS</xsl:text>
            </a>
            <xsl:text>] </xsl:text>
        </li>
    </xsl:template>
    <xsl:template name="prop-guidance-section-start">
        <xsl:param name="ssdc-combined-map"/>
        <xsl:param name="resource-type"/>
        <xsl:param name="co-prop"/>
        <xsl:param name="coitem-prop"/>
        <xsl:variable name="heading">
            <xsl:choose>
                <xsl:when test="$resource-type = 'text'">
                    <xsl:text>TEXTUAL RESOURCES</xsl:text>
                </xsl:when>
                <xsl:when test="$resource-type = 'song'">
                    <xsl:text>BALLADS</xsl:text>
                </xsl:when>
                <xsl:when test="$resource-type = 'oh'">
                    <xsl:text>ORAL HISTORIES</xsl:text>
                </xsl:when>
                <xsl:when test="$resource-type = 'na/standalone'">
                    <xsl:text>STANDALONE OBJECTS</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>!ERROR GENERATING HEADING FOR THE GIVEN RESOURCE TYPE!</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <br/>
        <xsl:choose>
            <xsl:when test="$resource-type != 'na/standalone'">
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
                                    <xsl:choose>
                                        <xsl:when test="$resource-type = 'text'">
                                            <xsl:for-each
                                                select="$ssdc-combined-map/mig2:property[matches(mig2:uid, $text-co-prop)]">
                                                <li>
                                                  <a href="{concat('#', mig2:uid, '-text-co')}">
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
                                        </xsl:when>
                                        <xsl:when test="$resource-type = 'song'">
                                            <xsl:for-each
                                                select="$ssdc-combined-map/mig2:property[matches(mig2:uid, $song-co-prop)]">
                                                <li>
                                                  <a href="{concat('#', mig2:uid, '-song-co')}">
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
                                        </xsl:when>
                                        <xsl:when test="$resource-type = 'oh'">
                                            <xsl:for-each
                                                select="$ssdc-combined-map/mig2:property[matches(mig2:uid, $oh-co-prop)]">
                                                <li>
                                                  <a href="{concat('#', mig2:uid, '-oh-co')}">
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
                                        </xsl:when>
                                        <xsl:otherwise>!ERROR GENERATING PROPERTY LIST FOR THE GIVEN
                                            RESOURCE AND OBJECT TYPES!</xsl:otherwise>
                                    </xsl:choose>
                                </ul>
                            </td>
                            <td width="50%">
                                <ul class="no_bullets large_one">
                                    <xsl:choose>
                                        <xsl:when test="$resource-type = 'text'">
                                            <xsl:for-each
                                                select="$ssdc-combined-map/mig2:property[matches(mig2:uid, $text-coitem-prop)]">
                                                <li>
                                                  <a href="{concat('#', mig2:uid, '-text-coitem')}">
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
                                        </xsl:when>
                                        <xsl:when test="$resource-type = 'song'">
                                            <xsl:for-each
                                                select="$ssdc-combined-map/mig2:property[matches(mig2:uid, $song-coitem-prop)]">
                                                <li>
                                                  <a href="{concat('#', mig2:uid, '-song-coitem')}">
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
                                        </xsl:when>
                                        <xsl:when test="$resource-type = 'oh'">
                                            <xsl:for-each
                                                select="$ssdc-combined-map/mig2:property[matches(mig2:uid, $oh-coitem-prop)]">
                                                <li>
                                                  <a href="{concat('#', mig2:uid, '-oh-coitem')}">
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
                                        </xsl:when>
                                        <xsl:otherwise>!ERROR GENERATING PROPERTY LIST FOR THE GIVEN
                                            RESOURCE AND OBJECT TYPES!</xsl:otherwise>
                                    </xsl:choose>
                                </ul>
                            </td>
                        </tr>
                    </table>
                    <br/>
                    <xsl:call-template name="cdm_map_backlink"/>
                    <br/>
                </div>
                <br/>
            </xsl:when>
            <xsl:when test="$resource-type = 'na/standalone'">
                <div class="standalone_color">
                    <br/>
                    <h2 id="standalone">
                        <xsl:value-of select="$heading"/>
                    </h2>
                    <p>
                        <span class="italic bold large_one">DRAFT guidance for using SSDC MAP
                            properties with standalone objects</span>
                    </p>
                    <br/>
                </div>
                <br/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>!ERROR GENERATING SUBHEADING FOR THE GIVEN RESOURCE TYPE!</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="$resource-type != 'na/standalone'">
                <div class="{concat($resource-type, '_color large_two')}">
                    <br/>
                    <h3 id="{concat($resource-type, '-co')}">
                        <xsl:value-of select="$heading"/>
                        <xsl:text> > COMPOUND OBJECT PROPERTY GUIDANCE</xsl:text>
                    </h3>
                    <br/>
                </div>
                <xsl:call-template name="prop-guidance-section-tables">
                    <xsl:with-param name="ssdc-combined-map" select="$ssdc-combined-map"/>
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
                    <xsl:with-param name="ssdc-combined-map" select="$ssdc-combined-map"/>
                    <xsl:with-param name="list-per-resource-and-object-type" select="$coitem-prop"/>
                    <xsl:with-param name="resource-type" select="$resource-type"/>
                    <xsl:with-param name="object-type" select="'coitem'"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$resource-type = 'na/standalone'">
                <xsl:call-template name="prop-guidance-section-tables">
                    <xsl:with-param name="ssdc-combined-map" select="$ssdc-combined-map"/>
                    <!-- the list-per-resource-and-object-type for standalones is all props -->
                    <xsl:with-param name="list-per-resource-and-object-type"
                        select="$na-standalone-prop"/>
                    <xsl:with-param name="resource-type" select="'na/standalone'"/>
                    <xsl:with-param name="object-type" select="'standalone'"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>!ERROR GENERATING PROPERTY TABLES FOR THE GIVEN RESOURCE TYPE!</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="prop-guidance-section-tables">
        <xsl:param name="ssdc-combined-map"/>
        <xsl:param name="list-per-resource-and-object-type"/>
        <xsl:param name="resource-type"/>
        <xsl:param name="object-type"/>
        <xsl:variable name="obj-type-in-prop-file">
            <xsl:choose>
                <xsl:when test="$object-type = 'co'">object</xsl:when>
                <xsl:when test="$object-type = 'coitem'">item</xsl:when>
                <xsl:when test="$object-type = 'standalone'">no</xsl:when>
            </xsl:choose>
        </xsl:variable>
        <!-- at one point, after some seemingly inconsequential changes, 
            the XPath in the for-each below kicked out an error message that I didn't understand...
            reverted changes... -->
        <xsl:for-each
            select="$ssdc-combined-map/mig2:property[matches(mig2:uid, $list-per-resource-and-object-type)]">
            <br/>
            <table class="prop_table">
                <thead>
                    <tr>
                        <xsl:choose>
                            <xsl:when test="$resource-type != 'na/standalone'">
                                <th colspan="2"
                                    id="{concat(mig2:uid, '-', $resource-type, '-', $object-type)}"
                                    class="{concat('prop_table_head', ' ', $resource-type, '_color')}">
                                    <div class="large_one">
                                        <xsl:choose>
                                            <xsl:when test="$resource-type = 'text'">
                                                <xsl:text>TEXTUAL RESOURCES > </xsl:text>
                                            </xsl:when>
                                            <xsl:when test="$resource-type = 'song'">
                                                <xsl:text>BALLADS > </xsl:text>
                                            </xsl:when>
                                            <xsl:when test="$resource-type = 'oh'">
                                                <xsl:text>ORAL HISTORIES > </xsl:text>
                                            </xsl:when>
                                            <xsl:otherwise/>
                                        </xsl:choose>
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
                                                <xsl:value-of
                                                  select="mig2:labels/mig2:platformIndependent"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </div>
                                </th>
                            </xsl:when>
                            <xsl:when test="$resource-type = 'na/standalone'">
                                <th colspan="2" id="{concat(mig2:uid, '-', $object-type)}"
                                    class="{concat('prop_table_head', ' ', $object-type, '_color')}">
                                    <div class="large_one">
                                        <xsl:text>STANDALONE OBJECT > </xsl:text>
                                    </div>
                                    <br/>
                                    <div class="large_two">
                                        <xsl:choose>
                                            <xsl:when test="mig2:cdm/mig2:label/text()">
                                                <xsl:value-of select="mig2:cdm/mig2:label"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of
                                                  select="mig2:labels/mig2:platformIndependent"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </div>
                                </th>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>!ERROR GENERATING PROPERTY GUIDANCE TABLE FOR THE GIVEN RESOURCE TYPE!</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </tr>
                </thead>
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
                            <!-- BMR QUESTION why for-each here?? -->
                            <xsl:for-each select=".">
                                <xsl:choose>
                                    <xsl:when test="$resource-type != 'na/standalone'">
                                        <xsl:choose>
                                            <xsl:when test="
                                                    mig2:descriptions/mig2:customization
                                                    [@co = $obj-type-in-prop-file]
                                                    [@dd = $collection][matches(@resourceType, $resource-type)]/node()">
                                                <xsl:for-each select="
                                                        mig2:descriptions/mig2:customization
                                                        [@co = $obj-type-in-prop-file]
                                                        [@dd = $collection][matches(@resourceType, $resource-type)]/mig2:para">
                                                  <li>
                                                  <xsl:value-of select="."/>
                                                  </li>
                                                </xsl:for-each>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:for-each
                                                  select="mig2:descriptions/mig2:instructions[@co = $obj-type-in-prop-file]/mig2:para">
                                                  <li>
                                                  <xsl:value-of select="."/>
                                                  </li>
                                                </xsl:for-each>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                    <xsl:when test="$resource-type = 'na/standalone'">
                                        <xsl:choose>
                                            <xsl:when test="
                                                    mig2:descriptions/mig2:customization
                                                    [@co = $obj-type-in-prop-file][@dd = $collection]/node()">
                                                <xsl:for-each select="
                                                        mig2:descriptions/mig2:customization
                                                        [@co = $obj-type-in-prop-file][@dd = $collection]/mig2:para">
                                                  <li>
                                                  <xsl:value-of select="."/>
                                                  </li>
                                                </xsl:for-each>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:for-each
                                                  select="mig2:descriptions/mig2:instructions[@co = $obj-type-in-prop-file]/mig2:para">
                                                  <li>
                                                  <xsl:value-of select="."/>
                                                  </li>
                                                </xsl:for-each>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:text>!ERROR GENERATING PROPERTY INSTRUCTIONS FOR THE GIVEN RESOURCE TYPE!</xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </ul>
                        <br/>
                    </td>
                </tr>
                <tr>
                    <th scope="row" class="right_align">EXAMPLE(S) OF WELL-FORMED VALUES</th>
                    <td>
                        <br/>
                        <ul class="no_bullets">
                            <!-- BMR QUESTION why for-each here?? -->
                            <xsl:for-each select=".">
                                <xsl:choose>
                                    <!-- XPath here won't retrieve custom examples for using props with standalone
                                        to do is fix this -->
                                    <xsl:when test="
                                            mig2:examples/mig2:customization
                                            [@co = $obj-type-in-prop-file]
                                            [@dd = $collection][matches(@resourceType, $resource-type)]/node()">
                                        <xsl:for-each select="
                                                mig2:examples/mig2:customization
                                                [@co = $obj-type-in-prop-file]
                                                [@dd = $collection][matches(@resourceType, $resource-type)]/mig2:para">
                                            <li>
                                                <xsl:value-of select="."/>
                                            </li>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:for-each
                                            select="mig2:examples/mig2:example[@co = $obj-type-in-prop-file]/mig2:para">
                                            <li>
                                                <xsl:value-of select="."/>
                                            </li>
                                        </xsl:for-each>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </ul>
                        <br/>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" class="center_align">
                        <xsl:text>RIGHT-CLICK TO COPY A </xsl:text>
                        <xsl:choose>
                            <!-- !TO DO HREF CONSTRUCTION WILL NEED TO CHANGE 
                                WHEN MAP IS PUBLISHED ELSEWHERE! -->
                            <xsl:when test="$resource-type != 'na/standalone'">
                                <a
                                    href="{concat('https://uwlib-mig.github.io/contentdm_maps/p16786coll3.html#', mig2:uid, '-', $resource-type, '-', $object-type)}">
                                    <xsl:text>LINK TO THESE INSTRUCTIONS</xsl:text>
                                </a>
                            </xsl:when>
                            <xsl:when test="$resource-type = 'na/standalone'">
                                <a
                                    href="{concat('https://uwlib-mig.github.io/contentdm_maps/p16786coll3.html#', mig2:uid, '-standalone')}">
                                    <xsl:text>LINK TO THESE INSTRUCTIONS</xsl:text>
                                </a>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>!ERROR GENERATING CLICKABLE LINK FOR GIVEN RESOURCE TYPE!</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </td>
                </tr>
            </table>
            <div class="toc_color">
                <xsl:call-template name="prop-guidance-section-tables-links">
                    <xsl:with-param name="property" select="."/>
                    <xsl:with-param name="resource-type" select="$resource-type"/>
                    <xsl:with-param name="object-type" select="$object-type"/>
                </xsl:call-template>
                <xsl:call-template name="cdm_map_backlink"/>
                <br/>
            </div>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="prop-guidance-section-tables-links">
        <xsl:param name="property"/>
        <xsl:param name="resource-type"/>
        <xsl:param name="object-type"/>
        <!-- need to exclude the current set of instructions -->
        <div class="italic right_align">
            <br/>
            <xsl:if test="$resource-type != 'na/standalone'">
                <xsl:text>Guidance for using </xsl:text>
                <span class="bold large_one">
                    <xsl:choose>
                        <xsl:when test="$property/mig2:cdm/mig2:label/text()">
                            <xsl:value-of select="$property/mig2:cdm/mig2:label"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$property/mig2:labels/mig2:platformIndependent"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </span>
                <xsl:text> with </xsl:text>
                <!-- Links to guidance for text co and coitem -->
                <xsl:if test="
                        matches($property/mig2:uid, $text-co-prop) or
                        matches($property/mig2:uid, $text-coitem-prop)">
                    <xsl:if test="matches($property/mig2:uid, $text-co-prop)">
                        <xsl:text> [</xsl:text>
                        <a href="{concat('#', $property/mig2:uid, '-text-co')}">
                            <xsl:text>TEXTUAL RESOURCES > COMPOUND OBJECTS</xsl:text>
                        </a>
                        <xsl:text>] </xsl:text>
                    </xsl:if>
                    <xsl:if test="matches($property/mig2:uid, $text-coitem-prop)">

                        <xsl:text> [</xsl:text>
                        <a href="{concat('#', $property/mig2:uid, '-text-coitem')}">
                            <xsl:text>TEXTUAL RESOURCES > COMPOUND-OBJECT ITEMS</xsl:text>
                        </a>
                        <xsl:text>] </xsl:text>
                    </xsl:if>
                    <br/>
                </xsl:if>
                <!-- Links to guidance for song co and coitem -->
                <xsl:if test="
                        matches($property/mig2:uid, $song-co-prop) or
                        matches($property/mig2:uid, $song-coitem-prop)">
                    <xsl:if test="matches($property/mig2:uid, $song-co-prop)">
                        <xsl:text> [</xsl:text>
                        <a href="{concat('#', $property/mig2:uid, '-song-co')}">
                            <xsl:text>BALLADS > COMPOUND OBJECTS</xsl:text>
                        </a>
                        <xsl:text>] </xsl:text>
                    </xsl:if>
                    <xsl:if test="matches($property/mig2:uid, $song-coitem-prop)">
                        <xsl:text> [</xsl:text>
                        <a href="{concat('#', $property/mig2:uid, '-song-coitem')}">
                            <xsl:text>BALLADS > COMPOUND-OBJECT ITEMS</xsl:text>
                        </a>
                        <xsl:text>] </xsl:text>
                    </xsl:if>
                    <br/>
                </xsl:if>
                <!-- Links to guidance for oh co and coitem -->
                <xsl:if test="
                        matches($property/mig2:uid, $oh-co-prop) or
                        matches($property/mig2:uid, $oh-coitem-prop)">
                    <xsl:if test="matches($property/mig2:uid, $oh-co-prop)">
                        <xsl:text> [</xsl:text>
                        <a href="{concat('#', $property/mig2:uid, '-oh-co')}">
                            <xsl:text>ORAL HISTORIES > COMPOUND OBJECTS</xsl:text>
                        </a>
                        <xsl:text>] </xsl:text>
                    </xsl:if>
                    <xsl:if test="matches($property/mig2:uid, $oh-coitem-prop)">
                        <xsl:text> [</xsl:text>
                        <a href="{concat('#', $property/mig2:uid, '-oh-coitem')}">
                            <xsl:text>ORAL HISTORIES > COMPOUND-OBJECT ITEMS</xsl:text>
                        </a>
                        <xsl:text>] </xsl:text>
                    </xsl:if>
                    <br/>
                </xsl:if>
                <!-- <xsl:choose>
                    <xsl:when test="$resource-type = 'text' and $object-type = 'co'">
                        <xsl:if test="matches($property/mig2:uid, $text-coitem-prop)">
                            <xsl:text> [ </xsl:text>
                            <a href="#text">
                                <xsl:text>TEXTUAL RESOURCES</xsl:text>
                            </a>
                            <xsl:text> > </xsl:text>
                            <a
                                href="{concat('#', $property/mig2:uid, '-', $resource-type, '-coitem')}">
                                <xsl:text>COMPOUND-OBJECT ITEMS</xsl:text>
                            </a>
                            <xsl:text> ] </xsl:text>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="$resource-type = 'text' and $object-type = 'coitem'">
                        <xsl:if test="matches($property/mig2:uid, $text-co-prop)">
                            <xsl:text> [ </xsl:text>
                            <a href="#text">
                                <xsl:text>TEXTUAL RESOURCES</xsl:text>
                            </a>
                            <xsl:text> > </xsl:text>
                            <a href="{concat('#', $property/mig2:uid, '-', $resource-type, '-co')}">
                                <xsl:text>COMPOUND OBJECTS</xsl:text>
                            </a>
                            <xsl:text> ] </xsl:text>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="$resource-type = 'song' and $object-type = 'co'">
                        <xsl:if test="matches($property/mig2:uid, $song-coitem-prop)">
                            <xsl:text> [ </xsl:text>
                            <a href="#song">
                                <xsl:text>BALLADS</xsl:text>
                            </a>
                            <xsl:text> > </xsl:text>
                            <a
                                href="{concat('#', $property/mig2:uid, '-', $resource-type, '-coitem')}">
                                <xsl:text>COMPOUND-OBJECT ITEMS</xsl:text>
                            </a>
                            <xsl:text> ] </xsl:text>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="$resource-type = 'song' and $object-type = 'coitem'">
                        <xsl:if test="matches($property/mig2:uid, $song-co-prop)">
                            <xsl:text> [ </xsl:text>
                            <a href="#song">
                                <xsl:text>BALLADS</xsl:text>
                            </a>
                            <xsl:text> > </xsl:text>
                            <a href="{concat('#', $property/mig2:uid, '-', $resource-type, '-co')}">
                                <xsl:text>COMPOUND OBJECTS</xsl:text>
                            </a>
                            <xsl:text> ] </xsl:text>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="$resource-type = 'oh' and $object-type = 'co'">
                        <xsl:if test="matches($property/mig2:uid, $oh-coitem-prop)">
                            <xsl:text> [ </xsl:text>
                            <a href="#oh">
                                <xsl:text>ORAL HISTORIES</xsl:text>
                            </a>
                            <xsl:text> > </xsl:text>
                            <a
                                href="{concat('#', $property/mig2:uid, '-', $resource-type, '-coitem')}">
                                <xsl:text>COMPOUND-OBJECT ITEMS</xsl:text>
                            </a>
                            <xsl:text> ] </xsl:text>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="$resource-type = 'oh' and $object-type = 'coitem'">
                        <xsl:if test="matches($property/mig2:uid, $oh-co-prop)">
                            <xsl:text> [ </xsl:text>
                            <a href="#oh">
                                <xsl:text>ORAL HISTORIES</xsl:text>
                            </a>
                            <xsl:text> > </xsl:text>
                            <a href="{concat('#', $property/mig2:uid, '-', $resource-type, '-co')}">
                                <xsl:text>COMPOUND OBJECTS</xsl:text>
                            </a>
                            <xsl:text> ] </xsl:text>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text> [ !ERROR GENERATING HELPFUL LINKS! ] </xsl:text>
                    </xsl:otherwise>
                </xsl:choose> -->
                <xsl:text> [</xsl:text>
                <a href="{concat('#', $property/mig2:uid, '-standalone')}">
                    <xsl:text>STANDALONE OBJECTS</xsl:text>
                </a>
                <xsl:text>] </xsl:text>
                <br/>
            </xsl:if>
            <xsl:text>[</xsl:text>
            <a href="{concat('#', $property/mig2:uid, '-settings')}">
                <xsl:text>CONTENTdm SETTINGS</xsl:text>
            </a>
            <xsl:text>] </xsl:text>
            <xsl:text> for </xsl:text>
            <span class="bold large_one">
                <xsl:choose>
                    <xsl:when test="$property/mig2:cdm/mig2:label/text()">
                        <xsl:value-of select="$property/mig2:cdm/mig2:label"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$property/mig2:labels/mig2:platformIndependent"/>
                    </xsl:otherwise>
                </xsl:choose>
            </span>
            <br/>
            <br/>
        </div>
    </xsl:template>
    <xsl:template name="prop-settings">
        <xsl:param name="ssdc-combined-map"/>
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
        <xsl:for-each select="$ssdc-combined-map/mig2:property">
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
                    test="mig2:additionalInfo/mig2:admin[@co = 'all'][@dd4para = 'p16786coll3']/node()">
                    <li>
                        <span class="bold">
                            <xsl:text>ADDITIONAL ADMINISTRATIVE NOTES</xsl:text>
                        </span>
                    </li>
                    <ul>
                        <xsl:for-each
                            select="mig2:additionalInfo/mig2:admin[@co = 'all'][@dd4para = 'p16786coll3']/mig2:para">
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

    <!-- NOTES
        * This stylesheet does not account for many of the ways that instructions/examples/etc. may be organized 
        in the existing property-file structure. For example with the use of co = 'all' or co = 'agnostic' etc.
        * I'd like MIG MAPs to indicate a platform somewhere (CONTENTdm should not be assumed)
        * 
    -->

</xsl:stylesheet>
