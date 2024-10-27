import os,re,struct

this_dir = os.path.dirname(os.path.abspath(__file__))

with open(os.path.join(this_dir,"..","assets","pooyan.bin"),"rb") as f:
    contents = f.read()

toff = 0x7A0D

olist = []
slist = []

for i in range(0,0x80,2):
    offset = struct.unpack_from("<H",contents,toff+i)[0]
    olist.append(offset)
    j = offset
    sparts = []
    x = []
    y = []

    while True:
        s = []
        x.append(contents[j])
        y.append(contents[j+1])
        j += 2
        while True:
            c = contents[j]
            j+=1
            s.append(chr(c))
            if c == 0x3F:
                break
            if c == 0x2E:
                break
        sparts.append("".join(s))
        if c == 0x3F:
            break
    slist.append({"offset":offset,"x":x,"y":y,"str":sparts})

with open("string_list.txt","w") as f:
    for sd in slist:
        f.write("str_{:04x}:\n".format(sd["offset"]))
        for x,y,s in zip(sd["x"],sd["y"],sd["str"]):
            f.write(f"\t.byte\t{x},{y}\n")
            f.write(f'\t.ascii\t"{s}"\n')
