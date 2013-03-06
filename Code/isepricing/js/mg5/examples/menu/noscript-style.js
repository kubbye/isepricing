addStylePad("pad", "item-offset:-1; offset-top:6; offset-left:-6;");
addStyleItem("item", "css:itemOff, itemOn;");
addStyleFont("font", "css:fontOff, fontOn;");
addStyleTag("tag", "css:tagOff, tagOn;");
setDefaultStyle("pad", "item", "font", "tag", "", "");

addInstance("Tool", "Tool", "position:relative toolBar; offset-top:20; visibility:hidden;");
addInstance("Game", "Game", "position:relative gameBar; offset-top:20; visibility:hidden;");
addInstance("Forum", "Forum", "position:relative forumBar; offset-top:20; visibility:hidden;");

addInstance("Demo", "Demo", "position:relative holder;");
