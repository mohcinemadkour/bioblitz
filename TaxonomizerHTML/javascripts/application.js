	var viewer = null;

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
			
			

			$.getJSONP = function (url, callback) {
			    return $.ajax({
			        url: url,
			        dataType: "jsonp",
			        success: callback
			    });
			};
		
			function onZoomitResponse(resp) {
					if (resp.error) {
							alert(resp.error);
			        return;
			    }

			    var content = resp.content;
			    var dzi = content.dzi;

			    if (content.ready && dzi) {
						Seadragon.Config.proxyUrl = "http://localhost:8888/proxy.php?url=";
			      viewer.openDzi(dzi.url);
			    } else if (content.failed) {
			        alert(content.url + " failed to convert.");
			    } else {
			        alert(content.url + " is " + Math.round(100 * content.progress) + "% done.");
			    }
			}

			$.getJSONP("http://api.zoom.it/v1/content/?url=" + 'http://farm3.static.flickr.com/2792/4136430964_bbdc1d96a2_o.jpg',onZoomitResponse);
	}
	
	
	function zoom_in() {
		viewer.viewport.zoomTo(viewer.viewport.getZoom()+0.5	);
	}
	
	
	function zoom_out() {
		if (viewer.viewport.getZoom()-1>0) {
	    viewer.viewport.zoomTo(viewer.viewport.getZoom()-0.5);
		}
	}
	