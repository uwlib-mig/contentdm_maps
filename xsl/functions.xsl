<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:cdmm="https://uwlib-mig.github.io/contentdm_maps/xsd/"
    xmlns:schemas="https://uwlib-mig.github.io/schemasProject/xsd/"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" exclude-result-prefixes="#all"
    expand-text="yes" version="3.0">

    <!-- coll_name -->
    <xsl:variable name="collection_list" select="
            unparsed-text('https://uwlib-mig.github.io/schemasProject/json/collection_list.json')
            => fn:json-to-xml()"/>
    <xsl:function name="cdmm:coll_name">
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

    <!-- render_genre_form -->
    <xsl:function name="cdmm:render_genre_form">
        <xsl:param name="genre_form" as="xs:string"/>
        <xsl:value-of select="translate($genre_form, '_', ' ')"/>
    </xsl:function>

    <!-- convert_object_type_notation -->
    <xsl:function name="cdmm:convert_object_type_notation">
        <xsl:param name="cdm_object_type"/>
        <xsl:choose>
            <xsl:when test="$cdm_object_type = 'compound_object'">object</xsl:when>
            <xsl:when test="$cdm_object_type = 'co_item'">item</xsl:when>
            <xsl:when test="$cdm_object_type = 'standalone_item'">no</xsl:when>
        </xsl:choose>
    </xsl:function>

    <!-- get_dcmap_config -->
    <xsl:variable name="dc_map_config_to_dc_term">
        <options>
            <dc_map_config label="Title">
                <dc_term>title</dc_term>
            </dc_map_config>
            <dc_map_config label="Subject">
                <dc_term>subject</dc_term>
            </dc_map_config>
            <dc_map_config label="Description">
                <dc_term>description</dc_term>
            </dc_map_config>
            <dc_map_config label="Creator">
                <dc_term>creator</dc_term>
            </dc_map_config>
            <dc_map_config label="Publisher">
                <dc_term>publisher</dc_term>
            </dc_map_config>
            <dc_map_config label="Contributors">
                <dc_term>contributor</dc_term>
            </dc_map_config>
            <dc_map_config label="Date">
                <dc_term>date</dc_term>
            </dc_map_config>
            <dc_map_config label="Type">
                <dc_term>type</dc_term>
            </dc_map_config>
            <dc_map_config label="Format">
                <dc_term>format</dc_term>
            </dc_map_config>
            <dc_map_config label="Identifier">
                <dc_term>identifier</dc_term>
            </dc_map_config>
            <dc_map_config label="Source">
                <dc_term>source</dc_term>
            </dc_map_config>
            <dc_map_config label="Language">
                <dc_term>language</dc_term>
            </dc_map_config>
            <dc_map_config label="Relation">
                <dc_term>relation</dc_term>
            </dc_map_config>
            <dc_map_config label="Coverage">
                <dc_term>coverage</dc_term>
            </dc_map_config>
            <dc_map_config label="Rights">
                <dc_term>rights</dc_term>
            </dc_map_config>
            <dc_map_config label="Audience">
                <dc_term>audience</dc_term>
            </dc_map_config>
            <dc_map_config label="Accrual_Method">
                <dc_term>accrualMethod</dc_term>
            </dc_map_config>
            <dc_map_config label="Accrual_Periodicity">
                <dc_term>accrualPeriodicity</dc_term>
            </dc_map_config>
            <dc_map_config label="Accrual_Policy">
                <dc_term>accrualPolicy</dc_term>
            </dc_map_config>
            <dc_map_config label="Instructional_Method">
                <dc_term>instructionalMethod</dc_term>
            </dc_map_config>
            <dc_map_config label="Provenance">
                <dc_term>provenance</dc_term>
            </dc_map_config>
            <dc_map_config label="Title-Alternative">
                <dc_term>alternative</dc_term>
            </dc_map_config>
            <dc_map_config label="Description-Table_Of_Contents">
                <dc_term>tableOfContents</dc_term>
            </dc_map_config>
            <dc_map_config label="Description-Abstract">
                <dc_term>abstract</dc_term>
            </dc_map_config>
            <dc_map_config label="Date-Created">
                <dc_term>created</dc_term>
            </dc_map_config>
            <dc_map_config label="Date-Valid">
                <dc_term>valid</dc_term>
            </dc_map_config>
            <dc_map_config label="Date-Available">
                <dc_term>available</dc_term>
            </dc_map_config>
            <dc_map_config label="Date-Issued">
                <dc_term>issued</dc_term>
            </dc_map_config>
            <dc_map_config label="Date-Modified">
                <dc_term>modified</dc_term>
            </dc_map_config>
            <dc_map_config label="Date-Accepted">
                <dc_term>dateAccepted</dc_term>
            </dc_map_config>
            <dc_map_config label="Date-Copyrighted">
                <dc_term>dateCopyrighted</dc_term>
            </dc_map_config>
            <dc_map_config label="Date-Submitted">
                <dc_term>dateSubmitted</dc_term>
            </dc_map_config>
            <dc_map_config label="Format-Extent">
                <dc_term>extent</dc_term>
            </dc_map_config>
            <dc_map_config label="Format-Medium">
                <dc_term>medium</dc_term>
            </dc_map_config>
            <dc_map_config label="Identifier-Biliographic_Citation">
                <dc_term>bibliographicCitation</dc_term>
            </dc_map_config>
            <dc_map_config label="Relation-Is_Version_Of">
                <dc_term>isVersionOf</dc_term>
            </dc_map_config>
            <dc_map_config label="Relation-Has_Version">
                <dc_term>hasVersion</dc_term>
            </dc_map_config>
            <dc_map_config label="Relation-Is_Replaced_By">
                <dc_term>isReplacedBy</dc_term>
            </dc_map_config>
            <dc_map_config label="Relation-Replaces">
                <dc_term>replaces</dc_term>
            </dc_map_config>
            <dc_map_config label="Relation-Is_Required_By">
                <dc_term>isRequiredBy</dc_term>
            </dc_map_config>
            <dc_map_config label="Relation-Requires">
                <dc_term>requires</dc_term>
            </dc_map_config>
            <dc_map_config label="Relation-Is_Part_of">
                <dc_term>isPartOf</dc_term>
            </dc_map_config>
            <dc_map_config label="Relation-Has_Part">
                <dc_term>hasPart</dc_term>
            </dc_map_config>
            <dc_map_config label="Relation-Is_Referenced_By">
                <dc_term>isReferencedBy</dc_term>
            </dc_map_config>
            <dc_map_config label="Relation-References">
                <dc_term>references</dc_term>
            </dc_map_config>
            <dc_map_config label="Relation-Is_Format_Of">
                <dc_term>isFormatOf</dc_term>
            </dc_map_config>
            <dc_map_config label="Relation-Has_Format_Of">
                <dc_term>hasFormat</dc_term>
            </dc_map_config>
            <dc_map_config label="Relation-Conforms_To">
                <dc_term>conformsTo</dc_term>
            </dc_map_config>
            <dc_map_config label="Rights-Access_Rights">
                <dc_term>accessRights</dc_term>
            </dc_map_config>
            <dc_map_config label="Rights-License">
                <dc_term>license</dc_term>
            </dc_map_config>
            <dc_map_config label="Rights-Rights_Holder">
                <dc_term>rightsHolder</dc_term>
            </dc_map_config>
            <dc_map_config label="Coverage-Spatial">
                <dc_term>spatial</dc_term>
            </dc_map_config>
            <dc_map_config label="Coverage-Temporal">
                <dc_term>temporal</dc_term>
            </dc_map_config>
            <dc_map_config label="Audience-Mediator">
                <dc_term>mediator</dc_term>
            </dc_map_config>
            <dc_map_config label="Audience-Education_Level">
                <dc_term>educationLevel</dc_term>
            </dc_map_config>
            <dc_map_config label="None">
                <dc_term>none</dc_term>
            </dc_map_config>
        </options>
    </xsl:variable>
    <xsl:key name="config_to_term" match="dc_map_config" use="dc_term"/>
    <xsl:function name="cdmm:get_dcmap_config">
        <xsl:param name="dcterm"/>
        <xsl:value-of select="key('config_to_term', $dcterm, $dc_map_config_to_dc_term/options)/@label"/>
    </xsl:function>
</xsl:stylesheet>
