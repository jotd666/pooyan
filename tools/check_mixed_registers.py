import os,re

this_dir = os.path.dirname(os.path.abspath(__file__))

register_re = re.compile(r"\b([ad]\d)\b",flags=re.I)

with open(os.path.join(this_dir,"..","src","pooyan.68k")) as f:
    lines = list(f)

def extract_regs(line):
    line = line.split("|")[0]
    return set(register_re.findall(line))

for i,line in enumerate(lines):
    regs = extract_regs(line)
    if regs:
        if "a0" in regs:
            for j in range(i+1,i+10):
                next_line = lines[i]
                next_regs = extract_regs(next_line)
                if "d6" in next_regs or "d5" in next_regs:
                    print("a0/d5/d6 mixup")
                    for k in range(i,i+10):
                        print(lines[k],end="")
                    break
