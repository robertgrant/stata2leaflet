/* stata2leaflet v0.1 - regard this as an alpha test version!
   To do in version 0.2:
   Custom icons (maybe too much bother)
   Choropleth
   Legend
   layer control
   allow southwest & northeast corners instead of mapzoom
      
   http://www.robertgrantstats.co.uk/software
   published 5 June 2014
   */

capture program drop stata2leaflet
program stata2leaflet
version 11
syntax varlist(min=3 max=3) [, MAPHeight(integer 480) MAPWidth(integer 600) ///
							   MAPLAT(real 0.0) MAPLONG(real 0.0) MAPZOOM(integer 0) ///
							   POPUP(varname numeric) MCOLOR(string) MCOLORVAR(varname string) ///
							   FILEname(string) REPLACE NOCOMments TITLE(string) CAPTION(string)] 
tokenize `varlist'
// default map centre
if `maplat'==0 {
	qui summ `1'
	local maplat=r(mean)
}
if `maplong'==0 {
	qui summ `2'
	local maplong=r(mean)
}
// default map bounds
if `mapzoom'==0 {
	qui summ `1'
	local minlat=r(min)
	local maxlat=r(max)
	qui summ `2'
	local minlong=r(min)
	local maxlong=r(max)
	local sbound=`minlat'-((`maxlat'-`minlat')/2)
	local nbound=`maxlat'+((`maxlat'-`minlat')/2)
	local wbound=`minlong'-((`maxlong'-`minlong')/2)
	local ebound=`maxlong'+((`maxlong'-`minlong')/2)
	local mapview=".setView([`maplat',`maplong']).fitBounds([[`sbound',`wbound'],[`nbound',`ebound']]);"
}
else {
	local mapview=".setView([`maplat',`maplong'], `mapzoom')"
}
// default filename
if "`filename'"=="" {
	local filename="index.html"
}
tempvar icons
gen str20 `icons'=""
local nobs=_N

/* check and tidy up filename - allow users to have any file extension (I don't know why
   they would but it seems unnecessarily restrictive to force them to .htm / .html) */
if strpos("`filename'",".")==0 {
	local filename=("`filename'"+".html")
}

// capture block begins here to ensure that the file handle is always closed at the end
capture noisily {
// passes replace as an option
file open myfile using `filename', write text `replace'

// write header
	file write myfile "<head>" _n
// add comment
	if "`nocomments'"!="nocomments" {
		file write myfile _tab `"<!-- The links in the header bring in the leaflet styles from CSS and the JavaScript program behind it all. -->"' _n
	}
// add links to CSS and JS files
	file write myfile _tab `"<link rel="stylesheet" type="text/css" href="http://cdn.leafletjs.com/leaflet-0.6.4/leaflet.css" />"' _n
	file write myfile _tab `"<script src="http://cdn.leafletjs.com/leaflet-0.6.4/leaflet.js"></script>"' _n
	file write myfile `"</head>"' _n _n
	
	file write myfile `"<body>"' _n
	if "`nocomments'"!="nocomments" & "`title'"!="" {
		file write myfile _tab `"<!-- Insert the title -->"' _n
	}
	if "`title'"!="" {
		file write myfile _tab `"<h1 style="font-family:arial;">`title'</h1>"' _n
	}
	if "`nocomments'"!="nocomments" {
		file write myfile _tab `"<!-- First we create a div (section of the page) called map -->"' _n
	}
	file write myfile _tab `"<div id="map" style="height:`mapheight'px; width:`mapwidth'px;"><script type="text/javascript">"' _n
	if "`nocomments'"!="nocomments" {
		file write myfile _tab `"<!-- Then we get into the JavaScript, using the leaflet function L.map to set the center and zooming -->"' _n
	}
	// note that Stata doesn't like single quotes inside the JS, happily we can switch them for double quotes
// first, deal with any color icon specification:
	if "`mcolorvar'"!="" {
		file write myfile _tab(2) `"var MyIcon = L.Icon.extend({options: {iconSize:[25,41],iconAnchor:[12,40],popupAnchor:[0,-31],shadowUrl:"http://www.robertgrantstats.co.uk/software/marker-shadow.png"}});"' _n
		file write myfile _tab(2) `"var greenIcon = new MyIcon({iconUrl:"http://www.robertgrantstats.co.uk/software/marker-icon-green.png"});"' _n
		file write myfile _tab(2) `"var greyIcon = new MyIcon({iconUrl:"http://www.robertgrantstats.co.uk/software/marker-icon-grey.png"});"' _n
		file write myfile _tab(2) `"var orangeIcon = new MyIcon({iconUrl:"http://www.robertgrantstats.co.uk/software/marker-icon-orange.png"});"' _n
		file write myfile _tab(2) `"var purpleIcon = new MyIcon({iconUrl:"http://www.robertgrantstats.co.uk/software/marker-icon-purple.png"});"' _n
		file write myfile _tab(2) `"var redIcon = new MyIcon({iconUrl:"http://www.robertgrantstats.co.uk/software/marker-icon-red.png"});"' _n
		file write myfile _tab(2) `"var yellowIcon = new MyIcon({iconUrl:"http://www.robertgrantstats.co.uk/software/marker-icon-yellow.png"});"' _n
		file write myfile _tab(2) `"var blueIcon = new MyIcon({iconUrl:"http://www.robertgrantstats.co.uk/software/marker-icon.png"});"' _n
		replace `icons'=",{icon:"+`mcolorvar'+"Icon}"
	}
	else if "`mcolor'"!="" {
		file write myfile _tab(2) `"var MyIcon = L.Icon.extend({options: {iconSize:[25,41],iconAnchor:[12,40],popupAnchor:[0,-31],shadowUrl:"http://www.robertgrantstats.co.uk/software/marker-shadow.png"}});"' _n
		if "`mcolor'"=="green" {
			file write myfile _tab(2) `"var greenIcon = new MyIcon({iconUrl:"http://www.robertgrantstats.co.uk/software/marker-icon-green.png"});"' _n
			replace `icons'=",{icon:"+"`mcolor'"+"Icon}"
		}
		else if "`mcolor'"=="orange" {
			file write myfile _tab(2) `"var orangeIcon = new MyIcon({iconUrl:"http://www.robertgrantstats.co.uk/software/marker-icon-orange.png"});"' _n
			replace `icons'=",{icon:"+"`mcolor'"+"Icon}"
		}
		else if "`mcolor'"=="purple" {
			file write myfile _tab(2) `"var purpleIcon = new MyIcon({iconUrl:"http://www.robertgrantstats.co.uk/software/marker-icon-purple.png"});"' _n
			replace `icons'=",{icon:"+"`mcolor'"+"Icon}"
		}
		else if "`mcolor'"=="red" {
			file write myfile _tab(2) `"var redIcon = new MyIcon({iconUrl:"http://www.robertgrantstats.co.uk/software/marker-icon-red.png"});"' _n
			replace `icons'=",{icon:"+"`mcolor'"+"Icon}"
		}
		else if "`mcolor'"=="yellow" {
			file write myfile _tab(2) `"var yellowIcon = new MyIcon({iconUrl:"http://www.robertgrantstats.co.uk/software/marker-icon-yellow.png"});"' _n
			replace `icons'=",{icon:"+"`mcolor'"+"Icon}"
		}
		else if "`mcolor'"=="blue" {
			file write myfile _tab(2) `"var blueIcon = new MyIcon({iconUrl:"http://www.robertgrantstats.co.uk/software/marker-icon.png"});"' _n
			replace `icons'=",{icon:"+"`mcolor'"+"Icon}"
		}
		// anything else is grey (or indeed gray):
		else {
			file write myfile _tab(2) `"var greyIcon = new MyIcon({iconUrl:"http://www.robertgrantstats.co.uk/software/marker-icon-grey.png"});"' _n
			replace `icons'=",{icon:"+"grey"+"Icon}"
		}
	}
	// draw the map	
	file write myfile _tab(2) `"var map = L.map("map")`mapview';"' _n
	if "`nocomments'"!="nocomments" {
		file write myfile _tab(2) `"<!-- The images are obtained online using L.tileLayer... -->"' _n
	}
	// I have avoided single quotes in the attribution and just hard-typed it
	file write myfile _tab(2) `"L.tileLayer("http://{s}.tile.osm.org/{z}/{x}/{y}.png", { attribution: "&copy; OpenStreetMap contributors" }).addTo(map);"' _n
	if "`nocomments'"!="nocomments" {
		file write myfile _tab(2) `"<!-- ...and then markers are added using L.marker, with pop-up captions using .bindPopup -->"' _n
	}
	// place the individual markers
	forvalues i=1/`nobs' {
		local templat=round(`1'[`i'],0.00001)
		local templong=round(`2'[`i'],0.00001)
		local templab=`3'[`i']
		local tempicon=`icons'[`i']
		if "`popup'"!="" {
			if `popup'[`i']==0 file write myfile _tab(3) `"L.marker([`templat',`templong']).addTo(map);"' _n
			else file write myfile _tab(3) `"L.marker([`templat',`templong']`tempicon').addTo(map).bindPopup("`templab'");"' _n
		}
		else file write myfile _tab(3) `"L.marker([`templat',`templong']`tempicon').addTo(map).bindPopup("`templab'");"' _n
	}
	if "`nocomments'"!="nocomments" {
		file write myfile _tab `"<!-- The tags for JavaScript and the map div are closed off -->"' _n
	}
	file write myfile _tab `"</script></div>"' _n
	if "`nocomments'"!="nocomments" & "`caption'"!="" {
		file write myfile _tab `"<!-- Now insert the caption -->"' _n
	}
	if "`caption'"!="" {
		file write myfile _tab `"<p style="font-family:arial;">`caption'</p>"' _n
	}
	if "`nocomments'"!="nocomments" {
		file write myfile _tab `"<!-- Finally, the body tag is closed off -->"' _n
	}
	file write myfile `"</body>"' _n
	dis as result "`filename' successfully written"
}
file close myfile
end
