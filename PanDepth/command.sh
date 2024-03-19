#for Pandepth (v2.16), Sambamba (v1.0.0), Mosdepth (v0.3.5), Megadepth (v1.2.0), and BamToCov (v2.7.0)
for thread in 1 2 3 4 6 12 24
do
    for repeat in {1..10}
    do
        for fileType in bam cram
        do
            for readType in SR LR
            do
                /usr/bin/time -v mosdepth -t ${thread} mosdepth.${readType}.sort.${fileType}_t${thread}_r8 ${readType}.sort.${fileType} 2>mosdepth.${readType}.sort.${fileType}_t${thread}_r${repeat}.log
                /usr/bin/time -v megadepth ${readType}.sort.${fileType} --gzip --no-coverage-stdout --coverage --threads ${thread} --prefix megadepth.${readType}.sort.${fileType}_t${thread}_r${repeat} 2>megadepth.${readType}.sort.${fileType}_t${thread}_r${repeat}.log
                /usr/bin/time -v bamtocov --skip-output -T ${thread} -o bamtocov.${readType}.sort.${fileType}_t${thread}_r8.txt ${readType}.sort.${fileType} 2>bamtocov.${readType}.sort.${fileType}_t${thread}_r${repeat}.log
                /usr/bin/time -v pandepth -i ${readType}.sort.${fileType} -o pandepth.${readType}.sort.${fileType}_t${thread}_r${repeat} -t ${thread} 2>pandepth.${readType}.sort.${fileType}_t${thread}_r${repeat}.log
            done
        done
    done
done

#for sambamba
for thread in 1 2 3 4 6 12 24
do
    for repeat in {1..10}
    do
        for readType in SR LR
        do
            /usr/bin/time -v sambamba depth base -c 0 -t ${thread} -o sambamba.${readType}.sort.bam_t${thread}_r${repeat}.txt ${readType}.sort.bam 2>sambamba.${readType}.sort.bam_t${thread}_r${repeat}.log
        done
    done
done

#for bedtools and samtools
for repeat in {1..10}
do
    for fileType in bam cram
    do
        for readType in SR LR
        do
            /usr/bin/time -v samtools coverage -o samtools.${readType}.sort.${fileType}_r${repeat}.txt ${readType}.sort.${fileType} 2>samtools.${readType}.sort.${fileType}_r${repeat}.log
            /usr/bin/time -v bedtools genomecov -bg -split -ibam ${readType}.sort.${fileType} > bedtools.${readType}.sort.${fileType}_r${repeat}.txt 2> bedtools.${readType}.sort.${fileType}_r${repeat}.log
        done
    done
done




