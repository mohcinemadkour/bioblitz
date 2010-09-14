	var viewer = null;
	var observation=null;

	function init() {
			viewer = new Seadragon.Viewer("container");
			viewer.clearControls();
			createLoading();
			createOverlayObjects();
      getNextObservationForIdentification();            
	}
	
	function displayObservation() {
	    $.ajax({
	        url: "http://api.zoom.it/v1/content/?url=" + escape(observation.associatedMedia[0]),
	        dataType: "jsonp",
	        success: function(resp) {
	           	if (resp.error) {
								console.log(resp.error);
			        	return;
			    		}

			    		var content = resp.content;
			    		var dzi = content.dzi;

			    		if (content.ready && dzi) {
								Seadragon.Config.proxyUrl = "/api/proxy?url=";
			      		viewer.openDzi(dzi.url);
								viewer.addEventListener("animationfinish", setTimeout("showElements()",2000));
								
			    		} else if (content.failed) {
			        	alert(content.url + " failed to convert.");
			    		} else {
			        	alert(content.url + " is " + Math.round(100 * content.progress) + "% done.");
			    		}
		  
	        }
					
	    });
	}
	
	
	function getNextObservationForIdentification() {
	    //Here we need to do some loading while we retrieve the next identification
	    
	    
        //First we get the total amount of pending identifications
        var sql="select COUNT() from 225363 WHERE identificationRequested contains ignoring case 'Yes' AND associatedMedia not equal to ''";
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
	            sql="select ROWID,observedBy,dateTime,latitude,longitude,occurrenceRemarks,verbatimLocality,associatedMedia from 225363 WHERE identificationRequested contains ignoring case 'Yes' AND associatedMedia not equal to '' OFFSET "+randomRecord +" LIMIT 1";
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
    	                    associatedMedia:pics,
    	                };
    	                console.log(observation);
    	                displayObservation();
    	            }
    	        });
	        }
	    });
	}
	
	function zoom_in() {
		viewer.viewport.zoomTo(viewer.viewport.getZoom()+0.5);
	}
	
	
	function zoom_out() {
		if (viewer.viewport.getZoom()-1>0) {
	    viewer.viewport.zoomTo(viewer.viewport.getZoom()-0.5);
		}
	}
	
	function showElements() {
		$('div#loading_container').fadeOut();
		$('div#main_container').fadeIn();
		$('a#vizzuality').fadeIn();
		$('div#image_info_container').fadeIn();
		$('div#zoom_container').fadeIn();
	}


	function hideElements() {
		$('div#main_container').fadeOut();
		$('a#vizzuality').fadeOut();
		$('div#image_info_container').fadeOut();
		$('div#zoom_container').fadeOut();
	}



	
	