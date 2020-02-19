# stata2leaflet
Output interactive maps using leaflet.js from Stata

This is a simple program which aims to get you started in making interactive maps in the browser. There are so may things you can do with the leaflet.js JavaScript library that there's little point in trying to have one Stata command that will offer them all; you'll have to learn how to program them in your own web page. But, this can create the skeleton for you.

The master branch here contains version 0.1, which was written in 2014 and uses the OpenStreetMap API to obtain the background map image. Since then, that API has changed. The mapbox-2020 branch does the same thing but with mapbox.com's API, for which you have to sign up and get a token (a long alphanumeric code which you supply, that identifies you when your computer requests the images from Mapbox). Mapbox is free as long as you don't use it thousands of times a month (so be careful if you are looping and things go wrong...). I suggest you use mapbox-2020. 

In due course, I have to decide how to combine these two into one. It might be nice to offer different APIs, but I want them to be free (for beginners) and stable. Some well-known mapping platforms based in Mountain View, CA (not naming no names) have been unhelpful in that regard over the years, as well as exhibiting untrustworthy attitudes to privacy, and I am not inclined to include them. But any other suggestions are welcome.

