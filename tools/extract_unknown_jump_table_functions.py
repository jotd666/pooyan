import os,re

this_dir = os.path.dirname(os.path.abspath(__file__))

jere = re.compile(r"\s+\.long\s+l_(\w\w\w\w)\b",flags=re.I)

with open(os.path.join(this_dir,"..","src","pooyan.68k")) as f:
    lines = list(f)

result = set()

for line in lines:
    m = jere.match(line)
    if m:
        result.add(int(m.group(1),0x10))

with open(r"K:\Emulation\MAME\bkpts.txt","w") as f:
    f.write("bpclear\n")
    for r in sorted(result):
        f.write(f"bpset ${r:04x}\n")

print(len(result))