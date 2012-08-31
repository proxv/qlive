$(document).ready(function() {
  module("verify-creds.js");

  test("permissions", 3, window.ns.permissionCheckB);
});
