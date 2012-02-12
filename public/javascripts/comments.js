var AS_Comments = {
  
  commentFormLoaded: function(data, status, xhr) {
    $('#create-comment-container').html(data);
    
    $('#create-comment-form')
    .bind("ajax:beforeSend", function(evt, xhr, settings){
    })
    .bind("ajax:success", function(evt, data, status, xhr){
      if (data.success) {
		$('#create-comment-container').modal('hide');
      } else {
        $('#create-comment-form .control-group').addClass('error');
      }
    })
    .bind("ajax:complete", function(evt, xhr, status){
    })
  }
};