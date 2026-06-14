# RGB Color Swapper

A small tool for quickly and easily swapping color channels in images. The motivation for this was an 
occasional bug in the NVIDIA app when creating high-resolution screenshots in some video games.

Sometimes the rgb color channels are swapped, and the screenshots look like this:

![swapped RGB channels](/doc/sample.jpg)

The RGB Color Swapper can swap the channels so that the colors are displayed correctly again.

![fixed colors](/doc/swapped.png)

## System requirements

* Windows 10, 11

## Usage

* Drag&Drop files into the main window (or use the menu)
* Select the correct swap mode option
* Save changes. For a single file you'll get a "Save As" dialog. If you have selected multiple files, you can 
choose from various options for how the images should be processed.

![batch settings](/doc/settings.png)

## Known quirks

* PNG files are always saved as 32-bit images. This means the file size may increase slightly. 
In most cases, however, it makes sense to choose JPEG as the target format.
* No metadata (e.g. exif) is carried over to the edited files. However, this isn't a problem for most game screenshots.

