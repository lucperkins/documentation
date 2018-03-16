function scrollOffset() {
  var navbarOffset = -1 * (document.querySelector("nav.navbar").offsetHeight + 15);
  var shiftWindow = function() { scrollBy(0, navbarOffset) };
  window.addEventListener("hashchange", shiftWindow);
  window.addEventListener("pageshow", shiftWindow);
  function load() { if (window.location.hash) shiftWindow(); }
}

function addLinkAnchors() {
  anchors.options = {
    icon: '#'
  };
  anchors.add('.content h2, .content h3, .content h4, .content h5, .content h6');
}

function navbarToggle() {
  // Get all "navbar-burger" elements
  var $navbarBurgers = Array.prototype.slice.call(document.querySelectorAll('.navbar-burger'), 0);

  // Check if there are any navbar burgers
  if ($navbarBurgers.length > 0) {

    // Add a click event on each of them
    $navbarBurgers.forEach(function($el) {
      $el.addEventListener('click', function (e) {
        e.preventDefault();

        // Get the target from the "data-target" attribute
        var target = $el.dataset.target;
        var $target = document.getElementById(target);

        // Toggle the class on both the "navbar-burger" and the "navbar-menu"
        $el.classList.toggle('is-active');
        $target.classList.toggle('is-active');

      });
    });
  }
}

function controlModals() {
  document.querySelectorAll('.popup-term').forEach(function(el) {
    el.addEventListener('click', function(e) {
      e.preventDefault();
      var term = this.dataset.modalId;

      var html = document.querySelector('html');
      var modal = document.querySelector(".modal.modal--" + term);

      modal.classList.add('is-active');
      html.classList.add('is-clipped');

      modal.addEventListener('click', function(e) {
        e.preventDefault();
        modal.classList.remove('is-active');
        html.classList.remove('is-clipped');
      });
    });
  });
}

function toggleTocFixed() {
  var topHeight = $('.hero').height();

  $(window).scroll(function() {

    if ($(window).scrollTop() > topHeight) {
      //$('.toc').classList.remove('toc--fixed');
      $('.toc').addClass('toc--fixed');
    } else {
      $('.toc').removeClass('toc--fixed');
    }
  });
}

document.addEventListener('DOMContentLoaded', function () {
  scrollOffset();
  addLinkAnchors();
  navbarToggle();
  controlModals();
  toggleTocFixed();
});
