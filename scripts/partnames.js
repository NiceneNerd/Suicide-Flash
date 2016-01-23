var swtch = arguments[0];
var offset1;
arguments.splice(0, 1);
if (swtch == "ptf") {
	offset1 = arguments.splice(0,1);
	var sz = arguments.splice(0,1);
	printPartitionFile(arguments.toString(), sz);
} else if (swtch == "ptl") { 
	printPartitionList(arguments.toString()); 
} else { 
	print("Usage: [ptf|ptl] files"); quit;
}

function printPartitionList(ls) {
	print("\"" + ls.toString().split(",").join("\",\"").split(".mbn").join("") + "\"");
}

function printPartitionFile(ls, size) {
	var lss = ls.split(",").filter(Boolean);
	lss.sort();

	var list = [];
	var li;
	for (li in lss) {
            var pInt = lss[li].replace("system","").replace(".mbn","");
	    var newInt = parseInt(pInt, 10);
	    list.push(newInt);
	}
	var li2;
	for (li2 in list) {
	    var sout;
	    var offset = parseInt(offset1,16) + ((list[li2] - 1) * (size));
	    sout = "0x" + zeroPad(offset.toString(16),12) + ": ";
	    sout += "system" + zeroPad(list[li2], 6) + "  : " + size;
	    print(sout);
	}
}

function zeroPad(num, places) {
  var zero = places - num.toString().length + 1;
  return Array(+(zero > 0 && zero)).join("0") + num;
}

function readline()
{
    var ist = new java.io.InputStreamReader(java.lang.System.in); 
    var bre = new java.io.BufferedReader(ist); 
    var line = bre.readLine();
    return line;
}
