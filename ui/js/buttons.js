document.body.innerHTML = document.body.innerHTML.replace(/ghbutton/g, '<span class="label label-default" style="background-color:green">GitHub</span>');
document.body.innerHTML = document.body.innerHTML.replace(/cranbutton/g, '<span class="label label-default" style="background-color:blue">CRAN</span>');
document.body.innerHTML = document.body.innerHTML.replace(/pdfbutton/g, '<span class="label label-default" style="background-color:#c62326">pdf</span>');
document.body.innerHTML = document.body.innerHTML.replace(/htmlbutton/g, '<span class="label label-default" style="background-color:#d36200">html</span>');

var links = document.links;

for (var i = 0, linksLength = links.length; i < linksLength; i++) {
   if (links[i].hostname != window.location.hostname) {
       links[i].target = '_blank';
   } 
}
