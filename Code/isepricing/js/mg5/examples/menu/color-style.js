addStylePad("pad", "offset-top:1;");

addStylePad("toolSub", "pad-css:padTool; offset-top:3;");
addStylePad("gameSub", "pad-css:padGame; offset-top:3;");
addStylePad("forumSub", "pad-css:padForum; offset-top:3;");
addStylePad("toolSub2", "pad-css:padTool; offset-top:6; offset-left:-6;");

addStyleItem("itemHome", "css:itemHomeOff, itemHomeOn;");
addStyleItem("itemTool", "css:itemToolOff, itemToolOn;");
addStyleItem("itemGame", "css:itemGameOff, itemGameOn;");
addStyleItem("itemForum", "css:itemForumOff, itemForumOn;");
addStyleItem("itemContact", "css:itemContactOff, itemContactOn;");

addStyleFont("font", "css:fontOff, fontOn;");
addStyleTag("tag", "css:tagOff, tagOn;");


addStyleMenu("menu", "pad", "", "font", "", "", "");

addStyleMenu("itemHome", "", "itemHome", "font", "", "", "");
addStyleMenu("itemTool", "", "itemTool", "font", "", "", "");
addStyleMenu("itemGame", "", "itemGame", "font", "", "", "");
addStyleMenu("itemForum", "", "itemForum", "font", "", "", "");
addStyleMenu("itemContact", "", "itemContact", "font", "", "", "");

addStyleMenu("subTool", "toolSub", "itemTool", "font", "tag", "", "");
addStyleMenu("subGame", "gameSub", "itemGame", "font", "tag", "", "");
addStyleMenu("subForum", "forumSub", "itemForum", "font", "tag", "", "");

addStyleMenu("subTool2", "toolSub2", "itemTool", "font", "", "", "");


addStyleGroup("group", "menu", "demo-top");
addStyleGroup("group", "itemHome", "home");
addStyleGroup("group", "itemTool", "tool");
addStyleGroup("group", "itemGame", "game");
addStyleGroup("group", "itemForum", "forum");
addStyleGroup("group", "itemContact", "contact");

addStyleGroup("group", "subTool", "tool-sub");
addStyleGroup("group", "subGame", "game-sub");
addStyleGroup("group", "subForum", "forum-sub");

addStyleGroup("group", "subTool2", "menu-sub");


addInstance("Demo", "Demo", "position:relative holder; menu-form:bar; align:center; style:group;");
