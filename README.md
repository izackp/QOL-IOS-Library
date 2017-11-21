QOL-iOS-Library
===

What is this?
---

This is mostly a collection of generic and extremely useful categories on top of the iOS SDK's classes with a few helper classes.

It will be easier to for you to look at the code then for me to explain everything here.

Project Setup Instructions
---

There are 2 ways to set this project up:

A) You can add this to your podfile.

or

B) You can Drag and drop the project file into your project.

you will also have to

- Go to the Build Settings for your project and
  - Add the `-ObjC -all_load` linker flags to the `Other Linker Flags` property.
  - Add the path of the library to the `Header Search Paths` property and make sure its recursive. Ex: `"$(SOURCE_ROOT)"/ExternalLibs/QOL-iOS-Library`
