addStylePad("pad", "item-offset:-7;");
addStylePad("padSub", "offset-top:-4;");
addStyleItem("itemL", "css:itemLOff, itemLOn;");
addStyleItem("itemM", "css:itemMOff, itemMOn;");
addStyleItem("itemR", "css:itemROff, itemROn;");
addStyleItem("itemI", "css:itemIOff, itemIOn;");

addStyleFont("font", "css:fontOff, fontOn;");
addStyleFont("fontSub", "css:fontSubOff, fontSubOn;");

addStyleSeparator("separatorT", "css:separatorT;");
addStyleSeparator("separatorB", "css:separatorB;");

addStyleMenu("menu", "pad", "", "font", "", "", "");
addStyleMenu("menuSub", "padSub", "", "font", "", "", "");
addStyleMenu("menuL", "pad", "itemL", "font", "", "", "");
addStyleMenu("menuM", "pad", "itemM", "font", "", "", "");
addStyleMenu("menuR", "pad", "itemR", "font", "", "", "");
addStyleMenu("menuI", "pad", "itemI", "fontSub", "", "", "");
addStyleMenu("sepTop", "", "", "", "", "", "separatorT");
addStyleMenu("sepBottom", "", "", "", "", "", "separatorB");

addStyleGroup("group", "menu", "demo-top");
addStyleGroup("group", "menuSub", "sub-1", "sub-2", "sub-3", "sub-4", "sub-5");
addStyleGroup("group", "menuL", "tabl");
addStyleGroup("group", "menuM", "tabm");
addStyleGroup("group", "menuR", "tabr");
addStyleGroup("group", "menuI", "tabi");
addStyleGroup("group", "sepTop", "tabt");
addStyleGroup("group", "sepBottom", "tabb");

addInstance("Demo", "Demo", "position:relative holder; menu-form:bar; style:group; align:center;");
