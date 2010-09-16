
		var first = false;
		var overMain = false;
		var viewer = null;
		var observation=null;

		function init() {
				viewer = new Seadragon.Viewer("container");
				viewer.clearControls(); 
				Seadragon.Config.autoHideControls = false;
				createLoading();
				createOverlayObjects();
		    getNextObservationForIdentification();
		
		    $('#text_input').focus(function(ev){
					if ($(this).attr('value') == 'Enter scientific name here') {
						$(this).attr('value','');
					}
				});
		}

		function displayObservation(zoomitId) {
				Seadragon.Config.proxyUrl = "/api/proxy?url=";
		    viewer.openDzi('http://cache.zoom.it/content/'+zoomitId+'.dzi');
				viewer.addEventListener("animationfinish", setTimeout("showElements('Loading...')",2000));
		}


		function getNextObservationForIdentification() {
		    //Here we need to do some loading while we retrieve the next identification
    
		      //First we get the total amount of pending identifications
		      var sql="select COUNT() from 225363 WHERE zoomitId not equal to ''";
		      $.ajax({
		        url: "http://tables.googlelabs.com/api/query?sql="+escape(sql),
		        dataType: "jsonp",
		        jsonp: "jsonCallback",
		        error: function(msg) {
		            console.log(msg);
		        },
		        success: function(data) {
		            //Here we have to check if there is no pending images and tell them THANKS but come back later.
		            var numObserv=data.table.rows[0][0];            
		            var randomRecord = Math.floor(Math.random()*numObserv)
		            sql="select ROWID,observedBy,dateTime,latitude,longitude,occurrenceRemarks,verbatimLocality,zoomitId from 225363 WHERE zoomitId not equal to '' OFFSET "+randomRecord +" LIMIT 1";
		              $.ajax({
		      	        url: "http://tables.googlelabs.com/api/query?sql="+escape(sql),
		      	        dataType: "jsonp",
		      	        jsonp: "jsonCallback",
		      	        error: function(msg) {
		      	            console.log(msg);
		      	        },
		      	        success: function(data) {
		      	            var da = data.table.rows[0];
		      	            var pics = da[7].split(" ");
		  	                observation = {
		  	                    rowid:da[0],
		  	                    observedBy:da[1],
		  	                    dateTime:da[2],
		  	                    latitude:da[3],
		  	                    longitude:da[4],
		  	                    occurrenceRemarks:da[5],
		  	                    verbatimLocality:da[6],
														zoomitId: pics
		  	                };
												$('p#observedBy').text('Image by '+ observation.observedBy);
												$('p#observedBy').append(' at '+'<a target="_blank" href="http://maps.google.com/?q='+observation.latitude+','+observation.longitude+'" style="color:white;">'+Number(observation.latitude).toFixed(4)+', '+Number(observation.longitude).toFixed(4)+'</a>');
		  	                displayObservation(pics[0]);
		  	            }
		  	        });
		        }
		    });
		}



		function createCarousel(pics_array) {
			$('#inner_carousel').html('');
			for (var i=1; i<pics_array.length; i++) {
				var margin = '0';
				if (i!=1) {
					margin = '0 0 0 5px';
				}
				$('#inner_carousel').append('<a href="javascript:void visualize(\''+pics_array[i]+'\')" style="float:left; position:relative; height:95px; overflow:hidden; padding:4px; background:white; margin:'+margin+'; border:1px solid gray"><div style="float:left; height:95px; overflow:hidden;"><img src="http://cache.zoom.it/content/'+pics_array[i]+'_files/8/0_0.jpg"/></div></a>');
			}
			setTimeout(function(ev){
				var carousel_long = $('div#carousel').width();
				$('div#carousel').css('margin','0 0 0 -'+(carousel_long/2)+'px');
				$('div#carousel').fadeIn();
			},400);
		}



		function visualize(dziCode) {
			hideElements();
			changeImagePosition(dziCode);
			displayObservation(dziCode);
		}


		function changeImagePosition(element) {
			for (var i=0; i<observation.zoomitId.length; i++) {
				if (observation.zoomitId[i]==element) {
					observation.zoomitId.splice(i,1);
					break;
				}
			}
			observation.zoomitId.unshift(element);
			showElements('Changing...');
		}



		function zoom_in() {
			viewer.viewport.zoomTo(viewer.viewport.getZoom()+0.5);
		}


		function zoom_out() {
			if (viewer.viewport.getZoom()-1>0) {
		    viewer.viewport.zoomTo(viewer.viewport.getZoom()-0.5);
			}
		}

		function showElements(state) {
			$('p#state').text(state);
			$('div#loading_container').fadeOut(function(ev){
				if (observation.zoomitId.length>1) {
					createCarousel(observation.zoomitId);
				}
			});
			if (!first) {
				$('div#main_container').fadeIn();
				first = !first;
				if (!overMain) $('div#main_container').delay(5000).fadeTo("slow",0.5);
			} else {
				$('div#main_container').fadeTo("slow",0.5);
			}
			$('a#vizzuality').fadeIn();
			$('div#image_info_container').fadeIn();
			$('div#zoom_container').fadeIn();
		}


		function hideElements() {
			$('div#main_container').fadeOut(function(ev){
				$('#text_input').attr('value','Enter scientific name here');
			});
			$('a#vizzuality').fadeOut();
			$('div#image_info_container').fadeOut();
			$('div#zoom_container').fadeOut();
			$('div#loading_container').fadeIn();
			$('div#carousel').fadeOut();
		}

		function getNext() {
			hideElements();
			getNextObservationForIdentification();
		}




