addStylePad("padTop", "pad-css:padTop; item-offset:1; menu-form:bar;");
addStylePad("padSub", "pad-css:padSub; item-offset:1; menu-form:bar; direction:abs-center-down;");
addStylePad("padSub2", "item-offset:-1; offset-top:1;");
addStyleItem("itemTop", "css:itemTopOff, itemTopOn; width:actual;");
addStyleItem("itemSub", "css:itemSubOff, itemSubOn; width:actual;");
addStyleItem("itemSub2", "css:itemSub2Off, itemSub2On;");
addStyleFont("font", "css:fontOff, fontOn;");

addStyleMenu("menu", "padTop", "itemTop", "font", "", "", "");
addStyleMenu("sub", "padSub", "itemSub", "font", "", "", "");
addStyleMenu("sub2", "padSub2", "itemSub2", "font", "", "", "");

addStyleGroup("group", "menu", "demo-top");
addStyleGroup("group", "sub", "tool-sub", "game-sub", "forum-sub");
addStyleGroup("group", "sub2", "menu-sub");

addInstance("Demo", "Demo", "position:slot 1; align:center; menu-form:bar; style:group; highlight:no;");
