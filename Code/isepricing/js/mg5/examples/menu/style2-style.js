addStylePad("bar", "holder-css:holder; pad-css:bar; scroll:yes;");
addStyleItem("itemTop", "css:itemTopNormal, itemTopOn, itemTopDown;");
addStyleItem("itemSub", "css:itemSubNormal, itemSubOn, itemSubDown;");
addStyleFont("font", "css:fontNormal, fontOn, fontDown;");
addStyleTag("tag", "css:tagNormal, tagOn, tagDown;");

addStyleMenu("top", "bar", "itemTop", "font", "tag", "", "");
addStyleMenu("sub", "bar", "itemSub", "font", "tag", "", "");

addStyleGroup("group", "top", "demo-top");
addStyleGroup("group", "sub", "tool-sub", "game-sub", "forum-sub", "menu-sub");

addInstance("Demo", "Demo", "position:relative demo; offset-left:20; offset-top:20; menu-form:bar; direction:right-up; style:group;");
