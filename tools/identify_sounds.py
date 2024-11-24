import os,re

known_sounds = {
0x26: "PLAYER_FALLING",    # done
0x1C: "GAME_INTRO_TUNE",
0x1A: "LEVEL_1_TUNE",
0x54: "",
0:"",
0x15: "",
0x16: "",
0x17: "",
0x27: "INTRO_TUNE",
0x1B: "LEVEL_2_TUNE",
0x1E: "LEVEL_1_COMPLETE",
0x22: "LEVEL_2_COMPLETE",
0xB: "CREDIT",              # done
0x11: "SHOT_BOUNCES",     # done
0x4:"INFLATING_BALLOON",  # done
0xD:"PLAYER_HIT",
0xE:"WOLF_PUSHES_ROCK",
0x5:"BURSTING_BALLOON",
0x6:"FRUIT_SHOT",
0x9:"ARROW_BOUNCES_OFF",
0x7:"ARROW_KILLS_ROCK",
0x8:"MEAT_HITS_WOLF",
0x2:"WOLF_FALLING",
0x3:"WOLF_CRASHED",
0xC:"LADDER_WOLF_SNAPS",
0xA:"MEAT_PICKED_UP",
0x1:"SHOOTING_ARROW",
0x10:"PLAYER_CRASHED",
0x1D:"GAME_OVER_MUSIC",
0x13:"BONUS_STAGE_PING",
0x29:"HIGH_SCORE_TUNE",
0x22:"BONUS_STAGE_TUNE",
}
#with open(r"K:\Emulation\MAME\sndbkpts","w") as f:
cond = "&&".join(f"A!=${k:x}" for k in known_sounds)
      # f.write("bpset ${:04x},A==${:02x},{g}\n".format(,k))
print("bpset ${:04x},{} && A<$80".format(0x0E8F,cond))

print("remove tunes")
musics = [k for k,v in known_sounds.items() if "TUNE" in v]
cond = "||".join(f"A==${k:x}" for k in musics)
print("bpset ${:04x},{},{{PC=$001f;g}}".format(0x0E8F,cond))

blank = [k for k,v in known_sounds.items() if not v]
print("only tunes")
cond = "&&".join(f"A!=${k:x}" for k in musics+blank)
print("bpset ${:04x},{},{{PC=$001f;g}}".format(0x0E8F,cond))
