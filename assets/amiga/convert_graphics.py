from PIL import Image,ImageOps
import os,sys,bitplanelib

this_dir = os.path.dirname(os.path.abspath(__file__))

src_dir = os.path.join(this_dir,"..","..","src","amiga")

sprite_names = dict()

NB_TILES = 256
NB_SPRITES = 64

dump_it = True
dump_dir = os.path.join(this_dir,"dumps")

if dump_it:
    if not os.path.exists(dump_dir):
        os.mkdir(dump_dir)
        with open(os.path.join(dump_dir,".gitignore"),"w") as f:
            f.write("*")


def dump_asm_bytes(*args,**kwargs):
    bitplanelib.dump_asm_bytes(*args,**kwargs,mit_format=True)


def ensure_empty(d):
    if os.path.exists(d):
        for f in os.listdir(d):
            os.remove(os.path.join(d,f))
    else:
        os.makedirs(d)

def load_tileset(image_name,palette_index,side,used_tiles,tileset_name,dumpdir,dump=False,name_dict=None):

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
        dump_subdir = os.path.join(dumpdir,tileset_name)
        if palette_index == 0:
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
                        name = name_dict.get(tile_number,"unknown")
                    else:
                        name = "unknown"

                    img.save(os.path.join(dump_subdir,f"{name}_{tile_number:02x}_{palette_index:02x}.png"))

            tile_number += 1

    return sorted(set(palette)),tileset_1


tile_plane_cache = dict()
sprite_plane_cache = dict()

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
    if isinstance(index,range):
        pass
    elif not isinstance(index,list):
        index = [index]
    for idx in index:
        sprite_names[idx] = name

def add_sprite_range(start,end,name):
    for i in range(start,end):
        sprite_names[i] = name


sprite_names = {}

add_sprite(0,"small_rock")
add_sprite(1,"upside_down_wolf")
add_sprite([3,4,9],"piglet")
add_sprite([6,0x1D,0xB],"falling_wolf")
add_sprite(7,"basket_bottom")
#add_sprite_range(8,10,"pig")
add_sprite(0xA,"basket_top")
add_sprite(0xF,"basket_bottom")
add_sprite(0x10,"meat")
add_sprite(0x3A,"points_1600")
add_sprite([0x37,0x39],"points")


add_sprite(0x11,"player_in_basket_top")
add_sprite(0x1c,"strawberry")  # wrong CLUT
add_sprite(0x12,"player_in_basket_bottom")
add_sprite(0x14,"arrow")
add_sprite(0x1b,"arrow")
add_sprite(0x25,"player_in_basket_top")
add_sprite(0x16,"player_in_basket_bottom")
add_sprite_range(0x26,0x2A,"wolf")
add_sprite_range(0x20,0x25,"baloon")  # 0: yellow
add_sprite_range(0x3B,0x3F,"baloon")  # 0: yellow
add_sprite(0x2,"baloon")
add_sprite(0x2d,"baloon")
add_sprite([0x17,0x18,0x13],"bow")
add_sprite([0x30,0x3F,0x35,0x38],"rock")

add_sprite_range(0x31,0x35,"burst")
add_sprite([0xD,0x36,0x15,0x1E],"pig")


add_sprite([0x19,0x1F,0x2a,0x2B],"wolf")
add_sprite(range(0x2e,0x30),"ladder_wolf")
add_sprite([0xe,0x1A,0xC,5,8],"falling_player")


sprites_path = os.path.join(this_dir,os.path.pardir,"pooyan")


sprite_sheet_dict = {i:Image.open(os.path.join(sprites_path,f"sprites_pal_{i:02x}.png")) for i in [0]}
tile_sheet_dict = {i:Image.open(os.path.join(sprites_path,f"tiles_pal_{i:02x}.png")) for i in range(16)}

tile_palette = set()
tile_set_list = []

for i,tsd in tile_sheet_dict.items():
    tp,tile_set = load_tileset(tsd,i,8,None,"tiles",dump_dir,dump=dump_it,name_dict=None)
    tile_set_list.append(tile_set)
    tile_palette.update(tp)

sprite_palette,sprite_set = load_tileset(sprite_sheet_dict[0],0,16,None,"sprites",dump_dir,dump=dump_it,name_dict=sprite_names)

full_palette = sorted(set(sprite_palette) | tile_palette)

nb_planes = 5
nb_colors = 1<<5

full_palette += (nb_colors-len(full_palette)) * [(0x10,0x20,0x30)]

sprite_table = [None]*NB_SPRITES

next_cache_id = 1

tile_table = []
for n,tile_set in enumerate(tile_set_list):
    tile_entry = []
    for i,tile in enumerate(tile_set):
        entry = dict()
        if tile:
            for x in range(2):
                if x:
                    tile = ImageOps.mirror(tile)

                bitplane_data = bitplanelib.palette_image2raw(tile,None,full_palette)

                plane_size = len(bitplane_data) // nb_planes
                bitplane_plane_ids = []
                for j in range(nb_planes):
                    offset = j*plane_size
                    bitplane = bitplane_data[offset:offset+plane_size]

                    cache_id = tile_plane_cache.get(bitplane)
                    if cache_id is not None:
                        bitplane_plane_ids.append(cache_id)
                    else:
                        if any(bitplane):
                            tile_plane_cache[bitplane] = next_cache_id
                            bitplane_plane_ids.append(next_cache_id)
                            next_cache_id += 1
                        else:
                            bitplane_plane_ids.append(0)  # blank
                entry["mirror_planes" if x else "planes"] = bitplane_plane_ids

        tile_entry.append(entry)

    tile_table.append(tile_entry)

new_tile_table = [[[] for _ in range(16)] for _ in range(256)]

# reorder/transpose. We have 16 * 256 we need 256 * 16
for i,u in enumerate(tile_table):
    for j,v in enumerate(u):
        new_tile_table[j][i] = v

tile_table = new_tile_table

with open(os.path.join(src_dir,"palette.68k"),"w") as f:
    bitplanelib.palette_dump(full_palette,f,bitplanelib.PALETTE_FORMAT_ASMGNU)

with open(os.path.join(src_dir,"graphics.68k"),"w") as f:
    f.write("\t.global\tcharacter_table\n")
    f.write("\t.global\tbob_table\n")

    f.write("character_table:\n")

    for i,tile_entry in enumerate(tile_table):
        f.write("\t.long\t")
        if tile_entry:
            f.write(f"tile_{i:02x}")
        else:
            f.write("0")
        f.write("\n")

    for i,tile_entry in enumerate(tile_table):
        if tile_entry:
            f.write(f"tile_{i:02x}:\n")
            for j,t in enumerate(tile_entry):
                f.write("\t.long\t")
                if t:
                    f.write(f"tile_{i:02x}_{j:02x}")
                else:
                    f.write("0")
                f.write("\n")


    for i,tile_entry in enumerate(tile_table):
        if tile_entry:
            for j,t in enumerate(tile_entry):
                if t:
                    name = f"tile_{i:02x}_{j:02x}"
                    f.write(f"{name}:\n")
                    for bitplane_id in t["planes"]:
                        f.write("\t.long\t")
                        if bitplane_id:
                            f.write(f"tile_plane_{bitplane_id:02d}")
                        else:
                            f.write("0")
                        f.write("\n")
                    if "mirror_planes" in t:
                        f.write("* mirror\n")
                        for bitplane_id in t["mirror_planes"]:
                            f.write("\t.long\t")
                            if bitplane_id:
                                f.write(f"tile_plane_{bitplane_id:02d}")
                            else:
                                f.write("0")
                            f.write("\n")

                    #dump_asm_bytes(t["bitmap"],f)

    for k,v in tile_plane_cache.items():
        f.write(f"tile_plane_{v:02d}:")
        dump_asm_bytes(k,f)

    f.write("bob_table:\n")

