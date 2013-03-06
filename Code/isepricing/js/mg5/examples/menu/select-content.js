var defaultInput = new Array("Celica", "2005"); // form field value when reset
var currentInput = new Array("Celica", "2005"); // to store current selection
var formField = new Array("vehicle", "year"); // corresponding form field names
var groupIds = new Array("vehicle", "year"); // group id for the sub-menu item as the top select list option
var selects = new Array("vehicle", "year"); // names of menu instances acting as alternative to the select list


// vehicle select list
addMenu("vehicle", "vehicles");

addSubMenu("vehicles", defaultInput[0], "", "javascript:resetItem(0)", "car-makers", "vehicle");

addSubMenu("car-makers", "Toyota", "", "", "Toyota", "");
addSubMenu("car-makers", "Honda", "", "", "Honda", "");
addSubMenu("car-makers", "Chrysler", "", "", "Chrysler", "");
addSubMenu("car-makers", "Dodge", "", "", "Dodge", "");
addSubMenu("car-makers", "Ford", "", "", "Ford", "");

addSubMenu("Toyota", "Cars", "", "", "Toyota-Cars", "");
addSubMenu("Toyota", "SUVs/Van", "", "", "Toyota-SUVs/Van", "");
addSubMenu("Toyota", "Trucks", "", "", "Toyota-Trucks", "");

addCommand("Toyota-Cars", "Avalon", "", "pickItem(0,'Avalon')", "");
addCommand("Toyota-Cars", "Camry", "", "pickItem(0,'Camry')", "");
addCommand("Toyota-Cars", "Celica", "", "pickItem(0,'Celica')", "");
addCommand("Toyota-Cars", "Corolla", "", "pickItem(0,'Corolla')", "");
addCommand("Toyota-Cars", "ECHO", "", "pickItem(0,'ECHO')", "");
addCommand("Toyota-Cars", "Matrix", "", "pickItem(0,'Matrix')", "");
addCommand("Toyota-Cars", "MR2 Spyder", "", "pickItem(0,'MR2 Spyder')", "");
addCommand("Toyota-Cars", "Prius", "", "pickItem(0,'Prius')", "");

addCommand("Toyota-SUVs/Van", "4Runner", "", "pickItem(0,'4Runner')", "");
addCommand("Toyota-SUVs/Van", "Highlander", "", "pickItem(0,'Highlander')", "");
addCommand("Toyota-SUVs/Van", "Land Cruiser", "", "pickItem(0,'Land Cruiser')", "");
addCommand("Toyota-SUVs/Van", "RAV4", "", "pickItem(0,'RAV4')", "");
addCommand("Toyota-SUVs/Van", "Sequoia", "", "pickItem(0,'Sequoia')", "");
addCommand("Toyota-SUVs/Van", "Sienna", "", "pickItem(0,'Sienna')", "");

addCommand("Toyota-Trucks", "Tacoma", "", "pickItem(0,'Tacoma')", "");
addCommand("Toyota-Trucks", "Tundra", "", "pickItem(0,'Tundra')", "");

addSubMenu("Honda", "Cars", "", "", "Honda-Cars", "");
addSubMenu("Honda", "SUVs/Van", "", "", "Honda-SUVs/Van", "");

addCommand("Honda-Cars", "Accord Sedan", "", "pickItem(0,'Accord Sedan')", "");
addCommand("Honda-Cars", "Accord Coupe", "", "pickItem(0,'Accord Coupe')", "");
addCommand("Honda-Cars", "Civic Sedan", "", "pickItem(0,'Civic Sedan')", "");
addCommand("Honda-Cars", "Civic Coupe", "", "pickItem(0,'Civic Coupe')", "");
addCommand("Honda-Cars", "Civic Hybrid", "", "pickItem(0,'Civic Hybrid')", "");
addCommand("Honda-Cars", "Civic Si", "", "pickItem(0,'Civic Si')", "");
addCommand("Honda-Cars", "Civic GX", "", "pickItem(0,'Civic GX')", "");
addCommand("Honda-Cars", "Insight", "", "pickItem(0,'Insight')", "");
addCommand("Honda-Cars", "S2000", "", "pickItem(0,'S2000')", "");

addCommand("Honda-SUVs/Van", "CR-V", "", "pickItem(0,'CR-V')", "");
addCommand("Honda-SUVs/Van", "Pilot", "", "pickItem(0,'Pilot')", "");
addCommand("Honda-SUVs/Van", "Odyssey", "", "pickItem(0,'Odyssey')", "");

addSubMenu("Chrysler", "Cars", "", "", "Chrysler-Cars", "");
addSubMenu("Chrysler", "SUVs/Van", "", "", "Chrysler-SUVs/Van", "");

addCommand("Chrysler-Cars", "300M", "", "pickItem(0,'300M')", "");
addCommand("Chrysler-Cars", "PT Cruiser", "", "pickItem(0,'PT Cruiser')", "");
addCommand("Chrysler-Cars", "Concorde", "", "pickItem(0,'Concorde')", "");
addCommand("Chrysler-Cars", "Sebring Coupe", "", "pickItem(0,'Sebring Coupe')", "");
addCommand("Chrysler-Cars", "Sebring Sedan", "", "pickItem(0,'Sebring Sedan')", "");
addCommand("Chrysler-Cars", "Sebring Convertible", "", "pickItem(0,'Sebring Convertible')", "");

addCommand("Chrysler-SUVs/Van", "Town & Country", "", "pickItem(0,'Town & Country')", "");
addCommand("Chrysler-SUVs/Van", "Voyager", "", "pickItem(0,'Voyager')", "");

addSubMenu("Dodge", "Cars", "", "", "Dodge-Cars", "");
addSubMenu("Dodge", "SUVs/Van", "", "", "Dodge-SUVs/Van", "");
addSubMenu("Dodge", "Trucks", "", "", "Dodge-Trucks", "");

addCommand("Dodge-Cars", "Intrepid", "", "pickItem(0,'Intrepid')", "");
addCommand("Dodge-Cars", "Neon", "", "pickItem(0,'Neon')", "");
addCommand("Dodge-Cars", "SRT-4", "", "pickItem(0,'SRT-4')", "");
addCommand("Dodge-Cars", "Stratus Coupe", "", "pickItem(0,'Stratus Coupe')", "");
addCommand("Dodge-Cars", "Stratus Sedan", "", "pickItem(0,'Stratus Sedan')", "");
addCommand("Dodge-Cars", "Viper", "", "pickItem(0,'Viper')", "");

addCommand("Dodge-SUVs/Van", "Caravan", "", "pickItem(0,'Caravan')", "");
addCommand("Dodge-SUVs/Van", "Durango", "", "pickItem(0,'Durango')", "");
addCommand("Dodge-SUVs/Van", "Ram Van", "", "pickItem(0,'Ram Van')", "");

addCommand("Dodge-Trucks", "Dakota", "", "pickItem(0,'Dakota')", "");
addCommand("Dodge-Trucks", "Ram Pickup", "", "pickItem(0,'Ram Pickup')", "");

addSubMenu("Ford", "Cars", "", "", "Ford-Cars", "");
addSubMenu("Ford", "SUVs/Van", "", "", "Ford-SUVs/Van", "");
addSubMenu("Ford", "Trucks", "", "", "Ford-Trucks", "");

addCommand("Ford-Cars", "ZX2", "", "pickItem(0,'ZX2')", "");
addCommand("Ford-Cars", "Focus", "", "pickItem(0,'Focus')", "");
addCommand("Ford-Cars", "Taurus", "", "pickItem(0,'Taurus')", "");
addCommand("Ford-Cars", "Crown Victoria", "", "pickItem(0,'Crown Victoria')", "");
addCommand("Ford-Cars", "Mustang", "", "pickItem(0,'Mustang')", "");
addCommand("Ford-Cars", "Thunderbird", "", "pickItem(0,'Thunderbird')", "");

addCommand("Ford-SUVs/Van", "Escape", "", "pickItem(0,'Escape')", "");
addCommand("Ford-SUVs/Van", "Explorer", "", "pickItem(0,'Explorer')", "");
addCommand("Ford-SUVs/Van", "Expedition", "", "pickItem(0,'Expedition')", "");
addCommand("Ford-SUVs/Van", "Excursion", "", "pickItem(0,'Excursion')", "");
addCommand("Ford-SUVs/Van", "Windstar", "", "pickItem(0,'Windstar')", "");
addCommand("Ford-SUVs/Van", "Econoline", "", "pickItem(0,'Econoline')", "");

addCommand("Ford-Trucks", "Ranger", "", "pickItem(0,'Ranger')", "");
addCommand("Ford-Trucks", "F-150", "", "pickItem(0,'F-150')", "");
addCommand("Ford-Trucks", "F-250", "", "pickItem(0,'F-250')", "");
addCommand("Ford-Trucks", "F-350", "", "pickItem(0,'F-350')", "");

// year select list
addMenu("year", "years");

addSubMenu("years", defaultInput[1], "", "javascript:resetItem(1)", "vehicle-year", "year");

addSubMenu("vehicle-year", "200x", "", "", "year-200x", "");
addSubMenu("vehicle-year", "199x", "", "", "year-199x", "");
addSubMenu("vehicle-year", "198x", "", "", "year-198x", "");

addCommand("year-200x", "2005", "", "pickItem(1,'2005')", "");
addCommand("year-200x", "2004", "", "pickItem(1,'2004')", "");
addCommand("year-200x", "2003", "", "pickItem(1,'2003')", "");
addCommand("year-200x", "2002", "", "pickItem(1,'2002')", "");
addCommand("year-200x", "2001", "", "pickItem(1,'2001')", "");
addCommand("year-200x", "2000", "", "pickItem(1,'2000')", "");

addCommand("year-199x", "1999", "", "pickItem(1,'1999')", "");
addCommand("year-199x", "1998", "", "pickItem(1,'1998')", "");
addCommand("year-199x", "1997", "", "pickItem(1,'1997')", "");
addCommand("year-199x", "1996", "", "pickItem(1,'1996')", "");
addCommand("year-199x", "1995", "", "pickItem(1,'1995')", "");
addCommand("year-199x", "1994", "", "pickItem(1,'1994')", "");
addCommand("year-199x", "1993", "", "pickItem(1,'1993')", "");
addCommand("year-199x", "1992", "", "pickItem(1,'1992')", "");
addCommand("year-199x", "1991", "", "pickItem(1,'1991')", "");
addCommand("year-199x", "1990", "", "pickItem(1,'1990')", "");

addCommand("year-198x", "1989", "", "pickItem(1,'1989')", "");
addCommand("year-198x", "1988", "", "pickItem(1,'1988')", "");
addCommand("year-198x", "1987", "", "pickItem(1,'1987')", "");
addCommand("year-198x", "1986", "", "pickItem(1,'1986')", "");
addCommand("year-198x", "1985", "", "pickItem(1,'1985')", "");
addCommand("year-198x", "1984", "", "pickItem(1,'1984')", "");
addCommand("year-198x", "1983", "", "pickItem(1,'1983')", "");
addCommand("year-198x", "1982", "", "pickItem(1,'1982')", "");
addCommand("year-198x", "1981", "", "pickItem(1,'1981')", "");
addCommand("year-198x", "1980", "", "pickItem(1,'1980')", "");

// the styles
addStylePad("padStyleFirstSub", "offset-left:0; offset-top:1");
addStylePad("padStyleOtherSub", "offset-left:1; offset-top:0");
addStyleItem("itemStyle", "css:itemOff, itemOn,,,itemPicked; sub-menu:mouse-over");
addStyleFont("fontStyle", "css:font,,,,fontPicked");
addStyleTag("tagStyleTop", "css:tagTop,,,,tagPicked");
addStyleTag("tagStyleSub", "css:tagSub");

// default style for sub-menus
setDefaultStyle("padStyleSub", "itemStyle", "fontStyle", "tagStyleSub", "");

// top item, top-menu, first level sub-menu and lower level sub-menus have different styles
addStyleMenu("menuStyle", "", "itemStyle", "fontStyle", "tagStyleTop", "", "");
addStyleMenu("menuStyleFirstSub", "padStyleFirstSub", "itemStyle", "fontStyle", "tagStyleSub", "", "");
addStyleMenu("menuStyleOtherSub", "padStyleOtherSub", "itemStyle", "fontStyle", "tagStyleSub", "", "");

addStyleGroup("style", "menuStyle", "vehicles", "years");
addStyleGroup("style", "menuStyleFirstSub", "car-makers", "vehicle-year");
addStyleGroup("style", "menuStyleOtherSub", "Toyota", "Honda", "Chrysler", "Dodge", "Ford", "year-200x", "year-199x", "year-198x");

// the menus
addInstance("vehicle", "vehicle", "position:relative vehicleholder; align:left; valign:top; offset-top:3; menu-form:bar; direction:right-down; visibility:visible; style:style");
addInstance("year", "year", "position:relative yearholder; align:left; valign:top; offset-top:3; menu-form:bar; direction:right-down; visibility:visible; style:style");


// pick an item from the select list
function pickItem(idx, name) {
  if (currentInput[idx] == name) { return ; }

  // update the select list
  updateItemDisplay(selects[idx], groupIds[idx], name);
  showPagePath(selects[idx], groupIds[idx]);
  hideMenu(selects[idx]);

  // set the current input
  currentInput[idx] = name;

  // update form field
  if (name == defaultInput[idx]) {
    document.forms[0][formField[idx]].value = defaultInput[idx];
  }
  else {
    document.forms[0][formField[idx]].value = name;
  }
}

// reset the top item
function resetItem(idx) {
  pickItem(idx, defaultInput[idx]);
  resetPagePath(selects[idx]);
}
