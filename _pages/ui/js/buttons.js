document.body.innerHTML = document.body.innerHTML.replace(/ghbutton/g, '<span class="label label-default" style="background-color:green; padding:1 2 1 2">GitHub</span>');
document.body.innerHTML = document.body.innerHTML.replace(/cranbutton/g, '<span class="label label-default" style="background-color:blue; padding:1 2 1 2">CRAN</span>');
document.body.innerHTML = document.body.innerHTML.replace(/pdfbutton/g, '<span class="label label-default" style="background-color:#c62326; padding:1 2 1 2">pdf</span>');
document.body.innerHTML = document.body.innerHTML.replace(/htmlbutton/g, '<span class="label label-default" style="background-color:#d36200; padding:1 2 1 2">html</span>');
document.body.innerHTML = document.body.innerHTML.replace(/livebutton/g, '<span class="label label-default" style="background-color:e87912; padding:1 2 1 2">live</span>');

var links = document.links;

for (var i = 0, linksLength = links.length; i < linksLength; i++) {
   if (links[i].hostname != window.location.hostname) {
       links[i].target = '_blank';
   } 
}
