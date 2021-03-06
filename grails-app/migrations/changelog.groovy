databaseChangeLog = {

    include file: '2015-11-18-SCHEME-initial-liquibase.groovy'
    include file: '2015-11-18-DATA-set-initial-csi-transformation.groovy'
    include file: '2015-11-18-DATA-multiply-csi-values-by-100.groovy'
    include file: '2015-11-26-SCHEME-optimizing-indices.groovy'
    include file: '2015-12-09-SCHEME-csi-configuration.groovy'
    include file: '2015-12-15-SCHEME-measured-value-and-connectivity-profile.groovy'
    include file: '2015-12-16-DATA-delete-invalid-default-csi-mappings.groovy'
    include file: '2015-12-22-DATA-delete-measured-value-update-events.groovy'
    include file: '2015-12-23-SCHEME-CsiDay-class-with-hoursOfDay.groovy'
    include file: '2015-12-23-SCHEME-replaced-hourOfDays-with-CsiDay-in-CsiConfiguration.groovy'
    include file: '2015-12-23-DATA-convert-hoursOfDay-to-CsiDay.groovy'
    include file: '2015-12-23-SCHEME-added-csiConfiguration-to-jobGroup.groovy'
    include file: '2016-01-04-DATA-create-initial-browser-connectivity-weights.groovy'
    include file: '2016-02-22-SCHEME-v340.groovy'
    include file: '2016-02-22-DATA-v340.groovy'
	include file: '2016-02-24-SCHEME-v341.groovy'
	include file: '2016-02-24-DATA-v341.groovy'
    include file: '2016-03-02-SCHEME-v346.groovy'
    include file: '2016-03-04-SCHEME-v347.groovy'
    include file: '2016-03-30-SCHEME-v348.groovy'
}
