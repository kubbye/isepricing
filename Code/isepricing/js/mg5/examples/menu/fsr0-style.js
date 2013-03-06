addStylePad("pad", "item-offset:-1; offset-left:-1;");
addStylePad("padSub", "item-offset:-1; offset-top:6; offset-left:6;");
addStyleItem("item", "css:itemOff, itemOn;");
addStyleFont("font", "css:fontOff, fontOn;");
addStyleTag("tag", "css:tagOff, tagOn;");

addStyleMenu("menu", "pad", "item", "font", "tag", "", "");
addStyleMenu("sub2", "padSub", "item", "font", "", "", "");

addStyleGroup("group", "menu", "demo-top", "tool-sub", "game-sub", "forum-sub");
addStyleGroup("group", "sub2", "menu-sub");

addInstance("Demo", "Demo", "position:slot 0; align:left; valign:top; direction:left-down; style:group;");
