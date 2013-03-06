addMenu("Demo", "demo-top");

addLink("demo-top", "&nbsp;Home", "", "", "");
addSubMenu("demo-top", "&nbsp;Tool Scripts", "", "", "tool-sub", "");
addSubMenu("demo-top", "&nbsp;Game Scripts", "", "", "game-sub", "");
addSubMenu("demo-top", "&nbsp;User Forum", "", "", "forum-sub", "");
addLink("demo-top", "&nbsp;Contact", "", "", "");

addSubMenu("tool-sub", "&nbsp;Menu Scripts", "", "", "menu-sub", "");
addLink("tool-sub", "&nbsp;Xin Calendar", "", "", "");
addLink("tool-sub", "&nbsp;Select Menu 2", "", "", "");
addLink("tool-sub", "&nbsp;Form Guard", "", "", "");

addLink("game-sub", "&nbsp;Soul Of Fighters", "", "", "");
addLink("game-sub", "&nbsp;Simple Tetris 2", "", "", "");
addLink("game-sub", "&nbsp;Bubble Puzzle", "", "", "");
addLink("game-sub", "&nbsp;Puzzle OnSite", "", "", "");

addLink("forum-sub", "&nbsp;Menu G5", "", "", "");
addLink("forum-sub", "&nbsp;Xin Calendar", "", "", "");
addLink("forum-sub", "&nbsp;Form Utilities", "", "", "");

addLink("menu-sub", "&nbsp;Menu G5", "", "", "");
addLink("menu-sub", "&nbsp;Menu G4", "", "", "");
addLink("menu-sub", "&nbsp;Menu G3", "", "", "");

// ------
addMenu("Tool", "tool-sub");

addSubMenu("tool-sub", "&nbsp;Menu Scripts", "", "", "menu-sub", "");
addLink("tool-sub", "&nbsp;Xin Calendar", "", "", "");
addLink("tool-sub", "&nbsp;Select Menu 2", "", "", "");
addLink("tool-sub", "&nbsp;Form Guard", "", "", "");

addLink("menu-sub", "&nbsp;Menu G5", "", "", "");
addLink("menu-sub", "&nbsp;Menu G4", "", "", "");
addLink("menu-sub", "&nbsp;Menu G3", "", "", "");

// ------
addMenu("Game", "game-sub");

addLink("game-sub", "&nbsp;Soul Of Fighters", "", "", "");
addLink("game-sub", "&nbsp;Simple Tetris 2", "", "", "");
addLink("game-sub", "&nbsp;Bubble Puzzle", "", "", "");
addLink("game-sub", "&nbsp;Puzzle OnSite", "", "", "");

// ------
addMenu("Forum", "forum-sub");

addLink("forum-sub", "&nbsp;Menu G5", "", "", "");
addLink("forum-sub", "&nbsp;Xin Calendar", "", "", "");
addLink("forum-sub", "&nbsp;Form Utilities", "", "", "");

endMenu();
