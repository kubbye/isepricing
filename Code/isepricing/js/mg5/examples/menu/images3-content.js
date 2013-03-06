addMenu("Demo", "top-menu");

addSeparator("top-menu", "top-top");
addSubMenu("top-menu", "sub-1", "", "", "sub-1", "top-sub");
addSubMenu("top-menu", "sub-2", "", "", "sub-2", "top-sub");
addLink("top-menu", "link", "", "", "top-item");
addSubMenu("top-menu", "sub-3", "", "", "sub-3", "top-sub");
addLink("top-menu", "link", "", "", "top-item");
addLink("top-menu", "link", "", "", "top-item");
addSeparator("top-menu", "top-bottom");

addSeparator("sub-1", "sub-top");
addLink("sub-1", "link", "", "", "sub-connect");
addLink("sub-1", "link", "", "", "sub-item");
addLink("sub-1", "link", "", "", "sub-item");
addLink("sub-1", "link", "", "", "sub-item");
addSeparator("sub-1", "sub-bottom");

addSeparator("sub-2", "sub-top");
addLink("sub-2", "link", "", "", "sub-connect");
addLink("sub-2", "link", "", "", "sub-item");
addLink("sub-2", "link", "", "", "sub-item");
addLink("sub-2", "link", "", "", "sub-item");
addLink("sub-2", "link", "", "", "sub-item");
addLink("sub-2", "link", "", "", "sub-item");
addSeparator("sub-2", "sub-bottom");

addSeparator("sub-3", "sub-top");
addSubMenu("sub-3", "sub-3-1", "", "", "sub-31", "sub+connect");
addLink("sub-3", "link", "", "", "sub-item");
addLink("sub-3", "link", "", "", "sub-item");
addSubMenu("sub-3", "sub-3-4", "", "", "sub-34", "sub-sub");
addLink("sub-3", "link", "", "", "sub-item");
addSeparator("sub-3", "sub-bottom");

addSeparator("sub-31", "sub-top");
addLink("sub-31", "link", "", "", "sub-connect");
addLink("sub-31", "link", "", "", "sub-item");
addLink("sub-31", "link", "", "", "sub-item");
addLink("sub-31", "link", "", "", "sub-item");
addSeparator("sub-31", "sub-bottom");

addSeparator("sub-34", "sub-top");
addLink("sub-34", "link", "", "", "sub-connect");
addLink("sub-34", "link", "", "", "sub-item");
addLink("sub-34", "link", "", "", "sub-item");
addLink("sub-34", "link", "", "", "sub-item");
addSeparator("sub-34", "sub-bottom");

endMenu();

addStylePad("pad", "visibility:hidden;");
addStyleItem("item", "width:120; height:18; padding:2 6");

addStylePad("subpad", "visibility:hidden; offset-left:-2; offset-top:-20");
addStyleItem("subitem", "width:136; height:18; padding:2 14");

addStylePad("subpad2", "visibility:hidden; offset-left:-10; offset-top:-20");

addStyleFont("font", "font-family:verdana; font-size:12; font-weight:bold; color:#ffffff #7e93aa; text-align:center");
addStyleTag("tag", "path:./images/; tag-normal:tag.gif; width:9; height:14;");

addStyleItem("edge-top", "width:120; height:20");
addStyleItem("edge-sub", "width:136; height:20");
