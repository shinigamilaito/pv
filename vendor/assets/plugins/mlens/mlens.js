(function(e) {
        function q(d) {
            if ("string" === typeof d) {
                var c = d.indexOf("_");
                -1 != c && (d = d.substr(c + 1))
            }
            return d
        }
        var l = []
            , p = 0
            , r = {
            init: function(d) {
                this.each(function() {
                    var c = e(this)
                        , a = c.data("mlens")
                        , a = e()
                        , f = e()
                        , n = e()
                        , h = e()
                        , g = e()
                        , a = e.extend({
                        lensShape: "square",
                        lensSize: 100,
                        borderSize: 4,
                        borderColor: "#888",
                        borderRadius: 0,
                        imgSrc: "",
                        lensCss: "",
                        imgOverlay: "",
                        overlayAdapt: !0
                    }, d);
                    "" == a.imgSrc && (a.imgSrc = c.attr("src"));
                    var g = "background-position: 0px 0px;width: " + String(a.lensSize) + "px;height: " + String(a.lensSize) + "px;float: left;display: none;border: " + String(a.borderSize) + "px solid " + a.borderColor + ";background-repeat: no-repeat;position: absolute;z-index: 10;"
                        , b = "position: absolute; width: 100%; height: 100%; left: 0; top: 0; background-position: center center; background-repeat: no-repeat; z-index: 1;";
                    !0 === a.overlayAdapt && (b += "background-position: center center fixed; -webkit-background-size: cover; -moz-background-size: cover; -o-background-size: cover; background-size: cover;");
                    switch (a.lensShape) {
                        default:
                            g = g + "border-radius:" + String(a.borderRadius) + "px;";
                            b = b + "border-radius:" + String(a.borderRadius) + "px;";
                            break;
                        case "circle":
                            g = g + "border-radius: " + String(a.lensSize / 2 + a.borderSize) + "px;",
                                b = b + "border-radius: " + String(a.lensSize / 2 + a.borderSize) + "px;"
                    }
                    c.wrap("<div id='mlens_wrapper_" + p + "' />");
                    h = c.parent();
                    h.css({
                        width: c.width()
                    });
                    f = e("<div id='mlens_target_" + p + "' style='" + g + "' class='" + a.lensCss + "'>&nbsp;</div>").appendTo(h);
                    g = e("<img style='display:none;' src='" + a.imgSrc + "' />").appendTo(h);
                    f.css({
                        backgroundImage: "url('" + a.imgSrc + "')",
                        cursor: "none"
                    });
                    "" != a.imgOverlay && (n = e("<div id='mlens_overlay_" + p + "' style='" + b + "'>&nbsp;</div>"),
                        n.css({
                            backgroundImage: "url('" + a.imgOverlay + "')",
                            cursor: "none"
                        }),
                        n.appendTo(f));
                    c.attr("data-id", "mlens_" + p);
                    c.data("mlens", {
                        lens: c,
                        options: a,
                        target: f,
                        imageTag: g,
                        parentDiv: h,
                        overlay: n,
                        instance: p
                    });
                    a = c.data("mlens");
                    l[p] = a;
                    f.mousemove(function(a) {
                        e.fn.mlens("move", c.attr("data-id"), a)
                    });
                    c.mousemove(function(a) {
                        e.fn.mlens("move", c.attr("data-id"), a)
                    });
                    f.on("touchmove", function(a) {
                        a.preventDefault();
                        a = a.originalEvent.touches[0] || a.originalEvent.changedTouches[0];
                        e.fn.mlens("move", c.attr("data-id"), a)
                    });
                    c.on("touchmove", function(a) {
                        a.preventDefault();
                        a = a.originalEvent.touches[0] || a.originalEvent.changedTouches[0];
                        e.fn.mlens("move", c.attr("data-id"), a)
                    });
                    c.hover(function() {
                        f.show()
                    }, function() {
                        f.hide()
                    });
                    f.hover(function() {
                        f.show()
                    }, function() {
                        f.hide()
                    });
                    c.on("touchstart", function(a) {
                        a.preventDefault();
                        f.show()
                    });
                    c.on("touchend", function(a) {
                        a.preventDefault();
                        f.hide()
                    });
                    f.on("touchstart", function(a) {
                        a.preventDefault();
                        f.show()
                    });
                    f.on("touchend", function(a) {
                        a.preventDefault();
                        f.hide()
                    });
                    p++;
                    return l
                })
            },
            move: function(d, c) {
                d = q(d);
                var a = l[d]
                    , f = a.lens
                    , e = a.target
                    , h = a.imageTag
                    , g = f.offset()
                    , b = parseInt(c.pageX - g.left)
                    , k = parseInt(c.pageY - g.top)
                    , m = h.width() / f.width()
                    , h = h.height() / f.height();
                0 < b && 0 < k && b < f.width() && k < f.height() && (b = String(-((c.pageX - g.left) * m - e.width() / 2)),
                    k = String(-((c.pageY - g.top) * h - e.height() / 2)),
                    e.css({
                        backgroundPosition: b + "px " + k + "px"
                    }),
                    b = String(c.pageX - g.left - e.width() / 2),
                    k = String(c.pageY - g.top - e.height() / 2),
                    e.css({
                        left: b + "px",
                        top: k + "px"
                    }));
                a.target = e;
                l[d] = a;
                return l
            },
            update: function(d, c) {
                d = q(d);
                var a = l[d]
                    , f = a.lens
                    , n = a.target
                    , h = a.overlay
                    , g = a.imageTag
                    , b = e.extend(a.options, c);
                "" == b.imgSrc && (b.imgSrc = f.attr("src"));
                var k = "background-position: 0px 0px;width: " + String(b.lensSize) + "px;height: " + String(b.lensSize) + "px;float: left;display: none;border: " + String(b.borderSize) + "px solid " + b.borderColor + ";background-repeat: no-repeat;position: absolute;"
                    , m = "position: absolute; width: 100%; height: 100%; left: 0; top: 0; background-position: center center; background-repeat: no-repeat; z-index: 1;";
                !0 === b.overlayAdapt && (m += "background-position: center center fixed; -webkit-background-size: cover; -moz-background-size: cover; -o-background-size: cover; background-size: cover;");
                switch (b.lensShape) {
                    default:
                        k = k + "border-radius:" + String(b.borderRadius) + "px;";
                        m = m + "border-radius:" + String(b.borderRadius) + "px;";
                        break;
                    case "circle":
                        k = k + "border-radius: " + String(b.lensSize / 2 + b.borderSize) + "px;",
                            m = m + "border-radius: " + String(b.lensSize / 2 + b.borderSize) + "px;"
                }
                n.attr("style", k);
                g.attr("src", b.imgSrc);
                n.css({
                    backgroundImage: "url('" + b.imgSrc + "')",
                    cursor: "none"
                });
                h.attr("style", m);
                h.css({
                    backgroundImage: "url('" + b.imgOverlay + "')",
                    cursor: "none"
                });
                a.lens = f;
                a.target = n;
                a.overlay = h;
                a.options = b;
                a.imageTag = g;
                l[d] = a;
                return l
            },
            destroy: function(d) {
                d = q(d);
                e.removeData(l[d], this.name);
                this.removeClass(this.name);
                this.unbind();
                this.element = null
            }
        };
        e.fn.mlens = function(d) {
            if (r[d])
                return r[d].apply(this, Array.prototype.slice.call(arguments, 1));
            if ("object" !== typeof d && d)
                e.error("Method " + d + " does not exist on jQuery.mlens");
            else
                return r.init.apply(this, arguments)
        }
    }
)(jQuery);
