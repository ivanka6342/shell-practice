#### document content:
+ How-To-Use
+ OUTPUT data format
+ INPUT data format
  + LIB structure
    + CELL1 structure
      + VIEW1 structure
    + CELL2 structure
      + VIEW2 structure
      + VIEWMAP structure


## How-To-Use
This script is designed to parse CAD-output files. This files are INPUT for script <br/>
> Before work, enter this command `PowerShell Set-ExecutionPolicy Unrestricted` in the console. it allows scripts to run in system. It allows scripts to run on the system.

Put the script in any folder(working directory) with INPUT files <br/>
To run the script, Right-click -> Run with PowerShell (or type `PowerShell .\parser.ps1` in PS-console) <br/>


## OUTPUT data format
Parsing results are saved to working directory in [.txt] format. <br/>
Output-file contains a sequential description of the components in human-readable form. For example:

	COMPONENT : ADG772BCPZ
		7 : SB
		9 : SA
		10 : GND
		3 : SB
		2 : D
		1 : SA
		4 : IN
		6 : VCC
		5 : IN
		8 : D

	COMPONENT : ADM7170ACPZ_FIX
		7 : VIN1
		9 : PAD
		3 : SENSE
		2 : VOUT2
		1 : VOUT1
		4 : SS
		6 : GND
		5 : EN
		8 : VIN2

## INPUT data format
#### Keywords
  `---` : minimized block contents
  `***` : repeating blocks
  `/*block*/` : rare blocks
  `LIB` : Library
  `CELL` : Component
  `VIEW` : big parts of component
  `PORT` : pins of components

Script-INPUT is [.edn] files produced by CAD("Xpedition xDX Designer") software <br/>
INPUT-file structure:
```
  (edif DxD
    (edifVersion 2 0 0)
    (edifLevel 0)
    (keywordMap  (keywordLevel 0))
    (status
      ---
    )
	(library digital
	---
    )
	***
	(library Board1
    ---
    )
	(design Board1
	---
    )
  )
```

### LIB structure
LIB(library) - set of COMPONENTs. LIB example: digital, analog, Board1. <br/>
It seems that first two type LIBs are general purpose, with all components(LIB1); <br/>
But LIBs like the 3rd designed for specific boards(LIB2). <br/>
LIB description looks like this: <br/>
```
  (library digital
      (edifLevel 0)
      (technology
        ---
      )
      (cell CYUSB3014_FBX
        ---
      )
	    ***
	    (cell CYUSB3014_FBX
        ---
      )
  )
```

#### CELL1 structure
CELL - it is COMPONENT (they are signed like cell on top)
This is the cell1 in LIB1:
```
      (cell CYUSB3014_FBX
		(view cyusb3014_ctrl
        ---
        )
        ***
        (view jtag_v2
		    ---
        )
      )
```

##### VIEW1 structure
Thus, a CELL1 contains almost only a VIEW1 blocks.
VIEW - it is a part of COMPONENT, they looks like this here:
```
		(view cyusb3014_ctrl
          (viewType NETLIST)
          (interface
            (designator "?")
            (property Level  (string "STD")
              ---
            )
            (port CLKIN
              ---
            )
            ***
            (port XTALOUT
              ---
            )
          )
        )
```
		
Finally, the ports (pins) in the COMPONENT interfaces are described as follows:
// port - pin name
// designator - pin num
```
            (port CLKIN
              (direction INPUT)
              (designator "C5")
            )
```

#### CELL2 structure
This is what a cell looks like in LIB Board1:
```
      (cell Schematic1
		(view NETLIST_VIEW
          ---
        )
        (viewMap
          ---
        )
      )
```

##### VIEW2 structure
And this is view in library Board1:
```
		(view NETLIST_VIEW
          (contents		  
            (instance  (rename &0441I33793 "$1I33793")
			  ---
            )
			***
            (instance  (rename &0441I33934 "$1I33934")
              ---
            )
			/*
			(net
             ---
            )
			***
            (net
             ---
            )
			*/
          )
        )
```
		
where instance:
```
            (instance  (rename &0441I33934 "$1I33934")
              (viewRef jtag_v2  (cellRef CYUSB3014_FBX  (libraryRef digital)))
              (portInstance N_TRST  (designator ""))
              ***
              (portInstance TMS  (designator ""))
              (designator "?")
              (property  (rename Part_Label "Part Label")  (string "CYUSB3014_FBX")
                ---
              )
              (property  (rename Part_Name "Part Name")  (string "IC, Bridge, USB3.0x1, MFIx1, WLCSP-131, -40/+85")
                ---
              )
            )
```

##### VIEWMAP structure
The viewMap in library Board1:
```
		(viewMap  
		  (instanceBackAnnotate
            ---
          )
          (portBackAnnotate
            ---
		  )
		  ***
          (portBackAnnotate
            ---
          )
          ***
		  ***
          (instanceBackAnnotate
            ---
          )
		  (portBackAnnotate
            ---
          )
          ***
          (portBackAnnotate
            ---
          )
        )
```

where instanceBackAnnotate:
```
		  (instanceBackAnnotate
            (instanceRef &0441I33793  (viewRef NETLIST_VIEW))
            (designator "X1")
          )
```

and portBackAnnotate:
```
		  (portBackAnnotate
            (portRef CLKIN  (instanceRef &0441I33793  (viewRef NETLIST_VIEW)))
            (designator "C5")
          )
```