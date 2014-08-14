angular.module('icarus', ['angles', 'vr.directives.slider', 'ui.bootstrap'])
  .filter('titlecase', function() {
    return function(s) {
      s = ( s === undefined || s === null ) ? '' : s;
      return s.toString().toLowerCase().replace(/\b([a-z])/g, function(ch) {
        return ch.toUpperCase();
      });
    };
  })
  .controller('IcarusController', function($scope, $http) {
    $scope._ = _;

    $scope.params = {};
    $scope.controls = {};

    $scope.years = [];

    $scope.activeRows = 0;
    $scope.maxRows = 0;
    $scope.dataUtilization = 0;

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

      legendTemplate: "<ul class=\"<%=name.toLowerCase()%>-legend\"><% for (var i=0; i<datasets.length; i++){%><li><div class=\"legend-bullet\" style=\"background-color:<%=datasets[i].strokeColor%>\"></div><%if(datasets[i].label){%><%=datasets[i].label%><%}%></li><%}%></ul>"
    };

    $http({method: 'GET', url: '/info'})
      .success(function(data) {
        $scope.controls.date = {floor: data.range.date.floor, low: data.range.date.floor,
          ceil: data.range.date.ceil, high: data.range.date.ceil};
        $scope.controls.fatalities = {floor: data.range.fatalities.floor, low: data.range.fatalities.floor,
          ceil: data.range.fatalities.ceil, high: data.range.fatalities.ceil};
        $scope.controls.injuries = {floor: data.range.injuries.floor, low: data.range.injuries.floor,
          ceil: data.range.injuries.ceil, high: data.range.injuries.ceil};
        $scope.maxRows = data.maxRows;
        $scope.distinct = data.distinct;

        var params = {};
        params.date = {low: $scope.controls.date.low, high: $scope.controls.date.high};
        params.fatalities = {low: $scope.controls.fatalities.low, high: $scope.controls.fatalities.high};
        params.injuries = {low: $scope.controls.injuries.low, high: $scope.controls.injuries.high};
        $http.post('/query', params)
          .success(function(data) {
            $scope.activeRows = data.activeRows;
            $scope.dataUtilization = (data.activeRows / $scope.maxRows) * 100;
            $scope.years = data.years;

            var labels = _.pluck(data.years, 'year');

            $scope.controls.date.floor = labels[0];
            $scope.controls.date.low = labels[0];
            $scope.controls.date.ceil = labels[labels.length - 1];
            $scope.controls.date.high = labels[labels.length - 1];

            $scope.chartDataset = {
              labels: labels,
              datasets: [
                {
                  label: 'All Events',
                  fillColor: "rgba(200,200,200,0.4)",
                  strokeColor: "#c8c8c8",
                  pointColor: "#c8c8c8",
                  pointStrokeColor: "#c8c8c8",
                  data: _.pluck(data.years, 'events')
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
      });

    $scope.query = function(params) {
      if (_.isUndefined(params) || _.isNull(params)) {
        params = {};
      }
      angular.extend(params, {date: {low: $scope.controls.date.low, high: $scope.controls.date.high}});
      angular.extend(params,
        {fatalities: {low: $scope.controls.fatalities.low, high: $scope.controls.fatalities.high}});
      angular.extend(params, {injuries: {low: $scope.controls.injuries.low, high: $scope.controls.injuries.high}});
      $http.post('/query', params)
        .success(function(data) {
          $scope.activeRows = data.activeRows;
          $scope.dataUtilization = (data.activeRows / $scope.maxRows) * 100;
          $scope.years = data.years;

          $scope.chartDataset.labels = _.pluck(data.years, 'year');
          $scope.chartDataset.datasets[0].data = _.pluck(data.years, 'events');
          $scope.chartDataset.datasets[1].data = _.pluck(data.years, 'injuries');
          $scope.chartDataset.datasets[2].data = _.pluck(data.years, 'fatalities');
        });
    };
  });
