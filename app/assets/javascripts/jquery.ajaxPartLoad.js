(function($) {
    $.fn.ajaxPartLoad = function(options) {
        var settings;
        var onclick = function() {
            $(this).attr('data-disabled',true).addClass("ajax-load").find(".middle").text("");
            var that = $(this);
            $.ajax({
                type: 'POST',
                url: $(this).attr('href'),
                success: function(data) {
                    var load_to = that.data('load-to');
                    $(settings.loadTo+"").append(data.html);
                    if (data.url === "end") {
                        that.hide();
                    } else {
                        that.removeAttr('data-disabled').attr('href',data.url).removeClass("ajax-load").find('.middle').text('Load more');
                    }
                }
            });
            return false;
        };

        return this.each(function() {
            var that = $(this);
            settings = $.extend( {
                visibility : 500,
                loadTo: typeof that.data('load-to') !== 'undefined' ? that.data('load-to') : 'body'
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
    };
})(jQuery);