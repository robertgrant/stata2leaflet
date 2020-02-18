{smcl}
{* *! version 1.2.1  07mar2013}{...}
{cmd:help stata2leaflet} {...}
{hline}

{title:Title}

{cmd :stata2leaflet} {hline 2} Produce interactive online maps using the Leaflet JavaScript library


{title:Syntax}

{p 8 12 2}
{cmd:stata2leaflet} {it:latitudevar} {it:longitudevar} {it:labelvar} {cmd:, token(string)} [{it:{help stata2leaflet##options:options}}]


{synoptset 24 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Main}
{synopt :{opt token(string)}}You must supply a Mapbox API token; this is a long string identifying you to the Mapbox.com server, so you can download map tiles. To get it, you should sign up for a (free) account at mapbox.com, click on Tokens, then Create A Token, and copy the text that comes up.{p_end}
{synopt :{opt maph:eight(#)}}map height in pixels, default 480{p_end}
{synopt :{opt mapw:idth(#)}}map width in pixels, default 600{p_end}
{synopt :{opt maph:eight(#)}}map height in pixels, default 480{p_end}
{synopt :{opt mapw:idth(#)}}map width in pixels, default 600{p_end}
{synopt :{opt maplat(#)}}latitude at map center; default is mean of data{p_end}
{synopt :{opt maplong(#)}}longitude at map center; default is mean of data{p_end}
{synopt :{opt mapzoom(#)}}integer zoom as defined by leafletjs.com{p_end}
{synopt :{opt popup(varname)}}numeric variable controls whether popups appear for specific data points: zero means no popup, otherwise one is added{p_end}
{synopt :{opt mcolor(string)}}controls color of markers for all data points{p_end}
{synopt :{opt mcolorvar(varname)}}string variable defining colors of individual markers{p_end}
{synopt :{opt filename(filename)}}string filename to write to; .html extension will be added if no extension is given; default is index.html{p_end}
{synopt :{opt replace}}overwrite HTML file of same name if present{p_end}
{synopt :{opt nocom:ments}}suppress explanatory annotations in the HTML file (these are not visible to viewers unless they actively choose to view the source code){p_end}
{synopt :{opt title(titletext)}}writes {it:titletext} above the map in an HTML <h1> tag (large, bold font){p_end}
{synopt :{opt caption(captiontext)}}writes {it:captiontext} below the map in an HTML <p> tag (normal font){p_end}

{synoptline}
{p2colreset}{...}
{p 4 6 2}
{opt weight}s are not allowed, nor (at present) {opt if} and {opt in}.


{title:Description}

{pstd}
{cmd:stata2leaflet} writes an HTML file that can be uploaded or viewed locally in a web browser. It will contain only the title and caption (if specified) and an interactive (clickable, zoomable) map.

{pstd}
The resulting HTML file contains the instructions to display the map (including the data) with a marker and pop-up label for each observation in the Stata data file.

{pstd}
Internet access is necessary to obtain the background map images, so URLs are included
to obtain the leaflet JS and CSS files, as well as picture files for the colored
markers, which are stored on the author's website for your convenience.

{pstd}
These can also be saved locally if you are comfortable editing the HTML to point to them.
See leafletjs.com and github.com/shramov/leaflet-plugins for more details on the
leaflet JavaScript library.


{marker options}{...}
{title:Options}
{dlgtab:Main}

{p 4 8}
{opt mapzoom} Requires an integer, usually between 3 and 11. The default is to fit all data plus half of the range above and below the extremes in latitude and longitude.

{p 4 8}
{opt mcolorvar(varname)} String variable defining different marker colors. At present, it can contain values "blue", "red", "yellow", "green" "grey", "gray", "orange" or "purple". Any other values will result in a grey marker.

{p 8 8}
If neither {opt mcolor()} nor {opt mcolorvar()} are specified, the default marker
color is blue. If both {opt mcolor()} and {opt mcolorvar()} are specified, {opt mcolorvar()} takes precedence. {p_end}


{marker remarks}{...}
{title:Remarks}

{p 4 4}
This is version 0.1 of stata2leaflet. You can find out more about it at the author's webpage http://www.robertgrantstats.co.uk/software

{p 4 4}
{it:latitudevar} and {it:longitudevar} should be provided in degrees (North and East are positive, South and West are negative), with minutes and seconds converted to decimal places.

{p 4 4}
A string {it:labelvar} must be provided, even if it is blank throughout. To include a line break in the pop-up labels, add

{p 4 4}
<br>

{p 4 4}
to {it:labelvar} at the point where you want the break. Those familiar with
HTML will realise this tag is written verbatim to the output file and then interpreted
in the browser, and so you can include other formatting to the popup text, or the
title or caption, this way if you know what tags to use.


{marker examples}{...}
{title:Example}

{phang}{cmd:. // draw 5 random points in the south of England, with popups}{p_end}
{phang}{cmd:. clear}{p_end}
{phang}{cmd:. set obs 5}{p_end}
{phang}{cmd:. gen mlat=rnormal(51.5,0.2)}{p_end}
{phang}{cmd:. gen mlong=rnormal(-1.5,0.1)}{p_end}
{phang}{cmd:. gen nn=_n}{p_end}
{phang}{cmd:. gen str8 mlab="Point "+string(nn)}{p_end}
{phang}{cmd:. drop nn}{p_end}
{phang}{cmd:. gen mcol="red"}{p_end}
{phang}{cmd:. replace mcol="purple" in 2}{p_end}
{phang}{cmd:. replace mcol="green" in 3}{p_end}
{phang}{cmd:. stata2leaflet mlat mlong mlab, mcolorvar(mcol) replace nocomments ///}{p_end}
{phang}{cmd:.     title("Here's my new map") ///}{p_end}
{phang}{cmd:.     caption("Here's some more details")}{p_end}

{phang}This should look similar to the map displayed at www.robertgrantstats.co.uk/software{p_end}

{marker results}{...}
{title:Saved results}

{pstd}
{cmd:stata2leaflet} does not save anything.
