#!/bin/bash
set -x

nodenames=$(oc get nodes | cut -d' ' -f1 | sed '1d')
consoleurl=$(oc whoami --show-console)
masterurl=$(oc cluster-info | head -n 1 | sed 's/.* //' | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2};?)?)?[mGK]//g")

for curnode in $nodenames; do
  echo "---$curnode"
  alternatenodes=$(echo "$nodenames" | grep -v $curnode)
  pingcommand=""
  for alternatenode in $alternatenodes; do
    pingcommand="${pingcommand}ping -w 5 $alternatenode;"
  done
  pingcommand="${pingcommand}ping -w 5 8.8.8.8"
cat <<EOF | oc debug node/$curnode
echo "     time_namelookup:  %{time_namelookup}s\n" > curldebug.txt
echo "        time_connect:  %{time_connect}s\n" >> curldebug.txt
echo "     time_appconnect:  %{time_appconnect}s\n" >> curldebug.txt
echo "    time_pretransfer:  %{time_pretransfer}s\n" >> curldebug.txt
echo "       time_redirect:  %{time_redirect}s\n" >> curldebug.txt
echo "  time_starttransfer:  %{time_starttransfer}s\n" >> curldebug.txt
echo "                     ----------\n" >> curldebug.txt
echo "          time_total:  %{time_total}s\n" >> curldebug.txt
echo "curling $consoleurl"
curl -w "@curldebug.txt" -o /dev/null -s "$consoleurl"
echo "curling $masterurl"
curl -w "@curldebug.txt" -o /dev/null -s "$masterurl"
eval $pingcommand
EOF
done

