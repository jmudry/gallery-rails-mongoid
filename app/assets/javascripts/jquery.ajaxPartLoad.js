(function($) {
    $.fn.ajaxPartLoad = function(options) {
        var onclick = function() {
            $(this).attr('data-disabled',true).addClass("ajax-load").find(".middle").text("");
            var that = $(this);
            $.ajax({
                type: 'POST',
                url: $(this).attr('href'),
                success: function(data,status,jqxhr) {
                    var load_to = that.data('load-to');
                    $(load_to+"").append(data.html);
                    if (data.url == "end")
                        that.hide();
                    else {
                        that.removeAttr('data-disabled').attr('href',data.url).removeClass("ajax-load").find('.middle').text('Load more');
                    }
                }
            });
            return false;
        };

        return this.each(function(options) {
            var that = $(this);
            var settings = $.extend( {
                visibility : 500
            }, options);
            that.live('click', onclick);
            $(window).scroll(function() {
                if($(window).scrollTop() + $(window).height() > $(document).height() - settings.visibility) {
                    if (that.is(":visible") && that.data("disabled") !== false) {
                        $('.show-more-ajax:visible:not([data-disabled])').trigger('click');
                    }
                }
            });
            return;
        });
    }
})(jQuery);