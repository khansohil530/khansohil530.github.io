---
title: "Pico8: Basic Tutorial to get you started"
description: "Pico8 tutorial to get you started on your journey for game development"
categories: [Game]
tags: [Pic8, Tutorial]
date: 2025-06-27
---

## Introduction

Pico8 is a lightweight game engine with limited access to resources like screen size, color palette, code length which
forces you to be more creative. One of the important reasons for these constraints is to direct you towards what's important
in your game and not diverge into too many half-baked features. You might also look at it from the perspective of a world
where computing resources were limited compared to today. Finally, the charm of developing games is so that other people
can try it. Pico8 makes this supper easy by allowing you to export games into digital cartridges (known as `carts`) which
can be of various formats from image to `html`. You can also view other games at their [official site](https://www.lexaloffle.com/pico-8.php)
and even inspect their code.

## Basic Commands
When you first enter Pico8, the engine starts in command mode where you can use commands like `SAVE`, `LOAD` and `RUN`.
To view a full list of commands, you can use `HELP` command or follow their online documentation.

Pressing `ESC` allows you to toggle between editor and command mode. Editor mode is the place where you can start 
developing your game.

**Shortcuts**: `Ctrl+R` → Run, `Ctrl+S` → Save

## Editor
Pico8 editor provides you with every tool to create a game, ranging from code editor to sound editor.

### Code Editor
This is the place where all your game code is written. There's a limit of 8192 **tokens** which you can use within this 
code editor. Tokens are basically statements, like `X=WIDTH+7` will take up five tokens of space.

**Shortcuts**: `Alt+Up/Down` → Go Up/Down a function, `Ctrl+L`→Move to specific line, `Ctrl+Up/Down`→ Move 
to very top/bottom of tab, `Ctrl+F, Ctrl+G`→ Find text or find again.

### Sprite Editor
Sprites are pieces of art that make up graphics of your game. For example, character, map tiles, pickup, background, etc.
You can create up to 256 8x8 sprites split across four tabs from 0 to 3. Note the last two tabs are shared with the lower
half of the Map Editor.

**Shortcuts**: `H/V`→ Flip Horizontally/Vertically, `R`→ Rotate sprite clockwise

### Map Editor
Map tiles use 8x8 sprites from the sprite editor, i.e., 16x16 tiles will file the whole screen. Even though you've
 a maximum map size of 128 tiles wide and 64 tiles tall, the lower half of map shares space with last two tabs of sprite
editor.

**Shortcuts**: `Mousewheel Up/Down`→ Zoom in/out

### Sound Editor
You can have up to 64 sounds, and each sound can have 32 different notes. Volume, frequency, speed, and effect of 
each note can be controlled. The Sound editor has two modes: **Pitch mode**, which is useful for simple sounds, and 
**Tracker mode**, which is useful for music.

**Shortcuts**: `Space`→ Play/stop, `-/+`→ Go to previous/next sound, 

### Music Editor

Allows you to create a pattern of music using sounds from the sound editor. Each pattern has four channels that can
contain a sound each. The Playback pattern is controlled by three buttons at top-right. Right-facing arrow marks a start
point, left-facing arrow marks a loop point, square button marks a stop point.

Playback flows from the end of one pattern to the beginning of the next. If playback reaches the end of a pattern and 
finds a loop point, it'll search backward until if finds a start point and play from there. Otherwise, if it finds a stop
point, playback will stop.

**Shortcuts**: `Space`→ Play/Stop, `-/+`→ Go to a previous/next pattern

<blockquote>
Coordinates: PICO-8's screen space is 128 pixels wide and 128 pixels tall. The coordinates `(0,0)` is in top left and `(127,127)`
on bottom right.
</blockquote>

<blockquote>
Pico8 uses Lua as its core language. Look it up on internet, pretty basic stuff.
</blockquote>

## Game Loop
The **Game Loop** is the mechanism that drives a game's logic and rendering processes.
Because each cycle of the loop updates the display, it is important for the loop to run at regular intervals to keep
the animation smooth and the game feeling responsive to user input.

PICO-8 has a built-in game loop that runs 30 times per second (or 30 FPS).
You use this in your code by defining three functions: `_INIT()`, `_UPDATE()`, and `_DRAW()`.
The `_INIT()` function executes only one time, when the game starts, then `_UPDATE()` and `_DRAW()` execute in a loop
respectively until your game ends.

## Tutorials
### Cave diver
Classic one button side-scrolling game like `Flappy Bird`. In this variation, we’re flying/bouncing
through a cave trying to get as deep into the cave as we can. You can find the source code [here](cave_diver.lua)

{{< pico8 src="/pico8/cave_diver/index.html" title="Zombie Garden" w="640" h="430" >}}

### Lander
Guide the lander on landing pad. You can furthure improve this by adding winds, obstacles, or more stages.
The code for this can be found [here](lander.lua)

{{< pico8 src="/pico8/lander/index.html" title="Zombie Garden" w="640" h="430" >}}

## Coroutines
Sometimes you need your functions to take longer than a single frame to execute or maybe have control over 
other things while your function is running. This can be achieved using `couroutines` which basically
`yield` to give control back to the function calling them and the coroutine can be resumed at any later point.
Pico8 provides four functions to work with Coroutine:

`cocreate(function_name)`: creates and returns a coroutine, but doesn't start it

`coresume(coroutine)`: passes control to coroutine

`costatus(coroutine)`: returns _running_, _suspended_ or _dead_ as per the status of coroutine

`yield()`: gives back the control to whatever called the coroutine

For example, the following code uses coroutine to reset the animation to start with the press of any button.
```lua
function _init()
 c_move=cocreate(move)
end

function _update()
 if c_move and costatus(c_move) != "dead" then
  coresume(c_move)
 else
  c_move=nil
 end
 if (btnp()>0) c_move=cocreate(move)
end

function _draw()
 cls(1)
 circ(x,y,r,12)
 print(current,4,4,7)
end

function move()
 x,y,r=32,32,8
 for i=32,96 do
  x=i
  yield()
 end
 
 current="top to bottom"
 for j=32,96 do
  y=j
  yield()
 end
 
 current="back to start"
 for i=96,32,-1 do
  x,y=i,i
  yield()
 end
end
```

## Publish your games
1. Add a title for your game by adding two comments to the top of your code. 
   This information will be added to your cart image
      ```lua
      -- game_name
      -- by creator_name
      ```
2. Create cart label image by pressing `F7` at any moment in game you want as the label.
3. Go to command mode and `save <game_name>.png` to save it as a shareable image

You can now publish the game to the Lexaloffle forum by submitting the cart image [here](https://www.lexaloffle.com/pico-8.php?page=submit).
Or you can export the cart image as `html` and `js` files for web by using `export <game>.html` command. You can also publish it
on [itch.io](https://itch.io/) by export the game as `html` with filename `index.html` and uploading the files as a zip.

And that is it. You can use this tool to create fun games and share with others. 
To find all available commands, go through these [Docs](https://www.lexaloffle.com/dl/docs/pico-8_manual.html). Have fun!