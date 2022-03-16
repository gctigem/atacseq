#!/bin/bash

awk 'BEGIN{OFS="\t"} $12>='"$(awk -v p=${1} 'BEGIN{print -log(p)/log(10)}')"' {print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12}' ${2} | sort | uniq | sort -k1,1 -k2,2n > ${3}_IDR_filtered.bed