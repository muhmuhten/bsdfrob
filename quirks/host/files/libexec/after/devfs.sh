#devfsrules_hide_all=1
# pointless, just don't even bother mounting /dev

#devfsrules_unhide_basic=2
devfs rule -s 2 delset
devfs rule -s 2 add path null unhide
devfs rule -s 2 add path zero unhide
devfs rule -s 2 add path random unhide
devfs rule -s 2 add path urandom unhide

#devfsrules_unhide_login=3
#devfs rule -s 3 delset
#devfs rule -s 3 add path '[pt]ty[l-sL-S][0-9a-v]' unhide
#devfs rule -s 3 add path ptmx unhide
#devfs rule -s 3 add path pts unhide
#devfs rule -s 3 add path 'pts/*' unhide
#devfs rule -s 3 add path fd unhide
#devfs rule -s 3 add path 'fd/*' unhide
#devfs rule -s 3 add path stdin unhide
#devfs rule -s 3 add path stdout unhide
#devfs rule -s 3 add path stderr unhide

#devfsrules_jail=4
devfs rule -s 4 delset
devfs rule -s 4 add hide
devfs rule -s 4 add include 2
devfs rule -s 4 add path fd unhide
devfs rule -s 4 add path pts unhide
devfs rule -s 4 add path zfs unhide
devfs rule -s 4 add path '*/*' unhide
devfs rule -s 4 add path 'std*' unhide
