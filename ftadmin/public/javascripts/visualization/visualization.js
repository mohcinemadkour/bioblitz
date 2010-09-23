var chart;
var main_chart;
var map;

$(document).ready(function() {
	
		$(".move_box").resizable({
			maxHeight: 104,
			maxWidth: 756,
			minHeight: 104,
			minWidth: 1,
			handles: 'w',
			stop: function(event,ui) {
				console.log(event);
				console.log(ui);
			}
		});
		
		
		
		main_chart = new Highcharts.Chart({
				chart: {
				         renderTo: 'main_chart',
				         defaultSeriesType: 'line',
				         margin: [20,7,15,7],
								 backgroundColor: 'none'
				      },
				      title: {
				         text: ''
				      },
							plotOptions: {line: {pointStart: 0}},
				      xAxis: {
				         categories: ['0', '1', '2', '3', '4', '5', 
				            '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24']
				      },
				      yAxis: {gridLineWidth:0},
							credits: {enabled: false},
				      tooltip: {enabled: false},
				      legend: {enabled: false},
				      series: [{
				         name: 'Tokyo',
				         data: [7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6, 12, 14,14,14,15,16,17,18,1,1,1,1]
				      }, {
				         name: 'New York',
				         data: [2, 0.8, 5.7, 11.3, 17.0, 22.0, 24.8, 24.1, 20.1, 14.1, 8.6, 2.5, 12, 14,14,14,15,16,17,18,1,1,1,1]
				      }, {
				         name: 'Berlin',
				         data: [1, 0.6, 3.5, 8.4, 13.5, 17.0, 18.6, 17.9, 14.3, 9.0, 3.9, 1.0, 12, 14,14,14,15,16,17,18,38,1,1,1]
				      }, {
				         name: 'London',
				         data: [3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8, 12, 14,14,14,15,16,17,18,1,1,1,1]
				      }]
				   });
		
		
	
	  var body_height = $(document).height();
  	$('#map').css('height',body_height+'px');
	  
		var stylez = [
		  {
		    featureType: "road.arterial",
		    elementType: "all",
		    stylers: [
		      { visibility: "off" }
		    ]
		  },{
		    featureType: "water",
		    elementType: "all",
		    stylers: [
		      { hue: "#0091ff" }
		    ]
		  },{
		    featureType: "all",
		    elementType: "all",
		    stylers: [

		    ]
		  }
		];
		
	
		var mapOptions = {
		   zoom: 14,
		   center: new google.maps.LatLng(41.48195222338898, -70.66639090629883),
		
		   mapTypeControlOptions: {
		      mapTypeIds: [google.maps.MapTypeId.TERRAIN, 'vizzuality']
		   },
			disableDefaultUI: true,
			scrollwheel: false
		 };

		 map = new google.maps.Map(document.getElementById("map"),mapOptions);
		 var styledMapOptions = {name: "Vizzuality"}
		 var jayzMapType = new google.maps.StyledMapType(stylez, styledMapOptions);

		 map.mapTypes.set('vizzuality', jayzMapType);
		 map.setMapTypeId('vizzuality');
		
			
		 
	
	
		
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


   
   
});