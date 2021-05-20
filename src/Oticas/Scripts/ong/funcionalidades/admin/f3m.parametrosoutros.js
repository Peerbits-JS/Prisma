"use strict";

var $parametrosoutros = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    self.Init = function () {
    };


    return parent;

}($parametrosoutros || {}, jQuery));

var ParametrosOutrosInit = $parametrosoutros.ajax.Init;

$(document).ready(function (e) {
    ParametrosOutrosInit();
})
