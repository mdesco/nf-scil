#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { BUNDLE_AVERAGE } from '../../../../../modules/nf-scil/bundle/average/main.nf'

workflow test_bundle_average {

    input = [
        [ id:'test', single_end:false ], // meta map
        [file(params.test_data['bundle']['average']['bundle1'], checkIfExists: true),
        file(params.test_data['bundle']['average']['bundle2'], checkIfExists: true)],
        file(params.test_data['bundle']['average']['folder'], checkIfExists: true)
    ]

    BUNDLE_AVERAGE ( input )
}
