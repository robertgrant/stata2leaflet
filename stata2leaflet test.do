cd "C:\Users\ku52502\Dropbox\Visualization\interactive\leaflet"
clear
set obs 5
gen mlat=rnormal(51.5,0.2)
gen mlong=rnormal(-1.5,0.1)
gen nn=_n
gen str8 mlab="Point "+string(nn)
drop nn
gen mcol="red"
replace mcol="purple" in 2
replace mcol="green" in 3
stata2leaflet mlat mlong mlab, mcolorvar(mcol) replace nocomments ///
	title("Here's my new map") ///
	caption("Here's some more details")
