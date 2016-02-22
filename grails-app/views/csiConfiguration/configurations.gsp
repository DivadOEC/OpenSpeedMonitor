<%@ page import="grails.plugin.springsecurity.SpringSecurityUtils; grails.converters.JSON" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="kickstart_osm"/>
    <title>CSI CheckDashboard</title>
    <style>
    %{--Styles for MatrixView--}%
    .xAxisMatrix path,
    .xAxisMatrix line,
    .yAxisMatrix path,
    .yAxisMatrix line {
        fill: none;
        shape-rendering: inherit;
    }

    .xAxisMatrix text,
    .yAxisMatrix text {
        font-size: 12px;
    }

    .matrixViewAxisLabel {
        font-weight: bold;
    }

    %{--Styles for BarChart--}%
    .barRect {
        fill: steelblue;
    }

    .barRect:hover {
        fill: orange;
    }

    .chart .axisLabel {
        fill: black;
        text-anchor: end;
        font-weight: bold;
    }

    .xAxis path,
    .xAxis line,
    .yAxis path,
    .yAxis line {
        fill: none;
        stroke: black;
        shape-rendering: inherit;
    }

    /*Styles for the clocks*/
    svg.clock {
        stroke-linecap: round;
    }

    .minutetick.face {
        stroke-width: 1;
    }

    .hand {
        stroke: #336;
        stroke-width: 2;
    }

    .clockBorder {
        fill: #e1e1e1;
        stroke: black;
    }

    /*Styles for Treemap*/
    .node {
        overflow: hidden;
        position: absolute;
    }

    .browserText {
        fill: black;
        font-weight: bold;
        stroke-width: 0px;
    }

    .filterBox li {
        margin-left: 15px;

    }

    #tooltipMatrixView,
    #tooltip {
        position: absolute;
        width: auto;
        height: auto;
        padding: 10px;
        background-color: white;
        -webkit-border-radius: 10px;
        -moz-border-radius: 10px;
        border-radius: 10px;
        -webkit-box-shadow: 4px 4px 10px rgba(0, 0, 0, 0.4);
        -moz-box-shadow: 4px 4px 10px rgba(0, 0, 0, 0.4);
        box-shadow: 4px 4px 10px rgba(0, 0, 0, 0.4);
        pointer-events: none;
    }

    #tooltipMatrixView.hidden,
    #tooltip.hidden {
        display: none;
    }

    #tooltipMatrixView p,
    #tooltip p {
        margin: 0;
        font-family: sans-serif;
        font-size: 16px;
        line-height: 20px;
    }

    %{--Styles for multi line chart--}%
    .axis path,
    .axis line {
        fill: none;
        stroke: black;
        shape-rendering: crisp-edges;
    }

    .line {
        fill: none;
        stroke-width: 2px;
    }

    .verticalLine,
    .horizontalLine {
        opacity: 0.3;
        stroke-dasharray: 3, 3;
        stroke: blue;
    }

    .xTextContainer,
    .tooltipTextContainer {
        opacity: 0.5;
    }

    #defaultMultilineGraphButtonLine {
        margin-bottom: 30px;
    }
    </style>
</head>

<body>
<%-- main menu ---------------------------------------------------------------------------%>
<g:render template="/layouts/mainMenu"/>

%{--container for errors --}%
<div class="alert alert-error" id="errorDeletingCsiConfiguration" style="display: none">
    <strong>
        <g:message code="de.iteratec.osm.csiConfiguration.deleteErrorTitle"/>
    </strong>

    <p id="deletingCsiConfiguratioinErrors"></p>
</div>

<div class="row">

    %{--Name and description of actual config----------------------------------------------}%
    <div class="span8">
        <blockquote>
            <p class="text-info">
                <strong id="headerCsiConfLabel">${selectedCsiConfiguration.label}</strong>
                <sec:ifAnyGranted roles="ROLE_ADMIN, ROLE_SUPER_ADMIN">
                    <a href="#updateCsiConfModal" class="fa fa-edit"
                       style="text-decoration:none;color: #3a87ad;" data-toggle="modal"></a>
                </sec:ifAnyGranted>
            </p>
            <span id="headerCsiConfDescription">${selectedCsiConfiguration.description}</span>
        </blockquote>
    </div>

    <div id="copyCsiConfigurationSpinner" class="spinner-large-content-spinner"></div>
    %{--dropdown button----------------------------------------------}%
    <div class="span2 offset1">

        <g:if test="${grails.plugin.springsecurity.SpringSecurityUtils.ifAnyGranted("ROLE_ADMIN,ROLE_SUPER_ADMIN") || csiConfigurations.size() > 1}">

            <div class="btn-group pull-left">
                <button class="btn btn-small btn-info dropdown-toggle text-right" data-toggle="dropdown">
                    <g:message code="de.iteratec.osm.csi.configuration.messages.actual-configuration"
                               default="This Configuration..."></g:message>
                    <span class="caret"></span>
                </button>
                <ul class="dropdown-menu">

                %{--features for actual configuration----------------------------}%
                    <sec:ifAnyGranted roles="ROLE_ADMIN,ROLE_SUPER_ADMIN">
                        <li>
                            <a href="#"
                               onclick="prepareConfigurationListAndCopy();">
                                <i class="fa fa-copy"></i>&nbsp;${message(code: 'de.iteratec.osm.csiConfiguration.saveAs', default: 'Copy')}
                            </a>
                        </li>
                        <li>
                            <a href="${createLink(absolute: true, controller: 'csiConfiguration', action: 'deleteCsiConfiguration',
                                    params: [sourceCsiConfigLabel: selectedCsiConfiguration.label, label: selectedCsiConfiguration.label])}"
                               onclick="return validateDeleting('${selectedCsiConfiguration.label}', '${message(code: 'de.iteratec.osm.csiConfiguration.sureDelete.js', args: [selectedCsiConfiguration.label], default: 'delete?')}', '${message(code: 'de.iteratec.osm.csiConfiguration.overwriteWarning.js', default: 'Overwriting')}')">
                                <i class="fa fa-remove"></i>&nbsp;${message(code: 'de.iteratec.osm.csi.ui.delete.label', args: [selectedCsiConfiguration.label], default: 'delete')}
                            </a>
                        </li>
                    </sec:ifAnyGranted>

                %{--submenu to show other configurations----------------------------}%
                    <g:if test="${csiConfigurations.size() > 1}">
                        <li class="dropdown-submenu">
                            <a tabindex="-1" href="#">
                                <i class="fa fa-share-square-o"></i>&nbsp;<g:message
                                    code="de.iteratec.osm.csi.configuration.messages.select-different" default="leave"/>
                            </a>
                            <ul class="dropdown-menu">
                                <g:each in="${csiConfigurations.findAll { it[0] != selectedCsiConfiguration.ident() }}"
                                        var="conf">
                                    <li>
                                        <a id="button_${conf}"
                                           onclick="changeCsiConfiguration(this.getAttribute('value'))"
                                           value="${conf[0]}">
                                            <g:message code="de.iteratec.osm.csi.ui.show.label" args="${[conf[1]]}"
                                                       default="show ${conf[1]}"/>
                                        </a>
                                    </li>
                                </g:each>
                            </ul>
                        </li>
                    </g:if>
                </ul>
            </div>

        </g:if>

    </div>
</div>

%{--mapping and weights details----------------------------------------------}%
<g:render template="confDetails" model="[readOnly                : false,
                                         showDefaultMappings     : true,
                                         errorMessagesCsi        : errorMessagesCsi,
                                         defaultTimeToCsMappings : defaultTimeToCsMappings,
                                         selectedCsiConfiguration: selectedCsiConfiguration]"/>

%{--initially invisible modal dialog to update csi configuratuion via ajax---------------}%
<g:render template="/_common/modals/csi/updateCsiConfiguration"/>

<%-- include bottom ---------------------------------------------------------------------------%>

<content tag="include.bottom">
    <asset:javascript src="d3/matrixView.js"/>
    <asset:javascript src="d3/barChart.js"/>
    <asset:javascript src="d3/treemap.js"/>
    <asset:script type="text/javascript">

        var registerEventHandlers = function () {

            registerEventHandlersForFileUploadControls();

            $("#btn-csi-mapping").click(function () {
                $('#csi-mapping').show();
                $('#csi-weights').hide();
            });
            $("#btn-csi-weights").click(function () {
                $('#csi-mapping').hide();
                $('#csi-weights').show();
            });

            $('#updateCsiConfModal').on('shown', function () {
                $('#confLabelFromModal').val( $('#headerCsiConfLabel').text() );
                $('#confDescriptionFromModal').val( $('#headerCsiConfDescription').text() );
                $('#updatingCsiConfigurationErrors').text('');
                $('#errorUpdatingCsiConfiguration').hide();
            });

            $('#defaultTimeToCsMappingCsvFile').bind('change', function () {
                $("#warnAboutOverwritingBox").hide();
                $("#errorBoxDefaultMappingCsv").hide();
                $("#defaultMappingUploadButton").prop("disabled", true);

                validateDefaultMappingCsv(this.files[0])
            });

        };

        var registerEventHandlersForFileUploadControls = function () {
            $('input[id=theBrowserConnectivityCsvFile]').change(function () {
                $('#theBrowserConnectivityCsvFileTwitter').val($(this).val());
            });
            $('input[id=theBrowserCsvFile]').change(function () {
                $('#theBrowserCsvFileTwitter').val($(this).val());
            });
            $('input[id=thePageCsvFile]').change(function () {
                $('#thePageCsvFileTwitter').val($(this).val());
            });
            $('input[id=theHourOfDayCsvFile]').change(function () {
                $('#theHourOfDayCsvFileTwitter').val($(this).val());
            });
            $('input[id=defaultTimeToCsMappingCsvFile]').change(function () {
                $('#defaultTimeToCsMappingCsvFileVisible').val($(this).val());
            });
        };

        var initializeSomeControls = function(){
            $("#warnAboutOverwritingBox").hide();
            $("#errorBoxDefaultMappingCsv").hide();
            $("#defaultMappingUploadButton").prop("disabled", true);
            if (${showCsiWeights}) {
                $("#btn-csi-weights").click();
            } else {
                $("#btn-csi-mapping").click();
            }
        }

        var prepareConfigurationListAndCopy = function(){
            return copyCsiConfiguration(${csiConfigurations as grails.converters.JSON})
        }

        $(document).ready(function () {

            actualCsiConfigurationId = ${selectedCsiConfiguration.ident()};

            createMatrixView(${matrixViewData}, "browserConnectivityMatrixView");
            createTreemap(1200, 750, ${treemapData}, "rect", "pageWeightTreemap");
            createBarChart(1000, 750, ${barchartData}, "clocks", "hoursOfDayBarchart");

            registerEventHandlers();

            initializeSomeControls();

        });
        $( window ).load(function() {
            var loader = new PostLoader();
            loader.loadJavascript('<g:assetPath src="csi/configurationPost.js" absolute="true"/>');
        });

    </asset:script>
</content>
</body>
</html>
