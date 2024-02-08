
process BUNDLE_AVERAGE {
    tag "$meta.id"
    label 'process_single'

    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://scil.usherbrooke.ca/containers/scilus_1.6.0.sif':
        'scilus/scilus:1.6.0' }"

    input:
        tuple val(meta), path(bundles), path(centroids_dir)

    output:
        tuple val(meta), path("*_average_density_mni.nii.gz"), emit: average_density_mni, optional true
        tuple val(meta), path("*_average_binary_mni.nii.gz"), emit: average_binary_mni, optional true
        path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    shopt -s nullglob
    mkdir tmp/
    for centroid in $centroids_dir/*.trk;
        do bname=\${centroid/_centroid/}
        bname=\$(basename \$bname .trk)

        nfiles=\$(find ./ -maxdepth 1 -type f -name "*__\${bname}_density_mni.nii.gz" | wc -l)
        if [[ \$nfiles -gt 0 ]];
            then scil_image_math.py addition *__\${bname}_density_mni.nii.gz 0 tmp/\${bname}_average_density_mni.nii.gz
            scil_image_math.py addition *__\${bname}_binary_mni.nii.gz 0 tmp/\${bname}_average_binary_mni.nii.gz
        fi
    done
    mv tmp/* ./

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        scilpy: 1.6.0
    END_VERSIONS
    """

    stub:
    def prefix = task.ext.prefix ?: "${meta.id}"

    """
    scil_image_math.py -h

    touch ${prefix}__average_density_mni.nii.gz
    touch ${prefix}__average_binary_mni.nii.gz

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        scilpy: 1.6.0
    END_VERSIONS
    """
}
