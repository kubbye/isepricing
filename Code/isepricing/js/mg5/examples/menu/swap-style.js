addStylePad("pad", "item-offset:-1; offset-top:1;");
addStylePad("padSub", "item-offset:-1; offset-top:6; offset-left:-6;");

addStyleItem("itemTop", "css:itemTopOff, itemTopOn;");
addStyleItem("itemSub", "css:itemSubOff, itemSubOn;");
addStyleItem("itemTitle", "css:itemTitle;");

addStyleFont("fontTop", "css:fontOff, fontOn;");
addStyleFont("fontSub", "css:fontOff, fontOn;");
addStyleFont("fontTitle", "css:fontTitle");

addStyleTag("tagStyle", "css:tagDownOff, tagDownOn;");
addStyleTag("tagTitle", "css:tagDownOn;");

addStyleMenu("menu", "pad", "itemTop", "fontTop", "tagStyle", "", "");
addStyleMenu("sub", "pad", "itemSub", "fontSub", "", "", "");
addStyleMenu("title", "", "itemTitle", "fontTitle", "tagTitle", "", "");

addStyleGroup("group", "menu", "Toyota-top", "Honda-top", "Chrysler-top", "Dodge-top", "Ford-top");
addStyleGroup("group", "sub", "Toyota-other", "Toyota-Cars", "Toyota-SUVs/Van", "Toyota-Trucks", "Honda-other", "Honda-Cars", "Honda-SUVs/Van", "Chrysler-other", "Chrysler-Cars", "Chrysler-SUVs/Van", "Dodge-other", "Dodge-Cars", "Dodge-SUVs/Van", "Dodge-Trucks", "Ford-other", "Ford-Cars", "Ford-SUVs/Van", "Ford-Trucks");
addStyleGroup("group", "title", "maker");

 
 
addInstance("Toyota", "Toyota", "position:slot 5; menu-form:bar; align:center; valign:bottom; style:group; target:main; visibility:hidden;");
addInstance("Honda", "Honda", "position:slot 5; menu-form:bar; align:center; valign:bottom; style:group; target:main; visibility:hidden;");
addInstance("Chrysler", "Chrysler", "position:slot 5; menu-form:bar; align:center; valign:bottom; style:group; target:main; visibility:hidden;");
addInstance("Dodge", "Dodge", "position:slot 5; menu-form:bar; align:center; valign:bottom; style:group; target:main; visibility:hidden;");
addInstance("Ford", "Ford", "position:slot 5; menu-form:bar; align:center; valign:bottom; style:group; target:main; visibility:hidden;");
