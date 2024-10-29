from PIL import Image,ImageOps
import os,sys,bitplanelib

this_dir = os.path.dirname(os.path.abspath(__file__))

src_dir = os.path.join(this_dir,"..","..","src","amiga")

sprite_names = dict()

side = 8

def dump_asm_bytes(*args,**kwargs):
    bitplanelib.dump_asm_bytes(*args,**kwargs,mit_format=True)


def ensure_empty(d):
    if os.path.exists(d):
        for f in os.listdir(d):
            os.remove(os.path.join(d,f))
    else:
        os.makedirs(d)

def load_tileset(image_name,side,used_tiles,tileset_name,dumpdir,dump=False,name_dict=None):

    if isinstance(image_name,str):
        full_image_path = os.path.join(this_dir,os.path.pardir,"pooyan",
                            tile_type,image_name)
        tiles_1 = Image.open(full_image_path)
    else:
        tiles_1 = image_name
    nb_rows = tiles_1.size[1] // side
    nb_cols = tiles_1.size[0] // side


    tileset_1 = []

    if dump:
        dump_subdir = os.path.join(dumpdir,tile_type,tileset_name)
        if tile_offset == 0:
            ensure_empty(dump_subdir)

    tile_number = 0
    palette = set()

    for j in range(nb_rows):
        for i in range(nb_cols):
            if used_tiles and tile_number not in used_tiles:
                tileset_1.append(None)
            else:

                img = Image.new("RGB",(side,side))
                img.paste(tiles_1,(-i*side,-j*side))

                # only consider colors of used tiles
                palette.update(set(bitplanelib.palette_extract(img)))


                tileset_1.append(img)
                if dump:
                    img = ImageOps.scale(img,5,resample=Image.Resampling.NEAREST)
                    if name_dict:
                        name = name_dict.get(tile_number+tile_offset,"unknown")
                    else:
                        name = "unknown"

                    img.save(os.path.join(dump_subdir,f"{name}_{tile_number+tile_offset:02x}.png"))

            tile_number += 1

    return sorted(set(palette)),tileset_1


def paint_black(img,coords):
    for x,y in coords:
        img.putpixel((x,y),(0,0,0))

def change_color(img,color1,color2):
    rval = Image.new("RGB",img.size)
    for x in range(img.size[0]):
        for y in range(img.size[1]):
            p = img.getpixel((x,y))
            if p==color1:
                p = color2
            rval.putpixel((x,y),p)
    return rval

def add_sprite(index,name):
    sprite_names[index] = name

def add_sprite_range(start,end,name):
    for i in range(start,end):
        sprite_names[i] = name


sprite_names = {}

add_sprite(0,"rock")
add_sprite(1,"upside_down_wolf")
add_sprite_range(3,6,"pig_1")
add_sprite(6,"falling_wolf")
add_sprite(7,"basket_bottom")
add_sprite_range(8,10,"pig_2")
add_sprite(10,"basket_top")


sprites_path = os.path.join(this_dir,os.path.pardir,"pooyan")

sprite_sheet_dict = {i:Image.open(os.path.join(sprites_path,f"sprites_pal_{i:02x}.png")) for i in [0]}

with open(os.path.join(src_dir,"palette.68k"),"w") as f:
    pass

