addStylePad("pad", "item-offset:-1; offset-top:1;");
addStylePad("padSub", "item-offset:-1; offset-top:6; offset-left:-6;");

addStyleItem("itemTop", "css:itemTopOff, itemTopOn;");
addStyleItem("itemSub", "css:itemSubOff, itemSubOn;");

addStyleFont("fontTop", "css:fontOff, fontOn;");
addStyleFont("fontSub", "css:fontOff, fontOn;");

addStyleTag("tag", "css:tagOff, tagOn;");

addStyleMenu("menu", "pad", "itemTop", "fontTop", "", "", "");
addStyleMenu("sub", "pad", "itemSub", "fontSub", "tag", "", "");
addStyleMenu("sub2", "padSub", "itemSub", "fontSub", "", "", "");

addStyleMenu("menu-style-name", "pad-style", "item-style", "font-style", "tag-style", "icon-style", "separator-style");


addStyleGroup("group", "menu", "demo-top");
addStyleGroup("group", "sub", "tool-sub", "game-sub", "forum-sub");
addStyleGroup("group", "sub2", "menu-sub");

//addInstance("Demo", "Demo", "position:slot 6; menu-form:bar; align:left; valign:bottom; style:group;");
addInstance("Demo", "Demo", "position:relative holder; menu-form:bar; align:left; style:group;");
