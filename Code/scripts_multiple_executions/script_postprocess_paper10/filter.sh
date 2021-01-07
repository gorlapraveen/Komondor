# Converts agent's logs to timestamp - throughput satisfaction csv.

cd ../../output

mkdir -p processed_output
rm processed_output/*

echo 'DETECTED KOMONDOR INPUT FILES: '
file_ix=0
while read line
do
	array_original[ $file_ix ]="$line"
	echo "- ${array_original[file_ix]}"
	(( file_ix++ ))
done < <(ls)

(( file_ix --));

echo '---------------------------------------'
echo ''
# processing part 1: extract lines where word "satisfaction" appears
echo '- processing part 1: extract lines where word reward appears...'
for (( executing_ix=0; executing_ix < (file_ix); executing_ix++))
do 
    grep "thr. satisfaction" ${array_original[executing_ix]} > processed_output/test_output_$(printf %06d $executing_ix).csv
    #grep "reward (mixed)" ${array_original[executing_ix]} > processed_output/test_output_$(printf %06d $executing_ix).csv
done

# processing part 2: parse the pre-processed files and generate a csv file with the timestamp and the satisfaction value
echo '- processing part 2: parse the pre-processed files and generate a csv file with the timestamp and the reward value...'
cd processed_output/
file_ix=0
while read line
do
	array[ $file_ix ]="$line"
	(( file_ix++ ))
done < <(ls)
(( file_ix --));

# process the files (remove "=")
echo '- removing "=" symbol...'
for (( executing_ix=0; executing_ix < (file_ix + 1); executing_ix++))
do 
   while IFS="=" read a b;do
	   echo $a ";" $b >> 1_test_output_$(printf %06d $executing_ix).csv
   done < ${array[executing_ix]}
done

# process the files (select only the timestamp and the satisfaction value)
echo '- selecting only the timestamp and the reward value...'
for (( executing_ix=0; executing_ix < (file_ix + 1); executing_ix++))
do 
	filename=${array[executing_ix]}
	echo $filename

   while IFS=";" read a b c d e; do
	echo $a ";" $e | sed -e 's/\<Mbps\>//g' >> ${array_original[executing_ix]}.csv
   done < 1_${array[executing_ix]}
done

# remove the created auxiliary files
echo '- removing auxiliary files...'
for (( executing_ix=0; executing_ix < (file_ix + 1); executing_ix++))
do 
    rm test_output_$(printf %06d $executing_ix).csv
    rm 1_test_output_$(printf %06d $executing_ix).csv
done

echo '- done!'
