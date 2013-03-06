addStylePad("pad", "pad-css:pad; item-offset:1; tiles:27,20:t1top,t2,t3,t4,t5,t6,t7,t8,t9;");
addStylePad("subpad", "pad-css:pad; offset-left:5; offset-top:19; item-offset:1; tiles:27,20:t1sub,t2,t3,t4,t5,t6,t7,t8,t9;");
addStyleItem("item", "css:itemOff, itemOn; width:actual;");
addStyleFont("font", "css:fontOff, fontOn;");
addStyleTag("tag", "css:tagOff, tagOn;");
addStyleIcon("icon", "css:iconlOff, iconlOn; css2:iconrOff, iconrOn;");
addStyleIcon("tagicon", "css:icontOff, icontOn;");

addStyleMenu("top", "pad", "item", "font", "", "icon", "");
addStyleMenu("subitem", "", "item", "font", "tag", "tagicon", "");

addStyleGroup("group", "top", "demo-top");
addStyleGroup("group", "subitem", "sub");

setDefaultStyle("subpad", "item", "font", "", "icon", "");

addInstance("Demo", "Demo", "position:relative holder; style:group;");
