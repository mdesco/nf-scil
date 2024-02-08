#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { BUNDLE_AVERAGE } from '../../../../../modules/nf-scil/bundle/average/main.nf'

workflow test_bundle_average {

    input = [
        [ id:'test', single_end:false ], // meta map
        file(params.test_data['light']['bundles-centroids']['IFG*trk'], checkIfExists: true),
        file(params.test_data['light']['bundles-centroids']['centroids'], checkIfExists: true)
    ]

    BUNDLE_AVERAGE ( input )
}
