#awk -F '<td>|<\/td>' '/QAM256/{print "modem_arris,channel="$2"i,power="$12}'

BEGIN {
        FS = "<td>|<\/td>"
        ORS = "\n"
	NUM_CHAN = 0
	NUM_CHAN_UP = 0
}

/QAM256/ {
	power=$12
	gsub(/ /,"",power)
	gsub(/dBmV/,"",power)
	arris[NUM_CHAN,"Power"]=power

	snr=$14
        gsub(/ /,"",snr)
        gsub(/dB/,"",snr)
	arris[NUM_CHAN,"SNR"]=snr

	arris[NUM_CHAN,"Cr"]=$16
	arris[NUM_CHAN,"Uncr"]=$18
	
	NUM_CHAN++
} 

/ATDMA/ {
	power_up=$14
	gsub(/ /,"",power_up)
        gsub(/dBmV/,"",power_up)
	NUM_CHAN_UP++
}


END {
	for (i=0;i<NUM_CHAN;i++) {
		print "modem_arris_downstream,channel="i+1" power=" arris[i,"Power"] ",snr=" arris[i,"SNR"] ",corrected=" arris[i,"Cr"] ",uncorrectables=" arris[i,"Uncr"]
	}

	for (i=0;i<NUM_CHAN_UP;i++) {
		print "modem_arris_upstream,channel="i+1" power=" power_up
	}
}
