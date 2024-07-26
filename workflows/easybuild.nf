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

samples = Channel.fromPath(params.input).splitCsv(sep: ',')


workflow EASYBUILD {
	
	// Print the samples
	samples.view { it -> "Parsed sample: config=${it[0]}, software=${it[1]}, version=${it[2]}" }
	
	easybuild_out_log = Channel.empty()
	easybuild_out_err = Channel.empty()

	samples.flatMap { config, software, version ->	
		EASYBUILD_INSTALLATION(config, software, version) 
	}
	easybuild_out_log = EASYBUILD_INSTALLATION.out.installedLogs
	easybuild_out_err = EASYBUILD_INSTALLATION.out.errLogs

	
	checkinstall_out_ch = Channel.empty()
	
	samples.flatMap{ config, software, version -> 
		CHECK_INSTALLATION(config, software, version) 

	}
	checkinstall_out_ch = CHECK_INSTALLATION.out.log

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
