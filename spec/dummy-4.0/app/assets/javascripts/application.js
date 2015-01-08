//= require jquery
//= require jquery_ujs
//= require sortable

//= require jquery-ui/sortable

// for drag and drop feature test
//= require jquery.simulate

$(document).ready(function(){
  $('*[data-role=activerecord_sortable]').activerecord_sortable();
});
