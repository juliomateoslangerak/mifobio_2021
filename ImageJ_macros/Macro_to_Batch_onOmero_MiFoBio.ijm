/* Test macro for analysis on a datset Omero
 *  Input : 2D TIF image
 *  Thresholding and analyze particles with ROIs and results
 *  Output : Results tab and ROIs
 *  F. Brau for Fiji/ImageJ 1.53f November 2021
*/

function Summary_to_Result() { 
	close("Results");
	selectWindow("Summary");
	IJ.renameResults("Summary","Results");
}

//Initialisation
run("Colors...", "foreground=white background=black selection=red");
run("Options...", "iterations=1 count=1 black edm=16-bit");
run("Set Measurements...", "area perimeter shape feret's limit redirect=None decimal=2");
run("Clear Results");
print("\\Clear");
chemin=getDirectory("macros");
image=getTitle();

/* The dialog box is executed only if the macro is called for the first time by the groovy script.
 In this case values are stored in a temporary file "Parameters_Macro_toBatch.txt" (which is previously deleted)
 in the Fiji\macros directory. The values are read in the file during the following executions.
 */
execution=getArgument();
//execution=0;
if (execution=='0'){
	Dialog.create("Test Macro for Batch Macro on Omero");
	Dialog.addNumber("Minimal size (microns):", 10);
	Dialog.addNumber("Maximal size (microns):", 1000);
	Dialog.show();
	min_size=Dialog.getNumber();
	max_size=Dialog.getNumber();
	File.delete(chemin+"Parameters_Macro_toBatch.txt");
	file_temp = File.open(chemin+"Parameters_Macro_toBatch.txt");
	print(file_temp, min_size + "  \t" + max_size);
	File.close(file_temp);
}
if (execution!='0'){
	str=File.openAsString(chemin+"Parameters_Macro_toBatch.txt"); 
	lines=split(str,"\t");
  	min_size=parseFloat(lines[0]);
  	max_size=parseFloat(lines[1]);
}

run("Clear Results");
setAutoThreshold("Otsu dark");
run("Set Measurements...", "area perimeter shape feret's limit redirect=None decimal=2");
run("Analyze Particles...", "size="+min_size+"-"+max_size+" display exclude clear summarize add");
Summary_to_Result();
print("Done for image"+image);
