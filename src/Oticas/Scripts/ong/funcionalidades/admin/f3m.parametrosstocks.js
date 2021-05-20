"use strict";

var $parametrosstocks = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    self.Init = function () {      
    };

    return parent;

}($parametrosstocks || {}, jQuery));

var ParametrosStocksInit = $parametrosstocks.ajax.Init;

$(document).ready(function (e) {
    ParametrosStocksInit();
})
