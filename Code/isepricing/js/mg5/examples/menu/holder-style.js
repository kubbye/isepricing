addStylePad("pad", "item-offset:-1; offset-top:6; offset-left:-6;");
addStyleItem("item", "css:itemOff, itemOn;");
addStyleFont("font", "css:fontOff, fontOn;");
addStyleTag("tag", "css:tagOff, tagOn;");

setDefaultStyle("pad", "item", "font", "tag", "", "");

addInstance("Demo", "vehicle", "visibility:hidden;");

// form field handling codes
var currentField=-1;
var formFields=["vehicle1", "vehicle2", "vehicle3"];
var formNames=["testform", "testform", "testform"];
var menuHolders=["holder1", "holder2", "holder3"];

function pickItem(car) {
  if (currentField!=-1) {
    document.forms[formNames[currentField]][formFields[currentField]].value=car;
  }
}

function popupMenu(idx) {
  currentField=idx;
  setHolder("Demo", menuHolders[idx]);
  closeMenuNow();
  clickMenu("Demo");
}