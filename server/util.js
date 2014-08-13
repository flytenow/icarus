var _ = require('lodash');

module.exports.getResponse = function(rows, maxRows) {
  var years = [];
  _.forEach(rows, function(row) {
    var date = row.date.substr(0, 4);
    if (!_.find(years, {year: date})) {
      years.push({year: date, events: 1, fatalities: row.fatalities || 0, injuries: row.injuries || 0});
    } else {
      var year = _.find(years, {year: date});
      year.events++;
      year.fatalities += row.fatalities;
      year.injuries += row.injuries;
    }
  });
  return {years: _.sortBy(years, 'year'), activeRows: rows.length, maxRows: maxRows};
};

