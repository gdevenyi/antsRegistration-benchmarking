echo file,time,memory,fixed,moving,error

for file in logs/*.o*
do
   echo $file,$(grep "Total elapsed" $file | cut -d":" -f2 | tr -d '[:space:]'),$(grep Maximum $file | cut -d":" -f2 | tr -d '[:space:]'),$(grep "fixed image" $file | grep -v "and"| uniq | cut -d":" -f2 | tr -d '[:space:]' | sed 's/brain._//g' | sed 's/.mnc//g'),\
$(grep "moving image" $file | grep -v "and"| uniq | cut -d":" -f2 | tr -d '[:space:]' | sed 's/brain._//g' | sed 's/.mnc//g'),$(grep -i error $file)
done
