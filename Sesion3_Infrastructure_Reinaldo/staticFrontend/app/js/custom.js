
 /* jQuery Pre loader
  -----------------------------------------------*/
$(window).load(function(){
    $('.preloader').fadeOut(1000); // set duration in brackets    
});


$(document).ready(function() {

  /* Hide mobile menu after clicking on a link
    -----------------------------------------------*/
    $('.navbar-collapse a').click(function(){
        $(".navbar-collapse").collapse('hide');
    });


  /* Owl Carousel
    -----------------------------------------------*/
  $(document).ready(function() {
    $("#owl-testimonial").owlCarousel({
      autoPlay: 5000,
      items : 2,
      itemsDesktop : [1199,1],
      itemsDesktopSmall : [979,2],
    });
  });


  /* Parallax section
    -----------------------------------------------*/
  function initParallax() {
    $('#home').parallax("100%", 0.1);
    $('#service').parallax("100%", 0.3);
    $('#about').parallax("100%", 0.2);
    $('#team').parallax("100%", 0.3);
    $('#portfolio').parallax("100%", 0.1);
    $('#blog').parallax("100%", 0.2);
    $('#faq').parallax("100%", 0.1);
    $('#testimonial').parallax("100%", 0.3);
    $('#contact').parallax("100%", 0.1);

  }
  initParallax();


  /* Nivo lightbox
    -----------------------------------------------*/
  $('#portfolio .col-md-4 a').nivoLightbox({
        effect: 'fadeScale',
    });


  /* wow
  -------------------------------*/
  new WOW({ mobile: false }).init();

  });

