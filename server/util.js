var _ = require('lodash');

module.exports.getResponse = function(rows) {
  var years = [];
  _.forEach(rows, function(row) {
    var year = row.date.substr(0, 4);
    if (!_.find(years, {year: year})) {
      years.push({year: year, count: 1});
    } else {
      _.find(years, {year: year}).count++;
    }
  });
  return {years: _.sortBy(years, 'year')};
};

