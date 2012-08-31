var DEFAULT_MAX_DURATION = 12000;

window.waitFor = function(title, checkFn, opts) {
  var qunitCurrent = QUnit.config.current; // something is clearing this. Not yet sure why.
  var defer = jQuery.Deferred();
  opts = opts || {};
  var startTime = new Date().getTime();
  var maxDuration = opts.maxDuration || DEFAULT_MAX_DURATION;
  var pollInterval = opts.pollInterval || 200;
  var pollFn = function() {
    var now = new Date().getTime();
    if (now > startTime + maxDuration) {
      qlog('qq.waitFor "' + title + '" did not complete in ' + maxDuration + ' ms');
      QUnit.config.current = qunitCurrent;
      defer.reject();
      failQunit('qq.waitFor "' + title + '" did not complete in ' + maxDuration + ' ms');
    } else {
      try {
        var isReady = checkFn();
      } catch (err) {
        failQunit('ERROR. qq.waitFor "' + title + '" WAIT function has an error: ' + err.message);
      }
      if (isReady) {
        QUnit.config.current = qunitCurrent;
        qlog('Wait on "' + title + '" completed in ' + (now - startTime) + ' ms');
        try {
          defer.resolve();
        } catch (err) {
          failQunit('ERROR. qq.waitFor "' + title + '" RESOLUTION function has an error: ' + err.message);
        }
      } else {
        window.setTimeout(pollFn, pollInterval);
      }
    }
  };
  qlog('Waiting for "' + title + '"');
  pollFn();
  return defer.promise();
};

function failQunit(msg) {
  qlog(msg);
  ok(false, msg);
  start();
  window.qunitComplete = true;
}