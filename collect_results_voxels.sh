echo file,time,memory,fixed,moving,error

for file in logs/*.o*
do
   echo $file,$(grep "Total elapsed" $file | cut -d":" -f2 | tr -d '[:space:]'),$(grep Maximum $file | cut -d":" -f2 | tr -d '[:space:]'),$(PrintHeader $(grep "fixed image" $file | grep -v "and"| uniq | cut -d":" -f2 | tr -d '[:space:]') 2 | sed 's/x/\*/g' | bc),\
$(PrintHeader $(grep "moving image" $file | grep -v "and"| uniq | cut -d":" -f2 | tr -d '[:space:]') 2 | sed 's/x/\*/g' | bc),$(grep -i error $file)
done
