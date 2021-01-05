function pollVisibility(div, tMessage) {
  if (!$("#hideThis").is(":visible")) {
    div.slideDown();
    setTimeout(function() { div.slideUp(); }, 3000);
  } else {
    setTimeout(pollVisibility, 500);
  }
}

$(function() {

	var hud = $("#hud-main");

	window.addEventListener('message', function(event) {

		var item = event.data;

		if (item.showmenu) { hud.show(); }
		if (item.hidemenu) { hud.hide(); }

    if (item.wanted) {
      if (item.wanted == "mw")
        pollVisibility($("#wanted-msg"), 'MOST WANTED');
      else
        pollVisibility($("#wanted-msg"), 'WANTED');
    }
    if (item.innocent)
      pollVisibility($("#wanted-msg"), 'INNOCENT');

	});

  // Pressing the ESC key with the menu open closes it
  document.onkeyup = function (data) {
    if (data.which == 27) {
      if (menu.is( ":visible" )) {ExitMenu();}
    }
  };

});

function ExitMenu() {
	$.post('http://bnbandits/MainMenu', JSON.stringify({exit:true}));
}
