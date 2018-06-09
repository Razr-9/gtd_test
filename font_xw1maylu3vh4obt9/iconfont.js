;(function(window) {

  var svgSprite = '<svg>' +
    '' +
    '<symbol id="icon-xiao" viewBox="0 0 1024 1024">' +
    '' +
    '<path d="M512.002 2.621c-281.225 0-509.383 228.158-509.383 509.383 0 281.218 228.158 509.375 509.383 509.375 281.218 0 509.375-228.158 509.375-509.375 0.001-281.226-228.157-509.383-509.375-509.383l0 0ZM206.372 359.185c0-56.245 45.634-101.873 101.877-101.873s101.873 45.629 101.873 101.873c0 56.244-45.63 101.877-101.873 101.877-56.242 0-101.877-45.634-101.877-101.877l0 0ZM677.548 698.348c-9.973 11.459-26.315 27.379-47.329 43.299-37.988 28.865-77.04 46.694-118.429 46.694-41.175 0-80.441-17.829-118.43-46.694-21.014-15.92-37.141-31.839-47.328-43.299-18.465-21.225-16.556-53.27 4.669-71.949 21.223-18.465 53.269-16.556 71.949 4.669 5.94 6.791 17.615 18.042 32.26 29.287 21.861 16.555 42.234 25.895 56.667 25.895 14.433 0 35.02-9.342 56.671-25.895 14.854-11.246 26.528-22.711 32.261-29.287 18.464-21.226 50.724-23.347 71.949-4.669 21.646 18.677 23.77 50.94 5.097 71.949l-0.004 0ZM715.755 461.062c-56.244 0-101.876-45.636-101.876-101.877 0-56.245 45.635-101.873 101.876-101.873 56.245 0 101.873 45.629 101.873 101.873 0 56.244-45.631 101.877-101.873 101.877l0 0ZM715.755 461.062Z"  ></path>' +
    '' +
    '</symbol>' +
    '' +
    '<symbol id="icon-xiao1" viewBox="0 0 1024 1024">' +
    '' +
    '<path d="M512 0C229.216 0 0 229.248 0 512c0 282.816 229.216 512 512 512s512-229.184 512-512C1024 229.248 794.784 0 512 0zM512 960C264.576 960 64 759.424 64 512 64 264.608 264.576 64 512 64s448 200.608 448 448C960 759.424 759.424 960 512 960z"  ></path>' +
    '' +
    '<path d="M358.016 363.488m-79.008 0a2.469 2.469 0 1 0 158.016 0 2.469 2.469 0 1 0-158.016 0Z"  ></path>' +
    '' +
    '<path d="M670.016 363.488m-79.008 0a2.469 2.469 0 1 0 158.016 0 2.469 2.469 0 1 0-158.016 0Z"  ></path>' +
    '' +
    '<path d="M744.544 608.768c0 0 16-36-16-60 0 0-36-22.016-67.616 11.936 0 0-30.368 104.064-150.368 97.888 0 0-90.016 2.176-147.744-88.256 0 0-9.248-41.568-68.8-22.368 0 0-35.424 32.8-9.44 68.8 0 0 68.992 122.752 226.016 122.016C510.528 738.752 665.536 757.504 744.544 608.768z"  ></path>' +
    '' +
    '</symbol>' +
    '' +
    '<symbol id="icon-xiao-copy" viewBox="0 0 1024 1024">' +
    '' +
    '<path d="M512.002 2.621C230.777 2.621 2.619 230.779 2.619 512.004c0 281.218 228.158 509.375 509.383 509.375 281.218 0 509.375-228.158 509.375-509.375 0.001-281.226-228.157-509.383-509.375-509.383z m-305.63 356.564c0-56.245 45.634-101.873 101.877-101.873s101.873 45.629 101.873 101.873c0 56.244-45.63 101.877-101.873 101.877-56.242 0-101.877-45.634-101.877-101.877z m471.176 339.163c-9.973 11.459-26.315 27.379-47.329 43.299-37.988 28.865-77.04 46.694-118.429 46.694-41.175 0-80.441-17.829-118.43-46.694-21.014-15.92-37.141-31.839-47.328-43.299-18.465-21.225-16.556-53.27 4.669-71.949 21.223-18.465 53.269-16.556 71.949 4.669 5.94 6.791 17.615 18.042 32.26 29.287 21.861 16.555 42.234 25.895 56.667 25.895s35.02-9.342 56.671-25.895c14.854-11.246 26.528-22.711 32.261-29.287 18.464-21.226 50.724-23.347 71.949-4.669 21.646 18.677 23.77 50.94 5.097 71.949h-0.004z m38.207-237.286c-56.244 0-101.876-45.636-101.876-101.877 0-56.245 45.635-101.873 101.876-101.873 56.245 0 101.873 45.629 101.873 101.873 0 56.244-45.631 101.877-101.873 101.877z m0 0z" fill="#d81e06" ></path>' +
    '' +
    '</symbol>' +
    '' +
    '</svg>'
  var script = function() {
    var scripts = document.getElementsByTagName('script')
    return scripts[scripts.length - 1]
  }()
  var shouldInjectCss = script.getAttribute("data-injectcss")

  /**
   * document ready
   */
  var ready = function(fn) {
    if (document.addEventListener) {
      if (~["complete", "loaded", "interactive"].indexOf(document.readyState)) {
        setTimeout(fn, 0)
      } else {
        var loadFn = function() {
          document.removeEventListener("DOMContentLoaded", loadFn, false)
          fn()
        }
        document.addEventListener("DOMContentLoaded", loadFn, false)
      }
    } else if (document.attachEvent) {
      IEContentLoaded(window, fn)
    }

    function IEContentLoaded(w, fn) {
      var d = w.document,
        done = false,
        // only fire once
        init = function() {
          if (!done) {
            done = true
            fn()
          }
        }
        // polling for no errors
      var polling = function() {
        try {
          // throws errors until after ondocumentready
          d.documentElement.doScroll('left')
        } catch (e) {
          setTimeout(polling, 50)
          return
        }
        // no errors, fire

        init()
      };

      polling()
        // trying to always fire before onload
      d.onreadystatechange = function() {
        if (d.readyState == 'complete') {
          d.onreadystatechange = null
          init()
        }
      }
    }
  }

  /**
   * Insert el before target
   *
   * @param {Element} el
   * @param {Element} target
   */

  var before = function(el, target) {
    target.parentNode.insertBefore(el, target)
  }

  /**
   * Prepend el to target
   *
   * @param {Element} el
   * @param {Element} target
   */

  var prepend = function(el, target) {
    if (target.firstChild) {
      before(el, target.firstChild)
    } else {
      target.appendChild(el)
    }
  }

  function appendSvg() {
    var div, svg

    div = document.createElement('div')
    div.innerHTML = svgSprite
    svgSprite = null
    svg = div.getElementsByTagName('svg')[0]
    if (svg) {
      svg.setAttribute('aria-hidden', 'true')
      svg.style.position = 'absolute'
      svg.style.width = 0
      svg.style.height = 0
      svg.style.overflow = 'hidden'
      prepend(svg, document.body)
    }
  }

  if (shouldInjectCss && !window.__iconfont__svg__cssinject__) {
    window.__iconfont__svg__cssinject__ = true
    try {
      document.write("<style>.svgfont {display: inline-block;width: 1em;height: 1em;fill: currentColor;vertical-align: -0.1em;font-size:16px;}</style>");
    } catch (e) {
      console && console.log(e)
    }
  }

  ready(appendSvg)


})(window)