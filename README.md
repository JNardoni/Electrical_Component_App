# Electrical Component Tracking

As electricians look through a property, whether for planning a fix, expansion, or rework, they must record the different
electrical components located throughout. Outlets, sockets, overheads, etc. As opposed to writing these out on a notepad,
this app allows a user to do each of the steps quickly, including:

1. Create and store a new property
2. Add new rooms to said property
3. Add, remove, and comment on components on a room by room basis
4. Export the building to a PDF

All of this information is persistenetly stored in an SQLite database. This ensures that all information is saved and 
displayed accurately.

## Create Properties

New properties can be created, and are saved to the home screen. They save all information about their residence, and can be freely switched between.

<img src="https://github.com/JNardoni/Electrical_Component_App/blob/main/Sample%20Images/Home.png" title="Home Screen" width = "375" height="780">

## Add new rooms to said property

Each property has its own list of rooms. Rooms can be added by the user as needed, and can be removed via dragging it off the screen.
The adding screen keeps a list of the most popular rooms to be added for quick addition, though custom rooms can be added as well.

<img src="https://github.com/JNardoni/Electrical_Component_App/blob/main/Sample%20Images/Rooms.png" title="Add Rooms" width = "750" height="780">

## Add, remove, and comment on components

All components containt counters to enable adding multiple instances of objects to a single room. 
Components come in two forms, basic and advanced.
Basic are common, and are automatically added to every room.
Advanced components are added individually, via a list. Multiple can be added together, and they can hold custom descriptions as needed.

<img src="https://github.com/JNardoni/Electrical_Component_App/blob/main/Sample%20Images/Components.png" title="Advanced Components" width = "750" height="780">

Advanced components can be created by the user, and either added only to added to only the current room, or saved for later to be selected for future rooms as well.

<img src="https://github.com/JNardoni/Electrical_Component_App/blob/main/Sample%20Images/Add%20Components.png" title="Select Components" width = "750" height="780">

## Create PDF

Pdfs can be created on a house to house basis, creating a table with a list of rooms and all basic components with some advanced components (if it doesnt cause overflow). If extra room is needed, advanced components are given a seperate table.
