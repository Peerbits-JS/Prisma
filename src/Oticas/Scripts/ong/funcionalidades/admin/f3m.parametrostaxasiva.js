"use strict";

var $parametrostaxasiva = (function (parent, $) {
    var self = parent.ajax = parent.ajax || {};

    self.Init = function () {
    };


    return parent;

}($parametrostaxasiva || {}, jQuery));

var ParametrosTaxasIvaInit = $parametrostaxasiva.ajax.Init;

$(document).ready(function (e) {
    ParametrosTaxasIvaInit();
})
