(1) Hello and welcome to the MEMS_CAD_Pipeline GDSII Toolbox, below we will briefly talk about what GDSII is and how to get started...

What is GDSII?
-GDSII is a file format used to store and edit designs for electronics and Micromachine devices, with modules such as Matlab's/Octave's GDSII Toolbox 
(https://github.com/ulfgri/gdsii-toolbox) or Python libraries such as GDSpy (https://gdspy.readthedocs.io/en/stable/) we can write scripts that can generate
GDS files which we can then open in a Layout Viewer such as Klayout (https://www.klayout.de/) were we can run scripts to check that our design meets SOIMUMPS
design rule specifications.

What is SOIMUMPS
-SOIMUMPS is a fabrication process to create micromachines, all GDS tools and DRC (Design Rule Checker) scripts are designed to check that your GDS file meets SOIMUMPS
specifications for fabrication to learn more about SOIMUMPS either look up the following link (http://www.memscapinc.com/__data/assets/pdf_file/0019/1774/SOIMUMPs.dr.v8.0.pdf) 
or go into DRC_check_scripts folder where the soimumps_rules.pdf file should have and explain SOIMUMPS specifications.

Where can I find documentation/Tutorials for GDSII?
-Ulfgri's Matlab/Octave Toolbox contains documentation and examples of the GDSII toolbox, how to use it, and example scripts to use as templates when design 
SOIMUMPS devices using the GDSII file format (look at the readme file).

(https://github.com/ulfgri/gdsii-toolbox)

-Additionally for help using  GDSpy look at the documentation in the link below.

(https://gdspy.readthedocs.io/en/stable/)

-For help with the Layout Viewer Klayout, check out the following link.

(https://www.klayout.de/)


How is this Toolbox Organized
-Once you follow the steps in ulfgri's toolbox or gdspy to get some working GDSII script writing environment (in your working directory), you may now utilize the tools in this toolbox which 
are organized into the following folders....

	(FOLDER) DRC_check_scripts
		-drc.txt
		-DRC_Check.lydrc 
		-soimumps_rules
	(FOLDER) example_gdsii_files_and_scripts 
		-
		.
		.
		.
		-
	(FOLDER) test_gdsii_files
		-PMETL_to_SOI_violation (violates SOIMUMPS RULE 2.3 column 1)
	readme_instructions.txt


-DRC_check_scripts includes the DRC_Check script used in Klayout to check if a gdsii file meets SOIMUMPS specifications (still WIP) with additional documentation 
in DRC_Check.lydrc and soimumps_rules.pdf. Additionally, example_gdsii_files_and_scripts includes example Matlab Scripts used to generate GDSII files, and test_gdsii_files is 
meant to contain Matlab Scripts used to generate GDS files that violate specific SOIMUMPS design rules.

-This toolbox is still very much work in progress, so functionality may not be all the way there.