addStylePad("padSub", "pad-css:menuBar; offset-top:4; offset-left:6;");
addStyleItem("itemTop", "css:menuItem, menuItemOn, menuItemDown, menuItemDown; width:actual; sub-menu:mouse-click;");
addStyleItem("itemSub", "css:menuItem, menuItemSub; width:actual;");
addStyleItem("itemInfo", "css:menuInfo; width:actual;");
addStyleFont("fontTop", "css:menuFontOffBold, menuFontOnBold;");
addStyleFont("fontSub", "css:menuFontOff, menuFontOn;");
addStyleFont("fontInfo", "css:menuFontOffBold;");
addStyleTag("tag", "css:tagOff, tagOn;");
addStyleSeparator("sep", "css:separatorT, separatorB;");

addStyleMenu("menu", "", "itemTop", "fontTop", "", "", "sep");
addStyleMenu("sub", "padSub", "itemSub", "fontSub", "tag", "", "sep");
addStyleMenu("info", "", "itemInfo", "fontInfo", "", "", "");

addStyleGroup("group", "menu", "top");
addStyleGroup("group", "sub", "sub-Home", "sub-CSS", "sub-JS", "sub-DHTML", "sub-ASP", "sub-Java");
addStyleGroup("group", "info", "info");

addInstance("BrainJar", "brainjar", "position:relative holder; menu-form:bar; offset-top:3px; offset-left:5px; style:group; sticky:yes;");

