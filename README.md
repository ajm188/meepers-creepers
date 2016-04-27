# meepers-creepers

MIPS emulation in MatLab.
Cameron Gutman (cmg110)
Andrew Mason (ajm188)

## Errata

- Does not comply with Branch Delay Slot in official MIPS spec.
    - MARS (which generated our binaries) does not either.
- Occasionally, when attempting to abort yams from the GUI, the operation may
  appear to fail. This is because yams is blocked on a socket syscall. To
  proceed with the abortion, simply attempt to load a web page from the browser
  or curl, and yams will abort.

## How do I get MIPS binaries?

1. Download the [Mars
   simulator](http://courses.missouristate.edu/KenVollmar/MARS/).
    - Launch this by doing `java -jar NAME_OF_JAR`. You will probably want to
      alias this to a command in your shell while working on this project.
1. Enter some MIPS code ...
    - Look on the internet if you need help here.
1. Click "Assemble."
1. Click "Dump machine code or data in an available format."
    - You will want both the code and data sections.
    - You should select the "Binary" format from the dropdown.
