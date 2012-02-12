var img;
var imgData;
var pixelArray;
var zoomIndex = 1;
var zoomLevels = [1, 2, 4, 6];
var scale = zoomLevels[zoomIndex];
var gridShowing = false;
var hoverColour = [0, 0, 0, 0];
var chosenColour;
var previousPixel;
var picking = false,
	drawing = false;
var spriteContext,
	cursorContext;
var gridDirty = true;
var orderedColours = [];
var colourIndexes = {};
var edited = false;

$(window).bind('beforeunload', function() {
	if (edited) {
		return "You have unsaved changes which will be lost if you leave this page!";
	}
	
	return;
});

$(window).scroll(function() {
	var windowTop = $(this).scrollTop();
	var navHeight = $('.navbar').height();
	console.log(navHeight + " " + windowTop);
	$('#art-toolbar').css('padding-top', Math.max(0, navHeight - windowTop) + 10 + 'px');
});

$(document).ready(function() {
	var spriteCanvas = $('canvas#sprite');
	
	spriteCanvas.bind('contextmenu', function() {
		return false;
	});
	
	$('#eyedrop-label').tooltip({'placement': 'right'});
	$('#chosen-colour-label').tooltip({'placement': 'right'});
	
	$('#grid-toggle').click(toggleGrid);
	
	$('#sprite-submit').click(submitSprite);
	
	$('#zoom-in').click(function() {
		if (zoomIndex < zoomLevels.length - 1) {
			zoomIndex += 1;
			scale = zoomLevels[zoomIndex];
			gridDirty = true;
			redrawEditor();
		}
	});
	
	$('#zoom-out').click(function() {
		if (zoomIndex > 0) {
			zoomIndex -= 1;
			scale = zoomLevels[zoomIndex];
			gridDirty = true;
			redrawEditor();
		}
	});
	
	$('body').mouseup(function() {
		drawing = false;
		picking = false;
	})
	
	spriteCanvas.mousemove(function(e) {
		var eventPixel = canvasPixelFromEvent(e);
		
		var movedPixels = true;
		
		if (previousPixel && previousPixel.x == eventPixel.x && previousPixel.y == eventPixel.y) {
			movedPixels = false;
		}
		
		if (movedPixels && previousPixel) {
			refreshCursor(eventPixel.x, eventPixel.y);
		}
		
		if (!movedPixels) {
			return;
		}
		
		var distanceMovedX = previousPixel ? Math.abs(previousPixel.x - eventPixel.x) : 0;
		var distanceMovedY = previousPixel ? Math.abs(previousPixel.y - eventPixel.y) : 0;
		
		var i = (eventPixel.y * imgData.width + eventPixel.x) * 4;
		var r = pixelArray[i];
		var g = pixelArray[i + 1];
		var b = pixelArray[i + 2];
		var a = pixelArray[i + 3];
		
		hoverColour = [r, g, b, a];
		$('#hover-colour .colour').css('background-color', colourFormat(hoverColour));
		
		if (drawing) {
			if (distanceMovedY <= 1 && distanceMovedX <= 1) {
				drawPixel(eventPixel.x, eventPixel.y, chosenColour);
			} else {
				drawLine(previousPixel.x, previousPixel.y, eventPixel.x, eventPixel.y, chosenColour);
			}
		}
		
		previousPixel = eventPixel;
	});
	
	spriteCanvas.mouseout(function() {
		if (previousPixel) {
			clearPixel(cursorContext, previousPixel.x, previousPixel.y);
		}
		
		previousPixel = null;
	});
	
	spriteCanvas.mousedown(function(e) {
		if (e.which == 1 && !picking) {
			drawing = true;
			drawPixel(previousPixel.x, previousPixel.y, chosenColour);
		}
		if (e.which == 3 && !drawing) { // right click
			picking = true;
			refreshCursor(previousPixel.x, previousPixel.y);
		}
	});
	
	spriteCanvas.mouseup(function(e) {
		if (e.which == 1) {
			drawing = false;
		}
		if (e.which == 3) { // right click
			picking = false;
			chosenColour = hoverColour.slice(0);
			$('#current-colour .colour').css('background-color', colourFormat(chosenColour));
			
			var key = chosenColour.join(',');
			var index = colourIndexes[key];
			if (index !== undefined) {
				$('#palette .colour-preview').removeClass('selected');
				$('#palette .colour-preview:nth-child(' + (index + 1) + ')').addClass('selected');
			}
			
			refreshCursor(previousPixel.x, previousPixel.y)
		}
	});
	
	$.get(IMAGE_DATA_PATH, function(data) {
		loadImage('data:image/png;base64,' + data);
	});
});

function submitSprite() {
	$('#sprite-submit').attr('disabled', 'disabled');
	
	var tempCanvas = $('<canvas></canvas>')[0];
	tempCanvas.width = imgData.width;
	tempCanvas.height = imgData.height;
	
	var tempCtx = tempCanvas.getContext('2d');
	tempCtx.putImageData(imgData, 0, 0);
	
	var imageDataBase64 = tempCanvas.toDataURL().split(',')[1];
	$.post(
		SUBMIT_IMAGE_PATH,
		{ 'image_data': imageDataBase64 },
		function(data, textStatus) {
			edited = false;
			document.location = data;
		}
	).error(function(xhr) {
		var message = xhr.status == 403 ? 'You are not the owner of this Pokemon.' : 'Error';
		alert('Could not save your changes.\n' + message);
		$('#sprite-submit').removeAttr('disabled');	
	});
}

function canvasPixelFromEvent(e) {
	var offset = $(e.target).offset();
	var offsetX = e.pageX - offset.left;
	var offsetY = e.pageY - offset.top;
	
	return { 'x' : Math.floor(offsetX / scale), 'y' : Math.floor(offsetY / scale) };
}

function colourFormat(rOrRGB, g, b, a) {
	if (rOrRGB instanceof Array) {
		g = rOrRGB[1];
		b = rOrRGB[2];
		a = rOrRGB[3];
		rOrRGB = rOrRGB[0];
	}
	return "rgba(" + rOrRGB + "," + g + "," + b + "," + a + ")";
}

function toggleGrid() {
	gridShowing = !$('#grid-toggle').hasClass('active');
	
	if (gridDirty) {
		drawGridOnCanvas($('canvas#grid')[0]);
	}
	
	$('canvas#grid').toggle(gridShowing && scale > 1);
}

function refreshSpritePixel(x, y, clear) {
	var i = (y * img.width + x) * 4;
	var r = pixelArray[i];
	var g = pixelArray[i + 1];
	var b = pixelArray[i + 2];
	var a = pixelArray[i + 3];
	
	if (clear) {
		spriteContext.clearRect(x * scale, y * scale, scale, scale);
	}
	
	spriteContext.fillStyle = colourFormat(r, g, b, a);
	spriteContext.fillRect(x * scale, y * scale, scale, scale);
	
	return [r, g, b, a];
}

function drawPixel(x, y, colour) {
	var i = (y * img.width + x) * 4;
	var changed = false;
	for (var component = 0; component < 4; component++) {
		changed = changed || (pixelArray[i + component] != colour[component]);
		pixelArray[i + component] = colour[component];
	}
	
	if (changed) {
		$('#sprite-submit').removeAttr('disabled');
		edited = true;
		refreshSpritePixel(x, y, true);
	}
}

// Taken from http://en.wikipedia.org/wiki/Bresenham's_line_algorithm
function drawLine(x1, y1, x2, y2, colour) {
	var diffX = Math.abs(x1 - x2);
	var diffY = Math.abs(y1 - y2);
	
	var stepX = x1 < x2 ? 1 : -1;
	var stepY = y1 < y2 ? 1 : -1;
	
	var error = diffX - diffY;
	
	while (true) {
		drawPixel(x1, y1, colour);
		if (x1 == x2 && y1 == y2) {
			break;
		}
		
		var error2 = 2 * error;
		
		if (error2 > -diffY) {
			error -= diffY;
			x1 += stepX;
		}
		if (error2 < diffX) {
			error += diffX;
			y1 += stepY;
		}
	}
}

function setPixel(ctx, x, y, colour) {
	ctx.fillStyle = colourFormat(colour);
	ctx.fillRect(x * scale, y * scale, scale, scale);
}

function clearPixel(ctx, x, y) {
	ctx.clearRect(x * scale, y * scale, scale + 1, scale + 1);
}

function outlinePixel(ctx, x, y) {
	ctx.lineStyle = 'black';
	ctx.strokeRect(x * scale + 0.5, y * scale + 0.5, scale, scale);
}

function loadImage(url) {
	img = new Image();
	imgData = undefined;
	pixelArray = undefined;

	$(img).load(function() {
		$('#sprite-submit').attr('disabled', 'disabled');
		edited = false;
		redrawEditor();
	});
	
	img.src = url;
}

function redrawEditor() {
	displayImageOnSpriteCanvas();
	drawGridOnCanvas($('canvas#grid')[0]);
}

function refreshCursor(x, y) {
	if (previousPixel) {
		clearPixel(cursorContext, previousPixel.x, previousPixel.y);
	}
	
	if (!picking) {
		setPixel(cursorContext, x, y, chosenColour);
	}
	
	if (picking || scale > 2 || chosenColour[3] == 0) {
		outlinePixel(cursorContext, x, y);
	}
}

function displayImageOnSpriteCanvas() {
	var spriteCanvas = $('canvas#sprite')[0];
	var cursorCanvas = $('canvas#cursor')[0];
	
	var tempCanvas = $('<canvas></canvas>')[0];
	var tempCtx = tempCanvas.getContext('2d');
	
	tempCanvas.width = img.width;
	tempCanvas.height = img.height;
	tempCtx.drawImage(img, 0, 0, img.width, img.height);
	
	var canvasWidth = img.width * scale;
	var canvasHeight = img.height * scale;
	
	cursorCanvas.width = canvasWidth;
	cursorCanvas.height = canvasHeight;
	cursorContext = cursorCanvas.getContext('2d');
	
	spriteCanvas.width = canvasWidth;
	spriteCanvas.height = canvasHeight;
	spriteContext = spriteCanvas.getContext('2d');
	
	$('#editor').width(canvasWidth);
	$('#editor').height(canvasHeight);
	$('#editor').toggle(true);
	
	if (!imgData) {
		imgData = tempCtx.getImageData(0, 0, img.width, img.height);
		pixelArray = imgData.data;
	}
	
	var frequencyMap = {};
	
	for (var x = 0; x < img.width; x++) {
		for (var y = 0; y < img.height; y++) {
			var colour = refreshSpritePixel(x, y);
			var key = colour.join(',');
			var value = frequencyMap[key] || 0;
			frequencyMap[key] = value + 1;
		}
	}
	
	if (orderedColours.length > 0) {
		return;
	}
	
	orderedColours = [];
	colourIndexes = {};
	
	for (var colour in frequencyMap) {
		orderedColours.push({ 'colour': colour, 'count': frequencyMap[colour] });
	}
	orderedColours.sort(function(c1, c2) {
		return c2.count - c1.count;
	});
	
	$('#palette').empty();
	
	$.each(orderedColours, function (i, oc) {
		colourIndexes[oc.colour] = i;
		
		var colourComponents = $.map(oc.colour.split(','), function (val) {
			return parseInt(val);
		});
		
		var div = $('<div class="colour-preview striped"><div class="colour"></div></div>');
		
		if (i == 0) {
			chosenColour = colourComponents;
			$(div).addClass('selected');
		}
		
		$('#palette').append(div);
		
		var tooltipTitle = (colourComponents[3] == 0) ? 'Clear' : 'R: ' + colourComponents[0] + '<br />G: ' + colourComponents[1] + '<br />B: ' + colourComponents[2];
		
		div.tooltip({ 'placement': 'right', 'title': tooltipTitle });
		
		div.children('.colour').css('background-color', colourFormat(colourComponents));
		div.click(function() {
			$('#palette .colour-preview').removeClass('selected');
			chosenColour = colourComponents;
			$('#current-colour .colour').css('background-color', colourFormat(chosenColour));
			$(this).addClass('selected');
		});
	});
	$('#palette').append('<div class="clearfix"></div>');
}

function drawGridOnCanvas(canvas) {
	var showGrid = gridShowing && scale > 1;
	$(canvas).toggle(showGrid);
	if (!showGrid)
		return;
	
	var ctx = canvas.getContext('2d');
	var width = imgData.width * scale;
	var height = imgData.height * scale;
	
	canvas.width = width;
	canvas.height = height;
	
	ctx.lineWidth = 1;
	ctx.strokeStyle = colourFormat(200, 200, 200, 1.0);
	
	for (var x = 0; x < width; x += scale) {
		ctx.beginPath();
		ctx.moveTo(x + 0.5, 0);
		ctx.lineTo(x + 0.5, height);
		ctx.closePath();
		ctx.stroke();
	}
	
	for (var y = 0; y < height; y += scale) {
		ctx.beginPath();
		ctx.moveTo(0, y + 0.5);
		ctx.lineTo(width, y + 0.5);
		ctx.closePath();
		ctx.stroke();
	}
	
	gridDirty = false;
}