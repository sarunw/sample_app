document.observe("dom:loaded", function() {
	limiter();
})

function limiter() {
	var text = $('micropost_content').getValue();
	var length = text.length;
	if (length > 140) {
		$('micropost_counter').addClassName('over_limit');
	} else {
		$('micropost_counter').removeClassName('over_limit');
	}
	$('micropost_counter').setValue(140 - length);
}