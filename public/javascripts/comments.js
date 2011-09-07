var AS_Comments = {
  
  showing: false,
  
  showCommentForm: function() {
    if (this.showing) { return; }
    
    $('#comment-overlay').css('top', $(window).scrollTop() + 100 + 'px');
    
    var container = $('#create-comment-container');
    container.data('originalContent', container.html());
    container.fadeIn();
    
    this.showing = true;
    
    return true;
  },
  
  commentFormLoaded: function(data, status, xhr) {
    $('#create-comment-container').html(data);
    
    $('#create-comment-form')
    .bind("ajax:beforeSend", function(evt, xhr, settings){
    })
    .bind("ajax:success", function(evt, data, status, xhr){
      if (data.success) {
        AS_Comments.closeCommentForm();
      } else {
        alert("Your comment could not be posted.");
      }
    })
    .bind("ajax:complete", function(evt, xhr, status){
    })
  },
  
  closeCommentForm: function() {
    if (!this.showing) { return; }
    var container = $('#create-comment-container')
    container.fadeOut(400, function(){container.html(container.data('originalContent')); AS_Comments.showing = false;});
  }
};