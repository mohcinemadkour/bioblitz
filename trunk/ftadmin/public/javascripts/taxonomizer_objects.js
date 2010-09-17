


	function createLoading() {
		var loading_container = document.createElement("div");
		loading_container.style.position = "absolute";
		loading_container.style.display = "block";
		loading_container.id = "loading_container";
		loading_container.style.height = "125px";
		loading_container.style.width = "125px";
		loading_container.style.padding = "0";
	 	loading_container.style.margin = "-75px 0 0 -75px";
	 	loading_container.style.background = "url(images/loading_bkg_.png) no-repeat 0 0";
	 	loading_container.style.top = "50%";
	 	loading_container.style.left = "50%";
		loading_container.style.zIndex = "100";
		
		var state = document.createElement("p");
		state.style.position = "absolute";
		state.id = "state";
		state.innerHTML = "Loading...";
		state.style.top = "18px";
		state.style.width = "125px";
		state.style.textAlign = "center";
		state.style.letterSpacing = "-1px";
		state.style.left = "0";
	 	state.style.padding = "0";
	 	state.style.margin = "0";
	 	state.style.font = "normal 21px Arial";
	 	state.style.color = "white";
		loading_container.appendChild(state);		
		
		
		var spinning = document.createElement("img");
		spinning.style.position = "absolute";
		spinning.style.top = "60px";
		spinning.style.left = "46px";
	 	spinning.style.padding = "0";
	 	spinning.style.margin = "0";
		spinning.src = "images/big_loader.gif";
		loading_container.appendChild(spinning);

		viewer.addControl(loading_container);
	}




	function createOverlayObjects() {
		
		//Create vizzuality logo
		var vizzuality = document.createElement("a");
   	vizzuality.href = "http://www.vizzuality.com";
	 	vizzuality.target = "_blank";
		vizzuality.id = "vizzuality";
		vizzuality.style.display = "none";
	 	vizzuality.style.position = "absolute";
	 	vizzuality.style.padding = "0";
	 	vizzuality.style.margin = "0";
	 	vizzuality.style.bottom = "10px";
	 	vizzuality.style.left = "10px";
	 	vizzuality.style.background = "url(../images/vizzuality_color.png) no-repeat 0 0";
	 	vizzuality.style.height = "40px";
	 	vizzuality.style.width = "75px";
		viewer.addControl(vizzuality);
		
		
		//Zoom container
		var zoom_container = document.createElement("div");
		zoom_container.style.position = "absolute";
		zoom_container.style.display = "none";
		zoom_container.id = "zoom_container";
		zoom_container.style.height = "106px";
		zoom_container.style.width = "48px";
		zoom_container.style.padding = "0";
	 	zoom_container.style.margin = "0";
	 	zoom_container.style.top = "30px";
	 	zoom_container.style.left = "30px";
		zoom_container.style.zIndex = "100";
		
		//Zoom in Taxxonomaizer
		var zoomIn = document.createElement("a");
   	zoomIn.href = "javascript:void zoom_in()";
	 	zoomIn.style.position = "absolute";
	 	zoomIn.style.padding = "0";
	 	zoomIn.style.margin = "0";
		zoomIn.style.top = '0';
		zoomIn.style.left = '0';
	 	zoomIn.style.background = "url(../images/zoomIn.png) no-repeat 0 0";
	 	zoomIn.style.height = "48px";
	 	zoomIn.style.width = "48px";
		$(zoomIn).hover(function(ev){
			$(this).css('background-position','0 -48px');
		},function(ev){
			$(this).css('background-position','0 0');
		});
		zoom_container.appendChild(zoomIn);
		
		
		//Zoom out Taxxonomaizer
		var zoomOut = document.createElement("a");
   	zoomOut.href = "javascript:void zoom_out()";
	 	zoomOut.style.position = "absolute";
	 	zoomOut.style.padding = "0";
	 	zoomOut.style.margin = "0";
		zoomOut.style.top = '60px';
		zoomOut.style.left = '0px';
	 	zoomOut.style.background = "url(../images/zoomOut.png) no-repeat 0 0";
	 	zoomOut.style.height = "48px";
	 	zoomOut.style.width = "48px";
		$(zoomOut).hover(function(ev){
			$(this).css('background-position','0 -48px');
		},function(ev){
			$(this).css('background-position','0 0');
		});
		zoom_container.appendChild(zoomOut);
		viewer.addControl(zoom_container);



		//Top right container
		var image_info_container = document.createElement("div");
		image_info_container.style.position = "absolute"; 	
		image_info_container.style.height = "48px";
		image_info_container.style.width = "250px";
	 	image_info_container.style.top = "30px";
	 	image_info_container.style.right = "30px";
		image_info_container.style.zIndex = "100";	
		image_info_container.style.display = "none";
		image_info_container.id = "image_info_container";

		
		//Next image
		var next = document.createElement("a");
   	next.href = "javascript:void getNextImage()";
	 	next.style.position = "absolute";
	 	next.style.padding = "0";
	 	next.style.margin = "0";
	 	next.style.top = "0";
	 	next.style.right = "0";
		next.style.zIndex = "100";
	 	next.style.background = "url(../images/next.png) no-repeat 0 0";
	 	next.style.height = "48px";
	 	next.style.width = "48px";
		$(next).hover(function(ev){
			$(this).css('background-position','0 -48px');
		},function(ev){
			$(this).css('background-position','0 0');
		});
		image_info_container.appendChild(next);
		
		
		//Image info
		// var image_info = document.createElement("a");
		//    image_info.href = "#";
		// 	 	image_info.style.position = "absolute";
		// 	 	image_info.style.padding = "0";
		// 	 	image_info.style.margin = "0";
		// 	 	image_info.style.top = "0";
		// 	 	image_info.style.right = "60px";
		// 		image_info.style.zIndex = "100";
		// 	 	image_info.style.background = "url(../images/image_info.png) no-repeat 0 0";
		// 	 	image_info.style.height = "48px";
		// 	 	image_info.style.width = "48px";
		// 		$(image_info).hover(function(ev){
		// 			$(this).css('background-position','0 -48px');
		// 		},function(ev){
		// 			$(this).css('background-position','0 0');
		// 		});
		// 		image_info_container.appendChild(image_info);
		viewer.addControl(image_info_container);		
		
		
		
		
		//Main container
		var main_container = document.createElement("div");
		main_container.style.position = "absolute"; 
		main_container.style.bottom = "170px";
		main_container.style.left = "50%";
		main_container.style.margin = "0 0 0 -373px";	
		main_container.style.height = "125px";
		main_container.style.width = "746px";
		main_container.style.padding = "0";
		main_container.style.background = "url(../images/main_bkg.png) no-repeat 0 0";
		main_container.style.display = "none";
		main_container.id = "main_container";
		$(main_container).hover(function(ev){
			overMain = true;
			$(this).stop().fadeTo("fast",1);
		},function(ev){
			if (!first) {
				$(this).stop().fadeTo("fast",1);
			} else {
				if (!$('.ac_results').is(':visible') && !overMain) {
					$('#main_container').stop().fadeTo("slow",0.5);
				}
			}
		});
		
		var logo = document.createElement('img');
		logo.src = "../images/taxonomizer.png";
		logo.style.position = "absolute";
		logo.style.top = "34px";
		logo.style.left = "20px";
		main_container.appendChild(logo);
		
		
		var title = document.createElement('h1');
		title.innerHTML = "Can you recognize this specie?";
		title.style.position = "absolute";
		title.style.padding = "0";
		title.style.margin = "0";
		title.style.font = "normal 17px Arial";
		title.style.color = "white";
		title.style.textShadow = "#000000 0 -1px";
		title.style.top = "20px";
		title.style.left = "222px";		
		main_container.appendChild(title);
		
		var skip_image = document.createElement("a");
   	skip_image.href = "javascript:void getNextImage()";
		skip_image.innerHTML = "No, skip this image";
	 	skip_image.style.position = "absolute";
	 	skip_image.style.padding = "0";
	 	skip_image.style.margin = "0";
	 	skip_image.style.textDecoration = "underline";
	 	skip_image.style.top = "18px";
	 	skip_image.style.right = "20px";
		skip_image.style.zIndex = "100";
		skip_image.style.font = "normal 13px Arial";
		skip_image.style.color = "white";
		$(skip_image).hover(function(ev){
			$(this).css('color','#999999');
		},function(ev){
			$(this).css('color','white');
		});
		main_container.appendChild(skip_image);
		
		
		
		var form = document.createElement("form");
		form.style.width = "502px";
		form.style.height = "38px";
		form.style.position = "absolute";
		form.style.right = "19px";
		form.style.top = "48px";
		form.action = "javascript:void sendUnknownAnimal()";
		main_container.appendChild(form);
		
		//Confirmation tooltip
		var tooltip = document.createElement("div");
		tooltip.id = "tooltip";
		tooltip.style.width = "277px";
		tooltip.style.height = "84px";
		tooltip.style.position = "absolute";
		tooltip.style.float = "left";
		tooltip.style.padding = "15px 15px 0 15px";
		tooltip.style.right = "160px";
		tooltip.style.bottom = "59px";
		tooltip.style.zIndex = "10000";
		tooltip.style.background = "url(../images/send_tooltip.png) no-repeat 0 0";
		
		
		//Confirmation tooltip
		var tooltip_title = document.createElement("p");
		tooltip_title.id = "tooltip_title";
		tooltip_title.innerHTML = "Did you mean “Luzula luzuloides”?";
		tooltip.appendChild(tooltip_title);
		
		var tooltip_button = document.createElement("a");
		tooltip_button.innerHTML = "Yes";
		tooltip_button.id = "tooltip_button";
		tooltip_button.href = "javascript: void alert('jamon')";
		tooltip.appendChild(tooltip_button);
		
		var second_button = document.createElement("a");
		second_button.innerHTML = 'No, I mean "Paco"';
		second_button.id = "second_button";
		second_button.href = "javascript: void alert('jamon')";
		tooltip.appendChild(second_button);
		
		main_container.appendChild(tooltip);

		
		var spinning = document.createElement("img");
		spinning.style.position = "absolute";
		spinning.style.zIndex = "1000";
		spinning.style.display = "none";
		spinning.id = "spinning";
		$(spinning).addClass('loader');
		spinning.style.top = "11px";
		spinning.style.right = "108px";
	 	spinning.style.padding = "0";
	 	spinning.style.margin = "0";
		spinning.src = "images/ajax-loader.gif";
		form.appendChild(spinning);
		
		
		var text_input = document.createElement("input");
		text_input.style.position = "absolute";
		text_input.id = "text_input";
		text_input.style.top = "0";
		text_input.style.left = "0";
	 	text_input.style.padding = "10px";
	 	text_input.style.margin = "0";
	 	text_input.style.width = "386px";
	 	text_input.style.height = "18px";
	 	text_input.style.border = "none";
		text_input.style.background = "url(../images/text_input_bkg.png) no-repeat 0 0";
	 	text_input.style.font = "normal 17px Arial";
	 	text_input.style.color = "#999999";
		text_input.type = "text";
		text_input.value = "Enter scientific name here";
		form.appendChild(text_input);

		
		
		var submit_input = document.createElement("input");
		submit_input.style.position = "absolute";
		submit_input.style.top = "0";
		submit_input.style.right = "0";
	 	submit_input.style.padding = "9px 10px 11px 10px";
	 	submit_input.style.margin = "0";
	 	submit_input.style.width = "98px";
	 	submit_input.style.height = "38px";
	 	submit_input.style.border = "none";
	 	submit_input.style.textAlign = "center";
	 	submit_input.style.letterSpacing = "-1px";
		submit_input.style.textShadow = "#000000 0 -1px";
		submit_input.style.background = "url(../images/send_button.png) no-repeat right 0";
	 	submit_input.style.font = "bold 19px Arial";
	 	submit_input.style.color = "white";
		submit_input.type = "submit";
		submit_input.value = "Send";
		$(submit_input).hover(function(ev){
			$(this).css('background-position','0 -40px');
			$(this).css('cursor','pointer');
		},function(ev){
			$(this).css('background-position','0 0');
			$(this).css('cursor','default');
		});
		form.appendChild(submit_input);		
		
		
		var image_by = document.createElement("p");
		image_by.style.position = "absolute";
		image_by.id = "observedBy";
		image_by.style.bottom = "13px";
		image_by.style.left = "222px";
	 	image_by.style.padding = "0";
	 	image_by.style.margin = "0";
	 	image_by.style.font = "normal 11px Arial";
	 	image_by.style.color = "white";
		main_container.appendChild(image_by);		

		viewer.addControl(main_container);

		
		//Images carousel
		var carousel = document.createElement("div");
		carousel.style.position = "absolute"; 
		carousel.style.display = "none"; 
		carousel.style.bottom = "10px";
		carousel.style.left = "50%";
		carousel.style.margin = "0";	
		carousel.style.height = "125px";
		carousel.style.padding = "0 0 0 10px";
		carousel.style.background = "url(../images/carousel_left.png) no-repeat 0 0";
		carousel.id = "carousel";
		
		
		var inner_carousel = document.createElement("span");
		inner_carousel.style.position = "relative"; 
		inner_carousel.style.float = "left"; 
		inner_carousel.style.bottom = "0";
		inner_carousel.style.left = "0";
		inner_carousel.style.top = "0";
		inner_carousel.style.margin = "0";	
		inner_carousel.style.height = "105px";
		inner_carousel.style.padding = "10px 10px 10px 0";
		inner_carousel.style.background = "url(../images/carousel_right.png) no-repeat right 0";
		inner_carousel.style.display = "block";
		inner_carousel.style.overflow = "hidden";
		inner_carousel.id = "inner_carousel";
		carousel.appendChild(inner_carousel);		
		
		
		viewer.addControl(carousel);



		$('#text_input').focus().autocomplete('http://bioblitz.ipq.co/api/taxonomy?',{
					dataType: 'jsonp',
					parse: function(data){
                      animals = new Array();
                      gbif_data = data;

                      for(var i=0; i<gbif_data.length; i++) {
                        animals[i] = {data: gbif_data[i], value: gbif_data[i].s, result: gbif_data[i].s };
                      }
											console.log(animals);
                      return animals;
					}, 
					formatItem: function(row, i, n, value, term) {
								
						var menu_string = '<p style="float:left;width:100%;font:normal 15px Arial;">' + value.replace(new RegExp("(?![^&;]+;)(?!<[^<>]*)(" + term.replace(/([\^\$\(\)\[\]\{\}\*\.\+\?\|\\])/gi, "\\$1") + ")(?![^<>]*>)(?![^&;]+;)", "gi"), "<strong>$1</strong>") + '</p>';
						menu_string += '<div class="taxonomy"><p class="first">'+row.k+'</p><p>'+row.p+'</p><p>'+row.c+'</p><p>'+row.o+'</p><p class="last">'+row.f+'</p></div>';
						return menu_string;
		      },					
					width: 404,
					height: 159,
					minChars: 4,
					max: 3,
					selectFirst: false,
					loadingClass: 'loader',
					multiple: false,
					scroll: false
				}).result(function(event,row){
					$.get('/api/provide_identification?username='+escape($('#username').text())+'&rowid='+ observation.rowid + '&id=' + row.id, function(data) {});
					getNextImage();
				});
				

	}
	
	
	
	
	