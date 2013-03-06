addStylePad("pad", "item-offset:-1; offset-top:6; offset-left:-6;");
addStylePad("scroll-pad", "pad-css:pad; item-offset:-1; offset-top:6; offset-left:-6; scroll:y-only;");
addStylePad("multi-pad", "pad-css:pad; item-offset:-1; offset-top:6; offset-left:-6; scroll:y-only; col:4;");
addStyleItem("item", "css:itemOff, itemOn;");
addStyleFont("font", "css:fontOff, fontOn;");
addStyleTag("tag", "css:tagOff, tagOn;");

addStyleMenu("scroll", "scroll-pad", "item", "font", "tag", "", "");
addStyleMenu("multi", "multi-pad", "item", "font", "tag", "", "");

addStyleGroup("style", "scroll", "scroll-sub");
addStyleGroup("style", "multi", "multi-sub");

setDefaultStyle("pad", "item", "font", "tag", "", "");

addInstance("Demo", "Demo", "position:relative holder; offset-top:20; offset-left:5; style:style;");
