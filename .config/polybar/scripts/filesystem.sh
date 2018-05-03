#/bin/sh

icons=(  )
parts=(/ /mnt/data /mnt/backup)
output=""
for i in "${!parts[@]}"; do 
	avail=$(df -h ${parts[$i]} | tail -1 | tr -s ' ' | cut -d' ' -f4)
	used=$(df -h ${parts[$i]} | tail -1 | tr -s ' ' | cut -d' ' -f5)
	num=$(echo ${used} | cut -d'%' -f1)

	if [ "$num" -gt 80 ] ; then
		color="#dd7777"
	elif [ "$num" -gt 50 ] ; then
		color="#fba922"
	else
		color="#77dd77"
	fi
	output=$output"%{F${color}}${icons[$i]} $used%{F#555} · $avail%{F-}"
	if [ $(($i + 1)) -ne "${#parts[@]}" ] ; then
		output=$output"               "
	fi

done

echo "$output"