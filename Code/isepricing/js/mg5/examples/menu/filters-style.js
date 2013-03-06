addStylePad("bar", "holder-css:holder; pad-css:bar;");

addStylePad("sub1", "holder-css:subholder1; pad-css:bar;");
addStylePad("sub2", "holder-css:subholder2; pad-css:bar; filters:yes,yes;");
addStylePad("sub3", "holder-css:subholder3; pad-css:bar;");
addStylePad("subx", "holder-css:subholderx; pad-css:bar; offset-top:10; offset-left:-2;");

addStyleItem("itemTopL1", "css:itemNormal itemTopL1, itemOn itemTopL1, itemDown itemTopL1; filters:yes,no;");
addStyleItem("itemTopS1", "css:itemNormal itemTopS1, itemOn itemTopS1, itemDown itemTopS1; filters:yes;");
addStyleItem("itemTopS2", "css:itemNormal itemTopS2, itemOn itemTopS2, itemDown itemTopS2; filters:yes;");
addStyleItem("itemTopS3", "css:itemNormal itemTopS3, itemOn itemTopS3, itemDown itemTopS3; filters:yes;");
addStyleItem("itemTopL2", "css:itemNormal itemTopL2, itemOn itemTopL2, itemDown itemTopL2; filters:no no yes;");

addStyleItem("itemSub", "css:itemNormal itemSub, itemOn itemSub, itemDown itemSub;");
addStyleFont("font", "css:fontNormal, fontOn, fontDown;");
addStyleTag("tag", "css:tagNormal, tagOn, tagDown;");

addStyleMenu("menu", "bar", "", "font", "tag", "", "");
addStyleMenu("L1", "", "itemTopL1", "font", "tag", "", "");
addStyleMenu("S1", "", "itemTopS1", "font", "tag", "", "");
addStyleMenu("S2", "", "itemTopS2", "font", "tag", "", "");
addStyleMenu("S3", "", "itemTopS3", "font", "tag", "", "");
addStyleMenu("L2", "", "itemTopL2", "font", "tag", "", "");

addStyleMenu("sub1", "sub1", "itemSub", "font", "tag", "", "");
addStyleMenu("sub2", "sub2", "itemSub", "font", "tag", "", "");
addStyleMenu("sub3", "sub3", "itemSub", "font", "tag", "", "");
addStyleMenu("subx", "subx", "itemSub", "font", "tag", "", "");

addStyleGroup("group", "menu", "demo-top");

addStyleGroup("group", "L1", "l1");
addStyleGroup("group", "S1", "s1");
addStyleGroup("group", "S2", "s2");
addStyleGroup("group", "S3", "s3");
addStyleGroup("group", "L2", "l2");

addStyleGroup("group", "sub1", "tool-sub");
addStyleGroup("group", "sub2", "game-sub");
addStyleGroup("group", "sub3", "forum-sub");
addStyleGroup("group", "subx", "menu-sub");

addInstance("Demo", "Demo", "position:relative holder; offset-left:20; offset-top:20; align:center; valign:bottom; menu-form:bar; style:group;");
