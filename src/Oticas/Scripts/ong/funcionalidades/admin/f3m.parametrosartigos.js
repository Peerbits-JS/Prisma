"use strict";

var $parametrosartigos = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    self.Init = function () {
    };

    return parent;

}($parametrosartigos || {}, jQuery));

var ParametrosArtigosInit = $parametrosartigos.ajax.Init;

$(document).ready(function (e) {
    ParametrosArtigosInit();
})
