//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require_tree .

$(function () {
    $('.show-more-ajax').ajaxPartLoad();
});

$(document).on("mouseleave", ".gallery-container .image", function () {
        $(this).find('.nav').fadeOut(300);
        $(this).find('.description').slideUp(300);
    });

$(document).on("mouseenter", ".gallery-container .image", function () {
        if (!$(this).find('.next').hasClass('disabled')) {
            $(this).find(".nav.next").fadeIn(300);
        }
        if (!$(this).find('.prev').hasClass('disabled')) {
           $(this).find(".nav.prev").fadeIn(300);
        }
        $(this).find('.description').slideDown(300);
});

$(document).on('click','.gallery-container .image .nav', function () {
       var container = $(this).closest('.gallery-container');
    if ($(this).hasClass('prev')) {
        container.find('.buttons a.exactly-prev').trigger('click');
    } else if ($(this).hasClass('next')) {
        container.find('.buttons a.exactly-next').trigger('click');
    }
});

$(document).on('click', '.gallery-container a.navigation', function (e) {
    var that = this;
    if (!$(this).hasClass('disabled')) {
        $.ajax({
            type: 'POST',
            url: $(this).attr('href'),
            success: function(data) {
                var closest = $(that).closest('.gallery-container'),
                    image = closest.find('.image img'),
                    buttons = closest.find('.buttons a');
                if (data.photo.id !== 'nil') {
                    buttons.each(function (index, element) {
                        var href = $(element).attr('href');
                        href = href.replace(/\/photos\/(.*)\/get\//i, "/photos/"+data.photo.id+"/get/");
                        $(element).attr('href', href);
                    });
                }
                closest.find('.description').text(data.photo.description);
                if (!data.prev) {
                    closest.find('.prev').addClass("disabled");
                } else {
                    closest.find('.prev').removeClass("disabled");
                }
                if (!data.next) {
                    closest.find('.next').addClass("disabled");
                } else {
                    closest.find('.next').removeClass("disabled");
                }

                image.fadeOut('fast', function () {
                    image.attr('src', data.photo.src);
                    image.fadeIn('fast');
                });
            }
        });
    }
    e.preventDefault();
    return false;
});


//ajax load

