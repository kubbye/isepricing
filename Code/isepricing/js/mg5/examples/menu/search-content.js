addMenu("Demo", "demo-top");

addLink("demo-top", "Home", "", "", "");
addSubMenu("demo-top", "Tool Scripts", "", "", "tool-sub", "");
addSubMenu("demo-top", "Game Scripts", "", "", "game-sub", "");
addSubMenu("demo-top", "Rate Me", "", "", "rate-sub", "");
addSubMenu("demo-top", "Search", "", "", "search-sub", "");

addSubMenu("tool-sub", "Menu Scripts", "", "", "menu-sub", "");
addLink("tool-sub", "Xin Calendar", "", "", "");
addLink("tool-sub", "Select Menu 2", "", "", "");
addLink("tool-sub", "Form Guard", "", "", "");

addLink("menu-sub", "Menu G5", "", "", "");
addLink("menu-sub", "Menu G4", "", "", "");
addLink("menu-sub", "Menu G3", "", "", "");

addLink("game-sub", "Soul Of Fighters", "", "", "");
addLink("game-sub", "Simple Tetris 2", "", "", "");
addLink("game-sub", "Bubble Puzzle", "", "", "");
addLink("game-sub", "Puzzle OnSite", "", "", "");

addInfo("rate-sub", '<form class="nomargin"><table cellspacing="1" cellpadding="0" border="0" bgcolor="#ffffff"><tr><td><table width="130" cellspacing="0" cellpadding="0" border="0" bgcolor="#cccccc"><tr align="left"><td align="right"><input type="radio" name="rate" value="1"></td><td>&nbsp;Excellent&nbsp;</td></tr><tr align="left"><td align="right"><input type="radio" name="rate" value="2"></td><td>&nbsp;Good&nbsp;</td></tr><tr align="left"><td align="right"><input type="radio" name="rate" value="3"></td><td>&nbsp;Average&nbsp;</td></tr><tr align="left"><td align="right"><input type="radio" name="rate" value="4"></td><td>&nbsp;Bad&nbsp;</td></tr><tr align="left"><td align="right"><input type="radio" name="rate" value="5"></td><td>&nbsp;Terrible&nbsp;</td></tr></table></td></tr><tr><td align="center" bgcolor="#cccccc"><table><tr><td><input type="submit" value="Vote" class="button"></td></tr></table></td></tr></table></form>', "info");

addInfo("search-sub", '<form class="nomargin" action="http://search.yahoo.com/bin/search" method="get" target="yahoo"><table cellspacing="1" cellpadding="1" width="132"><tr bgcolor="#cccccc"><td colspan="2" class="button">&nbsp;Yahoo:&nbsp;</td></tr><tr bgcolor="#cccccc"><td><input class="button" type="text" name="p" value="" size="11"></td><td><input type="submit" value="Go" class="button"></td></tr></table></form>', "info");
addInfo("search-sub", '<form class="nomargin" action="http://www.google.com/search" method="get" target="google"><input type="hidden" name="hits" value="25"><input type="hidden" name="disp" value="Text Only"><table cellspacing="1" cellpadding="1" width="132"><tr bgcolor="#cccccc"><td colspan="2" class="button">&nbsp;Google:&nbsp;</td></tr><tr bgcolor="#cccccc"><td><input class="button" type="text" name="q" value="" size="11"></td><td><input type="submit" value="Go" class="button"></td></tr></table></form>', "info");

endMenu();
