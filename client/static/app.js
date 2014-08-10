angular.module('icarus', ['angles'])
  .controller('IcarusController', function($scope, $http) {

    $scope.years = [];

    $scope.chartOptions = {
      scaleLineWidth: 2,
      scaleLineColor: '#777',
      scaleFontFamily: "'Helvetica Neue', 'Helvetica', 'Arial', sans-serif",
      scaleFontSize: 16,
      scaleFontColor: '#333',

      responsive: true,
      maintainAspectRatio: false,

      tooltipFillColor: "rgba(0,0,0,0.8)",
      tooltipFontFamily: "'Helvetica Neue', 'Helvetica', 'Arial', sans-serif",
      tooltipFontSize: 14,
      tooltipFontColor: "#fff",
      tooltipTitleFontFamily: "'Helvetica Neue', 'Helvetica', 'Arial', sans-serif",
      tooltipTitleFontSize: 20,
      tooltipTitleFontStyle: "bold",
      tooltipTitleFontColor: "#fff",
      tooltipYPadding: 10,
      tooltipXPadding: 10,
      tooltipCornerRadius: 4,

      scaleGridLineColor: "rgba(0,0,0,.05)",
      scaleGridLineWidth: 1,

      bezierCurve: true,
      bezierCurveTension: 0.4,

      pointDotRadius: 6,
      pointDotStrokeWidth: 1,

      datasetStrokeWidth: 3,

      legendTemplate: "<ul class=\"<%=name.toLowerCase()%>-legend\"><% for (var i=0; i<datasets.length; i++){%><li><span style=\"background-color:<%=datasets[i].lineColor%>\"></span><%if(datasets[i].label){%><%=datasets[i].label%><%}%></li><%}%></ul>"
    };

    $http.get('/query')
      .success(function(data) {
        $scope.years = data.years;

        $scope.chartDataset = {
          labels: _.pluck(data.years, 'year'),
          datasets: [
            {
              label: 'Incidents',
              fillColor: "rgba(200,200,200,0.4)",
              strokeColor: "#c8c8c8",
              pointColor: "#c8c8c8",
              pointStrokeColor: "#c8c8c8",
              data: _.pluck(data.years, 'incidents')
            },
            {
              label: 'Injuries',
              fillColor: "rgba(0,150,0,0.4)",
              strokeColor: "#009600",
              pointColor: "#009600",
              pointStrokeColor: "#009600",
              data: _.pluck(data.years, 'injuries')
            },
            {
              label: 'Fatalities',
              fillColor: "rgba(0,153,221,0.4)",
              strokeColor: "#09d",
              pointColor: "#09d",
              pointStrokeColor: "#09d",
              data: _.pluck(data.years, 'fatalities')
            }
          ]
        };
      });

    $scope.query = function() {
    }
  });
