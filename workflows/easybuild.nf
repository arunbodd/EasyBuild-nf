#!/usr/bin/env nextflow

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT MODULES
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

//
// MODULE: Installed directly from nf-core/modules
//

include { EASYBUILD_INSTALLATION		} from '../modules/local/easybuild_parallelisation.nf'
include { CHECK_INSTALLATION			} from '../modules/local/check_installation.nf'

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

Channel
    .fromPath(params.input)
    .splitCsv(header:true, sep: ',')
    .map { row -> tuple(row.configfile, row.software, row.version) }
    .set { sample_ch }
sample_ch.view { "Sample channel: $it" }
workflow EASYBUILD {
	
	// Print the samples

	EASYBUILD_INSTALLATION(sample_ch) 
	//CHECK_INSTALLATION(sample_ch)
   //EASYBUILD_INSTALLATION.out.installedLogs
    //EASYBUID_INSTALLATION.out.errLogs

}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    COMPLETION EMAIL AND SUMMARY
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow.onComplete {
    if (params.email || params.email_on_fail) {
        NfcoreTemplate.email(workflow, params, summary_params, projectDir, log)
    }
    NfcoreTemplate.dump_parameters(workflow, params)
    NfcoreTemplate.summary(workflow, params, log)
    if (params.hook_url) {
        NfcoreTemplate.IM_notification(workflow, params, summary_params, projectDir, log)
    }
}

workflow.onError {
    if (workflow.errorReport.contains("Process requirement exceeds available memory")) {
        println("🛑 Default resources exceed availability 🛑 ")
        println("💡 See here on how to configure pipeline: https://nf-co.re/docs/usage/configuration#tuning-workflow-resources 💡")
    }
}
