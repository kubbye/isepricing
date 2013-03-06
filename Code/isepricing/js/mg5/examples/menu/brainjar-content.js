// menu
addMenu("brainjar", "top");

// top-bar
addSubMenu("top", "Home", "", "", "sub-Home", "");
addSubMenu("top", "CSS", "", "", "sub-CSS", "");
addSubMenu("top", "JavaScript", "", "", "sub-JS", "");
addSubMenu("top", "DHTML", "", "", "sub-DHTML", "");
addSubMenu("top", "ASP", "", "", "sub-ASP", "");
addSubMenu("top", "Java", "", "", "sub-Java", "");

// sub Home
addLink("sub-Home", "Main Page", "", "", "");
addSeparator("sub-Home", "");
addLink("sub-Home", "Contact BrainJar.com", "", "", "");
addLink("sub-Home", "Terms of Use", "", "", "");
addLink("sub-Home", "Search this Site", "", "", "");
addSeparator("sub-Home", "");
addSubMenu("sub-Home", "Customize", "", "", "sub-Custom", "");

// sub Custom
addLink("sub-Custom", "Style Schemes", "", "", "info");
addCommand("sub-Custom", "Default", "", "", "");
addCommand("sub-Custom", "Groovy", "", "", "");
addCommand("sub-Custom", "Halloween", "", "", "");
addCommand("sub-Custom", "Patriotic", "", "", "");
addCommand("sub-Custom", "Undersea", "", "", "");
addSeparator("sub-Custom", "");
addLink("sub-Custom", "How-To", "", "", "");

// sub CSS
addLink("sub-CSS", "Tutorials", "", "", "info");
addLink("sub-CSS", "Using Style Sheets", "", "", "");
addLink("sub-CSS", "CSS Positioning", "", "", "");
addSeparator("sub-CSS", "");
addLink("sub-CSS", "Samples", "", "", "info");
addLink("sub-CSS", "Playing Cards with CSS", "", "", "");
addLink("sub-CSS", "Tabs", "", "", "");
addSeparator("sub-CSS", "");
addLink("sub-CSS", "Resources", "", "", "");

// sub JS
addLink("sub-JS", "Tutorials", "", "", "info");
addLink("sub-JS", "JavaScript Card Objects", "", "", "");
addSeparator("sub-JS", "");
addLink("sub-JS", "Utilities", "", "", "info");
addLink("sub-JS", "JavaScript Crunchinator", "", "", "");
addSeparator("sub-JS", "");
addLink("sub-JS", "Samples", "", "", "info");
addLink("sub-JS", "Blackjack", "", "", "");
addLink("sub-JS", "Calendar", "", "", "");
addLink("sub-JS", "Validation Algorithms", "", "", "");
addSeparator("sub-JS", "");
addLink("sub-JS", "Resources", "", "", "");

// sub DHTML
addLink("sub-DHTML", "Tutorials", "", "", "info");
addLink("sub-DHTML", "Introduction to the DOM", "", "", "");
addLink("sub-DHTML", "The DOM Event Model", "", "", "");
addSeparator("sub-DHTML", "");
addLink("sub-DHTML", "Utilities", "", "", "info");
addLink("sub-DHTML", "DOM Viewer", "", "", "");
addSeparator("sub-DHTML", "");
addLink("sub-DHTML", "Samples", "", "", "info");
addLink("sub-DHTML", "Bride of Windows", "", "", "");
addLink("sub-DHTML", "Generic Drag", "", "", "");
addLink("sub-DHTML", "Revenge of the Menu Bar", "", "", "");
addLink("sub-DHTML", "Table Sort", "", "", "");
addSeparator("sub-DHTML", "");
addLink("sub-DHTML", "Resources", "", "", "");

// sub ASP
addLink("sub-ASP", "Tutorials", "", "", "info");
addLink("sub-ASP", "File Operations", "", "", "");
addLink("sub-ASP", "Directory Listing", "", "", "");
addSeparator("sub-ASP", "");
addLink("sub-ASP", "Samples", "", "", "info");
addLink("sub-ASP", "ASP From Mail", "", "", "");
addLink("sub-ASP", "Football Pool", "", "", "");
addSeparator("sub-ASP", "");
addLink("sub-ASP", "Resources", "", "", "");

// sub Java
addLink("sub-Java", "Tutorials", "", "", "info");
addLink("sub-Java", "Animation Basics", "", "", "");
addLink("sub-Java", "Applet Parameters", "", "", "");
addLink("sub-Java", "Host Communication", "", "", "");
addLink("sub-Java", "Sound and Image Loading", "", "", "");
addSeparator("sub-Java", "");
addLink("sub-Java", "Samples", "", "", "info");
addSubMenu("sub-Java", "Java Game Applets", "", "", "sub-Applet", "");
addSeparator("sub-Java", "");
addLink("sub-Java", "Resources", "", "", "");

// sub Applet
addLink("sub-Applet", "Asteroids", "", "", "");
addLink("sub-Applet", "Snake Pit", "", "", "");
addLink("sub-Applet", "Tail Gunner", "", "", "");
addLink("sub-Applet", "Word Search", "", "", "");

// done
endMenu();
