=======================================================================================================
- Using SED (StreamLine Editor) editor- = Temporary Editor
	: To update/changes the Lines in the Background.

Example: 

consider the passwd file under  /etc/passwd/. you see lot of lines. Here you need to update the Lines.
using CRUD method.

Syntax: sed -e 'a 1 <word to change/update'> <file-name>

		-e --> enable i.e Temporary Change, || -i --> Insert i.e Permanent Change.
		a --> append/after || i --> before
		1 --> Line Number i.e 1st Line.
		
Ex: sed -e '1 a I am Learning shell Script' passwd
	
- in the file, it will update this message after 1st line.
- so these are the Temporary changes, it won't save it.
- and once your run it, the output will display in the screen.

To need permanent changes, use -i

	sed -i '1 a I am Learning shell Script' passwd

- It will permanent change and it won't display it in the screen.
- open the file and you can verify it.

- To update the messgae before the line -- use i
	sed -i '1 i I am Learning shell Script' passwd

- If you are looking update from small 'sbin' to capital 'SBIN' --
------------------------------------------------------------
Syntax: sed -e 's/<word to find>/<word to replace>/' <filename.
	
	sed -e 's/sbin/SBIN/' passwd 	(By Default 1st occurance in the everyline)
	sed -e 's/sbin/SBIN/g' passwd 	(g(global) --> It will change everything)
	
- s --> substitute. like in VM editor we used %s.
- once you run this command, it will replace to capital SBIN in the entire File.


To Delete the Lines/Words -- sed -e '<line number d - delete>' <filename>

	sed -e '1d' passwd --> It will delete the 1st Line.
	sed -e '/learning/ d' passwd   --> It will delete the particular Word)
			/word to delete/

============================================================================================