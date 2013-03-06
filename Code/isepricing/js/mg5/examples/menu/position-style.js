addStylePad("pad", "holder-css:holder; pad-css:pad;");
addStyleItem("item", "css:itemOff, itemOn;");
addStyleFont("font", "css:fontOff, fontOn;");
addStyleTag("tag", "css:tagOff, tagOn;");
setDefaultStyle("pad", "item", "font", "tag", "", "");

addInstance("Demo1", "Demo", "position:absolute; offset-top:10; offset-left:10; visibility:hidden;");
addInstance("Demo2", "Demo", "position:relative holder; visibility:hidden;");
addInstance("Demo4", "Demo", "position:slot 6; align:left; valign:bottom; direction:right-up; floating:yes; visibility:hidden;");
addInstance("Demo5", "Demo", "position:relative holder3; align:center; menu-form:bar;");
