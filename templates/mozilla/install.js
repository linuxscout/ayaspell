var err = initInstall("Arabic spellchecking dictionary\nBased on Tim Buckwalter's GPLed data", "ar@dictionaries.addons.mozilla.org", "1.2b1");
if (err != SUCCESS)
    cancelInstall();

var fProgram = getFolder("Program");
err = addDirectory("", "ar@dictionaries.addons.mozilla.org",
		   "dictionaries", fProgram, "dictionaries", true);
if (err != SUCCESS)
    cancelInstall();

performInstall();
