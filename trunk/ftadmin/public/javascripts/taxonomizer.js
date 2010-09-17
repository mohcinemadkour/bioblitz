
		var first = false;
		var overMain = false;
		var viewer = null;
		var observation=null;
		var animals = null;

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
				$('#text_input').focusin(function(){
					overMain = true;
				});
				$('#text_input').focusout(function(){
					overMain = false;
				});
		}

		function displayObservation(zoomitId) {
				Seadragon.Config.proxyUrl = "/api/proxy?url=";
		    viewer.openDzi('http://cache.zoom.it/content/'+zoomitId+'.dzi');
				viewer.addEventListener("animationfinish", setTimeout("showElements('Loading...')",2000));
				if (!first) {
					setTimeout(function(ev){
						if (!first) first=true;
					},8000);
				}
		}


		function getNextObservationForIdentification() {

        //Here we have to check if there is no pending images and tell them THANKS but come back later.
        sql="select ROWID,observedBy,dateTime,latitude,longitude,occurrenceRemarks,verbatimLocality,zoomitId from 225363 WHERE zoomitId not equal to '' ORDER BY numIdentifications ASC LIMIT 1";
          $.ajax({
  	        url: "http://tables.googlelabs.com/api/query?sql="+escape(sql),
  	        dataType: "jsonp",
  	        jsonp: "jsonCallback",
  	        error: function(msg) {
  	            //console.log(msg);
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
						if (observation.observedBy != '') {
							$('p#observedBy').text('Image by '+ observation.observedBy);
						}
						if (observation.latitude!='') {
$('p#observedBy').append(' at '+'<a target="_blank" href="http://maps.google.com/?q='+observation.latitude+','+observation.longitude+'" style="color:white;">'+Number(observation.latitude).toFixed(4)+', '+Number(observation.longitude).toFixed(4)+'</a>');
						}
               displayObservation(pics[0]);
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
			if (first) {
				if (overMain) {
					$('div#main_container').fadeTo("fast",1);
				} else {
					$('div#main_container').fadeTo("fast",0.5);
				}
			} else {
				$('div#main_container').fadeTo("fast",1);
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

		function getNextImage() {
			hideElements();
			$('#text_input').focusout();
			getNextObservationForIdentification();
		}
		
		
		function sendUnknownAnimal(event) {
			var animal = $('#text_input').attr('value');
			if (animal!='Enter scientific name here' && animal!='') {
					if (animals!=null && animals.length>0) {
						var indexAnimalResults = sameAsResult($('#text_input').attr('value'));
						if (indexAnimalResults != null) {
							$('.ac_results').hide();
							sendOccurrence(indexAnimalResults);
						} else {
							$('#tooltip_title').html('Did you mean “<a href="javascript:void sendOccurrence(0)">'+animals[0].data.s+'</a>”?');
							$('#tooltip_button').text('Yes');
							$('#tooltip_button').attr('href','javascript:void sendOccurrence(0)');
							$('#second_button').text("No, I mean “"+$('#text_input').attr('value')+"”");
							$('#second_button').attr('href','javascript:void sendOwnScientificName()');
							$('#tooltip').fadeTo("fast",1);
						}
					} else {
						$('#tooltip_title').text('Do you want to send this?');
						$('#tooltip_button').text('No');
						$('#tooltip_button').attr('href','javascript:void hideTooltip()');
						$('#second_button').text("Yes, It's my decision");
						$('#second_button').attr('href','javascript:void sendOwnScientificName()');
						$('#tooltip').fadeTo("fast",1);
					}
			}
		}
		
		function hideTooltip() {
			$('#tooltip').fadeTo("fast",0);
		}
		
		
		function sendOwnScientificName() {
			$.get('/api/provide_identification?username='+escape($('#username').text())+'&rowid='+ observation.rowid + '&scientificName=' + $('#text_input').attr('value'), function(data) {});
			getNextImage();
			$('#tooltip').hide();
		}
		
		function sendOccurrence(index) {
			$.get('/api/provide_identification?username='+escape($('#username').text())+'&rowid='+ observation.rowid + '&id=' + animals[index].data.id, function(data) {});
			getNextImage();
			$('#tooltip').hide();
		}
		
		
		function sameAsResult(name) {
			for (var i=0; i<animals.length; i++) {
				if (animals[i].data.s == name) {
					return i;
				}
			}
			
			return null;
		}
		




