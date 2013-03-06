addStylePad("pad", "pad-css:pad; item-offset:2;");
addStylePad("padSub", "pad-css:padSub; offset-top:4; offset-left:2;");
addStylePad("padSub2", "pad-css:padSub2; offset-top:6; offset-left:-3;");
addStyleItem("itemTop", "css:itemTopOff, itemTopOn; valign:bottom;");
addStyleItem("itemSub", "css:itemOff, itemOn;");
addStyleFont("fontTop", "css:fontTopOff, fontTopOn;");
addStyleFont("fontSub", "css:fontOff, fontOn;");
addStyleTag("tag", "css:tagOff, tagOn;");

addStyleMenu("menu", "pad", "itemTop", "fontTop", "", "", "");
addStyleMenu("sub", "padSub", "itemSub", "fontSub", "tag", "", "");
addStyleMenu("sub2", "padSub2", "itemSub", "fontSub", "", "", "");

addStyleGroup("group", "menu", "demo-top");
addStyleGroup("group", "sub", "tool-sub", "game-sub", "forum-sub");
addStyleGroup("group", "sub2", "menu-sub");

addInstance("Demo", "Demo", "position:relative holder; menu-form:bar; align:center; style:group;");
