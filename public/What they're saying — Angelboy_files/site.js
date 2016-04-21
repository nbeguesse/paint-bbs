Y.use('node', 'squarespace-dynamic-data', 'history-hash', function(Y) {

  Y.on('domready', function() {

    // fix goofy zooming on orientation change
    if (navigator.userAgent.match(/iPhone/i) && Y.one('body.mobile-style-available')) {
      var fixedViewport = 'width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1',
          zoomViewport = 'width=device-width, initial-scale=1',
          viewport = Y.one('meta[name="viewport"]');
      viewport.setAttribute('content', fixedViewport);
      Y.one('body').on('touchstart', function(e) {
        if (e.touches.length > 1) {
          viewport.setAttribute('content', zoomViewport);
        }
      });
    }

    // Mobile Nav ///////////////////////////////////

    Y.one('#mobileMenuLink a').on('click', function(e){
      console.log(e);
       // var mobileMenuHeight = parseInt(Y.one('#mobileNav .wrapper').get('offsetHeight'),10);
       // if (Y.one('#mobileNav').hasClass('menu-open')) {
       //   new Y.Anim({ node: Y.one('#mobileNav'), to: { height: 0 }, duration: 0.5, easing: 'easeBoth' }).run();
       // } else {
       //   new Y.Anim({ node: Y.one('#mobileNav'), to: { height: mobileMenuHeight }, duration: 0.5, easing: 'easeBoth' }).run();
       // }

       Y.one('#mobileNav').toggleClass('menu-open');

       //iOS6 Safari fix...
       // if(Y.one('#mobileNav').hasClass('menu-open') && Y.one('#mobileNav').get('offsetHeight') == 0){
       //   new Y.Anim({ node: Y.one('#mobileNav'), to: { height: mobileMenuHeight }, duration: 0.5, easing: 'easeBoth' }).run();
       // }
    });

    body = Y.one('body');
    bodyWidth = parseInt(body.getComputedStyle('width'),10);

    // center align dropdown menus (when design is centered)
    if(Y.one('body').hasClass('layout-style-center')) {
      Y.all('#topNav .subnav').each( function(n){
        n.setStyle('marginLeft', -(parseInt(n.getComputedStyle('width'),10)/2) + 'px' );
      });
    }

    // vertically align page title/description
    if (Y.one('.page-image .wrapper')) {
      var vertAlign = function() {
        Y.one('.page-image .wrapper').setStyles({
          marginTop: -1 * parseInt(Y.one('.page-image .wrapper').getComputedStyle('height'),10)/2 + 'px',
          opacity: 1
        });
      };
      vertAlign();
      Y.one('window').on('resize', vertAlign);
    }

    Y.one('#page').setStyle('opacity', 1);

    // PROJECT PAGES
    if (Y.one('.collection-type-template-page #projectPages, .collection-type-index #projectPages')) {

      thumbLoader();

      // thumbnail click events
      thumbClickHandler();

      // hash based page loading
      pageLoader();
      Y.on('hashchange', pageLoader);


      // project pagination
      Y.one('#projectNav').delegate('click', function(e) {
        var project = Y.one('#projectPages .active-project').previous('.project');
        if (project) {
          scrollToTop();
          window.location.hash = project.getAttribute('data-url');
        } else {
          e.currentTarget.addClass('disabled');
        }
      }, '.prev-project');

      Y.one('#projectNav').delegate('click', function(e) {
        var project = Y.one('#projectPages .active-project').next('.project');
        if (project) {
          scrollToTop();
          window.location.hash = project.getAttribute('data-url');
        } else {
          e.currentTarget.addClass('disabled');
        }
      }, '.next-project');

    }


    // GALLERY PAGES



    var body, bodyWidth;

    // SIDEBAR min-height set

    function setPageHeight() {
      var sidebarHeight;
      if (Y.one('#sidebar')) {
        sidebarHeight = Y.one('#sidebar').getComputedStyle('height');
      }
      if (sidebarHeight) {
        Y.one('#page').setStyle('minHeight', sidebarHeight);
      }
    }

    // run on page load
    setPageHeight();
    Y.later(1000, this, setPageHeight);


    // run when sidebar width is tweaked
    if (Y.Squarespace.Management) {
      Y.Squarespace.Management.on('tweak', function(f){
        if (f.getName() == 'blogSidebarWidth' ) {
          setPageHeight();
        }
      });
    }


  });


  // GLOBAL FUNCTIONS
  var dynamicLoaders = {};

  function pageLoader() {

    if (window.location.hash && window.location.hash != '#') {
      var urlId = window.location.hash.split('#')[1];

      urlId = urlId.charAt(0) == '/' ? urlId : '/' + urlId;
      urlId = urlId.charAt(urlId.length-1) == '/' ? urlId : urlId + '/';

      var activePage = Y.one('#projectPages .project[data-url="'+urlId+'"]');

      if (activePage) {
        if (activePage.hasAttribute('data-type-protected') || !activePage.hasClass('page-project') && !activePage.hasClass('gallery-project')) {
          // navigate away for anything other than pages/galleries
          window.location.replace(urlId);
          return;
        }

        if (activePage.hasClass('page-project') && !activePage.hasClass('sqs-dynamic-data-ready')) {
          dynamicLoaders['#'+urlId].simulateHash(urlId);
        }
      }

      // set active on projectPages
      Y.one('#page').addClass('page-open');

      resetAudioVideoBlocks();

      // remove active class from all project pages/thumbs
      Y.all('.active-project').each(function(project) {
        project.removeClass('active-project');
      });

      activePage.addClass('active-project');

      // set active thumb
      Y.one('#projectThumbs a.project[href="'+urlId+'"]').addClass('active-project');

      // set active navigation
      if (activePage.next('.project')) {
        Y.one('#projectNav .next-project').removeClass('disabled');
      } else {
        Y.one('#projectNav .next-project').addClass('disabled');
      }
      if (activePage.previous('.project')) {
        Y.one('#projectNav .prev-project').removeClass('disabled');
      } else {
        Y.one('#projectNav .prev-project').addClass('disabled');
      }

      scrollToTop(function() {
        Y.all('#projectPages .active-project img.loading').each(function(img) {
          // Load Non-Block Images
          if (!img.ancestor('.sqs-layout')) {
            ImageLoader.load(img, { load: true });
          }
        });

        Y.all('#projectPages .active-project .sqs-video-wrapper').each(function(video) {
          video.videoloader.load();
        });
      });

    } else { // no url hash

      // clear active on projectPages
      Y.one('#page').removeClass('page-open');

      resetAudioVideoBlocks();

      // remove active class from all project pages/thumbs
      Y.all('.active-project').removeClass('active-project');

    }
  }

  function resetAudioVideoBlocks() {
    // Audio/video blocks need to be forced reset
    var preActive = Y.one('#projectPages .active-project');
    if (preActive && preActive.one('.video-block, .code-block, .embed-block, .audio-block')){
      Y.fire('audioPlayer:stopAll', {container: preActive });
      preActive.empty(true).removeClass('sqs-dynamic-data-ready').removeAttribute('data-dynamic-data-link');
    }

    if (preActive && preActive.one('.sqs-video-wrapper')) {
      preActive.all('.sqs-video-wrapper').each(function(elem) {
        elem.videoloader.reload();
      });
    }
  }

  function thumbLoader() {
    var projectThumbs = Y.all('#projectThumbs img[data-src]');

    // lazy load on scroll
    var loadThumbsOnScreen = function() {
      projectThumbs.each(function(img) {
        if (img.inRegion(Y.one(Y.config.win).get('region'))) {
          ImageLoader.load(img, { load: true });
        }
      });
    };
    loadThumbsOnScreen();
    Y.on('scroll', loadThumbsOnScreen, Y.config.win);

    // also load/refresh on resize
    Y.one('window').on('resize', function(e){
      loadThumbsOnScreen();
    });


    // Proactively lazy load
    var lazyImageLoader = Y.later(100, this, function() {
      var bInProcess = projectThumbs.some(function(img) {
        if (img.hasClass('loading')) { // something is loading... wait
          return true;
        } else if(!img.getAttribute('src')) { // start the loading
          ImageLoader.load(img, { load: true });
          return true;
        }
      });
      if (!bInProcess) {
        lazyImageLoader.cancel();
      }
    }, null, true);
  }

  function thumbClickHandler() {
    Y.all('#projectThumbs a.project').each(Y.bind(function(elem) {
      var href = elem.getAttribute('href');
      // set dynamic loader for pages
      if (Y.one('#projectPages [data-url="'+href+'"]').hasClass('page-project')) {
        dynamicLoaders['#'+href] = new Y.Squarespace.DynamicData({
            wrapper: '#projectPages [data-url="'+href+'"]',
            target: 'a.project[href="'+href+'"]',
            injectEl: 'section > *',
            autoOpenHash: true,
            useHashes: true,
            scrollToWrapperPreLoad: true
        });
      } else {
        elem.on('click', function(e) {
          e.halt();
          window.location.hash = '#' + elem.getAttribute('href');
        });
      }
    }, this));
  }

  function scrollToTop(callback) {
    var scrollNodes = Y.UA.gecko || Y.UA.ie >= 10 ? 'html' : 'body',
        scrollLocation = Math.round(Y.one('#page').getXY()[1]);
    new Y.Anim({
      node: scrollNodes,
      to: { scroll: [0, scrollLocation] },
      duration: 0.2,
      easing: Y.Easing.easeBoth
    }).run().on('end', function() {
      // Bug - yui anim seems to stop if target style couldnt be reached in time
      if (Y.one(scrollNodes).get('scrollTop') != scrollLocation) {
        Y.one(scrollNodes).set('scrollTop', scrollLocation);
      }

      callback && callback();
    });
  }

  function lazyOnResize(f,t) {
    var timer;
    Y.one('window').on('resize', function(e){
      if (timer) { timer.cancel(); }
      timer = Y.later(t, this, f);
    });
  }

});
