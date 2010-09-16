$(document).ready(function() {

	$(function(){
		$.fn.supersized.options = {  
			startwidth: 1024,  
			startheight: 764,
			vertical_center: 1,
			slideshow: 0
		};
        $('#supersize').supersized(); 
    });

	Cufon.replace('.museo_font');  

});