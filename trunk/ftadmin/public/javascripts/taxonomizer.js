	var viewer = null;
	var observation=null;

	function init() {
			viewer = new Seadragon.Viewer("container");
			viewer.clearControls();
		
			//Create vizzuality logo
			var vizzuality = document.createElement("a");
	   	vizzuality.href = "http://www.vizzuality.com";
		 	vizzuality.target = "_blank";
		 	vizzuality.style.position = "relative";
		 	vizzuality.style.float = "left";
		 	vizzuality.style.padding = "0";
		 	vizzuality.style.margin = "0 0 10px 10px";
		 	vizzuality.style.background = "url(images/vizzuality.png) no-repeat 0 0";
		 	vizzuality.style.height = "40px";
		 	vizzuality.style.width = "75px";
			viewer.addControl(vizzuality, Seadragon.ControlAnchor.BOTTOM_LEFT);
			
			
			//Zoom container
			var zoom_container = document.createElement("div");
			zoom_container.style.position = "relative"; 	
			zoom_container.style.height = "106px";
			zoom_container.style.width = "48px";
			zoom_container.style.padding = "30px";
			
			
			//Zoom in Taxxonomaizer
			var zoomIn = document.createElement("a");
	   	zoomIn.href = "javascript:void zoom_in()";
		 	zoomIn.style.position = "relative";
		 	zoomIn.style.float = "left";
		 	zoomIn.style.padding = "0";
		 	zoomIn.style.margin = "0";
		 	zoomIn.style.background = "url(images/zoomIn.png) no-repeat 0 0";
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
		 	zoomOut.style.position = "relative";
		 	zoomOut.style.float = "left";
		 	zoomOut.style.padding = "0";
		 	zoomOut.style.margin = "10px 0 0 0";
		 	zoomOut.style.background = "url(images/zoomOut.png) no-repeat 0 0";
		 	zoomOut.style.height = "48px";
		 	zoomOut.style.width = "48px";
			$(zoomOut).hover(function(ev){
				$(this).css('background-position','0 -48px');
			},function(ev){
				$(this).css('background-position','0 0');
			});
			zoom_container.appendChild(zoomOut);
			viewer.addControl(zoom_container, Seadragon.ControlAnchor.TOP_LEFT);



			//Top right container
			var image_info_container = document.createElement("div");
			image_info_container.style.position = "relative"; 	
			image_info_container.style.height = "48px";
			image_info_container.style.width = "250px";
			image_info_container.style.padding = "30px";
		
			
			//Next image
			var next = document.createElement("a");
	   	next.href = "#";
		 	next.style.position = "relative";
		 	next.style.float = "right";
		 	next.style.padding = "0";
		 	next.style.margin = "0";
		 	next.style.background = "url(images/next.png) no-repeat 0 0";
		 	next.style.height = "48px";
		 	next.style.width = "48px";
			$(next).hover(function(ev){
				$(this).css('background-position','0 -48px');
			},function(ev){
				$(this).css('background-position','0 0');
			});
			image_info_container.appendChild(next);
			
			
			//Image info
			var image_info = document.createElement("a");
	   	image_info.href = "#";
		 	image_info.style.position = "relative";
		 	image_info.style.float = "right";
		 	image_info.style.padding = "0";
		 	image_info.style.margin = "0 10px 0 0";
		 	image_info.style.background = "url(images/image_info.png) no-repeat 0 0";
		 	image_info.style.height = "48px";
		 	image_info.style.width = "48px";
			$(image_info).hover(function(ev){
				$(this).css('background-position','0 -48px');
			},function(ev){
				$(this).css('background-position','0 0');
			});
			image_info_container.appendChild(image_info);
			viewer.addControl(image_info_container, Seadragon.ControlAnchor.TOP_RIGHT);		
			
			
			//Main container
			var main_container = document.createElement("div");
			main_container.style.position = "absolute"; 
			main_container.style.top = "65%";
			main_container.style.left = "50%";
			main_container.style.margin = "0 0 0 -373px";	
			main_container.style.height = "48px";
			main_container.style.width = "746px";
			main_container.style.padding = "108px";
			main_container.style.background = "url(images/main_bkg.png) no-repeat 0 0";
			viewer.addControl(main_container);		

            
            getNextObservationForIdentification();
            
			//
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
		viewer.viewport.zoomTo(viewer.viewport.getZoom()+0.5	);
	}
	
	
	function zoom_out() {
		if (viewer.viewport.getZoom()-1>0) {
	    viewer.viewport.zoomTo(viewer.viewport.getZoom()-0.5);
		}
	}
	