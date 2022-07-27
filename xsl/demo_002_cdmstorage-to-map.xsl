<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:cdmstore="https://uwlib-mig.github.io/contentdm_storage/xsd/"
    xmlns:cdmmap="https://uwlib-mig.github.io/contentdm_maps/xsd/"
    exclude-result-prefixes="xs math cdmstore cdmmap" version="3.0">

    <xsl:output method="html" indent="true"/>

    <xsl:variable name="map" select="document('../xml/temp_001_tjls.xml')"/>
    <xsl:variable name="alias" select="$map/cdmmap:contentdm_map/cdmmap:cdm_alias"/>
    <!-- [!] CAUTION local file path to elements xml, using local data -->
    <xsl:variable name="elements" select="collection('../../contentdm_storage/xml/?select=*.xml')"/>

    <xsl:variable name="uw_object_types">
        <xsl:for-each select="
                distinct-values($elements/cdmstore:uwldc_element/cdmstore:contentdm
                /cdmstore:implementation_set[@cdm_alias = $alias]/@uw_object_type)">
            <uw_object_type>
                <xsl:value-of select="."/>
            </uw_object_type>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="cdm_object_types">
        <xsl:for-each select="
                distinct-values($elements/cdmstore:uwldc_element/cdmstore:contentdm/
                cdmstore:implementation_set[@cdm_alias = $alias]/@cdm_object_type)">
            <cdm_object_type>
                <xsl:value-of select="."/>
            </cdm_object_type>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="uw_coitem_types">
        <xsl:for-each select="
                distinct-values($elements/cdmstore:uwldc_element/cdmstore:contentdm/
                cdmstore:implementation_set[@cdm_alias = $alias]/@uw_coitem_type)">
            <uw_coitem_type>
                <xsl:value-of select="."/>
            </uw_coitem_type>
        </xsl:for-each>
    </xsl:variable>

    <xsl:template match="/">
        
        <test_output>
            <uw_object_types>
                <xsl:for-each select="$uw_object_types/uw_object_type">
                    <uw_object>
                        <xsl:value-of select="."/>
                    </uw_object>
                </xsl:for-each>
            </uw_object_types>
            <cdm_object_types>
                <xsl:for-each select="$cdm_object_types/cdm_object_type">
                    <cdm_object>
                        <xsl:value-of select="."/>
                    </cdm_object>
                </xsl:for-each>
            </cdm_object_types>
            <uw_coitem_types>
                <!-- make this conditional, do not retrieve coitem types if coitems not in coll -->
                <xsl:for-each select="$uw_coitem_types/uw_coitem_type">
                    <uw_coitem_object>
                        <xsl:value-of select="."/>
                    </uw_coitem_object>
                </xsl:for-each>
            </uw_coitem_types>
            <element_details_by_uw_object_type>
                <!-- THIS WON'T WORK any longer because uwcontentdm.xsd has changed -->
                <xsl:for-each select="$uw_object_types/uw_object_type">
                    <xsl:variable name="uw_object_type" select="."/>
                    <uw_object_type object_type="{.}">
                        <xsl:for-each select="
                                $elements/cdmstore:uwldc_element
                                [cdmstore:contentdm/cdmstore:implementation_set/
                                @uw_object_type = $uw_object_type]">
                            <element>
                                <name>
                                    <xsl:value-of select="cdmstore:name"/>
                                </name>
                                <cdm_object_types>
                                    <xsl:for-each select="
                                            distinct-values(cdmstore:contentdm/
                                            cdmstore:implementation_set
                                            [@uw_object_type = $uw_object_type]/@cdm_object_type)">
                                        <cdm_object_type>
                                            <xsl:value-of select="."/>
                                            <!-- TO DO if coitem, retrieve uw_coitem_types here -->
                                        </cdm_object_type>
                                    </xsl:for-each>
                                </cdm_object_types>
                            </element>
                        </xsl:for-each>
                    </uw_object_type>
                </xsl:for-each>
            </element_details_by_uw_object_type>

            <!-- TEST prop_list_all -->
            <test_prop_list>
                <xsl:for-each select="$elements/cdmstore:uwldc_element">
                    <div class="prop_list_heading">
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
                                        select="cdmstore:contentdm/cdmstore:default_field_label"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </p>
                    </div>
                    <xsl:call-template name="prop_list_all_details">
                        <xsl:with-param name="element" select="."/>
                    </xsl:call-template>
                </xsl:for-each>
            </test_prop_list>
        </test_output>
    </xsl:template>

    <xsl:template name="prop_list_all_details">
        <xsl:param name="element"/>
        <ul>
            <xsl:for-each select="$uw_object_types/uw_object_type">
                <li>
                    <xsl:text>USE WITH </xsl:text>
                    <!-- need mechanism to pull formatted labels for object type -->
                    <xsl:value-of select="."/>
                </li>               
                <ul>
                    <xsl:if test="
                            $element/cdmstore:contentdm/cdmstore:implementation_set
                            [matches(@cdm_alias, $alias)]
                            [matches(@uw_object_type, .) or matches(@uw_object_type, '\*')]
                            [matches(@cdm_object_type, 'co') or matches(@cdm_object_type, '\*')]">
                        <li>
                            <xsl:text>compound objects</xsl:text>
                        </li>
                    </xsl:if>
                    <xsl:if test="
                            $element/cdmstore:contentdm/cdmstore:implementation_set
                            [matches(@cdm_alias, $alias)]
                            [matches(@uw_object_type, .) or matches(@uw_object_type, '\*')]
                            [matches(@cdm_object_type, 'coitem') or matches(@cdm_object_type, '\*')]">
                        <xsl:for-each select="
                                $element/cdmstore:contentdm/cdmstore:implementation_set
                                [matches(@cdm_alias, $alias)]
                                [matches(@uw_object_type, .) or matches(@uw_object_type, '\*')]
                                [matches(@cdm_object_type, 'coitem') or matches(@cdm_object_type, '\*')]
                                /@uw_coitem_type">
                            <li>
                                <xsl:text>compound-object items > </xsl:text>
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
