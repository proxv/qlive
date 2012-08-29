
var DEFAULT_MAX_DURATION = 9000;

// note: optionally disable ajax async to reduce the need for waitFor. eg:
// $.ajax({ async: false });

window.waitFor = function(title, checkFn, opts) {
  stop();
  var defer = jQuery.Deferred();
  opts = opts || {};
  var startTime = new Date().getTime();
  var maxDuration = opts.maxDuration || DEFAULT_MAX_DURATION;
  var pollInterval = opts.pollInterval || 200;
  var pollFn = function() {
    if (new Date().getTime() > startTime + maxDuration) {
      ok(false, 'waitFor "' + title + '" did not complete in ' + maxDuration + ' ms');
      defer.reject();
      start();
    } else if (checkFn()) {
      defer.resolve();
      start();
    } else {
      window.setTimeout(pollFn, pollInterval);
    }
  };
  pollFn();
  return defer.promise();
};