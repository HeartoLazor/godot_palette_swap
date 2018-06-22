# Godot Palette Swap
Replaces a Sprite color with another one using a mask.

![Demo](https://thumbs.gfycat.com/FrighteningAssuredKinkajou-size_restricted.gif)  

If an inconsistency appears between Intel/Amd/Nvidia GPU, Feel free to fix and commit it, but take this as a warning for production use.

## Requirements
Godot >= 3.x

## Installation
Copy the palette_swap_material.tres from 

`.\godot_pallete_swap\resources`

and use it as a material in your sprites.

## Usage
First you need to create a pow 2 palette texture. The shader read only the first row of the palette.

Pow 2 means, the palette width should be 2 ^ x, example values: 1, 2, 4, 8, 16, 32, 64, 128...

Example:

Megaman has 3 colors:

![Megaman Colors](https://i.imgur.com/aDuUvDC.png)

but 3 isn't pow two so the palette width should be expanded to the next compatible value which is 4 and filled with anything.

![Compatible Palette](https://i.imgur.com/bwTCztG.png)

Then you need to create a mask to use that palette, where each palette index is a red value in the mask, and a 255 color means ignore that pixel. This image should be imported in godot Lossless, unfiltered with mipmaps off

The formula for mask colors in rgb 255 values: (palette_pixel_index / palette_size) * 255, rounded up to the nearest value

For example the megaman palette, has 4 colors:

![Compatible Palette](https://i.imgur.com/bwTCztG.png)

Where the first color is the outline, with index 0, using the formula:

(0 / 4) * 255 = 0

The second one is 64:

(1 / 4) * 255 = 63,75 ~ 64

The third one is 128:

(2 / 4) * 255 = 127,5 ~ 128

and fill the rest of the mask with white (255)

This is the result:

![Mask](https://i.imgur.com/ZYP2Wmk.png)  

All this explanation could be summarized in this image:

![Guide](https://i.imgur.com/0fJQJ0z.png)  

### License
MIT License

Author: Hearto Lazor
