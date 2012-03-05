// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function() {
	$("input:text:visible:first").focus();
	
	$('#total-progress').tooltip({'placement': 'bottom'});
	
	$('.artist-badge .label').tooltip({'placement': 'right'});
});

var AS = {
	
	toggleWorkPopup: function(button) {
		var p = $('#work-popup');
		var becomeVisible = !p.is(':visible');
		p.toggle();
		
		var buttonImage = button.children('img');
		buttonImage.toggleClass('work-button-selected');
		p.css('top', buttonImage.offset().top + buttonImage.height() + 4 + 'px');
		
		if (becomeVisible && (!AS.workRequest || AS.workRequest.status != 200)) {
			AS.workRequest = $.ajax('/artists/your/work', { success: AS.workLoaded })
		}
	},
	
	workRequest: null,
	
	workLoaded: function(data, status, xhr) {
		$('#work-popup').html(data);
	}
	
}
