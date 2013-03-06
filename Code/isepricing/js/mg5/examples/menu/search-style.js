addStylePad("pad", "item-offset:-1; offset-top:1;");
addStylePad("padSub", "item-offset:-1; offset-top:6; offset-left:-6;");
addStyleItem("itemTop", "css:itemTopOff, itemTopOn;");
addStyleItem("itemSub", "css:itemSubOff, itemSubOn;");
addStyleItem("itemX", "css:itemX; width:actual;");
addStyleFont("fontTop", "css:fontOff, fontOn;");
addStyleFont("fontSub", "css:fontOff, fontOn;");
addStyleFont("fontX", "css:fontOn;");
addStyleTag("tag", "css:tagOff, tagOn;");

addStyleMenu("menu", "pad", "itemTop", "fontTop", "", "", "");
addStyleMenu("sub", "pad", "itemSub", "fontSub", "tag", "", "");
addStyleMenu("sub2", "padSub", "itemSub", "fontSub", "", "", "");
addStyleMenu("info", "pad", "itemX", "fontX", "", "", "");

addStyleGroup("group", "menu", "demo-top");
addStyleGroup("group", "sub", "tool-sub", "game-sub", "forum-sub");
addStyleGroup("group", "sub2", "menu-sub");
addStyleGroup("group", "info", "info");

addInstance("Demo", "Demo", "position:relative holder; menu-form:bar; align:center; style:group;");
