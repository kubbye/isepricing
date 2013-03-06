addStylePad("pad", "item-offset:-1;");
addStylePad("padSub", "item-offset:-1; offset-top:1;");

addStyleItem("itemTop", "css:itemTopOff, itemTopOn;");
addStyleItem("itemSub", "css:itemSubOff, itemSubOn;");
addStyleItem("itemTitle", "css:itemTitle;");

addStyleFont("fontTop", "css:fontOff, fontOn;");
addStyleFont("fontSub", "css:fontOff, fontOn;");
addStyleFont("fontTitle", "css:fontTitle");

addStyleTag("tagStyle", "css:tagDownOff, tagDownOn;");
addStyleTag("tagTitle", "css:tagDownOn;");

addStyleMenu("menu", "pad", "itemTop", "fontTop", "tagStyle", "", "");
addStyleMenu("title", "", "itemTitle", "fontTitle", "tagTitle", "", "");

setDefaultStyle("padSub", "itemSub", "fontSub", "", "", "");

addStyleGroup("group", "menu", "maker-top");
addStyleGroup("group", "title", "maker");
