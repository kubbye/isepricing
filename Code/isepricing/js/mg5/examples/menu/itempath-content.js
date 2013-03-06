addMenu("Demo", "demo-top");

addLink("demo-top", "Home", "", "itempath.html", "home");
addSubMenu("demo-top", "Tool Scripts", "", "ip-tool.html", "tool-sub", "tool");
addSubMenu("demo-top", "Game Scripts", "", "ip-game.html", "game-sub", "game");
addSubMenu("demo-top", "User Forum", "", "ip-forum.html", "forum-sub", "forum");
addLink("demo-top", "Contact", "", "ip-contact.html", "contact");

addSubMenu("tool-sub", "Menu Scripts", "", "ip-tool-menu.html", "menu-sub", "menu");
addLink("tool-sub", "Xin Calendar", "", "ip-tool-cal.html", "cal");
addLink("tool-sub", "Select Menu 2", "", "ip-tool-sm.html", "sm");
addLink("tool-sub", "Form Guard", "", "ip-tool-fg.html", "fg");

addLink("game-sub", "Soul Of Fighters", "", "ip-game-sof.html", "sof");
addLink("game-sub", "Simple Tetris 2", "", "ip-game-tetris.html", "tetris");
addLink("game-sub", "Bubble Puzzle", "", "ip-game-bubble.html", "bubble");
addLink("game-sub", "Puzzle OnSite", "", "ip-game-puzzle.html", "puzzle");

addLink("forum-sub", "Menu G5", "", "ip-forum-menug5.html", "menug5");
addLink("forum-sub", "Xin Calendar", "", "ip-forum-xincal.html", "xincal");
addLink("forum-sub", "Form Utilities", "", "ip-forum-misc.html", "misc");

addLink("menu-sub", "Menu G5", "", "ip-tool-menu-g5.html", "g5");
addLink("menu-sub", "Menu G4", "", "ip-tool-menu-g4.html", "g4");
addLink("menu-sub", "Menu G3", "", "ip-tool-menu-g3.html", "g3");

endMenu();
