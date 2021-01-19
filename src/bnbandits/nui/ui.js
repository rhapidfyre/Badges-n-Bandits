
function wantedBanner(wL) {
  let fDelay = 5000;
  var div = $("#hud-wants");
  var wantMsg = $("#wants-top");
  var wantSub = $("#wants-btm");
  let mMsg = 'INNOCENT';
  let mSub = 'YOU NO LONGER HAVE A BOUNTY';
  if (wL == "mw")       {mMsg = 'MOST WANTED'; mSub = 'YOU ARE NOW THE MOST WANTED';}
  else if (wL == "dec") {mMsg = 'WANTED'; mSub = 'YOUR WANTED LEVEL HAS DECREASED';}
  else if (wL == "inc") {mMsg = 'WANTED'; mSub = 'YOUR WANTED LEVEL HAS INCREASED';}
  if (!div.is(":visible")) {
    wantMsg.html('&nbsp;');
    wantSub.html('&nbsp;');
    wantMsg.html(mMsg);
    div.fadeIn(function() {wantSub.html(mSub);});
    div.delay(fDelay).fadeOut(1000);
  }
  else {
    // If div is visible, don't repeat divs already displayed
    if (mMsg != wantMsg.text()) {
      console.log("Queuing '" + mMsg + "' for load. ('" + (wantMsg.text()) +"')");
      setTimeout(function() {wantedBanner(wL);}, 1000)
    } else {
      console.log("Ignoring '" + mMsg + "' (Already Displayed)");
    }
  };
  
}

$(function() {

	var hud = $("#hud-main");

	window.addEventListener('message', function(event) {

		var item = event.data;

		if (item.showmenu) { $('#'+item.showmenu).show(); }
		if (item.hidemenu) { $('#'+item.showmenu).hide(); }
    if (item.wanted)   wantedBanner(item.wanted);

    if (item.showscores)
      $('#wrap').show();

    if (item.hidescores)
      $('#wrap').hide();

    if (item.updatescores) {
      $("#player_table").empty();
      $('#player_table').append("<tr class=\"heading\"><th>ID</th><th>Name</th></tr>");
      $('#player_table').append(item.updatescores);
    }

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

function SetModel(mValue) {
	if (mValue == 1)      $.post('http://bnbandits/CharacterCreator', JSON.stringify({prevModel:true}));
	else if (mValue == 2) $.post('http://bnbandits/CharacterCreator', JSON.stringify({nextModel:true}));
	else if (mValue == 2) $.post('http://bnbandits/CharacterCreator', JSON.stringify({swapGender:true}));
}

function SelectModel() {
	$.post('http://bnbandits/CharacterCreator', JSON.stringify({select:true}));
}
