addMenu("Demo", "demo-top");

addSeparator("demo-top", "barTop");
addLink("demo-top", "Home", "", "", "");
addSubMenu("demo-top", "Tool Scripts", "", "", "tool-sub", "");
addSubMenu("demo-top", "Game Scripts", "", "", "game-sub", "");
addSubMenu("demo-top", "User Forum", "", "", "forum-sub", "");
addLink("demo-top", "Contact", "", "", "");
addSeparator("demo-top", "barBottom");

addSeparator("tool-sub", "subBarTop");
addSubMenu("tool-sub", "Menu Scripts", "", "", "menu-sub", "");
addLink("tool-sub", "Xin Calendar", "", "", "");
addLink("tool-sub", "Select Menu 2", "", "", "");
addLink("tool-sub", "Form Guard", "", "", "");
addSeparator("tool-sub", "barBottom");

addSeparator("game-sub", "subBarTop");
addLink("game-sub", "Soul Of Fighters", "", "", "");
addLink("game-sub", "Simple Tetris 2", "", "", "");
addLink("game-sub", "Bubble Puzzle", "", "", "");
addLink("game-sub", "Puzzle OnSite", "", "", "");
addSeparator("game-sub", "barBottom");

addSeparator("forum-sub", "subBarTop");
addLink("forum-sub", "Menu G5", "", "", "");
addLink("forum-sub", "Xin Calendar", "", "", "");
addLink("forum-sub", "Form Utilities", "", "", "");
addSeparator("forum-sub", "barBottom");

addSeparator("menu-sub", "subBarTop");
addLink("menu-sub", "Menu G5", "", "", "");
addLink("menu-sub", "Menu G4", "", "", "");
addLink("menu-sub", "Menu G3", "", "", "");
addSeparator("menu-sub", "barBottom");

endMenu();
