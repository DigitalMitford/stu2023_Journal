<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xs math"
    version="3.0">
    <xsl:output method="xhtml" html-version="5" omit-xml-declaration="yes"/>
    <xsl:variable name="si" as="document-node()" select="doc('https://digitalmitford.org/si.xml')"/>
    <xsl:variable name="journal" as="document-node()" select="doc('https://raw.githubusercontent.com/DigitalMitford/stu2023_Journal/master/1819-1823MRMJournal.xml')"/>
    
    <xsl:template match="/">
        <html>
            <head>
                <title>Exploring Mitford's Journal and Site Index</title>
                <link rel="stylesheet" type="text/css" href="style.css"/>
                <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"
                    integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY="
                    crossorigin=""/>
                <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"
                    integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo="
                    crossorigin=""></script>
            </head>
            <body>
                <xsl:variable name="placeRefs" as="item()+" select="$journal//placeName/@ref ! substring-after(., '#') ! normalize-space() => distinct-values() => sort()"/>
                <div class="main">                
                    <div class="journalIndex">
                    <table>
                        <tr>
                            <th> Locations </th>
                            <th> Mentioned entries </th>
                        </tr>
                        <xsl:for-each select="$placeRefs">
                          <xsl:variable name="SI-lookup" as="item()?" select="$si//place[@xml:id ! normalize-space() = current()]"/>
                          
                            <tr>
                                <td>
                                    <!-- 2023-12-13 ebb: Check if place has geocoordinates or not. If it does not, don't output a map button. -->
                                   <xsl:choose> 
                                       
                                      <xsl:when test="$SI-lookup and $SI-lookup//geo[matches(., '^\d+')]"> 
                                          <button id="{current()}"><xsl:apply-templates select="$SI-lookup/placeName[1] ! normalize-space()  => string-join(', ') "/></button>
                                      </xsl:when>
                                       <xsl:when test="$SI-lookup and not($SI-lookup//geo[matches(., '^\d+')])"> 
                                           <xsl:apply-templates select="$SI-lookup/placeName[1] ! normalize-space() => string-join(', ') "/>
                                       </xsl:when>
                                       
                                       <xsl:otherwise>
                                           <xsl:apply-templates select="current()"/>
                                       </xsl:otherwise>
                                   
                                   </xsl:choose>
                                </td>
                                <td>
                                    <ul>
                                    <xsl:for-each select="$journal//div[@type ='entry'][.//placeName[@ref = concat('#', current())]]">
                                        <li><a href="texts.html#{current()/@xml:id}"><xsl:apply-templates select="current()//head/date/@when"/></a></li>
                                    </xsl:for-each>
                                    </ul>
                                </td>
                            </tr>
                        </xsl:for-each>
                    </table>
                    </div>
                    <div class="journalViewer">
                        <div id="map" style="width: 100%; height: 65%"></div>
                        <script src="script.js"></script>
                        <h2 class="locationName"></h2>
                        <p class="locationInfo"></p>
                    </div>
                </div>
            </body> 
        </html>
    </xsl:template>
</xsl:stylesheet>