addStylePad("pad", "offset-top:-12");
addStyleItem("item", "css:itemOff, itemOn; width:actual;");
addStyleFont("font", "css:fontOff, fontOn;");
addStyleIcon("icon", "css:licon; text:|:; css2:ricon; text2:|&nbsp;:;");
addStyleIcon("subicon", "css:liconsub; text:[:; css2:riconsub; text2:]&gt;:;");

addStyleIcon("xicon", "css:liconx; text:+:; css2:riconx; text2:+&nbsp;:;");
addStyleItem("xitem", "css:itemOff; width:actual;");
addStyleFont("xfont", "css:fontOff;");

addStyleMenu("xitem", "", "xitem", "xfont", "", "xicon", "");
addStyleMenu("sub", "", "item", "font", "", "subicon", "");
addStyleGroup("group", "sub", "sub");
addStyleGroup("group", "xitem", "x");

setDefaultStyle("pad", "item", "font", "", "icon", "");

addInstance("Demo", "Demo", "position:relative holder; style:group;");
