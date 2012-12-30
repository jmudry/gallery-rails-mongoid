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
                    if (data.photo.id !== 'nil') {
                        buttons.each(function (index, element) {
                            var href = $(element).attr('href');
                            href = href.replace(/\/photos\/(\d*)\/get\//i, "/photos/"+data.photo.id+"/get/")
                            $(element).attr('href', href);
                            console.log(href);
                        });
                    }
                    closest.find('.description').text(data.photo.description);
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
                    image.attr('src', data.photo.src)


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
        $(this).find('.description').slideUp(300);

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

//ajax load


// load more posts
$('.show-more-ajax').live('ajax:success',function(e,data,status,xhr){
    var load_to = $(this).data('load-to');
        $(load_to+"").append(data.html);
    if (data.url == "end")
        $(this).hide();
    else {
        $(this).removeAttr('data-disabled').attr('href',data.url).removeClass("ajax-load").find('.middle').text('Load more');
    }}).live('click',function(){
        $(this).attr('data-disabled',true).addClass("ajax-load").find(".middle").text("");
    });


$(window).scroll(function() {
    if($(window).scrollTop() + $(window).height() > $(document).height() -500) {
        $('.show-more-ajax:visible:not([data-disabled])').trigger('click');

    }
});