addStylePad("pad", "offset-top:-5; offset-left:1;");
addStyleItem("item", "css:itemOff1, itemOn1;");
addStyleFont("font", "css:fontOff1, fontOn1;");
addStyleTag("tag", "css:tagOff1, tagOn1;");
addStyleSeparator("separator1", "css:separator1;");
addStyleSeparator("separator2", "css:separator2;");
addStyleSeparator("separator3", "css:separator3;");

addStyleMenu("menu", "pad", "item", "font", "tag", "", "");
addStyleMenu("sepTop", "", "", "", "", "", "separator1");
addStyleMenu("sepBottom", "", "", "", "", "", "separator2");
addStyleMenu("sepTop2", "", "", "", "", "", "separator3");

addStyleGroup("group", "menu", "demo-top");
addStyleGroup("group", "sepTop", "barTop");
addStyleGroup("group", "sepBottom", "barBottom");
addStyleGroup("group", "sepTop2", "subBarTop");

addInstance("Demo1", "Demo", "position:relative holder1; style:group; offset-top:3; align:center;");


addStylePad("pad2", "pad-css:pad2; offset-top:-12; offset-left:16;");
addStyleItem("item2", "css:itemOff2, itemOn2;");
addStyleFont("font2", "css:fontOff2, fontOn2;");
addStyleTag("tag2", "css:tagOff2, tagOn2;");
addStyleSeparator("separator", "css:separator");

addStyleMenu("menu2", "pad2", "item2", "font2", "tag2", "", "separator");
addStyleGroup("group2", "menu2", "demo-top");

addInstance("Demo2", "Demo", "position:relative holder2; style:group2; offset-top:3; align:center;");


addStylePad("pad3", "offset-top:-4; item-offset:-1;");
addStylePad("subpad3", "pad-css:subpad3; offset-top:-4; offset-left:-4; item-offset:-1; flip:no;");
addStyleItem("item3", "css:itemOff3, itemOn3;");
addStyleFont("font3", "css:fontOff3, fontOn3;");
addStyleSeparator("separatorT", "css:separatorT");
addStyleSeparator("separatorB", "css:separatorB");

addStyleMenu("menu3", "pad3", "item3", "font3", "tag3", "", "");
addStyleMenu("submenu3", "subpad3", "item3", "font3", "tag3", "", "");
addStyleMenu("sepT", "", "", "", "", "", "separatorT");
addStyleMenu("sepB", "", "", "", "", "", "separatorB");

addStyleGroup("group3", "menu3", "demo-top");
addStyleGroup("group3", "submenu3", "tool-sub", "game-sub", "forum-sub", "menu-sub");
addStyleGroup("group3", "sepT", "barTop", "subBarTop");
addStyleGroup("group3", "sepB", "barBottom");

addInstance("Demo3", "Demo", "position:relative holder3; style:group3; offset-top:3; align:center;");


addStylePad("pad4", "pad-css:pad4; offset-top:-2; offset-left:-4; item-offset:1;");
addStyleItem("item4", "css:itemOff4, itemOn4;");
addStyleFont("font4", "css:fontOff4, fontOn4;");
addStyleIcon("icon4", "css:iconOff4, iconOn4;");
addStyleSeparator("separator4", "css:separator4");

addStyleMenu("menu4", "pad4", "item4", "font4", "", "icon4", "separator4");
addStyleGroup("group4", "menu4", "demo-top");

addInstance("Demo4", "Demo", "position:relative holder4; style:group4; offset-top:3; align:center;");
