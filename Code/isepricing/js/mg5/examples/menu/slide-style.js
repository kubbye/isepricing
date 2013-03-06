addStylePad("pad", "item-offset:-1; offset-top:1; scroll:x-only; step:200;");
addStylePad("padSub", "item-offset:-1; offset-top:6; offset-left:-6;");
addStyleItem("itemTop", "css:itemTopOff, itemTopOn;");
addStyleItem("itemSub", "css:itemSubOff, itemSubOn;");
addStyleItem("itemTab", "css:itemTab;");
addStyleFont("font", "css:fontOff, fontOn;");
addStyleTag("tag", "css:tagOff, tagOn;");

addStyleMenu("menu", "pad", "itemTop", "font", "", "", "");
addStyleMenu("sub", "pad", "itemSub", "font", "tag", "", "");
addStyleMenu("sub2", "padSub", "itemSub", "font", "", "", "");
addStyleMenu("tab", "", "itemTab", "font", "", "", "");

addStyleGroup("group", "menu", "demo-top");
addStyleGroup("group", "sub", "tool-sub", "game-sub", "forum-sub");
addStyleGroup("group", "sub2", "menu-sub");
addStyleGroup("group", "tab", "tab");

addInstance("Demo1", "Demo", "floating:yes; offset-left:20; offset-top:-1; menu-form:bar; align:right; style:group;");
slideMenuBack("Demo1");