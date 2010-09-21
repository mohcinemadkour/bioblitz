var chart;
$(document).ready(function() {
	
		
   chart = new Highcharts.Chart({
			chart: {
					renderTo: 'stats',
         	margin: [20,7,20,7],
         	zoomType: 'xy',
					backgroundColor:'#F2F2F2'
      },
	    legend: {enabled: false},
	    plotOptions: {column: {groupPadding: -0.1,borderWidth: 0, borderRadius: 2, shadow:false, borderColor:"#FF7700"}},
	    title: {text:""},
	    credits: {enabled: false},
		 	xAxis: [{ 
		         labels: {
		            formatter: function() {
		               return '';
		            },
		            style: {
		               color: '#89A54E'
		            }
		         },
		         title: {
		            text: '',
		            style: {
		               color: '#89A54E'
		            },
		            margin: 0
		         },
		        categories: ['']
		      }],
			yAxis: [{ // Primary yAxis
        lineColor: '#FF7700', 
				labels: {
            formatter: function() {
               return this.value;
            },
            style: {
               color: '#CCCCCC'
            },
						x: 5,
						y: -5,
						align: "left"
         },
         title: {
            text: '',
            style: {
               color: '#CCCCCC'
            },
            margin: 0
         }
      }, { // Secondary yAxis
				title: {
            text: '',
            margin: 0,
            style: {
               color: '#4572A7'
            }
         },
         labels: {
            formatter: function() {
               return this.value;
            },
            style: {
               color: '#999999'
            }	,
							x: 0,
							y: -5,
							align: "right"
         },
				 gridLineColor: '#CCCCCC',
				 gridLineWidth: 1,
         opposite: true
      }],
      series: [{
         name: '',
         type: 'column',
         yAxis: 1,
         data: [{name:'Kingdom', y: 13,color: {linearGradient: [0, 0, 0, 250], stops: [[0, 'rgba(153, 204, 10,1)'],[1, 'rgba(117,156,0,1)']]}}, 
								{name:'Kingdom', y: 23,color: '#FF9900'}, 
								{name:'Kingdom', y: 19,color: '#0099CC'}, 
								{name:'Kingdom', y: 13,color: '#9933CC'}, 
								{name:'Kingdom', y: 23,color: '#FF3399'}, 
								{name:'Kingdom', y: 19,color: '#333333'}]    
      }]
   });



	var po = org.polymaps;
	var body_height = $(document).height();
	console.log(body_height);
	$('#map').css('height',body_height+'px');
	console.log($('#map').height());
	var map = po.map()
	    .container(document.getElementById("map").appendChild(po.svg("svg")))
	    .center({lat: 37.787, lon: -122.228})
	    .zoom(14)
	    .zoomRange([12, 16])
	    .add(po.interact());

	map.add(po.image()
	    .url(po.url("http://{S}tile.cloudmade.com"
	    + "/67d9477354af439c8973454d7cf3aa58" // http://cloudmade.com/register
	    + "/20760/256/{Z}/{X}/{Y}.png")
	    .hosts(["a.", "b.", "c.", ""])));

	map.add(po.geoJson()
	    .url(crimespotting("http://oakland.crimespotting.org"
	        + "/crime-data"
	        + "?count=1000"
	        + "&format=json"
	        + "&bbox={B}"
	        + "&dstart=2010-04-01"
	        + "&dend=2010-05-01"))
	    .on("load", load)
	    .clip(false)
	    .zoom(14));

	map.add(po.compass()
	    .pan("none"));

	function crimespotting(template) {
	  return function(c) {
	    var max = 1 << c.zoom, column = c.column % max;
	    if (column < 0) column += max;
	    return template.replace(/{(.)}/g, function(s, v) {
	      switch (v) {
	        case "B": {
	          var nw = map.coordinateLocation({row: c.row, column: column, zoom: c.zoom}),
	              se = map.coordinateLocation({row: c.row + 1, column: column + 1, zoom: c.zoom}),
	              pn = Math.ceil(Math.log(c.zoom) / Math.LN2);
	          return nw.lon.toFixed(pn)
	              + "," + se.lat.toFixed(pn)
	              + "," + se.lon.toFixed(pn)
	              + "," + nw.lat.toFixed(pn);
	        }
	      }
	      return v;
	    });
	  };
	}

	function load(e) {
		
	  var cluster = e.tile.cluster || (e.tile.cluster = kmeans()
	      .iterations(16)
	      .size(64));

	  for (var i = 0; i < e.features.length; i++) {
	    var feature = e.features[i];
	    cluster.add({
	      x: Number(feature.element.getAttribute("cx")),
	      y: Number(feature.element.getAttribute("cy"))
	    });
	  }

	  var tile = e.tile, g = tile.element;
	  while (g.lastChild) g.removeChild(g.lastChild);

	  var means = cluster.means();
	  means.sort(function(a, b) { return b.size - a.size; });
	  for (var i = 0; i < means.length; i++) {
	    var mean = means[i], point = g.appendChild(po.svg("circle"));
	    point.setAttribute("cx", mean.x);
	    point.setAttribute("cy", mean.y);
	    point.setAttribute("r", Math.pow(2, tile.zoom - 11) * Math.sqrt(mean.size));
	  }
	}

   
   
});