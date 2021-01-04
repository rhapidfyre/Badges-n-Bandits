
$(function() {
	
	var hud = $("#hud-main");
	
	window.addEventListener('message', function(event) {
		
		var item = event.data;
		if (item.showmenu) { hud.show(); }
		if (item.hidemenu) { hud.hide(); }
    
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
