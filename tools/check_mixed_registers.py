import os,re

this_dir = os.path.dirname(os.path.abspath(__file__))

register_re = re.compile(r"\b([ad]\d)\b",flags=re.I)

with open(os.path.join(this_dir,"..","src","pooyan.68k")) as f:
    lines = list(f)

def extract_regs(line):
    line = line.split("|")[0]
    return {x for x in register_re.findall(line)}

start = False

i = 0
nb_hits = 0
while i < len(lines):
    line = lines[i]
    if "disassembly by JOTD" in line:
        start = True
    if line.strip().startswith("*"):
        i+=1
        continue

    if start:
        if "movem" not in line.lower():
            regs = extract_regs(line)
            if regs:
                for r1,r2,mp1,mp2 in (("a0","d6","_A0_","D5D6"),("d6","a0","_A0_","D5D6"),("a1","d4","_A1_","D3D4"),("d4","a1","_A1_","D3D4")):
                    if r1 in regs and "jra" not in line:
                        for j in range(i+1,i+10):
                            next_line = lines[j]
                            if next_line.strip().startswith("*"):
                                continue
                            toks = next_line.split()
                            if "rts" in toks:
                                break
                            if "jra" in toks:
                                break
                            if mp1 in next_line:
                                break
                            if mp2 in next_line:
                                break
                            if "coherence" in next_line:
                                break
                            next_regs = extract_regs(next_line)
                            if r2 in next_regs:
                                print(f"*****a0/d6 mixup line {i+1}")
                                for k in range(i,j+1):
                                    print(lines[k],end="")
                                nb_hits += 1
                                i = j
                                break
    i+=1

print(nb_hits)