addStylePad("bar", "holder-css:holder; pad-css:bar;");
addStyleItem("itemTop", "css:itemTopNormal, itemTopOn, itemTopDown;");
addStyleItem("itemSub", "css:itemSubNormal, itemSubOn, itemSubDown;");
addStyleFont("font", "css:fontNormal, fontOn, fontDown;");
addStyleTag("tag", "css:tagNormal, tagOn, tagDown;");

addStyleMenu("menu", "bar", "itemTop", "font", "tag", "", "");
addStyleMenu("sub", "bar", "itemSub", "font", "tag", "", "");

addStyleGroup("group", "menu", "demo-top");
addStyleGroup("group", "sub", "tool-sub", "game-sub", "forum-sub", "menu-sub");

addInstance("Demo", "Demo", "position:relative demo; offset-left:20; offset-top:20; menu-form:bar; direction:right-up; style:group;");

// one item
addMenu("oneItem", "one-top");
addLink("one-top", "hover & mousedown me", "", "", "");

addStyleItem("oneitem", "css:oneitemNormal, oneitemOn, oneitemDown;");
addStyleFont("onefont", "css:onefontNormal, onefontOn, onefontDown;");
addStyleMenu("onemenu", "", "oneitem", "onefont", "", "", "");
addStyleGroup("onegroup", "onemenu", "one-top");

addInstance("oneItem", "oneItem", "position:relative one; offset-left:30px; style:onegroup;");

// one separator
addMenu("oneSeparator", "sep-top");
addLink("sep-top", "item one", "", "", "");
addSeparator("sep-top");
addLink("sep-top", "item two", "", "", "");

addStylePad("seppad", "pad-css:seppad;");
addStyleItem("seppaditem", "css:seppaditem;");
addStyleSeparator("sep", "css:separatorT, separatorB;");
addStyleSeparator("sep2", "css:separator;");
addStyleSeparator("sep3", "css:separatorH;");
addStyleSeparator("sep4", "css:separatorV;");

addStyleMenu("sepmenu", "seppad", "seppaditem", "", "", "", "sep");
addStyleMenu("sepmenu2", "seppad", "seppaditem", "", "", "", "sep2");
addStyleMenu("sepmenu3", "seppad", "seppaditem", "", "", "", "sep3");
addStyleMenu("sepmenu4", "seppad", "seppaditem", "", "", "", "sep4");

addStyleGroup("sepgroup", "sepmenu", "sep-top");
addStyleGroup("sepgroup2", "sepmenu2", "sep-top");
addStyleGroup("sepgroup3", "sepmenu3", "sep-top");
addStyleGroup("sepgroup4", "sepmenu4", "sep-top");

addInstance("oneSeparator", "oneSeparator", "position:relative sep; offset-left:30px; style:sepgroup;");
addInstance("oneSeparator2", "oneSeparator", "position:relative sep2; menu-form:bar; offset-left:30px; style:sepgroup2;");
addInstance("oneSeparator3", "oneSeparator", "position:relative sep3; offset-left:30px; style:sepgroup3;");
addInstance("oneSeparator4", "oneSeparator", "position:relative sep4; menu-form:bar; offset-left:30px; style:sepgroup4;");
