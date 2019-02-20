#!/bin/sh
# print "processes per user" bar chart
# source: blog.sleeplessbeastie.eu/2014/11/25/how-to-create-simple-bar-charts-in-terminal-using-awk/
# Debian/GNU awk: /usr/bin/awk -> /etc/alternatives/awk -> /usr/bin/gawk

# get usernames
IFS=
user_processes=`cat $1`

# character used to print bar chart
barchr="+"

# current min, max values [from 'ps' output]
vmin=0
echo "vmin:$vmin"
vmax=$(echo "$user_processes" | awk 'BEGIN {max=0} {if($2>max) max=$2} END {print max}')
echo "vmax:$vmax"

# range of the bar graph
dmin=1
dmax=80-5

# color steps
cstep1="\033[32m"
cstep2="\033[33m"
cstep3="\033[31m"
cstepc="\033[0m"

# generate output
echo "$user_processes" | awk -v dmin="$dmin" -v dmax="$dmax" \
                             -v vmin="$vmin" -v vmax="$vmax" \
                             -v cstep1="$cstep1" -v cstep2="$cstep2" -v cstep3="$cstep3" -v cstepc="$cstepc"\
                             -v barchr="$barchr" \
                             'BEGIN {
                                printf("%15s %7s %2s%54s\n","key","value","|<", "bar chart >|")
                              }
                              {
                                x=int(dmin+($2-vmin)*(dmax-dmin)/(vmax-vmin));
                                printf("%15s %7s ",$1,$2);
                                for(i=1;i<=x;i++)
                                {
                                    if (i >= 1 && i <= int(dmax/3))
                                      {printf(cstep1 barchr cstepc);}
				                    else if (i > int(dmax/3) && i <= int(2*dmax/3))
                                      {printf(cstep2 barchr cstepc);}
                                    else
                                      {printf(cstep3 barchr cstepc);}
                                };
                                print ""
                              }'
