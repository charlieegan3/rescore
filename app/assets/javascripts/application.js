// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

function movieSuggest()
{
  var search_param = $("#movie-search-box").val();
  console.log("Searching: " + search_param);

  if(search_param != "") {
    $("#search-results").html("<strong>Results:</strong></br>");
    $.ajax({
      url: "/movies/search_by_title.json?query="+search_param,
      context: document.body
    }).done(function(data) {
      if(data.length > 0) {
        for(i=0; i<data.length; i++) {
          var title = data[i]['title'];
          var slug = data[i]['slug'];
          $("#search-results").append("<a href='/movies/"+ slug + "'>" + title + "</a></br>");
        }
      }
      else {
        $("#search-results").html("No results");
      }
    });
  }
  else {
    $("#search-results").html("");
  }
}

$(document).ready(function(){
  $(".rescore-flash").delay(2400).fadeOut("slow");

  $("#movie-search-box").on('input', function(e) {
    movieSuggest();
  });
});
