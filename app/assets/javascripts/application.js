// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require_tree .



(function($) {
    $.fn.replaceAttr = function(options) {
        return this.each(function() {
        });
    }
})(jQuery);

$(function () {
    $(document).on('click', '.gallery-container a.navigation', function (e) {
        var that = this
        if (!$(this).hasClass('disabled')) {
            $.ajax({
                type: 'POST',
                url: $(this).attr('href'),
                success: function(data,status,jqxhr) {
                    var closest = $(that).closest('.gallery-container'),
                        image = closest.find('.image img'),
                        buttons = closest.find('.buttons a');
                    if (data.photo_id !== 'nil') {
                        buttons.each(function (index, element) {
                            var href = $(element).attr('href'),
                                reg = /\/photos\/(\d*)\/get\//i
                            href = href.replace(reg, "/photos/"+data.photo_id+"/get/")
                            $(element).attr('href', href);
                            console.log(href);
                        });
                    }
                    if (!data.prev) {
                        closest.find('.prev').addClass("disabled")
                    } else {
                        closest.find('.prev').removeClass("disabled")
                    }
                    if (!data.next) {
                        closest.find('.next').addClass("disabled")
                    } else {
                        closest.find('.next').removeClass("disabled")
                    }
                    image.attr('src', data.src)


                }
            });
        } else {
            console.log("block action")
        }
        e.preventDefault()
        return false
    });

});

$(document).on("mouseleave", ".gallery-container .image", function () {
        $(this).find('.nav').fadeOut(300);
    }
);

$(document).on("mouseenter", ".gallery-container .image", function () {
        var container = $(this).closest('.gallery-container');
        if (!$(this).hasClass('disabled')) {
            container.find(".image .nav.next").fadeIn(300);
        }
        if (!$(this).hasClass('disabled')) {
            container.find(".image .nav.prev").fadeIn(300);
        }
});

$(document).on('click','.gallery-container .image .nav', function () {
       var container = $(this).closest('.gallery-container');
    if ($(this).hasClass('prev')) {
        container.find('.buttons a.exactly-prev').trigger('click');
    } else if ($(this).hasClass('next')) {
        container.find('.buttons a.exactly-next').trigger('click');
    }
});



$("#test-plugin").replaceAttr("data-text").css("color","red");
