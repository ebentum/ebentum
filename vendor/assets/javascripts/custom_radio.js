var toggleHandler = function(toggle) {
    var toggle = toggle;
    var radio = $(toggle).find("input");

    radio.eq(0).click(function() {
        $(toggle).toggleClass("toggle-off");
        $(toggle).trigger('switch-change')

    });

    radio.eq(1).click(function() {
        $(toggle).toggleClass("toggle-off");
        $(toggle).trigger('switch-change')
    });
};

$(document).ready(function() {
    $(".toggle").each(function(index, toggle) {
        toggleHandler(toggle);
    });
});
