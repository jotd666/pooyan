;
; Pooyan disassembly by JOTD
;
;	map(0x0000, 0x7fff).rom();
;	map(0x8000, 0x83ff).ram().w(FUNC(pooyan_state::colorram_w)).share(m_colorram);
;	map(0x8400, 0x87ff).ram().w(FUNC(pooyan_state::videoram_w)).share(m_videoram);
;	map(0x8800, 0x8fff).ram();  2k of ram
;	map(0x9000, 0x90ff).mirror(0x0b00).ram().share(m_spriteram[0]);
;	map(0x9400, 0x94ff).mirror(0x0b00).ram().share(m_spriteram[1]);
;	map(0xa000, 0xa000).mirror(0x5e7f).portr("DSW1");
;	map(0xa080, 0xa080).mirror(0x5e1f).portr("IN0");
;	map(0xa0a0, 0xa0a0).mirror(0x5e1f).portr("IN1");
;	map(0xa0c0, 0xa0c0).mirror(0x5e1f).portr("IN2");
;	map(0xa0e0, 0xa0e0).mirror(0x5e1f).portr("DSW0");
;	map(0xa000, 0xa000).mirror(0x5e7f).w("watchdog", FUNC(watchdog_timer_device::reset_w));
;	map(0xa100, 0xa100).mirror(0x5e7f).w("timeplt_audio", FUNC(timeplt_audio_device::sound_data_w));
;	map(0xa180, 0xa187).mirror(0x5e78).w("mainlatch", FUNC(ls259_device::write_d0));

x_pos_06 = 6
sprite_attributes_10 = $10
y_pos_04 = 4
sprite_code_0f = $f


0000: AF          xor  a
0001: 32 80 A1    ld   (mainlatch_a180),a
0004: C3 92 00    jp   bootup_0092


rst_08:
0008: 77          ld   (hl),a
0009: 3C          inc  a
000A: 23          inc  hl
000B: 77          ld   (hl),a
000C: 3C          inc  a
000D: 19          add  hl,de
000E: C9          ret

; fill (hl) b times with a value
rst_10:
0010: 77          ld   (hl),a
0011: 23          inc  hl
0012: 10 FC       djnz $0010
0014: C9          ret

rst_18:
0018: 77          ld   (hl),a
0019: 23          inc  hl
001A: 10 FC       djnz $0018
001C: 0D          dec  c
001D: 20 F9       jr   nz,$0018
001F: C9          ret

; read byte at hl+a into a
rst_20:
0020: 85          add  a,l
0021: 6F          ld   l,a
0022: 3E 00       ld   a,$00
0024: 8C          adc  a,h
0025: 67          ld   h,a
0026: 7E          ld   a,(hl)
0027: C9          ret

; jump to location using a jump table just after the rst call
rst_28:
0028: 87          add  a,a
0029: E1          pop  hl
002A: 5F          ld   e,a
002B: 16 00       ld   d,$00
002D: 19          add  hl,de
002E: 5E          ld   e,(hl)
002F: 23          inc  hl
0030: 56          ld   d,(hl)
0031: EB          ex   de,hl
0032: E9          jp   (hl)

rst_38:
0038: E5          push hl
0039: 26 88       ld   h,$88
003B: 3A A0 88    ld   a,($88A0)
003E: 6F          ld   l,a
003F: CB 7E       bit  7,(hl)
0041: 28 0E       jr   z,$0051
0043: 72          ld   (hl),d
0044: 2C          inc  l
0045: 73          ld   (hl),e
0046: 2C          inc  l
0047: 7D          ld   a,l
0048: FE C0       cp   $C0
004A: 30 02       jr   nc,$004E
004C: 3E C0       ld   a,$C0
004E: 32 A0 88    ld   ($88A0),a
0051: E1          pop  hl
0052: C9          ret

irq_0066:
0066: C3 6D 06    jp   irq_066D

table_0069:
0069  00 11 22 04 31 06 15 02 33 07 21 03 24 05 13 01
0079  00 33 05 61 BE 05 66 07 06 DD A8 05 60 BC 04 A6
0089  51 05 38 8A 06 AD BA 05 CA

bootup_0092:
0092: 32 00 A0    ld   (watchdog_a000),a                                      
0095: 31 00 90    ld   sp,ram_top_9000
0098: 32 00 88    ld   ($8800),a		; set to 0
009B: 06 08       ld   b,$08
009D: C5          push bc
009E: 21 00 00    ld   hl,$0000
00A1: DD 21 79 00 ld   ix,$0079
00A5: 11 00 00    ld   de,$0000
00A8: 4A          ld   c,d
00A9: 7B          ld   a,e
00AA: 86          add  a,(hl)
00AB: 5F          ld   e,a
00AC: 30 04       jr   nc,$00B2
00AE: 14          inc  d
00AF: 20 01       jr   nz,$00B2
00B1: 0C          inc  c
00B2: 2C          inc  l
00B3: 20 F4       jr   nz,$00A9
00B5: 24          inc  h
00B6: 7C          ld   a,h
00B7: E6 0F       and  $0F
00B9: 20 EE       jr   nz,$00A9
00BB: 32 00 A0    ld   (watchdog_a000),a
00BE: 7B          ld   a,e
00BF: DD BE 00    cp   (ix+$00)
00C2: 20 0C       jr   nz,$00D0
00C4: 7A          ld   a,d
00C5: DD BE 01    cp   (ix+$01)
00C8: 20 06       jr   nz,$00D0
00CA: 79          ld   a,c
00CB: DD BE 02    cp   (ix+$02)
00CE: 28 02       jr   z,$00D2
00D0: 18 06       jr   $00D8
00D2: E5          push hl
00D3: 21 FF 8F    ld   hl,$8FFF
00D6: 34          inc  (hl)
00D7: E1          pop  hl
00D8: DD 23       inc  ix
00DA: DD 23       inc  ix
00DC: DD 23       inc  ix
00DE: 10 C5       djnz $00A5
00E0: 3A E0 A0    ld   a,(dsw0_a0e0)
00E3: E6 0F       and  $0F
00E5: 21 69 00    ld   hl,$0069
00E8: E7          rst  $20
00E9: 7E          ld   a,(hl)
00EA: B7          or   a
00EB: 18 16       jr   $0103

00ED: 57          ld   d,a
00EE: E6 0F       and  $0F
00F0: 5F          ld   e,a
00F1: AA          xor  d
00F2: 0F          rrca
00F3: 0F          rrca
00F4: 0F          rrca
00F5: 0F          rrca
00F6: CD FA 00    call $00FA
00F9: 7B          ld   a,e
00FA: FE 0A       cp   $0A
00FC: 38 02       jr   c,$0100
00FE: C6 07       add  a,$07
0100: 77          ld   (hl),a
0101: 09          add  hl,bc
0102: C9          ret

0103: 32 00 A0    ld   (watchdog_a000),a
0106: 21 00 88    ld   hl,$8800
0109: 11 01 88    ld   de,$8801
010C: 01 FD 07    ld   bc,$07FD
010F: 36 00       ld   (hl),$00
; clear RAM
0111: ED B0       ldir
0113: 3E 08       ld   a,$08
0115: 32 42 8A    ld   ($8A42),a
0118: 21 C0 88    ld   hl,$88C0
; put FF $40 times
011B: 06 40       ld   b,$40
011D: 3E FF       ld   a,$FF
011F: D7          rst  $10
0120: 21 43 8A    ld   hl,$8A43
0123: 06 1C       ld   b,$1C
0125: D7          rst  $10
0126: 21 43 43    ld   hl,$4343
0129: 22 40 8A    ld   ($8A40),hl
012C: 32 00 A0    ld   (watchdog_a000),a
012F: 3E 01       ld   a,$01
0131: 32 87 A1    ld   ($A187),a
0134: 32 1F 88    ld   ($881F),a
0137: 21 C0 C0    ld   hl,$C0C0
013A: 22 A0 88    ld   ($88A0),hl
; put $10 in video ram
013D: 21 00 80    ld   hl,$8000
0140: 11 01 80    ld   de,$8001
0143: 36 10       ld   (hl),$10
0145: 01 00 04    ld   bc,$0400
0148: ED B0       ldir
014A: CD E6 02    call $02E6
014D: 32 00 A0    ld   (watchdog_a000),a
0150: 3A 00 A0    ld   a,(dsw1_a000)
0153: 2F          cpl
0154: 0F          rrca
0155: 0F          rrca
0156: 47          ld   b,a
0157: E6 01       and  $01
0159: 32 0F 88    ld   ($880F),a
015C: 78          ld   a,b
015D: 0F          rrca
015E: 47          ld   b,a
015F: E6 01       and  $01
0161: 32 00 88    ld   ($8800),a
0164: 78          ld   a,b
0165: 0F          rrca
0166: 47          ld   b,a
0167: E6 07       and  $07
0169: 32 20 88    ld   ($8820),a
016C: 78          ld   a,b
016D: 0F          rrca
016E: 0F          rrca
016F: 0F          rrca
0170: 47          ld   b,a
0171: E6 01       and  $01
0173: 32 21 88    ld   ($8821),a
0176: 3A 00 A0    ld   a,(dsw1_a000)
0179: 2F          cpl
017A: E6 03       and  $03
017C: FE 03       cp   $03
017E: 28 04       jr   z,$0184
0180: C6 03       add  a,$03
0182: 18 02       jr   $0186
0184: 3E FF       ld   a,$FF
0186: 32 07 88    ld   ($8807),a
0189: 3A E0 A0    ld   a,(dsw0_a0e0)
018C: 47          ld   b,a
018D: E6 F0       and  $F0
018F: 0F          rrca
0190: 0F          rrca
0191: 0F          rrca
0192: 0F          rrca
0193: 21 53 00    ld   hl,$0053
0196: E7          rst  $20
0197: 32 2F 88    ld   ($882F),a
019A: 78          ld   a,b
019B: E6 0F       and  $0F
019D: 21 53 00    ld   hl,$0053
01A0: E7          rst  $20
01A1: 32 2C 88    ld   ($882C),a
01A4: 32 00 A0    ld   (watchdog_a000),a
01A7: CD EA 01    call $01EA
01AA: AF          xor  a
01AB: CD 8F 0E    call audio_shit_0E8F
01AE: 3E 01       ld   a,$01
01B0: 32 80 A1    ld   (mainlatch_a180),a
01B3: 21 00 8A    ld   hl,$8A00
01B6: 06 0A       ld   b,$0A
01B8: 36 00       ld   (hl),$00
01BA: 2C          inc  l
01BB: 36 00       ld   (hl),$00
01BD: 2C          inc  l
01BE: 36 01       ld   (hl),$01
01C0: 2C          inc  l
01C1: 10 F5       djnz $01B8
01C3: 21 AA 88    ld   hl,$88AA
01C6: 36 01       ld   (hl),$01
01C8: 32 00 A0    ld   (watchdog_a000),a
01CB: 21 C0 89    ld   hl,$89C0
01CE: AF          xor  a
01CF: 06 1E       ld   b,$1E
01D1: D7          rst  $10
01D2: C3 0F 02    jp   $020F
01D5: 32 00 A0    ld   (watchdog_a000),a
01D8: 18 FB       jr   $01D5
01DA: 0B          dec  bc
01DB: 32 00 A0    ld   (watchdog_a000),a
01DE: 3A 80 A0    ld   a,(in0_a080)
01E1: CB 5F       bit  3,a
01E3: C0          ret  nz
01E4: 78          ld   a,b
01E5: B1          or   c
01E6: 20 F2       jr   nz,$01DA
01E8: 37          scf
01E9: C9          ret
01EA: 21 10 94    ld   hl,$9410
01ED: 06 30       ld   b,$30
01EF: D7          rst  $10
01F0: 21 10 90    ld   hl,$9010
01F3: 06 30       ld   b,$30
01F5: D7          rst  $10
01F6: 21 40 84    ld   hl,$8440
01F9: 11 41 84    ld   de,$8441
01FC: 01 BF 03    ld   bc,$03BF
01FF: 36 1E       ld   (hl),$1E
0201: ED B0       ldir
0203: 00          nop
0204: 00          nop
0205: 00          nop
0206: 10 FB       djnz $0203
0208: 32 00 A0    ld   (watchdog_a000),a
020B: 0D          dec  c
020C: 20 F5       jr   nz,$0203
020E: C9          ret

020F: 26 88       ld   h,$88
0211: 3A A1 88    ld   a,($88A1)
0214: 6F          ld   l,a
0215: 7E          ld   a,(hl)
0216: 87          add  a,a
0217: 30 05       jr   nc,$021E
0219: CD 54 02    call $0254
021C: 18 F1       jr   $020F
021E: E6 1F       and  $1F
0220: 4F          ld   c,a
0221: 06 00       ld   b,$00
0223: 36 FF       ld   (hl),$FF
0225: 23          inc  hl
0226: 5E          ld   e,(hl)
0227: 36 FF       ld   (hl),$FF
0229: 2C          inc  l
022A: 7D          ld   a,l
022B: FE C0       cp   $C0
022D: 30 02       jr   nc,$0231
022F: 3E C0       ld   a,$C0
0231: 32 A1 88    ld   ($88A1),a
0234: 7B          ld   a,e
0235: 21 42 02    ld   hl,$0242
0238: 09          add  hl,bc
0239: 5E          ld   e,(hl)
023A: 23          inc  hl
023B: 56          ld   d,(hl)
023C: 21 0F 02    ld   hl,$020F
023F: E5          push hl
0240: EB          ex   de,hl
0241: E9          jp   (hl)
0242: 9B          sbc  a,e
0243: 03          inc  bc
0244: C2 03 E9    jp   nz,$E903
0247: 03          inc  bc
0248: 96          sub  (hl)
0249: 04          inc  b
024A: 52          ld   d,d
024B: 05          dec  b
024C: 6B          ld   l,e
024D: 05          dec  b
024E: B2          or   d
024F: 05          dec  b
0250: EE 05       xor  $05
0252: 44          ld   b,h
0253: 06 3A       ld   b,$3A
0255: 3F          ccf
0256: 88          adc  a,b
0257: 47          ld   b,a
0258: E6 0F       and  $0F
025A: CA 61 02    jp   z,$0261
025D: CD 8C 20    call anti_hack_check_208C
0260: C9          ret
0261: 3A 06 88    ld   a,($8806)
0264: A7          and  a
0265: C8          ret  z
0266: 11 E0 FF    ld   de,$FFE0
0269: 21 E0 84    ld   hl,$84E0
026C: 3A 0E 88    ld   a,($880E)
026F: A7          and  a
0270: 28 22       jr   z,$0294
0272: 36 02       ld   (hl),$02
0274: CD AA 02    call $02AA
0277: 21 40 87    ld   hl,$8740
027A: CD A8 02    call $02A8
027D: 3A 0D 88    ld   a,($880D)
0280: A7          and  a
0281: 21 40 87    ld   hl,$8740
0284: 28 03       jr   z,$0289
0286: 21 E0 84    ld   hl,$84E0
0289: CB 60       bit  4,b
028B: C8          ret  z
028C: 3A 06 88    ld   a,($8806)
028F: 0F          rrca
0290: D0          ret  nc
0291: C3 B1 02    jp   $02B1
0294: 21 E0 84    ld   hl,$84E0
0297: CD B1 02    call $02B1
029A: 21 21 85    ld   hl,$8521
029D: CD B1 02    call $02B1
02A0: CD B1 02    call $02B1
02A3: CD B1 02    call $02B1
02A6: 18 CF       jr   $0277
02A8: 36 01       ld   (hl),$01
02AA: 19          add  hl,de
02AB: 36 25       ld   (hl),$25
02AD: 19          add  hl,de
02AE: 36 20       ld   (hl),$20
02B0: C9          ret
02B1: 3E 10       ld   a,$10
02B3: 77          ld   (hl),a
02B4: 19          add  hl,de
02B5: 77          ld   (hl),a
02B6: 19          add  hl,de
02B7: 77          ld   (hl),a
02B8: C9          ret
02B9: 21 40 88    ld   hl,sprite_shadow_ram_8840
02BC: 06 60       ld   b,$60
02BE: AF          xor  a
02BF: D7          rst  $10
02C0: 21 80 8A    ld   hl,top_basket_object_8A80
02C3: D7          rst  $10
02C4: D7          rst  $10
02C5: 06 37       ld   b,$37
02C7: D7          rst  $10
02C8: C9          ret

02C9: CD B9 02    call $02B9
02CC: 06 1D       ld   b,$1D
02CE: 3E 20       ld   a,$20
02D0: 90          sub  b
02D1: 5F          ld   e,a
02D2: 16 00       ld   d,$00
02D4: 2A 0B 88    ld   hl,($880B)
02D7: 3E 10       ld   a,$10
02D9: D7          rst  $10
02DA: 19          add  hl,de
02DB: 22 0B 88    ld   ($880B),hl
02DE: 21 09 88    ld   hl,$8809
02E1: 35          dec  (hl)
02E2: C9          ret

02E3: 21 02 84    ld   hl,$8402
02E6: 22 0B 88    ld   ($880B),hl
02E9: 3E 20       ld   a,$20
02EB: 32 09 88    ld   ($8809),a
02EE: C9          ret

update_sprite_shadows_02EF:
02EF: 21 40 88    ld   hl,sprite_shadow_ram_8840
02F2: DD 21 80 8A ld   ix,top_basket_object_8A80
02F6: 11 18 00    ld   de,$0018
02F9: 06 02       ld   b,$02
02FB: CD 2A 03    call update_sprite_shadow_0321
02FE: DD 21 90 8C ld   ix,$8C90
0302: 06 02       ld   b,$02
0304: CD 2A 03    call update_sprite_shadow_0321
0307: DD 21 E0 8A ld   ix,$8AE0
030B: 06 12       ld   b,$12
030D: CD 43 03    call $0343
0310: DD 21 B0 8A ld   ix,$8AB0
0314: 06 02       ld   b,$02
0316: CD 2A 03    call update_sprite_shadow_0321
0319: 21 98 88    ld   hl,$8898
031C: 35          dec  (hl)
031D: 21 9C 88    ld   hl,$889C
0320: 35          dec  (hl)
0321: 3A 1F 88    ld   a,($881F)
0324: A7          and  a
0325: C0          ret  nz
0326: CD 78 03    call $0378
0329: C9          ret

; < HL: 88xx (to write to shadow sprite ram)
; < IX: character structure X,Y, ...
update_sprite_shadow_0321:
032A: DD 7E 06    ld   a,(ix+x_pos_06)
032D: 77          ld   (hl),a
032E: 2C          inc  l
032F: DD 7E 10    ld   a,(ix+sprite_attributes_10)
0332: 77          ld   (hl),a
0333: 2C          inc  l
0334: DD 7E 04    ld   a,(ix+y_pos_04)
0337: 77          ld   (hl),a
0338: 2C          inc  l
0339: DD 7E 0F    ld   a,(ix+sprite_code_0f)
033C: 77          ld   (hl),a
033D: 2C          inc  l
033E: DD 19       add  ix,de
0340: 10 E8       djnz update_sprite_shadow_0321
0342: C9          ret

0343: DD 4E 05    ld   c,(ix+$05)
0346: DD 7E 06    ld   a,(ix+$06)
0349: CB 01       rlc  c
034B: 17          rla
034C: CB 01       rlc  c
034E: 17          rla
034F: CB 01       rlc  c
0351: 17          rla
0352: D6 08       sub  $08
0354: 77          ld   (hl),a
0355: 2C          inc  l
0356: DD 7E 10    ld   a,(ix+$10)
0359: 77          ld   (hl),a
035A: 2C          inc  l
035B: DD 7E 04    ld   a,(ix+$04)
035E: DD 4E 03    ld   c,(ix+$03)
0361: CB 01       rlc  c
0363: 17          rla
0364: CB 01       rlc  c
0366: 17          rla
0367: CB 01       rlc  c
0369: 17          rla
036A: D6 08       sub  $08
036C: 77          ld   (hl),a
036D: 2C          inc  l
036E: DD 7E 0F    ld   a,(ix+$0f)
0371: 77          ld   (hl),a
0372: 2C          inc  l
0373: DD 19       add  ix,de
0375: 10 CC       djnz $0343
0377: C9          ret

0378: 11 40 88    ld   de,sprite_shadow_ram_8840
037B: 06 18       ld   b,$18
037D: 1A          ld   a,(de)
037E: ED 44       neg
0380: D6 10       sub  $10
0382: 12          ld   (de),a
0383: 1C          inc  e
0384: 1A          ld   a,(de)
0385: E6 C0       and  $C0
0387: EE C0       xor  $C0
0389: 4F          ld   c,a
038A: 1A          ld   a,(de)
038B: E6 0F       and  $0F
038D: B1          or   c
038E: 12          ld   (de),a
038F: 1C          inc  e
0390: 1A          ld   a,(de)
0391: ED 44       neg
0393: D6 10       sub  $10
0395: 12          ld   (de),a
0396: 1C          inc  e
0397: 1C          inc  e
0398: 10 E3       djnz $037D
039A: C9          ret
039B: 3A 06 88    ld   a,($8806)
039E: A7          and  a
039F: C8          ret  z
03A0: 21 82 84    ld   hl,$8482
03A3: 11 20 00    ld   de,$0020
03A6: 3A 80 8A    ld   a,(top_basket_object_8A80)
03A9: 3C          inc  a
03AA: FE 08       cp   $08
03AC: 38 02       jr   c,$03B0
03AE: 3E 08       ld   a,$08
03B0: 4F          ld   c,a
03B1: 47          ld   b,a
03B2: 36 0C       ld   (hl),$0C
03B4: 19          add  hl,de
03B5: 10 FB       djnz $03B2
03B7: 3E 08       ld   a,$08
03B9: 91          sub  c
03BA: C8          ret  z
03BB: 47          ld   b,a
03BC: 36 10       ld   (hl),$10
03BE: 19          add  hl,de
03BF: 10 FB       djnz $03BC
03C1: C9          ret
03C2: 21 3F 86    ld   hl,$863F
03C5: 11 E0 FF    ld   de,$FFE0
03C8: 3A 08 89    ld   a,(nb_lives_8908)
03CB: A7          and  a
03CC: C8          ret  z
03CD: 3D          dec  a
03CE: 4F          ld   c,a
03CF: 28 0D       jr   z,$03DE
03D1: FE 05       cp   $05
03D3: 38 02       jr   c,$03D7
03D5: 3E 05       ld   a,$05
03D7: 4F          ld   c,a
03D8: 47          ld   b,a
03D9: 36 B0       ld   (hl),$B0
03DB: 19          add  hl,de
03DC: 10 FB       djnz $03D9
03DE: 3E 05       ld   a,$05
03E0: 91          sub  c
03E1: C8          ret  z
03E2: 47          ld   b,a
03E3: 36 10       ld   (hl),$10
03E5: 19          add  hl,de
03E6: 10 FB       djnz $03E3
03E8: C9          ret
03E9: 3E 1A       ld   a,$1A
03EB: 06 0B       ld   b,$0B
03ED: F5          push af
03EE: C5          push bc
03EF: CD B2 05    call $05B2
03F2: C1          pop  bc
03F3: F1          pop  af
03F4: 3C          inc  a
03F5: 10 F6       djnz $03ED
03F7: 21 C7 85    ld   hl,$85C7
03FA: 11 20 00    ld   de,$0020
03FD: 06 0A       ld   b,$0A
03FF: DD 21 00 8A ld   ix,$8A00
0403: CD 29 04    call $0429
0406: 77          ld   (hl),a
0407: 19          add  hl,de
0408: DD 23       inc  ix
040A: CD 29 04    call $0429
040D: 77          ld   (hl),a
040E: 19          add  hl,de
040F: DD 23       inc  ix
0411: CD 29 04    call $0429
0414: 28 01       jr   z,$0417
0416: 77          ld   (hl),a
0417: 11 62 FF    ld   de,$FF62
041A: 19          add  hl,de
041B: 11 20 00    ld   de,$0020
041E: DD 23       inc  ix
0420: 10 E1       djnz $0403
0422: CD 39 04    call $0439
0425: CD 60 04    call $0460
0428: C9          ret
0429: DD 7E 00    ld   a,(ix+$00)
042C: 4F          ld   c,a
042D: E6 0F       and  $0F
042F: 77          ld   (hl),a
0430: 19          add  hl,de
0431: 79          ld   a,c
0432: 0F          rrca
0433: 0F          rrca
0434: 0F          rrca
0435: 0F          rrca
0436: E6 0F       and  $0F
0438: C9          ret
0439: DD 21 C0 89 ld   ix,$89C0
043D: 21 67 84    ld   hl,$8467
0440: 06 0A       ld   b,$0A
0442: 11 20 00    ld   de,$0020
0445: DD 23       inc  ix
0447: CD 29 04    call $0429
044A: 77          ld   (hl),a
044B: 19          add  hl,de
044C: 36 51       ld   (hl),$51
044E: 19          add  hl,de
044F: DD 23       inc  ix
0451: CD 29 04    call $0429
0454: 28 01       jr   z,$0457
0456: 77          ld   (hl),a
0457: DD 23       inc  ix
0459: 11 82 FF    ld   de,$FF82
045C: 19          add  hl,de
045D: 10 E3       djnz $0442
045F: C9          ret
0460: DD 21 00 8E ld   ix,$8E00
0464: 21 67 85    ld   hl,$8567
0467: 06 0A       ld   b,$0A
0469: 11 E0 FF    ld   de,$FFE0
046C: DD 7E 00    ld   a,(ix+$00)
046F: A7          and  a
0470: 20 02       jr   nz,$0474
0472: 3E 40       ld   a,$40
0474: 77          ld   (hl),a
0475: 19          add  hl,de
0476: DD 23       inc  ix
0478: DD 7E 00    ld   a,(ix+$00)
047B: A7          and  a
047C: 20 02       jr   nz,$0480
047E: 3E 40       ld   a,$40
0480: 77          ld   (hl),a
0481: 19          add  hl,de
0482: DD 23       inc  ix
0484: DD 7E 00    ld   a,(ix+$00)
0487: A7          and  a
0488: 20 02       jr   nz,$048C
048A: 3E 40       ld   a,$40
048C: 77          ld   (hl),a
048D: DD 23       inc  ix
048F: 11 42 00    ld   de,$0042
0492: 19          add  hl,de
0493: 10 D4       djnz $0469
0495: C9          ret
0496: 4F          ld   c,a
0497: 3A 06 88    ld   a,($8806)
049A: 0F          rrca
049B: D0          ret  nc
049C: 79          ld   a,c
049D: A7          and  a
049E: 28 47       jr   z,$04E7
04A0: CD F2 04    call $04F2
04A3: 87          add  a,a
04A4: 81          add  a,c
04A5: 4F          ld   c,a
04A6: 06 00       ld   b,$00
04A8: 21 01 05    ld   hl,$0501
04AB: 09          add  hl,bc
04AC: A7          and  a
04AD: 06 03       ld   b,$03
04AF: 1A          ld   a,(de)
04B0: 8E          adc  a,(hl)
04B1: 27          daa
04B2: 12          ld   (de),a
04B3: 13          inc  de
04B4: 23          inc  hl
04B5: 10 F8       djnz $04AF
04B7: D5          push de
04B8: 3A 0D 88    ld   a,($880D)
04BB: 0F          rrca
04BC: 30 02       jr   nc,$04C0
04BE: 3E 01       ld   a,$01
04C0: CD 6B 05    call $056B
04C3: D1          pop  de
04C4: 1B          dec  de
04C5: 21 AA 88    ld   hl,$88AA
04C8: 06 03       ld   b,$03
04CA: 1A          ld   a,(de)
04CB: BE          cp   (hl)
04CC: D8          ret  c
04CD: 20 05       jr   nz,$04D4
04CF: 1B          dec  de
04D0: 2B          dec  hl
04D1: 10 F7       djnz $04CA
04D3: C9          ret
04D4: CD F2 04    call $04F2
04D7: 21 A8 88    ld   hl,$88A8
04DA: 06 03       ld   b,$03
04DC: 1A          ld   a,(de)
04DD: 77          ld   (hl),a
04DE: 13          inc  de
04DF: 23          inc  hl
04E0: 10 FA       djnz $04DC
04E2: 3E 02       ld   a,$02
04E4: C3 6B 05    jp   $056B
04E7: CD F2 04    call $04F2
04EA: 21 AB 88    ld   hl,$88AB
04ED: A7          and  a
04EE: 06 03       ld   b,$03
04F0: 18 BD       jr   $04AF
04F2: F5          push af
04F3: 3A 0D 88    ld   a,($880D)
04F6: 11 A2 88    ld   de,$88A2
04F9: 0F          rrca
04FA: 30 03       jr   nc,$04FF
04FC: 11 A5 88    ld   de,$88A5
04FF: F1          pop  af
0500: C9          ret

; unreached?
0552: F5          push af
0553: 21 A2 88    ld   hl,$88A2
0556: A7          and  a
0557: 28 09       jr   z,$0562
0559: 21 A5 88    ld   hl,$88A5
055C: 3D          dec  a
055D: 28 03       jr   z,$0562
055F: 21 A8 88    ld   hl,$88A8
0562: 36 00       ld   (hl),$00
0564: 23          inc  hl
0565: 36 00       ld   (hl),$00
0567: 23          inc  hl
0568: 36 00       ld   (hl),$00
056A: F1          pop  af
056B: 21 A4 88    ld   hl,$88A4
056E: DD 21 81 87 ld   ix,$8781
0572: A7          and  a
0573: 28 11       jr   z,$0586
0575: 21 A7 88    ld   hl,$88A7
0578: DD 21 21 85 ld   ix,$8521
057C: 3D          dec  a
057D: 28 07       jr   z,$0586
057F: 21 AA 88    ld   hl,$88AA
0582: DD 21 41 86 ld   ix,$8641
0586: 11 E0 FF    ld   de,$FFE0
0589: 06 03       ld   b,$03
058B: 0E 04       ld   c,$04
058D: 7E          ld   a,(hl)
058E: 0F          rrca
058F: 0F          rrca
0590: 0F          rrca
0591: 0F          rrca
0592: CD 9D 05    call $059D
0595: 7E          ld   a,(hl)
0596: CD 9D 05    call $059D
0599: 2B          dec  hl
059A: 10 F1       djnz $058D
059C: C9          ret
059D: E6 0F       and  $0F
059F: 28 08       jr   z,$05A9
05A1: 0E 00       ld   c,$00
05A3: DD 77 00    ld   (ix+$00),a
05A6: DD 19       add  ix,de
05A8: C9          ret
05A9: 79          ld   a,c
05AA: A7          and  a
05AB: 28 F6       jr   z,$05A3
05AD: 3E 10       ld   a,$10
05AF: 0D          dec  c
05B0: 18 F1       jr   $05A3
05B2: 87          add  a,a
05B3: F5          push af
05B4: 21 0D 7A    ld   hl,$7A0D
05B7: E6 7F       and  $7F
05B9: 5F          ld   e,a
05BA: 16 00       ld   d,$00
05BC: 19          add  hl,de
05BD: F1          pop  af
05BE: 5E          ld   e,(hl)
05BF: 23          inc  hl
05C0: 56          ld   d,(hl)
05C1: EB          ex   de,hl
05C2: 5E          ld   e,(hl)
05C3: 23          inc  hl
05C4: 56          ld   d,(hl)
05C5: 23          inc  hl
05C6: EB          ex   de,hl
05C7: 01 E0 FF    ld   bc,$FFE0
05CA: 38 14       jr   c,$05E0
05CC: 1A          ld   a,(de)
05CD: FE 2E       cp   $2E
05CF: 28 0B       jr   z,$05DC
05D1: FE 3F       cp   $3F
05D3: C8          ret  z
05D4: D6 30       sub  $30
05D6: 77          ld   (hl),a
05D7: 13          inc  de
05D8: 09          add  hl,bc
05D9: 18 F1       jr   $05CC
05DB: 37          scf
05DC: EB          ex   de,hl
05DD: 23          inc  hl
05DE: 18 E2       jr   $05C2
05E0: 1A          ld   a,(de)
05E1: FE 2E       cp   $2E
05E3: 28 F6       jr   z,$05DB
05E5: FE 3F       cp   $3F
05E7: C8          ret  z
05E8: 36 10       ld   (hl),$10
05EA: 13          inc  de
05EB: 09          add  hl,bc
05EC: 18 F2       jr   $05E0
05EE: 3E 05       ld   a,$05
05F0: CD B2 05    call $05B2
05F3: 3A 02 88    ld   a,(nb_credits_8802)
05F6: FE 63       cp   $63
05F8: 38 02       jr   c,$05FC
05FA: 3E 63       ld   a,$63
05FC: CD 2A 06    call $062A
05FF: 47          ld   b,a
0600: E6 F0       and  $F0
0602: 28 07       jr   z,$060B
; display number of credits up to 99
0604: 0F          rrca
0605: 0F          rrca
0606: 0F          rrca
0607: 0F          rrca
0608: 32 BF 86    ld   (video_address_of_10_credit_86BF),a
060B: 78          ld   a,b
060C: E6 0F       and  $0F
060E: 32 9F 86    ld   (video_address_of_credit_unit_869F),a
0611: FE 02       cp   $02
0613: C0          ret  nz
0614: 11 C8 64    ld   de,$64C8
0617: 01 1F 00    ld   bc,$001F
061A: 1A          ld   a,(de)
061B: 1B          dec  de
061C: 80          add  a,b
061D: 47          ld   b,a
061E: 0D          dec  c
061F: 20 F9       jr   nz,$061A
0621: FE 8C       cp   $8C
0623: C8          ret  z
0624: 21 1E 45    ld   hl,$451E
0627: 29          add  hl,hl
0628: 34          inc  (hl)
0629: C9          ret

062A: 47          ld   b,a
062B: E6 0F       and  $0F
062D: C6 00       add  a,$00
062F: 27          daa
0630: 4F          ld   c,a
0631: 78          ld   a,b
0632: E6 F0       and  $F0
0634: 28 0B       jr   z,$0641
0636: 0F          rrca
0637: 0F          rrca
0638: 0F          rrca
0639: 0F          rrca
063A: 47          ld   b,a
063B: AF          xor  a
063C: C6 16       add  a,$16
063E: 27          daa
063F: 10 FB       djnz $063C
0641: 81          add  a,c
0642: 27          daa
0643: C9          ret
0644: DD 21 8A 77 ld   ix,$778A
0648: 16 00       ld   d,$00
064A: DD 7E 00    ld   a,(ix+$00)
064D: FE C8       cp   $C8
064F: 20 16       jr   nz,$0667
0651: DD 86 01    add  a,(ix+$01)
0654: 30 01       jr   nc,$0657
0656: 14          inc  d
0657: DD 86 02    add  a,(ix+$02)
065A: 30 01       jr   nc,$065D
065C: 14          inc  d
065D: DD 86 03    add  a,(ix+$03)
0660: 30 01       jr   nc,$0663
0662: 14          inc  d
0663: 92          sub  d
0664: FE 59       cp   $59
0666: C8          ret  z
0667: 3E 01       ld   a,$01
0669: 32 F8 8D    ld   ($8DF8),a
066C: C9          ret

irq_066D:
066D: F5          push af
066E: C5          push bc
066F: D5          push de
0670: E5          push hl
0671: 08          ex   af,af'
0672: D9          exx
0673: F5          push af
0674: C5          push bc
0675: D5          push de
0676: E5          push hl
0677: DD E5       push ix
0679: FD E5       push iy
067B: AF          xor  a
067C: 32 80 A1    ld   (mainlatch_a180),a
067F: 21 40 88    ld   hl,sprite_shadow_ram_8840
0682: DD 21 10 94 ld   ix,$9410
0686: 11 10 90    ld   de,$9010
0689: 06 04       ld   b,$04
068B: 3A 0A 88    ld   a,(in_game_sub_state_880A)
068E: FE 04       cp   $04
0690: 28 04       jr   z,$0696
0692: 06 18       ld   b,$18
0694: 18 18       jr   $06AE
0696: CD 14 07    call update_sprites_0714
0699: 21 7C 88    ld   hl,sprite_shadow_ram_8840+$3C
069C: 06 03       ld   b,$03
069E: CD 14 07    call update_sprites_0714
06A1: 21 50 88    ld   hl,sprite_shadow_ram_8840+$10
06A4: 06 0B       ld   b,$0B
06A6: CD 14 07    call update_sprites_0714
06A9: 21 88 88    ld   hl,sprite_shadow_ram_8840+$48
06AC: 06 06       ld   b,$06
06AE: CD 14 07    call update_sprites_0714
06B1: 32 00 A0    ld   (watchdog_a000),a
06B4: 3A 15 88    ld   a,($8815)
06B7: 32 16 88    ld   ($8816),a
06BA: 3A 13 88    ld   a,($8813)
06BD: 32 15 88    ld   ($8815),a
06C0: 2A 10 88    ld   hl,($8810)
06C3: 22 13 88    ld   ($8813),hl
06C6: 21 12 88    ld   hl,$8812
06C9: 3A C0 A0    ld   a,(in2_a0c0)
06CC: 2F          cpl
06CD: 77          ld   (hl),a
06CE: 2B          dec  hl
06CF: 3A A0 A0    ld   a,(in1_a0a0)
06D2: 2F          cpl
06D3: 77          ld   (hl),a
06D4: 2B          dec  hl
06D5: 3A 80 A0    ld   a,(in0_a080)
06D8: 2F          cpl
06D9: 77          ld   (hl),a
06DA: 21 3F 88    ld   hl,$883F
06DD: 35          dec  (hl)
06DE: 21 5F 8A    ld   hl,$8A5F
06E1: 35          dec  (hl)
06E2: CD E8 59    call $59E8
06E5: CD 64 0E    call $0E64
06E8: 21 FA 06    ld   hl,continue_06FA
06EB: E5          push hl
06EC: 3A 05 88    ld   a,(game_state_8805)
06EF: EF          rst  $28
jump_table_06FF:
	.word	$072D         
	.word	title_screens_0899         
	.word	push_start_screen_0C4E         
	.word	in_game_159B         
	.word	$0E53         

continue_06FA:
06FA: 3A 1F 88    ld   a,($881F)                                      
06FD: 32 87 A1    ld   ($A187),a
0700: FD E1       pop  iy
0702: DD E1       pop  ix
0704: E1          pop  hl
0705: D1          pop  de
0706: C1          pop  bc
0707: F1          pop  af
0708: D9          exx
0709: 08          ex   af,af'
070A: E1          pop  hl
070B: D1          pop  de
070C: C1          pop  bc
070D: 3E 01       ld   a,$01
070F: 32 80 A1    ld   (mainlatch_a180),a
0712: F1          pop  af
0713: C9          ret

; < HL: source
; < IX: sprite pointer $90xx
; < B: number of sprites to update
update_sprites_0714:
0714: 7E          ld   a,(hl)
0715: DD 77 01    ld   (ix+$01),a
0718: 2C          inc  l
0719: 7E          ld   a,(hl)
071A: DD 77 00    ld   (ix+$00),a
071D: 2C          inc  l
071E: 7E          ld   a,(hl)
071F: 12          ld   (de),a
0720: 13          inc  de
0721: 2C          inc  l
0722: 7E          ld   a,(hl)
0723: 12          ld   (de),a
0724: 13          inc  de
0725: 2C          inc  l
0726: DD 23       inc  ix
0728: DD 23       inc  ix
072A: 10 E8       djnz update_sprites_0714
072C: C9          ret

072D: 06 20       ld   b,$20
072F: CD CE 02    call $02CE
0732: C0          ret  nz
0733: 3A FF 8F    ld   a,($8FFF)
0736: FE 10       cp   $10
0738: C2 0F 02    jp   nz,$020F
073B: 21 06 88    ld   hl,$8806
073E: 36 00       ld   (hl),$00
0740: 2B          dec  hl
0741: 36 01       ld   (hl),$01
0743: AF          xor  a
0744: 32 0A 88    ld   (in_game_sub_state_880A),a
0747: 01 79 07    ld   bc,$0779
074A: CD 5D 07    call $075D
074D: 11 04 06    ld   de,$0604
0750: FF          rst  $38
0751: 11 00 05    ld   de,$0500
0754: FF          rst  $38
0755: 1E 02       ld   e,$02
0757: FF          rst  $38
0758: AF          xor  a
0759: 32 51 8E    ld   (title_sub_state_8E51),a
075C: C9          ret

075D: 21 40 80    ld   hl,$8040
0760: 11 20 00    ld   de,$0020
0763: 0A          ld   a,(bc)
0764: 77          ld   (hl),a
0765: 19          add  hl,de
0766: 7C          ld   a,h
0767: FE 84       cp   $84
0769: 38 F8       jr   c,$0763
076B: 26 80       ld   h,$80
076D: CB F5       set  6,l
076F: 03          inc  bc
0770: 2C          inc  l
0771: 7D          ld   a,l
0772: E6 1F       and  $1F
0774: FE 1F       cp   $1F
0776: 38 EB       jr   c,$0763
0778: C9          ret

title_screens_0899:
0899: 21 B5 0B    ld   hl,$0BB5                                       
089C: E5          push hl                                             
089D: 3A 51 8E    ld   a,(title_sub_state_8E51)                                      
08A0: EF          rst  $28                                            
	.word	init_title_screens_08B3  
	.word	title_display_play_08E9  
	.word	$092C  
	.word	$0986  
	.word	$099C  
	.word	$0AC8  
	.word	$0B32  
	.word	pigs_arrive_during_title_7442 
	.word	$76EA  

init_title_screens_08B3:
08B3: AF          xor  a                                              
08B4: 32 28 A0    ld   ($A028),a
08B7: 32 19 88    ld   ($8819),a
08BA: CD E3 02    call $02E3
08BD: 21 51 8E    ld   hl,title_sub_state_8E51
08C0: 34          inc  (hl)
08C1: 01 D5 64    ld   bc,$64D5
08C4: 2E 00       ld   l,$00
08C6: 65          ld   h,l
08C7: 0A          ld   a,(bc)
08C8: FE 96       cp   $96
08CA: 28 08       jr   z,$08D4
08CC: 84          add  a,h
08CD: 30 01       jr   nc,$08D0
08CF: 2C          inc  l
08D0: 67          ld   h,a
08D1: 0B          dec  bc
08D2: 18 F3       jr   $08C7
08D4: 95          sub  l
08D5: FE 8F       cp   $8F
08D7: 28 05       jr   z,$08DE
08D9: 3E 01       ld   a,$01
08DB: 32 FB 89    ld   ($89FB),a
08DE: AF          xor  a
08DF: 32 06 88    ld   ($8806),a
08E2: CD B9 02    call $02B9
08E5: CD 0D 1D    call $1D0D
08E8: C9          ret

title_display_play_08E9:
08E9: 06 1D       ld   b,$1D
08EB: CD CE 02    call $02CE
08EE: C0          ret  nz
08EF: CD E3 02    call $02E3
08F2: 21 59 08    ld   hl,$0859
08F5: 06 1F       ld   b,$1F
08F7: 7E          ld   a,(hl)
08F8: 23          inc  hl
08F9: 86          add  a,(hl)
08FA: 10 FC       djnz $08F8
08FC: FE 63       cp   $63
08FE: 20 F2       jr   nz,$08F2
0900: 01 59 08    ld   bc,$0859
0903: CD 5D 07    call $075D
0906: 21 31 08    ld   hl,$0831
0909: 06 08       ld   b,$08
090B: 7E          ld   a,(hl)
090C: 23          inc  hl
090D: 86          add  a,(hl)
090E: 10 FC       djnz $090C
0910: FE AA       cp   $AA
0912: 20 DE       jr   nz,$08F2
0914: CD 54 0E    call $0E54
0917: 11 11 06    ld   de,$0611
091A: FF          rst  $38
091B: 1E 0B       ld   e,$0B
091D: FF          rst  $38
091E: 21 51 8E    ld   hl,title_sub_state_8E51
* change state to 7
0921: 36 07       ld   (hl),$07
0923: C9          ret

0924: 58          ld   e,b
0925: 40          ld   b,b
0926: 38 06       jr   c,$092E
0928: 88          adc  a,b
0929: 40          ld   b,b
092A: 38 0B       jr   c,$0937

092C: 06 19       ld   b,$19
092E: CD CE 02    call $02CE
0931: C0          ret  nz
0932: CD E3 02    call $02E3
0935: 21 51 8E    ld   hl,title_sub_state_8E51
0938: 34          inc  (hl)
0939: CD B9 02    call $02B9
093C: 21 F5 07    ld   hl,$07F5
093F: 3E 11       ld   a,$11
0941: BE          cp   (hl)
0942: 20 FD       jr   nz,$0941
0944: DD 21 38 08 ld   ix,$0838
0948: 06 07       ld   b,$07
094A: 21 76 09    ld   hl,$0976
094D: 78          ld   a,b
094E: CD 45 0C    call $0C45
0951: 3E 1C       ld   a,$1C
0953: 83          add  a,e
0954: 5F          ld   e,a
0955: 30 01       jr   nc,$0958
0957: 14          inc  d
0958: 1A          ld   a,(de)
0959: 4F          ld   c,a
095A: DD 7E 00    ld   a,(ix+$00)
095D: B9          cp   c
095E: 20 16       jr   nz,$0976
0960: DD 2B       dec  ix
0962: 10 E6       djnz $094A
0964: 01 D9 07    ld   bc,$07D9
0967: CD 5D 07    call $075D
096A: 11 8B 06    ld   de,$068B
096D: FF          rst  $38
096E: 1E 8E       ld   e,$8E
0970: FF          rst  $38
0971: 11 00 02    ld   de,$0200
0974: FF          rst  $38
0975: C9          ret
0976: 79          ld   a,c
0977: 07          rlca
0978: 99          sbc  a,c
0979: 07          rlca
097A: B9          cp   c
097B: 07          rlca
097C: D9          exx
097D: 07          rlca
097E: F9          ld   sp,hl
097F: 07          rlca
0980: 19          add  hl,de
0981: 08          ex   af,af'
0982: 39          add  hl,sp
0983: 08          ex   af,af'
0984: 59          ld   e,c
0985: 08          ex   af,af'
0986: 21 50 8E    ld   hl,$8E50
0989: 35          dec  (hl)
098A: C0          ret  nz
098B: CD B9 02    call $02B9
098E: CD E3 02    call $02E3
0991: 21 51 8E    ld   hl,title_sub_state_8E51
0994: 34          inc  (hl)
0995: 21 26 0B    ld   hl,$0B26
0998: 22 48 8F    ld   ($8F48),hl
099B: C9          ret
099C: 06 19       ld   b,$19
099E: CD CE 02    call $02CE
09A1: C0          ret  nz
09A2: 16 0D       ld   d,$0D
09A4: 21 65 0A    ld   hl,$0A65
09A7: 01 C9 07    ld   bc,$07C9
09AA: 0A          ld   a,(bc)
09AB: 96          sub  (hl)
09AC: 20 FC       jr   nz,$09AA
09AE: 03          inc  bc
09AF: 23          inc  hl
09B0: 15          dec  d
09B1: 20 F7       jr   nz,$09AA
09B3: 01 B9 07    ld   bc,$07B9
09B6: CD 5D 07    call $075D
09B9: 11 0D 06    ld   de,$060D
09BC: FF          rst  $38
09BD: 21 70 8B    ld   hl,$8B70
09C0: AF          xor  a
09C1: 47          ld   b,a
09C2: D7          rst  $10
09C3: 21 76 0A    ld   hl,$0A76
09C6: 11 7E 0A    ld   de,$0A7E
09C9: DD 21 70 8B ld   ix,$8B70
09CD: CD 0C 0A    call $0A0C
09D0: 01 18 00    ld   bc,$0018
09D3: DD 09       add  ix,bc
09D5: 1A          ld   a,(de)
09D6: 3C          inc  a
09D7: 20 F4       jr   nz,$09CD
09D9: CD 52 0A    call $0A52
09DC: CD 25 0A    call $0A25
09DF: 21 87 0A    ld   hl,$0A87
09E2: 22 54 8E    ld   ($8E54),hl
09E5: 21 48 86    ld   hl,$8648
09E8: 22 56 8E    ld   ($8E56),hl
09EB: 21 50 8E    ld   hl,$8E50
09EE: 36 32       ld   (hl),$32
09F0: 2C          inc  l
09F1: 34          inc  (hl)
09F2: 2C          inc  l
09F3: 36 0D       ld   (hl),$0D
09F5: 2C          inc  l
09F6: 36 05       ld   (hl),$05
09F8: DD 21 70 8B ld   ix,$8B70
09FC: 06 04       ld   b,$04
09FE: 11 18 00    ld   de,$0018
0A01: CD 06 40    call $4006
0A04: DD 19       add  ix,de
0A06: 10 F9       djnz $0A01
0A08: CD EF 02    call update_sprite_shadows_02EF
0A0B: C9          ret
0A0C: 1A          ld   a,(de)
0A0D: DD 77 06    ld   (ix+$06),a
0A10: 13          inc  de
0A11: 1A          ld   a,(de)
0A12: 13          inc  de
0A13: DD 77 04    ld   (ix+$04),a
0A16: 7E          ld   a,(hl)
0A17: DD 77 0C    ld   (ix+$0c),a
0A1A: 23          inc  hl
0A1B: 7E          ld   a,(hl)
0A1C: DD 77 0D    ld   (ix+$0d),a
0A1F: DD 36 0E 00 ld   (ix+$0e),$00
0A23: 23          inc  hl
0A24: C9          ret
0A25: 21 41 8D    ld   hl,$8D41
0A28: 36 0A       ld   (hl),$0A
0A2A: 2D          dec  l
0A2B: 7E          ld   a,(hl)
0A2C: 34          inc  (hl)
0A2D: E6 03       and  $03
0A2F: 21 F6 26    ld   hl,$26F6
0A32: CD 45 0C    call $0C45
0A35: D5          push de
0A36: 21 6A 86    ld   hl,$866A
0A39: CD 40 0A    call $0A40
0A3C: D1          pop  de
0A3D: 21 AA 86    ld   hl,$86AA
0A40: 01 20 00    ld   bc,$0020
0A43: 1A          ld   a,(de)
0A44: 77          ld   (hl),a
0A45: 2C          inc  l
0A46: 13          inc  de
0A47: 1A          ld   a,(de)
0A48: 77          ld   (hl),a
0A49: 09          add  hl,bc
0A4A: 13          inc  de
0A4B: 1A          ld   a,(de)
0A4C: 77          ld   (hl),a
0A4D: 2D          dec  l
0A4E: 13          inc  de
0A4F: 1A          ld   a,(de)
0A50: 77          ld   (hl),a
0A51: C9          ret
0A52: 21 AA 82    ld   hl,$82AA
0A55: 11 72 0A    ld   de,$0A72
0A58: CD 40 0A    call $0A40
0A5B: 21 6A 82    ld   hl,$826A
0A5E: 11 72 0A    ld   de,$0A72
0A61: CD 40 0A    call $0A40
0A64: C9          ret

0AC9: 41          ld   b,c
0ACA: 8D          adc  a,l
0ACB: 35          dec  (hl)
0ACC: 20 03       jr   nz,$0AD1
0ACE: CD 28 0A    call $0A28
0AD1: CD F8 09    call $09F8
0AD4: 21 50 8E    ld   hl,$8E50
0AD7: 35          dec  (hl)
0AD8: C0          ret  nz
0AD9: 36 02       ld   (hl),$02
0ADB: 2A 54 8E    ld   hl,($8E54)
0ADE: 7E          ld   a,(hl)
0ADF: 23          inc  hl
0AE0: 22 54 8E    ld   ($8E54),hl
0AE3: 2A 56 8E    ld   hl,($8E56)
0AE6: 77          ld   (hl),a	; write name of character to screen
0AE7: 11 E0 FF    ld   de,$FFE0	; next char
0AEA: 19          add  hl,de
0AEB: 22 56 8E    ld   ($8E56),hl
0AEE: 21 52 8E    ld   hl,$8E52
0AF1: 35          dec  (hl)
0AF2: C0          ret  nz
0AF3: 36 0D       ld   (hl),$0D
0AF5: 21 50 8E    ld   hl,$8E50
0AF8: 36 14       ld   (hl),$14
0AFA: 2C          inc  l
0AFB: 34          inc  (hl)
0AFC: 2A 56 8E    ld   hl,($8E56)
0AFF: 11 00 00    ld   de,$0000
0B02: 06 0E       ld   b,$0E
0B04: 7E          ld   a,(hl)
0B05: 83          add  a,e
0B06: 5F          ld   e,a
0B07: 30 01       jr   nc,$0B0A
0B09: 14          inc  d
0B0A: 3E 20       ld   a,$20
0B0C: 85          add  a,l
0B0D: 6F          ld   l,a
0B0E: 30 01       jr   nc,$0B11
0B10: 24          inc  h
0B11: 10 F1       djnz $0B04
0B13: 2A 48 8F    ld   hl,($8F48)
0B16: 7E          ld   a,(hl)
0B17: BB          cp   e
0B18: C2 42 74    jp   nz,pigs_arrive_during_title_7442
0B1B: 23          inc  hl
0B1C: 7E          ld   a,(hl)
0B1D: BA          cp   d
0B1E: C2 EA 76    jp   nz,$76EA
0B21: 23          inc  hl
0B22: 22 48 8F    ld   ($8F48),hl
0B25: C9          ret
0B26: C6 01       add  a,$01
0B28: C4 01 8C    call nz,$8C01
0B2B: 01 A8 01    ld   bc,$01A8
0B2E: A7          and  a
0B2F: 01 BC 1C    ld   bc,$1CBC
0B32: 21 BC 82    ld   hl,$82BC
0B35: 11 E0 FF    ld   de,$FFE0
0B38: 06 0A       ld   b,$0A
0B3A: 7E          ld   a,(hl)
0B3B: 19          add  hl,de
0B3C: BE          cp   (hl)
0B3D: C2 B3 08    jp   nz,$08B3
0B40: 10 F8       djnz $0B3A
0B42: 21 41 8D    ld   hl,$8D41
0B45: 35          dec  (hl)
0B46: 20 03       jr   nz,$0B4B
0B48: CD 28 0A    call $0A28
0B4B: CD F8 09    call $09F8
0B4E: 21 50 8E    ld   hl,$8E50
0B51: 35          dec  (hl)
0B52: C0          ret  nz
0B53: 36 01       ld   (hl),$01
0B55: 2C          inc  l
0B56: 35          dec  (hl)
0B57: 3A 53 8E    ld   a,($8E53)
0B5A: 3D          dec  a
0B5B: 21 AB 0B    ld   hl,$0BAB
0B5E: CD 45 0C    call $0C45
0B61: ED 53 56 8E ld   ($8E56),de
0B65: 21 53 8E    ld   hl,$8E53
0B68: 35          dec  (hl)
0B69: C0          ret  nz
0B6A: 21 50 8E    ld   hl,$8E50
0B6D: 36 96       ld   (hl),$96
0B6F: 2C          inc  l
0B70: AF          xor  a
0B71: 77          ld   (hl),a
0B72: 21 62 84    ld   hl,$8462
0B75: 57          ld   d,a
0B76: 5F          ld   e,a
0B77: 0E 0E       ld   c,$0E
0B79: 06 1D       ld   b,$1D
0B7B: 7B          ld   a,e
0B7C: 86          add  a,(hl)
0B7D: 30 01       jr   nc,$0B80
0B7F: 14          inc  d
0B80: 5F          ld   e,a
0B81: 23          inc  hl
0B82: 10 F7       djnz $0B7B
0B84: 7D          ld   a,l
0B85: C6 03       add  a,$03
0B87: 6F          ld   l,a
0B88: 30 01       jr   nc,$0B8B
0B8A: 24          inc  h
0B8B: 0D          dec  c
0B8C: 20 EB       jr   nz,$0B79
0B8E: 2A 48 8F    ld   hl,($8F48)
0B91: 7B          ld   a,e
0B92: BE          cp   (hl)
0B93: C2 B3 08    jp   nz,$08B3
0B96: 23          inc  hl
0B97: 7E          ld   a,(hl)
0B98: BA          cp   d
0B99: C2 E9 08    jp   nz,$08E9
0B9C: AF          xor  a
0B9D: 32 48 8F    ld   ($8F48),a
0BA0: 32 49 8F    ld   ($8F49),a
0BA3: 3E 03       ld   a,$03
0BA5: 32 05 88    ld   (game_state_8805),a
0BA8: C3 00 0E    jp   init_play_0E00
0BAB: 59          ld   e,c
0BAC: 86          add  a,(hl)
0BAD: 56          ld   d,(hl)
0BAE: 86          add  a,(hl)
0BAF: 53          ld   d,e
0BB0: 86          add  a,(hl)
0BB1: 4E          ld   c,(hl)
0BB2: 86          add  a,(hl)
0BB3: 4B          ld   c,e
0BB4: 86          add  a,(hl)
0BB5: 3A 06 88    ld   a,($8806)
0BB8: A7          and  a
0BB9: 20 41       jr   nz,$0BFC
0BBB: 3A 05 88    ld   a,(game_state_8805)
0BBE: 3D          dec  a
0BBF: 20 3B       jr   nz,$0BFC
0BC1: 3A 51 8E    ld   a,(title_sub_state_8E51)
0BC4: FE 03       cp   $03
0BC6: 28 08       jr   z,$0BD0
0BC8: FE 05       cp   $05
0BCA: 28 04       jr   z,$0BD0
0BCC: FE 08       cp   $08
0BCE: 20 2C       jr   nz,$0BFC
0BD0: 11 E0 FF    ld   de,$FFE0
0BD3: 21 FE 8E    ld   hl,$8EFE
0BD6: 34          inc  (hl)
0BD7: 21 BC 86    ld   hl,$86BC
0BDA: 01 C2 20    ld   bc,$20C2
0BDD: 0A          ld   a,(bc)
0BDE: 96          sub  (hl)
0BDF: 20 16       jr   nz,$0BF7
0BE1: 19          add  hl,de
0BE2: 03          inc  bc
0BE3: 0A          ld   a,(bc)
0BE4: 3C          inc  a
0BE5: 20 F6       jr   nz,$0BDD
0BE7: 11 C0 FB    ld   de,$FBC0
0BEA: 19          add  hl,de
0BEB: EB          ex   de,hl
0BEC: 21 CB 20    ld   hl,$20CB
0BEF: 3A 51 8E    ld   a,(title_sub_state_8E51)
0BF2: E7          rst  $20
0BF3: EB          ex   de,hl
0BF4: BE          cp   (hl)
0BF5: 28 05       jr   z,$0BFC
0BF7: 3E 01       ld   a,$01
0BF9: 32 E5 89    ld   ($89E5),a
0BFC: 3A 2C 88    ld   a,($882C)
0BFF: FE 0F       cp   $0F
0C01: 20 19       jr   nz,$0C1C
0C03: 3A 10 88    ld   a,($8810)
0C06: CB 5F       bit  3,a
0C08: 28 09       jr   z,$0C13
0C0A: CD CF 0E    call $0ECF
0C0D: 21 00 00    ld   hl,$0000
0C10: C3 AB 0D    jp   $0DAB
0C13: CB 67       bit  4,a
0C15: C8          ret  z
0C16: CD CF 0E    call $0ECF
0C19: C3 A8 0D    jp   $0DA8
0C1C: 3A 02 88    ld   a,(nb_credits_8802)
0C1F: A7          and  a
0C20: C8          ret  z
0C21: 21 05 88    ld   hl,game_state_8805
0C24: 34          inc  (hl)
0C25: AF          xor  a
0C26: 32 0A 88    ld   (in_game_sub_state_880A),a
0C29: C9          ret
0C2A: 3A 80 A0    ld   a,(in0_a080)
0C2D: CB 5F       bit  3,a
0C2F: C0          ret  nz
0C30: 3E 09       ld   a,$09
0C32: 32 51 8E    ld   (title_sub_state_8E51),a
0C35: 21 00 84    ld   hl,$8400
0C38: 1E 10       ld   e,$10
0C3A: 01 FF 03    ld   bc,$03FF
0C3D: 73          ld   (hl),e
0C3E: 23          inc  hl
0C3F: 0B          dec  bc
0C40: 78          ld   a,b
0C41: B1          or   c
0C42: 20 F9       jr   nz,$0C3D
0C44: C9          ret
0C45: 87          add  a,a
0C46: 16 00       ld   d,$00
0C48: 5F          ld   e,a
0C49: 19          add  hl,de
0C4A: 5E          ld   e,(hl)
0C4B: 23          inc  hl
0C4C: 56          ld   d,(hl)
0C4D: C9          ret

push_start_screen_0C4E:
0C4E: 21 78 0D    ld   hl,$0D78
0C51: E5          push hl
0C52: 3A 0A 88    ld   a,(in_game_sub_state_880A)
0C55: EF          rst  $28
jump_table_0C56:
	.word	$0C5C
	.word	$0C77
	.word	$0D61

0C5C: AF          xor  a
0C5D: 32 19 88    ld   ($8819),a
0C60: 32 28 A0    ld   ($A028),a
0C63: 32 06 88    ld   ($8806),a
0C66: 21 42 84    ld   hl,$8442
0C69: 22 0B 88    ld   ($880B),hl
0C6C: 21 09 88    ld   hl,$8809
0C6F: 36 0F       ld   (hl),$0F
0C71: 23          inc  hl
0C72: 34          inc  (hl)
0C73: CD B9 02    call $02B9
0C76: C9          ret

0C77: 2A 0B 88    ld   hl,($880B)
0C7A: 06 1D       ld   b,$1D
0C7C: 3E 10       ld   a,$10
0C7E: D7          rst  $10
0C7F: 11 03 00    ld   de,$0003
0C82: 19          add  hl,de
0C83: 06 1D       ld   b,$1D
0C85: D7          rst  $10
0C86: 19          add  hl,de
0C87: 22 0B 88    ld   ($880B),hl
0C8A: 21 09 88    ld   hl,$8809
0C8D: 35          dec  (hl)
0C8E: C0          ret  nz
0C8F: 2C          inc  l
0C90: 34          inc  (hl)
0C91: 21 79 07    ld   hl,$0779
0C94: 01 00 00    ld   bc,$0000
0C97: 7E          ld   a,(hl)
0C98: 23          inc  hl
0C99: 86          add  a,(hl)
0C9A: 30 01       jr   nc,$0C9D
0C9C: 0C          inc  c
0C9D: 10 F9       djnz $0C98
0C9F: FE C1       cp   $C1
0CA1: 20 F5       jr   nz,$0C98
0CA3: 79          ld   a,c
0CA4: FE 0C       cp   $0C
0CA6: 20 F0       jr   nz,$0C98
0CA8: 01 79 07    ld   bc,$0779
0CAB: CD 5D 07    call $075D
0CAE: 32 0D 88    ld   ($880D),a
0CB1: CD 54 0E    call $0E54
0CB4: CD F8 0C    call $0CF8
0CB7: 11 01 06    ld   de,$0601
0CBA: FF          rst  $38
0CBB: 1E 11       ld   e,$11
0CBD: FF          rst  $38
0CBE: 1E 16       ld   e,$16
0CC0: FF          rst  $38
0CC1: 1C          inc  e
0CC2: 3A 00 88    ld   a,($8800)
0CC5: E6 01       and  $01
0CC7: 28 02       jr   z,$0CCB
0CC9: 1E 28       ld   e,$28
0CCB: FF          rst  $38
0CCC: 1E 2A       ld   e,$2A
0CCE: 3A 00 88    ld   a,($8800)
0CD1: E6 01       and  $01
0CD3: 28 01       jr   z,$0CD6
0CD5: 1D          dec  e
0CD6: FF          rst  $38
0CD7: CD 4E 0F    call $0F4E
0CDA: 21 26 0B    ld   hl,$0B26
0CDD: 11 00 00    ld   de,$0000
0CE0: 06 20       ld   b,$20
0CE2: 7E          ld   a,(hl)
0CE3: 83          add  a,e
0CE4: 5F          ld   e,a
0CE5: 30 01       jr   nc,$0CE8
0CE7: 14          inc  d
0CE8: 23          inc  hl
0CE9: 10 F7       djnz $0CE2
0CEB: 7B          ld   a,e
0CEC: FE D3       cp   $D3
; looks like code was patched
0CEE: 00          nop
0CEF: 00          nop
0CF0: 00          nop
0CF1: 3E 0B       ld   a,$0B
0CF3: BA          cp   d
0CF4: 00          nop
0CF5: 00          nop
0CF6: 00          nop
0CF7: C9          ret

0CF8: 21 2F 0D    ld   hl,$0D2F
0CFB: DD 21 A7 86 ld   ix,$86A7
0CFF: 11 E0 FF    ld   de,$FFE0
0D02: 06 0C       ld   b,$0C
0D04: 7E          ld   a,(hl)
0D05: DD 77 00    ld   (ix+$00),a
0D08: 23          inc  hl
0D09: DD 19       add  ix,de
0D0B: 10 F7       djnz $0D04
0D0D: 7E          ld   a,(hl)
0D0E: FE FF       cp   $FF
0D10: 28 0F       jr   z,$0D21
0D12: FE EE       cp   $EE
0D14: C8          ret  z
0D15: 11 81 01    ld   de,$0181
0D18: DD 19       add  ix,de
0D1A: 11 E0 FF    ld   de,$FFE0
0D1D: 06 0C       ld   b,$0C
0D1F: 18 E3       jr   $0D04
0D21: 21 48 0D    ld   hl,$0D48
0D24: DD 21 A7 82 ld   ix,$82A7
0D28: 11 E0 FF    ld   de,$FFE0
0D2B: 06 0C       ld   b,$0C
0D2D: 18 D5       jr   $0D04

0D61: 3A 02 88    ld   a,($8802)                                      
0D64: A7          and  a
0D65: C8          ret  z
0D66: 3D          dec  a
0D67: 11 18 06    ld   de,$0618
0D6A: 28 01       jr   z,$0D6D
0D6C: 1C          inc  e
0D6D: FF          rst  $38
0D6E: 11 00 03    ld   de,$0300
0D71: FF          rst  $38
0D72: 3E 02       ld   a,$02
0D74: 32 05 88    ld   (game_state_8805),a
0D77: C9          ret
0D78: 3A 10 88    ld   a,($8810)
0D7B: CB 5F       bit  3,a
0D7D: C2 E4 0D    jp   nz,$0DE4
0D80: CB 67       bit  4,a
0D82: C8          ret  z
0D83: 3A 02 88    ld   a,(nb_credits_8802)
0D86: FE 02       cp   $02
0D88: D8          ret  c
0D89: D6 02       sub  $02
0D8B: 32 02 88    ld   (nb_credits_8802),a
0D8E: 21 6B 77    ld   hl,$776B
0D91: 06 14       ld   b,$14
0D93: 58          ld   e,b
0D94: 53          ld   d,e
0D95: 7E          ld   a,(hl)
0D96: 83          add  a,e
0D97: 5F          ld   e,a
0D98: 30 01       jr   nc,$0D9B
0D9A: 14          inc  d
0D9B: 23          inc  hl
0D9C: 10 F7       djnz $0D95
0D9E: 7B          ld   a,e
0D9F: 82          add  a,d
0DA0: E6 AB       and  $AB
0DA2: 28 04       jr   z,$0DA8
0DA4: 21 EA 89    ld   hl,$89EA
0DA7: 34          inc  (hl)
0DA8: 21 00 01    ld   hl,$0100
0DAB: 22 0D 88    ld   ($880D),hl
0DAE: CD 54 0E    call $0E54
0DB1: AF          xor  a
0DB2: 32 0A 88    ld   (in_game_sub_state_880A),a
0DB5: 3E 03       ld   a,$03
0DB7: 32 05 88    ld   (game_state_8805),a
0DBA: 3E 01       ld   a,$01
0DBC: 32 06 88    ld   ($8806),a
0DBF: 32 1F 88    ld   ($881F),a
0DC2: 11 04 06    ld   de,$0604
0DC5: FF          rst  $38
0DC6: CD 00 0E    call init_play_0E00
0DC9: 21 21 8D    ld   hl,$8D21
0DCC: 36 00       ld   (hl),$00
0DCE: 2C          inc  l
0DCF: 36 20       ld   (hl),$20
0DD1: 11 00 04    ld   de,$0400
0DD4: FF          rst  $38
0DD5: 3A 0E 88    ld   a,($880E)
0DD8: 0F          rrca
0DD9: D0          ret  nc
0DDA: 1C          inc  e
0DDB: FF          rst  $38
0DDC: AF          xor  a
0DDD: 21 1F 8E    ld   hl,$8E1F
0DE0: 06 0C       ld   b,$0C
0DE2: D7          rst  $10
0DE3: C9          ret
0DE4: 3A 02 88    ld   a,(nb_credits_8802)
0DE7: A7          and  a
0DE8: 28 0A       jr   z,$0DF4
0DEA: 3D          dec  a
0DEB: 32 02 88    ld   (nb_credits_8802),a
0DEE: 21 00 00    ld   hl,$0000
0DF1: C3 AB 0D    jp   $0DAB
0DF4: 3A 0A 88    ld   a,(in_game_sub_state_880A)
0DF7: FE 0E       cp   $0E
0DF9: C8          ret  z
0DFA: 3E 01       ld   a,$01
0DFC: 32 05 88    ld   (game_state_8805),a
0DFF: C9          ret

init_play_0E00:
0E00: 21 00 89    ld   hl,current_play_variables_8900
0E03: AF          xor  a
0E04: 32 0A 88    ld   (in_game_sub_state_880A),a
0E07: 32 E1 89    ld   ($89E1),a
0E0A: 32 E2 89    ld   ($89E2),a
0E0D: 32 E3 89    ld   ($89E3),a
0E10: 32 5B 8F    ld   ($8F5B),a
; clear block 8900-BF
0E13: 06 BF       ld   b,$BF
0E15: D7          rst  $10
0E16: 3A 07 88    ld   a,($8807)
0E19: 32 48 89    ld   ($8948),a
0E1C: 32 88 89    ld   ($8988),a
0E1F: 3E 20       ld   a,$20
0E21: 32 41 89    ld   ($8941),a
0E24: 32 81 89    ld   ($8981),a
0E27: 3A 20 88    ld   a,($8820)
0E2A: 32 40 89    ld   ($8940),a
0E2D: 32 80 89    ld   ($8980),a
0E30: CD E3 02    call $02E3
0E33: 3A 06 88    ld   a,($8806)
0E36: A7          and  a
0E37: C8          ret  z
0E38: AF          xor  a
0E39: 32 3F 8F    ld   ($8F3F),a
0E3C: 32 30 8F    ld   ($8F30),a
0E3F: 32 0E 8F    ld   ($8F0E),a
0E42: 32 0F 8F    ld   (meat_speed_8F0F),a
0E45: C9          ret
0E46: 11 04 00    ld   de,$0004
0E49: 06 06       ld   b,$06
0E4B: 3E FB       ld   a,$FB
0E4D: A6          and  (hl)
0E4E: 77          ld   (hl),a
0E4F: 19          add  hl,de
0E50: 10 F9       djnz $0E4B
0E52: C9          ret

0E53: C9          ret
0E54: 11 01 07    ld   de,$0701
0E57: FF          rst  $38
0E58: 3A 2C 88    ld   a,($882C)
0E5B: FE 0F       cp   $0F
0E5D: 20 04       jr   nz,$0E63
0E5F: 11 06 06    ld   de,$0606
0E62: FF          rst  $38
0E63: C9          ret
0E64: 11 41 8A    ld   de,$8A41
0E67: 1A          ld   a,(de)
0E68: 6F          ld   l,a
0E69: 26 8A       ld   h,$8A
0E6B: 7E          ld   a,(hl)
0E6C: FE FF       cp   $FF
0E6E: C8          ret  z
0E6F: 47          ld   b,a
0E70: 3A 21 88    ld   a,($8821)
0E73: E6 01       and  $01
0E75: 20 06       jr   nz,$0E7D
0E77: 3A 06 88    ld   a,($8806)
0E7A: A7          and  a
0E7B: 28 04       jr   z,$0E81
0E7D: 78          ld   a,b
0E7E: CD 8F 0E    call audio_shit_0E8F
0E81: 36 FF       ld   (hl),$FF
0E83: 7D          ld   a,l
0E84: FE 5E       cp   $5E
0E86: 28 03       jr   z,$0E8B
0E88: 3C          inc  a
0E89: 12          ld   (de),a
0E8A: C9          ret
0E8B: 3E 43       ld   a,$43
0E8D: 12          ld   (de),a
0E8E: C9          ret

audio_shit_0E8F:
0E8F: 32 00 A1    ld   (audio_a100),a
0E92: 3E 01       ld   a,$01
0E94: 32 81 A1    ld   ($A181),a
; cpu-dependent timer
0E97: 00          nop
0E98: 00          nop
0E99: 00          nop
0E9A: 00          nop
0E9B: 00          nop
0E9C: 00          nop
0E9D: 3D          dec  a
0E9E: 32 81 A1    ld   ($A181),a
0EA1: C9          ret

0EA2: 32 20 8D    ld   ($8D20),a
0EA5: 3A 06 88    ld   a,($8806)
0EA8: A7          and  a
0EA9: 20 05       jr   nz,$0EB0
0EAB: 3A 50 8F    ld   a,($8F50)
0EAE: A7          and  a
0EAF: C8          ret  z
0EB0: 3A 20 8D    ld   a,($8D20)
0EB3: C5          push bc
0EB4: D5          push de
0EB5: E5          push hl
0EB6: 47          ld   b,a
0EB7: 11 40 8A    ld   de,$8A40
0EBA: 1A          ld   a,(de)
0EBB: 6F          ld   l,a
0EBC: 26 8A       ld   h,$8A
0EBE: 70          ld   (hl),b
0EBF: 7D          ld   a,l
0EC0: FE 5E       cp   $5E
0EC2: 28 04       jr   z,$0EC8
0EC4: 3C          inc  a
0EC5: 12          ld   (de),a
0EC6: 18 03       jr   $0ECB
0EC8: 3E 43       ld   a,$43
0ECA: 12          ld   (de),a
0ECB: E1          pop  hl
0ECC: D1          pop  de
0ECD: C1          pop  bc
0ECE: C9          ret
0ECF: AF          xor  a
0ED0: 18 E1       jr   $0EB3
0ED2: 3E 01       ld   a,$01
0ED4: 18 CC       jr   $0EA2
0ED6: 3E 02       ld   a,$02
0ED8: 18 D9       jr   $0EB3
0EDA: 3E 82       ld   a,$82
0EDC: CD B3 0E    call $0EB3
0EDF: 3E 03       ld   a,$03
0EE1: 18 D0       jr   $0EB3
0EE3: 3A 24 8F    ld   a,($8F24)
0EE6: A7          and  a
0EE7: C0          ret  nz
0EE8: 3A 32 8D    ld   a,($8D32)
0EEB: A7          and  a
0EEC: C0          ret  nz
0EED: 3E 04       ld   a,$04
0EEF: 18 B1       jr   $0EA2
0EF1: 3E 05       ld   a,$05
0EF3: 18 BE       jr   $0EB3
0EF5: 3E 06       ld   a,$06
0EF7: 18 A9       jr   $0EA2
0EF9: 3E 07       ld   a,$07
0EFB: 18 A5       jr   $0EA2
0EFD: 3E 08       ld   a,$08
0EFF: 18 A1       jr   $0EA2
0F01: 3E 09       ld   a,$09
0F03: 18 AE       jr   $0EB3
0F05: 3E 0A       ld   a,$0A
0F07: 18 99       jr   $0EA2
0F09: 3E 0B       ld   a,$0B
0F0B: 18 82       jr   audio_shit_0E8F
0F0D: 3E 0B       ld   a,$0B
0F0F: 18 91       jr   $0EA2
0F11: 3E 0C       ld   a,$0C
0F13: 18 8D       jr   $0EA2
0F15: 3E 0D       ld   a,$0D
0F17: 18 89       jr   $0EA2
0F19: 3E 0E       ld   a,$0E
0F1B: 18 85       jr   $0EA2
0F1D: 3E 0F       ld   a,$0F
0F1F: 18 81       jr   $0EA2
0F21: 3E 95       ld   a,$95
0F23: CD A2 0E    call $0EA2
0F26: 3E 10       ld   a,$10
0F28: C3 A2 0E    jp   $0EA2
0F2B: 3E 11       ld   a,$11
0F2D: C3 A2 0E    jp   $0EA2
0F30: 3E 95       ld   a,$95
0F32: CD A2 0E    call $0EA2
0F35: 3E 03       ld   a,$03
0F37: CD A2 0E    call $0EA2
0F3A: 3E 11       ld   a,$11
0F3C: C3 A2 0E    jp   $0EA2
0F3F: 3E 12       ld   a,$12
0F41: C3 A2 0E    jp   $0EA2
0F44: 3E 13       ld   a,$13
0F46: C3 A2 0E    jp   $0EA2
0F49: 3E 14       ld   a,$14
0F4B: C3 A2 0E    jp   $0EA2
0F4E: 3E 82       ld   a,$82
0F50: CD B3 0E    call $0EB3
0F53: 3E 95       ld   a,$95
0F55: C3 B3 0E    jp   $0EB3
0F58: 3E 96       ld   a,$96
0F5A: CD A2 0E    call $0EA2
0F5D: 3E 97       ld   a,$97
0F5F: CD A2 0E    call $0EA2
0F62: 3E 18       ld   a,$18
0F64: CD B3 0E    call $0EB3
0F67: 3E 15       ld   a,$15
0F69: C3 B3 0E    jp   $0EB3
0F6C: 3E 19       ld   a,$19
0F6E: CD B3 0E    call $0EB3
0F71: 3E 15       ld   a,$15
0F73: C3 B3 0E    jp   $0EB3
0F76: 3A 68 8D    ld   a,($8D68)
0F79: B7          or   a
0F7A: C0          ret  nz
0F7B: 3A 07 89    ld   a,($8907)
0F7E: E6 01       and  $01
0F80: C6 1A       add  a,$1A
0F82: CD A2 0E    call $0EA2
0F85: C3 C3 0F    jp   $0FC3
0F88: 3E 82       ld   a,$82
0F8A: CD A2 0E    call $0EA2
0F8D: 3E 1C       ld   a,$1C
0F8F: C3 C3 0F    jp   $0FC3
0F92: 3E 1D       ld   a,$1D
0F94: C3 C3 0F    jp   $0FC3
0F97: 3A 07 89    ld   a,($8907)
0F9A: 0F          rrca
0F9B: E6 03       and  $03
0F9D: C6 1E       add  a,$1E
0F9F: C3 C3 0F    jp   $0FC3
0FA2: 3A 07 89    ld   a,($8907)
0FA5: 0F          rrca
0FA6: E6 03       and  $03
0FA8: C6 22       add  a,$22
0FAA: C3 C3 0F    jp   $0FC3
0FAD: 3E 26       ld   a,$26
0FAF: C3 C3 0F    jp   $0FC3
0FB2: 3E 27       ld   a,$27
0FB4: CD B3 0E    call $0EB3
0FB7: 3E 15       ld   a,$15
0FB9: C3 B3 0E    jp   $0EB3
0FBC: 3E 28       ld   a,$28
0FBE: C3 C3 0F    jp   $0FC3
0FC1: 3E 29       ld   a,$29
0FC3: CD A2 0E    call $0EA2
0FC6: 3E 15       ld   a,$15
0FC8: CD A2 0E    call $0EA2
0FCB: 3E 16       ld   a,$16
0FCD: CD A2 0E    call $0EA2
0FD0: 3E 17       ld   a,$17
0FD2: C3 A2 0E    jp   $0EA2
0FD5: 3A 5C 8F    ld   a,($8F5C)
0FD8: E6 07       and  $07
0FDA: FE 02       cp   $02
0FDC: 38 04       jr   c,$0FE2
0FDE: 21 35 10    ld   hl,$1035
0FE1: E5          push hl
0FE2: EF          rst  $28
	.word	$0FEF
	.word	$1016  
	.word	$1090  
	.word	$10A2  
	.word	$113C  
	.word	$114F  

0FEF: 0F3E        ld   a,$0F
0FF1: 21 01 89    ld   hl,nb_wolves_8901
0FF4: 77          ld   (hl),a
0FF5: 2E 07       ld   l,$07
0FF7: CB 56       bit  2,(hl)
0FF9: 28 03       jr   z,$0FFE
0FFB: CD F1 50    call $50F1
0FFE: 3E 01       ld   a,$01
1000: 32 61 8F    ld   ($8F61),a
1003: 32 3F 8F    ld   ($8F3F),a
1006: 32 5C 8F    ld   ($8F5C),a
1009: CD BC 0F    call $0FBC
100C: 21 38 8A    ld   hl,$8A38
100F: 7E          ld   a,(hl)
1010: 23          inc  hl
1011: B7          or   a
1012: C8          ret  z
1013: 32 5C 8F    ld   ($8F5C),a
1016: CD 83 15    call $1583
1019: CD 42 10    call $1042
101C: CD 7D 10    call $107D
101F: CD D4 20    call $20D4
1022: CD 1B 51    call $511B
1025: CD 19 12    call $1219
1028: CD BD 40    call $40BD
102B: CD EF 02    call update_sprite_shadows_02EF
102E: CD E4 5A    call $5AE4
1031: CD 64 0E    call $0E64
1034: C9          ret

1035: CD 57 21    call $2157
1038: CD 19 12    call $1219
103B: CD BD 40    call $40BD
103E: CD EF 02    call update_sprite_shadows_02EF
1041: C9          ret
1042: 3E 01       ld   a,$01
1044: 32 3F 8F    ld   ($8F3F),a
1047: DD 21 80 8A ld   ix,top_basket_object_8A80
104B: FD 21 90 8C ld   iy,$8C90
104F: DD 7E 02    ld   a,(ix+$02)
1052: A7          and  a
1053: 20 23       jr   nz,$1078
1055: 3A 24 8F    ld   a,($8F24)
1058: 21 57 8F    ld   hl,$8F57
105B: B6          or   (hl)
105C: 20 1A       jr   nz,$1078
105E: 3A 1F 88    ld   a,($881F)
1061: A7          and  a
1062: 3A A0 A0    ld   a,(in1_a0a0)
1065: 20 03       jr   nz,$106A
1067: 3A C0 A0    ld   a,(in2_a0c0)
106A: 2F          cpl
106B: DD 77 07    ld   (ix+$07),a
106E: DD 7E 1E    ld   a,(ix+$1e)
1071: A7          and  a
1072: C0          ret  nz
1073: DD CB 07 A6 res  4,(ix+$07)
1077: C9          ret
1078: DD 36 07 00 ld   (ix+$07),$00
107C: C9          ret
107D: 3A 01 89    ld   a,(nb_wolves_8901)
1080: A7          and  a
1081: C0          ret  nz
1082: 21 5C 8F    ld   hl,$8F5C
1085: 34          inc  (hl)
1086: 11 35 06    ld   de,$0635
1089: FF          rst  $38
108A: 3E 40       ld   a,$40
108C: 32 62 8F    ld   ($8F62),a
108F: C9          ret
1090: 21 62 8F    ld   hl,$8F62
1093: 7E          ld   a,(hl)
1094: A7          and  a
1095: 28 02       jr   z,$1099
1097: 35          dec  (hl)
1098: C9          ret
1099: 21 5C 8F    ld   hl,$8F5C
109C: 34          inc  (hl)
109D: 11 34 06    ld   de,$0634
10A0: FF          rst  $38
10A1: C9          ret
10A2: 3A 5D 8F    ld   a,($8F5D)
10A5: FE 0A       cp   $0A
10A7: 38 04       jr   c,$10AD
10A9: 47          ld   b,a
10AA: CD 31 11    call $1131
10AD: 21 50 86    ld   hl,$8650
10B0: CD 19 11    call $1119
10B3: 3A 5D 8F    ld   a,($8F5D)
10B6: A7          and  a
10B7: 28 26       jr   z,$10DF
10B9: FE 0C       cp   $0C
10BB: 30 22       jr   nc,$10DF
10BD: D6 07       sub  $07
10BF: 06 05       ld   b,$05
10C1: 28 0D       jr   z,$10D0
10C3: 30 06       jr   nc,$10CB
10C5: 04          inc  b
10C6: 3C          inc  a
10C7: 20 FC       jr   nz,$10C5
10C9: 18 05       jr   $10D0
10CB: 05          dec  b
10CC: 3D          dec  a
10CD: 20 FC       jr   nz,$10CB
10CF: 78          ld   a,b
10D0: 78          ld   a,b
10D1: 32 62 8F    ld   ($8F62),a
10D4: CB 20       sla  b
10D6: CD 31 11    call $1131
10D9: 21 D0 85    ld   hl,$85D0
10DC: CD 19 11    call $1119
10DF: 3A 5E 8F    ld   a,($8F5E)
10E2: FE 0A       cp   $0A
10E4: 38 04       jr   c,$10EA
10E6: 47          ld   b,a
10E7: CD 31 11    call $1131
10EA: 21 52 86    ld   hl,$8652
10ED: CD 19 11    call $1119
10F0: 21 60 8F    ld   hl,$8F60
10F3: 7E          ld   a,(hl)
10F4: A7          and  a
10F5: 28 1A       jr   z,$1111
10F7: 47          ld   b,a
10F8: 2E 62       ld   l,$62
10FA: 86          add  a,(hl)
10FB: 77          ld   (hl),a
10FC: CB 20       sla  b
10FE: CD 31 11    call $1131
1101: 5F          ld   e,a
1102: 79          ld   a,c
1103: A7          and  a
1104: 28 04       jr   z,$110A
1106: 79          ld   a,c
1107: 32 F2 85    ld   ($85F2),a
110A: 21 D2 85    ld   hl,$85D2
110D: 7B          ld   a,e
110E: CD 19 11    call $1119
1111: 21 5C 8F    ld   hl,$8F5C
1114: 34          inc  (hl)
1115: CD 44 0F    call $0F44
1118: C9          ret
1119: 01 E0 FF    ld   bc,$FFE0
111C: 5F          ld   e,a
111D: CB 3F       srl  a
111F: CB 3F       srl  a
1121: CB 3F       srl  a
1123: CB 3F       srl  a
1125: A7          and  a
1126: 20 02       jr   nz,$112A
1128: 3E 10       ld   a,$10
112A: 77          ld   (hl),a
112B: 09          add  hl,bc
112C: 7B          ld   a,e
112D: E6 0F       and  $0F
112F: 77          ld   (hl),a
1130: C9          ret
1131: AF          xor  a
1132: 4F          ld   c,a
1133: C6 01       add  a,$01
1135: 27          daa
1136: 30 01       jr   nc,$1139
1138: 0C          inc  c
1139: 10 F8       djnz $1133
113B: C9          ret
113C: 21 62 8F    ld   hl,$8F62
113F: 7E          ld   a,(hl)
1140: A7          and  a
1141: 28 06       jr   z,$1149
1143: 35          dec  (hl)
1144: 11 15 03    ld   de,$0315
1147: FF          rst  $38
1148: C9          ret
1149: 36 80       ld   (hl),$80
114B: 2E 5C       ld   l,$5C
114D: 34          inc  (hl)
114E: C9          ret
114F: 21 62 8F    ld   hl,$8F62
1152: 7E          ld   a,(hl)
1153: A7          and  a
1154: 28 02       jr   z,$1158
1156: 35          dec  (hl)
1157: C9          ret
1158: AF          xor  a
1159: 2E 5B       ld   l,$5B
115B: 06 09       ld   b,$09
115D: D7          rst  $10
115E: CD CF 0E    call $0ECF
1161: 3E 06       ld   a,$06
1163: 32 0A 88    ld   (in_game_sub_state_880A),a
1166: 21 3C 8A    ld   hl,$8A3C
1169: 3A 2B 88    ld   a,($882B)
116C: 86          add  a,(hl)
116D: A7          and  a
116E: C8          ret  z
116F: 18 1C       jr   $118D
1171: 21 07 8D    ld   hl,$8D07
1174: 7E          ld   a,(hl)
1175: A7          and  a
1176: 28 02       jr   z,$117A
1178: 35          dec  (hl)
1179: C9          ret
117A: 3A 01 89    ld   a,(nb_wolves_8901)
117D: 2E 40       ld   l,$40
117F: 96          sub  (hl)
1180: C8          ret  z
1181: D8          ret  c
1182: 4F          ld   c,a
1183: 7E          ld   a,(hl)
1184: FE 06       cp   $06
1186: D0          ret  nc
1187: DD 21 E0 8A ld   ix,$8AE0
118B: 06 06       ld   b,$06
118D: 1E 1D       ld   e,$1D
118F: CD 9A 11    call $119A
1192: 11 18 00    ld   de,$0018
1195: DD 19       add  ix,de
1197: 10 F4       djnz $118D
1199: C9          ret
119A: DD 7E 00    ld   a,(ix+$00)
119D: DD B6 01    or   (ix+$01)
11A0: 0F          rrca
11A1: D8          ret  c
11A2: 41          ld   b,c
11A3: DD 36 00 01 ld   (ix+$00),$01
11A7: DD 36 02 03 ld   (ix+$02),$03
11AB: DD 73 04    ld   (ix+$04),e
11AE: AF          xor  a
11AF: DD 77 03    ld   (ix+$03),a
11B2: DD 77 05    ld   (ix+$05),a
11B5: DD 77 06    ld   (ix+$06),a
11B8: DD 77 08    ld   (ix+$08),a
11BB: DD 36 07 01 ld   (ix+$07),$01
11BF: DD 77 0B    ld   (ix+$0b),a
11C2: 21 09 12    ld   hl,$1209
11C5: 3A 07 89    ld   a,($8907)
11C8: E6 3F       and  $3F
11CA: CB 3F       srl  a
11CC: CB 3F       srl  a
11CE: FE 10       cp   $10
11D0: E7          rst  $20
11D1: DD 77 09    ld   (ix+$09),a
11D4: ED 44       neg
11D6: DD 77 0A    ld   (ix+$0a),a
11D9: 11 29 38    ld   de,$3829
11DC: CD 1E 38    call $381E
11DF: 21 F9 11    ld   hl,$11F9
11E2: 3A 07 89    ld   a,($8907)
11E5: E6 3F       and  $3F
11E7: CB 2F       sra  a
11E9: CB 2F       sra  a
11EB: E7          rst  $20
11EC: 32 07 8D    ld   ($8D07),a
11EF: 21 5F 8F    ld   hl,$8F5F
11F2: 34          inc  (hl)
11F3: 21 40 8D    ld   hl,$8D40
11F6: 34          inc  (hl)
11F7: F1          pop  af
11F8: C9          ret

1219: DD 21 E0 8A ld   ix,$8AE0
121D: 11 18 00    ld   de,$0018
1220: 06 0E       ld   b,$0E
1222: D9          exx
1223: CD 2C 12    call $122C
1226: D9          exx
1227: DD 19       add  ix,de
1229: 10 F7       djnz $1222
122B: C9          ret
122C: DD 7E 00    ld   a,(ix+$00)
122F: DD B6 01    or   (ix+$01)
1232: 0F          rrca
1233: D0          ret  nc
1234: DD 7E 02    ld   a,(ix+$02)
1237: E6 1F       and  $1F
1239: FE 11       cp   $11
123B: D0          ret  nc
123C: EF          rst  $28

	.word	$125F 
	.word	$1270 
	.word	$3536 
	.word	$12AF 
	.word	$3865 
	.word	$1496
	.word	$3BE3 
	.word	$3C92 
	.word	$14DC 
	.word	$1518
	.word	$154D 
	.word	$3E69 
	.word	$3E9C
	.word	$3F5C
	.word	$3F72 
	.word	$3F7C 
	.word	$3FE9

125F: DD 35 11    dec  (ix+$11)
1262: C0          ret  nz
1263: DD 34 02    inc  (ix+$02)
1266: 11 38 38    ld   de,$3838
1269: DD 36 08 01 ld   (ix+$08),$01
126D: C3 1E 38    jp   $381E
1270: CD 06 40    call $4006
1273: DD 7E 0A    ld   a,(ix+$0a)
1276: ED 44       neg
1278: 47          ld   b,a
1279: DD 7E 05    ld   a,(ix+$05)
127C: B8          cp   b
127D: 30 03       jr   nc,$1282
127F: DD 35 06    dec  (ix+$06)
1282: DD 86 0A    add  a,(ix+$0a)
1285: DD 77 05    ld   (ix+$05),a
1288: DD 7E 06    ld   a,(ix+$06)
128B: A7          and  a
128C: C0          ret  nz
128D: CD 53 35    call $3553
1290: 21 40 8D    ld   hl,$8D40
1293: 35          dec  (hl)
1294: 21 01 89    ld   hl,nb_wolves_8901
1297: 7E          ld   a,(hl)
1298: 4F          ld   c,a
1299: A7          and  a
129A: 28 01       jr   z,$129D
129C: 35          dec  (hl)
129D: 3A 0A 88    ld   a,(in_game_sub_state_880A)
12A0: FE 04       cp   $04
12A2: 20 02       jr   nz,$12A6
12A4: 2C          inc  l
12A5: 34          inc  (hl)
12A6: 79          ld   a,c
12A7: 3D          dec  a
12A8: FE 0A       cp   $0A
12AA: D0          ret  nc
12AB: 32 43 87    ld   ($8743),a
12AE: C9          ret
12AF: CD 06 40    call $4006
12B2: DD 7E 08    ld   a,(ix+$08)
12B5: A7          and  a
12B6: C2 FE 13    jp   nz,$13FE
12B9: DD 7E 05    ld   a,(ix+$05)
12BC: DD 86 09    add  a,(ix+$09)
12BF: 30 03       jr   nc,$12C4
12C1: DD 34 06    inc  (ix+$06)
12C4: DD 77 05    ld   (ix+$05),a
12C7: 47          ld   b,a
12C8: 3A 01 89    ld   a,(nb_wolves_8901)
12CB: FE 03       cp   $03
12CD: DA 99 13    jp   c,$1399
12D0: 21 FB 12    ld   hl,$12FB
12D3: 3A 07 89    ld   a,($8907)
12D6: E6 1F       and  $1F
12D8: CB 3F       srl  a
12DA: CB 3F       srl  a
12DC: CD 45 0C    call $0C45
12DF: EB          ex   de,hl
12E0: 3A 41 8D    ld   a,($8D41)
12E3: E6 0F       and  $0F
12E5: E7          rst  $20
12E6: 4F          ld   c,a
12E7: DD 7E 06    ld   a,(ix+$06)
12EA: B9          cp   c
12EB: CA 83 13    jp   z,$1383
12EE: FE 14       cp   $14
12F0: D8          ret  c
12F1: DD 36 08 01 ld   (ix+$08),$01
12F5: 11 38 38    ld   de,$3838
12F8: C3 1E 38    jp   $381E
12FB: 0B          dec  bc
12FC: 13          inc  de
12FD: 1A          ld   a,(de)
12FE: 13          inc  de
12FF: 29          add  hl,hl
1300: 13          inc  de
1301: 38 13       jr   c,$1316
1303: 47          ld   b,a
1304: 13          inc  de
1305: 56          ld   d,(hl)
1306: 13          inc  de
1307: 65          ld   h,l
1308: 13          inc  de
1309: 74          ld   (hl),h
130A: 13          inc  de
130B: 11 0D 09    ld   de,$090D
130E: 0D          dec  c
130F: 09          add  hl,bc
1310: 12          ld   (de),a
1311: 0E 0B       ld   c,$0B
1313: 09          add  hl,bc
1314: 0D          dec  c
1315: 09          add  hl,bc
1316: 09          add  hl,bc
1317: 11 0D 09    ld   de,$090D
131A: 0D          dec  c
131B: 09          add  hl,bc
131C: 11 0D 09    ld   de,$090D
131F: 09          add  hl,bc
1320: 12          ld   (de),a
1321: 10 09       djnz $132C
1323: 0D          dec  c
1324: 09          add  hl,bc
1325: 11 0D 09    ld   de,$090D
1328: 09          add  hl,bc
1329: 11 0D 11    ld   de,$110D
132C: 0D          dec  c
132D: 09          add  hl,bc
132E: 11 0F 0D    ld   de,$0D0F
1331: 09          add  hl,bc
1332: 12          ld   (de),a
1333: 0D          dec  c
1334: 10 09       djnz $133F
1336: 0D          dec  c
1337: 09          add  hl,bc
1338: 09          add  hl,bc
1339: 09          add  hl,bc
133A: 09          add  hl,bc
133B: 11 0C 08    ld   de,$080C
133E: 0D          dec  c
133F: 09          add  hl,bc
1340: 11 0E 0B    ld   de,$0B0E
1343: 08          ex   af,af'
1344: 11 0D 09    ld   de,$090D
1347: 11 0D 09    ld   de,$090D
134A: 0D          dec  c
134B: 11 0D 09    ld   de,$090D
134E: 0D          dec  c
134F: 11 0D 09    ld   de,$090D
1352: 0D          dec  c
1353: 11 0D 09    ld   de,$090D
1356: 11 0D 09    ld   de,$090D
1359: 09          add  hl,bc
135A: 11 0D 0D    ld   de,$0D0D
135D: 09          add  hl,bc
135E: 12          ld   (de),a
135F: 11 0D 09    ld   de,$090D
1362: 11 0D 09    ld   de,$090D
1365: 0D          dec  c
1366: 09          add  hl,bc
1367: 0B          dec  bc
1368: 08          ex   af,af'
1369: 11 12 0D    ld   de,$0D12
136C: 11 0D 10    ld   de,$100D
136F: 09          add  hl,bc
1370: 10 11       djnz $1383
1372: 0D          dec  c
1373: 09          add  hl,bc
1374: 11 0D 0B    ld   de,$0B0D
1377: 09          add  hl,bc
1378: 12          ld   (de),a
1379: 10 0D       djnz $1388
137B: 0C          inc  c
137C: 09          add  hl,bc
137D: 0B          dec  bc
137E: 10 0C       djnz $138C
1380: 11 0D 18    ld   de,$180D
1383: 78          ld   a,b
1384: FE 20       cp   $20
1386: D0          ret  nc
1387: 18 33       jr   $13BC
1389: DD CB 08 46 bit  0,(ix+$08)
138D: C8          ret  z
138E: C3 1C 14    jp   $141C
1391: DD CB 08 46 bit  0,(ix+$08)
1395: C0          ret  nz
1396: C3 D0 12    jp   $12D0
1399: DD 7E 06    ld   a,(ix+$06)
139C: FE 07       cp   $07
139E: 38 E9       jr   c,$1389
13A0: FE 14       cp   $14
13A2: 30 ED       jr   nc,$1391
13A4: 21 6B 8D    ld   hl,$8D6B
13A7: 7E          ld   a,(hl)
13A8: A7          and  a
13A9: 28 02       jr   z,$13AD
13AB: 35          dec  (hl)
13AC: C9          ret
13AD: 78          ld   a,b
13AE: FE 80       cp   $80
13B0: D0          ret  nc
13B1: EB          ex   de,hl
13B2: 21 D3 13    ld   hl,$13D3
13B5: 3A 07 89    ld   a,($8907)
13B8: E6 07       and  $07
13BA: E7          rst  $20
13BB: 12          ld   (de),a
13BC: FD 21 70 8B ld   iy,$8B70
13C0: 11 18 00    ld   de,$0018
13C3: 06 05       ld   b,$05
13C5: FD 7E 00    ld   a,(iy+$00)
13C8: FD B6 01    or   (iy+$01)
13CB: 0F          rrca
13CC: 30 0D       jr   nc,$13DB
13CE: FD 19       add  iy,de
13D0: 10 F3       djnz $13C5
13D2: C9          ret
13D3: 28 28       jr   z,$13FD
13D5: 20 20       jr   nz,$13F7
13D7: 18 18       jr   $13F1
13D9: 10 10       djnz $13EB
13DB: 21 41 8D    ld   hl,$8D41
13DE: 34          inc  (hl)
13DF: 20 01       jr   nz,$13E2
13E1: 34          inc  (hl)
13E2: 4E          ld   c,(hl)
13E3: DD 71 14    ld   (ix+$14),c
13E6: 21 88 39    ld   hl,$3988
13E9: DD 75 0C    ld   (ix+$0c),l
13EC: DD 74 0D    ld   (ix+$0d),h
13EF: DD 36 0E 00 ld   (ix+$0e),$00
13F3: DD 36 11 28 ld   (ix+$11),$28
13F7: DD 36 02 04 ld   (ix+$02),$04
13FB: C3 2C 14    jp   $142C
13FE: DD 7E 0A    ld   a,(ix+$0a)
1401: ED 44       neg
1403: 47          ld   b,a
1404: DD 7E 05    ld   a,(ix+$05)
1407: B8          cp   b
1408: 30 03       jr   nc,$140D
140A: DD 35 06    dec  (ix+$06)
140D: DD 86 0A    add  a,(ix+$0a)
1410: DD 77 05    ld   (ix+$05),a
1413: 47          ld   b,a
1414: 3A 01 89    ld   a,(nb_wolves_8901)
1417: FE 03       cp   $03
1419: DA 99 13    jp   c,$1399
141C: DD 7E 06    ld   a,(ix+$06)
141F: FE 02       cp   $02
1421: D0          ret  nc
1422: DD 36 08 00 ld   (ix+$08),$00
1426: 11 29 38    ld   de,$3829
1429: C3 1E 38    jp   $381E
142C: FD 36 00 01 ld   (iy+$00),$01
1430: FD 36 02 04 ld   (iy+$02),$04
1434: FD 71 14    ld   (iy+$14),c
1437: AF          xor  a
1438: FD 77 07    ld   (iy+$07),a
143B: FD 77 0E    ld   (iy+$0e),a
143E: DD 7E 05    ld   a,(ix+$05)
1441: C6 80       add  a,$80
1443: FD 77 05    ld   (iy+$05),a
1446: DD 7E 03    ld   a,(ix+$03)
1449: C6 80       add  a,$80
144B: FD 77 03    ld   (iy+$03),a
144E: DD 7E 04    ld   a,(ix+$04)
1451: D6 01       sub  $01
1453: FD 77 04    ld   (iy+$04),a
1456: DD 7E 06    ld   a,(ix+$06)
1459: C6 01       add  a,$01
145B: FD 77 06    ld   (iy+$06),a
145E: 3A 00 89    ld   a,(current_play_variables_8900)
1461: FE 08       cp   $08
1463: 38 02       jr   c,$1467
1465: 3E 07       ld   a,$07
1467: 21 8E 14    ld   hl,$148E
146A: E7          rst  $20
146B: 3A 07 89    ld   a,($8907)
146E: E6 01       and  $01
1470: 7E          ld   a,(hl)
1471: 28 02       jr   z,$1475
1473: ED 44       neg
1475: FD 77 0A    ld   (iy+$0a),a
1478: DD 77 0A    ld   (ix+$0a),a
147B: 11 CB 38    ld   de,$38CB
147E: FD 77 0B    ld   (iy+$0b),a
1481: FD 73 0C    ld   (iy+$0c),e
1484: FD 72 0D    ld   (iy+$0d),d
1487: FD 36 11 28 ld   (iy+$11),$28
148B: C3 E3 0E    jp   $0EE3
148E: 10 11       djnz $14A1
1490: 12          ld   (de),a
1491: 13          inc  de
1492: 14          inc  d
1493: 15          dec  d
1494: 16 17       ld   d,$17
1496: CD 06 40    call $4006
1499: DD 7E 0A    ld   a,(ix+$0a)
149C: ED 44       neg
149E: 47          ld   b,a
149F: DD 7E 03    ld   a,(ix+$03)
14A2: B8          cp   b
14A3: 30 03       jr   nc,$14A8
14A5: DD 35 04    dec  (ix+$04)
14A8: DD 86 0A    add  a,(ix+$0a)
14AB: DD 77 03    ld   (ix+$03),a
14AE: DD 46 04    ld   b,(ix+$04)
14B1: DD 7E 07    ld   a,(ix+$07)
14B4: A7          and  a
14B5: 28 12       jr   z,$14C9
14B7: 78          ld   a,b
14B8: FE 04       cp   $04
14BA: 38 04       jr   c,$14C0
14BC: DD 7E 06    ld   a,(ix+$06)
14BF: C9          ret
14C0: DD 36 02 00 ld   (ix+$02),$00
14C4: DD 36 11 20 ld   (ix+$11),$20
14C8: C9          ret
14C9: 78          ld   a,b
14CA: FE 02       cp   $02
14CC: D0          ret  nc
14CD: 11 D1 3B    ld   de,$3BD1
14D0: CD 1E 38    call $381E
14D3: DD 36 02 02 ld   (ix+$02),$02
14D7: DD 36 11 28 ld   (ix+$11),$28
14DB: C9          ret
14DC: 06 01       ld   b,$01
14DE: DD 4E 17    ld   c,(ix+$17)
14E1: 3A 45 8D    ld   a,($8D45)
14E4: A7          and  a
14E5: 28 21       jr   z,$1508
14E7: DD 4E 12    ld   c,(ix+$12)
14EA: 0C          inc  c
14EB: 28 1B       jr   z,$1508
14ED: FE 05       cp   $05
14EF: 38 02       jr   c,$14F3
14F1: 3E 04       ld   a,$04
14F3: 47          ld   b,a
14F4: 05          dec  b
14F5: 48          ld   c,b
14F6: 28 06       jr   z,$14FE
14F8: 3E 01       ld   a,$01
14FA: CB 27       sla  a
14FC: 10 FC       djnz $14FA
14FE: 21 60 8F    ld   hl,$8F60
1501: 86          add  a,(hl)
1502: 77          ld   (hl),a
1503: 2E 5E       ld   l,$5E
1505: 34          inc  (hl)
1506: 06 38       ld   b,$38
1508: DD 70 11    ld   (ix+$11),b
150B: 79          ld   a,c
150C: 21 57 15    ld   hl,$1557
150F: CD 45 0C    call $0C45
1512: CD 1E 38    call $381E
1515: DD 34 02    inc  (ix+$02)
1518: CD 06 40    call $4006
151B: DD 35 11    dec  (ix+$11)
151E: C0          ret  nz
151F: 3A 60 8F    ld   a,($8F60)
1522: CB 27       sla  a
1524: 47          ld   b,a
1525: A7          and  a
1526: 28 12       jr   z,$153A
1528: CD 31 11    call $1131
152B: 5F          ld   e,a
152C: 79          ld   a,c
152D: A7          and  a
152E: 28 03       jr   z,$1533
1530: 32 E9 85    ld   ($85E9),a
1533: 21 C9 85    ld   hl,$85C9
1536: 7B          ld   a,e
1537: CD 19 11    call $1119
153A: DD 7E 16    ld   a,(ix+$16)
153D: FE 07       cp   $07
153F: CA 99 3D    jp   z,$3D99
1542: 3C          inc  a
1543: DD 77 13    ld   (ix+$13),a
1546: DD 36 11 01 ld   (ix+$11),$01
154A: DD 34 02    inc  (ix+$02)
154D: CD 06 40    call $4006
1550: DD 35 11    dec  (ix+$11)
1553: C0          ret  nz
1554: C3 53 35    jp   $3553
1557: 5F          ld   e,a
1558: 15          dec  d
1559: 68          ld   l,b
155A: 15          dec  d
155B: 71          ld   (hl),c
155C: 15          dec  d
155D: 7A          ld   a,d
155E: 15          dec  d
155F: 80          add  a,b
1560: 01 05 40    ld   bc,$4005
1563: 1D          dec  e
1564: 05          dec  b
1565: 42          ld   b,d
1566: 37          scf
1567: 28 80       jr   z,$14E9
1569: 01 05 40    ld   bc,$4005
156C: 1D          dec  e
156D: 05          dec  b
156E: 43          ld   b,e
156F: 39          add  hl,sp
1570: 28 80       jr   z,$14F2
1572: 01 04 40    ld   bc,$4004
1575: 1D          dec  e
1576: 04          inc  b
1577: 42          ld   b,d
1578: 39          add  hl,sp
1579: 28 80       jr   z,$14FB
157B: 01 03 40    ld   bc,$4003
157E: 1D          dec  e
157F: 03          inc  bc
1580: 4F          ld   c,a
1581: 3A 38 21    ld   a,($2138)
1584: 4D          ld   c,l
1585: 8F          adc  a,a
1586: 34          inc  (hl)
1587: 7E          ld   a,(hl)
1588: 47          ld   b,a
1589: E6 0F       and  $0F
158B: C0          ret  nz
158C: CB 60       bit  4,b
158E: 11 35 06    ld   de,$0635
1591: 28 02       jr   z,$1595
1593: 1E B5       ld   e,$B5
1595: FF          rst  $38
1596: 3A EF 89    ld   a,($89EF)
1599: A7          and  a
159A: C8          ret  z

in_game_159B:
159B: CD 12 79    call $7912
159E: 21 D1 15    ld   hl,continue_15D1
15A1: E5          push hl
15A2: 3A 0A 88    ld   a,(in_game_sub_state_880A)
15A5: E6 1F       and  $1F
15A7: EF          rst  $28
	 .word	$1601  
	 .word	$16B7
	 .word	$175D  
	 .word	$17C1 
	 .word	$18AF  
	 .word	$19EE  
	 .word	$1A01 
	 .word	$1A64 
     .word	$15B8 
	 .word	$1B43 
	 .word	$1B8C 
	 .word	$1BAB 
	 .word	$1BCC 
	 .word	$1C03
	 .word	$1C53 
	 .word	$1C66 
	 .word	$1D9C 
     .word	$15C8 
	 .word	$1D6E  
	 .word	$6BB2 
	 .word	$71B9

continue_15D1:
15D1: 3A 06 88    ld   a,($8806)
15D4: A7          and  a
15D5: C0          ret  nz
15D6: 3A 2C 88    ld   a,($882C)
15D9: FE 0F       cp   $0F
15DB: CA B5 0B    jp   z,$0BB5
15DE: 3A 02 88    ld   a,(nb_credits_8802)
15E1: A7          and  a
15E2: C8          ret  z
15E3: 21 05 88    ld   hl,game_state_8805
15E6: 36 02       ld   (hl),$02
15E8: 2E 0A       ld   l,$0A
15EA: 36 00       ld   (hl),$00
15EC: CD 27 25    call $2527
15EF: CD B9 02    call $02B9
15F2: 21 5F 85    ld   hl,$855F
15F5: 11 E0 FF    ld   de,$FFE0
15F8: 06 08       ld   b,$08
15FA: 3E 10       ld   a,$10
15FC: 77          ld   (hl),a
15FD: 19          add  hl,de
15FE: 10 FA       djnz $15FA
1600: C9          ret
1601: CD C9 02    call $02C9
1604: C0          ret  nz
1605: CD E3 02    call $02E3
1608: CD BC 19    call $19BC
160B: AF          xor  a
160C: 32 21 8D    ld   ($8D21),a
160F: 21 23 8D    ld   hl,$8D23
1612: 06 C0       ld   b,$C0
1614: D7          rst  $10
1615: 21 21 8E    ld   hl,$8E21
1618: 06 0C       ld   b,$0C
161A: D7          rst  $10
161B: 32 16 8F    ld   ($8F16),a
161E: 32 17 8F    ld   ($8F17),a
1621: 3A 0E 88    ld   a,($880E)
1624: A7          and  a
1625: 3E 02       ld   a,$02
1627: 28 2A       jr   z,$1653
1629: 3A E3 89    ld   a,($89E3)
162C: A7          and  a
162D: 20 24       jr   nz,$1653
162F: 3C          inc  a
1630: 32 E3 89    ld   ($89E3),a
1633: 3A 0F 88    ld   a,($880F)
1636: A7          and  a
1637: 3A 0D 88    ld   a,($880D)
163A: 20 06       jr   nz,$1642
163C: 3D          dec  a
163D: 32 1F 88    ld   ($881F),a
1640: 18 01       jr   $1643
1642: 3D          dec  a
1643: 11 02 06    ld   de,$0602
1646: A7          and  a
1647: 20 01       jr   nz,$164A
1649: 1C          inc  e
164A: FF          rst  $38
164B: 01 79 07    ld   bc,$0779
164E: CD 5D 07    call $075D
1651: 3E 80       ld   a,$80
1653: 32 08 88    ld   ($8808),a
1656: 21 0A 88    ld   hl,in_game_sub_state_880A
1659: 34          inc  (hl)
165A: 3A 0D 88    ld   a,($880D)
165D: 21 40 89    ld   hl,$8940
1660: 11 00 89    ld   de,current_play_variables_8900
1663: 01 3F 00    ld   bc,$003F
1666: A7          and  a
1667: 28 03       jr   z,$166C
1669: 21 80 89    ld   hl,$8980
166C: ED B0       ldir
166E: 3A 03 89    ld   a,($8903)
1671: A7          and  a
1672: 28 05       jr   z,$1679
1674: D6 02       sub  $02
1676: 32 31 89    ld   ($8931),a
1679: 3A 06 89    ld   a,($8906)
167C: A7          and  a
167D: C0          ret  nz
167E: 32 05 89    ld   ($8905),a
1681: 32 0A 89    ld   ($890A),a
1684: 11 AE 16    ld   de,$16AE
1687: 21 F0 89    ld   hl,$89F0
168A: 1A          ld   a,(de)
168B: FE FF       cp   $FF
168D: C8          ret  z
168E: 77          ld   (hl),a
168F: 13          inc  de
1690: 23          inc  hl
1691: 18 F7       jr   $168A
1693: C9          ret
1694: 11 AE 16    ld   de,$16AE
1697: 21 F0 89    ld   hl,$89F0
169A: 1A          ld   a,(de)
169B: FE FF       cp   $FF
169D: 28 07       jr   z,$16A6
169F: BE          cp   (hl)
16A0: 20 15       jr   nz,$16B7
16A2: 13          inc  de
16A3: 23          inc  hl
16A4: 18 F4       jr   $169A
16A6: 21 F0 89    ld   hl,$89F0
16A9: AF          xor  a
16AA: 06 07       ld   b,$07
16AC: D7          rst  $10
16AD: C9          ret
16AE: 0A          ld   a,(bc)
16AF: 10 1B       djnz $16CC
16B1: 1F          rra
16B2: 1E 11       ld   e,$11
16B4: 1D          dec  e
16B5: 19          add  hl,de
16B6: FF          rst  $38
16B7: 21 08 88    ld   hl,$8808
16BA: 35          dec  (hl)
16BB: C0          ret  nz
16BC: CD E3 02    call $02E3
16BF: CD D3 1D    call $1DD3
16C2: 3A 50 8F    ld   a,($8F50)
16C5: E6 01       and  $01
16C7: 28 06       jr   z,$16CF
16C9: 3E 10       ld   a,$10
16CB: 32 0A 88    ld   (in_game_sub_state_880A),a
16CE: C9          ret
16CF: AF          xor  a
16D0: 32 B7 88    ld   ($88B7),a
16D3: CD C2 03    call $03C2
16D6: 3A 50 8F    ld   a,($8F50)
16D9: A7          and  a
16DA: 28 17       jr   z,$16F3
16DC: 3A 07 89    ld   a,($8907)
16DF: CB 4F       bit  1,a
16E1: 20 08       jr   nz,$16EB
16E3: 21 81 4E    ld   hl,$4E81
16E6: 11 39 50    ld   de,$5039
16E9: 18 3D       jr   $1728
16EB: 21 92 4C    ld   hl,$4C92
16EE: 11 CE 4D    ld   de,$4DCE
16F1: 18 35       jr   $1728

16F3: 3A 04 89    ld   a,($8904)
16F6: A7          and  a
16F7: 20 1C       jr   nz,$1715
16F9: 3A 06 88    ld   a,($8806)
16FC: A7          and  a
16FD: 28 16       jr   z,$1715
16FF: 3A 07 89    ld   a,($8907)
1702: CB 47       bit  0,a
1704: 21 2C 46    ld   hl,$462C
1707: 11 30 4B    ld   de,$4B30
170A: 20 1C       jr   nz,$1728
170C: A7          and  a
170D: 21 A9 44    ld   hl,$44A9
1710: 11 55 4B    ld   de,$4B55
1713: 28 13       jr   z,$1728
1715: 3A 07 89    ld   a,($8907)
1718: CB 47       bit  0,a
171A: 21 D6 46    ld   hl,$46D6
171D: 11 50 4A    ld   de,$4A50
1720: 28 06       jr   z,$1728
1722: 21 72 48    ld   hl,$4872
1725: 11 F6 4B    ld   de,$4BF6
1728: ED 53 45 8F ld   ($8F45),de
172C: 22 BA 88    ld   ($88BA),hl
172F: 21 42 84    ld   hl,$8442
1732: 22 B8 88    ld   ($88B8),hl
1735: 21 42 80    ld   hl,$8042
1738: 22 43 8F    ld   ($8F43),hl
173B: 3E 20       ld   a,$20
173D: 32 07 8D    ld   ($8D07),a
1740: 21 0A 88    ld   hl,in_game_sub_state_880A
1743: 34          inc  (hl)
1744: 11 83 06    ld   de,$0683
1747: FF          rst  $38
1748: CD 94 16    call $1694
174B: C9          ret

table_1754:
   .byte 	04 08 8D 8F 0F 88 8E 8C 5A


175D: CD 81 43    call $4381
1760: 21 B7 88    ld   hl,$88B7
1763: 34          inc  (hl)
1764: 7E          ld   a,(hl)
1765: FE 1C       cp   $1C
1767: C0          ret  nz
1768: 36 00       ld   (hl),$00
176A: 21 20 89    ld   hl,$8920
176D: 7E          ld   a,(hl)
176E: 34          inc  (hl)
176F: A7          and  a
1770: C8          ret  z
1771: AF          xor  a
1772: 77          ld   (hl),a
1773: 3A 50 8F    ld   a,($8F50)
1776: A7          and  a
1777: 20 42       jr   nz,$17BB
1779: 3A 04 89    ld   a,($8904)
177C: A7          and  a
177D: 20 22       jr   nz,$17A1
177F: 3A 06 88    ld   a,($8806)
1782: A7          and  a
1783: 28 13       jr   z,$1798
1785: 3A 07 89    ld   a,($8907)
1788: CB 47       bit  0,a
178A: 20 06       jr   nz,$1792
178C: 3A 07 89    ld   a,($8907)
178F: A7          and  a
1790: 20 06       jr   nz,$1798
1792: 3E 0D       ld   a,$0D
1794: 32 0A 88    ld   (in_game_sub_state_880A),a
1797: C9          ret
1798: 3E 01       ld   a,$01
179A: 32 04 89    ld   ($8904),a
179D: 3C          inc  a
179E: 32 03 89    ld   ($8903),a
17A1: CD AD 1E    call $1EAD
17A4: CD 65 20    call $2065
17A7: CD 0B 4A    call $4A0B
17AA: 3E 10       ld   a,$10
17AC: 32 91 8A    ld   ($8A91),a
17AF: 32 06 8F    ld   ($8F06),a
17B2: 32 09 8F    ld   ($8F09),a
17B5: CD 0D 54    call $540D
17B8: CD EF 02    call update_sprite_shadows_02EF
17BB: 21 0A 88    ld   hl,in_game_sub_state_880A
17BE: 36 03       ld   (hl),$03
17C0: C9          ret
17C1: DD 21 80 8A ld   ix,top_basket_object_8A80
17C5: 3A 50 8F    ld   a,($8F50)
17C8: A7          and  a
17C9: 11 F6 84    ld   de,$84F6
17CC: 20 0A       jr   nz,$17D8
17CE: 3A 07 89    ld   a,($8907)
17D1: CB 47       bit  0,a
17D3: 21 2C 1E    ld   hl,$1E2C
17D6: 20 05       jr   nz,$17DD
17D8: 21 34 1E    ld   hl,$1E34
17DB: 1E E9       ld   e,$E9
17DD: ED 53 BE 88 ld   ($88BE),de
17E1: 11 18 00    ld   de,$0018
17E4: 06 04       ld   b,$04
17E6: DD 36 00 01 ld   (ix+$00),$01
17EA: 7E          ld   a,(hl)
17EB: DD 77 04    ld   (ix+$04),a
17EE: 23          inc  hl
17EF: 7E          ld   a,(hl)
17F0: DD 77 06    ld   (ix+$06),a
17F3: 23          inc  hl
17F4: DD 19       add  ix,de
17F6: 10 EE       djnz $17E6
17F8: DD 21 80 8A ld   ix,top_basket_object_8A80
17FC: 3A 1F 88    ld   a,($881F)
17FF: A7          and  a
1800: 20 06       jr   nz,$1808
1802: DD 35 06    dec  (ix+$06)
1805: DD 35 06    dec  (ix+$06)
1808: 21 C9 26    ld   hl,$26C9
180B: 22 00 8F    ld   ($8F00),hl
180E: CD B1 22    call $22B1
1811: 3A 50 8F    ld   a,($8F50)
1814: A7          and  a
1815: 20 31       jr   nz,$1848
1817: 3A 06 88    ld   a,($8806)
181A: A7          and  a
181B: 20 0C       jr   nz,$1829
181D: 3A 3F 8F    ld   a,($8F3F)
1820: A7          and  a
1821: 28 06       jr   z,$1829
1823: 21 0A 88    ld   hl,in_game_sub_state_880A
1826: 36 12       ld   (hl),$12
1828: C9          ret
1829: 21 0A 88    ld   hl,in_game_sub_state_880A
182C: 34          inc  (hl)
182D: 11 3F 18    ld   de,$183F
1830: 21 F0 89    ld   hl,$89F0
1833: 1A          ld   a,(de)
1834: FE 43       cp   $43
1836: C8          ret  z
1837: D6 88       sub  $88
1839: 77          ld   (hl),a
183A: 13          inc  de
183B: 23          inc  hl
183C: 18 F5       jr   $1833
183E: C9          ret
183F: 92          sub  d
1840: 98          sbc  a,b
1841: A3          and  e
1842: A7          and  a
1843: A6          and  (hl)
1844: 99          sbc  a,c
1845: A5          and  l
1846: A1          and  c
1847: 43          ld   b,e
1848: 3A 07 89    ld   a,($8907)
184B: CB 4F       bit  1,a
184D: 28 5A       jr   z,$18A9
184F: 3A 07 89    ld   a,($8907)
1852: CB 3F       srl  a
1854: FE 07       cp   $07
1856: 38 06       jr   c,$185E
1858: 3E 08       ld   a,$08
185A: 06 03       ld   b,$03
185C: 18 07       jr   $1865
185E: CB 3F       srl  a
1860: E6 03       and  $03
1862: 47          ld   b,a
1863: C6 05       add  a,$05
1865: 32 47 8F    ld   ($8F47),a
1868: 78          ld   a,b
1869: 21 EB 70    ld   hl,$70EB
186C: CD 45 0C    call $0C45
186F: EB          ex   de,hl
1870: DD 21 E0 8A ld   ix,$8AE0
1874: 3A 47 8F    ld   a,($8F47)
1877: 47          ld   b,a
1878: 0E 00       ld   c,$00
187A: DD 36 05 80 ld   (ix+$05),$80
187E: DD 36 00 01 ld   (ix+$00),$01
1882: DD 36 06 04 ld   (ix+$06),$04
1886: DD 74 04    ld   (ix+$04),h
1889: 7D          ld   a,l
188A: E6 0F       and  $0F
188C: 84          add  a,h
188D: 67          ld   h,a
188E: 7D          ld   a,l
188F: E6 F0       and  $F0
1891: 81          add  a,c
1892: 4F          ld   c,a
1893: DD 77 03    ld   (ix+$03),a
1896: 30 04       jr   nc,$189C
1898: DD 34 04    inc  (ix+$04)
189B: 24          inc  h
189C: 11 29 38    ld   de,$3829
189F: CD 1E 38    call $381E
18A2: 11 18 00    ld   de,$0018
18A5: DD 19       add  ix,de
18A7: 10 D1       djnz $187A
18A9: 21 0A 88    ld   hl,in_game_sub_state_880A
18AC: 36 0F       ld   (hl),$0F
18AE: C9          ret

18AF: CD 55 1E    call $1E55
18B2: CD AB 6C    call $6CAB
18B5: CD D4 20    call $20D4
18B8: CD 1B 51    call $511B
18BB: CD 77 33    call $3377
18BE: CD BD 40    call $40BD
18C1: CD EF 02    call update_sprite_shadows_02EF
18C4: CD DA 18    call $18DA
18C7: CD 1C 19    call $191C
18CA: CD E4 5A    call $5AE4
18CD: CD 6E 19    call $196E
18D0: CD 2F 1F    call $1F2F
18D3: CD 3B 6B    call $6B3B
18D6: CD CA 19    call $19CA
18D9: C9          ret

18DA: 3A 09 89    ld   a,($8909)
18DD: A7          and  a
18DE: 28 2E       jr   z,$190E
18E0: 4F          ld   c,a
18E1: 3A 0D 88    ld   a,($880D)
18E4: 21 A4 88    ld   hl,$88A4
18E7: A7          and  a
18E8: 28 03       jr   z,$18ED
18EA: 21 A7 88    ld   hl,$88A7
18ED: 7E          ld   a,(hl)
18EE: B9          cp   c
18EF: C0          ret  nz
18F0: 21 08 89    ld   hl,nb_lives_8908
18F3: 7E          ld   a,(hl)
18F4: FE FF       cp   $FF
18F6: 30 01       jr   nc,$18F9
18F8: 34          inc  (hl)
18F9: 3A 00 88    ld   a,($8800)
18FC: A7          and  a
18FD: 3E 08       ld   a,$08
18FF: 28 01       jr   z,$1902
1901: 3D          dec  a
1902: 81          add  a,c
1903: 27          daa
1904: 32 09 89    ld   ($8909),a
1907: CD C2 03    call $03C2
190A: CD 0D 0F    call $0F0D
190D: C9          ret

190E: 3A 00 88    ld   a,($8800)
1911: A7          and  a
1912: 3E 05       ld   a,$05
1914: 28 02       jr   z,$1918
1916: 3E 03       ld   a,$03
1918: 32 09 89    ld   ($8909),a
191B: C9          ret

191C: 3A 01 89    ld   a,(nb_wolves_8901)
191F: A7          and  a
1920: C0          ret  nz
1921: 3A 82 8A    ld   a,($8A82)
1924: A7          and  a
1925: C0          ret  nz
1926: 21 E2 8A    ld   hl,$8AE2
1929: 11 18 00    ld   de,$0018
192C: 06 06       ld   b,$06
192E: 3E 03       ld   a,$03
1930: BE          cp   (hl)
1931: C8          ret  z
1932: 19          add  hl,de
1933: 10 FB       djnz $1930
1935: 21 0A 88    ld   hl,in_game_sub_state_880A
1938: 34          inc  (hl)
1939: 3A 07 89    ld   a,($8907)
193C: CB 47       bit  0,a
193E: 20 15       jr   nz,$1955
1940: CB 3F       srl  a
1942: 47          ld   b,a
1943: 3A 20 88    ld   a,($8820)
1946: 80          add  a,b
1947: 47          ld   b,a
1948: 3A 03 89    ld   a,($8903)
194B: 80          add  a,b
194C: 47          ld   b,a
194D: FE 20       cp   $20
194F: 38 02       jr   c,$1953
1951: 3E 1F       ld   a,$1F
1953: 18 0B       jr   $1960
1955: 47          ld   b,a
1956: 3A 20 88    ld   a,($8820)
1959: 80          add  a,b
195A: FE 20       cp   $20
195C: 38 02       jr   c,$1960
195E: 3E 1F       ld   a,$1F
1960: 32 00 89    ld   (current_play_variables_8900),a
1963: AF          xor  a
1964: 32 87 8A    ld   ($8A87),a
1967: 32 05 89    ld   ($8905),a
196A: 32 06 89    ld   ($8906),a
196D: C9          ret
196E: 3A 55 8D    ld   a,($8D55)
1971: A7          and  a
1972: C0          ret  nz
1973: 3A 02 89    ld   a,($8902)
1976: FE 05       cp   $05
1978: 38 26       jr   c,$19A0
197A: 28 0E       jr   z,$198A
197C: 32 55 8D    ld   ($8D55),a
197F: 3A 32 8D    ld   a,($8D32)
1982: A7          and  a
1983: 20 03       jr   nz,$1988
1985: CD 6C 0F    call $0F6C
1988: 18 16       jr   $19A0
198A: 3A 32 8D    ld   a,($8D32)
198D: A7          and  a
198E: 20 03       jr   nz,$1993
1990: 21 68 8D    ld   hl,$8D68
1993: 7E          ld   a,(hl)
1994: A7          and  a
1995: 20 09       jr   nz,$19A0
1997: 36 01       ld   (hl),$01
1999: 2C          inc  l
199A: 2C          inc  l
199B: 36 01       ld   (hl),$01
199D: CD 58 0F    call $0F58
19A0: 3A 21 8D    ld   a,($8D21)
19A3: A7          and  a
19A4: C0          ret  nz
19A5: 3A 24 8F    ld   a,($8F24)
19A8: A7          and  a
19A9: C0          ret  nz
19AA: 21 22 8D    ld   hl,$8D22
19AD: 7E          ld   a,(hl)
19AE: A7          and  a
19AF: 28 02       jr   z,$19B3
19B1: 35          dec  (hl)
19B2: C9          ret
19B3: 36 20       ld   (hl),$20
19B5: 2D          dec  l
19B6: 36 01       ld   (hl),$01
19B8: CD 76 0F    call $0F76
19BB: C9          ret
19BC: 21 80 8A    ld   hl,top_basket_object_8A80
19BF: 11 81 8A    ld   de,$8A81
19C2: 01 FF 01    ld   bc,$01FF
19C5: 36 00       ld   (hl),$00
19C7: ED B0       ldir
19C9: C9          ret
19CA: 3A 06 88    ld   a,($8806)
19CD: A7          and  a
19CE: C0          ret  nz
19CF: 3A 68 8D    ld   a,($8D68)
19D2: A7          and  a
19D3: C8          ret  z
19D4: 21 6A 8D    ld   hl,$8D6A
19D7: 35          dec  (hl)
19D8: C0          ret  nz
19D9: 36 18       ld   (hl),$18
19DB: 2D          dec  l
19DC: CB 46       bit  0,(hl)
19DE: 20 07       jr   nz,$19E7
19E0: 36 01       ld   (hl),$01
19E2: 11 0F 06    ld   de,$060F
19E5: FF          rst  $38
19E6: C9          ret
19E7: 36 00       ld   (hl),$00
19E9: 11 8F 06    ld   de,$068F
19EC: FF          rst  $38
19ED: C9          ret
19EE: CD 8B 30    call $308B
19F1: CD A6 25    call $25A6
19F4: CD 77 33    call $3377
19F7: CD BD 40    call $40BD
19FA: CD C6 28    call $28C6
19FD: CD EF 02    call update_sprite_shadows_02EF
1A00: C9          ret
1A01: CD 27 25    call $2527
1A04: 32 02 89    ld   ($8902),a
1A07: 32 34 89    ld   ($8934),a
1A0A: 0E 30       ld   c,$30
1A0C: 3A 07 89    ld   a,($8907)
1A0F: FE 02       cp   $02
1A11: 30 02       jr   nc,$1A15
1A13: 0E 28       ld   c,$28
1A15: 21 01 89    ld   hl,nb_wolves_8901
1A18: 71          ld   (hl),c
1A19: 2E 07       ld   l,$07
1A1B: 34          inc  (hl)
1A1C: 7E          ld   a,(hl)
1A1D: E6 01       and  $01
1A1F: 20 26       jr   nz,$1A47
1A21: 3A 06 88    ld   a,($8806)
1A24: A7          and  a
1A25: CA 3C 1D    jp   z,$1D3C
1A28: 3A 50 8F    ld   a,($8F50)
1A2B: A7          and  a
1A2C: 20 10       jr   nz,$1A3E
1A2E: 35          dec  (hl)
1A2F: 3E 01       ld   a,$01
1A31: 32 50 8F    ld   ($8F50),a
1A34: 32 01 89    ld   (nb_wolves_8901),a
1A37: 3E 40       ld   a,$40
1A39: 32 4A 8F    ld   ($8F4A),a
1A3C: 18 09       jr   $1A47
1A3E: AF          xor  a
1A3F: 21 45 8F    ld   hl,$8F45
1A42: 06 10       ld   b,$10
1A44: D7          rst  $10
1A45: 26 81       ld   h,$81
1A47: 2E 04       ld   l,$04
1A49: 36 00       ld   (hl),$00
1A4B: 11 40 89    ld   de,$8940
1A4E: 21 00 89    ld   hl,current_play_variables_8900
1A51: 01 3F 00    ld   bc,$003F
1A54: 3A 0D 88    ld   a,($880D)
1A57: A7          and  a
1A58: 28 03       jr   z,$1A5D
1A5A: 11 80 89    ld   de,$8980
1A5D: ED B0       ldir
1A5F: AF          xor  a
1A60: 32 0A 88    ld   (in_game_sub_state_880A),a
1A63: C9          ret
1A64: 3A 50 8F    ld   a,($8F50)
1A67: A7          and  a
1A68: 20 97       jr   nz,$1A01
1A6A: CD 4E 0F    call $0F4E
1A6D: CD 27 25    call $2527
1A70: AF          xor  a
1A71: 32 E3 89    ld   ($89E3),a
1A74: 3A 06 88    ld   a,($8806)
1A77: A7          and  a
1A78: CA 3C 1D    jp   z,$1D3C
1A7B: 21 08 89    ld   hl,nb_lives_8908
1A7E: 7E          ld   a,(hl)
1A7F: A7          and  a
1A80: 28 14       jr   z,$1A96
1A82: 35          dec  (hl)
1A83: 28 11       jr   z,$1A96
1A85: CD C2 03    call $03C2
1A88: 0E 0A       ld   c,$0A
1A8A: 3A 0D 88    ld   a,($880D)
1A8D: A7          and  a
1A8E: 28 01       jr   z,$1A91
1A90: 0C          inc  c
1A91: 79          ld   a,c
1A92: 32 0A 88    ld   (in_game_sub_state_880A),a
1A95: C9          ret
1A96: CD 92 0F    call $0F92
1A99: 21 0A 88    ld   hl,in_game_sub_state_880A
1A9C: 3A 0D 88    ld   a,($880D)
1A9F: A7          and  a
1AA0: 28 01       jr   z,$1AA3
1AA2: 34          inc  (hl)
1AA3: 34          inc  (hl)
1AA4: AF          xor  a
1AA5: 32 FC 89    ld   ($89FC),a
1AA8: 32 31 89    ld   ($8931),a
1AAB: 32 32 89    ld   ($8932),a
1AAE: CD B2 1A    call $1AB2
1AB1: C9          ret
1AB2: 01 1E 00    ld   bc,$001E
1AB5: 68          ld   l,b
1AB6: 11 03 00    ld   de,$0003
1AB9: DD 21 A2 88 ld   ix,$88A2
1ABD: 3A 0D 88    ld   a,($880D)
1AC0: 0F          rrca
1AC1: 30 02       jr   nc,$1AC5
1AC3: DD 19       add  ix,de
1AC5: FD 21 00 8A ld   iy,$8A00
1AC9: DD 7E 02    ld   a,(ix+$02)
1ACC: FD BE 02    cp   (iy+$02)
1ACF: 20 0E       jr   nz,$1ADF
1AD1: DD 7E 01    ld   a,(ix+$01)
1AD4: FD BE 01    cp   (iy+$01)
1AD7: 20 06       jr   nz,$1ADF
1AD9: DD 7E 00    ld   a,(ix+$00)
1ADC: FD BE 00    cp   (iy+$00)
1ADF: 30 09       jr   nc,$1AEA
1AE1: FD 19       add  iy,de
1AE3: 2C          inc  l
1AE4: 0D          dec  c
1AE5: 0D          dec  c
1AE6: 0D          dec  c
1AE7: C8          ret  z
1AE8: 18 DF       jr   $1AC9
1AEA: 7D          ld   a,l
1AEB: 3C          inc  a
1AEC: 32 FC 89    ld   ($89FC),a
1AEF: 3D          dec  a
1AF0: C5          push bc
1AF1: 21 1D 8A    ld   hl,$8A1D
1AF4: 11 20 8A    ld   de,$8A20
1AF7: ED B8       lddr
1AF9: 6F          ld   l,a
1AFA: DD 7E 00    ld   a,(ix+$00)
1AFD: FD 77 00    ld   (iy+$00),a
1B00: DD 7E 01    ld   a,(ix+$01)
1B03: FD 77 01    ld   (iy+$01),a
1B06: DD 7E 02    ld   a,(ix+$02)
1B09: FD 77 02    ld   (iy+$02),a
1B0C: C1          pop  bc
1B0D: C5          push bc
1B0E: DD 21 30 8A ld   ix,$8A30
1B12: 21 E1 89    ld   hl,$89E1
1B15: 3A 0D 88    ld   a,($880D)
1B18: A7          and  a
1B19: 28 05       jr   z,$1B20
1B1B: DD 21 33 8A ld   ix,$8A33
1B1F: 23          inc  hl
1B20: 36 01       ld   (hl),$01
1B22: 2E DD       ld   l,$DD
1B24: 11 E0 89    ld   de,$89E0
1B27: ED B8       lddr
1B29: DD 7E 02    ld   a,(ix+$02)
1B2C: 12          ld   (de),a
1B2D: 1B          dec  de
1B2E: DD 7E 01    ld   a,(ix+$01)
1B31: 12          ld   (de),a
1B32: C1          pop  bc
1B33: 21 1C 8E    ld   hl,$8E1C
1B36: 11 1F 8E    ld   de,$8E1F
1B39: ED B8       lddr
1B3B: EB          ex   de,hl
1B3C: 2B          dec  hl
1B3D: 3E 10       ld   a,$10
1B3F: 06 03       ld   b,$03
1B41: D7          rst  $10
1B42: C9          ret
1B43: CD C9 02    call $02C9
1B46: C0          ret  nz
1B47: CD E3 02    call $02E3
1B4A: 01 19 08    ld   bc,$0819
1B4D: CD 5D 07    call $075D
1B50: 11 00 06    ld   de,$0600
1B53: FF          rst  $38
1B54: 1E 02       ld   e,$02
1B56: FF          rst  $38
1B57: CD 60 79    call $7960
1B5A: 3E 0C       ld   a,$0C
1B5C: 32 0A 88    ld   (in_game_sub_state_880A),a
1B5F: AF          xor  a
1B60: 32 08 88    ld   ($8808),a
1B63: 11 93 55    ld   de,$5593
1B66: 01 00 22    ld   bc,$2200
1B69: 1A          ld   a,(de)
1B6A: E6 37       and  $37
1B6C: 0F          rrca
1B6D: 89          adc  a,c
1B6E: 4F          ld   c,a
1B6F: 13          inc  de
1B70: 10 F7       djnz $1B69
1B72: FE 7C       cp   $7C
1B74: 28 04       jr   z,$1B7A
1B76: 21 1E 88    ld   hl,$881E
1B79: 34          inc  (hl)
1B7A: 11 F2 1F    ld   de,$1FF2
1B7D: 21 F0 89    ld   hl,$89F0
1B80: 1A          ld   a,(de)
1B81: FE A0       cp   $A0
1B83: C8          ret  z
1B84: C6 08       add  a,$08
1B86: 77          ld   (hl),a
1B87: 13          inc  de
1B88: 23          inc  hl
1B89: 18 F5       jr   $1B80
1B8B: C9          ret
1B8C: CD C9 02    call $02C9
1B8F: C0          ret  nz
1B90: 01 19 08    ld   bc,$0819
1B93: CD 5D 07    call $075D
1B96: 11 00 06    ld   de,$0600
1B99: FF          rst  $38
1B9A: 1E 03       ld   e,$03
1B9C: FF          rst  $38
1B9D: CD 60 79    call $7960
1BA0: 3E 0C       ld   a,$0C
1BA2: 32 0A 88    ld   (in_game_sub_state_880A),a
1BA5: 3E 60       ld   a,$60
1BA7: 32 08 88    ld   ($8808),a
1BAA: C9          ret
1BAB: 3A 0E 88    ld   a,($880E)
1BAE: A7          and  a
1BAF: 28 0B       jr   z,$1BBC
1BB1: 3A 88 89    ld   a,($8988)
1BB4: A7          and  a
1BB5: 28 05       jr   z,$1BBC
1BB7: 3E 01       ld   a,$01
1BB9: 32 0D 88    ld   ($880D),a
1BBC: 11 40 89    ld   de,$8940
1BBF: 21 00 89    ld   hl,current_play_variables_8900
1BC2: 01 3F 00    ld   bc,$003F
1BC5: ED B0       ldir
1BC7: AF          xor  a
1BC8: 32 0A 88    ld   (in_game_sub_state_880A),a
1BCB: C9          ret
1BCC: 3A 48 89    ld   a,($8948)
1BCF: A7          and  a
1BD0: 28 04       jr   z,$1BD6
1BD2: AF          xor  a
1BD3: 32 0D 88    ld   ($880D),a
1BD6: 11 80 89    ld   de,$8980
1BD9: 21 00 89    ld   hl,current_play_variables_8900
1BDC: 01 3F 00    ld   bc,$003F
1BDF: ED B0       ldir
1BE1: AF          xor  a
1BE2: 32 0A 88    ld   (in_game_sub_state_880A),a
1BE5: 21 28 53    ld   hl,$5328
1BE8: 06 0E       ld   b,$0E
1BEA: 7E          ld   a,(hl)
1BEB: E6 1F       and  $1F
1BED: 83          add  a,e
1BEE: 5F          ld   e,a
1BEF: 30 01       jr   nc,$1BF2
1BF1: 14          inc  d
1BF2: 23          inc  hl
1BF3: 10 F5       djnz $1BEA
1BF5: 3E 60       ld   a,$60
1BF7: BB          cp   e
1BF8: 20 04       jr   nz,$1BFE
1BFA: 3E 8A       ld   a,$8A
1BFC: 92          sub  d
1BFD: C8          ret  z
1BFE: 21 38 8A    ld   hl,$8A38
1C01: 34          inc  (hl)
1C02: C9          ret
1C03: 21 08 88    ld   hl,$8808
1C06: 35          dec  (hl)
1C07: C0          ret  nz
1C08: 3E 82       ld   a,$82
1C0A: CD B2 05    call $05B2
1C0D: 3E 80       ld   a,$80
1C0F: CD B2 05    call $05B2
1C12: 3E 89       ld   a,$89
1C14: CD B2 05    call $05B2
1C17: 01 D9 07    ld   bc,$07D9
1C1A: CD 5D 07    call $075D
1C1D: CD E9 03    call $03E9
1C20: 11 11 06    ld   de,$0611
1C23: FF          rst  $38
1C24: 21 0A 88    ld   hl,in_game_sub_state_880A
1C27: 36 0E       ld   (hl),$0E
1C29: 3A FC 89    ld   a,($89FC)
1C2C: A7          and  a
1C2D: C8          ret  z
1C2E: 21 45 80    ld   hl,$8045
1C31: 47          ld   b,a
1C32: 2C          inc  l
1C33: 2C          inc  l
1C34: 10 FC       djnz $1C32
1C36: 22 FD 89    ld   ($89FD),hl
1C39: CD C1 0F    call $0FC1
1C3C: 21 FF 89    ld   hl,$89FF
1C3F: 36 07       ld   (hl),$07
1C41: 11 54 17    ld   de,table_1754
1C44: 21 F0 89    ld   hl,$89F0
1C47: 1A          ld   a,(de)
1C48: FE 5A       cp   $5A
1C4A: C8          ret  z
1C4B: CB 17       rl   a
1C4D: 77          ld   (hl),a
1C4E: 13          inc  de
1C4F: 23          inc  hl
1C50: 18 F5       jr   $1C47
1C52: C9          ret
1C53: 3A 07 89    ld   a,($8907)
1C56: E6 01       and  $01
1C58: 20 05       jr   nz,$1C5F
1C5A: CD E2 64    call $64E2
1C5D: 18 03       jr   $1C62
1C5F: CD F8 68    call $68F8
1C62: CD EF 02    call update_sprite_shadows_02EF
1C65: C9          ret

1C66: 21 08 88    ld   hl,$8808
1C69: 35          dec  (hl)
1C6A: 3A 2A 8E    ld   a,($8E2A)
1C6D: A7          and  a
1C6E: 28 04       jr   z,$1C74
1C70: 7E          ld   a,(hl)
1C71: A7          and  a
1C72: 28 28       jr   z,$1C9C
1C74: CD 94 7E    call $7E94
1C77: 3A FC 89    ld   a,($89FC)
1C7A: A7          and  a
1C7B: C8          ret  z
1C7C: 3A 08 88    ld   a,($8808)
1C7F: E6 07       and  $07
1C81: C0          ret  nz
1C82: 3A FF 89    ld   a,($89FF)
1C85: 2A FD 89    ld   hl,($89FD)
1C88: 11 20 00    ld   de,$0020
1C8B: 06 1C       ld   b,$1C
1C8D: 77          ld   (hl),a
1C8E: 19          add  hl,de
1C8F: 10 FC       djnz $1C8D
1C91: 3C          inc  a
1C92: FE 10       cp   $10
1C94: 38 02       jr   c,$1C98
1C96: 3E 06       ld   a,$06
1C98: 32 FF 89    ld   ($89FF),a
1C9B: C9          ret
1C9C: 21 5F 85    ld   hl,$855F
1C9F: 11 E0 FF    ld   de,$FFE0
1CA2: 06 08       ld   b,$08
1CA4: 3E 10       ld   a,$10
1CA6: 77          ld   (hl),a
1CA7: 19          add  hl,de
1CA8: 10 FA       djnz $1CA4
1CAA: 21 BC 82    ld   hl,$82BC
1CAD: 11 E0 FF    ld   de,$FFE0
1CB0: 01 00 0A    ld   bc,$0A00
1CB3: 7E          ld   a,(hl)
1CB4: 81          add  a,c
1CB5: 4F          ld   c,a
1CB6: 19          add  hl,de
1CB7: 10 FA       djnz $1CB3
1CB9: 79          ld   a,c
1CBA: FE AA       cp   $AA
1CBC: C0          ret  nz
1CBD: AF          xor  a
1CBE: 32 2A 8E    ld   ($8E2A),a
1CC1: 3A 0E 88    ld   a,($880E)
1CC4: A7          and  a
1CC5: 28 4E       jr   z,$1D15
1CC7: 3A 0D 88    ld   a,($880D)
1CCA: A7          and  a
1CCB: 28 29       jr   z,$1CF6
1CCD: 3A 48 89    ld   a,($8948)
1CD0: A7          and  a
1CD1: 28 42       jr   z,$1D15
1CD3: AF          xor  a
1CD4: 32 0D 88    ld   ($880D),a
1CD7: 32 0A 88    ld   (in_game_sub_state_880A),a
1CDA: 21 80 89    ld   hl,$8980
1CDD: 06 3F       ld   b,$3F
1CDF: D7          rst  $10
1CE0: 3C          inc  a
1CE1: 32 1F 88    ld   ($881F),a
1CE4: CD E3 02    call $02E3
1CE7: 21 E0 84    ld   hl,$84E0
1CEA: 36 02       ld   (hl),$02
1CEC: 11 E0 FF    ld   de,$FFE0
1CEF: 19          add  hl,de
1CF0: 36 25       ld   (hl),$25
1CF2: 19          add  hl,de
1CF3: 36 20       ld   (hl),$20
1CF5: C9          ret
1CF6: 3A 88 89    ld   a,($8988)
1CF9: A7          and  a
1CFA: 28 19       jr   z,$1D15
1CFC: AF          xor  a
1CFD: 32 0A 88    ld   (in_game_sub_state_880A),a
1D00: 21 40 89    ld   hl,$8940
1D03: 06 3F       ld   b,$3F
1D05: D7          rst  $10
1D06: 3C          inc  a
1D07: 32 0D 88    ld   ($880D),a
1D0A: CD E3 02    call $02E3
1D0D: 21 40 87    ld   hl,$8740
1D10: 36 01       ld   (hl),$01
1D12: 18 D8       jr   $1CEC
1D14: C9          ret
1D15: AF          xor  a
1D16: 21 00 89    ld   hl,current_play_variables_8900
1D19: 06 BF       ld   b,$BF
1D1B: D7          rst  $10
1D1C: 3A 0E 88    ld   a,($880E)
1D1F: A7          and  a
1D20: CC 0D 1D    call z,$1D0D
1D23: C4 E7 1C    call nz,$1CE7
1D26: 3A 02 88    ld   a,(nb_credits_8802)
1D29: A7          and  a
1D2A: 28 10       jr   z,$1D3C
1D2C: AF          xor  a
1D2D: 32 06 88    ld   ($8806),a
1D30: 32 0A 88    ld   (in_game_sub_state_880A),a
1D33: 3C          inc  a
1D34: 32 1F 88    ld   ($881F),a
1D37: 3C          inc  a
1D38: 32 05 88    ld   (game_state_8805),a
1D3B: C9          ret
1D3C: AF          xor  a
1D3D: 32 06 88    ld   ($8806),a
1D40: 32 0A 88    ld   (in_game_sub_state_880A),a
1D43: 32 0D 88    ld   ($880D),a
1D46: 32 0E 88    ld   ($880E),a
1D49: 32 51 8E    ld   (title_sub_state_8E51),a
1D4C: 3C          inc  a
1D4D: 32 05 88    ld   (game_state_8805),a
1D50: 32 1F 88    ld   ($881F),a
1D53: 32 3F 8F    ld   ($8F3F),a
1D56: CD B9 02    call $02B9
1D59: CD CF 0E    call $0ECF
1D5C: 11 4C 1E    ld   de,$1E4C
1D5F: 21 F0 89    ld   hl,$89F0
1D62: 1A          ld   a,(de)
1D63: FE 7F       cp   $7F
1D65: C8          ret  z
1D66: CB 3F       srl  a
1D68: 77          ld   (hl),a
1D69: 13          inc  de
1D6A: 23          inc  hl
1D6B: 18 F5       jr   $1D62
1D6D: C9          ret
1D6E: 21 4A 8F    ld   hl,$8F4A
1D71: 7E          ld   a,(hl)
1D72: 35          dec  (hl)
1D73: FE 40       cp   $40
1D75: 20 0B       jr   nz,$1D82
1D77: CD E9 79    call $79E9
1D7A: 11 26 06    ld   de,$0626
1D7D: FF          rst  $38
1D7E: CD 44 0F    call $0F44
1D81: C9          ret
1D82: A7          and  a
1D83: C0          ret  nz
1D84: 32 0A 88    ld   (in_game_sub_state_880A),a
1D87: 2E 50       ld   l,$50
1D89: 36 02       ld   (hl),$02
1D8B: 21 07 8D    ld   hl,$8D07
1D8E: 36 40       ld   (hl),$40
1D90: 3A 07 89    ld   a,($8907)
1D93: CB 4F       bit  1,a
1D95: C0          ret  nz
1D96: 3E 01       ld   a,$01
1D98: 32 61 8F    ld   ($8F61),a
1D9B: C9          ret
1D9C: 3A 07 89    ld   a,($8907)
1D9F: CB 4F       bit  1,a
1DA1: 20 04       jr   nz,$1DA7
1DA3: CD D5 0F    call $0FD5
1DA6: C9          ret
1DA7: CD A6 6D    call $6DA6
1DAA: 21 4C 58    ld   hl,$584C
1DAD: 7D          ld   a,l
1DAE: D6 24       sub  $24
1DB0: 6F          ld   l,a
1DB1: 24          inc  h
1DB2: 24          inc  h
1DB3: 01 20 20    ld   bc,$2020
1DB6: AF          xor  a
1DB7: CB 46       bit  0,(hl)
1DB9: 28 01       jr   z,$1DBC
1DBB: 3C          inc  a
1DBC: CB 5E       bit  3,(hl)
1DBE: 20 01       jr   nz,$1DC1
1DC0: 3C          inc  a
1DC1: 10 F4       djnz $1DB7
1DC3: B9          cp   c
1DC4: C8          ret  z
1DC5: 3E 01       ld   a,$01
1DC7: 32 E7 89    ld   ($89E7),a
1DCA: C9          ret
1DCB: 10 12       djnz $1DDF
1DCD: 14          inc  d
1DCE: 18 1A       jr   $1DEA
1DD0: 1C          inc  e
1DD1: 1E 20       ld   e,$20
1DD3: 3A 04 89    ld   a,($8904)
1DD6: A7          and  a
1DD7: 21 07 89    ld   hl,$8907
1DDA: 20 0F       jr   nz,$1DEB
1DDC: 3A 06 88    ld   a,($8806)
1DDF: A7          and  a
1DE0: 28 09       jr   z,$1DEB
1DE2: 7E          ld   a,(hl)
1DE3: CB 47       bit  0,a
1DE5: 20 2A       jr   nz,$1E11
1DE7: 7E          ld   a,(hl)
1DE8: A7          and  a
1DE9: 28 26       jr   z,$1E11
1DEB: 7E          ld   a,(hl)
1DEC: E6 01       and  $01
1DEE: 01 39 08    ld   bc,$0839
1DF1: 20 03       jr   nz,$1DF6
1DF3: 01 79 08    ld   bc,$0879
1DF6: CD 5D 07    call $075D
1DF9: 3E 0F       ld   a,$0F
1DFB: 21 45 80    ld   hl,$8045
1DFE: 11 20 00    ld   de,$0020
1E01: 06 04       ld   b,$04
1E03: 77          ld   (hl),a
1E04: 19          add  hl,de
1E05: 10 FC       djnz $1E03
1E07: 21 46 80    ld   hl,$8046
1E0A: 06 04       ld   b,$04
1E0C: 77          ld   (hl),a
1E0D: 19          add  hl,de
1E0E: 10 FC       djnz $1E0C
1E10: C9          ret
1E11: 3A 50 8F    ld   a,($8F50)
1E14: A7          and  a
1E15: 20 D4       jr   nz,$1DEB
1E17: 01 59 08    ld   bc,$0859
1E1A: CD 5D 07    call $075D
1E1D: 21 1C 81    ld   hl,$811C
1E20: 11 20 00    ld   de,$0020
1E23: 06 10       ld   b,$10
1E25: 3E 09       ld   a,$09
1E27: 77          ld   (hl),a
1E28: 19          add  hl,de
1E29: 10 FC       djnz $1E27
1E2B: C9          ret

1E55: 21 E5 89    ld   hl,$89E5
1E58: 46          ld   b,(hl)
1E59: 7D          ld   a,l
1E5A: C6 16       add  a,$16
1E5C: 6F          ld   l,a
1E5D: 78          ld   a,b
1E5E: B6          or   (hl)
1E5F: A7          and  a
1E60: DD 21 80 8A ld   ix,top_basket_object_8A80
1E64: 20 3C       jr   nz,$1EA2
1E66: 3A 06 88    ld   a,($8806)
1E69: A7          and  a
1E6A: C8          ret  z
1E6B: FD 21 90 8C ld   iy,$8C90
1E6F: DD 7E 02    ld   a,(ix+$02)
1E72: A7          and  a
1E73: 20 2D       jr   nz,$1EA2
1E75: 3A 24 8F    ld   a,($8F24)
1E78: 21 57 8F    ld   hl,$8F57
1E7B: B6          or   (hl)
1E7C: 20 24       jr   nz,$1EA2
1E7E: 3A 1F 88    ld   a,($881F)
1E81: A7          and  a
1E82: 3A A0 A0    ld   a,(in1_a0a0)
1E85: 20 03       jr   nz,$1E8A
1E87: 3A C0 A0    ld   a,(in2_a0c0)
1E8A: 2F          cpl
1E8B: DD 77 07    ld   (ix+$07),a
1E8E: 17          rla
1E8F: 17          rla
1E90: 17          rla
1E91: 21 03 8F    ld   hl,$8F03
1E94: 17          rla
1E95: CB 16       rl   (hl)
1E97: 7E          ld   a,(hl)
1E98: E6 07       and  $07
1E9A: FE 01       cp   $01
1E9C: C8          ret  z
1E9D: DD CB 07 A6 res  4,(ix+$07)
1EA1: C9          ret
1EA2: DD 36 07 00 ld   (ix+$07),$00
1EA6: C9          ret
1EA7: 22 1F 25    ld   ($251F),hl
1EAA: 1E 14       ld   e,$14
1EAC: 10 3A       djnz $1EE8
1EAE: 1E 88       ld   e,$88
1EB0: A7          and  a
1EB1: 20 5E       jr   nz,$1F11
1EB3: 21 5F 85    ld   hl,$855F
1EB6: 01 A7 1E    ld   bc,$1EA7
1EB9: 11 E0 FF    ld   de,$FFE0
1EBC: 0A          ld   a,(bc)
1EBD: 77          ld   (hl),a
1EBE: 03          inc  bc
1EBF: 19          add  hl,de
1EC0: FE 10       cp   $10
1EC2: 20 F8       jr   nz,$1EBC
1EC4: 3A 07 89    ld   a,($8907)
1EC7: 3C          inc  a
1EC8: 47          ld   b,a
1EC9: AF          xor  a
1ECA: C6 01       add  a,$01
1ECC: 27          daa
1ECD: 10 FB       djnz $1ECA
1ECF: F5          push af
1ED0: F5          push af
1ED1: F5          push af
1ED2: CB 3F       srl  a
1ED4: CB 3F       srl  a
1ED6: CB 3F       srl  a
1ED8: CB 3F       srl  a
1EDA: 21 9F 84    ld   hl,$849F
1EDD: A7          and  a
1EDE: 20 02       jr   nz,$1EE2
1EE0: 3E 10       ld   a,$10
1EE2: 77          ld   (hl),a
1EE3: F1          pop  af
1EE4: E6 0F       and  $0F
1EE6: 21 7F 84    ld   hl,$847F
1EE9: 77          ld   (hl),a
1EEA: F1          pop  af
1EEB: CB 3F       srl  a
1EED: CB 3F       srl  a
1EEF: CB 3F       srl  a
1EF1: CB 3F       srl  a
1EF3: E6 01       and  $01
1EF5: 21 0D 20    ld   hl,$200D
1EF8: CD 45 0C    call $0C45
1EFB: 21 62 84    ld   hl,$8462
1EFE: CD 07 33    call $3307
1F01: 21 22 87    ld   hl,$8722
1F04: CD 8C 1F    call update_flag_1F8C
1F07: F1          pop  af
1F08: 47          ld   b,a
1F09: E6 0F       and  $0F
1F0B: 32 83 84    ld   ($8483),a
1F0E: CD FB 1F    call $1FFB
1F11: CD 18 1F    call $1F18
1F14: CD C9 34    call $34C9
1F17: C9          ret
1F18: 21 E7 89    ld   hl,$89E7
1F1B: 06 07       ld   b,$07
1F1D: 7E          ld   a,(hl)
1F1E: 23          inc  hl
1F1F: B6          or   (hl)
1F20: C0          ret  nz
1F21: 10 FA       djnz $1F1D
1F23: 0E 00       ld   c,$00
1F25: 2E 01       ld   l,$01
1F27: 7E          ld   a,(hl)
1F28: D6 0A       sub  $0A
1F2A: 38 22       jr   c,$1F4E
1F2C: 0C          inc  c
1F2D: 18 F9       jr   $1F28
1F2F: 3A 56 8D    ld   a,($8D56)
1F32: A7          and  a
1F33: C0          ret  nz
1F34: 4F          ld   c,a
1F35: 3A 01 89    ld   a,(nb_wolves_8901)
1F38: FE 0A       cp   $0A
1F3A: 38 0D       jr   c,$1F49
1F3C: 21 87 1F    ld   hl,table_1F87
1F3F: 06 05       ld   b,$05
1F41: BE          cp   (hl)
1F42: 28 0A       jr   z,$1F4E
1F44: 0C          inc  c
1F45: 23          inc  hl
1F46: 10 F9       djnz $1F41
1F48: C9          ret
1F49: 3E 01       ld   a,$01
1F4B: 32 56 8D    ld   ($8D56),a
1F4E: 79          ld   a,c
1F4F: A7          and  a
1F50: 20 28       jr   nz,$1F7A
1F52: 3A 07 89    ld   a,($8907)
1F55: C6 01       add  a,$01
1F57: 47          ld   b,a
1F58: AF          xor  a
1F59: C6 01       add  a,$01
1F5B: 27          daa
1F5C: 10 FB       djnz $1F59
1F5E: 11 E6 1F    ld   de,$1FE6
1F61: CB 67       bit  4,a
1F63: 20 03       jr   nz,$1F68
1F65: 11 DA 1F    ld   de,$1FDA
1F68: 21 22 87    ld   hl,$8722
1F6B: CD 8C 1F    call update_flag_1F8C
1F6E: 3E 10       ld   a,$10
1F70: 06 03       ld   b,$03
1F72: D7          rst  $10
1F73: 3A 01 89    ld   a,(nb_wolves_8901)
1F76: 32 43 87    ld   ($8743),a
1F79: AF          xor  a
1F7A: 21 A3 1F    ld   hl,$1FA3
1F7D: CD 45 0C    call $0C45
1F80: 21 22 83    ld   hl,$8322
1F83: CD 8C 1F    call update_flag_1F8C
1F86: C9          ret

table_1F87:
  .byte 	09 14 1E 28 30 3E 04 ED 47
 
; < HL: screen address
1F8C: 3E 04       ld   a,$04                                          
1F8E: ED 47       ld   i,a                                            
1F90: 06 03       ld   b,$03
1F92: 1A          ld   a,(de)
1F93: 77          ld   (hl),a		; write video
1F94: 2C          inc  l
1F95: 13          inc  de
1F96: 10 FA       djnz $1F92
1F98: 0E 1D       ld   c,$1D
1F9A: 09          add  hl,bc
1F9B: ED 57       ld   a,i
1F9D: 3D          dec  a
1F9E: C8          ret  z
1F9F: ED 47       ld   i,a
1FA1: 18 ED       jr   $1F90


1FFB: 78          ld   a,b                                            
1FFC: CB 6F       bit  5,a
1FFE: 11 3B 20    ld   de,$203B
2001: 28 03       jr   z,$2006
2003: 11 50 20    ld   de,$2050
2006: 21 62 80    ld   hl,$8062
2009: CD 07 33    call $3307
200C: C9          ret

2065: 21 3F 86    ld   hl,$863F
2068: 11 E0 FF    ld   de,$FFE0
206B: 3A 08 89    ld   a,(nb_lives_8908)
206E: A7          and  a
206F: C8          ret  z
2070: 3D          dec  a
2071: 4F          ld   c,a
2072: 28 0D       jr   z,$2081
2074: FE 05       cp   $05
2076: 38 02       jr   c,$207A
2078: 3E 05       ld   a,$05
207A: 4F          ld   c,a
207B: 47          ld   b,a
207C: 36 B0       ld   (hl),$B0
207E: 19          add  hl,de
207F: 10 FB       djnz $207C
2081: 3E 05       ld   a,$05
2083: 91          sub  c
2084: C8          ret  z
2085: 47          ld   b,a
2086: 36 10       ld   (hl),$10
2088: 19          add  hl,de
2089: 10 FB       djnz $2086
208B: C9          ret

; compare 2 parts of ROM. If not equal
; then set a flag, then game can't start
anti_hack_check_208C:
208C: 21 6D 06    ld   hl,irq_066D
208F: 06 10       ld   b,$10
2091: 11 AA 20    ld   de,$20AA
2094: 1A          ld   a,(de)
2095: BE          cp   (hl)
2096: 20 0C       jr   nz,rom_corrupt_20A4
2098: 13          inc  de
2099: 00          nop
209A: 3E 08       ld   a,$08
209C: 85          add  a,l
209D: 30 01       jr   nc,$20A0
209F: 24          inc  h
20A0: 6F          ld   l,a
20A1: 10 F1       djnz $2094
20A3: C9          ret

rom_corrupt_20A4:
20A4: 3E 01       ld   a,$01
20A6: 32 F0 8E    ld   (checksum_failed_8EF0),a
20A9: C9          ret

20AA: F5          push af
20AB: D5          push de
20AC: 80          add  a,b
20AD: 94          sub  h
20AE: 88          adc  a,b
20AF: 18 03       jr   $20B4


20D4: 21 32 8D    ld   hl,$8D32
20D7: 3A 50 8F    ld   a,($8F50)
20DA: A7          and  a
20DB: 28 0B       jr   z,$20E8
20DD: 36 00       ld   (hl),$00
20DF: 45          ld   b,l
20E0: 2E F8       ld   l,$F8
20E2: 7E          ld   a,(hl)
20E3: 23          inc  hl
20E4: A6          and  (hl)
20E5: 20 03       jr   nz,$20EA
20E7: 68          ld   l,b
20E8: 7E          ld   a,(hl)
20E9: A7          and  a
20EA: C2 1E 24    jp   nz,$241E
20ED: DD 21 80 8A ld   ix,top_basket_object_8A80
20F1: CD 29 23    call $2329
20F4: CD 01 21    call $2101
20F7: CD 63 25    call $2563
20FA: CD A6 25    call $25A6
20FD: CD 8B 30    call $308B
2100: C9          ret
2101: CD 78 27    call $2778
2104: CD 0B 21    call $210B
2107: CD 57 21    call $2157
210A: C9          ret

210B: DD 21 80 8A ld   ix,top_basket_object_8A80
210F: DD CB 07 66 bit  4,(ix+$07)
2113: DD 36 07 00 ld   (ix+$07),$00
2117: C8          ret  z
2118: 21 02 8F    ld   hl,$8F02
211B: 7E          ld   a,(hl)
211C: A7          and  a
211D: C0          ret  nz
211E: 34          inc  (hl)
211F: FD 21 90 8C ld   iy,$8C90
2123: 3A 30 8F    ld   a,($8F30)
2126: FE 02       cp   $02
2128: 38 15       jr   c,$213F
212A: FD 7E 18    ld   a,(iy+$18)
212D: FE 02       cp   $02
212F: 20 0E       jr   nz,$213F
2131: FD 7E 00    ld   a,(iy+$00)
2134: A7          and  a
2135: 20 08       jr   nz,$213F
2137: FD 36 18 00 ld   (iy+$18),$00
213B: FD CB 00 CE set  1,(iy+$00)
213F: 11 18 00    ld   de,$0018
2142: 06 02       ld   b,$02
2144: FD CB 00 46 bit  0,(iy+$00)
2148: 28 3A       jr   z,$2184
214A: FD 19       add  iy,de
214C: 10 F6       djnz $2144
214E: DD 54       ld   d,ixh
2150: 1E 3C       ld   e,$3C
2152: 1A          ld   a,(de)
2153: A7          and  a
2154: 20 01       jr   nz,$2157
2156: C9          ret
2157: FD 21 90 8C ld   iy,$8C90
215B: 3E 02       ld   a,$02
215D: 32 15 8F    ld   ($8F15),a
2160: FD CB 00 46 bit  0,(iy+$00)
2164: C4 CF 21    call nz,$21CF
2167: 11 18 00    ld   de,$0018
216A: FD 19       add  iy,de
216C: 3A 15 8F    ld   a,($8F15)
216F: D6 01       sub  $01
2171: 20 EA       jr   nz,$215D
2173: 3A 00 8F    ld   a,($8F00)
2176: 11 C9 26    ld   de,$26C9
2179: D6 0C       sub  $0C
217B: 93          sub  e
217C: C2 B1 22    jp   nz,$22B1
217F: AF          xor  a
2180: 32 02 8F    ld   ($8F02),a
2183: C9          ret
2184: FD CB 00 C6 set  0,(iy+$00)
2188: DD 7E 04    ld   a,(ix+$04)
218B: D6 03       sub  $03
218D: FD 77 04    ld   (iy+$04),a
2190: DD 7E 06    ld   a,(ix+$06)
2193: C6 04       add  a,$04
2195: FD 77 06    ld   (iy+$06),a
2198: FD CB 00 4E bit  1,(iy+$00)
219C: 20 0A       jr   nz,$21A8
219E: FD 36 0F 14 ld   (iy+$0f),$14
21A2: FD 36 10 40 ld   (iy+$10),$40
21A6: 18 14       jr   $21BC
21A8: FD 36 0F 10 ld   (iy+$0f),$10
21AC: FD 36 10 40 ld   (iy+$10),$40
21B0: 3E 01       ld   a,$01
21B2: 32 77 8D    ld   ($8D77),a
21B5: AF          xor  a
21B6: 21 98 8A    ld   hl,$8A98
21B9: 06 18       ld   b,$18
21BB: D7          rst  $10
21BC: 21 19 8D    ld   hl,$8D19
21BF: FD E5       push iy
21C1: D1          pop  de
21C2: AF          xor  a
21C3: CB 5B       bit  3,e
21C5: 28 01       jr   z,$21C8
21C7: 23          inc  hl
21C8: 77          ld   (hl),a
21C9: 23          inc  hl
21CA: 23          inc  hl
21CB: 77          ld   (hl),a
21CC: C3 B1 22    jp   $22B1
21CF: FD CB 07 46 bit  0,(iy+$07)
21D3: 20 2F       jr   nz,$2204
21D5: FD 7E 12    ld   a,(iy+$12)
21D8: A7          and  a
21D9: 20 06       jr   nz,$21E1
21DB: FD 34 12    inc  (iy+$12)
21DE: CD D2 0E    call $0ED2
21E1: FD CB 00 4E bit  1,(iy+$00)
21E5: 20 3F       jr   nz,$2226
21E7: FD 7D       ld   a,iyl
21E9: CB 5F       bit  3,a
21EB: 21 1B 8D    ld   hl,$8D1B
21EE: 28 01       jr   z,$21F1
21F0: 23          inc  hl
21F1: 7E          ld   a,(hl)
21F2: A7          and  a
21F3: 28 04       jr   z,$21F9
21F5: 36 00       ld   (hl),$00
21F7: 18 25       jr   $221E
21F9: FD 7E 06    ld   a,(iy+$06)
21FC: D6 04       sub  $04			; arrow speed
21FE: 38 1E       jr   c,$221E
2200: FD 77 06    ld   (iy+$06),a
2203: C9          ret
2204: FD 7E 01    ld   a,(iy+$01)
2207: FE 01       cp   $01
2209: D8          ret  c
220A: 20 07       jr   nz,$2213
220C: FD 36 0F 1B ld   (iy+$0f),$1B
2210: FD 34 01    inc  (iy+$01)
2213: FD 7E 04    ld   a,(iy+$04)
2216: C6 04       add  a,$04			; arrow speed
2218: FD 77 04    ld   (iy+$04),a
221B: FE E8       cp   $E8
221D: D8          ret  c
221E: FD E5       push iy
2220: E1          pop  hl
2221: 06 18       ld   b,$18
2223: AF          xor  a
2224: D7          rst  $10
2225: C9          ret
2226: 3A 0E 8F    ld   a,($8F0E)
2229: A7          and  a
222A: CC 82 22    call z,$2282
222D: ED 5B 10 8F ld   de,($8F10)
2231: FD 7D       ld   a,iyl
2233: CB 5F       bit  3,a
2235: FD 6E 05    ld   l,(iy+$05)
2238: FD 66 06    ld   h,(iy+$06)
223B: 01 19 8D    ld   bc,$8D19
223E: 28 01       jr   z,$2241
2240: 03          inc  bc
2241: 0A          ld   a,(bc)
2242: CB 47       bit  0,a
2244: 28 03       jr   z,$2249
2246: 19          add  hl,de
2247: 18 02       jr   $224B
2249: ED 52       sbc  hl,de
224B: FD 75 05    ld   (iy+$05),l
224E: FD 74 06    ld   (iy+$06),h
2251: ED 5B 12 8F ld   de,($8F12)
2255: FD 6E 03    ld   l,(iy+$03)
2258: FD 66 04    ld   h,(iy+$04)
225B: 19          add  hl,de
225C: 7C          ld   a,h
225D: FE E8       cp   $E8
225F: 30 0B       jr   nc,$226C
2261: FD 75 03    ld   (iy+$03),l
2264: FD 74 04    ld   (iy+$04),h
2267: 21 0E 8F    ld   hl,$8F0E
226A: 35          dec  (hl)
226B: C9          ret
226C: AF          xor  a
226D: 32 0E 8F    ld   ($8F0E),a
2270: 32 0F 8F    ld   (meat_speed_8F0F),a
2273: 32 30 8F    ld   ($8F30),a
2276: 32 45 8D    ld   ($8D45),a
2279: 32 77 8D    ld   ($8D77),a
227C: 32 3F 8F    ld   ($8F3F),a
227F: 18 9D       jr   $221E
2281: C9          ret
2282: 3A 0F 8F    ld   a,(meat_speed_8F0F)
2285: 21 12 27    ld   hl,$2712
2288: E7          rst  $20
2289: 32 0E 8F    ld   ($8F0E),a
228C: 3A 0F 8F    ld   a,(meat_speed_8F0F)
228F: 21 1C 27    ld   hl,$271C
2292: CD 45 0C    call $0C45
2295: ED 53 10 8F ld   ($8F10),de
2299: 3A 0F 8F    ld   a,(meat_speed_8F0F)
229C: 21 30 27    ld   hl,$2730
229F: CD 45 0C    call $0C45
22A2: ED 53 12 8F ld   ($8F12),de
22A6: 21 0F 8F    ld   hl,meat_speed_8F0F
22A9: 34          inc  (hl)
22AA: 7E          ld   a,(hl)
22AB: FE 09       cp   $09
22AD: C0          ret  nz
22AE: 36 08       ld   (hl),$08
22B0: C9          ret
22B1: 3A 32 8D    ld   a,($8D32)
22B4: A7          and  a
22B5: C0          ret  nz
22B6: DD 21 80 8A ld   ix,top_basket_object_8A80
22BA: CD E6 22    call $22E6
22BD: 11 18 00    ld   de,$0018
22C0: DD 19       add  ix,de
22C2: CD E6 22    call $22E6
22C5: DD 19       add  ix,de
22C7: CD E6 22    call $22E6
22CA: DD 19       add  ix,de
22CC: CD E6 22    call $22E6
22CF: C9          ret
22D0: FD 21 90 8C ld   iy,$8C90
22D4: 11 18 00    ld   de,$0018
22D7: 06 02       ld   b,$02
22D9: AF          xor  a
22DA: FD CB 00 46 bit  0,(iy+$00)
22DE: 28 01       jr   z,$22E1
22E0: 07          rlca
22E1: FD 19       add  iy,de
22E3: 10 F5       djnz $22DA
22E5: C9          ret
22E6: DD 7E 0E    ld   a,(ix+$0e)
22E9: A7          and  a
22EA: 28 04       jr   z,$22F0
22EC: DD 35 0E    dec  (ix+$0e)
22EF: C9          ret
22F0: 2A 00 8F    ld   hl,($8F00)
22F3: 7E          ld   a,(hl)
22F4: FE FF       cp   $FF
22F6: 28 12       jr   z,$230A
22F8: DD 77 10    ld   (ix+$10),a
22FB: 23          inc  hl
22FC: 7E          ld   a,(hl)
22FD: DD 77 0F    ld   (ix+$0f),a
2300: 23          inc  hl
2301: 7E          ld   a,(hl)
2302: DD 77 0E    ld   (ix+$0e),a
2305: 23          inc  hl
2306: 22 00 8F    ld   ($8F00),hl
2309: C9          ret
230A: CD D0 22    call $22D0
230D: FE 03       cp   $03
230F: 20 08       jr   nz,$2319
2311: 21 E7 26    ld   hl,$26E7
2314: 22 00 8F    ld   ($8F00),hl
2317: 18 D7       jr   $22F0
2319: 23          inc  hl
231A: 7E          ld   a,(hl)
231B: 32 00 8F    ld   ($8F00),a
231E: 23          inc  hl
231F: 7E          ld   a,(hl)
2320: 32 01 8F    ld   ($8F01),a
2323: 18 CB       jr   $22F0
2325: 10 10       djnz $2337
2327: 37          scf
2328: 37          scf
2329: DD CB 07 56 bit  2,(ix+$07)
232D: 28 3B       jr   z,$236A
232F: DD 35 04    dec  (ix+$04)
2332: DD 7E 04    ld   a,(ix+$04)
2335: FE 41       cp   $41
2337: 30 04       jr   nc,$233D
2339: DD 36 04 41 ld   (ix+$04),$41
233D: CD D7 23    call $23D7
2340: 2A BE 88    ld   hl,($88BE)
2343: 7D          ld   a,l
2344: FE E6       cp   $E6
2346: 20 11       jr   nz,$2359
2348: 7E          ld   a,(hl)
2349: FE 35       cp   $35
234B: 30 0C       jr   nc,$2359
234D: 26 89       ld   h,$89
234F: 06 07       ld   b,$07
2351: 23          inc  hl
2352: 7E          ld   a,(hl)
2353: B7          or   a
2354: 20 03       jr   nz,$2359
2356: 10 F9       djnz $2351
2358: C9          ret
2359: CD EC 23    call $23EC
235C: 21 BD 88    ld   hl,$88BD
235F: 34          inc  (hl)
2360: 7E          ld   a,(hl)
2361: E6 07       and  $07
2363: 77          ld   (hl),a
2364: A7          and  a
2365: C0          ret  nz
2366: 2B          dec  hl
2367: 34          inc  (hl)
2368: 18 43       jr   $23AD
236A: DD CB 07 5E bit  3,(ix+$07)
236E: C8          ret  z
236F: DD 34 04    inc  (ix+$04)
2372: DD 7E 04    ld   a,(ix+$04)
2375: FE C0       cp   $C0
2377: 38 04       jr   c,$237D
2379: DD 36 04 C0 ld   (ix+$04),$C0
237D: CD D7 23    call $23D7
2380: 3A BE 88    ld   a,($88BE)
2383: FE F6       cp   $F6
2385: 20 17       jr   nz,$239E
2387: 21 38 8A    ld   hl,$8A38
238A: 06 03       ld   b,$03
238C: 7E          ld   a,(hl)
238D: A7          and  a
238E: 20 0E       jr   nz,$239E
2390: 23          inc  hl
2391: 10 F9       djnz $238C
2393: 21 83 80    ld   hl,$8083
2396: 3A 43 83    ld   a,($8343)
2399: 86          add  a,(hl)
239A: E6 0F       and  $0F
239C: A7          and  a
239D: C8          ret  z
239E: CD 05 24    call $2405
23A1: 21 BD 88    ld   hl,$88BD
23A4: 35          dec  (hl)
23A5: 7E          ld   a,(hl)
23A6: E6 07       and  $07
23A8: 77          ld   (hl),a
23A9: A7          and  a
23AA: C0          ret  nz
23AB: 2B          dec  hl
23AC: 35          dec  (hl)
23AD: 7E          ld   a,(hl)
23AE: E6 03       and  $03
23B0: 77          ld   (hl),a
23B1: 21 F6 26    ld   hl,$26F6
23B4: CD 45 0C    call $0C45
23B7: D5          push de
23B8: 21 25 84    ld   hl,$8425
23BB: CD 25 33    call write_4x4_tile_block_3325
23BE: D1          pop  de
23BF: 2E 65       ld   l,$65
23C1: CD 25 33    call write_4x4_tile_block_3325
23C4: 2E A5       ld   l,$A5
23C6: 11 0A 27    ld   de,$270A
23C9: 3A BC 88    ld   a,($88BC)
23CC: E6 01       and  $01
23CE: 20 03       jr   nz,$23D3
23D0: 11 0E 27    ld   de,$270E
23D3: CD 25 33    call write_4x4_tile_block_3325
23D6: C9          ret
23D7: DD 21 80 8A ld   ix,top_basket_object_8A80
23DB: DD 7E 04    ld   a,(ix+$04)
23DE: DD 77 4C    ld   (ix+$4c),a
23E1: D6 10       sub  $10
23E3: DD 77 34    ld   (ix+$34),a
23E6: C6 0A       add  a,$0A
23E8: DD 77 1C    ld   (ix+$1c),a
23EB: C9          ret
23EC: 21 37 8F    ld   hl,$8F37
23EF: 34          inc  (hl)
23F0: CB 46       bit  0,(hl)
23F2: C0          ret  nz
23F3: 2A BE 88    ld   hl,($88BE)
23F6: 7E          ld   a,(hl)
23F7: FE 34       cp   $34
23F9: 28 03       jr   z,$23FE
23FB: 35          dec  (hl)
23FC: 18 03       jr   $2401
23FE: 36 10       ld   (hl),$10
2400: 2B          dec  hl
2401: 22 BE 88    ld   ($88BE),hl
2404: C9          ret
2405: 21 37 8F    ld   hl,$8F37
2408: 34          inc  (hl)
2409: CB 46       bit  0,(hl)
240B: C8          ret  z
240C: 2A BE 88    ld   hl,($88BE)
240F: 7E          ld   a,(hl)
2410: FE 37       cp   $37
2412: 30 03       jr   nc,$2417
2414: 34          inc  (hl)
2415: 18 03       jr   $241A
2417: 23          inc  hl
2418: 36 34       ld   (hl),$34
241A: 22 BE 88    ld   ($88BE),hl
241D: C9          ret
241E: CD 01 21    call $2101
2421: CD A6 25    call $25A6
2424: CD 8B 30    call $308B
2427: 3A 1E 88    ld   a,($881E)
242A: A7          and  a
242B: C0          ret  nz
242C: DD 21 80 8A ld   ix,top_basket_object_8A80
2430: DD 7E 02    ld   a,(ix+$02)
2433: E6 07       and  $07
2435: EF          rst  $28
jump_table_2436:
	.word	$2442
	.word	$2473
	.word	$2497
	.word	$24B9
	.word	$24DB
	.word	$24FB

2442: 21 E8 89    ld   hl,$89E8                                       
2445: 7E89        ld   a,(hl)
2446: 2E EF       ld   l,$EF
2448: B6          or   (hl)
2449: C0          ret  nz
244A: DD 36 11 10 ld   (ix+$11),$10
244E: DD 34 02    inc  (ix+$02)
2451: 21 80 8A    ld   hl,top_basket_object_8A80
2454: 11 98 8A    ld   de,$8A98
2457: 01 18 00    ld   bc,$0018
245A: ED B0       ldir
245C: DD 7E 04    ld   a,(ix+$04)
245F: D6 10       sub  $10
2461: DD 77 04    ld   (ix+$04),a
2464: 21 BD 26    ld   hl,$26BD
2467: CD 0F 25    call $250F
246A: 3A 24 8F    ld   a,($8F24)
246D: A7          and  a
246E: C0          ret  nz
246F: CD AD 0F    call $0FAD
2472: C9          ret

2473: DD 35 11    dec  (ix+$11)
2476: C0          ret  nz
2477: 3A 39 8A    ld   a,($8A39)
247A: A7          and  a
247B: 20 06       jr   nz,$2483
247D: DD 36 11 10 ld   (ix+$11),$10
2481: DD 34 02    inc  (ix+$02)
2484: DD 7E 04    ld   a,(ix+$04)
2487: C6 10       add  a,$10
2489: DD 77 04    ld   (ix+$04),a
248C: AF          xor  a
248D: DD 77 1E    ld   (ix+$1e),a
2490: 21 C1 26    ld   hl,$26C1
2493: CD 0F 25    call $250F
2496: C9          ret
2497: DD 35 11    dec  (ix+$11)
249A: C0          ret  nz
249B: DD 34 02    inc  (ix+$02)
249E: 21 C5 26    ld   hl,$26C5
24A1: CD 0F 25    call $250F
24A4: DD 21 80 8A ld   ix,top_basket_object_8A80
24A8: DD 7E 04    ld   a,(ix+$04)
24AB: C6 04       add  a,$04
24AD: DD 77 04    ld   (ix+$04),a
24B0: DD 7E 06    ld   a,(ix+$06)
24B3: D6 06       sub  $06
24B5: DD 77 06    ld   (ix+$06),a
24B8: C9          ret
24B9: DD 34 05    inc  (ix+$05)
24BC: DD CB 05 46 bit  0,(ix+$05)
24C0: 20 03       jr   nz,$24C5
24C2: DD 35 06    dec  (ix+$06)
24C5: DD 7E 04    ld   a,(ix+$04)
24C8: C6 02       add  a,$02
24CA: DD 77 04    ld   (ix+$04),a
24CD: FE DC       cp   $DC
24CF: D8          ret  c
24D0: CD 21 0F    call $0F21
24D3: DD 36 11 02 ld   (ix+$11),$02
24D7: DD 34 02    inc  (ix+$02)
24DA: C9          ret
24DB: DD 35 11    dec  (ix+$11)
24DE: C0          ret  nz
24DF: DD 7E 04    ld   a,(ix+$04)
24E2: C6 04       add  a,$04
24E4: DD 77 04    ld   (ix+$04),a
24E7: DD 7E 06    ld   a,(ix+$06)
24EA: D6 08       sub  $08
24EC: DD 77 06    ld   (ix+$06),a
24EF: DD 36 0F 1A ld   (ix+$0f),$1A
24F3: DD 36 11 30 ld   (ix+$11),$30
24F7: DD 34 02    inc  (ix+$02)
24FA: C9          ret
24FB: DD 35 11    dec  (ix+$11)
24FE: C0          ret  nz
24FF: 21 2B 88    ld   hl,$882B
2502: 7E          ld   a,(hl)
2503: A7          and  a
2504: 20 02       jr   nz,$2508
2506: 2E 0A       ld   l,$0A
2508: 36 07       ld   (hl),$07
250A: 3A 3C 8A    ld   a,($8A3C)
250D: A7          and  a
250E: C8          ret  z
250F: 11 18 00    ld   de,$0018
2512: 06 04       ld   b,$04
2514: 7E          ld   a,(hl)
2515: DD 77 0F    ld   (ix+$0f),a
2518: 23          inc  hl
2519: DD 19       add  ix,de
251B: 10 F7       djnz $2514
251D: 21 E5 89    ld   hl,$89E5
2520: 3A F9 8D    ld   a,($8DF9)
2523: B6          or   (hl)
2524: 20 01       jr   nz,$2527
2526: C9          ret
2527: 16 08       ld   d,$08
2529: FF          rst  $38
252A: 21 02 89    ld   hl,$8902
252D: 7E          ld   a,(hl)
252E: FE 07       cp   $07
2530: 3E 00       ld   a,$00
2532: 38 0D       jr   c,$2541
2534: 3A FB 89    ld   a,($89FB)
2537: 36 04       ld   (hl),$04
2539: 2E 34       ld   l,$34
253B: 36 04       ld   (hl),$04
253D: 06 20       ld   b,$20
253F: 68          ld   l,b
2540: D7          rst  $10
2541: 21 00 8F    ld   hl,$8F00
2544: 06 4F       ld   b,$4F
2546: D7          rst  $10
2547: 2E 57       ld   l,$57
2549: 06 04       ld   b,$04
254B: D7          rst  $10
254C: 21 30 8D    ld   hl,$8D30
254F: 06 03       ld   b,$03
2551: D7          rst  $10
2552: 32 82 8A    ld   ($8A82),a
2555: 32 90 8C    ld   ($8C90),a
2558: 32 A8 8C    ld   ($8CA8),a
255B: 32 52 8F    ld   ($8F52),a
255E: 32 63 8F    ld   ($8F63),a
2561: C9          ret

2563: 3A 50 8F    ld   a,($8F50)
2566: A7          and  a
2567: C0          ret  nz
2568: 21 06 8F    ld   hl,$8F06
256B: 7E          ld   a,(hl)
256C: A7          and  a
256D: 28 02       jr   z,$2571
256F: 35          dec  (hl)
2570: C9          ret
2571: 36 0C       ld   (hl),$0C
2573: 23          inc  hl
2574: 34          inc  (hl)
2575: EB          ex   de,hl
2576: 3A 07 89    ld   a,($8907)
2579: CB 47       bit  0,a
257B: 21 BB 87    ld   hl,$87BB
257E: 1A          ld   a,(de)
257F: 20 0E       jr   nz,$258F
2581: 26 84       ld   h,$84
2583: 11 44 27    ld   de,$2744
2586: E6 01       and  $01
2588: 28 0F       jr   z,$2599
258A: 11 48 27    ld   de,$2748
258D: 18 0A       jr   $2599
258F: 11 4C 27    ld   de,$274C
2592: E6 01       and  $01
2594: 28 03       jr   z,$2599
2596: 11 50 27    ld   de,$2750
2599: D5          push de
259A: CD 25 33    call write_4x4_tile_block_3325
259D: 11 A0 FF    ld   de,$FFA0
25A0: 19          add  hl,de
25A1: D1          pop  de
25A2: CD 25 33    call write_4x4_tile_block_3325
25A5: C9          ret
25A6: 3A 07 89    ld   a,($8907)
25A9: CB 47       bit  0,a
25AB: CA 66 2D    jp   z,$2D66
25AE: 21 09 8F    ld   hl,$8F09
25B1: 35          dec  (hl)
25B2: C0          ret  nz
25B3: 36 10       ld   (hl),$10
25B5: 3A 02 89    ld   a,($8902)
25B8: A7          and  a
25B9: C8          ret  z
25BA: 4F          ld   c,a
25BB: 3A 20 89    ld   a,($8920)
25BE: A7          and  a
25BF: 20 74       jr   nz,$2635
25C1: 79          ld   a,c
25C2: 11 05 8F    ld   de,$8F05
25C5: 21 34 89    ld   hl,$8934
25C8: BE          cp   (hl)
25C9: 28 10       jr   z,$25DB
25CB: 1A          ld   a,(de)
25CC: A7          and  a
25CD: 20 0C       jr   nz,$25DB
25CF: 34          inc  (hl)
25D0: 3C          inc  a
25D1: 12          ld   (de),a
25D2: 11 E3 86    ld   de,$86E3
25D5: ED 53 32 89 ld   ($8932),de
25D9: 18 10       jr   $25EB
25DB: 1A          ld   a,(de)
25DC: A7          and  a
25DD: 28 0C       jr   z,$25EB
25DF: 3A 32 89    ld   a,($8932)
25E2: FE A3       cp   $A3
25E4: 20 05       jr   nz,$25EB
25E6: AF          xor  a
25E7: 12          ld   (de),a
25E8: 32 63 8F    ld   ($8F63),a
25EB: 7E          ld   a,(hl)
25EC: FE 07       cp   $07
25EE: 38 0E       jr   c,$25FE
25F0: 3A 32 89    ld   a,($8932)
25F3: FE C3       cp   $C3
25F5: 20 05       jr   nz,$25FC	; drop boulder
25F7: 3E 01       ld   a,$01
25F9: 32 04 8F    ld   ($8F04),a
25FC: 3E 07       ld   a,$07
25FE: 47          ld   b,a
25FF: 11 C0 FF    ld   de,$FFC0
2602: 3A 05 8F    ld   a,($8F05)
2605: A7          and  a
2606: 28 63       jr   z,$266B
2608: 21 09 8F    ld   hl,$8F09
260B: 36 1C       ld   (hl),$1C
260D: 11 E0 FF    ld   de,$FFE0
2610: DD 2A 32 89 ld   ix,($8932)
2614: DD 19       add  ix,de
2616: DD 22 32 89 ld   ($8932),ix
261A: 23          inc  hl
261B: CB 46       bit  0,(hl)
261D: 21 6C 27    ld   hl,$276C
2620: 20 03       jr   nz,$2625
2622: 21 68 27    ld   hl,$2768
2625: DD 36 40 10 ld   (ix+$40),$10
2629: DD 36 41 10 ld   (ix+$41),$10
262D: CD 19 0F    call $0F19
2630: CD 11 0F    call $0F11
2633: 18 43       jr   $2678
2635: 3A 0A 8F    ld   a,($8F0A)
2638: CB 47       bit  0,a
263A: 21 70 27    ld   hl,$2770
263D: 28 03       jr   z,$2642
263F: 21 74 27    ld   hl,table_2774
2642: FD 2A 32 89 ld   iy,($8932)
2646: FD 7C       ld   a,iyh
2648: D6 04       sub  $04
264A: FD 67       ld   iyh,a
264C: FD 7E 00    ld   a,(iy+$00)
264F: FE 80       cp   $80
2651: 06 07       ld   b,$07
2653: 28 23       jr   z,$2678
2655: 3E 80       ld   a,$80
2657: 11 C0 FF    ld   de,$FFC0
265A: FD 77 00    ld   (iy+$00),a
265D: FD 77 01    ld   (iy+$01),a
2660: FD 19       add  iy,de
2662: 10 F6       djnz $265A
2664: CD 49 0F    call $0F49
2667: 06 07       ld   b,$07
2669: 18 0D       jr   $2678
266B: 3A 0A 8F    ld   a,($8F0A)
266E: CB 47       bit  0,a
2670: 21 68 27    ld   hl,$2768
2673: 28 03       jr   z,$2678
2675: 21 6C 27    ld   hl,$276C
2678: DD 2A 32 89 ld   ix,($8932)
267C: 11 C0 FF    ld   de,$FFC0
267F: E5          push hl
2680: 7E          ld   a,(hl)
2681: DD 77 00    ld   (ix+$00),a
2684: 23          inc  hl
2685: 7E          ld   a,(hl)
2686: DD 77 01    ld   (ix+$01),a
2689: 23          inc  hl
268A: 7E          ld   a,(hl)
268B: DD 77 20    ld   (ix+$20),a
268E: 23          inc  hl
268F: 7E          ld   a,(hl)
2690: DD 77 21    ld   (ix+$21),a
2693: DD 19       add  ix,de
2695: E1          pop  hl
2696: 10 E7       djnz $267F
2698: 3A 20 89    ld   a,($8920)
269B: A7          and  a
269C: 20 1A       jr   nz,$26B8
269E: 11 DF FF    ld   de,$FFDF
26A1: DD 19       add  ix,de
26A3: DD E5       push ix
26A5: E1          pop  hl
26A6: 3A 0A 8F    ld   a,($8F0A)
26A9: CB 47       bit  0,a
26AB: 11 54 27    ld   de,$2754
26AE: 28 03       jr   z,$26B3
26B0: 11 5E 27    ld   de,$275E
26B3: CD 07 33    call $3307
26B6: 36 10       ld   (hl),$10
26B8: 21 0A 8F    ld   hl,$8F0A
26BB: 34          inc  (hl)
26BC: C9          ret


table_2770:
  3E C8 3E C8
table_2774:
  74 54 74 54 


2778: 3A 30 8F    ld   a,($8F30)
277B: E6 07       and  $07
277D: EF          rst  $28
	.word	$278F
	.word	$27F3
	.word	$2856
	.word	$28AD
	.word	$28C5



278F: 3A 3F 8F    ld   a,($8F3F)
2792: A7          and  a
2793: 20 1D       jr   nz,$27B2
2795: 3A 75 8D    ld   a,($8D75)
2798: A7          and  a
2799: 28 0A       jr   z,$27A5
279B: 21 20 8F    ld   hl,$8F20
279E: 7E          ld   a,(hl)
279F: A7          and  a
27A0: 20 03       jr   nz,$27A5
27A2: 34          inc  (hl)
27A3: 18 08       jr   $27AD
27A5: 3A 01 89    ld   a,(nb_wolves_8901)
27A8: A7          and  a
27A9: C8          ret  z
27AA: E6 07       and  $07
27AC: C0          ret  nz	; meat delay
27AD: 3E 01       ld   a,$01
27AF: 32 3F 8F    ld   ($8F3F),a
27B2: 3A B4 8A    ld   a,($8AB4)
27B5: FE 3C       cp   $3C
27B7: D8          ret  c
27B8: 3A 90 8C    ld   a,($8C90)
27BB: CB 4F       bit  1,a
27BD: C0          ret  nz
27BE: 3A A8 8C    ld   a,($8CA8)
27C1: CB 4F       bit  1,a
27C3: C0          ret  nz
27C4: 21 30 8F    ld   hl,$8F30
27C7: 34          inc  (hl)
27C8: 3E 08       ld   a,$08
27CA: 32 2F 89    ld   ($892F),a
27CD: 3A 06 88    ld   a,($8806)
27D0: A7          and  a
27D1: 20 0E       jr   nz,$27E1
27D3: 3A 50 8F    ld   a,($8F50)
27D6: 21 3F 8F    ld   hl,$8F3F
27D9: B6          or   (hl)
27DA: 28 05       jr   z,$27E1
27DC: 3E 6F       ld   a,$6F
27DE: 32 08 85    ld   ($8508),a
27E1: 3A 7A 8D    ld   a,($8D7A)
27E4: A7          and  a
27E5: 28 03       jr   z,$27EA
27E7: 32 20 8F    ld   ($8F20),a
27EA: 21 A7 84    ld   hl,$84A7
27ED: 11 51 2D    ld   de,$2D51
27F0: C3 25 33    jp   write_4x4_tile_block_3325
27F3: 3A B4 8A    ld   a,($8AB4)
27F6: FE 34       cp   $34
27F8: 38 19       jr   c,$2813	; collect meat
27FA: 21 2F 89    ld   hl,$892F
27FD: 35          dec  (hl)
27FE: C0          ret  nz
27FF: 36 10       ld   (hl),$10
2801: 2B          dec  hl
2802: 34          inc  (hl)
2803: CB 46       bit  0,(hl)
2805: 21 A7 84    ld   hl,$84A7
2808: 11 51 2D    ld   de,$2D51
280B: 20 03       jr   nz,$2810
280D: 11 55 2D    ld   de,$2D55
2810: C3 25 33    jp   write_4x4_tile_block_3325
2813: 21 90 8C    ld   hl,$8C90
2816: 11 18 00    ld   de,$0018
2819: 06 02       ld   b,$02
281B: 7E          ld   a,(hl)
281C: A7          and  a
281D: 28 04       jr   z,$2823
281F: 19          add  hl,de
2820: 10 F9       djnz $281B
2822: C9          ret
2823: 3E 02       ld   a,$02
2825: 32 30 8F    ld   ($8F30),a
2828: 77          ld   (hl),a
2829: CD 05 0F    call $0F05
282C: 21 A7 84    ld   hl,$84A7
282F: 11 55 2D    ld   de,$2D55
2832: CD 25 33    call write_4x4_tile_block_3325
2835: 3A 50 8F    ld   a,($8F50)
2838: 21 3F 8F    ld   hl,$8F3F
283B: B6          or   (hl)
283C: 28 03       jr   z,$2841
283E: 3E 10       ld   a,$10
2840: 32 08 85    ld   ($8508),a
2843: 3E 01       ld   a,$01
2845: 32 99 8A    ld   ($8A99),a
2848: 3A 86 8A    ld   a,($8A86)
284B: C6 0C       add  a,$0C
284D: 32 9E 8A    ld   ($8A9E),a
2850: 3E 10       ld   a,$10
2852: 32 A7 8A    ld   ($8AA7),a
2855: C9          ret
2856: 3A 50 8F    ld   a,($8F50)
2859: A7          and  a
285A: 20 3A       jr   nz,$2896
285C: DD 21 78 8C ld   ix,$8C78
2860: 11 E8 FF    ld   de,$FFE8
2863: 06 06       ld   b,$06
2865: DD 7E 00    ld   a,(ix+$00)
2868: DD B6 01    or   (ix+$01)
286B: 28 05       jr   z,$2872
286D: DD 19       add  ix,de
286F: 10 F4       djnz $2865
2871: C9          ret

2872: DD 36 01 05 ld   (ix+$01),$05
2876: DD 36 02 10 ld   (ix+$02),$10
287A: DD 36 03 00 ld   (ix+$03),$00
287E: DD 36 04 08 ld   (ix+$04),$08
2882: DD 36 05 00 ld   (ix+$05),$00
2886: DD 36 06 1A ld   (ix+$06),$1A
288A: DD 36 0F 37 ld   (ix+$0f),$37
288E: DD 36 10 42 ld   (ix+$10),$42
2892: DD 22 32 8F ld   ($8F32),ix
2896: 21 30 8F    ld   hl,$8F30
2899: 34          inc  (hl)
289A: 3A 61 8F    ld   a,($8F61)
289D: A7          and  a
289E: 28 04       jr   z,$28A4
28A0: 2E 5D       ld   l,$5D
28A2: 34          inc  (hl)
28A3: C9          ret
28A4: 2E 34       ld   l,$34
28A6: 36 20       ld   (hl),$20
28A8: 11 15 03    ld   de,$0315
28AB: FF          rst  $38
28AC: C9          ret
28AD: 21 34 8F    ld   hl,$8F34
28B0: 7E          ld   a,(hl)
28B1: A7          and  a
28B2: 28 02       jr   z,$28B6
28B4: 35          dec  (hl)
28B5: C9          ret
28B6: 2E 30       ld   l,$30
28B8: 34          inc  (hl)
28B9: 3A 50 8F    ld   a,($8F50)
28BC: A7          and  a
28BD: C0          ret  nz
28BE: AF          xor  a
28BF: 2A 32 8F    ld   hl,($8F32)
28C2: 06 18       ld   b,$18
28C4: D7          rst  $10
28C5: C9          ret
28C6: CD 01 21    call $2101
28C9: 3A 07 89    ld   a,($8907)
28CC: CB 47       bit  0,a
28CE: 21 0A 88    ld   hl,in_game_sub_state_880A
28D1: 20 03       jr   nz,$28D6
28D3: 36 06       ld   (hl),$06
28D5: C9          ret
28D6: 3A 08 8F    ld   a,($8F08)
28D9: A7          and  a
28DA: 28 03       jr   z,$28DF
28DC: 36 04       ld   (hl),$04
28DE: C9          ret
28DF: DD 21 80 8A ld   ix,top_basket_object_8A80
28E3: 21 8D 2B    ld   hl,$2B8D
28E6: E5          push hl
28E7: DD 35 11    dec  (ix+$11)
28EA: C0          ret  nz
28EB: DD 7E 02    ld   a,(ix+$02)
28EE: E6 07       and  $07
28F0: EF          rst  $28
	.word	$2901     
	.word	$29A0     
	.word	$2A01    
	.word	$2A32 
	.word	$2A79 
	.word	$2A96 
	.word	$2AB3
	.word	$2AE8 
 
2901: DD 36 11 01 ld  (ix+$11),$01          
2905: DD 34 04    inc  (ix+$04)  
2908: DD 7E 04    ld   a,(ix+$04)
290B: FE DC       cp   $DC
290D: 30 0F       jr   nc,$291E
290F: CD D7 23    call $23D7
2912: 3A BE 88    ld   a,($88BE)
2915: FE F9       cp   $F9
2917: C8          ret  z
2918: CD 05 24    call $2405
291B: C3 A1 23    jp   $23A1
291E: 21 59 2D    ld   hl,$2D59
2921: CD 0F 25    call $250F
2924: 21 91 8A    ld   hl,$8A91
2927: 36 0C       ld   (hl),$0C
2929: 2E 82       ld   l,$82
292B: 34          inc  (hl)
292C: 23          inc  hl
292D: 23          inc  hl
292E: 7E          ld   a,(hl)
292F: D6 03       sub  $03
2931: 77          ld   (hl),a
2932: AF          xor  a
2933: 32 9C 8A    ld   ($8A9C),a
2936: 32 9E 8A    ld   ($8A9E),a
2939: 21 59 08    ld   hl,$0859
293C: 01 00 20    ld   bc,$2000
293F: 7E          ld   a,(hl)
2940: 81          add  a,c
2941: 4F          ld   c,a
2942: 23          inc  hl
2943: 10 FA       djnz $293F
2945: FE 63       cp   $63
2947: C2 E8 2A    jp   nz,$2AE8
294A: 06 20       ld   b,$20
294C: 11 80 29    ld   de,$2980
294F: 1B          dec  de
2950: 1A          ld   a,(de)
2951: BE          cp   (hl)
2952: C2 9A 2B    jp   nz,$2B9A
2955: 23          inc  hl
2956: 10 F7       djnz $294F
2958: CD A2 0F    call $0FA2
295B: C9          ret

29A0: DD 36 11 03 ld   (ix+$11),$03
29A4: DD 34 0B    inc  (ix+$0b)
29A7: DD 7E 0B    ld   a,(ix+$0b)
29AA: E6 03       and  $03
29AC: 20 0E       jr   nz,$29BC
29AE: DD 7E 0F    ld   a,(ix+$0f)
29B1: FE 15       cp   $15
29B3: 3E 15       ld   a,$15
29B5: 20 02       jr   nz,$29B9
29B7: 3E 1E       ld   a,$1E
29B9: DD 77 0F    ld   (ix+$0f),a
29BC: DD 7E 06    ld   a,(ix+$06)
29BF: D6 02       sub  $02
29C1: DD 77 06    ld   (ix+$06),a
29C4: FE 2C       cp   $2C
29C6: D0          ret  nc
29C7: 3A 43 83    ld   a,($8343)
29CA: A7          and  a
29CB: C2 23 2B    jp   nz,$2B23
29CE: C6 30       add  a,$30
29D0: 32 30 8D    ld   ($8D30),a
29D3: DD 36 11 18 ld   (ix+$11),$18
29D7: DD 34 02    inc  (ix+$02)
29DA: 21 79 08    ld   hl,$0879
29DD: 01 00 20    ld   bc,$2000
29E0: 7E          ld   a,(hl)
29E1: 81          add  a,c
29E2: 4F          ld   c,a
29E3: 23          inc  hl
29E4: 10 FA       djnz $29E0
29E6: FE 37       cp   $37
29E8: C2 B3 2A    jp   nz,$2AB3
29EB: 21 59 08    ld   hl,$0859
29EE: 06 20       ld   b,$20
29F0: 11 80 29    ld   de,$2980
29F3: 1A          ld   a,(de)
29F4: BE          cp   (hl)
29F5: C2 01 29    jp   nz,$2901
29F8: 23          inc  hl
29F9: 13          inc  de
29FA: 10 F7       djnz $29F3
29FC: 11 14 06    ld   de,$0614
29FF: FF          rst  $38
2A00: C9          ret

2A01: DD 36 11 08 ld   (ix+$11),$08
2A05: DD CB 10 FE set  7,(ix+$10)
2A09: 21 5A 87    ld   hl,$875A
2A0C: 3E BC       ld   a,$BC
2A0E: 77          ld   (hl),a
2A0F: 23          inc  hl
2A10: 77          ld   (hl),a
2A11: 23          inc  hl
2A12: 77          ld   (hl),a
2A13: DD 34 02    inc  (ix+$02)
2A16: AF          xor  a
2A17: 21 39 08    ld   hl,$0839
2A1A: 06 20       ld   b,$20
2A1C: 86          add  a,(hl)
2A1D: 23          inc  hl
2A1E: 10 FC       djnz $2A1C
2A20: 3D          dec  a
2A21: C2 58 2C    jp   nz,$2C58
2A24: 11 15 06    ld   de,$0615
2A27: FF          rst  $38
2A28: 21 03 89    ld   hl,$8903
2A2B: 7E          ld   a,(hl)
2A2C: FE 09       cp   $09
2A2E: D8          ret  c
2A2F: 36 08       ld   (hl),$08
2A31: C9          ret
2A32: DD 36 11 03 ld   (ix+$11),$03
2A36: DD 34 0B    inc  (ix+$0b)
2A39: DD 7E 0B    ld   a,(ix+$0b)
2A3C: E6 03       and  $03
2A3E: 20 0E       jr   nz,$2A4E
2A40: DD 7E 0F    ld   a,(ix+$0f)
2A43: FE 15       cp   $15
2A45: 3E 15       ld   a,$15
2A47: 20 02       jr   nz,$2A4B
2A49: 3E 1E       ld   a,$1E
2A4B: DD 77 0F    ld   (ix+$0f),a
2A4E: 3E 80       ld   a,$80
2A50: DD 86 05    add  a,(ix+$05)
2A53: DD 77 05    ld   (ix+$05),a
2A56: DD 7E 06    ld   a,(ix+$06)
2A59: 30 01       jr   nc,$2A5C
2A5B: 3C          inc  a
2A5C: 3C          inc  a
2A5D: DD 77 06    ld   (ix+$06),a
2A60: FE 52       cp   $52
2A62: 20 05       jr   nz,$2A69
2A64: 11 94 06    ld   de,$0694
2A67: FF          rst  $38
2A68: C9          ret
2A69: FE 64       cp   $64
2A6B: 20 05       jr   nz,$2A72
2A6D: 11 95 06    ld   de,$0695
2A70: FF          rst  $38
2A71: C9          ret
2A72: FE AC       cp   $AC
2A74: D8          ret  c
2A75: DD 34 02    inc  (ix+$02)
2A78: C9          ret

2A79: 21 66 1C    ld   hl,$1C66		; another protection check
2A7C: 11 23 2B    ld   de,$2B23
2A7F: 06 68       ld   b,$68
2A81: 1A          ld   a,(de)
2A82: 96          sub  (hl)
2A83: C2 A0 29    jp   nz,$29A0		; code not identical: corrupt/hacked
2A86: 23          inc  hl
2A87: 13          inc  de
2A88: 10 F7       djnz $2A81
2A8A: DD 36 11 30 ld   (ix+$11),$30
2A8E: DD CB 10 BE res  7,(ix+$10)
2A92: DD 34 02    inc  (ix+$02)
2A95: C9          ret

2A96: 21 DF 67    ld   hl,$67DF
2A99: 11 23 2B    ld   de,$2B23
2A9C: 06 20       ld   b,$20
2A9E: 1A          ld   a,(de)
2A9F: 96          sub  (hl)
2AA0: C2 01 2A    jp   nz,$2A01
2AA3: 23          inc  hl
2AA4: 1B          dec  de
2AA5: 10 F7       djnz $2A9E
2AA7: DD 36 11 18 ld   (ix+$11),$18
2AAB: DD CB 10 FE set  7,(ix+$10)
2AAF: DD 34 02    inc  (ix+$02)
2AB2: C9          ret
2AB3: DD 36 11 02 ld   (ix+$11),$02
2AB7: DD 34 0B    inc  (ix+$0b)
2ABA: DD 7E 0B    ld   a,(ix+$0b)
2ABD: E6 03       and  $03
2ABF: 20 0E       jr   nz,$2ACF
2AC1: DD 7E 0F    ld   a,(ix+$0f)
2AC4: FE 15       cp   $15
2AC6: 3E 15       ld   a,$15
2AC8: 20 02       jr   nz,$2ACC
2ACA: 3E 1E       ld   a,$1E
2ACC: DD 77 0F    ld   (ix+$0f),a
2ACF: DD 34 06    inc  (ix+$06)
2AD2: DD 7E 06    ld   a,(ix+$06)
2AD5: FE C0       cp   $C0
2AD7: D8          ret  c
2AD8: DD 7E 04    ld   a,(ix+$04)
2ADB: D6 03       sub  $03
2ADD: DD 77 04    ld   (ix+$04),a
2AE0: DD 34 02    inc  (ix+$02)
2AE3: DD 36 11 40 ld   (ix+$11),$40
2AE7: C9          ret
2AE8: AF          xor  a
2AE9: 21 80 8A    ld   hl,top_basket_object_8A80
2AEC: 77          ld   (hl),a
2AED: 11 81 8A    ld   de,$8A81
2AF0: 01 40 02    ld   bc,$0240
2AF3: ED B0       ldir
2AF5: 32 02 89    ld   ($8902),a
2AF8: 32 03 89    ld   ($8903),a
2AFB: 32 31 89    ld   ($8931),a
2AFE: 3E 06       ld   a,$06
2B00: 32 0A 88    ld   (in_game_sub_state_880A),a
2B03: C9          ret

2B23: 21 08 88    ld   hl,$8808
2B26: 35          dec  (hl)
2B27: 3A 2A 8E    ld   a,($8E2A)
2B2A: A7          and  a
2B2B: 28 04       jr   z,$2B31
2B2D: 7E          ld   a,(hl)
2B2E: A7          and  a
2B2F: 28 28       jr   z,$2B59
2B31: CD 94 7E    call $7E94
2B34: 3A FC 89    ld   a,($89FC)
2B37: A7          and  a
2B38: C8          ret  z
2B39: 3A 08 88    ld   a,($8808)
2B3C: E6 07       and  $07
2B3E: C0          ret  nz
2B3F: 3A FF 89    ld   a,($89FF)
2B42: 2A FD 89    ld   hl,($89FD)
2B45: 11 20 00    ld   de,$0020
2B48: 06 1C       ld   b,$1C
2B4A: 77          ld   (hl),a
2B4B: 19          add  hl,de
2B4C: 10 FC       djnz $2B4A
2B4E: 3C          inc  a
2B4F: FE 10       cp   $10
2B51: 38 02       jr   c,$2B55
2B53: 3E 06       ld   a,$06
2B55: 32 FF 89    ld   ($89FF),a
2B58: C9          ret
2B59: 21 5F 85    ld   hl,$855F
2B5C: 11 E0 FF    ld   de,$FFE0
2B5F: 06 08       ld   b,$08
2B61: 3E 10       ld   a,$10
2B63: 77          ld   (hl),a
2B64: 19          add  hl,de
2B65: 10 FA       djnz $2B61
2B67: 21 BC 82    ld   hl,$82BC
2B6A: 11 E0 FF    ld   de,$FFE0
2B6D: 01 00 0A    ld   bc,$0A00
2B70: 7E          ld   a,(hl)
2B71: 81          add  a,c
2B72: 4F          ld   c,a
2B73: 19          add  hl,de
2B74: 10 FA       djnz $2B70
2B76: 79          ld   a,c
2B77: FE AA       cp   $AA
2B79: C0          ret  nz
2B7A: AF          xor  a
2B7B: 32 2A 8E    ld   ($8E2A),a
2B7E: 3A 0E 88    ld   a,($880E)
2B81: A7          and  a
2B82: 28 4E       jr   z,$2BD2
2B84: 3A 0D 88    ld   a,($880D)
2B87: A7          and  a
2B88: 28 29       jr   z,$2BB3
2B8A: 3A 48 89    ld   a,($8948)
2B8D: 3A 82 8A    ld   a,($8A82)
2B90: FE 03       cp   $03
2B92: D8          ret  c
2B93: CD 9A 2B    call $2B9A
2B96: CD 2C 2C    call $2C2C
2B99: C9          ret
2B9A: 21 03 89    ld   hl,$8903
2B9D: 7E          ld   a,(hl)
2B9E: FE 02       cp   $02
2BA0: DC BF 2B    call c,$2BBF
2BA3: 21 30 8D    ld   hl,$8D30
2BA6: 7E          ld   a,(hl)
2BA7: A7          and  a
2BA8: 28 02       jr   z,$2BAC
2BAA: 35          dec  (hl)
2BAB: C9          ret
2BAC: DD 21 60 8C ld   ix,$8C60
2BB0: 11 E8 FF    ld   de,$FFE8
2BB3: 06 11       ld   b,$11
2BB5: D9          exx
2BB6: CD E5 2B    call $2BE5
2BB9: D9          exx
2BBA: DD 19       add  ix,de
2BBC: 10 F7       djnz $2BB5
2BBE: C9          ret
2BBF: FE 01       cp   $01
2BC1: 21 7B 87    ld   hl,$877B
2BC4: 28 0D       jr   z,$2BD3
2BC6: 7E          ld   a,(hl)
2BC7: FE BA       cp   $BA
2BC9: 20 02       jr   nz,$2BCD
2BCB: F1          pop  af
2BCC: C9          ret
2BCD: 11 E1 2B    ld   de,$2BE1
2BD0: CD 25 33    call write_4x4_tile_block_3325
2BD3: 21 BB 87    ld   hl,$87BB
2BD6: 7E          ld   a,(hl)
2BD7: FE BA       cp   $BA
2BD9: C8          ret  z
2BDA: 11 E1 2B    ld   de,$2BE1
2BDD: CD 25 33    call write_4x4_tile_block_3325
2BE0: C9          ret
2BE1: BA          cp   d
2BE2: BA          cp   d
2BE3: BA          cp   d
2BE4: BA          cp   d
2BE5: DD 7E 00    ld   a,(ix+$00)
2BE8: DD B6 01    or   (ix+$01)
2BEB: 0F          rrca
2BEC: D8          ret  c
2BED: DD 36 00 01 ld   (ix+$00),$01
2BF1: AF          xor  a
2BF2: DD 36 02 11 ld   (ix+$02),$11
2BF6: DD 77 03    ld   (ix+$03),a
2BF9: DD 77 05    ld   (ix+$05),a
2BFC: DD 36 04 1C ld   (ix+$04),$1C
2C00: DD 36 06 03 ld   (ix+$06),$03
2C04: 21 03 89    ld   hl,$8903
2C07: 35          dec  (hl)
2C08: CB 46       bit  0,(hl)
2C0A: 28 01       jr   z,$2C0D
2C0C: 3C          inc  a
2C0D: DD 77 07    ld   (ix+$07),a
2C10: 11 5D 2D    ld   de,$2D5D
2C13: CD 1E 38    call $381E
2C16: 3A 03 89    ld   a,($8903)
2C19: FE 0A       cp   $0A
2C1B: 38 02       jr   c,$2C1F
2C1D: 3E 0A       ld   a,$0A
2C1F: 47          ld   b,a
2C20: 3E 20       ld   a,$20
2C22: 90          sub  b
2C23: 32 30 8D    ld   ($8D30),a
2C26: DD 36 09 10 ld   (ix+$09),$10
2C2A: F1          pop  af
2C2B: C9          ret
2C2C: DD 21 E0 8A ld   ix,$8AE0
2C30: 11 18 00    ld   de,$0018
2C33: 06 11       ld   b,$11
2C35: D9          exx
2C36: CD 3F 2C    call $2C3F
2C39: D9          exx
2C3A: DD 19       add  ix,de
2C3C: 10 F7       djnz $2C35
2C3E: C9          ret
2C3F: DD 7E 00    ld   a,(ix+$00)
2C42: DD B6 01    or   (ix+$01)
2C45: 0F          rrca
2C46: D0          ret  nc
2C47: DD 7E 02    ld   a,(ix+$02)
2C4A: E6 1F       and  $1F
2C4C: D6 11       sub  $11
2C4E: D8          ret  c
2C4F: EF          rst  $28
	.word	$2C58   
	.word	$2CB3 
	.word	$2D24 
	.word	$2D4A 
     

2C58: CD 06 40    call $4006
2C5B: DD 7E 05    ld   a,(ix+$05)
2C5E: DD 86 09    add  a,(ix+$09)
2C61: 30 03       jr   nc,$2C66
2C63: DD 34 06    inc  (ix+$06)
2C66: DD 77 05    ld   (ix+$05),a
2C69: 47          ld   b,a
2C6A: DD 7E 06    ld   a,(ix+$06)
2C6D: FE 12       cp   $12
2C6F: D8          ret  c
2C70: DD 21 E0 8A ld   ix,$8AE0
2C74: 06 11       ld   b,$11
2C76: CD 85 2C    call $2C85
2C79: 11 18 00    ld   de,$0018
2C7C: DD 19       add  ix,de
2C7E: 10 F6       djnz $2C76
2C80: CD 3F 0F    call $0F3F
2C83: F1          pop  af
2C84: C9          ret
2C85: DD 7E 02    ld   a,(ix+$02)
2C88: FE 11       cp   $11
2C8A: C0          ret  nz
2C8B: DD 36 02 12 ld   (ix+$02),$12
2C8F: 11 A7 2C    ld   de,$2CA7
2C92: CD 1E 38    call $381E
2C95: 21 00 2D    ld   hl,$2D00
2C98: DD 75 16    ld   (ix+$16),l
2C9B: DD 74 17    ld   (ix+$17),h
2C9E: DD 36 15 00 ld   (ix+$15),$00
2CA2: C9          ret
2CA3: A7          and  a
2CA4: 2C          inc  l
2CA5: AD          xor  l
2CA6: 2C          inc  l
2CA7: 4F          ld   c,a
2CA8: 04          inc  b
2CA9: F0          ret  p
2CAA: FF          rst  $38
2CAB: A7          and  a
2CAC: 2C          inc  l
2CAD: 0F          rrca
2CAE: 04          inc  b
2CAF: F0          ret  p
2CB0: FF          rst  $38
2CB1: AD          xor  l
2CB2: 2C          inc  l
2CB3: CD 06 40    call $4006
2CB6: DD 6E 16    ld   l,(ix+$16)
2CB9: DD 66 17    ld   h,(ix+$17)
2CBC: 7E          ld   a,(hl)
2CBD: FE FF       cp   $FF
2CBF: 20 06       jr   nz,$2CC7
2CC1: DD 77 15    ld   (ix+$15),a
2CC4: 23          inc  hl
2CC5: 18 F5       jr   $2CBC
2CC7: FE 88       cp   $88
2CC9: 20 0E       jr   nz,$2CD9
2CCB: DD 34 02    inc  (ix+$02)
2CCE: 11 5D 2D    ld   de,$2D5D
2CD1: CD 1E 38    call $381E
2CD4: DD 36 11 20 ld   (ix+$11),$20
2CD8: C9          ret
2CD9: 23          inc  hl
2CDA: DD 75 16    ld   (ix+$16),l
2CDD: DD 74 17    ld   (ix+$17),h
2CE0: DD CB 15 46 bit  0,(ix+$15)
2CE4: 20 0E       jr   nz,$2CF4
2CE6: 47          ld   b,a
2CE7: DD 7E 03    ld   a,(ix+$03)
2CEA: 90          sub  b
2CEB: 30 03       jr   nc,$2CF0
2CED: DD 35 04    dec  (ix+$04)
2CF0: DD 77 03    ld   (ix+$03),a
2CF3: C9          ret
2CF4: DD 86 03    add  a,(ix+$03)
2CF7: 30 03       jr   nc,$2CFC
2CF9: DD 34 04    inc  (ix+$04)
2CFC: DD 77 03    ld   (ix+$03),a
2CFF: C9          ret

2D24: CD 06 40    call $4006
2D27: DD 7E 05    ld   a,(ix+$05)
2D2A: DD 86 09    add  a,(ix+$09)
2D2D: 30 03       jr   nc,$2D32
2D2F: DD 34 06    inc  (ix+$06)
2D32: DD 77 05    ld   (ix+$05),a
2D35: DD 7E 06    ld   a,(ix+$06)
2D38: FE 19       cp   $19
2D3A: D8          ret  c
2D3B: DD 34 02    inc  (ix+$02)
2D3E: AF          xor  a
2D3F: DD 77 05    ld   (ix+$05),a
2D42: DD 77 06    ld   (ix+$06),a
2D45: DD 77 16    ld   (ix+$16),a
2D48: F1          pop  af
2D49: C9          ret
2D4A: 3E 00       ld   a,$00
2D4C: 32 36 8F    ld   ($8F36),a
2D4F: F1          pop  af
2D50: C9          ret

2D66: 3A 32 8D    ld   a,($8D32)
2D69: A7          and  a
2D6A: C0          ret  nz
2D6B: 3A 03 89    ld   a,($8903)
2D6E: D6 02       sub  $02
2D70: C8          ret  z
2D71: CD 78 2D    call $2D78
2D74: CD 22 2E    call $2E22
2D77: C9          ret
2D78: 3A 14 8F    ld   a,($8F14)
2D7B: EF          rst  $28
	.word	$2D80
	.word	$2DBC

2D80: 3A 03 89    ld   a,($8903)
2D83: D6 02       sub  $02
2D85: 21 31 89    ld   hl,$8931
2D88: BE          cp   (hl)
2D89: C8          ret  z
2D8A: 34          inc  (hl)
2D8B: 21 18 8F    ld   hl,$8F18
2D8E: 7E          ld   a,(hl)
2D8F: FE 04       cp   $04
2D91: 38 05       jr   c,$2D98
2D93: 3A EF 89    ld   a,($89EF)
2D96: A7          and  a
2D97: C8          ret  z
2D98: 34          inc  (hl)
2D99: 21 B8 2D    ld   hl,$2DB8
2D9C: E7          rst  $20
2D9D: 6F          ld   l,a
2D9E: 26 84       ld   h,$84
2DA0: 22 19 8F    ld   ($8F19),hl
2DA3: 3A 18 8F    ld   a,($8F18)
2DA6: 47          ld   b,a
2DA7: 21 26 8F    ld   hl,$8F26
2DAA: 23          inc  hl
2DAB: 23          inc  hl
2DAC: 10 FC       djnz $2DAA
2DAE: 36 10       ld   (hl),$10
2DB0: 2E 14       ld   l,$14
2DB2: 34          inc  (hl)
2DB3: 2E 16       ld   l,$16
2DB5: 36 10       ld   (hl),$10
2DB7: C9          ret
2DB8: 97          sub  a
2DB9: 93          sub  e
2DBA: 8F          adc  a,a
2DBB: 8A          adc  a,d
2DBC: 21 16 8F    ld   hl,$8F16
2DBF: 7E          ld   a,(hl)
2DC0: A7          and  a
2DC1: 28 02       jr   z,$2DC5
2DC3: 35          dec  (hl)
2DC4: C9          ret
2DC5: 36 08       ld   (hl),$08
2DC7: 2E 1B       ld   l,$1B
2DC9: 7E          ld   a,(hl)
2DCA: FE 08       cp   $08
2DCC: 20 0F       jr   nz,$2DDD
2DCE: AF          xor  a
2DCF: 77          ld   (hl),a
2DD0: 2E 14       ld   l,$14
2DD2: 77          ld   (hl),a
2DD3: 3A 18 8F    ld   a,($8F18)
2DD6: 2E 1B       ld   l,$1B
2DD8: 85          add  a,l
2DD9: 6F          ld   l,a
2DDA: 36 01       ld   (hl),$01
2DDC: C9          ret
2DDD: 21 EE 2D    ld   hl,$2DEE
2DE0: CD 45 0C    call $0C45
2DE3: 2A 19 8F    ld   hl,($8F19)
2DE6: CD 25 33    call write_4x4_tile_block_3325
2DE9: 21 1B 8F    ld   hl,$8F1B
2DEC: 34          inc  (hl)
2DED: C9          ret


2E22: 3A 18 8F    ld   a,($8F18)
2E25: A7          and  a
2E26: C8          ret  z
2E27: DD 21 1C 8F ld   ix,$8F1C
2E2B: 47          ld   b,a
2E2C: D9          exx
2E2D: CD 36 2E    call $2E36
2E30: D9          exx
2E31: DD 23       inc  ix
2E33: 10 F7       djnz $2E2C
2E35: C9          ret

2E36: DD 7E 00    ld   a,(ix+$00)
2E39: D6 01       sub  $01
2E3B: D8          ret  c
2E3C: EF          rst  $28
	.word	$2E5E
	.word	$2ECB
	.word	$2F01
	.word	$2F2F

2E45: DD 7D       ld   a,ixl
2E47: 4F          ld   c,a
2E48: E6 03       and  $03
2E4A: 87          add  a,a
2E4B: C6 28       add  a,$28
2E4D: 6F          ld   l,a
2E4E: 26 8F       ld   h,$8F
2E50: 35          dec  (hl)
2E51: C9          ret
2E52: DD 7D       ld   a,ixl
2E54: E6 03       and  $03
2E56: 21 B8 2D    ld   hl,$2DB8
2E59: E7          rst  $20
2E5A: 6F          ld   l,a
2E5B: 26 84       ld   h,$84
2E5D: C9          ret
2E5E: 3A 5F 8A    ld   a,($8A5F)
2E61: E6 03       and  $03
2E63: C0          ret  nz
2E64: CD 45 2E    call $2E45
2E67: C0          ret  nz
2E68: 36 01       ld   (hl),$01
2E6A: FD 21 48 8C ld   iy,$8C48
2E6E: 11 18 00    ld   de,$0018
2E71: 06 03       ld   b,$03
2E73: FD 7E 00    ld   a,(iy+$00)
2E76: FD B6 01    or   (iy+$01)
2E79: 0F          rrca
2E7A: 30 05       jr   nc,$2E81
2E7C: FD 19       add  iy,de
2E7E: 10 F3       djnz $2E73
2E80: C9          ret
2E81: 3A 07 89    ld   a,($8907)
2E84: FE 10       cp   $10
2E86: 38 02       jr   c,$2E8A
2E88: 3E 10       ld   a,$10
2E8A: D6 28       sub  $28
2E8C: 2F          cpl
2E8D: 77          ld   (hl),a
2E8E: 23          inc  hl
2E8F: 78          ld   a,b
2E90: 2F          cpl
2E91: E6 03       and  $03
2E93: 77          ld   (hl),a
2E94: DD 7D       ld   a,ixl
2E96: E6 03       and  $03
2E98: 21 C7 2E    ld   hl,$2EC7
2E9B: E7          rst  $20
2E9C: FD 36 00 07 ld   (iy+$00),$07
2EA0: FD 36 02 10 ld   (iy+$02),$10
2EA4: FD 77 04    ld   (iy+$04),a
2EA7: FD 36 05 40 ld   (iy+$05),$40
2EAB: FD 36 06 1A ld   (iy+$06),$1A
2EAF: FD 36 0F 2E ld   (iy+$0f),$2E
2EB3: FD 36 10 40 ld   (iy+$10),$40
2EB7: DD 34 00    inc  (ix+$00)
2EBA: CD 52 2E    call $2E52
2EBD: 11 FE 2D    ld   de,$2DFE
2EC0: CD 25 33    call write_4x4_tile_block_3325
2EC3: CD 11 0F    call $0F11
2EC6: C9          ret
2EC7: 18 14       jr   $2EDD
2EC9: 10 0B       djnz $2ED6
2ECB: CD 45 2E    call $2E45
2ECE: C0          ret  nz
2ECF: 3A 07 89    ld   a,($8907)
2ED2: FE 10       cp   $10
2ED4: 38 02       jr   c,$2ED8
2ED6: 3E 10       ld   a,$10
2ED8: 07          rlca
2ED9: C6 18       add  a,$18
2EDB: 77          ld   (hl),a
2EDC: FD 21 30 8C ld   iy,$8C30
2EE0: 11 18 00    ld   de,$0018
2EE3: 23          inc  hl
2EE4: 46          ld   b,(hl)
2EE5: 04          inc  b
2EE6: FD 19       add  iy,de
2EE8: 10 FC       djnz $2EE6
2EEA: FD 34 0F    inc  (iy+$0f)
2EED: FD 36 05 00 ld   (iy+$05),$00
2EF1: FD 35 06    dec  (iy+$06)
2EF4: DD 34 00    inc  (ix+$00)
2EF7: CD 52 2E    call $2E52
2EFA: 11 1E 2E    ld   de,$2E1E
2EFD: CD 25 33    call write_4x4_tile_block_3325
2F00: C9          ret
2F01: CD 5F 30    call $305F
2F04: CD 45 2E    call $2E45
2F07: C0          ret  nz
2F08: 36 0C       ld   (hl),$0C
2F0A: FD 21 30 8C ld   iy,$8C30
2F0E: 11 18 00    ld   de,$0018
2F11: 23          inc  hl
2F12: 46          ld   b,(hl)
2F13: 04          inc  b
2F14: FD 19       add  iy,de
2F16: 10 FC       djnz $2F14
2F18: FD 35 0F    dec  (iy+$0f)
2F1B: FD 36 05 C0 ld   (iy+$05),$C0
2F1F: FD 34 06    inc  (iy+$06)
2F22: DD 34 00    inc  (ix+$00)
2F25: CD 52 2E    call $2E52
2F28: 11 FE 2D    ld   de,$2DFE
2F2B: CD 25 33    call write_4x4_tile_block_3325
2F2E: C9          ret
2F2F: CD 45 2E    call $2E45
2F32: C0          ret  nz
2F33: 3A 31 89    ld   a,($8931)
2F36: A7          and  a
2F37: C8          ret  z
2F38: E5          push hl
2F39: 3A 07 89    ld   a,($8907)
2F3C: CB 3F       srl  a
2F3E: CB 3F       srl  a
2F40: FE 04       cp   $04
2F42: 38 02       jr   c,$2F46
2F44: 3E 03       ld   a,$03
2F46: 47          ld   b,a
2F47: 3A 20 88    ld   a,($8820)
2F4A: E6 04       and  $04
2F4C: 0F          rrca
2F4D: 80          add  a,b
2F4E: 21 93 2F    ld   hl,$2F93
2F51: CD 45 0C    call $0C45
2F54: EB          ex   de,hl
2F55: 3A 31 89    ld   a,($8931)
2F58: 3D          dec  a
2F59: FE 20       cp   $20
2F5B: 38 02       jr   c,$2F5F
2F5D: 3E 1F       ld   a,$1F
2F5F: E7          rst  $20
2F60: E1          pop  hl
2F61: 5F          ld   e,a
2F62: 7D          ld   a,l
2F63: FE 28       cp   $28
2F65: 28 0C       jr   z,$2F73
2F67: D6 02       sub  $02
2F69: 6F          ld   l,a
2F6A: 7E          ld   a,(hl)
2F6B: E6 1C       and  $1C
2F6D: 83          add  a,e
2F6E: 5F          ld   e,a
2F6F: 7D          ld   a,l
2F70: C6 02       add  a,$02
2F72: 6F          ld   l,a
2F73: 7B          ld   a,e
2F74: 77          ld   (hl),a
2F75: 11 18 00    ld   de,$0018
2F78: 23          inc  hl
2F79: 46          ld   b,(hl)
2F7A: 21 30 8C    ld   hl,$8C30
2F7D: 04          inc  b
2F7E: 19          add  hl,de
2F7F: 10 FD       djnz $2F7E
2F81: AF          xor  a
2F82: 06 18       ld   b,$18
2F84: D7          rst  $10
2F85: 3C          inc  a
2F86: DD 77 00    ld   (ix+$00),a
2F89: CD 52 2E    call $2E52
2F8C: 11 1A 2E    ld   de,$2E1A
2F8F: CD 25 33    call write_4x4_tile_block_3325
2F92: C9          ret

305F: DD 7D       ld   a,ixl                                          
3061: E6 03       and  $03
3063: 21 87 30    ld   hl,$3087
3066: E7          rst  $20
3067: 47          ld   b,a
3068: 3A 84 8A    ld   a,(lift_speed_8A84)
306B: D6 07       sub  $07
306D: 4F          ld   c,a
306E: C6 0E       add  a,$0E
3070: B8          cp   b
; collision detection (wolf)
3071: D8          ret  c
3072: 79          ld   a,c
3073: B8          cp   b
3074: D0          ret  nc
3075: 21 24 8F    ld   hl,$8F24
3078: 3A 08 8F    ld   a,($8F08)
307B: B6          or   (hl)
307C: C0          ret  nz
307D: 3E 01       ld   a,$01
307F: 32 32 8D    ld   ($8D32),a
3082: CD 15 0F    call $0F15
3085: F1          pop  af
3086: C9          ret
3087: C0          ret  nz
3088: A0          and  b
3089: 80          add  a,b
308A: 58          ld   e,b
308B: 3A 04 8F    ld   a,($8F04)
308E: A7          and  a
308F: C8          ret  z
3090: 3A 08 8F    ld   a,($8F08)
3093: A7          and  a
3094: 20 4A       jr   nz,$30E0
3096: DD 21 E0 8A ld   ix,$8AE0
309A: FD 21 20 89 ld   iy,$8920
309E: 11 18 00    ld   de,$0018
30A1: 06 11       ld   b,$11
30A3: DD 7E 00    ld   a,(ix+$00)
30A6: A7          and  a
30A7: 28 0D       jr   z,$30B6
30A9: FE 05       cp   $05
30AB: 28 09       jr   z,$30B6
30AD: DD 19       add  ix,de
30AF: 10 F2       djnz $30A3
30B1: AF          xor  a
30B2: 32 20 89    ld   ($8920),a
30B5: C9          ret
30B6: DD 7E 01    ld   a,(ix+$01)
30B9: A7          and  a
30BA: 20 F1       jr   nz,$30AD
30BC: DD E5       push ix
30BE: E1          pop  hl
30BF: FD 75 00    ld   (iy+$00),l
30C2: FD 74 01    ld   (iy+$01),h
30C5: DD 36 00 05 ld   (ix+$00),$05
30C9: DD 36 02 10 ld   (ix+$02),$10
30CD: FD 23       inc  iy
30CF: FD 23       inc  iy
30D1: FD 7D       ld   a,iyl
30D3: FE 28       cp   $28
30D5: 20 D6       jr   nz,$30AD
30D7: 21 08 8F    ld   hl,$8F08
30DA: 36 01       ld   (hl),$01
30DC: 23          inc  hl
30DD: 36 20       ld   (hl),$20
30DF: C9          ret
30E0: 21 BD 32    ld   hl,$32BD
30E3: E5          push hl
30E4: 3A 08 8F    ld   a,($8F08)
30E7: E6 03       and  $03
30E9: 3D          dec  a
30EA: EF          rst  $28
	.word	$30F1         
	.word	$316E      
	.word	$3266    

30F1: DD 21 20 89 ld   ix,$8920
30F5: 21 37 33    ld   hl,$3337
30F8: 06 04       ld   b,$04
30FA: DD 5E 00    ld   e,(ix+$00)
30FD: DD 56 01    ld   d,(ix+$01)
3100: FD 6B       ld   iyl,e
3102: FD 62       ld   iyh,d
3104: 7E          ld   a,(hl)
3105: FD 77 04    ld   (iy+$04),a
3108: 23          inc  hl
3109: 7E          ld   a,(hl)
310A: FD 77 06    ld   (iy+$06),a
310D: 23          inc  hl
310E: 7E          ld   a,(hl)
310F: FD 77 0F    ld   (iy+$0f),a
3112: 23          inc  hl
3113: 7E          ld   a,(hl)
3114: FD 77 10    ld   (iy+$10),a
3117: FD 36 09 30 ld   (iy+$09),$30
311B: DD 23       inc  ix
311D: DD 23       inc  ix
311F: 23          inc  hl
3120: 10 D8       djnz $30FA
3122: 3E 0C       ld   a,$0C
3124: 32 28 89    ld   ($8928),a
3127: 21 08 8F    ld   hl,$8F08
312A: 34          inc  (hl)
312B: 3E 10       ld   a,$10
312D: 11 1D 00    ld   de,$001D
3130: 21 C2 84    ld   hl,$84C2
3133: 0E 03       ld   c,$03
3135: 06 03       ld   b,$03
3137: D7          rst  $10
3138: 19          add  hl,de
3139: 0D          dec  c
313A: 20 F9       jr   nz,$3135
313C: 21 70 33    ld   hl,$3370
313F: 22 4B 8F    ld   ($8F4B),hl
3142: CD 19 0F    call $0F19
3145: CD 3E 32    call $323E
3148: 11 AC 68    ld   de,$68AC
314B: 21 78 32    ld   hl,$3278
314E: 06 40       ld   b,$40
3150: 7B          ld   a,e
3151: BE          cp   (hl)
3152: 20 0F       jr   nz,$3163
3154: 7A          ld   a,d
3155: 23          inc  hl
3156: BE          cp   (hl)
3157: 20 0A       jr   nz,$3163
3159: 23          inc  hl
315A: 1A          ld   a,(de)
315B: BE          cp   (hl)
315C: 20 05       jr   nz,$3163
315E: 13          inc  de
315F: 23          inc  hl
3160: 10 F8       djnz $315A
3162: C9          ret
3163: AF          xor  a
3164: 21 00 88    ld   hl,$8800
3167: 11 01 88    ld   de,$8801
316A: 77          ld   (hl),a
316B: ED B0       ldir
316D: C9          ret
316E: 21 28 89    ld   hl,$8928
3171: 7E          ld   a,(hl)
3172: A7          and  a
3173: 28 02       jr   z,$3177
3175: 35          dec  (hl)
3176: C9          ret
3177: 2E 20       ld   l,$20
3179: 5E          ld   e,(hl)
317A: 23          inc  hl
317B: 56          ld   d,(hl)
317C: D5          push de
317D: FD E1       pop  iy
317F: 2A 4B 8F    ld   hl,($8F4B)
3182: 7E          ld   a,(hl)
3183: A7          and  a
3184: 28 13       jr   z,$3199
3186: FD 86 05    add  a,(iy+$05)
3189: 30 03       jr   nc,$318E
318B: FD 34 06    inc  (iy+$06)
318E: FD 77 05    ld   (iy+$05),a
3191: 23          inc  hl
3192: 7E          ld   a,(hl)
3193: 23          inc  hl
3194: 22 4B 8F    ld   ($8F4B),hl
3197: 18 0B       jr   $31A4
3199: FD 34 09    inc  (iy+$09)
319C: 20 03       jr   nz,$31A1
319E: FD 34 04    inc  (iy+$04)
31A1: FD 7E 09    ld   a,(iy+$09)
31A4: FD 86 03    add  a,(iy+$03)
31A7: 30 03       jr   nc,$31AC
31A9: FD 34 04    inc  (iy+$04)
31AC: FD 77 03    ld   (iy+$03),a
31AF: 3A 4A 8F    ld   a,($8F4A)
31B2: A7          and  a
31B3: FD 7E 04    ld   a,(iy+$04)
31B6: 20 1F       jr   nz,$31D7
31B8: 07          rlca
31B9: 07          rlca
31BA: 07          rlca
31BB: C6 18       add  a,$18
31BD: 4F          ld   c,a
31BE: 3A 84 8A    ld   a,(lift_speed_8A84)
31C1: B9          cp   c
31C2: 30 21       jr   nc,$31E5
31C4: 3E 01       ld   a,$01
31C6: 32 24 8F    ld   ($8F24),a
31C9: 32 4A 8F    ld   ($8F4A),a
31CC: 21 48 33    ld   hl,$3348
31CF: 22 4B 8F    ld   ($8F4B),hl
31D2: CD 1D 0F    call $0F1D
31D5: 18 0E       jr   $31E5
31D7: FE 1B       cp   $1B
31D9: 38 0A       jr   c,$31E5
31DB: 32 28 89    ld   ($8928),a
31DE: 21 08 8F    ld   hl,$8F08
31E1: 34          inc  (hl)
31E2: CD 1D 0F    call $0F1D
31E5: FD 4E 04    ld   c,(iy+$04)
31E8: FD 46 06    ld   b,(iy+$06)
31EB: DD 21 20 89 ld   ix,$8920
31EF: 11 03 00    ld   de,$0003
31F2: DD 6E 02    ld   l,(ix+$02)
31F5: DD 66 03    ld   h,(ix+$03)
31F8: 19          add  hl,de
31F9: FD 7E 03    ld   a,(iy+$03)
31FC: 77          ld   (hl),a
31FD: 23          inc  hl
31FE: 79          ld   a,c
31FF: 77          ld   (hl),a
3200: 23          inc  hl
3201: FD 7E 05    ld   a,(iy+$05)
3204: 77          ld   (hl),a
3205: 23          inc  hl
3206: 78          ld   a,b
3207: C6 02       add  a,$02
3209: 77          ld   (hl),a
320A: DD 6E 04    ld   l,(ix+$04)
320D: DD 66 05    ld   h,(ix+$05)
3210: 19          add  hl,de
3211: FD 7E 03    ld   a,(iy+$03)
3214: 77          ld   (hl),a
3215: 23          inc  hl
3216: 79          ld   a,c
3217: C6 02       add  a,$02
3219: 77          ld   (hl),a
321A: 23          inc  hl
321B: FD 7E 05    ld   a,(iy+$05)
321E: 77          ld   (hl),a
321F: 23          inc  hl
3220: 78          ld   a,b
3221: 77          ld   (hl),a
3222: DD 6E 06    ld   l,(ix+$06)
3225: DD 66 07    ld   h,(ix+$07)
3228: 19          add  hl,de
3229: FD 7E 03    ld   a,(iy+$03)
322C: 77          ld   (hl),a
322D: 23          inc  hl
322E: 79          ld   a,c
322F: C6 02       add  a,$02
3231: 77          ld   (hl),a
3232: 23          inc  hl
3233: FD 7E 05    ld   a,(iy+$05)
3236: 77          ld   (hl),a
3237: 23          inc  hl
3238: 78          ld   a,b
3239: C6 02       add  a,$02
323B: 77          ld   (hl),a
323C: 06 04       ld   b,$04
323E: DD 7E 01    ld   a,(ix+$01)
3241: FE 8C       cp   $8C
3243: CC 4D 32    call z,$324D
3246: DD 23       inc  ix
3248: DD 23       inc  ix
324A: 10 F2       djnz $323E
324C: C9          ret
324D: DD 7E 00    ld   a,(ix+$00)
3250: FE 40       cp   $40
3252: D8          ret  c
3253: 26 8C       ld   h,$8C
3255: C6 05       add  a,$05
3257: 6F          ld   l,a
3258: 7E          ld   a,(hl)
3259: D6 40       sub  $40
325B: 77          ld   (hl),a
325C: D0          ret  nc
325D: 23          inc  hl
325E: 35          dec  (hl)
325F: 3A E5 89    ld   a,($89E5)
3262: A7          and  a
3263: 20 13       jr   nz,$3278
3265: C9          ret
3266: 21 99 07    ld   hl,$0799
3269: 01 00 20    ld   bc,$2000
326C: 7E          ld   a,(hl)
326D: 81          add  a,c
326E: 4F          ld   c,a
326F: 23          inc  hl
3270: 10 FA       djnz $326C
3272: FE DC       cp   $DC
3274: C2 99 07    jp   nz,$0799
3277: C9          ret
3278: AC          xor  h
3279: 68          ld   l,b
327A: 21 55 8F    ld   hl,$8F55
327D: 7E          ld   a,(hl)
327E: A7          and  a
327F: C0          ret  nz
3280: 34          inc  (hl)
3281: 21 02 84    ld   hl,$8402
3284: 11 00 00    ld   de,$0000
3287: 7E          ld   a,(hl)
3288: 83          add  a,e
3289: 5F          ld   e,a
328A: 30 01       jr   nc,$328D
328C: 14          inc  d
328D: 2C          inc  l
328E: 7D          ld   a,l
328F: E6 1F       and  $1F
3291: FE 1F       cp   $1F
3293: 20 F2       jr   nz,$3287
3295: 7D          ld   a,l
3296: C6 03       add  a,$03
3298: 6F          ld   l,a
3299: 30 EC       jr   nc,$3287
329B: 24          inc  h
329C: 7C          ld   a,h
329D: FE 88       cp   $88
329F: 38 E6       jr   c,$3287
32A1: 21 EB 68    ld   hl,$68EB
32A4: 06 04       ld   b,$04
32A6: 7B          ld   a,e
32A7: BE          cp   (hl)
32A8: 28 06       jr   z,$32B0
32AA: 23          inc  hl
32AB: 10 FA       djnz $32A7
32AD: C3 D4 76    jp   $76D4
32B0: 7A          ld   a,d
32B1: 23          inc  hl
32B2: BE          cp   (hl)
32B3: C8          ret  z
32B4: 10 FA       djnz $32B0
32B6: C3 29 38    jp   $3829
32B9: 43          ld   b,e
32BA: 95          sub  l
32BB: 89          adc  a,c
32BC: 87          add  a,a
32BD: 3A 24 8F    ld   a,($8F24)
32C0: A7          and  a
32C1: C8          ret  z
32C2: FE 02       cp   $02
32C4: 28 22       jr   z,$32E8
32C6: D0          ret  nc
32C7: AF          xor  a
32C8: 21 21 8D    ld   hl,$8D21
32CB: 77          ld   (hl),a
32CC: 23          inc  hl
32CD: 36 20       ld   (hl),$20
32CF: CD AD 0F    call $0FAD
32D2: 21 24 8F    ld   hl,$8F24
32D5: 34          inc  (hl)
32D6: 21 79 07    ld   hl,$0779
32D9: 01 00 20    ld   bc,$2000
32DC: 7E          ld   a,(hl)
32DD: 81          add  a,c
32DE: 4F          ld   c,a
32DF: 23          inc  hl
32E0: 10 FA       djnz $32DC
32E2: E6 47       and  $47
32E4: C2 40 1F    jp   nz,$1F40
32E7: C9          ret
32E8: 21 84 8A    ld   hl,lift_speed_8A84
32EB: 34          inc  (hl)
32EC: 34          inc  (hl)
32ED: 7E          ld   a,(hl)
32EE: FE DB       cp   $DB
32F0: 30 04       jr   nc,$32F6
32F2: CD D7 23    call $23D7
32F5: C9          ret
32F6: CD 30 0F    call $0F30
32F9: 3A 83 80    ld   a,($8083)
32FC: A7          and  a
32FD: C0          ret  nz
32FE: 3C          inc  a
32FF: 32 32 8D    ld   ($8D32),a
3302: 21 24 8F    ld   hl,$8F24
3305: 34          inc  (hl)
3306: C9          ret
3307: 01 1D 00    ld   bc,$001D
330A: C5          push bc
330B: 06 03       ld   b,$03
330D: 1A          ld   a,(de)
330E: 77          ld   (hl),a
330F: 13          inc  de
3310: 23          inc  hl
3311: 10 FA       djnz $330D
3313: C1          pop  bc
3314: 09          add  hl,bc
3315: 3A 0B 8F    ld   a,($8F0B)
3318: 3C          inc  a
3319: 32 0B 8F    ld   ($8F0B),a
331C: FE 03       cp   $03
331E: 20 E7       jr   nz,$3307
3320: AF          xor  a
3321: 32 0B 8F    ld   ($8F0B),a
3324: C9          ret

; < DE: input char data
; < HL: screen address
write_4x4_tile_block_3325:
3325: 01 20 00    ld   bc,$0020		; to previous char
3328: 1A          ld   a,(de)
3329: 77          ld   (hl),a		; store video
332A: 13          inc  de
332B: 23          inc  hl
332C: 1A          ld   a,(de)
332D: 77          ld   (hl),a		; store video
332E: 13          inc  de
332F: 09          add  hl,bc
3330: 1A          ld   a,(de)
3331: 77          ld   (hl),a
3332: 13          inc  de
3333: 2B          dec  hl
3334: 1A          ld   a,(de)
3335: 77          ld   (hl),a
3336: C9          ret


3377: DD 21 E0 8A ld   ix,$8AE0
337B: 11 18 00    ld   de,$0018
337E: 06 0E       ld   b,$0E
3380: D9          exx
3381: CD 8A 33    call $338A
3384: D9          exx
3385: DD 19       add  ix,de
3387: 10 F7       djnz $3380
3389: C9          ret
338A: DD 7E 00    ld   a,(ix+$00)
338D: DD B6 01    or   (ix+$01)
3390: 0F          rrca
3391: D0          ret  nc
3392: DD 7E 02    ld   a,(ix+$02)
3395: E6 1F       and  $1F
3397: FE 11       cp   $11
3399: D0          ret  nc
339A: EF          rst  $28
	.word	$33BD
	.word	$3423
	.word	$3536
	.word	$355B
	.word	$3865
	.word	$39AF
	.word	$3BE3
	.word	$3C92
	.word	$3D18
	.word	$3D5C
	.word	$3D8F
	.word	$3E69
	.word	$3E9C
	.word	$3F5C
	.word	$3F72
	.word	$3F7C
	.word	$3FE9


33BD: DD 35 11    dec  (ix+$11)
33C0: C0          ret  nz
33C1: DD 34 02    inc  (ix+$02)
33C4: DD CB 0B 46 bit  0,(ix+$0b)
33C8: 20 2D       jr   nz,$33F7
33CA: 3A 43 8D    ld   a,($8D43)
33CD: E6 0F       and  $0F
33CF: 21 18 34    ld   hl,table_3418
33D2: E7          rst  $20
33D3: 32 4B 8D    ld   ($8D4B),a
33D6: DD BE 06    cp   (ix+$06)
33D9: 28 11       jr   z,$33EC
33DB: 3E 00       ld   a,$00
33DD: 11 29 38    ld   de,$3829
33E0: 30 04       jr   nc,$33E6
33E2: 3C          inc  a
33E3: 11 38 38    ld   de,$3838
33E6: DD 77 08    ld   (ix+$08),a
33E9: C3 1E 38    jp   $381E
33EC: DD 7E 09    ld   a,(ix+$09)
33EF: DD BE 05    cp   (ix+$05)
33F2: 38 EF       jr   c,$33E3
33F4: C3 73 34    jp   $3473
33F7: 21 4C 8D    ld   hl,$8D4C
33FA: 34          inc  (hl)
33FB: 3E 06       ld   a,$06
33FD: 32 01 89    ld   (nb_wolves_8901),a
3400: AF          xor  a
3401: 32 4A 8D    ld   ($8D4A),a
3404: DD 77 0B    ld   (ix+$0b),a
3407: CD CA 33    call $33CA
340A: 11 47 38    ld   de,$3847
340D: DD CB 08 46 bit  0,(ix+$08)
3411: 28 D6       jr   z,$33E9
3413: 11 56 38    ld   de,$3856
3416: 18 D1       jr   $33E9
table_3418:
	.byte	$08
	.byte	$08
	.byte	$08
	.byte	$08
	.byte	$08
	.byte	$08
	.byte	$08
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00

3423: CD 06 40    call $4006
3426: DD CB 01 46 bit  0,(ix+$01)
342A: 28 0B       jr   z,$3437
342C: 3A 63 8F    ld   a,($8F63)
342F: A7          and  a
3430: C0          ret  nz
3431: DD 36 01 00 ld   (ix+$01),$00
3435: 18 3C       jr   $3473
3437: DD 7E 08    ld   a,(ix+$08)
343A: A7          and  a
343B: C2 F2 34    jp   nz,$34F2
343E: DD 7E 05    ld   a,(ix+$05)
3441: DD 86 09    add  a,(ix+$09)
3444: 30 03       jr   nc,$3449
3446: DD 34 06    inc  (ix+$06)
3449: DD 77 05    ld   (ix+$05),a
344C: 47          ld   b,a
344D: 3A 4B 8D    ld   a,($8D4B)
3450: 4F          ld   c,a
3451: DD 7E 06    ld   a,(ix+$06)
3454: E6 1F       and  $1F
3456: B9          cp   c
3457: D8          ret  c
3458: 28 0A       jr   z,$3464
345A: DD 36 08 01 ld   (ix+$08),$01
345E: 11 38 38    ld   de,$3838
3461: C3 1E 38    jp   $381E
3464: A7          and  a
3465: CA B0 34    jp   z,$34B0
3468: 3A 0A 88    ld   a,(in_game_sub_state_880A)
346B: FE 04       cp   $04
346D: C0          ret  nz
346E: DD 7E 09    ld   a,(ix+$09)
3471: B8          cp   b
3472: D8          ret  c
3473: 3A 63 8F    ld   a,($8F63)
3476: A7          and  a
3477: CA 7F 34    jp   z,$347F
347A: DD 36 01 01 ld   (ix+$01),$01
347E: C9          ret
347F: DD 36 01 00 ld   (ix+$01),$00
3483: 21 43 8D    ld   hl,$8D43
3486: 7E          ld   a,(hl)
3487: FE 07       cp   $07
3489: 30 25       jr   nc,$34B0
348B: FE 0A       cp   $0A
348D: 30 01       jr   nc,$3490
348F: 34          inc  (hl)
3490: 7E          ld   a,(hl)
3491: 21 18 34    ld   hl,table_3418
3494: E7          rst  $20
3495: 32 4B 8D    ld   ($8D4B),a
3498: 21 E3 86    ld   hl,$86E3
349B: 11 40 00    ld   de,$0040
349E: 36 D8       ld   (hl),$D8
34A0: 23          inc  hl
34A1: 36 D9       ld   (hl),$D9
34A3: 1E 1F       ld   e,$1F
34A5: 19          add  hl,de
34A6: 36 DA       ld   (hl),$DA
34A8: 23          inc  hl
34A9: 36 DB       ld   (hl),$DB
34AB: 3E 01       ld   a,$01
34AD: 32 63 8F    ld   ($8F63),a
34B0: CD 53 35    call $3553
34B3: 21 40 8D    ld   hl,$8D40
34B6: 35          dec  (hl)
34B7: 21 01 89    ld   hl,nb_wolves_8901
34BA: 7E          ld   a,(hl)
34BB: 4F          ld   c,a
34BC: A7          and  a
34BD: 28 01       jr   z,$34C0
34BF: 35          dec  (hl)
34C0: 3A 0A 88    ld   a,(in_game_sub_state_880A)
34C3: FE 04       cp   $04
34C5: 20 02       jr   nz,$34C9
34C7: 2C          inc  l
34C8: 34          inc  (hl)
34C9: 3A 01 89    ld   a,(nb_wolves_8901)
34CC: 47          ld   b,a
34CD: 21 43 87    ld   hl,$8743
34D0: 11 20 00    ld   de,$0020
34D3: FE 0A       cp   $0A
34D5: 38 0C       jr   c,$34E3
34D7: 3A 50 8F    ld   a,($8F50)
34DA: A7          and  a
34DB: C0          ret  nz
34DC: AF          xor  a
34DD: C6 01       add  a,$01
34DF: 27          daa
34E0: 10 FB       djnz $34DD
34E2: 47          ld   b,a
34E3: E6 0F       and  $0F
34E5: 77          ld   (hl),a
34E6: 19          add  hl,de
34E7: 78          ld   a,b
34E8: 0F          rrca
34E9: 0F          rrca
34EA: 0F          rrca
34EB: 0F          rrca
34EC: E6 0F       and  $0F
34EE: A7          and  a
34EF: C8          ret  z
34F0: 77          ld   (hl),a
34F1: C9          ret
34F2: DD 7E 0A    ld   a,(ix+$0a)
34F5: ED 44       neg
34F7: 47          ld   b,a
34F8: DD 7E 05    ld   a,(ix+$05)
34FB: B8          cp   b
34FC: 30 03       jr   nc,$3501
34FE: DD 35 06    dec  (ix+$06)
3501: DD 86 0A    add  a,(ix+$0a)
3504: DD 77 05    ld   (ix+$05),a
3507: 47          ld   b,a
3508: 3A 4B 8D    ld   a,($8D4B)
350B: 4F          ld   c,a
350C: DD 7E 06    ld   a,(ix+$06)
350F: E6 1F       and  $1F
3511: B9          cp   c
3512: 28 10       jr   z,$3524
3514: D0          ret  nc
3515: A7          and  a
3516: CA B0 34    jp   z,$34B0
3519: 3A 0A 88    ld   a,(in_game_sub_state_880A)
351C: FE 04       cp   $04
351E: C0          ret  nz
351F: DD 36 08 00 ld   (ix+$08),$00
3523: C9          ret
3524: A7          and  a
3525: CA B0 34    jp   z,$34B0
3528: 3A 0A 88    ld   a,(in_game_sub_state_880A)
352B: FE 04       cp   $04
352D: C0          ret  nz
352E: DD 7E 09    ld   a,(ix+$09)
3531: B8          cp   b
3532: D8          ret  c
3533: C3 73 34    jp   $3473
3536: CD 06 40    call $4006
3539: DD 35 11    dec  (ix+$11)
353C: C0          ret  nz
353D: DD 7E 07    ld   a,(ix+$07)
3540: E6 F0       and  $F0
3542: 28 0F       jr   z,$3553
3544: 21 76 8D    ld   hl,$8D76
3547: 34          inc  (hl)
3548: 7E          ld   a,(hl)
3549: FE 03       cp   $03
354B: 38 06       jr   c,$3553
354D: 2D          dec  l
354E: AF          xor  a
354F: 77          ld   (hl),a
3550: 32 20 8F    ld   ($8F20),a
3553: AF          xor  a
3554: DD E5       push ix
3556: E1          pop  hl
3557: 06 17       ld   b,$17
3559: D7          rst  $10
355A: C9          ret
355B: CD 06 40    call $4006
355E: DD 7E 08    ld   a,(ix+$08)
3561: A7          and  a
3562: C2 57 37    jp   nz,$3757
3565: DD 7E 05    ld   a,(ix+$05)
3568: DD 86 09    add  a,(ix+$09)
356B: 30 03       jr   nc,$3570
356D: DD 34 06    inc  (ix+$06)
3570: DD 77 05    ld   (ix+$05),a
3573: 47          ld   b,a
3574: 3A 01 89    ld   a,(nb_wolves_8901)
3577: FE 03       cp   $03
3579: DA 2D 36    jp   c,$362D
357C: 3A 79 8D    ld   a,($8D79)
357F: A7          and  a
3580: 20 32       jr   nz,$35B4
3582: 21 C7 35    ld   hl,table_35C7
3585: 3A 07 89    ld   a,($8907)
3588: E6 0F       and  $0F
358A: CB 3F       srl  a
358C: CD 45 0C    call $0C45
358F: EB          ex   de,hl
3590: 3A 41 8D    ld   a,($8D41)
3593: E6 07       and  $07
3595: E7          rst  $20
3596: 4F          ld   c,a
3597: DD 7E 06    ld   a,(ix+$06)
359A: B9          cp   c
359B: CA 17 36    jp   z,$3617
359E: FE 14       cp   $14
35A0: D8          ret  c
35A1: DD 36 08 01 ld   (ix+$08),$01
35A5: 11 38 38    ld   de,$3838
35A8: DD CB 07 4E bit  1,(ix+$07)
35AC: 28 03       jr   z,$35B1
35AE: 11 56 38    ld   de,$3856
35B1: C3 1E 38    jp   $381E
35B4: DD CB 07 56 bit  2,(ix+$07)
35B8: 28 08       jr   z,$35C2
35BA: 2A 6F 8D    ld   hl,($8D6F)
35BD: 3A 7B 8D    ld   a,($8D7B)
35C0: 18 D3       jr   $3595
35C2: DD 7E 06    ld   a,(ix+$06)
35C5: 18 D7       jr   $359E

table_35C7:
	 .word	$35D7  
	 .word	$35DF 
	 .word	$35E7  
	 .word	$35EF 
	 .word	$35F7 
	 .word	$35FF  
	 .word	$3607  
	 .word	$360F 

35D6: 36 09       ld   (hl),$09
35D8: 0D          dec  c
35D9: 11 09 0D    ld   de,$0D09
35DC: 11 09 0D    ld   de,$0D09
35DF: 09          add  hl,bc
35E0: 11 0D 11    ld   de,$110D
35E3: 0D          dec  c
35E4: 09          add  hl,bc
35E5: 0D          dec  c
35E6: 09          add  hl,bc
35E7: 11 0D 09    ld   de,$090D
35EA: 11 0D 09    ld   de,$090D
35ED: 11 0D 08    ld   de,$080D
35F0: 0B          dec  bc
35F1: 0F          rrca
35F2: 12          ld   (de),a
35F3: 08          ex   af,af'
35F4: 12          ld   (de),a
35F5: 0B          dec  bc
35F6: 0F          rrca
35F7: 12          ld   (de),a
35F8: 0F          rrca
35F9: 0B          dec  bc
35FA: 08          ex   af,af'
35FB: 0F          rrca
35FC: 12          ld   (de),a
35FD: 08          ex   af,af'
35FE: 0B          dec  bc
35FF: 08          ex   af,af'
3600: 0B          dec  bc
3601: 0E 11       ld   c,$11
3603: 0B          dec  bc
3604: 08          ex   af,af'
3605: 11 0E 11    ld   de,$110E
3608: 0E 0B       ld   c,$0B
360A: 08          ex   af,af'
360B: 0E 11       ld   c,$11
360D: 0B          dec  bc
360E: 08          ex   af,af'
360F: 08          ex   af,af'
3610: 0B          dec  bc
3611: 0F          rrca
3612: 12          ld   (de),a
3613: 0A          ld   a,(bc)
3614: 11 09 0D    ld   de,$0D09
3617: 78          ld   a,b
3618: FE 20       cp   $20
361A: D0          ret  nc
361B: 18 40       jr   $365D
361D: DD CB 08 46 bit  0,(ix+$08)
3621: C8          ret  z
3622: C3 75 37    jp   $3775
3625: DD CB 08 46 bit  0,(ix+$08)
3629: C0          ret  nz
362A: C3 7C 35    jp   $357C
362D: DD 7E 06    ld   a,(ix+$06)
3630: FE 07       cp   $07
3632: 38 E9       jr   c,$361D
3634: FE 14       cp   $14
3636: 30 ED       jr   nc,$3625
3638: 3A 7D 8D    ld   a,($8D7D)
363B: FE 0E       cp   $0E
363D: 38 06       jr   c,$3645
363F: DD 7E 06    ld   a,(ix+$06)
3642: FE 13       cp   $13
3644: D8          ret  c
3645: 21 6B 8D    ld   hl,$8D6B
3648: 7E          ld   a,(hl)
3649: A7          and  a
364A: 28 02       jr   z,$364E
364C: 35          dec  (hl)
364D: C9          ret
364E: 78          ld   a,b
364F: FE 80       cp   $80
3651: D0          ret  nc
3652: EB          ex   de,hl
3653: 21 8E 36    ld   hl,$368E
3656: 3A 07 89    ld   a,($8907)
3659: E6 07       and  $07
365B: E7          rst  $20
365C: 12          ld   (de),a
365D: DD CB 0B 46 bit  0,(ix+$0b)
3661: 28 14       jr   z,$3677
3663: 21 E2 8A    ld   hl,$8AE2
3666: 11 18 00    ld   de,$0018
3669: 4A          ld   c,d
366A: 06 06       ld   b,$06
366C: 7E          ld   a,(hl)
366D: FE 03       cp   $03
366F: 20 01       jr   nz,$3672
3671: 0C          inc  c
3672: 19          add  hl,de
3673: 10 F7       djnz $366C
3675: 0D          dec  c
3676: C0          ret  nz
3677: FD 21 70 8B ld   iy,$8B70
367B: 11 18 00    ld   de,$0018
367E: 06 05       ld   b,$05
3680: FD 7E 00    ld   a,(iy+$00)
3683: FD B6 01    or   (iy+$01)
3686: 0F          rrca
3687: 30 0D       jr   nc,$3696
3689: FD 19       add  iy,de
368B: 10 F3       djnz $3680
368D: C9          ret
368E: 28 28       jr   z,$36B8
3690: 20 20       jr   nz,$36B2
3692: 18 18       jr   $36AC
3694: 10 10       djnz $36A6
3696: DD CB 07 56 bit  2,(ix+$07)
369A: 28 13       jr   z,$36AF
369C: 21 7B 8D    ld   hl,$8D7B
369F: 34          inc  (hl)
36A0: 21 79 8D    ld   hl,$8D79
36A3: 7E          ld   a,(hl)
36A4: A7          and  a
36A5: 28 08       jr   z,$36AF
36A7: 35          dec  (hl)
36A8: 21 75 8D    ld   hl,$8D75
36AB: 77          ld   (hl),a
36AC: 2C          inc  l
36AD: 36 00       ld   (hl),$00
36AF: 21 41 8D    ld   hl,$8D41
36B2: 34          inc  (hl)
36B3: 20 01       jr   nz,$36B6
36B5: 34          inc  (hl)
36B6: 4E          ld   c,(hl)
36B7: DD 71 14    ld   (ix+$14),c
36BA: 21 88 39    ld   hl,$3988
36BD: DD CB 07 4E bit  1,(ix+$07)
36C1: 28 03       jr   z,$36C6
36C3: 21 94 39    ld   hl,$3994
36C6: DD 75 0C    ld   (ix+$0c),l
36C9: DD 74 0D    ld   (ix+$0d),h
36CC: DD 36 0E 00 ld   (ix+$0e),$00
36D0: DD 36 11 28 ld   (ix+$11),$28
36D4: DD 36 02 04 ld   (ix+$02),$04
36D8: CD DE 36    call $36DE
36DB: C3 9D 37    jp   $379D
36DE: 3A 07 89    ld   a,($8907)
36E1: FE 10       cp   $10
36E3: 38 02       jr   c,$36E7
36E5: 3E 0E       ld   a,$0E
36E7: 47          ld   b,a
36E8: 3A 20 88    ld   a,($8820)
36EB: 87          add  a,a
36EC: 80          add  a,b
36ED: 21 37 37    ld   hl,$3737
36F0: E7          rst  $20
36F1: DD CB 16 46 bit  0,(ix+$16)
36F5: 28 0C       jr   z,$3703
36F7: 3D          dec  a
36F8: 28 16       jr   z,$3710
36FA: DD CB 13 46 bit  0,(ix+$13)
36FE: 28 03       jr   z,$3703
3700: 3D          dec  a
3701: 28 0D       jr   z,$3710
3703: 47          ld   b,a
3704: DD 7E 06    ld   a,(ix+$06)
3707: FE 09       cp   $09
3709: 78          ld   a,b
370A: 30 04       jr   nc,$3710
370C: 3D          dec  a
370D: 28 01       jr   z,$3710
370F: 3D          dec  a
3710: 47          ld   b,a
3711: 3A 01 89    ld   a,(nb_wolves_8901)
3714: FE 04       cp   $04
3716: 78          ld   a,b
3717: 30 03       jr   nc,$371C
3719: 3E 03       ld   a,$03
371B: 80          add  a,b
371C: 21 27 37    ld   hl,$3727
371F: E7          rst  $20
3720: DD B6 08    or   (ix+$08)
3723: DD 77 08    ld   (ix+$08),a
3726: C9          ret

3757: DD 7E 0A    ld   a,(ix+$0a)
375A: ED 44       neg
375C: 47          ld   b,a
375D: DD 7E 05    ld   a,(ix+$05)
3760: B8          cp   b
3761: 30 03       jr   nc,$3766
3763: DD 35 06    dec  (ix+$06)
3766: DD 86 0A    add  a,(ix+$0a)
3769: DD 77 05    ld   (ix+$05),a
376C: 47          ld   b,a
376D: 3A 01 89    ld   a,(nb_wolves_8901)
3770: FE 03       cp   $03
3772: DA 2D 36    jp   c,$362D
3775: 3A 0A 88    ld   a,(in_game_sub_state_880A)
3778: FE 05       cp   $05
377A: 28 19       jr   z,$3795
377C: DD 7E 06    ld   a,(ix+$06)
377F: FE 02       cp   $02
3781: D0          ret  nc
3782: DD 36 08 00 ld   (ix+$08),$00
3786: 11 29 38    ld   de,$3829
3789: DD CB 07 4E bit  1,(ix+$07)
378D: 28 03       jr   z,$3792
378F: 11 47 38    ld   de,$3847
3792: C3 1E 38    jp   $381E
3795: DD 7E 06    ld   a,(ix+$06)
3798: A7          and  a
3799: C0          ret  nz
379A: C3 53 35    jp   $3553
379D: FD 36 00 01 ld   (iy+$00),$01
37A1: FD 36 02 04 ld   (iy+$02),$04
37A5: FD 71 14    ld   (iy+$14),c
37A8: AF          xor  a
37A9: FD 77 07    ld   (iy+$07),a
37AC: FD 77 0E    ld   (iy+$0e),a
37AF: DD 7E 05    ld   a,(ix+$05)
37B2: C6 80       add  a,$80
37B4: FD 77 05    ld   (iy+$05),a
37B7: DD 7E 03    ld   a,(ix+$03)
37BA: C6 80       add  a,$80
37BC: FD 77 03    ld   (iy+$03),a
37BF: DD 7E 04    ld   a,(ix+$04)
37C2: D6 01       sub  $01
37C4: FD 77 04    ld   (iy+$04),a
37C7: DD 7E 06    ld   a,(ix+$06)
37CA: C6 01       add  a,$01
37CC: FD 77 06    ld   (iy+$06),a
37CF: 21 A5 38    ld   hl,$38A5
37D2: 3A 20 88    ld   a,($8820)
37D5: FE 07       cp   $07
37D7: 20 03       jr   nz,$37DC
37D9: 21 AD 38    ld   hl,$38AD
37DC: 3A 00 89    ld   a,(current_play_variables_8900)
37DF: FE 08       cp   $08
37E1: 38 02       jr   c,$37E5
37E3: 3E 07       ld   a,$07
37E5: E7          rst  $20
37E6: 3A 07 89    ld   a,($8907)
37E9: E6 01       and  $01
37EB: 7E          ld   a,(hl)
37EC: 28 02       jr   z,$37F0
37EE: ED 44       neg
37F0: FD 77 0A    ld   (iy+$0a),a
37F3: DD 77 0A    ld   (ix+$0a),a
37F6: 21 B5 38    ld   hl,$38B5
37F9: DD 7E 07    ld   a,(ix+$07)
37FC: E6 F0       and  $F0
37FE: 0F          rrca
37FF: 0F          rrca
3800: 0F          rrca
3801: 0F          rrca
3802: CD 45 0C    call $0C45
3805: DD 7E 0B    ld   a,(ix+$0b)
3808: A7          and  a
3809: 28 03       jr   z,$380E
380B: 11 52 39    ld   de,$3952
380E: FD 77 0B    ld   (iy+$0b),a
3811: FD 73 0C    ld   (iy+$0c),e
3814: FD 72 0D    ld   (iy+$0d),d
3817: FD 36 11 28 ld   (iy+$11),$28
381B: C3 E3 0E    jp   $0EE3
381E: DD 73 0C    ld   (ix+$0c),e
3821: DD 72 0D    ld   (ix+$0d),d
3824: DD 36 0E 00 ld   (ix+$0e),$00
3828: C9          ret

3865: CD 06 40    call $4006                                          
3868: DD 35 11    dec  (ix+$11)
386B: C0          ret  nz
386C: DD 34 02    inc  (ix+$02)
386F: DD CB 08 86 res  0,(ix+$08)
3873: DD E5       push ix
3875: E1          pop  hl
3876: 7C          ld   a,h
3877: FE 8B       cp   $8B
3879: D8          ret  c
387A: 7D          ld   a,l
387B: FE 70       cp   $70
387D: D8          ret  c
387E: DD 35 04    dec  (ix+$04)
3881: DD 35 06    dec  (ix+$06)
3884: 3A 5F 8A    ld   a,($8A5F)
3887: A7          and  a
3888: C0          ret  nz
; another ROM integrity check, should be
; skipped!
3889: 21 82 42    ld   hl,$4282
388C: 0E 00       ld   c,$00
388E: 59          ld   e,c
388F: 7E          ld   a,(hl)
3890: 2B          dec  hl
3891: 81          add  a,c
3892: 4F          ld   c,a
3893: 30 01       jr   nc,$3896
3895: 1C          inc  e
3896: 3E 1A       ld   a,$1A
3898: BE          cp   (hl)
3899: 20 F4       jr   nz,$388F
389B: 7B          ld   a,e
389C: 81          add  a,c
389D: E6 9E       and  $9E
389F: C8          ret  z
38A0: 21 F0 8E    ld   hl,checksum_failed_8EF0
38A3: 34          inc  (hl)
38A4: C9          ret

39AF: CD 06 40    call $4006
39B2: 3A 07 89    ld   a,($8907)
39B5: E6 01       and  $01
39B7: CA 87 3B    jp   z,$3B87
39BA: DD 7E 0A    ld   a,(ix+$0a)
39BD: ED 44       neg
39BF: 47          ld   b,a
39C0: DD 7E 03    ld   a,(ix+$03)
39C3: B8          cp   b
39C4: 30 03       jr   nc,$39C9
39C6: DD 35 04    dec  (ix+$04)
39C9: DD 86 0A    add  a,(ix+$0a)
39CC: DD 77 03    ld   (ix+$03),a
39CF: DD 46 04    ld   b,(ix+$04)
39D2: DD 7E 07    ld   a,(ix+$07)
39D5: A7          and  a
39D6: 28 79       jr   z,$3A51
39D8: 78          ld   a,b
39D9: FE 04       cp   $04
39DB: 38 6B       jr   c,$3A48
39DD: FE 10       cp   $10
39DF: D8          ret  c
39E0: 21 7D 8D    ld   hl,$8D7D
39E3: 7E          ld   a,(hl)
39E4: FE 0E       cp   $0E
39E6: 30 20       jr   nc,$3A08
39E8: 3A 07 89    ld   a,($8907)
39EB: FE 06       cp   $06
39ED: 30 0C       jr   nc,$39FB
39EF: 3A 08 89    ld   a,(nb_lives_8908)
39F2: FE 03       cp   $03
39F4: 38 05       jr   c,$39FB
39F6: 7E          ld   a,(hl)
39F7: FE 08       cp   $08
39F9: 30 0D       jr   nc,$3A08
39FB: 3A 20 88    ld   a,($8820)
39FE: FE 07       cp   $07
3A00: 28 06       jr   z,$3A08
3A02: DD 7E 06    ld   a,(ix+$06)
3A05: FE 10       cp   $10
3A07: D0          ret  nc
3A08: 3A 75 8D    ld   a,($8D75)
3A0B: A7          and  a
3A0C: C0          ret  nz
3A0D: DD 7E 08    ld   a,(ix+$08)
3A10: E6 F0       and  $F0
3A12: C8          ret  z
3A13: DD 7E 15    ld   a,(ix+$15)
3A16: A7          and  a
3A17: 28 04       jr   z,$3A1D
3A19: DD 35 15    dec  (ix+$15)
3A1C: C9          ret
3A1D: 3A 42 88    ld   a,($8842)
3A20: 4F          ld   c,a
3A21: 3A 1F 88    ld   a,($881F)
3A24: 47          ld   b,a
3A25: A7          and  a
3A26: 79          ld   a,c
3A27: 20 02       jr   nz,$3A2B
3A29: ED 44       neg
3A2B: 0F          rrca
3A2C: 0F          rrca
3A2D: 0F          rrca
3A2E: E6 1F       and  $1F
3A30: 4F          ld   c,a
3A31: 78          ld   a,b
3A32: A7          and  a
3A33: 20 02       jr   nz,$3A37
3A35: 0D          dec  c
3A36: 0D          dec  c
3A37: 3A 07 89    ld   a,($8907)
3A3A: 47          ld   b,a
3A3B: CB 47       bit  0,a
3A3D: 79          ld   a,c
3A3E: 28 02       jr   z,$3A42
3A40: C6 04       add  a,$04
3A42: DD BE 04    cp   (ix+$04)
3A45: 28 25       jr   z,$3A6C
3A47: C9          ret
3A48: DD 36 02 00 ld   (ix+$02),$00
3A4C: DD 36 11 20 ld   (ix+$11),$20
3A50: C9          ret
3A51: 78          ld   a,b
3A52: FE 02       cp   $02
3A54: D0          ret  nc
3A55: 11 D1 3B    ld   de,$3BD1
3A58: CD 1E 38    call $381E
3A5B: DD 36 02 02 ld   (ix+$02),$02
3A5F: DD 36 11 28 ld   (ix+$11),$28
3A63: C9          ret
3A64: 10 15       djnz $3A7B
3A66: 0D          dec  c
3A67: 1B          dec  de
3A68: 0F          rrca
3A69: 11 13 1C    ld   de,$1C13
3A6C: 21 42 8D    ld   hl,$8D42
3A6F: 34          inc  (hl)
3A70: FD 21 E8 8B ld   iy,$8BE8
3A74: 06 03       ld   b,$03
3A76: 11 18 00    ld   de,$0018
3A79: FD 7E 00    ld   a,(iy+$00)
3A7C: FD B6 01    or   (iy+$01)
3A7F: 0F          rrca
3A80: 30 05       jr   nc,$3A87
3A82: FD 19       add  iy,de
3A84: 10 F3       djnz $3A79
3A86: C9          ret
3A87: DD 7E 06    ld   a,(ix+$06)
3A8A: D6 06       sub  $06
3A8C: CB 3F       srl  a
3A8E: E6 07       and  $07
3A90: 4F          ld   c,a
3A91: 21 57 3B    ld   hl,$3B57
3A94: 3A 07 89    ld   a,($8907)
3A97: CB 47       bit  0,a
3A99: 28 03       jr   z,$3A9E
3A9B: 21 47 3B    ld   hl,$3B47
3A9E: 79          ld   a,c
3A9F: CD 45 0C    call $0C45
3AA2: 1A          ld   a,(de)
3AA3: FD 77 12    ld   (iy+$12),a
3AA6: 13          inc  de
3AA7: 1A          ld   a,(de)
3AA8: FD 77 13    ld   (iy+$13),a
3AAB: FD CB 08 C6 set  0,(iy+$08)
3AAF: 11 6A 39    ld   de,$396A
3AB2: DD CB 07 4E bit  1,(ix+$07)
3AB6: 28 03       jr   z,$3ABB
3AB8: 11 79 39    ld   de,$3979
3ABB: DD 7E 16    ld   a,(ix+$16)
3ABE: E6 30       and  $30
3AC0: FE 30       cp   $30
3AC2: 20 03       jr   nz,$3AC7
3AC4: 11 A0 39    ld   de,$39A0
3AC7: CD 1E 38    call $381E
3ACA: DD 7E 08    ld   a,(ix+$08)
3ACD: D6 10       sub  $10
3ACF: DD 77 08    ld   (ix+$08),a
3AD2: FD 36 00 01 ld   (iy+$00),$01
3AD6: FD 36 02 0B ld   (iy+$02),$0B
3ADA: FD 36 07 01 ld   (iy+$07),$01
3ADE: 3A 50 8F    ld   a,($8F50)
3AE1: A7          and  a
3AE2: 11 DD 3B    ld   de,$3BDD
3AE5: 28 0D       jr   z,$3AF4
3AE7: 11 3B 43    ld   de,$433B
3AEA: 3A 07 89    ld   a,($8907)
3AED: CB 57       bit  2,a
3AEF: 28 03       jr   z,$3AF4
3AF1: 11 41 43    ld   de,$4341
3AF4: FD 73 0C    ld   (iy+$0c),e
3AF7: FD 72 0D    ld   (iy+$0d),d
3AFA: FD 36 0E 00 ld   (iy+$0e),$00
3AFE: FD 36 16 00 ld   (iy+$16),$00
3B02: FD 36 11 13 ld   (iy+$11),$13
3B06: DD E5       push ix
3B08: E1          pop  hl
3B09: FD 75 14    ld   (iy+$14),l
3B0C: FD 74 15    ld   (iy+$15),h
3B0F: 21 6C 8D    ld   hl,$8D6C
3B12: 34          inc  (hl)
3B13: 7E          ld   a,(hl)
3B14: E6 07       and  $07
3B16: 57          ld   d,a
3B17: 21 37 3B    ld   hl,$3B37
3B1A: 3A 07 89    ld   a,($8907)
3B1D: CB 47       bit  0,a
3B1F: 28 03       jr   z,$3B24
3B21: 21 3F 3B    ld   hl,$3B3F
3B24: 7A          ld   a,d
3B25: E7          rst  $20
3B26: DD 77 15    ld   (ix+$15),a
3B29: C9          ret


3B88: CB 08       rrc  b
3B8A: 46          ld   b,(hl)
3B8B: C2 BA 39    jp   nz,$39BA
3B8E: DD 7E 03    ld   a,(ix+$03)
3B91: DD 86 0A    add  a,(ix+$0a)
3B94: 30 03       jr   nc,$3B99
3B96: DD 34 04    inc  (ix+$04)
3B99: DD 77 03    ld   (ix+$03),a
3B9C: DD 46 04    ld   b,(ix+$04)
3B9F: DD 7E 07    ld   a,(ix+$07)
3BA2: A7          and  a
3BA3: CA CA 3B    jp   z,$3BCA
3BA6: 78          ld   a,b
3BA7: FE 1D       cp   $1D
3BA9: 30 03       jr   nc,$3BAE
3BAB: C3 E0 39    jp   $39E0
3BAE: DD 34 02    inc  (ix+$02)
3BB1: AF          xor  a
3BB2: DD 77 00    ld   (ix+$00),a
3BB5: DD 36 01 01 ld   (ix+$01),$01
3BB9: DD CB 08 86 res  0,(ix+$08)
3BBD: DD 36 09 20 ld   (ix+$09),$20
3BC1: DD 77 14    ld   (ix+$14),a
3BC4: 11 29 38    ld   de,$3829
3BC7: C3 1E 38    jp   $381E
3BCA: 78          ld   a,b
3BCB: FE 1B       cp   $1B
3BCD: D4 53 35    call nc,$3553
3BD0: C9          ret

3BE3: CD 06 40    call $4006
3BE6: DD CB 08 46 bit  0,(ix+$08)
3BEA: 20 24       jr   nz,$3C10
3BEC: DD 7E 05    ld   a,(ix+$05)
3BEF: DD 86 09    add  a,(ix+$09)
3BF2: 30 03       jr   nc,$3BF7
3BF4: DD 34 06    inc  (ix+$06)
3BF7: DD 77 05    ld   (ix+$05),a
3BFA: 47          ld   b,a
3BFB: DD 7E 06    ld   a,(ix+$06)
3BFE: FE 1F       cp   $1F
3C00: D8          ret  c
3C01: 18 38       jr   $3C3B
3C03: DD 34 02    inc  (ix+$02)
3C06: DD 36 11 20 ld   (ix+$11),$20
3C0A: 3E 28       ld   a,$28
3C0C: 32 5E 8D    ld   ($8D5E),a
3C0F: C9          ret
3C10: DD 7E 0A    ld   a,(ix+$0a)
3C13: ED 44       neg
3C15: 47          ld   b,a
3C16: DD 7E 05    ld   a,(ix+$05)
3C19: B8          cp   b
3C1A: 30 03       jr   nc,$3C1F
3C1C: DD 35 06    dec  (ix+$06)
3C1F: DD 86 0A    add  a,(ix+$0a)
3C22: DD 77 05    ld   (ix+$05),a
3C25: 47          ld   b,a
3C26: DD 6E 14    ld   l,(ix+$14)
3C29: DD 66 15    ld   h,(ix+$15)
3C2C: E5          push hl
3C2D: FD E1       pop  iy
3C2F: FD 77 05    ld   (iy+$05),a
3C32: DD 7E 06    ld   a,(ix+$06)
3C35: FD 77 06    ld   (iy+$06),a
3C38: E6 1F       and  $1F
3C3A: C0          ret  nz
3C3B: 21 03 89    ld   hl,$8903
3C3E: 34          inc  (hl)
3C3F: 21 40 8D    ld   hl,$8D40
3C42: 35          dec  (hl)
3C43: 2E 7D       ld   l,$7D
3C45: 34          inc  (hl)
3C46: DD 7E 07    ld   a,(ix+$07)
3C49: E6 F0       and  $F0
3C4B: CA 53 35    jp   z,$3553
3C4E: CD 53 35    call $3553
3C51: 3A 7E 8D    ld   a,($8D7E)
3C54: A7          and  a
3C55: C0          ret  nz
3C56: 21 76 8D    ld   hl,$8D76
3C59: 34          inc  (hl)
3C5A: 7E          ld   a,(hl)
3C5B: FE 02       cp   $02
3C5D: D8          ret  c
3C5E: 2D          dec  l
3C5F: AF          xor  a
3C60: 77          ld   (hl),a
3C61: 32 20 8F    ld   ($8F20),a
3C64: 32 6D 8D    ld   ($8D6D),a
3C67: 32 6E 8D    ld   ($8D6E),a
3C6A: 3E 02       ld   a,$02
3C6C: 32 07 8D    ld   ($8D07),a
3C6F: 32 7E 8D    ld   ($8D7E),a
3C72: 3A 1F 88    ld   a,($881F)
3C75: A7          and  a
3C76: C0          ret  nz
3C77: 3A 01 89    ld   a,(nb_wolves_8901)
3C7A: FE 10       cp   $10
3C7C: D0          ret  nc
3C7D: 11 D5 01    ld   de,$01D5
3C80: 01 12 00    ld   bc,$0012
3C83: 1A          ld   a,(de)
3C84: 1B          dec  de
3C85: 80          add  a,b
3C86: 47          ld   b,a
3C87: 0D          dec  c
3C88: 20 F9       jr   nz,$3C83
3C8A: FE 55       cp   $55
3C8C: C8          ret  z
3C8D: 21 ED 89    ld   hl,$89ED
3C90: 34          inc  (hl)
3C91: C9          ret
3C92: CD 06 40    call $4006
3C95: DD 35 11    dec  (ix+$11)
3C98: C0          ret  nz
3C99: FD 21 30 8C ld   iy,$8C30
3C9D: 11 18 00    ld   de,$0018
3CA0: 06 04       ld   b,$04
3CA2: CD AE 3C    call $3CAE
3CA5: FD 19       add  iy,de
3CA7: 10 F9       djnz $3CA2
3CA9: DD 36 11 10 ld   (ix+$11),$10
3CAD: C9          ret
3CAE: FD 7E 00    ld   a,(iy+$00)
3CB1: FD B6 01    or   (iy+$01)
3CB4: 0F          rrca
3CB5: C0          ret  nz
3CB6: FD 36 01 01 ld   (iy+$01),$01
3CBA: AF          xor  a
3CBB: FD 36 02 10 ld   (iy+$02),$10
3CBF: 21 0F 3D    ld   hl,$3D0F
3CC2: FD 75 0C    ld   (iy+$0c),l
3CC5: FD 74 0D    ld   (iy+$0d),h
3CC8: FD 77 0E    ld   (iy+$0e),a
3CCB: DD 36 02 06 ld   (ix+$02),$06
3CCF: DD 36 08 01 ld   (ix+$08),$01
3CD3: DD 36 0A E8 ld   (ix+$0a),$E8
3CD7: 11 38 38    ld   de,$3838
3CDA: CD 1E 38    call $381E
3CDD: DD 7E 04    ld   a,(ix+$04)
3CE0: D6 01       sub  $01
3CE2: FD 77 04    ld   (iy+$04),a
3CE5: DD 7E 03    ld   a,(ix+$03)
3CE8: FD 77 03    ld   (iy+$03),a
3CEB: DD 7E 06    ld   a,(ix+$06)
3CEE: C6 01       add  a,$01
3CF0: FD 77 06    ld   (iy+$06),a
3CF3: DD 7E 05    ld   a,(ix+$05)
3CF6: FD 77 05    ld   (iy+$05),a
3CF9: FD 36 08 01 ld   (iy+$08),$01
3CFD: FD 36 0A E8 ld   (iy+$0a),$E8
3D01: CD 3C 40    call $403C
3D04: FD E5       push iy
3D06: E1          pop  hl
3D07: DD 75 14    ld   (ix+$14),l
3D0A: DD 74 15    ld   (ix+$15),h
3D0D: F1          pop  af
3D0E: C9          ret
3D0F: 40          ld   b,b
3D10: 83          add  a,e
3D11: 10 40       djnz $3D53
3D13: 89          adc  a,c
3D14: 10 FF       djnz $3D15
3D16: 0F          rrca
3D17: 3D          dec  a
3D18: 06 20       ld   b,$20
3D1A: DD 4E 17    ld   c,(ix+$17)
3D1D: 3A 45 8D    ld   a,($8D45)
3D20: A7          and  a
3D21: 28 18       jr   z,$3D3B
3D23: DD 4E 12    ld   c,(ix+$12)
3D26: 0C          inc  c
3D27: 28 12       jr   z,$3D3B
3D29: FE 04       cp   $04
3D2B: 38 02       jr   c,$3D2F
3D2D: 3E 03       ld   a,$03
3D2F: 47          ld   b,a
3D30: C6 06       add  a,$06
3D32: 4F          ld   c,a
3D33: 11 0F 03    ld   de,$030F
3D36: 83          add  a,e
3D37: 5F          ld   e,a
3D38: FF          rst  $38
3D39: 06 38       ld   b,$38
3D3B: DD 70 11    ld   (ix+$11),b
3D3E: 79          ld   a,c
3D3F: DD CB 07 4E bit  1,(ix+$07)
3D43: 28 0B       jr   z,$3D50
3D45: 0C          inc  c
3D46: 3A 45 8D    ld   a,($8D45)
3D49: A7          and  a
3D4A: 79          ld   a,c
3D4B: 28 03       jr   z,$3D50
3D4D: 3E 03       ld   a,$03
3D4F: 81          add  a,c
3D50: 21 D3 3D    ld   hl,$3DD3
3D53: CD 45 0C    call $0C45
3D56: CD 1E 38    call $381E
3D59: DD 34 02    inc  (ix+$02)
3D5C: CD 06 40    call $4006
3D5F: DD 35 11    dec  (ix+$11)
3D62: C0          ret  nz
3D63: DD 7E 16    ld   a,(ix+$16)
3D66: FE 07       cp   $07
3D68: CA 99 3D    jp   z,$3D99
3D6B: 4F          ld   c,a
3D6C: A7          and  a
3D6D: 28 01       jr   z,$3D70
3D6F: 3D          dec  a
3D70: 11 12 03    ld   de,$0312
3D73: 83          add  a,e
3D74: 5F          ld   e,a
3D75: FF          rst  $38
3D76: 21 49 3E    ld   hl,$3E49
3D79: 79          ld   a,c
3D7A: FE 04       cp   $04
3D7C: 20 0A       jr   nz,$3D88
3D7E: CD 45 0C    call $0C45
3D81: CD 1E 38    call $381E
3D84: DD 36 11 30 ld   (ix+$11),$30
3D88: 0C          inc  c
3D89: DD 71 13    ld   (ix+$13),c
3D8C: DD 34 02    inc  (ix+$02)
3D8F: CD 06 40    call $4006
3D92: DD 35 11    dec  (ix+$11)
3D95: C0          ret  nz
3D96: C3 53 35    jp   $3553

3D99: 21 76 40    ld   hl,$4076
3D9C: DD 7E 07    ld   a,(ix+$07)
3D9F: E6 03       and  $03
3DA1: 3D          dec  a
3DA2: CD 45 0C    call $0C45
3DA5: CD 1E 38    call $381E
3DA8: DD 36 09 40 ld   (ix+$09),$40
3DAC: DD 36 02 0F ld   (ix+$02),$0F
3DB0: C3 D6 0E    jp   $0ED6

;3DBB  3DC1  3DC7  3DCD  3042  FFF0  3DBB  3041 
;FFF0  3DC1  3049  FFF0  3DC7  3040  FFF0  3DCD 
;3DEF  3DEF  3DEF  3DFB  3E07  407A  408F  3E13 
;3E1C  3E25  3E25  3E2E  3E37  3E40  3444  4405 
;0633  3244  4407  1231  3440  4005  0633  3240 
;4007  1231  3440  4005  0633  3240  4007  1231 
;0180  4005  051D  3943  8028  0401  1D40  4204 
;2839  0180  4003  031D  3A4F  8438  0501  1D44 
;4305  2839  0184  4404  041D  3942  8428  0301 
;1D44  4F03  383A  3E5D  3E5D  3E5D  3E5D  3E5D 
;3E63  3E66  3E66  3E66  3E66  3742  4340  4039 
;3942  4F40  483B 



3E69: DD 35 11    dec  (ix+$11)
3E6C: C0          ret  nz
3E6D: DD 6E 14    ld   l,(ix+$14)
3E70: DD 66 15    ld   h,(ix+$15)
3E73: 2C          inc  l
3E74: 2C          inc  l
3E75: 7E          ld   a,(hl)
3E76: FE 05       cp   $05
3E78: DA 53 35    jp   c,$3553
3E7B: FE 07       cp   $07
3E7D: D2 53 35    jp   nc,$3553
3E80: 2C          inc  l
3E81: 7E          ld   a,(hl)
3E82: DD 77 03    ld   (ix+$03),a
3E85: 2C          inc  l
3E86: 7E          ld   a,(hl)
3E87: 3D          dec  a
3E88: DD 77 04    ld   (ix+$04),a
3E8B: 2C          inc  l
3E8C: 7E          ld   a,(hl)
3E8D: DD 77 05    ld   (ix+$05),a
3E90: 2C          inc  l
3E91: 7E          ld   a,(hl)
3E92: DD 77 06    ld   (ix+$06),a
3E95: DD 36 15 00 ld   (ix+$15),$00
3E99: DD 34 02    inc  (ix+$02)
3E9C: CD 06 40    call $4006
3E9F: DD CB 01 46 bit  0,(ix+$01)
3EA3: C2 1D 3F    jp   nz,$3F1D
3EA6: DD 6E 12    ld   l,(ix+$12)
3EA9: DD 66 13    ld   h,(ix+$13)
3EAC: DD 7E 05    ld   a,(ix+$05)
3EAF: 85          add  a,l
3EB0: DD 77 05    ld   (ix+$05),a
3EB3: 30 03       jr   nc,$3EB8
3EB5: DD 34 06    inc  (ix+$06)
3EB8: DD CB 08 46 bit  0,(ix+$08)
3EBC: 28 43       jr   z,$3F01
3EBE: 7C          ld   a,h
3EBF: D6 02       sub  $02
3EC1: 38 35       jr   c,$3EF8
3EC3: 67          ld   h,a
3EC4: DD 7E 03    ld   a,(ix+$03)
3EC7: 94          sub  h
3EC8: DD 77 03    ld   (ix+$03),a
3ECB: 30 03       jr   nc,$3ED0
3ECD: DD 35 04    dec  (ix+$04)
3ED0: DD 74 13    ld   (ix+$13),h
3ED3: DD 7E 06    ld   a,(ix+$06)
3ED6: E6 1F       and  $1F
3ED8: FE 1A       cp   $1A
3EDA: D8          ret  c
3EDB: DD 7E 05    ld   a,(ix+$05)
3EDE: FE A0       cp   $A0
3EE0: D0          ret  nc
3EE1: 11 B4 40    ld   de,$40B4
3EE4: CD 1E 38    call $381E
3EE7: DD 36 11 0A ld   (ix+$11),$0A
3EEB: DD 36 02 02 ld   (ix+$02),$02
3EEF: DD 36 00 00 ld   (ix+$00),$00
3EF3: DD 36 01 01 ld   (ix+$01),$01
3EF7: C9          ret
3EF8: DD CB 08 86 res  0,(ix+$08)
3EFC: AF          xor  a
3EFD: DD 77 13    ld   (ix+$13),a
3F00: C9          ret
3F01: DD 34 16    inc  (ix+$16)
3F04: DD 7E 16    ld   a,(ix+$16)
3F07: E6 03       and  $03
3F09: C8          ret  z
3F0A: 7C          ld   a,h
3F0B: C6 01       add  a,$01
3F0D: DD 77 13    ld   (ix+$13),a
3F10: DD 86 03    add  a,(ix+$03)
3F13: DD 77 03    ld   (ix+$03),a
3F16: 30 03       jr   nc,$3F1B
3F18: DD 34 04    inc  (ix+$04)
3F1B: 18 B6       jr   $3ED3
3F1D: DD 6E 12    ld   l,(ix+$12)
3F20: DD 66 13    ld   h,(ix+$13)
3F23: 7E          ld   a,(hl)
3F24: 4F          ld   c,a
3F25: FE EE       cp   $EE
3F27: 20 01       jr   nz,$3F2A
3F29: 23          inc  hl
3F2A: 46          ld   b,(hl)
3F2B: DD 7E 05    ld   a,(ix+$05)
3F2E: 90          sub  b
3F2F: DD 77 05    ld   (ix+$05),a
3F32: 30 03       jr   nc,$3F37
3F34: DD 35 06    dec  (ix+$06)
3F37: 23          inc  hl
3F38: 7E          ld   a,(hl)
3F39: DD 86 03    add  a,(ix+$03)
3F3C: DD 77 03    ld   (ix+$03),a
3F3F: 30 03       jr   nc,$3F44
3F41: DD 34 04    inc  (ix+$04)
3F44: 23          inc  hl
3F45: 79          ld   a,c
3F46: FE EE       cp   $EE
3F48: 20 03       jr   nz,$3F4D
3F4A: 2B          dec  hl
3F4B: 2B          dec  hl
3F4C: 2B          dec  hl
3F4D: DD 75 12    ld   (ix+$12),l
3F50: DD 74 13    ld   (ix+$13),h
3F53: DD 7E 04    ld   a,(ix+$04)
3F56: FE 1E       cp   $1E
3F58: D8          ret  c
3F59: C3 E1 3E    jp   $3EE1
3F5C: 21 72 40    ld   hl,$4072
3F5F: DD 7E 07    ld   a,(ix+$07)
3F62: E6 03       and  $03
3F64: 3D          dec  a
3F65: CD 45 0C    call $0C45
3F68: CD 1E 38    call $381E
3F6B: DD 36 09 40 ld   (ix+$09),$40
3F6F: DD 34 02    inc  (ix+$02)
3F72: CD 06 40    call $4006
3F75: DD 35 11    dec  (ix+$11)
3F78: C0          ret  nz
3F79: DD 34 02    inc  (ix+$02)
3F7C: CD 06 40    call $4006
3F7F: CD D5 3F    call $3FD5
3F82: D8          ret  c
3F83: 21 A4 40    ld   hl,$40A4
3F86: DD 7E 07    ld   a,(ix+$07)
3F89: E6 03       and  $03
3F8B: 3D          dec  a
3F8C: CD 45 0C    call $0C45
3F8F: CD 1E 38    call $381E
3F92: DD 36 02 02 ld   (ix+$02),$02
3F96: DD 36 11 20 ld   (ix+$11),$20
3F9A: CD DA 0E    call $0EDA
3F9D: 21 40 8D    ld   hl,$8D40
3FA0: 35          dec  (hl)
3FA1: 21 01 89    ld   hl,nb_wolves_8901
3FA4: DD CB 0B 46 bit  0,(ix+$0b)
3FA8: 20 07       jr   nz,$3FB1
3FAA: 7E          ld   a,(hl)
3FAB: A7          and  a
3FAC: C8          ret  z
3FAD: 35          dec  (hl)
3FAE: C3 C9 34    jp   $34C9
3FB1: 36 00       ld   (hl),$00
3FB3: 3E 01       ld   a,$01
3FB5: CD C9 34    call $34C9
3FB8: 01 8B 42    ld   bc,$428B
3FBB: 2E 00       ld   l,$00
3FBD: 65          ld   h,l
3FBE: 0A          ld   a,(bc)
3FBF: FE C8       cp   $C8
3FC1: 28 08       jr   z,$3FCB
3FC3: 84          add  a,h
3FC4: 30 01       jr   nc,$3FC7
3FC6: 2C          inc  l
3FC7: 67          ld   h,a
3FC8: 0B          dec  bc
3FC9: 18 F3       jr   $3FBE
3FCB: 95          sub  l
3FCC: FE C0       cp   $C0
3FCE: C8          ret  z
3FCF: 3E 01       ld   a,$01
3FD1: 32 EB 89    ld   ($89EB),a
3FD4: C9          ret
3FD5: DD 7E 03    ld   a,(ix+$03)
3FD8: DD 86 09    add  a,(ix+$09)
3FDB: 30 03       jr   nc,$3FE0
3FDD: DD 34 04    inc  (ix+$04)
3FE0: DD 77 03    ld   (ix+$03),a
3FE3: DD 7E 04    ld   a,(ix+$04)
3FE6: FE 1E       cp   $1E
3FE8: C9          ret

3FE9: 11 80 77    ld   de,$7780
3FEC: 01 10 00    ld   bc,$0010
3FEF: 1A          ld   a,(de)
3FF0: 1B          dec  de
3FF1: 80          add  a,b
3FF2: 47          ld   b,a
3FF3: 0D          dec  c
3FF4: 20 F9       jr   nz,$3FEF
3FF6: CB 40       bit  0,b
3FF8: 20 07       jr   nz,$4001
3FFA: CB 68       bit  5,b
3FFC: 28 03       jr   z,$4001
3FFE: CB 78       bit  7,b
4000: C0          ret  nz
4001: 21 39 8A    ld   hl,$8A39
4004: 34          inc  (hl)
4005: C9          ret
4006: DD 7E 0E    ld   a,(ix+$0e)
4009: A7          and  a
400A: 28 04       jr   z,$4010
400C: DD 35 0E    dec  (ix+$0e)
400F: C9          ret
4010: DD 6E 0C    ld   l,(ix+$0c)
4013: DD 66 0D    ld   h,(ix+$0d)
4016: 7E          ld   a,(hl)
4017: FE FF       cp   $FF
4019: 28 15       jr   z,$4030
401B: DD 77 10    ld   (ix+$10),a
401E: 23          inc  hl
401F: 7E          ld   a,(hl)
4020: DD 77 0F    ld   (ix+$0f),a
4023: 23          inc  hl
4024: 7E          ld   a,(hl)
4025: DD 77 0E    ld   (ix+$0e),a
4028: 23          inc  hl
4029: DD 75 0C    ld   (ix+$0c),l
402C: DD 74 0D    ld   (ix+$0d),h
402F: C9          ret
4030: 23          inc  hl
4031: 7E          ld   a,(hl)
4032: DD 77 0C    ld   (ix+$0c),a
4035: 23          inc  hl
4036: 7E          ld   a,(hl)
4037: DD 77 0D    ld   (ix+$0d),a
403A: 18 D4       jr   $4010
403C: FD 7E 0E    ld   a,(iy+$0e)
403F: A7          and  a
4040: 28 04       jr   z,$4046
4042: FD 35 0E    dec  (iy+$0e)
4045: C9          ret
4046: FD 6E 0C    ld   l,(iy+$0c)
4049: FD 66 0D    ld   h,(iy+$0d)
404C: 7E          ld   a,(hl)
404D: FE FF       cp   $FF
404F: 28 15       jr   z,$4066
4051: FD 77 10    ld   (iy+$10),a
4054: 23          inc  hl
4055: 7E          ld   a,(hl)
4056: FD 77 0F    ld   (iy+$0f),a
4059: 23          inc  hl
405A: 7E          ld   a,(hl)
405B: FD 77 0E    ld   (iy+$0e),a
405E: 23          inc  hl
405F: FD 75 0C    ld   (iy+$0c),l
4062: FD 74 0D    ld   (iy+$0d),h
4065: C9          ret
4066: 23          inc  hl
4067: 7E          ld   a,(hl)
4068: FD 77 0C    ld   (iy+$0c),a
406B: 23          inc  hl
406C: 7E          ld   a,(hl)
406D: FD 77 0D    ld   (iy+$0d),a
4070: 18 D4       jr   $4046

40BD: DD 21 30 8C ld   ix,$8C30
40C1: 11 18 00    ld   de,$0018
40C4: 06 04       ld   b,$04
40C6: D9          exx
40C7: CD D0 40    call $40D0
40CA: D9          exx
40CB: DD 19       add  ix,de
40CD: 10 F7       djnz $40C6
40CF: C9          ret
40D0: DD 7E 00    ld   a,(ix+$00)
40D3: DD B6 01    or   (ix+$01)
40D6: 0F          rrca
40D7: D0          ret  nc
40D8: DD 7E 02    ld   a,(ix+$02)
40DB: E6 1F       and  $1F
40DD: FE 11       cp   $11
40DF: D0          ret  nc
40E0: EF          rst  $28
jump_table_40E1:
     .word	$40E1
	 .word	$4103
	 .word	$4137 
	 .word	$416F  
	 .word	$4179 
	 .word	$4179 
	 .word	$4179 
	 .word	$4179 
	 .word	$4179
     .word	$40F1
	 .word	$417A 
	 .word	$418D 
	 .word	$4179 
	 .word	$4221 
	 .word	$4350 
	 .word	$4364
	 .word	$4378 
	 .word	$4378
     .word	$4101 
	 .word	$4378 

4103: CD 06 40    call $4006
4106: DD 35 11    dec  (ix+$11)
4109: C0          ret  nz
410A: DD 34 02    inc  (ix+$02)
410D: DD 36 13 00 ld   (ix+$13),$00
4111: 3A 5F 8A    ld   a,($8A5F)
4114: A7          and  a
4115: C0          ret  nz
4116: 21 7F 55    ld   hl,$557F
4119: 06 38       ld   b,$38
411B: AF          xor  a
411C: 57          ld   d,a
411D: 5A          ld   e,d
411E: 7E          ld   a,(hl)
411F: E6 0F       and  $0F
4121: 83          add  a,e
4122: 5F          ld   e,a
4123: 30 01       jr   nc,$4126
4125: 14          inc  d
4126: 23          inc  hl
4127: 10 F5       djnz $411E
4129: 3E 67       ld   a,$67
412B: BB          cp   e
412C: 20 04       jr   nz,$4132
412E: 3E 01       ld   a,$01
4130: 92          sub  d
4131: C8          ret  z
4132: 21 38 8A    ld   hl,$8A38
4135: 34          inc  (hl)
4136: C9          ret

4137: CD 06 40    call $4006
413A: DD 7E 0A    ld   a,(ix+$0a)
413D: ED 44       neg
413F: 47          ld   b,a
4140: DD 7E 03    ld   a,(ix+$03)
4143: B8          cp   b
4144: 30 03       jr   nc,$4149
4146: DD 35 04    dec  (ix+$04)
4149: DD 86 0A    add  a,(ix+$0a)
414C: DD 77 03    ld   (ix+$03),a
414F: 47          ld   b,a
4150: DD 7E 04    ld   a,(ix+$04)
4153: FE 03       cp   $03
4155: D0          ret  nc
4156: DD 7E 17    ld   a,(ix+$17)
4159: 3C          inc  a
415A: 32 1D 8D    ld   ($8D1D),a
415D: 3D          dec  a
415E: DD 36 02 02 ld   (ix+$02),$02
4162: DD 36 11 18 ld   (ix+$11),$18
4166: 21 B1 41    ld   hl,$41B1
4169: CD 45 0C    call $0C45
416C: C3 1E 38    jp   $381E
416F: CD 06 40    call $4006
4172: DD 35 11    dec  (ix+$11)
4175: C0          ret  nz
4176: C3 53 35    jp   $3553
4179: C9          ret
417A: DD 7E 17    ld   a,(ix+$17)
417D: 21 B1 41    ld   hl,$41B1
4180: CD 45 0C    call $0C45
4183: CD 1E 38    call $381E
4186: DD 36 11 30 ld   (ix+$11),$30
418A: DD 34 02    inc  (ix+$02)
418D: CD 06 40    call $4006
4190: DD 35 11    dec  (ix+$11)
4193: C0          ret  nz
4194: DD 7E 16    ld   a,(ix+$16)
4197: 4F          ld   c,a
4198: A7          and  a
4199: 28 01       jr   z,$419C
419B: 3D          dec  a
419C: 11 12 03    ld   de,$0312
419F: 83          add  a,e
41A0: 5F          ld   e,a
41A1: FF          rst  $38
41A2: DD 36 11 01 ld   (ix+$11),$01
41A6: 0C          inc  c
41A7: DD 71 13    ld   (ix+$13),c
41AA: DD 36 02 02 ld   (ix+$02),$02
41AE: C3 6F 41    jp   $416F

4221: CD 06 40    call $4006
4224: DD CB 08 46 bit  0,(ix+$08)
4228: 20 1A       jr   nz,$4244
422A: CD 3E 34    call $343E
422D: DD 7E 06    ld   a,(ix+$06)
4230: E6 1F       and  $1F
4232: FE 14       cp   $14
4234: 38 5A       jr   c,$4290
4236: DD 36 08 01 ld   (ix+$08),$01
423A: 11 12 42    ld   de,$4212
423D: AF          xor  a
423E: 32 4B 8D    ld   ($8D4B),a
4241: C3 1E 38    jp   $381E
4244: CD F2 34    call $34F2
4247: DD 7E 06    ld   a,(ix+$06)
424A: E6 1F       and  $1F
424C: FE 0A       cp   $0A
424E: 30 40       jr   nc,$4290
4250: 47          ld   b,a
4251: 3A 01 89    ld   a,(nb_wolves_8901)
4254: FE 02       cp   $02
4256: 38 0E       jr   c,$4266
4258: DD 36 08 00 ld   (ix+$08),$00
425C: 11 03 42    ld   de,$4203
425F: 3E FF       ld   a,$FF
4261: 32 4B 8D    ld   ($8D4B),a
4264: 18 DB       jr   $4241
4266: 78          ld   a,b
4267: FE 02       cp   $02
4269: D0          ret  nc
426A: CD 53 35    call $3553
426D: 11 B9 0B    ld   de,$0BB9
4270: 21 83 42    ld   hl,$4283
4273: 1A          ld   a,(de)
4274: 86          add  a,(hl)
4275: 20 07       jr   nz,$427E
4277: 1B          dec  de
4278: 23          inc  hl
4279: 7E          ld   a,(hl)
427A: 3C          inc  a
427B: C8          ret  z
427C: 18 F5       jr   $4273
427E: 21 3A 8A    ld   hl,$8A3A
4281: 34          inc  (hl)
4282: C9          ret

4283:
 E0          
 59          
 78          
 FA C6 7A    
 B5          
 7A          
 B2          
 7A          
 AD          
 7A          
 FF          
4290: FE 05       cp   $05
4292: D8          ret  c
4293: 21 5B 8D    ld   hl,$8D5B
4296: 7E          ld   a,(hl)
4297: A7          and  a
4298: 20 2F       jr   nz,$42C9
429A: 2B          dec  hl
429B: 7E          ld   a,(hl)
429C: A7          and  a
429D: 28 02       jr   z,$42A1
429F: 35          dec  (hl)
42A0: C9          ret
42A1: 3A 01 89    ld   a,(nb_wolves_8901)
42A4: FE 08       cp   $08
42A6: 11 18 00    ld   de,$0018
42A9: 38 15       jr   c,$42C0
42AB: FD 21 E0 8A ld   iy,$8AE0
42AF: 3A 5C 8D    ld   a,($8D5C)
42B2: 47          ld   b,a
42B3: 4F          ld   c,a
42B4: FD 7E 04    ld   a,(iy+$04)
42B7: FE 07       cp   $07
42B9: 28 05       jr   z,$42C0
42BB: FD 19       add  iy,de
42BD: 10 F5       djnz $42B4
42BF: C9          ret
42C0: 3A 5D 8D    ld   a,($8D5D)
42C3: 32 5A 8D    ld   ($8D5A),a
42C6: 32 5B 8D    ld   ($8D5B),a
42C9: FD 21 48 8C ld   iy,$8C48
42CD: 06 03       ld   b,$03
42CF: CD DA 42    call $42DA
42D2: 11 18 00    ld   de,$0018
42D5: FD 19       add  iy,de
42D7: 10 F6       djnz $42CF
42D9: C9          ret
42DA: FD 7E 00    ld   a,(iy+$00)
42DD: FD B6 01    or   (iy+$01)
42E0: 0F          rrca
42E1: D8          ret  c
42E2: FD 36 00 01 ld   (iy+$00),$01
42E6: FD 36 02 0D ld   (iy+$02),$0D
42EA: DD E5       push ix
42EC: E1          pop  hl
42ED: FD E5       push iy
42EF: D1          pop  de
42F0: 2C          inc  l
42F1: 2C          inc  l
42F2: 2C          inc  l
42F3: 1C          inc  e
42F4: 1C          inc  e
42F5: 1C          inc  e
42F6: 01 04 00    ld   bc,$0004
42F9: ED B0       ldir
42FB: 3E 2A       ld   a,$2A
42FD: FD 77 09    ld   (iy+$09),a
4300: ED 44       neg
4302: FD 77 0A    ld   (iy+$0a),a
4305: 21 2D 43    ld   hl,$432D
4308: 3A 07 89    ld   a,($8907)
430B: CB 3F       srl  a
430D: 3D          dec  a
430E: E6 03       and  $03
4310: CD 45 0C    call $0C45
4313: CD 75 5C    call $5C75
4316: AF          xor  a
4317: 32 5B 8D    ld   ($8D5B),a
431A: 11 47 43    ld   de,$4347
431D: CD 1E 38    call $381E
4320: DD 36 11 30 ld   (ix+$11),$30
4324: FD 36 11 04 ld   (iy+$11),$04
4328: DD 34 02    inc  (ix+$02)
432B: F1          pop  af
432C: C9          ret

4350: CD 06 40    call $4006
4353: DD 35 11    dec  (ix+$11)
4356: C0          ret  nz
4357: DD 35 02    dec  (ix+$02)
435A: DD CB 08 46 bit  0,(ix+$08)
435E: CA 5C 42    jp   z,$425C
4361: C3 3A 42    jp   $423A
4364: DD 7E 11    ld   a,(ix+$11)
4367: A7          and  a
4368: 28 04       jr   z,$436E
436A: DD 35 11    dec  (ix+$11)
436D: C9          ret
436E: CD 06 40    call $4006
4371: CD D5 3F    call $3FD5
4374: D8          ret  c
4375: C3 53 35    jp   $3553
4378: C9          ret
4379: 10 11       djnz $438C
437B: 12          ld   (de),a
437C: 13          inc  de
437D: 14          inc  d
437E: 15          dec  d
437F: 16 17       ld   d,$17
4381: 06 1D       ld   b,$1D
4383: 3A 20 89    ld   a,($8920)
4386: 2A 43 8F    ld   hl,($8F43)
4389: ED 5B 45 8F ld   de,($8F45)
438D: A7          and  a
438E: 28 07       jr   z,$4397
4390: 2A B8 88    ld   hl,($88B8)
4393: ED 5B BA 88 ld   de,($88BA)
4397: 1A          ld   a,(de)
4398: FE 10       cp   $10
439A: 28 22       jr   z,$43BE
439C: FE FF       cp   $FF
439E: 28 2E       jr   z,$43CE
43A0: 77          ld   (hl),a
43A1: 13          inc  de
43A2: 23          inc  hl
43A3: 10 F2       djnz $4397
43A5: 23          inc  hl
43A6: 23          inc  hl
43A7: 23          inc  hl
43A8: 3A 20 89    ld   a,($8920)
43AB: A7          and  a
43AC: 20 08       jr   nz,$43B6
43AE: 22 43 8F    ld   ($8F43),hl
43B1: ED 53 45 8F ld   ($8F45),de
43B5: C9          ret
43B6: 22 B8 88    ld   ($88B8),hl
43B9: ED 53 BA 88 ld   ($88BA),de
43BD: C9          ret
43BE: 13          inc  de
43BF: 1A          ld   a,(de)
43C0: 4F          ld   c,a
43C1: 85          add  a,l
43C2: 30 01       jr   nc,$43C5
43C4: 24          inc  h
43C5: 6F          ld   l,a
43C6: 13          inc  de
43C7: 78          ld   a,b
43C8: 91          sub  c
43C9: 47          ld   b,a
43CA: 20 CB       jr   nz,$4397
43CC: 18 D7       jr   $43A5
43CE: 13          inc  de
43CF: 1A          ld   a,(de)
43D0: 6F          ld   l,a
43D1: 13          inc  de
43D2: 1A          ld   a,(de)
43D3: 67          ld   h,a
43D4: 13          inc  de
43D5: 1A          ld   a,(de)
43D6: 4F          ld   c,a
43D7: 3A B7 88    ld   a,($88B7)
43DA: 81          add  a,c
43DB: 32 B7 88    ld   ($88B7),a
43DE: 13          inc  de
43DF: 18 C7       jr   $43A8


4A0B: 3A 07 89    ld   a,($8907)
4A0E: CB 47       bit  0,a
4A10: C8          ret  z
4A11: 3A 02 89    ld   a,($8902)
4A14: 32 43 8D    ld   ($8D43),a
4A17: 32 34 89    ld   ($8934),a
4A1A: A7          and  a
4A1B: 20 0F       jr   nz,$4A2C
4A1D: 21 E3 86    ld   hl,$86E3
4A20: 22 32 89    ld   ($8932),hl
4A23: 2E 82       ld   l,$82
4A25: 11 54 27    ld   de,$2754
4A28: CD 07 33    call $3307
4A2B: C9          ret
4A2C: 47          ld   b,a
4A2D: 21 A3 86    ld   hl,$86A3
4A30: 22 32 89    ld   ($8932),hl
4A33: 2E C3       ld   l,$C3
4A35: 11 DF FF    ld   de,$FFDF
4A38: 36 DA       ld   (hl),$DA
4A3A: 23          inc  hl
4A3B: 36 DB       ld   (hl),$DB
4A3D: 19          add  hl,de
4A3E: 36 D8       ld   (hl),$D8
4A40: 23          inc  hl
4A41: 36 D9       ld   (hl),$D9
4A43: 19          add  hl,de
4A44: 10 F2       djnz $4A38
4A46: 1E BF       ld   e,$BF
4A48: 19          add  hl,de
4A49: 11 54 27    ld   de,$2754
4A4C: CD 07 33    call $3307
4A4F: C9          ret


50F1: 3A FB 89    ld   a,($89FB)
50F4: A7          and  a
50F5: 20 22       jr   nz,$5119
50F7: 21 C5 6A    ld   hl,$6AC5
50FA: 11 00 00    ld   de,$0000
50FD: 7E          ld   a,(hl)
50FE: FE C9       cp   $C9
5100: 28 08       jr   z,$510A
5102: 83          add  a,e
5103: 5F          ld   e,a
5104: 30 01       jr   nc,$5107
5106: 14          inc  d
5107: 23          inc  hl
5108: 18 F3       jr   $50FD
510A: 21 19 51    ld   hl,$5119
510D: 7B          ld   a,e
510E: BE          cp   (hl)
510F: C3 C5 6A    jp   $6AC5
5112: 7A          ld   a,d
5113: 23          inc  hl
5114: BE          cp   (hl)
5115: C2 2C 46    jp   nz,$462C
5118: C9          ret
5119: ED          db   $ed
511A: 1B          dec  de
511B: 3A 07 89    ld   a,($8907)
511E: CB 47       bit  0,a
5120: 28 1F       jr   z,$5141
5122: CD C5 54    call $54C5
5125: CD 19 55    call $5519
5128: CD 64 55    call $5564
512B: 3A 61 8F    ld   a,($8F61)
512E: A7          and  a
512F: 28 04       jr   z,$5135
5131: CD 71 11    call $1171
5134: C9          ret
5135: CD 46 51    call $5146
5138: 3A 6D 8D    ld   a,($8D6D)
513B: A7          and  a
513C: C0          ret  nz
513D: CD E8 56    call $56E8
5140: C9          ret
5141: CD B0 53    call $53B0
5144: 18 EF       jr   $5135
5146: CD 50 51    call $5150
5149: CD F6 52    call $52F6
514C: CD 34 53    call $5334
514F: C9          ret
5150: 3A 6D 8D    ld   a,($8D6D)
5153: A7          and  a
5154: C0          ret  nz
5155: 21 9A 51    ld   hl,$519A
5158: 3A 07 89    ld   a,($8907)
515B: E6 0F       and  $0F
515D: CD 45 0C    call $0C45
5160: EB          ex   de,hl
5161: 3A 01 89    ld   a,(nb_wolves_8901)
5164: FE 07       cp   $07
5166: D8          ret  c
5167: BE          cp   (hl)
5168: 28 05       jr   z,$516F
516A: D0          ret  nc
516B: 23          inc  hl
516C: 23          inc  hl
516D: 18 F8       jr   $5167
516F: 32 6D 8D    ld   ($8D6D),a
5172: 23          inc  hl
5173: 7E          ld   a,(hl)
5174: 47          ld   b,a
5175: 32 74 8D    ld   ($8D74),a
5178: 21 64 52    ld   hl,$5264
517B: CD 45 0C    call $0C45
517E: 1A          ld   a,(de)
517F: 32 73 8D    ld   ($8D73),a
5182: 13          inc  de
5183: ED 53 71 8D ld   ($8D71),de
5187: 78          ld   a,b
5188: 21 B0 52    ld   hl,$52B0
518B: CD 45 0C    call $0C45
518E: ED 53 6F 8D ld   ($8D6F),de
5192: AF          xor  a
5193: 32 7B 8D    ld   ($8D7B),a
5196: 32 7E 8D    ld   ($8D7E),a
5199: C9          ret

52F6: 3A 6D 8D    ld   a,($8D6D)
52F9: A7          and  a
52FA: C8          ret  z
52FB: 3A 6E 8D    ld   a,($8D6E)
52FE: A7          and  a
52FF: C0          ret  nz
5300: 01 00 06    ld   bc,$0600
5303: 21 E0 8A    ld   hl,$8AE0
5306: 11 17 00    ld   de,$0017
5309: 7E          ld   a,(hl)
530A: 2C          inc  l
530B: B6          or   (hl)
530C: 20 01       jr   nz,$530F
530E: 0C          inc  c
530F: 19          add  hl,de
5310: 10 F7       djnz $5309
5312: 79          ld   a,c
5313: FE 04       cp   $04
5315: D8          ret  c
5316: 32 6E 8D    ld   ($8D6E),a
5319: 11 F3 0B    ld   de,$0BF3
531C: 06 17       ld   b,$17
531E: AF          xor  a
531F: 6F          ld   l,a
5320: 67          ld   h,a
5321: 1A          ld   a,(de)
5322: E7          rst  $20
5323: 1B          dec  de
5324: 10 FB       djnz $5321
5326: 3E EB       ld   a,$EB
5328: 85          add  a,l
5329: 20 04       jr   nz,$532F
532B: 7C          ld   a,h
532C: C6 F7       add  a,$F7
532E: C8          ret  z
532F: 21 E8 89    ld   hl,$89E8
5332: 34          inc  (hl)
5333: C9          ret
5334: 3A 6E 8D    ld   a,($8D6E)
5337: A7          and  a
5338: C8          ret  z
5339: ED 5B 71 8D ld   de,($8D71)
533D: 1A          ld   a,(de)
533E: 3C          inc  a
533F: 20 14       jr   nz,$5355
5341: 3A 6D 8D    ld   a,($8D6D)
5344: 47          ld   b,a
5345: 3A 01 89    ld   a,(nb_wolves_8901)
5348: B8          cp   b
5349: D0          ret  nc
534A: AF          xor  a
534B: 32 6D 8D    ld   ($8D6D),a
534E: 32 6E 8D    ld   ($8D6E),a
5351: 32 07 8D    ld   ($8D07),a
5354: C9          ret
5355: 21 73 8D    ld   hl,$8D73
5358: 35          dec  (hl)
5359: C0          ret  nz
535A: 3D          dec  a
535B: 77          ld   (hl),a
535C: 13          inc  de
535D: ED 53 71 8D ld   ($8D71),de
5361: DD 21 E0 8A ld   ix,$8AE0
5365: 11 18 00    ld   de,$0018
5368: 06 06       ld   b,$06
536A: D9          exx
536B: CD 74 53    call $5374
536E: D9          exx
536F: DD 19       add  ix,de
5371: 10 F7       djnz $536A
5373: C9          ret
5374: DD 7E 00    ld   a,(ix+$00)
5377: DD B6 01    or   (ix+$01)
537A: C0          ret  nz
537B: 21 79 8D    ld   hl,$8D79
537E: 34          inc  (hl)
537F: DD 36 00 01 ld   (ix+$00),$01
5383: 3A 07 89    ld   a,($8907)
5386: 1E 1D       ld   e,$1D
5388: CB 47       bit  0,a
538A: 20 02       jr   nz,$538E
538C: 1E 04       ld   e,$04
538E: CD A0 53    call $53A0
5391: 21 A6 53    ld   hl,table_53A6
5394: 3A 74 8D    ld   a,($8D74)
5397: E7          rst  $20
5398: DD B6 07    or   (ix+$07)
539B: DD 77 07    ld   (ix+$07),a
539E: F1          pop  af
539F: C9          ret

53A0: 0E FF       ld   c,$FF
53A2: CD 33 57    call $5733
53A5: C9          ret


table_53A6:
  14 24 34 44 54 64 74 84 94 A4 A7 C8

53B2: 3A 59 8D    ld   a,($8D59)
53B5: A7          and  a
53B6: C0          ret  nz
53B7: 3A 5F 8A    ld   a,($8A5F)
53BA: A7          and  a
53BB: C0          ret  nz
53BC: 3C          inc  a
53BD: 32 59 8D    ld   ($8D59),a
53C0: DD 21 30 8C ld   ix,$8C30
53C4: 21 02 59    ld   hl,$5902
53C7: E7          rst  $20
53C8: DD 77 09    ld   (ix+$09),a
53CB: ED 44       neg
53CD: DD 77 0A    ld   (ix+$0a),a
53D0: DD 36 00 01 ld   (ix+$00),$01
53D4: DD 36 02 0B ld   (ix+$02),$0B
53D8: AF          xor  a
53D9: DD 77 03    ld   (ix+$03),a
53DC: DD 36 04 04 ld   (ix+$04),$04
53E0: DD 77 05    ld   (ix+$05),a
53E3: DD 77 06    ld   (ix+$06),a
53E6: 2F          cpl
53E7: 32 4B 8D    ld   ($8D4B),a
53EA: 11 03 42    ld   de,$4203
53ED: CD 1E 38    call $381E
53F0: 3A 07 89    ld   a,($8907)
53F3: CB 3F       srl  a
53F5: 3C          inc  a
53F6: FE 07       cp   $07
53F8: 38 02       jr   c,$53FC
53FA: 3E 06       ld   a,$06
53FC: 32 5C 8D    ld   ($8D5C),a
53FF: 21 07 54    ld   hl,table_5407
5402: E7          rst  $20
5403: 32 5D 8D    ld   ($8D5D),a
5406: C9          ret

table_5407:   FF  20 18  0C  0C	0B     
		
540D: 3A 07 89    ld   a,($8907)
5410: E6 01       and  $01
5412: C8          ret  z
5413: AF          xor  a
5414: 21 01 8D    ld   hl,$8D01
5417: 06 06       ld   b,$06
5419: D7          rst  $10
541A: 21 11 8D    ld   hl,$8D11
541D: 06 06       ld   b,$06
541F: D7          rst  $10
5420: DD 21 30 8C ld   ix,$8C30
5424: 11 18 00    ld   de,$0018
5427: 06 03       ld   b,$03
5429: D9          exx
542A: CD 33 54    call $5433
542D: D9          exx
542E: DD 19       add  ix,de
5430: 10 F7       djnz $5429
5432: C9          ret

5433: DD 7E 00    ld   a,(ix+$00)
5436: DD B6 01    or   (ix+$01)
5439: C0          ret  nz
543A: DD 36 00 01 ld   (ix+$00),$01
543E: AF          xor  a
543F: DD 77 02    ld   (ix+$02),a
5442: DD 77 05    ld   (ix+$05),a
5445: DD 36 03 60 ld   (ix+$03),$60
5449: DD 36 04 1B ld   (ix+$04),$1B
544D: DD 77 0E    ld   (ix+$0e),a
5450: 21 D4 55    ld   hl,$55D4
5453: 3A 01 8D    ld   a,($8D01)
5456: 4F          ld   c,a
5457: E7          rst  $20
5458: DD 77 06    ld   (ix+$06),a
545B: 21 D7 55    ld   hl,$55D7
545E: 79          ld   a,c
545F: E7          rst  $20
5460: ED 44       neg
5462: DD 77 0A    ld   (ix+$0a),a
5465: 21 1F 56    ld   hl,$561F
5468: 79          ld   a,c
5469: CD 45 0C    call $0C45
546C: 1A          ld   a,(de)
546D: DD 77 17    ld   (ix+$17),a
5470: 21 57 56    ld   hl,$5657
5473: CD 45 0C    call $0C45
5476: DD 73 0C    ld   (ix+$0c),e
5479: DD 72 0D    ld   (ix+$0d),d
547C: DD 36 11 40 ld   (ix+$11),$40
5480: CD 06 40    call $4006
5483: 79          ld   a,c
5484: 3C          inc  a
5485: 32 01 8D    ld   ($8D01),a
5488: C9          ret
5489: DD 36 00 01 ld   (ix+$00),$01
548D: AF          xor  a
548E: DD 77 02    ld   (ix+$02),a
5491: DD 77 05    ld   (ix+$05),a
5494: DD 36 03 60 ld   (ix+$03),$60
5498: DD 36 04 1B ld   (ix+$04),$1B
549C: DD 70 06    ld   (ix+$06),b
549F: DD 7E 17    ld   a,(ix+$17)
54A2: 4F          ld   c,a
54A3: 21 57 56    ld   hl,$5657
54A6: CD 45 0C    call $0C45
54A9: CD 1E 38    call $381E
54AC: DD 36 11 40 ld   (ix+$11),$40
54B0: 79          ld   a,c
54B1: 21 D7 55    ld   hl,$55D7
54B4: E7          rst  $20
54B5: 3A 07 89    ld   a,($8907)
54B8: E6 07       and  $07
54BA: 4F          ld   c,a
54BB: 87          add  a,a
54BC: 81          add  a,c
54BD: E7          rst  $20
54BE: ED 44       neg
54C0: DD 77 0A    ld   (ix+$0a),a
54C3: F1          pop  af
54C4: C9          ret
54C5: 3A 07 89    ld   a,($8907)
54C8: FE 04       cp   $04
54CA: 30 0F       jr   nc,$54DB
54CC: FE 02       cp   $02
54CE: 3A 20 88    ld   a,($8820)
54D1: 38 05       jr   c,$54D8
54D3: FE 02       cp   $02
54D5: D8          ret  c
54D6: 18 03       jr   $54DB
54D8: FE 03       cp   $03
54DA: D8          ret  c
54DB: 21 04 8D    ld   hl,$8D04
54DE: 35          dec  (hl)
54DF: C0          ret  nz
54E0: 21 EF 55    ld   hl,table_55EF
54E3: 3A 12 8D    ld   a,($8D12)
54E6: E6 0F       and  $0F
54E8: E7          rst  $20
54E9: 32 04 8D    ld   ($8D04),a
54EC: 21 12 8D    ld   hl,$8D12
54EF: 34          inc  (hl)
54F0: DD 21 30 8C ld   ix,$8C30
54F4: 11 18 00    ld   de,$0018
54F7: 06 01       ld   b,$01
54F9: D9          exx
54FA: DD 7E 00    ld   a,(ix+$00)
54FD: DD B6 01    or   (ix+$01)
5500: 20 11       jr   nz,$5513
5502: 06 0B       ld   b,$0B
5504: 21 37 56    ld   hl,$5637
5507: 3A 12 8D    ld   a,($8D12)
550A: E6 0F       and  $0F
550C: E7          rst  $20
550D: DD 77 17    ld   (ix+$17),a
5510: CD 89 54    call $5489
5513: D9          exx
5514: DD 19       add  ix,de
5516: 10 E1       djnz $54F9
5518: C9          ret
5519: 3A 07 89    ld   a,($8907)
551C: FE 02       cp   $02
551E: 30 06       jr   nc,$5526
5520: 3A 20 88    ld   a,($8820)
5523: FE 02       cp   $02
5525: D8          ret  c
5526: 21 05 8D    ld   hl,$8D05
5529: 35          dec  (hl)
552A: C0          ret  nz
552B: 21 FF 55    ld   hl,$55FF
552E: 3A 13 8D    ld   a,($8D13)
5531: E6 0F       and  $0F
5533: E7          rst  $20
5534: 32 05 8D    ld   ($8D05),a
5537: 21 13 8D    ld   hl,$8D13
553A: 34          inc  (hl)
553B: DD 21 48 8C ld   ix,$8C48
553F: 11 18 00    ld   de,$0018
5542: 06 01       ld   b,$01
5544: D9          exx
5545: DD 7E 00    ld   a,(ix+$00)
5548: DD B6 01    or   (ix+$01)
554B: 20 11       jr   nz,$555E
554D: 06 0F       ld   b,$0F
554F: 21 47 56    ld   hl,$5647
5552: 3A 13 8D    ld   a,($8D13)
5555: E6 0F       and  $0F
5557: E7          rst  $20
5558: DD 77 17    ld   (ix+$17),a
555B: CD 89 54    call $5489
555E: D9          exx
555F: DD 19       add  ix,de
5561: 10 E1       djnz $5544
5563: C9          ret
5564: 21 06 8D    ld   hl,$8D06
5567: 35          dec  (hl)
5568: C0          ret  nz
5569: 21 0F 56    ld   hl,$560F
556C: 3A 14 8D    ld   a,($8D14)
556F: E6 0F       and  $0F
5571: E7          rst  $20
5572: 32 06 8D    ld   ($8D06),a
5575: 21 14 8D    ld   hl,$8D14
5578: 34          inc  (hl)
5579: DD 21 60 8C ld   ix,$8C60
557D: 11 18 00    ld   de,$0018
5580: 3A 07 89    ld   a,($8907)
5583: FE 04       cp   $04
5585: 30 0B       jr   nc,$5592
5587: 3A 20 88    ld   a,($8820)
558A: A7          and  a
558B: C8          ret  z
558C: FE 04       cp   $04
558E: 06 01       ld   b,$01
5590: 38 02       jr   c,$5594
5592: 06 02       ld   b,$02
5594: D9          exx
5595: DD 7E 00    ld   a,(ix+$00)
5598: DD B6 01    or   (ix+$01)
559B: 20 31       jr   nz,$55CE
559D: 11 AD 0B    ld   de,$0BAD
55A0: 21 B5 55    ld   hl,table_55B5
55A3: 06 08       ld   b,$08
55A5: 1A          ld   a,(de)
55A6: 86          add  a,(hl)
55A7: 20 06       jr   nz,$55AF
55A9: 13          inc  de
55AA: 23          inc  hl
55AB: 10 F8       djnz $55A5
55AD: 18 0E       jr   $55BD
55AF: 21 1E 88    ld   hl,$881E
55B2: 34          inc  (hl)
55B3: 18 08       jr   $55BD


table_55B5:
	.byte	AA
	.byte	7A
	.byte	AD
	.byte	7A
	.byte	B2
	.byte	7A
	.byte	B5
	.byte	7A
	
55BD: 06 13       ld   b,$13
55BF: 21 27 56    ld   hl,$5627
55C2: 3A 14 8D    ld   a,($8D14)
55C5: E6 0F       and  $0F
55C7: E7          rst  $20
55C8: DD 77 17    ld   (ix+$17),a
55CB: CD 89 54    call $5489
55CE: D9          exx
55CF: DD 19       add  ix,de
55D1: 10 C1       djnz $5594
55D3: C9          ret
55D4: 0B          dec  bc
55D5: 0F          rrca
55D6: 13          inc  de
55D7: 10 18       djnz $55F1
55D9: 20 20       jr   nz,$55FB
55DB: 18 10       jr   $55ED

55DD: 
	.byte	28 18       
	.byte 	20 10       
	.byte 	18 20       
	.byte 	18 20       
	.byte 	10 28       
	.byte 	18 20       
	.byte 	10 18       
	.byte 	28 18    
   
55ED: 18 20       jr   $560F


56E8: 3A 07 8D    ld   a,($8D07)
56EB: A7          and  a
56EC: 28 05       jr   z,$56F3
56EE: 3D          dec  a
56EF: 32 07 8D    ld   ($8D07),a
56F2: C9          ret
56F3: 3A 07 89    ld   a,($8907)
56F6: CB 47       bit  0,a
56F8: CA 71 58    jp   z,$5871
56FB: 3A 01 89    ld   a,(nb_wolves_8901)
56FE: 21 40 8D    ld   hl,$8D40
5701: 96          sub  (hl)
5702: C8          ret  z
5703: D8          ret  c
5704: 4F          ld   c,a
5705: 3A 00 89    ld   a,(current_play_variables_8900)
5708: FE 03       cp   $03
570A: 38 04       jr   c,$5710
570C: 06 06       ld   b,$06
570E: 18 03       jr   $5713
5710: C6 04       add  a,$04
5712: 47          ld   b,a
5713: 3A 40 8D    ld   a,($8D40)
5716: B8          cp   b
5717: D0          ret  nc
5718: DD 21 E0 8A ld   ix,$8AE0
571C: 06 06       ld   b,$06
571E: 1E 1D       ld   e,$1D
5720: CD 2B 57    call $572B
5723: 11 18 00    ld   de,$0018
5726: DD 19       add  ix,de
5728: 10 F4       djnz $571E
572A: C9          ret
572B: DD 7E 00    ld   a,(ix+$00)
572E: DD B6 01    or   (ix+$01)
5731: 0F          rrca
5732: D8          ret  c
5733: 41          ld   b,c
5734: DD 36 00 01 ld   (ix+$00),$01
5738: DD 36 02 03 ld   (ix+$02),$03
573C: DD 73 04    ld   (ix+$04),e
573F: AF          xor  a
5740: DD 77 03    ld   (ix+$03),a
5743: DD 77 05    ld   (ix+$05),a
5746: DD 77 06    ld   (ix+$06),a
5749: DD 77 08    ld   (ix+$08),a
574C: DD 36 07 01 ld   (ix+$07),$01
5750: DD 77 0B    ld   (ix+$0b),a
5753: 21 E0 58    ld   hl,$58E0
5756: 3A 07 89    ld   a,($8907)
5759: E6 01       and  $01
575B: 20 03       jr   nz,$5760
575D: 21 02 59    ld   hl,$5902
5760: 3A 20 88    ld   a,($8820)
5763: FE 03       cp   $03
5765: 38 02       jr   c,$5769
5767: 3E 03       ld   a,$03
5769: 4F          ld   c,a
576A: 3A 08 89    ld   a,(nb_lives_8908)
576D: FE 04       cp   $04
576F: 38 05       jr   c,$5776
5771: 3A 4C 8D    ld   a,($8D4C)
5774: 81          add  a,c
5775: 4F          ld   c,a
5776: 3A 07 89    ld   a,($8907)
5779: CB 47       bit  0,a
577B: CC B4 57    call z,$57B4
577E: 3A 07 89    ld   a,($8907)
5781: 81          add  a,c
5782: 4F          ld   c,a
5783: FE 20       cp   $20
5785: 38 02       jr   c,$5789
5787: 3E 1F       ld   a,$1F
5789: 4F          ld   c,a
578A: E7          rst  $20
578B: DD 77 09    ld   (ix+$09),a
578E: ED 44       neg
5790: DD 77 0A    ld   (ix+$0a),a
5793: 11 29 38    ld   de,$3829
5796: CD 1E 38    call $381E
5799: 21 9B 58    ld   hl,$589B
579C: 3A 07 89    ld   a,($8907)
579F: E6 01       and  $01
57A1: 20 03       jr   nz,$57A6
57A3: 21 C0 58    ld   hl,$58C0
57A6: 79          ld   a,c
57A7: E7          rst  $20
57A8: 32 07 8D    ld   ($8D07),a
57AB: 21 40 8D    ld   hl,$8D40
57AE: 34          inc  (hl)
57AF: CD C3 57    call $57C3
57B2: F1          pop  af
57B3: C9          ret
57B4: 3A 01 89    ld   a,(nb_wolves_8901)
57B7: FE 03       cp   $03
57B9: D0          ret  nc
57BA: 3A 7D 8D    ld   a,($8D7D)
57BD: D6 0C       sub  $0C
57BF: D8          ret  c
57C0: 81          add  a,c
57C1: 4F          ld   c,a
57C2: C9          ret
57C3: 05          dec  b
57C4: 28 6F       jr   z,$5835
57C6: 21 46 8D    ld   hl,$8D46
57C9: 7E          ld   a,(hl)
57CA: A7          and  a
57CB: 28 2D       jr   z,$57FA
57CD: FE 07       cp   $07
57CF: 30 29       jr   nc,$57FA
57D1: 34          inc  (hl)
57D2: 2C          inc  l
57D3: 7E          ld   a,(hl)
57D4: A7          and  a
57D5: 28 0A       jr   z,$57E1
57D7: 35          dec  (hl)
57D8: DD 36 13 02 ld   (ix+$13),$02
57DC: DD 36 16 01 ld   (ix+$16),$01
57E0: C9          ret
57E1: 2C          inc  l
57E2: 7E          ld   a,(hl)
57E3: A7          and  a
57E4: 28 0A       jr   z,$57F0
57E6: 35          dec  (hl)
57E7: DD 36 13 01 ld   (ix+$13),$01
57EB: DD 36 16 C1 ld   (ix+$16),$C1
57EF: C9          ret
57F0: 2C          inc  l
57F1: 7E          ld   a,(hl)
57F2: A7          and  a
57F3: C8          ret  z
57F4: 35          dec  (hl)
57F5: DD 36 16 41 ld   (ix+$16),$41
57F9: C9          ret
57FA: 36 01       ld   (hl),$01
57FC: 3A 07 89    ld   a,($8907)
57FF: CB 47       bit  0,a
5801: 28 25       jr   z,$5828
5803: 3A 00 89    ld   a,(current_play_variables_8900)
5806: 4F          ld   c,a
5807: 3A 4C 8D    ld   a,($8D4C)
580A: 81          add  a,c
580B: FE 20       cp   $20
580D: 38 02       jr   c,$5811
580F: 3E 1F       ld   a,$1F
5811: 4F          ld   c,a
5812: EB          ex   de,hl
5813: 21 22 59    ld   hl,$5922
5816: 87          add  a,a
5817: 81          add  a,c
5818: E7          rst  $20
5819: 13          inc  de
581A: 12          ld   (de),a
581B: 23          inc  hl
581C: 13          inc  de
581D: 7E          ld   a,(hl)
581E: 12          ld   (de),a
581F: 23          inc  hl
5820: 13          inc  de
5821: 7E          ld   a,(hl)
5822: 12          ld   (de),a
5823: 06 FF       ld   b,$FF
5825: C3 C3 57    jp   $57C3
5828: FE 20       cp   $20
582A: 38 02       jr   c,$582E
582C: 3E 1F       ld   a,$1F
582E: 4F          ld   c,a
582F: EB          ex   de,hl
5830: 21 85 59    ld   hl,$5985
5833: 18 E1       jr   $5816
5835: 3A 4A 8D    ld   a,($8D4A)
5838: A7          and  a
5839: 20 8B       jr   nz,$57C6
583B: 3E 01       ld   a,$01
583D: 32 4A 8D    ld   ($8D4A),a
5840: DD 77 0B    ld   (ix+$0b),a
5843: DD 36 13 03 ld   (ix+$13),$03
5847: DD 77 16    ld   (ix+$16),a
584A: DD 36 07 02 ld   (ix+$07),$02
584E: 11 47 38    ld   de,$3847
5851: CD 1E 38    call $381E
5854: 21 B5 0B    ld   hl,$0BB5
5857: 06 52       ld   b,$52
5859: AF          xor  a
585A: 57          ld   d,a
585B: 5E          ld   e,(hl)
585C: 83          add  a,e
585D: 30 01       jr   nc,$5860
585F: 14          inc  d
5860: 23          inc  hl
5861: 10 F8       djnz $585B
5863: D6 C1       sub  $C1
5865: 20 04       jr   nz,$586B
5867: 3E 1D       ld   a,$1D
5869: BA          cp   d
586A: C8          ret  z
586B: 3E 01       ld   a,$01
586D: 32 2B 88    ld   ($882B),a
5870: C9          ret
5871: 32 00 89    ld   (current_play_variables_8900),a
5874: 3A 01 89    ld   a,(nb_wolves_8901)
5877: 21 40 8D    ld   hl,$8D40
587A: 96          sub  (hl)
587B: C8          ret  z
587C: D8          ret  c
587D: 3A 40 8D    ld   a,($8D40)
5880: FE 06       cp   $06
5882: D0          ret  nc
5883: 3E 01       ld   a,$01
5885: 32 4A 8D    ld   ($8D4A),a
5888: DD 21 E0 8A ld   ix,$8AE0
588C: 06 06       ld   b,$06
588E: 1E 04       ld   e,$04
5890: CD 2B 57    call $572B
5893: 11 18 00    ld   de,$0018
5896: DD 19       add  ix,de
5898: 10 F4       djnz $588E
589A: C9          ret

59E8: 3A 2C 88    ld   a,($882C)
59EB: FE 0F       cp   $0F
59ED: C8          ret  z
59EE: 3A 2F 88    ld   a,($882F)
59F1: FE 0F       cp   $0F
59F3: C8          ret  z
59F4: CD 06 5A    call $5A06
59F7: CD 56 5A    call $5A56
59FA: CD 1F 5A    call $5A1F
59FD: CD 9C 5A    call $5A9C
5A00: CD 6D 7E    call $7E6D
5A03: C3 C0 5A    jp   $5AC0
5A06: 3A 10 88    ld   a,($8810)
5A09: 0F          rrca
5A0A: 0F          rrca
5A0B: 0F          rrca
5A0C: 21 29 88    ld   hl,$8829
5A0F: CB 16       rl   (hl)
5A11: 7E          ld   a,(hl)
5A12: E6 07       and  $07
5A14: FE 01       cp   $01
5A16: C0          ret  nz
5A17: CD 09 0F    call $0F09
5A1A: 3E 01       ld   a,$01
5A1C: C3 8C 5A    jp   $5A8C
5A1F: 3A 10 88    ld   a,($8810)
5A22: 21 2D 88    ld   hl,$882D
5A25: 0F          rrca
5A26: 0F          rrca
5A27: CB 16       rl   (hl)
5A29: 7E          ld   a,(hl)
5A2A: E6 07       and  $07
5A2C: FE 01       cp   $01
5A2E: C0          ret  nz
5A2F: EB          ex   de,hl
5A30: CD 09 0F    call $0F09
5A33: 21 26 88    ld   hl,$8826
5A36: 34          inc  (hl)
5A37: EB          ex   de,hl
5A38: 23          inc  hl
5A39: 7E          ld   a,(hl)
5A3A: C6 10       add  a,$10
5A3C: 77          ld   (hl),a
5A3D: 47          ld   b,a
5A3E: 23          inc  hl
5A3F: 7E          ld   a,(hl)
5A40: 90          sub  b
5A41: D0          ret  nc
5A42: 7E          ld   a,(hl)
5A43: 4F          ld   c,a
5A44: E6 F0       and  $F0
5A46: C6 10       add  a,$10
5A48: 2B          dec  hl
5A49: ED 44       neg
5A4B: 86          add  a,(hl)
5A4C: 77          ld   (hl),a
5A4D: 79          ld   a,c
5A4E: E6 0F       and  $0F
5A50: FE 0F       cp   $0F
5A52: 20 38       jr   nz,$5A8C
5A54: 18 34       jr   $5A8A
5A56: 3A 10 88    ld   a,($8810)
5A59: 21 2A 88    ld   hl,$882A
5A5C: 0F          rrca
5A5D: CB 16       rl   (hl)
5A5F: 7E          ld   a,(hl)
5A60: E6 07       and  $07
5A62: FE 01       cp   $01
5A64: C0          ret  nz
5A65: EB          ex   de,hl
5A66: CD 09 0F    call $0F09
5A69: 21 24 88    ld   hl,$8824
5A6C: 34          inc  (hl)
5A6D: EB          ex   de,hl
5A6E: 23          inc  hl
5A6F: 7E          ld   a,(hl)
5A70: C6 10       add  a,$10
5A72: 77          ld   (hl),a
5A73: 47          ld   b,a
5A74: 23          inc  hl
5A75: 7E          ld   a,(hl)
5A76: 90          sub  b
5A77: D0          ret  nc
5A78: 7E          ld   a,(hl)
5A79: 4F          ld   c,a
5A7A: E6 F0       and  $F0
5A7C: C6 10       add  a,$10
5A7E: 2B          dec  hl
5A7F: ED 44       neg
5A81: 86          add  a,(hl)
5A82: 77          ld   (hl),a
5A83: 79          ld   a,c
5A84: E6 0F       and  $0F
5A86: FE 0F       cp   $0F
5A88: 20 02       jr   nz,$5A8C
5A8A: 3E 63       ld   a,$63
5A8C: 21 02 88    ld   hl,nb_credits_8802
5A8F: 86          add  a,(hl)
5A90: 77          ld   (hl),a
5A91: FE 63       cp   $63
5A93: 38 02       jr   c,$5A97
5A95: 36 63       ld   (hl),$63
5A97: 11 01 07    ld   de,$0701
5A9A: FF          rst  $38
5A9B: C9          ret
5A9C: 3A 24 88    ld   a,($8824)
5A9F: A7          and  a
5AA0: C8          ret  z
5AA1: 21 25 88    ld   hl,$8825
5AA4: 7E          ld   a,(hl)
5AA5: A7          and  a
5AA6: 20 07       jr   nz,$5AAF
5AA8: 36 30       ld   (hl),$30
5AAA: 3C          inc  a
5AAB: 32 83 A1    ld   ($A183),a
5AAE: C9          ret
5AAF: 35          dec  (hl)
5AB0: 28 09       jr   z,$5ABB
5AB2: 7E          ld   a,(hl)
5AB3: FE 18       cp   $18
5AB5: C0          ret  nz
5AB6: AF          xor  a
5AB7: 32 83 A1    ld   ($A183),a
5ABA: C9          ret
5ABB: 21 24 88    ld   hl,$8824
5ABE: 35          dec  (hl)
5ABF: C9          ret
5AC0: 3A 26 88    ld   a,($8826)
5AC3: A7          and  a
5AC4: C8          ret  z
5AC5: 21 27 88    ld   hl,$8827
5AC8: 7E          ld   a,(hl)
5AC9: A7          and  a
5ACA: 20 07       jr   nz,$5AD3
5ACC: 36 30       ld   (hl),$30
5ACE: 3C          inc  a
5ACF: 32 84 A1    ld   ($A184),a
5AD2: C9          ret
5AD3: 35          dec  (hl)
5AD4: 28 09       jr   z,$5ADF
5AD6: 7E          ld   a,(hl)
5AD7: FE 18       cp   $18
5AD9: C0          ret  nz
5ADA: AF          xor  a
5ADB: 32 84 A1    ld   ($A184),a
5ADE: C9          ret
5ADF: 21 26 88    ld   hl,$8826
5AE2: 35          dec  (hl)
5AE3: C9          ret
5AE4: CD 78 5E    call $5E78
5AE7: CD 6A 5F    call $5F6A
5AEA: CD 2F 60    call $602F
5AED: CD 68 63    call $6368
5AF0: CD F7 5D    call $5DF7
5AF3: CD 06 5B    call $5B06
5AF6: CD 4D 5D    call $5D4D
5AF9: CD 86 5B    call $5B86
5AFC: CD 04 64    call $6404
5AFF: CD 0B 5D    call $5D0B
5B02: CD 2C 5B    call $5B2C
5B05: C9          ret
5B06: 3A 07 89    ld   a,($8907)
5B09: FE 05       cp   $05
5B0B: C0          ret  nz
5B0C: FD 21 15 53 ld   iy,$5315
5B10: FD 55       ld   d,iyl
5B12: FD 5C       ld   e,iyh
5B14: AF          xor  a
5B15: 6F          ld   l,a
5B16: 67          ld   h,a
5B17: 06 06       ld   b,$06
5B19: 1A          ld   a,(de)
5B1A: 85          add  a,l
5B1B: 30 01       jr   nc,$5B1E
5B1D: 24          inc  h
5B1E: 6F          ld   l,a
5B1F: 13          inc  de
5B20: 10 F7       djnz $5B19
5B22: 84          add  a,h
5B23: C6 7F       add  a,$7F
5B25: C8          ret  z
5B26: 26 88       ld   h,$88
5B28: 2E 1E       ld   l,$1E
5B2A: 34          inc  (hl)
5B2B: C9          ret
5B2C: 3A 75 8D    ld   a,($8D75)
5B2F: A7          and  a
5B30: C8          ret  z
5B31: 3A 79 8D    ld   a,($8D79)
5B34: A7          and  a
5B35: C0          ret  nz
5B36: 3A 77 8D    ld   a,($8D77)
5B39: A7          and  a
5B3A: 20 1B       jr   nz,$5B57
5B3C: 21 E4 8A    ld   hl,$8AE4
5B3F: 11 18 00    ld   de,$0018
5B42: 06 06       ld   b,$06
5B44: 0E 13       ld   c,$13
5B46: 3A 07 89    ld   a,($8907)
5B49: CB 47       bit  0,a
5B4B: 28 02       jr   z,$5B4F
5B4D: 0E 0B       ld   c,$0B
5B4F: 7E          ld   a,(hl)
5B50: B9          cp   c
5B51: 28 04       jr   z,$5B57
5B53: 19          add  hl,de
5B54: 10 F9       djnz $5B4F
5B56: C9          ret
5B57: DD 21 E0 8A ld   ix,$8AE0
5B5B: 11 18 00    ld   de,$0018
5B5E: 06 06       ld   b,$06
5B60: D9          exx
5B61: CD 71 5B    call $5B71
5B64: D9          exx
5B65: DD 19       add  ix,de
5B67: 10 F7       djnz $5B60
5B69: AF          xor  a
5B6A: 32 75 8D    ld   ($8D75),a
5B6D: 32 20 8F    ld   ($8F20),a
5B70: C9          ret
5B71: DD 7E 02    ld   a,(ix+$02)
5B74: FE 05       cp   $05
5B76: C0          ret  nz
5B77: DD CB 07 56 bit  2,(ix+$07)
5B7B: C8          ret  z
5B7C: DD 7E 06    ld   a,(ix+$06)
5B7F: FE 11       cp   $11
5B81: D0          ret  nc
5B82: CD 6C 3A    call $3A6C
5B85: C9          ret
5B86: DD 21 E0 8A ld   ix,$8AE0
5B8A: 11 18 00    ld   de,$0018
5B8D: 06 06       ld   b,$06
5B8F: D9          exx
5B90: CD 99 5B    call $5B99
5B93: D9          exx
5B94: DD 19       add  ix,de
5B96: 10 F7       djnz $5B8F
5B98: C9          ret
5B99: DD CB 0B 46 bit  0,(ix+$0b)
5B9D: 20 06       jr   nz,$5BA5
5B9F: 3A 07 89    ld   a,($8907)
5BA2: CB 47       bit  0,a
5BA4: C0          ret  nz
5BA5: DD CB 00 46 bit  0,(ix+$00)
5BA9: C8          ret  z
5BAA: DD CB 16 46 bit  0,(ix+$16)
5BAE: C8          ret  z
5BAF: DD 7E 02    ld   a,(ix+$02)
5BB2: FE 05       cp   $05
5BB4: C0          ret  nz
5BB5: 21 48 88    ld   hl,$8848
5BB8: FD 21 90 8C ld   iy,$8C90
5BBC: 06 02       ld   b,$02
5BBE: FD CB 00 46 bit  0,(iy+$00)
5BC2: CA 46 5C    jp   z,$5C46
5BC5: FD CB 00 4E bit  1,(iy+$00)
5BC9: 20 7B       jr   nz,$5C46
5BCB: 1E 10       ld   e,$10
5BCD: 3A 1F 88    ld   a,($881F)
5BD0: A7          and  a
5BD1: 20 02       jr   nz,$5BD5
5BD3: 1E 08       ld   e,$08
5BD5: DD 7E 06    ld   a,(ix+$06)
5BD8: DD 4E 05    ld   c,(ix+$05)
5BDB: CB 01       rlc  c
5BDD: 17          rla
5BDE: CB 01       rlc  c
5BE0: 17          rla
5BE1: CB 01       rlc  c
5BE3: 17          rla
5BE4: 83          add  a,e
5BE5: FD 96 06    sub  (iy+$06)
5BE8: 30 02       jr   nc,$5BEC
5BEA: ED 44       neg
5BEC: FE 10       cp   $10
5BEE: 30 56       jr   nc,$5C46
5BF0: 2C          inc  l
5BF1: 2C          inc  l
5BF2: 1E 16       ld   e,$16
5BF4: 3A 07 89    ld   a,($8907)
5BF7: CB 47       bit  0,a
5BF9: 20 02       jr   nz,$5BFD
5BFB: 1E 12       ld   e,$12
5BFD: DD 7E 04    ld   a,(ix+$04)
5C00: DD 4E 03    ld   c,(ix+$03)
5C03: CB 01       rlc  c
5C05: 17          rla
5C06: CB 01       rlc  c
5C08: 17          rla
5C09: CB 01       rlc  c
5C0B: 17          rla
5C0C: 93          sub  e
5C0D: FD 96 04    sub  (iy+$04)
5C10: 30 02       jr   nc,$5C14
5C12: ED 44       neg
5C14: FE 09       cp   $09
5C16: 30 30       jr   nc,$5C48
5C18: 11 80 5C    ld   de,$5C80
5C1B: DD CB 07 4E bit  1,(ix+$07)
5C1F: 28 03       jr   z,$5C24
5C21: 11 89 5C    ld   de,$5C89
5C24: CD 1E 38    call $381E
5C27: DD 36 12 10 ld   (ix+$12),$10
5C2B: DD 36 16 02 ld   (ix+$16),$02
5C2F: FD 21 70 8B ld   iy,$8B70
5C33: 11 18 00    ld   de,$0018
5C36: 06 05       ld   b,$05
5C38: DD 7E 14    ld   a,(ix+$14)
5C3B: FD BE 14    cp   (iy+$14)
5C3E: 28 14       jr   z,$5C54
5C40: FD 19       add  iy,de
5C42: 10 F4       djnz $5C38
5C44: F1          pop  af
5C45: C9          ret
5C46: 2C          inc  l
5C47: 2C          inc  l
5C48: 2C          inc  l
5C49: 2C          inc  l
5C4A: 11 18 00    ld   de,$0018
5C4D: FD 19       add  iy,de
5C4F: 05          dec  b
5C50: C2 BE 5B    jp   nz,$5BBE
5C53: C9          ret
5C54: 21 92 5C    ld   hl,$5C92
5C57: DD 7E 07    ld   a,(ix+$07)
5C5A: E6 F0       and  $F0
5C5C: 0F          rrca
5C5D: 0F          rrca
5C5E: 0F          rrca
5C5F: 0F          rrca
5C60: CD 45 0C    call $0C45
5C63: FD CB 0B 46 bit  0,(iy+$0b)
5C67: 28 03       jr   z,$5C6C
5C69: 11 F9 5C    ld   de,$5CF9
5C6C: FD 36 16 02 ld   (iy+$16),$02
5C70: CD 75 5C    call $5C75
5C73: F1          pop  af
5C74: C9          ret
5C75: FD 73 0C    ld   (iy+$0c),e
5C78: FD 72 0D    ld   (iy+$0d),d
5C7B: FD 36 0E 00 ld   (iy+$0e),$00
5C7F: C9          ret

5D0C: 21 E0 8A    ld   hl,$8AE0
5D0F: 11 18 00    ld   de,$0018
5D12: 06 06       ld   b,$06
5D14: D9          exx
5D15: CD 1E 5D    call $5D1E
5D18: D9          exx
5D19: DD 19       add  ix,de
5D1B: 10 F7       djnz $5D14
5D1D: C9          ret
5D1E: DD CB 0B 46 bit  0,(ix+$0b)
5D22: 20 06       jr   nz,$5D2A
5D24: 3A 07 89    ld   a,($8907)
5D27: CB 47       bit  0,a
5D29: C0          ret  nz
5D2A: DD CB 00 46 bit  0,(ix+$00)
5D2E: C8          ret  z
5D2F: DD CB 16 4E bit  1,(ix+$16)
5D33: C8          ret  z
5D34: DD 35 12    dec  (ix+$12)
5D37: C0          ret  nz
5D38: DD 7E 13    ld   a,(ix+$13)
5D3B: E6 03       and  $03
5D3D: 28 09       jr   z,$5D48
5D3F: 3D          dec  a
5D40: DD 77 13    ld   (ix+$13),a
5D43: DD 36 16 01 ld   (ix+$16),$01
5D47: C9          ret
5D48: DD 36 16 00 ld   (ix+$16),$00
5D4C: C9          ret
5D4D: DD 21 9C 88 ld   ix,$889C
5D51: FD 21 7C 88 ld   iy,sprite_shadow_ram_8840+$3C
5D55: 21 E8 8B    ld   hl,$8BE8
5D58: 06 03       ld   b,$03
5D5A: CD 68 5D    call $5D68
5D5D: 11 04 00    ld   de,$0004
5D60: FD 19       add  iy,de
5D62: 1E 18       ld   e,$18
5D64: 19          add  hl,de
5D65: 10 F3       djnz $5D5A
5D67: C9          ret
5D68: 7E          ld   a,(hl)
5D69: A7          and  a
5D6A: C8          ret  z
5D6B: FE 05       cp   $05
5D6D: C8          ret  z
5D6E: 1E FC       ld   e,$FC
5D70: 16 00       ld   d,$00
5D72: 3A 1F 88    ld   a,($881F)
5D75: A7          and  a
5D76: 20 04       jr   nz,$5D7C
5D78: 1E 05       ld   e,$05
5D7A: 16 10       ld   d,$10
5D7C: DD 7E 00    ld   a,(ix+$00)
5D7F: 83          add  a,e
5D80: 5F          ld   e,a
5D81: DD 7E 02    ld   a,(ix+$02)
5D84: 82          add  a,d
5D85: 57          ld   d,a
5D86: FD 7E 00    ld   a,(iy+$00)
5D89: 93          sub  e
5D8A: 30 02       jr   nc,$5D8E
5D8C: ED 44       neg
5D8E: FE 04       cp   $04
5D90: D0          ret  nc
5D91: FD 7E 02    ld   a,(iy+$02)
5D94: C6 08       add  a,$08
5D96: 92          sub  d
5D97: 30 02       jr   nc,$5D9B
5D99: ED 44       neg
5D9B: FE 09       cp   $09
5D9D: D8          ret  c
5D9E: FE 0F       cp   $0F
5DA0: D0          ret  nc
5DA1: E5          push hl
5DA2: DD E1       pop  ix
5DA4: DD 36 00 00 ld   (ix+$00),$00
5DA8: DD 36 01 01 ld   (ix+$01),$01
5DAC: DD 36 02 0C ld   (ix+$02),$0C
5DB0: DD 36 07 01 ld   (ix+$07),$01
5DB4: 21 C2 5D    ld   hl,$5DC2
5DB7: DD 74 13    ld   (ix+$13),h
5DBA: DD 75 12    ld   (ix+$12),l
5DBD: CD 2B 0F    call $0F2B
5DC0: F1          pop  af
5DC1: C9          ret

5DF7: 3A 32 8D    ld   a,($8D32)
5DFA: A7          and  a
5DFB: C0          ret  nz
5DFC: 3A 08 8F    ld   a,($8F08)
5DFF: 21 24 8F    ld   hl,$8F24
5E02: B6          or   (hl)
5E03: C0          ret  nz
5E04: DD 21 40 88 ld   ix,sprite_shadow_ram_8840
5E08: FD 21 7C 88 ld   iy,sprite_shadow_ram_8840+$3C
5E0C: 21 E8 8B    ld   hl,$8BE8
5E0F: 06 03       ld   b,$03
5E11: CD 1F 5E    call $5E1F
5E14: 11 04 00    ld   de,$0004
5E17: FD 19       add  iy,de
5E19: 1E 18       ld   e,$18
5E1B: 19          add  hl,de
5E1C: 10 F3       djnz $5E11
5E1E: C9          ret
5E1F: 7E          ld   a,(hl)
5E20: A7          and  a
5E21: C8          ret  z
5E22: FE 05       cp   $05
5E24: C8          ret  z
5E25: 1E 09       ld   e,$09
5E27: 16 00       ld   d,$00
5E29: 3A 1F 88    ld   a,($881F)
5E2C: A7          and  a
5E2D: 20 04       jr   nz,$5E33
5E2F: 1E F7       ld   e,$F7
5E31: 16 10       ld   d,$10
5E33: DD 7E 00    ld   a,(ix+$00)
5E36: 83          add  a,e
5E37: 5F          ld   e,a
5E38: DD 7E 02    ld   a,(ix+$02)
5E3B: 82          add  a,d
5E3C: 57          ld   d,a
5E3D: FD 7E 00    ld   a,(iy+$00)
5E40: 93          sub  e
5E41: 30 02       jr   nc,$5E45
5E43: ED 44       neg
5E45: FE 02       cp   $02
5E47: D0          ret  nc
5E48: FD 7E 02    ld   a,(iy+$02)
5E4B: C6 08       add  a,$08
5E4D: 92          sub  d
5E4E: 30 02       jr   nc,$5E52
5E50: ED 44       neg
5E52: FE 09       cp   $09
; collision detection (rocks)
5E54: D0          ret  nc
5E55: 3E 01       ld   a,$01
5E57: 32 32 8D    ld   ($8D32),a
5E5A: E5          push hl
5E5B: DD E1       pop  ix
5E5D: 11 B4 40    ld   de,$40B4
5E60: CD 1E 38    call $381E
5E63: DD 36 11 0A ld   (ix+$11),$0A
5E67: DD 36 00 00 ld   (ix+$00),$00
5E6B: DD 36 01 01 ld   (ix+$01),$01
5E6F: DD 36 02 02 ld   (ix+$02),$02
5E73: CD 15 0F    call $0F15
5E76: F1          pop  af
5E77: C9          ret
5E78: 3A 07 89    ld   a,($8907)
5E7B: E6 01       and  $01
5E7D: C8          ret  z
5E7E: FD 21 48 88 ld   iy,$8848
5E82: 06 02       ld   b,$02
5E84: 11 04 00    ld   de,$0004
5E87: AF          xor  a
5E88: ED 47       ld   i,a
5E8A: D9          exx
5E8B: CD 98 5E    call $5E98
5E8E: D9          exx
5E8F: FD 19       add  iy,de
5E91: 3E 01       ld   a,$01
5E93: ED 47       ld   i,a
5E95: 10 F3       djnz $5E8A
5E97: C9          ret
5E98: ED 57       ld   a,i
5E9A: DD 21 90 8C ld   ix,$8C90
5E9E: A7          and  a
5E9F: 28 04       jr   z,$5EA5
5EA1: DD 21 A8 8C ld   ix,$8CA8
5EA5: DD CB 00 46 bit  0,(ix+$00)
5EA9: C8          ret  z
5EAA: DD 22 65 8D ld   ($8D65),ix
5EAE: DD CB 00 4E bit  1,(ix+$00)
5EB2: DD 21 88 88 ld   ix,sprite_shadow_ram_8840+$48
5EB6: 06 04       ld   b,$04
5EB8: 21 30 8C    ld   hl,$8C30
5EBB: 20 54       jr   nz,$5F11
5EBD: 7E          ld   a,(hl)
5EBE: A7          and  a
5EBF: 28 45       jr   z,$5F06
5EC1: 2C          inc  l
5EC2: 2C          inc  l
5EC3: 7E          ld   a,(hl)
5EC4: 2D          dec  l
5EC5: 2D          dec  l
5EC6: FE 04       cp   $04
5EC8: 30 3C       jr   nc,$5F06
5ECA: CD 53 5F    call $5F53
5ECD: 30 37       jr   nc,$5F06
5ECF: 57          ld   d,a
5ED0: FD 7E 00    ld   a,(iy+$00)
5ED3: 93          sub  e
5ED4: 30 02       jr   nc,$5ED8
5ED6: ED 44       neg
5ED8: FE 0A       cp   $0A
5EDA: 30 2A       jr   nc,$5F06
5EDC: FD 7E 02    ld   a,(iy+$02)
5EDF: C6 08       add  a,$08
5EE1: 92          sub  d
5EE2: 30 02       jr   nc,$5EE6
5EE4: ED 44       neg
5EE6: FE 09       cp   $09
5EE8: 30 1C       jr   nc,$5F06
5EEA: AF          xor  a
5EEB: 77          ld   (hl),a
5EEC: 23          inc  hl
5EED: 36 01       ld   (hl),$01
5EEF: 23          inc  hl
5EF0: 36 08       ld   (hl),$08
5EF2: DD 2A 65 8D ld   ix,($8D65)
5EF6: DD CB 07 46 bit  0,(ix+$07)
5EFA: 20 06       jr   nz,$5F02
5EFC: 2A 65 8D    ld   hl,($8D65)
5EFF: 06 17       ld   b,$17
5F01: D7          rst  $10
5F02: CD F1 0E    call $0EF1
5F05: C9          ret
5F06: 11 04 00    ld   de,$0004
5F09: DD 19       add  ix,de
5F0B: 1E 18       ld   e,$18
5F0D: 19          add  hl,de
5F0E: 10 AD       djnz $5EBD
5F10: C9          ret
5F11: 7E          ld   a,(hl)
5F12: A7          and  a
5F13: 28 32       jr   z,$5F47
5F15: FE 03       cp   $03
5F17: 28 2E       jr   z,$5F47
5F19: CD 53 5F    call $5F53
5F1C: 30 29       jr   nc,$5F47
5F1E: 57          ld   d,a
5F1F: FD 7E 00    ld   a,(iy+$00)
5F22: 93          sub  e
5F23: 30 02       jr   nc,$5F27
5F25: ED 44       neg
5F27: FE 07       cp   $07
5F29: 30 1C       jr   nc,$5F47
5F2B: FD 7E 02    ld   a,(iy+$02)
5F2E: C6 08       add  a,$08
5F30: 92          sub  d
5F31: 30 02       jr   nc,$5F35
5F33: ED 44       neg
5F35: FE 06       cp   $06
5F37: 30 0E       jr   nc,$5F47
5F39: 36 03       ld   (hl),$03
5F3B: 21 19 8D    ld   hl,$8D19
5F3E: ED 57       ld   a,i
5F40: 28 01       jr   z,$5F43
5F42: 2C          inc  l
5F43: 36 01       ld   (hl),$01
5F45: 18 BB       jr   $5F02
5F47: 11 04 00    ld   de,$0004
5F4A: DD 19       add  ix,de
5F4C: 11 18 00    ld   de,$0018
5F4F: 19          add  hl,de
5F50: 10 BF       djnz $5F11
5F52: C9          ret
5F53: 1E 06       ld   e,$06
5F55: 3A 1F 88    ld   a,($881F)
5F58: A7          and  a
5F59: 20 02       jr   nz,$5F5D
5F5B: 1E FE       ld   e,$FE
5F5D: DD 7E 00    ld   a,(ix+$00)
5F60: 83          add  a,e
5F61: 5F          ld   e,a
5F62: DD 7E 02    ld   a,(ix+$02)
5F65: C6 08       add  a,$08
5F67: FE E0       cp   $E0
5F69: C9          ret
5F6A: FD 21 48 88 ld   iy,$8848
5F6E: 06 02       ld   b,$02
5F70: 11 04 00    ld   de,$0004
5F73: AF          xor  a
5F74: ED 47       ld   i,a
5F76: D9          exx
5F77: CD 83 5F    call $5F83
5F7A: D9          exx
5F7B: FD 19       add  iy,de
5F7D: 78          ld   a,b
5F7E: ED 47       ld   i,a
5F80: 10 F4       djnz $5F76
5F82: C9          ret
5F83: DD 21 90 8C ld   ix,$8C90
5F87: ED 57       ld   a,i
5F89: A7          and  a
5F8A: 28 04       jr   z,$5F90
5F8C: DD 21 A8 8C ld   ix,$8CA8
5F90: DD 7E 00    ld   a,(ix+$00)
5F93: A7          and  a
5F94: C8          ret  z
5F95: 32 44 8D    ld   ($8D44),a
5F98: 4F          ld   c,a
5F99: DD 21 50 88 ld   ix,sprite_shadow_ram_8840+$10
5F9D: 06 06       ld   b,$06
5F9F: 21 E0 8A    ld   hl,$8AE0
5FA2: 7E          ld   a,(hl)
5FA3: A7          and  a
5FA4: 28 72       jr   z,$6018
5FA6: 2C          inc  l
5FA7: 2C          inc  l
5FA8: 7E          ld   a,(hl)
5FA9: 2D          dec  l
5FAA: 2D          dec  l
5FAB: FE 05       cp   $05
5FAD: 20 69       jr   nz,$6018
5FAF: 1E 06       ld   e,$06
5FB1: 3A 1F 88    ld   a,($881F)
5FB4: A7          and  a
5FB5: 20 02       jr   nz,$5FB9
5FB7: 1E FB       ld   e,$FB
5FB9: DD 7E 00    ld   a,(ix+$00)
5FBC: 83          add  a,e
5FBD: 5F          ld   e,a
5FBE: DD 7E 02    ld   a,(ix+$02)
5FC1: C6 08       add  a,$08
5FC3: 57          ld   d,a
5FC4: FD 7E 00    ld   a,(iy+$00)
5FC7: 93          sub  e
5FC8: 30 02       jr   nc,$5FCC
5FCA: ED 44       neg
5FCC: 5F          ld   e,a
5FCD: 79          ld   a,c
5FCE: FE 03       cp   $03
5FD0: 7B          ld   a,e
5FD1: 20 06       jr   nz,$5FD9
5FD3: FE 10       cp   $10
5FD5: 30 41       jr   nc,$6018
5FD7: 18 04       jr   $5FDD
5FD9: FE 08       cp   $08
5FDB: 30 3B       jr   nc,$6018
5FDD: FD 7E 02    ld   a,(iy+$02)
5FE0: C6 08       add  a,$08
5FE2: 92          sub  d
5FE3: 30 02       jr   nc,$5FE7
5FE5: ED 44       neg
5FE7: 5F          ld   e,a
5FE8: 79          ld   a,c
5FE9: FE 03       cp   $03
5FEB: 7B          ld   a,e
5FEC: 20 06       jr   nz,$5FF4
5FEE: FE 12       cp   $12
5FF0: 30 26       jr   nc,$6018
5FF2: 18 04       jr   $5FF8
5FF4: FE 08       cp   $08
5FF6: 30 20       jr   nc,$6018
5FF8: 79          ld   a,c
5FF9: FE 03       cp   $03
5FFB: 28 28       jr   z,$6025
5FFD: FD E5       push iy
5FFF: E1          pop  hl
6000: 7D          ld   a,l
6001: 21 91 8C    ld   hl,$8C91
6004: FE 48       cp   $48
6006: 28 03       jr   z,$600B
6008: 21 A9 8C    ld   hl,$8CA9
600B: 36 01       ld   (hl),$01
600D: 11 06 00    ld   de,$0006
6010: 19          add  hl,de
6011: 36 01       ld   (hl),$01
6013: CD 01 0F    call $0F01
6016: F1          pop  af
6017: C9          ret
6018: 11 04 00    ld   de,$0004
601B: DD 19       add  ix,de
601D: 1E 18       ld   e,$18
601F: 19          add  hl,de
6020: 05          dec  b
6021: C2 A2 5F    jp   nz,$5FA2
6024: C9          ret
6025: E5          push hl
6026: FD E1       pop  iy
6028: 21 45 8D    ld   hl,$8D45
602B: 34          inc  (hl)
602C: C3 3D 61    jp   $613D
602F: FD 21 48 88 ld   iy,$8848
6033: 06 02       ld   b,$02
6035: AF          xor  a
6036: ED 47       ld   i,a
6038: 11 04 00    ld   de,$0004
603B: D9          exx
603C: CD 48 60    call $6048
603F: D9          exx
6040: FD 19       add  iy,de
6042: 78          ld   a,b
6043: ED 47       ld   i,a
6045: 10 F4       djnz $603B
6047: C9          ret
6048: DD 21 90 8C ld   ix,$8C90
604C: ED 57       ld   a,i
604E: A7          and  a
604F: 28 04       jr   z,$6055
6051: DD 21 A8 8C ld   ix,$8CA8
6055: DD 7E 00    ld   a,(ix+$00)
6058: A7          and  a
6059: C8          ret  z
605A: FE 03       cp   $03
605C: C8          ret  z
605D: 32 44 8D    ld   ($8D44),a
6060: DD 21 68 88 ld   ix,$8868
6064: 06 05       ld   b,$05
6066: 21 70 8B    ld   hl,$8B70
6069: 7E          ld   a,(hl)
606A: A7          and  a
606B: CA F2 60    jp   z,$60F2
606E: 2C          inc  l
606F: 2C          inc  l
6070: 7E          ld   a,(hl)
6071: 2D          dec  l
6072: 2D          dec  l
6073: FE 05       cp   $05
6075: C2 F2 60    jp   nz,$60F2
6078: 3A 07 89    ld   a,($8907)
607B: CB 47       bit  0,a
607D: C2 B4 61    jp   nz,$61B4
6080: 1E 06       ld   e,$06
6082: 3A 1F 88    ld   a,($881F)
6085: A7          and  a
6086: 20 02       jr   nz,$608A
6088: 1E FE       ld   e,$FE
608A: DD 7E 00    ld   a,(ix+$00)
608D: 83          add  a,e
608E: 5F          ld   e,a
608F: DD 7E 02    ld   a,(ix+$02)
6092: C6 08       add  a,$08
6094: 57          ld   d,a
6095: FD 7E 00    ld   a,(iy+$00)
6098: 93          sub  e
6099: 30 02       jr   nc,$609D
609B: ED 44       neg
609D: FE 09       cp   $09
609F: 30 51       jr   nc,$60F2
60A1: FD 7E 02    ld   a,(iy+$02)
60A4: C6 08       add  a,$08
60A6: 92          sub  d
60A7: 30 02       jr   nc,$60AB
60A9: ED 44       neg
60AB: FE 08       cp   $08
60AD: 30 43       jr   nc,$60F2
60AF: 11 14 00    ld   de,$0014
60B2: 19          add  hl,de
60B3: FD 21 E0 8A ld   iy,$8AE0
60B7: 7E          ld   a,(hl)
60B8: 0E 06       ld   c,$06
60BA: 1E 18       ld   e,$18
60BC: FD BE 14    cp   (iy+$14)
60BF: 28 07       jr   z,$60C8
60C1: FD 19       add  iy,de
60C3: 0D          dec  c
60C4: 20 F6       jr   nz,$60BC
60C6: 18 0D       jr   $60D5
60C8: FD CB 16 4E bit  1,(iy+$16)
60CC: 28 07       jr   z,$60D5
60CE: 3A 44 8D    ld   a,($8D44)
60D1: FE 03       cp   $03
60D3: 20 2A       jr   nz,$60FF
60D5: 11 EC FF    ld   de,$FFEC
60D8: 19          add  hl,de
60D9: FD 21 1C 8D ld   iy,$8D1C
60DD: ED 57       ld   a,i
60DF: 20 02       jr   nz,$60E3
60E1: FD 2B       dec  iy
60E3: FD 36 00 01 ld   (iy+$00),$01
60E7: 11 04 04    ld   de,$0404
60EA: CD 9F 61    call $619F
60ED: 11 FD FF    ld   de,$FFFD
60F0: 18 2D       jr   $611F
60F2: 11 04 00    ld   de,$0004
60F5: DD 19       add  ix,de
60F7: 1E 18       ld   e,$18
60F9: 19          add  hl,de
60FA: 05          dec  b
60FB: C2 69 60    jp   nz,$6069
60FE: C9          ret
60FF: DD 21 90 8C ld   ix,$8C90
6103: ED 57       ld   a,i
6105: 28 04       jr   z,$610B
6107: DD 21 A8 8C ld   ix,$8CA8
610B: DD 36 01 01 ld   (ix+$01),$01
610F: DD 36 07 01 ld   (ix+$07),$01
6113: CD 01 0F    call $0F01
6116: F1          pop  af
6117: C9          ret
6118: 3A 45 8D    ld   a,($8D45)
611B: 3C          inc  a
611C: 32 45 8D    ld   ($8D45),a
611F: 19          add  hl,de
6120: 7E          ld   a,(hl)
6121: 06 06       ld   b,$06
6123: 11 18 00    ld   de,$0018
6126: FD 21 E0 8A ld   iy,$8AE0
612A: FD BE 14    cp   (iy+$14)
612D: 28 0E       jr   z,$613D
612F: FD 19       add  iy,de
6131: 10 F7       djnz $612A
6133: 3A 44 8D    ld   a,($8D44)
6136: FE 03       cp   $03
6138: C8          ret  z
6139: CD F1 0E    call $0EF1
613C: C9          ret
613D: FD CB 00 46 bit  0,(iy+$00)
6141: 28 47       jr   z,$618A
6143: 3A 07 89    ld   a,($8907)
6146: E6 01       and  $01
6148: 20 1C       jr   nz,$6166
614A: 3A 44 8D    ld   a,($8D44)
614D: FE 03       cp   $03
614F: 20 15       jr   nz,$6166
6151: FD 7E 14    ld   a,(iy+$14)
6154: DD 21 70 8B ld   ix,$8B70
6158: 11 18 00    ld   de,$0018
615B: 06 06       ld   b,$06
615D: DD BE 14    cp   (ix+$14)
6160: 28 2E       jr   z,$6190
6162: DD 19       add  ix,de
6164: 10 F7       djnz $615D
6166: AF          xor  a
6167: FD 77 00    ld   (iy+$00),a
616A: FD 36 01 01 ld   (iy+$01),$01
616E: FD 36 02 08 ld   (iy+$02),$08
6172: FD 36 16 07 ld   (iy+$16),$07
6176: FD 36 17 05 ld   (iy+$17),$05
617A: FD 77 14    ld   (iy+$14),a
617D: FD 77 13    ld   (iy+$13),a
6180: 3A 44 8D    ld   a,($8D44)
6183: FE 03       cp   $03
6185: 20 13       jr   nz,$619A
6187: CD FD 0E    call $0EFD
618A: AF          xor  a
618B: 32 44 8D    ld   ($8D44),a
618E: F1          pop  af
618F: C9          ret
6190: DD 36 08 01 ld   (ix+$08),$01
6194: DD 36 0A D0 ld   (ix+$0a),$D0
6198: 18 CC       jr   $6166
619A: CD F1 0E    call $0EF1
619D: 18 EB       jr   $618A
619F: 36 00       ld   (hl),$00
61A1: 23          inc  hl
61A2: 36 01       ld   (hl),$01
61A4: 23          inc  hl
61A5: 36 08       ld   (hl),$08
61A7: 01 10 00    ld   bc,$0010
61AA: 09          add  hl,bc
61AB: 36 FF       ld   (hl),$FF
61AD: 0E 04       ld   c,$04
61AF: 09          add  hl,bc
61B0: 73          ld   (hl),e
61B1: 23          inc  hl
61B2: 72          ld   (hl),d
61B3: C9          ret
61B4: E5          push hl
61B5: FD E5       push iy
61B7: C5          push bc
61B8: 7D          ld   a,l
61B9: C6 14       add  a,$14
61BB: 6F          ld   l,a
61BC: 7E          ld   a,(hl)
61BD: FD 21 E0 8A ld   iy,$8AE0
61C1: 01 18 00    ld   bc,$0018
61C4: 2E 05       ld   l,$05
61C6: FD BE 14    cp   (iy+$14)
61C9: 28 0C       jr   z,$61D7
61CB: FD 09       add  iy,bc
61CD: 2D          dec  l
61CE: 20 F6       jr   nz,$61C6
61D0: C1          pop  bc
61D1: FD E1       pop  iy
61D3: E1          pop  hl
61D4: C3 80 60    jp   $6080
61D7: FD 7E 0B    ld   a,(iy+$0b)
61DA: A7          and  a
61DB: 20 F3       jr   nz,$61D0
61DD: FD 7E 16    ld   a,(iy+$16)
61E0: C1          pop  bc
61E1: FD E1       pop  iy
61E3: E1          pop  hl
61E4: E6 F0       and  $F0
61E6: CA 80 60    jp   z,$6080
61E9: FE 40       cp   $40
61EB: 28 0F       jr   z,$61FC
61ED: FE 50       cp   $50
61EF: CA 87 62    jp   z,$6287
61F2: FE F0       cp   $F0
61F4: CA 0F 63    jp   z,$630F
61F7: FE D0       cp   $D0
61F9: CA 87 62    jp   z,$6287
61FC: 1E 06       ld   e,$06
61FE: 3A 1F 88    ld   a,($881F)
6201: A7          and  a
6202: 20 02       jr   nz,$6206
6204: 1E FE       ld   e,$FE
6206: DD 7E 00    ld   a,(ix+$00)
6209: 83          add  a,e
620A: 5F          ld   e,a
620B: DD 7E 02    ld   a,(ix+$02)
620E: C6 08       add  a,$08
6210: 57          ld   d,a
6211: FD 7E 00    ld   a,(iy+$00)
6214: 93          sub  e
6215: 30 02       jr   nc,$6219
6217: ED 44       neg
6219: FE 09       cp   $09
621B: D2 F2 60    jp   nc,$60F2
621E: FD 7E 02    ld   a,(iy+$02)
6221: C6 08       add  a,$08
6223: 92          sub  d
6224: 30 02       jr   nc,$6228
6226: ED 44       neg
6228: FE 08       cp   $08
622A: D2 F2 60    jp   nc,$60F2
622D: E5          push hl
622E: DD E1       pop  ix
6230: 11 43 63    ld   de,$6343
6233: CD 1E 38    call $381E
6236: 21 58 63    ld   hl,$6358
6239: 3A 07 89    ld   a,($8907)
623C: E6 07       and  $07
623E: 1F          rra
623F: E7          rst  $20
6240: 6F          ld   l,a
6241: DD 7E 0A    ld   a,(ix+$0a)
6244: 85          add  a,l
6245: DD 77 0A    ld   (ix+$0a),a
6248: FD 21 E0 8A ld   iy,$8AE0
624C: DD 7E 14    ld   a,(ix+$14)
624F: 0E 06       ld   c,$06
6251: 11 18 00    ld   de,$0018
6254: FD BE 14    cp   (iy+$14)
6257: 28 05       jr   z,$625E
6259: FD 19       add  iy,de
625B: 0D          dec  c
625C: 20 F6       jr   nz,$6254
625E: 21 58 63    ld   hl,$6358
6261: 3A 07 89    ld   a,($8907)
6264: E6 07       and  $07
6266: 1F          rra
6267: E7          rst  $20
6268: 6F          ld   l,a
6269: FD 7E 0A    ld   a,(iy+$0a)
626C: 85          add  a,l
626D: FD 77 0A    ld   (iy+$0a),a
6270: FD CB 16 E6 set  4,(iy+$16)
6274: 21 90 8C    ld   hl,$8C90
6277: ED 57       ld   a,i
6279: 28 03       jr   z,$627E
627B: 21 A8 8C    ld   hl,$8CA8
627E: 06 18       ld   b,$18
6280: AF          xor  a
6281: D7          rst  $10
6282: CD F1 0E    call $0EF1
6285: F1          pop  af
6286: C9          ret
6287: 4F          ld   c,a
6288: 1E 06       ld   e,$06
628A: 3A 1F 88    ld   a,($881F)
628D: A7          and  a
628E: 20 02       jr   nz,$6292
6290: 1E FE       ld   e,$FE
6292: DD 7E 00    ld   a,(ix+$00)
6295: 83          add  a,e
6296: 5F          ld   e,a
6297: DD 7E 02    ld   a,(ix+$02)
629A: C6 08       add  a,$08
629C: 57          ld   d,a
629D: FD 7E 00    ld   a,(iy+$00)
62A0: 93          sub  e
62A1: 30 02       jr   nc,$62A5
62A3: ED 44       neg
62A5: FE 06       cp   $06
62A7: D2 F2 60    jp   nc,$60F2
62AA: FD 7E 02    ld   a,(iy+$02)
62AD: C6 08       add  a,$08
62AF: 92          sub  d
62B0: 30 02       jr   nc,$62B4
62B2: ED 44       neg
62B4: FE 07       cp   $07
62B6: D2 F2 60    jp   nc,$60F2
62B9: 79          ld   a,c
62BA: FE 50       cp   $50
62BC: CA D9 60    jp   z,$60D9
62BF: E5          push hl
62C0: DD E1       pop  ix
62C2: 11 49 63    ld   de,$6349
62C5: CD 1E 38    call $381E
62C8: 21 60 63    ld   hl,$6360
62CB: 3A 07 89    ld   a,($8907)
62CE: E6 07       and  $07
62D0: 1F          rra
62D1: E7          rst  $20
62D2: 6F          ld   l,a
62D3: DD 7E 0A    ld   a,(ix+$0a)
62D6: 85          add  a,l
62D7: DD 77 0A    ld   (ix+$0a),a
62DA: FD 21 E0 8A ld   iy,$8AE0
62DE: DD 7E 14    ld   a,(ix+$14)
62E1: 0E 06       ld   c,$06
62E3: 11 18 00    ld   de,$0018
62E6: FD BE 14    cp   (iy+$14)
62E9: 28 05       jr   z,$62F0
62EB: FD 19       add  iy,de
62ED: 0D          dec  c
62EE: 20 F6       jr   nz,$62E6
62F0: 21 60 63    ld   hl,$6360
62F3: 3A 07 89    ld   a,($8907)
62F6: E6 07       and  $07
62F8: 1F          rra
62F9: E7          rst  $20
62FA: 6F          ld   l,a
62FB: FD 7E 0A    ld   a,(iy+$0a)
62FE: 85          add  a,l
62FF: FD 77 0A    ld   (iy+$0a),a
6302: FD CB 16 EE set  5,(iy+$16)
6306: 11 4F 63    ld   de,$634F
6309: CD 75 5C    call $5C75
630C: C3 74 62    jp   $6274
630F: 1E 06       ld   e,$06
6311: 3A 1F 88    ld   a,($881F)
6314: A7          and  a
6315: 20 02       jr   nz,$6319
6317: 1E FE       ld   e,$FE
6319: DD 7E 00    ld   a,(ix+$00)
631C: 83          add  a,e
631D: 5F          ld   e,a
631E: DD 7E 02    ld   a,(ix+$02)
6321: C6 08       add  a,$08
6323: 57          ld   d,a
6324: FD 7E 00    ld   a,(iy+$00)
6327: 93          sub  e
6328: 30 02       jr   nc,$632C
632A: ED 44       neg
632C: FE 05       cp   $05
632E: D2 F2 60    jp   nc,$60F2
6331: FD 7E 02    ld   a,(iy+$02)
6334: C6 08       add  a,$08
6336: 92          sub  d
6337: 30 02       jr   nc,$633B
6339: ED 44       neg
633B: FE 05       cp   $05
633D: D2 F2 60    jp   nc,$60F2
6340: C3 D9 60    jp   $60D9

6368: FD 21 48 88 ld   iy,$8848
636C: 06 02       ld   b,$02
636E: 11 04 00    ld   de,$0004
6371: AF          xor  a
6372: ED 47       ld   i,a
6374: D9          exx
6375: CD 81 63    call $6381
6378: D9          exx
6379: FD 19       add  iy,de
637B: 7B          ld   a,e
637C: ED 47       ld   i,a
637E: 10 F4       djnz $6374
6380: C9          ret
6381: DD 21 7C 88 ld   ix,sprite_shadow_ram_8840+$3C
6385: 06 03       ld   b,$03
6387: 21 E8 8B    ld   hl,$8BE8
638A: 7E          ld   a,(hl)
638B: A7          and  a
638C: 28 61       jr   z,$63EF
638E: 1E 05       ld   e,$05
6390: 3A 1F 88    ld   a,($881F)
6393: A7          and  a
6394: 20 02       jr   nz,$6398
6396: 1E FE       ld   e,$FE
6398: DD 7E 00    ld   a,(ix+$00)
639B: 83          add  a,e
639C: 5F          ld   e,a
639D: DD 7E 02    ld   a,(ix+$02)
63A0: C6 08       add  a,$08
63A2: 57          ld   d,a
63A3: FD 7E 00    ld   a,(iy+$00)
63A6: 93          sub  e
63A7: 30 02       jr   nc,$63AB
63A9: ED 44       neg
63AB: FE 06       cp   $06
63AD: 30 40       jr   nc,$63EF
63AF: FD 7E 02    ld   a,(iy+$02)
63B2: C6 08       add  a,$08
63B4: 92          sub  d
63B5: 30 02       jr   nc,$63B9
63B7: ED 44       neg
63B9: FE 06       cp   $06
63BB: 30 32       jr   nc,$63EF
63BD: E5          push hl
63BE: DD E1       pop  ix
63C0: DD 36 00 00 ld   (ix+$00),$00
63C4: DD 36 01 01 ld   (ix+$01),$01
63C8: DD 36 02 02 ld   (ix+$02),$02
63CC: DD 36 11 28 ld   (ix+$11),$28
63D0: 11 0F 00    ld   de,$000F
63D3: 21 1B 8D    ld   hl,$8D1B
63D6: ED 57       ld   a,i
63D8: A7          and  a
63D9: 28 03       jr   z,$63DE
63DB: 21 1C 8D    ld   hl,$8D1C
63DE: 36 01       ld   (hl),$01
63E0: 11 FB 63    ld   de,$63FB
63E3: CD 1E 38    call $381E
63E6: CD F9 0E    call $0EF9
63E9: 11 15 03    ld   de,$0315
63EC: FF          rst  $38
63ED: F1          pop  af
63EE: C9          ret
63EF: 11 04 00    ld   de,$0004
63F2: DD 19       add  ix,de
63F4: 11 18 00    ld   de,$0018
63F7: 19          add  hl,de
63F8: 10 90       djnz $638A
63FA: C9          ret
63FB: 4F          ld   c,a
63FC: 34          inc  (hl)
63FD: 06 4F       ld   b,$4F
63FF: 33          inc  sp
6400: 06 42       ld   b,$42
6402: 37          scf
6403: 28 3A       jr   z,$643F
6405: 50          ld   d,b
6406: 8F          adc  a,a
6407: A7          and  a
6408: 20 06       jr   nz,$6410
640A: 3A 07 89    ld   a,($8907)
640D: E6 01       and  $01
640F: C0          ret  nz
6410: FD 21 48 88 ld   iy,$8848
6414: 06 02       ld   b,$02
6416: 11 04 00    ld   de,$0004
6419: AF          xor  a
641A: ED 47       ld   i,a
641C: D9          exx
641D: CD 35 64    call $6435
6420: D9          exx
6421: FD 19       add  iy,de
6423: 7B          ld   a,e
6424: ED 47       ld   i,a
6426: 10 F4       djnz $641C
6428: C9          ret
6429: 11 04 00    ld   de,$0004
642C: DD 19       add  ix,de
642E: 11 18 00    ld   de,$0018
6431: 19          add  hl,de
6432: 10 17       djnz $644B
6434: C9          ret
6435: DD 21 8C 88 ld   ix,$888C
6439: 21 48 8C    ld   hl,$8C48
643C: 3A 50 8F    ld   a,($8F50)
643F: A7          and  a
6440: 28 07       jr   z,$6449
6442: DD 21 7C 88 ld   ix,sprite_shadow_ram_8840+$3C
6446: 21 E8 8B    ld   hl,$8BE8
6449: 06 03       ld   b,$03
644B: 7E          ld   a,(hl)
644C: A7          and  a
644D: 28 DA       jr   z,$6429
644F: 1E 05       ld   e,$05
6451: 3A 1F 88    ld   a,($881F)
6454: A7          and  a
6455: 20 02       jr   nz,$6459
6457: 1E FE       ld   e,$FE
6459: DD 7E 00    ld   a,(ix+$00)
645C: 83          add  a,e
645D: 5F          ld   e,a
645E: DD 7E 02    ld   a,(ix+$02)
6461: C6 08       add  a,$08
6463: 57          ld   d,a
6464: FD 7E 00    ld   a,(iy+$00)
6467: 93          sub  e
6468: 30 02       jr   nc,$646C
646A: ED 44       neg
646C: FE 07       cp   $07
646E: 30 B9       jr   nc,$6429
6470: FD 7E 02    ld   a,(iy+$02)
6473: C6 08       add  a,$08
6475: 92          sub  d
6476: 30 02       jr   nc,$647A
6478: ED 44       neg
647A: FE 07       cp   $07
647C: 30 AB       jr   nc,$6429
647E: E5          push hl
647F: DD E1       pop  ix
6481: DD 36 00 00 ld   (ix+$00),$00
6485: DD 36 01 01 ld   (ix+$01),$01
6489: DD 36 02 02 ld   (ix+$02),$02
648D: DD 36 11 20 ld   (ix+$11),$20
6491: 11 0F 00    ld   de,$000F
6494: 21 1B 8D    ld   hl,$8D1B
6497: ED 57       ld   a,i
6499: A7          and  a
649A: 28 03       jr   z,$649F
649C: 21 1C 8D    ld   hl,$8D1C
649F: 36 01       ld   (hl),$01
64A1: 11 DF 64    ld   de,$64DF
64A4: CD 1E 38    call $381E
64A7: CD F5 0E    call $0EF5
64AA: 3A 50 8F    ld   a,($8F50)
64AD: A7          and  a
64AE: 20 04       jr   nz,$64B4
64B0: 11 15 03    ld   de,$0315
64B3: FF          rst  $38
64B4: 21 52 8F    ld   hl,$8F52
64B7: 34          inc  (hl)
64B8: 11 C2 0B    ld   de,$0BC2
64BB: 21 D0 64    ld   hl,$64D0
64BE: 1A          ld   a,(de)
64BF: 96          sub  (hl)
64C0: 20 08       jr   nz,$64CA
64C2: 1B          dec  de
64C3: 23          inc  hl
64C4: 7E          ld   a,(hl)
64C5: 3D          dec  a
64C6: 28 06       jr   z,$64CE
64C8: 18 F4       jr   $64BE
64CA: 21 F9 8D    ld   hl,$8DF9
64CD: 34          inc  (hl)
64CE: F1          pop  af
64CF: C9          ret
64D0: 51          ld   d,c
64D1: 3A 3B 20    ld   a,($203B)
64D4: 3D          dec  a
64D5: 88          adc  a,b
64D6: 05          dec  b
64D7: 3A 41 20    ld   a,($2041)
64DA: A7          and  a
64DB: 88          adc  a,b
64DC: 06 3A       ld   b,$3A
64DE: 01 42 37    ld   bc,$3742
64E1: 28 CD       jr   z,$64B0
64E3: 13          inc  de
64E4: 6B          ld   l,e
64E5: DD 21 78 8C ld   ix,$8C78
64E9: CD FB 64    call $64FB
64EC: DD 21 E0 8A ld   ix,$8AE0
64F0: FD 21 78 8C ld   iy,$8C78
64F4: CD C5 66    call $66C5
64F7: CD 22 68    call $6822
64FA: C9          ret
64FB: DD 7E 02    ld   a,(ix+$02)
64FE: EF          rst  $28
jump_table_64FF:
	.word	$6505
	.word	$6566
	.word	$6666


6505: 21 29 89    ld   hl,$8929
6508: 36 1C       ld   (hl),$1C
650A: 11 E8 FF    ld   de,$FFE8
650D: 06 03       ld   b,$03
650F: 2E 2B       ld   l,$2B
6511: 36 08       ld   (hl),$08
6513: D9          exx
6514: CD 23 65    call $6523
6517: D9          exx
6518: DD 34 02    inc  (ix+$02)
651B: DD 19       add  ix,de
651D: 10 F4       djnz $6513
651F: CD 88 0F    call $0F88
6522: C9          ret
6523: DD 7E 00    ld   a,(ix+$00)
6526: DD B6 01    or   (ix+$01)
6529: 0F          rrca
652A: D8          ret  c
; checks protection/checksum failed
652B: 3A F0 8E    ld   a,(checksum_failed_8EF0)
652E: A7          and  a
652F: C0          ret  nz   ; failed: returns
6530: DD 36 00 01 ld   (ix+$00),$01
6534: DD 77 03    ld   (ix+$03),a
6537: DD 77 05    ld   (ix+$05),a
653A: DD 36 04 15 ld   (ix+$04),$15
653E: 3A 29 89    ld   a,($8929)
6541: DD 77 06    ld   (ix+$06),a
6544: D6 02       sub  $02
6546: 32 29 89    ld   ($8929),a
6549: DD 36 0F 03 ld   (ix+$0f),$03
654D: DD 36 10 C0 ld   (ix+$10),$C0
6551: DD 36 08 30 ld   (ix+$08),$30
6555: DD 36 09 F0 ld   (ix+$09),$F0
6559: 11 11 06    ld   de,$0611
655C: FF          rst  $38
655D: 3A 07 89    ld   a,($8907)
6560: A7          and  a
6561: C0          ret  nz
6562: 1E 07       ld   e,$07
6564: FF          rst  $38
6565: C9          ret

6566: 21 2F 89    ld   hl,$892F
6569: 7E          ld   a,(hl)
656A: A7          and  a
656B: 28 02       jr   z,$656F
656D: 35          dec  (hl)
656E: C9          ret
656F: 2E 2C       ld   l,$2C
6571: 34          inc  (hl)
6572: CB 46       bit  0,(hl)
6574: 2E 2F       ld   l,$2F
6576: 20 1E       jr   nz,$6596
6578: 36 06       ld   (hl),$06
657A: DD 7E 03    ld   a,(ix+$03)
657D: DD 86 08    add  a,(ix+$08)
6580: 30 09       jr   nc,$658B
6582: DD 34 04    inc  (ix+$04)
6585: DD 34 EC    inc  (ix-$14)
6588: DD 34 D4    inc  (ix-$2c)
658B: DD 77 03    ld   (ix+$03),a
658E: DD 77 EB    ld   (ix-$15),a
6591: DD 77 D3    ld   (ix-$2d),a
6594: 18 54       jr   $65EA
6596: 36 0C       ld   (hl),$0C
6598: DD 7E 03    ld   a,(ix+$03)
659B: DD 96 08    sub  (ix+$08)
659E: 30 09       jr   nc,$65A9
65A0: DD 35 04    dec  (ix+$04)
65A3: DD 35 EC    dec  (ix-$14)
65A6: DD 35 D4    dec  (ix-$2c)
65A9: DD 77 03    ld   (ix+$03),a
65AC: DD 77 EB    ld   (ix-$15),a
65AF: DD 77 D3    ld   (ix-$2d),a
65B2: DD 7E 05    ld   a,(ix+$05)
65B5: DD 96 09    sub  (ix+$09)
65B8: DD 77 05    ld   (ix+$05),a
65BB: DD 77 ED    ld   (ix-$13),a
65BE: DD 77 D5    ld   (ix-$2b),a
65C1: 30 12       jr   nc,$65D5
65C3: DD 7E 06    ld   a,(ix+$06)
65C6: D6 01       sub  $01
65C8: DD 77 06    ld   (ix+$06),a
65CB: D6 02       sub  $02
65CD: DD 77 EE    ld   (ix-$12),a
65D0: D6 02       sub  $02
65D2: DD 77 D6    ld   (ix-$2a),a
65D5: 2E 2C       ld   l,$2C
65D7: CB 46       bit  0,(hl)
65D9: 21 BF 66    ld   hl,$66BF
65DC: 28 03       jr   z,$65E1
65DE: 21 C2 66    ld   hl,$66C2
65E1: 11 E8 FF    ld   de,$FFE8
65E4: 06 03       ld   b,$03
65E6: CD 14 25    call $2514
65E9: C9          ret
65EA: DD 21 78 8C ld   ix,$8C78
65EE: DD 7E 06    ld   a,(ix+$06)
65F1: FE 0C       cp   $0C
65F3: D0          ret  nc
65F4: 3E 40       ld   a,$40
65F6: DD 77 10    ld   (ix+$10),a
65F9: DD 77 F8    ld   (ix-$08),a
65FC: DD 77 E0    ld   (ix-$20),a
65FF: 3E 18       ld   a,$18
6601: DD 77 09    ld   (ix+$09),a
6604: DD 77 F1    ld   (ix-$0f),a
6607: DD 77 D9    ld   (ix-$27),a
660A: 3E 02       ld   a,$02
660C: DD 77 02    ld   (ix+$02),a
660F: DD 77 EA    ld   (ix-$16),a
6612: DD 77 D2    ld   (ix-$2e),a
6615: 32 30 89    ld   ($8930),a
6618: 32 2E 89    ld   ($892E),a
661B: FD 21 BC 82 ld   iy,$82BC
661F: 11 00 00    ld   de,$0000
6622: 06 0A       ld   b,$0A
6624: FD 7E 00    ld   a,(iy+$00)
6627: FD BE E0    cp   (iy-$20)
662A: C2 84 52    jp   nz,$5284
662D: 83          add  a,e
662E: 5F          ld   e,a
662F: 30 01       jr   nc,$6632
6631: 14          inc  d
6632: FD 7D       ld   a,iyl
6634: D6 20       sub  $20
6636: FD 6F       ld   iyl,a
6638: 30 02       jr   nc,$663C
663A: FD 25       dec  iyh
663C: 10 E6       djnz $6624
663E: 06 0A       ld   b,$0A
6640: 3E 04       ld   a,$04
6642: FD 84       add  a,iyh
6644: FD 67       ld   iyh,a
6646: EB          ex   de,hl
6647: FD 5D       ld   e,iyl
6649: FD 54       ld   d,iyh
664B: EB          ex   de,hl
664C: 7E          ld   a,(hl)
664D: 83          add  a,e
664E: 30 01       jr   nc,$6651
6650: 14          inc  d
6651: 5F          ld   e,a
6652: 7D          ld   a,l
6653: C6 20       add  a,$20
6655: 30 01       jr   nc,$6658
6657: 24          inc  h
6658: 6F          ld   l,a
6659: 10 F1       djnz $664C
665B: 7B          ld   a,e
665C: FE 2A       cp   $2A
665E: C2 14 60    jp   nz,$6014
6661: 15          dec  d
6662: C2 05 20    jp   nz,$2005
6665: C9          ret

6666: 11 E8 FF    ld   de,$FFE8
6669: 06 03       ld   b,$03
666B: D9          exx
666C: CD 7C 66    call $667C
666F: D9          exx
6670: DD 19       add  ix,de
6672: 10 F7       djnz $666B
6674: DD 21 78 8C ld   ix,$8C78
6678: CD A1 66    call $66A1
667B: C9          ret
667C: DD 7E 01    ld   a,(ix+$01)
667F: A7          and  a
6680: C0          ret  nz
6681: DD 7E 05    ld   a,(ix+$05)
6684: DD 86 09    add  a,(ix+$09)
6687: 30 03       jr   nc,$668C
6689: DD 34 06    inc  (ix+$06)
668C: DD 77 05    ld   (ix+$05),a
668F: DD 7E 06    ld   a,(ix+$06)
6692: FE 1D       cp   $1D
6694: D8          ret  c
6695: DD 36 01 02 ld   (ix+$01),$02
6699: AF          xor  a
669A: DD 77 04    ld   (ix+$04),a
669D: DD 77 06    ld   (ix+$06),a
66A0: C9          ret
66A1: 21 2B 89    ld   hl,$892B
66A4: 35          dec  (hl)
66A5: 7E          ld   a,(hl)
66A6: A7          and  a
66A7: C0          ret  nz
66A8: 36 08       ld   (hl),$08
66AA: 23          inc  hl
66AB: 34          inc  (hl)
66AC: CB 46       bit  0,(hl)
66AE: 21 BF 66    ld   hl,$66BF
66B1: 28 03       jr   z,$66B6
66B3: 21 C2 66    ld   hl,$66C2
66B6: 11 E8 FF    ld   de,$FFE8
66B9: 06 03       ld   b,$03
66BB: CD 14 25    call $2514
66BE: C9          ret
66BF: 03          inc  bc
66C0: 03          inc  bc
66C1: 03          inc  bc
66C2: 09          add  hl,bc
66C3: 09          add  hl,bc
66C4: 09          add  hl,bc
66C5: 11 18 00    ld   de,$0018
66C8: 06 03       ld   b,$03
66CA: D9          exx
66CB: CD F1 66    call $66F1
66CE: D9          exx
66CF: DD 19       add  ix,de
66D1: 10 F7       djnz $66CA
66D3: 3A E2 8A    ld   a,($8AE2)
66D6: A7          and  a
66D7: C8          ret  z
66D8: 21 2D 89    ld   hl,$892D
66DB: 7E          ld   a,(hl)
66DC: A7          and  a
66DD: 28 02       jr   z,$66E1
66DF: 35          dec  (hl)
66E0: C9          ret
66E1: 36 10       ld   (hl),$10
66E3: 23          inc  hl
66E4: 23          inc  hl
66E5: 34          inc  (hl)
66E6: CB 46       bit  0,(hl)
66E8: 11 12 06    ld   de,$0612
66EB: 20 02       jr   nz,$66EF
66ED: 1E 92       ld   e,$92
66EF: FF          rst  $38
66F0: C9          ret
66F1: DD 7E 02    ld   a,(ix+$02)
66F4: EF          rst  $28
jump_table_66F5:
	.word	$66FD
	.word	$672A
	.word	$67A0
	.word	$67DF

66FD: 3A 30 89    ld   a,($8930)
6700: A7          and  a
6701: C8          ret  z
6702: 21 2E 89    ld   hl,$892E
6705: 7E          ld   a,(hl)
6706: A7          and  a
6707: 28 02       jr   z,$670B
6709: 35          dec  (hl)
670A: C9          ret
670B: 36 12       ld   (hl),$12
670D: DD 34 02    inc  (ix+$02)
6710: AF          xor  a
6711: DD 77 03    ld   (ix+$03),a
6714: DD 77 05    ld   (ix+$05),a
6717: DD 36 04 15 ld   (ix+$04),$15
671B: DD 36 06 02 ld   (ix+$06),$02
671F: 11 29 38    ld   de,$3829
6722: CD 1E 38    call $381E
6725: DD 36 09 2C ld   (ix+$09),$2C
6729: C9          ret
672A: CD 06 40    call $4006
672D: DD 7E 05    ld   a,(ix+$05)
6730: DD 86 09    add  a,(ix+$09)
6733: 30 03       jr   nc,$6738
6735: DD 34 06    inc  (ix+$06)
6738: DD 77 05    ld   (ix+$05),a
673B: DD 7E 06    ld   a,(ix+$06)
673E: FE 18       cp   $18
6740: 30 50       jr   nc,$6792
6742: FD 21 48 8C ld   iy,$8C48
6746: 11 18 00    ld   de,$0018
6749: 06 03       ld   b,$03
674B: FD 7E 01    ld   a,(iy+$01)
674E: A7          and  a
674F: 20 08       jr   nz,$6759
6751: DD 7E 06    ld   a,(ix+$06)
6754: FD BE 06    cp   (iy+$06)
6757: 28 05       jr   z,$675E
6759: FD 19       add  iy,de
675B: 10 EE       djnz $674B
675D: C9          ret
675E: 21 03 89    ld   hl,$8903
6761: 34          inc  (hl)
6762: FD 36 01 02 ld   (iy+$01),$02
6766: DD 7E 03    ld   a,(ix+$03)
6769: D6 80       sub  $80
676B: 30 03       jr   nc,$6770
676D: FD 35 04    dec  (iy+$04)
6770: FD 77 03    ld   (iy+$03),a
6773: DD 7E 05    ld   a,(ix+$05)
6776: C6 40       add  a,$40
6778: 30 03       jr   nc,$677D
677A: FD 35 06    dec  (iy+$06)
677D: FD 77 05    ld   (iy+$05),a
6780: FD 36 0F C0 ld   (iy+$0f),$C0
6784: FD E5       push iy
6786: E1          pop  hl
6787: DD 75 07    ld   (ix+$07),l
678A: DD 74 08    ld   (ix+$08),h
678D: 3E 20       ld   a,$20
678F: 32 29 89    ld   ($8929),a
6792: DD 34 02    inc  (ix+$02)
6795: DD 36 09 18 ld   (ix+$09),$18
6799: 11 38 38    ld   de,$3838
679C: CD 1E 38    call $381E
679F: C9          ret
67A0: 21 29 89    ld   hl,$8929
67A3: 7E          ld   a,(hl)
67A4: A7          and  a
67A5: 28 02       jr   z,$67A9
67A7: 35          dec  (hl)
67A8: C9          ret
67A9: CD 06 40    call $4006
67AC: DD 6E 07    ld   l,(ix+$07)
67AF: DD 66 08    ld   h,(ix+$08)
67B2: 7C          ld   a,h
67B3: A7          and  a
67B4: 28 11       jr   z,$67C7
67B6: E5          push hl
67B7: FD E1       pop  iy
67B9: FD 7E 05    ld   a,(iy+$05)
67BC: DD 96 09    sub  (ix+$09)
67BF: 30 03       jr   nc,$67C4
67C1: FD 35 06    dec  (iy+$06)
67C4: FD 77 05    ld   (iy+$05),a
67C7: DD 7E 05    ld   a,(ix+$05)
67CA: DD 96 09    sub  (ix+$09)
67CD: 30 03       jr   nc,$67D2
67CF: DD 35 06    dec  (ix+$06)
67D2: DD 77 05    ld   (ix+$05),a
67D5: DD 7E 06    ld   a,(ix+$06)
67D8: FE 00       cp   $00
67DA: C0          ret  nz
67DB: DD 34 02    inc  (ix+$02)
67DE: C9          ret
67DF: 21 BC 82    ld   hl,$82BC
67E2: 11 E0 FF    ld   de,$FFE0
67E5: 01 00 0A    ld   bc,$0A00
67E8: 7E          ld   a,(hl)
67E9: 81          add  a,c
67EA: 4F          ld   c,a
67EB: 19          add  hl,de
67EC: 10 FA       djnz $67E8
67EE: 3E 5A       ld   a,$5A
67F0: B9          cp   c
67F1: 20 AD       jr   nz,$67A0
67F3: 3E 01       ld   a,$01
67F5: 32 04 89    ld   ($8904),a
67F8: 32 08 88    ld   ($8808),a
67FB: 32 0A 88    ld   (in_game_sub_state_880A),a
67FE: AF          xor  a
67FF: 21 28 89    ld   hl,$8928
6802: 06 09       ld   b,$09
6804: D7          rst  $10
6805: 21 80 8A    ld   hl,top_basket_object_8A80
6808: 77          ld   (hl),a
6809: 11 81 8A    ld   de,$8A81
680C: 01 40 02    ld   bc,$0240
680F: ED B0       ldir
6811: 3E 10       ld   a,$10
6813: 21 42 84    ld   hl,$8442
6816: 0E 1D       ld   c,$1D
6818: 06 1D       ld   b,$1D
681A: D7          rst  $10
681B: 23          inc  hl
681C: 23          inc  hl
681D: 23          inc  hl
681E: 0D          dec  c
681F: 20 F7       jr   nz,$6818
6821: C9          ret
6822: 3A FA 8A    ld   a,($8AFA)
6825: A7          and  a
6826: C8          ret  z
6827: DD 21 E0 8A ld   ix,$8AE0
682B: 11 48 00    ld   de,$0048
682E: DD 19       add  ix,de
6830: DD 7E 02    ld   a,(ix+$02)
6833: EF          rst  $28
jump_table_6834:
	.word	$683A
	.word	$6857
	.word	$68AC

683A: DD 34 02    inc  (ix+$02)
683D: AF          xor  a
683E: DD 77 03    ld   (ix+$03),a
6841: DD 77 05    ld   (ix+$05),a
6844: DD 36 04 08 ld   (ix+$04),$08
6848: DD 36 06 1E ld   (ix+$06),$1E
684C: 11 EF 68    ld   de,$68EF
684F: CD 1E 38    call $381E
6852: DD 36 09 18 ld   (ix+$09),$18
6856: C9          ret
6857: CD 06 40    call $4006
685A: DD 7E 05    ld   a,(ix+$05)
685D: DD 96 09    sub  (ix+$09)
6860: 30 03       jr   nc,$6865
6862: DD 35 06    dec  (ix+$06)
6865: DD 77 05    ld   (ix+$05),a
6868: DD 7E 06    ld   a,(ix+$06)
686B: FE 1B       cp   $1B
686D: D0          ret  nc
686E: DD 34 02    inc  (ix+$02)
6871: 21 BC 86    ld   hl,$86BC
6874: 11 A3 68    ld   de,$68A3
6877: 01 00 08    ld   bc,$0800
687A: 1A          ld   a,(de)
687B: 86          add  a,(hl)
687C: 81          add  a,c
687D: 4F          ld   c,a
687E: 13          inc  de
687F: 7D          ld   a,l
6880: D6 20       sub  $20
6882: 30 01       jr   nc,$6885
6884: 25          dec  h
6885: 6F          ld   l,a
6886: 10 F2       djnz $687A
6888: 06 08       ld   b,$08
688A: 7C          ld   a,h
688B: D6 04       sub  $04
688D: 67          ld   h,a
688E: 7E          ld   a,(hl)
688F: 81          add  a,c
6890: 4F          ld   c,a
6891: 7D          ld   a,l
6892: C6 20       add  a,$20
6894: 30 01       jr   nc,$6897
6896: 24          inc  h
6897: 10 F5       djnz $688E
6899: 1A          ld   a,(de)
689A: 81          add  a,c
689B: C2 B3 08    jp   nz,$08B3
689E: 11 13 06    ld   de,$0613
68A1: FF          rst  $38
68A2: C9          ret

68AC: 21 55 8F    ld   hl,$8F55
68AF: 7E          ld   a,(hl)
68B0: A7          and  a
68B1: C0          ret  nz
68B2: 34          inc  (hl)
68B3: 21 02 84    ld   hl,$8402
68B6: 11 00 00    ld   de,$0000
68B9: 7E          ld   a,(hl)
68BA: 83          add  a,e
68BB: 5F          ld   e,a
68BC: 30 01       jr   nc,$68BF
68BE: 14          inc  d
68BF: 2C          inc  l
68C0: 7D          ld   a,l
68C1: E6 1F       and  $1F
68C3: FE 1F       cp   $1F
68C5: 20 F2       jr   nz,$68B9
68C7: 7D          ld   a,l
68C8: C6 03       add  a,$03
68CA: 6F          ld   l,a
68CB: 30 EC       jr   nc,$68B9
68CD: 24          inc  h
68CE: 7C          ld   a,h
68CF: FE 88       cp   $88
68D1: 38 E6       jr   c,$68B9
68D3: 21 EB 68    ld   hl,$68EB
68D6: 06 04       ld   b,$04
68D8: 7B          ld   a,e
68D9: BE          cp   (hl)
68DA: 28 06       jr   z,$68E2
68DC: 23          inc  hl
68DD: 10 FA       djnz $68D9
68DF: C3 D4 76    jp   $76D4
68E2: 7A          ld   a,d
68E3: 23          inc  hl
68E4: BE          cp   (hl)
68E5: C8          ret  z
68E6: 10 FA       djnz $68E2
68E8: C3 29 38    jp   $3829

68F8: CD 05 69    call $6905
68FB: CD AD 69    call $69AD
68FE: CD 0F 6A    call $6A0F
6901: CD 7F 6A    call $6A7F
6904: C9          ret
6905: 21 29 89    ld   hl,$8929
6908: 7E          ld   a,(hl)
6909: A7          and  a
690A: 28 02       jr   z,$690E
690C: 35          dec  (hl)
690D: C9          ret
690E: 2E 2D       ld   l,$2D
6910: 7E          ld   a,(hl)
6911: 2E 03       ld   l,$03
6913: BE          cp   (hl)
6914: C8          ret  z
6915: FE 08       cp   $08
6917: D0          ret  nc
6918: DD 21 E0 8A ld   ix,$8AE0
691C: FD 21 A0 8B ld   iy,$8BA0
6920: 11 18 00    ld   de,$0018
6923: 06 08       ld   b,$08
6925: D9          exx
6926: CD 31 69    call $6931
6929: D9          exx
692A: DD 19       add  ix,de
692C: FD 19       add  iy,de
692E: 10 F5       djnz $6925
6930: C9          ret
6931: DD 7E 00    ld   a,(ix+$00)
6934: DD B6 01    or   (ix+$01)
6937: 0F          rrca
6938: D8          ret  c
6939: AF          xor  a
693A: DD 77 03    ld   (ix+$03),a
693D: DD 77 05    ld   (ix+$05),a
6940: 3C          inc  a
6941: DD 77 00    ld   (ix+$00),a
6944: FD 77 00    ld   (iy+$00),a
6947: DD 36 04 15 ld   (ix+$04),$15
694B: DD 36 06 1E ld   (ix+$06),$1E
694F: FD 36 03 80 ld   (iy+$03),$80
6953: FD 36 05 A0 ld   (iy+$05),$A0
6957: FD 36 04 14 ld   (iy+$04),$14
695B: FD 36 06 1E ld   (iy+$06),$1E
695F: FD 36 0F 03 ld   (iy+$0f),$03
6963: FD 36 10 40 ld   (iy+$10),$40
6967: DD 36 09 24 ld   (ix+$09),$24
696B: FD 36 09 24 ld   (iy+$09),$24
696F: 11 38 38    ld   de,$3838
6972: CD 1E 38    call $381E
6975: 3E 10       ld   a,$10
6977: 32 29 89    ld   ($8929),a
697A: 3A 2D 89    ld   a,($892D)
697D: A7          and  a
697E: 20 27       jr   nz,$69A7
6980: 11 25 06    ld   de,$0625
6983: FF          rst  $38
6984: 1E 0A       ld   e,$0A
6986: FF          rst  $38
6987: 21 3B 86    ld   hl,$863B
698A: 3A 03 89    ld   a,($8903)
698D: 47          ld   b,a
698E: AF          xor  a
698F: C6 01       add  a,$01
6991: 27          daa
6992: 10 FB       djnz $698F
6994: 5F          ld   e,a
6995: E6 F0       and  $F0
6997: 0F          rrca
6998: 0F          rrca
6999: 0F          rrca
699A: 0F          rrca
699B: 77          ld   (hl),a
699C: 01 E0 FF    ld   bc,$FFE0
699F: 09          add  hl,bc
69A0: 7B          ld   a,e
69A1: E6 0F       and  $0F
69A3: 77          ld   (hl),a
69A4: CD 97 0F    call $0F97
69A7: 21 2D 89    ld   hl,$892D
69AA: 34          inc  (hl)
69AB: F1          pop  af
69AC: C9          ret
69AD: DD 21 E0 8A ld   ix,$8AE0
69B1: FD 21 A0 8B ld   iy,$8BA0
69B5: 11 18 00    ld   de,$0018
69B8: 06 08       ld   b,$08
69BA: D9          exx
69BB: CD C6 69    call $69C6
69BE: D9          exx
69BF: DD 19       add  ix,de
69C1: FD 19       add  iy,de
69C3: 10 F5       djnz $69BA
69C5: C9          ret
69C6: DD 7E 00    ld   a,(ix+$00)
69C9: A7          and  a
69CA: C8          ret  z
69CB: DD 7E 02    ld   a,(ix+$02)
69CE: A7          and  a
69CF: C0          ret  nz
69D0: CD 06 40    call $4006
69D3: FD 7E 05    ld   a,(iy+$05)
69D6: FD 96 09    sub  (iy+$09)
69D9: 30 03       jr   nc,$69DE
69DB: FD 35 06    dec  (iy+$06)
69DE: FD 77 05    ld   (iy+$05),a
69E1: DD 7E 05    ld   a,(ix+$05)
69E4: DD 96 09    sub  (ix+$09)
69E7: 30 03       jr   nc,$69EC
69E9: DD 35 06    dec  (ix+$06)
69EC: DD 77 05    ld   (ix+$05),a
69EF: DD 7E 06    ld   a,(ix+$06)
69F2: FE 06       cp   $06
69F4: 20 08       jr   nz,$69FE
69F6: 21 2B 89    ld   hl,$892B
69F9: 7E          ld   a,(hl)
69FA: A7          and  a
69FB: C0          ret  nz
69FC: 34          inc  (hl)
69FD: C9          ret
69FE: FE 01       cp   $01
6A00: D0          ret  nc
6A01: AF          xor  a
6A02: DD E5       push ix
6A04: E1          pop  hl
6A05: 06 18       ld   b,$18
6A07: D7          rst  $10
6A08: FD E5       push iy
6A0A: E1          pop  hl
6A0B: 06 18       ld   b,$18
6A0D: D7          rst  $10
6A0E: C9          ret
6A0F: 21 2B 89    ld   hl,$892B
6A12: 7E          ld   a,(hl)
6A13: A7          and  a
6A14: C8          ret  z
6A15: 23          inc  hl
6A16: 7E          ld   a,(hl)
6A17: FE 06       cp   $06
6A19: C8          ret  z
6A1A: 2E 2A       ld   l,$2A
6A1C: 7E          ld   a,(hl)
6A1D: A7          and  a
6A1E: 28 02       jr   z,$6A22
6A20: 35          dec  (hl)
6A21: C9          ret
6A22: DD 21 E0 8A ld   ix,$8AE0
6A26: 11 18 00    ld   de,$0018
6A29: 06 12       ld   b,$12
6A2B: D9          exx
6A2C: CD 35 6A    call $6A35
6A2F: D9          exx
6A30: DD 19       add  ix,de
6A32: 10 F7       djnz $6A2B
6A34: C9          ret
6A35: DD 7E 00    ld   a,(ix+$00)
6A38: DD B6 01    or   (ix+$01)
6A3B: 0F          rrca
6A3C: D8          ret  c
6A3D: AF          xor  a
6A3E: DD 77 03    ld   (ix+$03),a
6A41: DD 77 05    ld   (ix+$05),a
6A44: 3C          inc  a
6A45: DD 77 01    ld   (ix+$01),a
6A48: DD 77 02    ld   (ix+$02),a
6A4B: DD 36 04 15 ld   (ix+$04),$15
6A4F: DD 36 06 1E ld   (ix+$06),$1E
6A53: DD 36 09 28 ld   (ix+$09),$28
6A57: 21 2A 89    ld   hl,$892A
6A5A: 36 10       ld   (hl),$10
6A5C: 2E 2C       ld   l,$2C
6A5E: 7E          ld   a,(hl)
6A5F: 34          inc  (hl)
6A60: FE 02       cp   $02
6A62: 28 0E       jr   z,$6A72
6A64: 30 11       jr   nc,$6A77
6A66: A7          and  a
6A67: 28 04       jr   z,$6A6D
6A69: 2E 2A       ld   l,$2A
6A6B: 36 1C       ld   (hl),$1C
6A6D: 11 D4 76    ld   de,$76D4
6A70: 18 08       jr   $6A7A
6A72: 11 EF 68    ld   de,$68EF
6A75: 18 03       jr   $6A7A
6A77: 11 0A 6B    ld   de,$6B0A
6A7A: CD 1E 38    call $381E
6A7D: F1          pop  af
6A7E: C9          ret
6A7F: 3A 2B 89    ld   a,($892B)
6A82: A7          and  a
6A83: 28 40       jr   z,$6AC5
6A85: DD 21 E0 8A ld   ix,$8AE0
6A89: 11 18 00    ld   de,$0018
6A8C: 06 12       ld   b,$12
6A8E: D9          exx
6A8F: CD 98 6A    call $6A98
6A92: D9          exx
6A93: DD 19       add  ix,de
6A95: 10 F7       djnz $6A8E
6A97: C9          ret
6A98: DD 7E 01    ld   a,(ix+$01)
6A9B: A7          and  a
6A9C: C8          ret  z
6A9D: DD 7E 02    ld   a,(ix+$02)
6AA0: 3D          dec  a
6AA1: E6 03       and  $03
6AA3: EF          rst  $28
jump_table_6AA4:
	.word	$6AA8
	.word	$67DF

6AA8: CD 06 40    call $4006
6AAB: DD 7E 05    ld   a,(ix+$05)
6AAE: DD 96 09    sub  (ix+$09)
6AB1: 30 03       jr   nc,$6AB6
6AB3: DD 35 06    dec  (ix+$06)
6AB6: DD 77 05    ld   (ix+$05),a
6AB9: DD 7E 06    ld   a,(ix+$06)
6ABC: A7          and  a
6ABD: C0          ret  nz
6ABE: 32 56 8F    ld   ($8F56),a
6AC1: DD 34 02    inc  (ix+$02)
6AC4: C9          ret
6AC5: 3A 2D 89    ld   a,($892D)
6AC8: FE 02       cp   $02
6ACA: C0          ret  nz
6ACB: 3A 56 8F    ld   a,($8F56)
6ACE: A7          and  a
6ACF: C0          ret  nz
6AD0: 3C          inc  a
6AD1: 32 56 8F    ld   ($8F56),a
6AD4: 21 50 84    ld   hl,$8450
6AD7: 11 00 00    ld   de,$0000
6ADA: 7B          ld   a,e
6ADB: 86          add  a,(hl)
6ADC: 5F          ld   e,a
6ADD: 30 01       jr   nc,$6AE0
6ADF: 14          inc  d
6AE0: 2C          inc  l
6AE1: 7D          ld   a,l
6AE2: E6 1F       and  $1F
6AE4: FE 1B       cp   $1B
6AE6: 20 03       jr   nz,$6AEB
6AE8: 2C          inc  l
6AE9: 18 EF       jr   $6ADA
6AEB: FE 1F       cp   $1F
6AED: 20 EB       jr   nz,$6ADA
6AEF: 3E 12       ld   a,$12
6AF1: 85          add  a,l
6AF2: 6F          ld   l,a
6AF3: 30 E5       jr   nc,$6ADA
6AF5: 24          inc  h
6AF6: 7C          ld   a,h
6AF7: FE 88       cp   $88
6AF9: 38 DF       jr   c,$6ADA
6AFB: 7B          ld   a,e
6AFC: FE B8       cp   $B8
6AFE: 28 03       jr   z,$6B03
6B00: C3 29 09    jp   $0929
6B03: 7A          ld   a,d
6B04: FE 29       cp   $29
6B06: C2 29 38    jp   nz,$3829
6B09: C9          ret

6B13: 21 06 8F    ld   hl,$8F06
6B16: 7E          ld   a,(hl)
6B17: A7          and  a
6B18: 28 02       jr   z,$6B1C
6B1A: 35          dec  (hl)
6B1B: C9          ret
6B1C: 36 0C       ld   (hl),$0C
6B1E: 23          inc  hl
6B1F: 34          inc  (hl)
6B20: 7E          ld   a,(hl)
6B21: E6 01       and  $01
6B23: 11 44 27    ld   de,$2744
6B26: 21 B4 84    ld   hl,$84B4
6B29: 28 03       jr   z,$6B2E
6B2B: 11 48 27    ld   de,$2748
6B2E: D5          push de
6B2F: CD 25 33    call write_4x4_tile_block_3325
6B32: 11 A0 FF    ld   de,$FFA0
6B35: 19          add  hl,de
6B36: D1          pop  de
6B37: CD 25 33    call write_4x4_tile_block_3325
6B3A: C9          ret
6B3B: 3A 06 88    ld   a,($8806)
6B3E: A7          and  a
6B3F: C0          ret  nz
6B40: 3A 5F 8D    ld   a,($8D5F)
6B43: A7          and  a
6B44: C0          ret  nz
6B45: 3A 07 89    ld   a,($8907)
6B48: E6 01       and  $01
6B4A: C0          ret  nz
6B4B: 21 5E 8D    ld   hl,$8D5E
6B4E: 7E          ld   a,(hl)
6B4F: A7          and  a
6B50: C8          ret  z
6B51: FE 01       cp   $01
6B53: 28 02       jr   z,$6B57
6B55: 35          dec  (hl)
6B56: C9          ret
6B57: 3E 11       ld   a,$11
6B59: 32 0A 88    ld   (in_game_sub_state_880A),a
6B5C: 32 5F 8D    ld   ($8D5F),a
6B5F: 3E FF       ld   a,$FF
6B61: 32 5E 8D    ld   ($8D5E),a
6B64: 11 18 00    ld   de,$0018
6B67: DD 21 E0 8A ld   ix,$8AE0
6B6B: FD 21 80 8D ld   iy,$8D80
6B6F: 06 0B       ld   b,$0B
6B71: DD 7E 04    ld   a,(ix+$04)
6B74: E6 1F       and  $1F
6B76: FE 06       cp   $06
6B78: 38 1D       jr   c,$6B97
6B7A: FE 1A       cp   $1A
6B7C: 30 19       jr   nc,$6B97
6B7E: DD E5       push ix
6B80: E1          pop  hl
6B81: FD 75 00    ld   (iy+$00),l
6B84: FD 74 01    ld   (iy+$01),h
6B87: DD 7E 06    ld   a,(ix+$06)
6B8A: FD 77 02    ld   (iy+$02),a
6B8D: DD 36 06 00 ld   (ix+$06),$00
6B91: FD 23       inc  iy
6B93: FD 23       inc  iy
6B95: FD 23       inc  iy
6B97: DD 19       add  ix,de
6B99: 10 D6       djnz $6B71
6B9B: 11 2B 06    ld   de,$062B
6B9E: FF          rst  $38
6B9F: 11 2C 06    ld   de,$062C
6BA2: FF          rst  $38
6BA3: 11 2D 06    ld   de,$062D
6BA6: FF          rst  $38
6BA7: 11 2E 06    ld   de,$062E
6BAA: FF          rst  $38
6BAB: 11 2F 06    ld   de,$062F
6BAE: FF          rst  $38
6BAF: C3 EF 02    jp   update_sprite_shadows_02EF
6BB2: 21 5E 8D    ld   hl,$8D5E
6BB5: 35          dec  (hl)
6BB6: C0          ret  nz
6BB7: FD 21 80 8D ld   iy,$8D80
6BBB: 11 03 00    ld   de,$0003
6BBE: 06 0B       ld   b,$0B
6BC0: AF          xor  a
6BC1: FD 66 01    ld   h,(iy+$01)
6BC4: B4          or   h
6BC5: 28 09       jr   z,$6BD0
6BC7: FD 6E 00    ld   l,(iy+$00)
6BCA: FD 7E 02    ld   a,(iy+$02)
6BCD: 19          add  hl,de
6BCE: 19          add  hl,de
6BCF: 77          ld   (hl),a
6BD0: FD 19       add  iy,de
6BD2: 10 EC       djnz $6BC0
6BD4: 3E 04       ld   a,$04
6BD6: 32 0A 88    ld   (in_game_sub_state_880A),a
6BD9: 11 AB 06    ld   de,$06AB
6BDC: FF          rst  $38
6BDD: 11 AC 06    ld   de,$06AC
6BE0: FF          rst  $38
6BE1: 11 AD 06    ld   de,$06AD
6BE4: FF          rst  $38
6BE5: 11 AE 06    ld   de,$06AE
6BE8: FF          rst  $38
6BE9: 11 AF 06    ld   de,$06AF
6BEC: 18 C0       jr   $6BAE
6BEE: 3A 52 8D    ld   a,($8D52)
6BF1: A7          and  a
6BF2: 28 20       jr   z,$6C14
6BF4: 21 87 8A    ld   hl,$8A87
6BF7: 3D          dec  a
6BF8: 28 0D       jr   z,$6C07
6BFA: CB DE       set  3,(hl)
6BFC: CB 96       res  2,(hl)
6BFE: 21 53 8D    ld   hl,$8D53
6C01: 35          dec  (hl)
6C02: C0          ret  nz
6C03: AF          xor  a
6C04: 2D          dec  l
6C05: 77          ld   (hl),a
6C06: C9          ret
6C07: CB D6       set  2,(hl)
6C09: CB 9E       res  3,(hl)
6C0B: 21 53 8D    ld   hl,$8D53
6C0E: 35          dec  (hl)
6C0F: C0          ret  nz
6C10: AF          xor  a
6C11: 2D          dec  l
6C12: 77          ld   (hl),a
6C13: C9          ret
6C14: CD 18 6C    call $6C18
6C17: C9          ret
6C18: DD 21 40 88 ld   ix,sprite_shadow_ram_8840
6C1C: FD 21 7C 88 ld   iy,sprite_shadow_ram_8840+$3C
6C20: 21 E8 8B    ld   hl,$8BE8
6C23: 06 03       ld   b,$03
6C25: CD 3F 6C    call $6C3F
6C28: 11 04 00    ld   de,$0004
6C2B: FD 19       add  iy,de
6C2D: 1E 18       ld   e,$18
6C2F: 19          add  hl,de
6C30: 10 F3       djnz $6C25
6C32: 21 87 8A    ld   hl,$8A87
6C35: CB 96       res  2,(hl)
6C37: CB 9E       res  3,(hl)
6C39: 21 54 8D    ld   hl,$8D54
6C3C: 36 00       ld   (hl),$00
6C3E: C9          ret
6C3F: CB 46       bit  0,(hl)
6C41: C8          ret  z
6C42: 1E 10       ld   e,$10
6C44: 16 00       ld   d,$00
6C46: DD 7E 00    ld   a,(ix+$00)
6C49: 83          add  a,e
6C4A: 5F          ld   e,a
6C4B: DD 7E 02    ld   a,(ix+$02)
6C4E: 82          add  a,d
6C4F: 57          ld   d,a
6C50: FD 7E 00    ld   a,(iy+$00)
6C53: C6 20       add  a,$20
6C55: 93          sub  e
6C56: 30 02       jr   nc,$6C5A
6C58: ED 44       neg
6C5A: FE 18       cp   $18
6C5C: D0          ret  nc
6C5D: 0E 00       ld   c,$00
6C5F: FD 7E 02    ld   a,(iy+$02)
6C62: C6 08       add  a,$08
6C64: 92          sub  d
6C65: 30 04       jr   nc,$6C6B
6C67: 0E FF       ld   c,$FF
6C69: ED 44       neg
6C6B: FE 0E       cp   $0E
6C6D: D0          ret  nc
6C6E: 21 54 8D    ld   hl,$8D54
6C71: 36 01       ld   (hl),$01
6C73: DD 7E 02    ld   a,(ix+$02)
6C76: 21 87 8A    ld   hl,$8A87
6C79: 0C          inc  c
6C7A: 20 13       jr   nz,$6C8F
6C7C: FE B6       cp   $B6
6C7E: 38 1B       jr   c,$6C9B
6C80: CB D6       set  2,(hl)
6C82: CB 9E       res  3,(hl)
6C84: 0E 01       ld   c,$01
6C86: 21 52 8D    ld   hl,$8D52
6C89: 71          ld   (hl),c
6C8A: 2C          inc  l
6C8B: 36 18       ld   (hl),$18
6C8D: F1          pop  af
6C8E: C9          ret
6C8F: FE 51       cp   $51
6C91: 30 12       jr   nc,$6CA5
6C93: CB DE       set  3,(hl)
6C95: CB 96       res  2,(hl)
6C97: 0E 02       ld   c,$02
6C99: 18 EB       jr   $6C86
6C9B: FE 51       cp   $51
6C9D: 38 F4       jr   c,$6C93
6C9F: CB DE       set  3,(hl)
6CA1: CB 96       res  2,(hl)
6CA3: F1          pop  af
6CA4: C9          ret
6CA5: CB D6       set  2,(hl)
6CA7: CB 9E       res  3,(hl)
6CA9: F1          pop  af
6CAA: C9          ret
6CAB: 3A 06 88    ld   a,($8806)
6CAE: A7          and  a
6CAF: C0          ret  nz
6CB0: 3A 32 8D    ld   a,($8D32)
6CB3: A7          and  a
6CB4: C0          ret  nz
6CB5: 3A 24 8F    ld   a,($8F24)
6CB8: A7          and  a
6CB9: 21 87 8A    ld   hl,$8A87
6CBC: 28 03       jr   z,$6CC1
6CBE: AF          xor  a
6CBF: 77          ld   (hl),a
6CC0: C9          ret
6CC1: CD EE 6B    call $6BEE
6CC4: 3A 54 8D    ld   a,($8D54)
6CC7: A7          and  a
6CC8: C0          ret  nz
6CC9: 21 87 8A    ld   hl,$8A87
6CCC: 3A 30 8F    ld   a,($8F30)
6CCF: FE 01       cp   $01
6CD1: 28 3A       jr   z,$6D0D
6CD3: 3A 41 8F    ld   a,($8F41)
6CD6: A7          and  a
6CD7: C2 4D 6D    jp   nz,$6D4D
6CDA: 21 42 88    ld   hl,$8842
6CDD: DD 21 E0 8A ld   ix,$8AE0
6CE1: FD 21 52 88 ld   iy,$8852
6CE5: 06 06       ld   b,$06
6CE7: DD 7E 00    ld   a,(ix+$00)
6CEA: A7          and  a
6CEB: 20 2A       jr   nz,$6D17
6CED: 11 18 00    ld   de,$0018
6CF0: DD 19       add  ix,de
6CF2: 11 04 00    ld   de,$0004
6CF5: FD 19       add  iy,de
6CF7: 10 EE       djnz $6CE7
6CF9: 3A 41 8F    ld   a,($8F41)
6CFC: A7          and  a
6CFD: C8          ret  z
6CFE: 3A 42 88    ld   a,($8842)
6D01: 4F          ld   c,a
6D02: ED 5B 41 8F ld   de,($8F41)
6D06: 21 87 8A    ld   hl,$8A87
6D09: 1A          ld   a,(de)
6D0A: B9          cp   c
6D0B: 30 05       jr   nc,$6D12
6D0D: CB D6       set  2,(hl)
6D0F: CB 9E       res  3,(hl)
6D11: C9          ret
6D12: CB DE       set  3,(hl)
6D14: CB 96       res  2,(hl)
6D16: C9          ret
6D17: FD 7E 00    ld   a,(iy+$00)
6D1A: FE 40       cp   $40
6D1C: 38 CF       jr   c,$6CED
6D1E: FE C0       cp   $C0
6D20: 30 CB       jr   nc,$6CED
6D22: 96          sub  (hl)
6D23: 30 01       jr   nc,$6D26
6D25: 2F          cpl
6D26: 4F          ld   c,a
6D27: 3A 40 8F    ld   a,($8F40)
6D2A: A7          and  a
6D2B: 28 04       jr   z,$6D31
6D2D: B9          cp   c
6D2E: 30 BD       jr   nc,$6CED
6D30: 79          ld   a,c
6D31: 32 40 8F    ld   ($8F40),a
6D34: FD E5       push iy
6D36: D1          pop  de
6D37: 7B          ld   a,e
6D38: 32 41 8F    ld   ($8F41),a
6D3B: 7A          ld   a,d
6D3C: 32 42 8F    ld   ($8F42),a
6D3F: DD E5       push ix
6D41: D1          pop  de
6D42: 13          inc  de
6D43: 7B          ld   a,e
6D44: 32 43 8F    ld   ($8F43),a
6D47: 7A          ld   a,d
6D48: 32 44 8F    ld   ($8F44),a
6D4B: 18 A0       jr   $6CED
6D4D: 2A 43 8F    ld   hl,($8F43)
6D50: 7E          ld   a,(hl)
6D51: A7          and  a
6D52: 20 0C       jr   nz,$6D60
6D54: 2A 41 8F    ld   hl,($8F41)
6D57: 7E          ld   a,(hl)
6D58: FE 40       cp   $40
6D5A: 38 04       jr   c,$6D60
6D5C: FE C0       cp   $C0
6D5E: 38 08       jr   c,$6D68
6D60: AF          xor  a
6D61: 21 40 8F    ld   hl,$8F40
6D64: 06 05       ld   b,$05
6D66: D7          rst  $10
6D67: C9          ret
6D68: 4F          ld   c,a
6D69: 3A 07 89    ld   a,($8907)
6D6C: CB 47       bit  0,a
6D6E: 3A 42 88    ld   a,($8842)
6D71: 20 04       jr   nz,$6D77
6D73: D6 02       sub  $02
6D75: 18 02       jr   $6D79
6D77: C6 14       add  a,$14
6D79: 21 87 8A    ld   hl,$8A87
6D7C: 47          ld   b,a
6D7D: 3A 03 8F    ld   a,($8F03)
6D80: 3C          inc  a
6D81: 32 03 8F    ld   ($8F03),a
6D84: E6 07       and  $07
6D86: 20 0D       jr   nz,$6D95
6D88: 78          ld   a,b
6D89: C6 08       add  a,$08
6D8B: B9          cp   c
6D8C: 38 07       jr   c,$6D95
6D8E: D6 10       sub  $10
6D90: B9          cp   c
6D91: 3E 10       ld   a,$10
6D93: 38 01       jr   c,$6D96
6D95: AF          xor  a
6D96: 77          ld   (hl),a
6D97: 78          ld   a,b
6D98: B9          cp   c
6D99: 28 06       jr   z,$6DA1
6D9B: DA 12 6D    jp   c,$6D12
6D9E: C3 0D 6D    jp   $6D0D
6DA1: CB 96       res  2,(hl)
6DA3: CB 9E       res  3,(hl)
6DA5: C9          ret
6DA6: 3A 51 8F    ld   a,($8F51)
6DA9: EF          rst  $28
jump_table_6DAA:
	.word	$6DB8
	.word	$6E59    
	.word	$6F42    
	.word	$6F5E    
	.word	$6F9D   
	.word	$7032 
	.word	$705F 


6DB8: CD BC 0F    call $0FBC
6DBB: 3A 07 89    ld   a,($8907)
6DBE: CB 3F       srl  a
6DC0: CB 3F       srl  a
6DC2: FE 07       cp   $07
6DC4: 38 02       jr   c,$6DC8
6DC6: 3E 07       ld   a,$07
6DC8: E6 07       and  $07
6DCA: 21 F3 70    ld   hl,$70F3
6DCD: CD 45 0C    call $0C45
6DD0: ED 53 4A 8F ld   ($8F4A),de
6DD4: 3E 40       ld   a,$40
6DD6: 32 48 8F    ld   ($8F48),a
6DD9: 21 51 8F    ld   hl,$8F51
6DDC: 34          inc  (hl)
6DDD: 3A 07 89    ld   a,($8907)
6DE0: CB 3F       srl  a
6DE2: CB 3F       srl  a
6DE4: CB 3F       srl  a
6DE6: D0          ret  nc
; protection again?? checksum
6DE7: 21 C8 0A    ld   hl,$0AC8
6DEA: 11 F9 6D    ld   de,$6DF9
6DED: 06 60       ld   b,$60
6DEF: 1A          ld   a,(de)
6DF0: BE          cp   (hl)
6DF1: C2 71 70    jp   nz,$7071
6DF4: 23          inc  hl
6DF5: 13          inc  de
6DF6: 10 F7       djnz $6DEF
6DF8: C9          ret

6DF9: 21 41 8D    ld   hl,$8D41
6DFC: 35          dec  (hl)
6DFD: 20 03       jr   nz,$6E02
6DFF: CD 28 0A    call $0A28
6E02: CD F8 09    call $09F8
6E05: 21 50 8E    ld   hl,$8E50
6E08: 35          dec  (hl)
6E09: C0          ret  nz
6E0A: 36 02       ld   (hl),$02
6E0C: 2A 54 8E    ld   hl,($8E54)
6E0F: 7E          ld   a,(hl)
6E10: 23          inc  hl
6E11: 22 54 8E    ld   ($8E54),hl
6E14: 2A 56 8E    ld   hl,($8E56)
6E17: 77          ld   (hl),a
6E18: 11 E0 FF    ld   de,$FFE0
6E1B: 19          add  hl,de
6E1C: 22 56 8E    ld   ($8E56),hl
6E1F: 21 52 8E    ld   hl,$8E52
6E22: 35          dec  (hl)
6E23: C0          ret  nz
6E24: 36 0D       ld   (hl),$0D
6E26: 21 50 8E    ld   hl,$8E50
6E29: 36 14       ld   (hl),$14
6E2B: 2C          inc  l
6E2C: 34          inc  (hl)
6E2D: 2A 56 8E    ld   hl,($8E56)
6E30: 11 00 00    ld   de,$0000
6E33: 06 0E       ld   b,$0E
6E35: 7E          ld   a,(hl)
6E36: 83          add  a,e
6E37: 5F          ld   e,a
6E38: 30 01       jr   nc,$6E3B
6E3A: 14          inc  d
6E3B: 3E 20       ld   a,$20
6E3D: 85          add  a,l
6E3E: 6F          ld   l,a
6E3F: 30 01       jr   nc,$6E42
6E41: 24          inc  h
6E42: 10 F1       djnz $6E35
6E44: 2A 48 8F    ld   hl,($8F48)
6E47: 7E          ld   a,(hl)
6E48: BB          cp   e
6E49: C2 42 74    jp   nz,pigs_arrive_during_title_7442
6E4C: 23          inc  hl
6E4D: 7E          ld   a,(hl)
6E4E: BA          cp   d
6E4F: C2 EA 76    jp   nz,$76EA
6E52: 23          inc  hl
6E53: 22 48 8F    ld   ($8F48),hl
6E56: C9          ret
6E57: C6 01       add  a,$01

6E59: CD 83 15    call $1583
6E5C: CD 75 6E    call $6E75
6E5F: CD 55 1E    call $1E55
6E62: CD D4 20    call $20D4
6E65: CD EF 02    call update_sprite_shadows_02EF
6E68: CD DA 18    call $18DA
6E6B: CD 1C 19    call $191C
6E6E: CD 04 64    call $6404
6E71: CD 64 0E    call $0E64
6E74: C9          ret

6E75: 21 1E 88    ld   hl,$881E
6E78: 3A F0 8E    ld   a,(checksum_failed_8EF0)
6E7B: B6          or   (hl)
6E7C: C2 92 4C    jp   nz,$4C92	; crash!
6E7F: CD 86 6E    call $6E86
6E82: CD DB 6E    call $6EDB
6E85: C9          ret
6E86: 21 48 8F    ld   hl,$8F48
6E89: 7E          ld   a,(hl)
6E8A: A7          and  a
6E8B: 28 02       jr   z,$6E8F
6E8D: 35          dec  (hl)
6E8E: C9          ret
6E8F: 3A 49 8F    ld   a,($8F49)
6E92: CB 4F       bit  1,a
6E94: 3E 20       ld   a,$20
6E96: 28 02       jr   z,$6E9A
6E98: 3E 2C       ld   a,$2C
6E9A: 77          ld   (hl),a
6E9B: 2A 4A 8F    ld   hl,($8F4A)
6E9E: 7E          ld   a,(hl)
6E9F: FE FF       cp   $FF
6EA1: C8          ret  z
6EA2: 23          inc  hl
6EA3: 22 4A 8F    ld   ($8F4A),hl
6EA6: 47          ld   b,a
6EA7: DD 21 C8 8A ld   ix,$8AC8
6EAB: 11 18 00    ld   de,$0018
6EAE: DD 19       add  ix,de
6EB0: 10 FC       djnz $6EAE
6EB2: 21 EA 8B    ld   hl,$8BEA
6EB5: 11 18 00    ld   de,$0018
6EB8: 06 03       ld   b,$03
6EBA: 7E          ld   a,(hl)
6EBB: A7          and  a
6EBC: 28 0B       jr   z,$6EC9
6EBE: 19          add  hl,de
6EBF: 10 F9       djnz $6EBA
6EC1: 2A 4A 8F    ld   hl,($8F4A)
6EC4: 2B          dec  hl
6EC5: 22 4A 8F    ld   ($8F4A),hl
6EC8: C9          ret
6EC9: DD 36 02 06 ld   (ix+$02),$06
6ECD: 11 6A 39    ld   de,$396A
6ED0: CD 1E 38    call $381E
6ED3: CD 6C 3A    call $3A6C
6ED6: 21 49 8F    ld   hl,$8F49
6ED9: 34          inc  (hl)
6EDA: C9          ret
6EDB: DD 21 E0 8A ld   ix,$8AE0
6EDF: 11 18 00    ld   de,$0018
6EE2: 06 0E       ld   b,$0E
6EE4: D9          exx
6EE5: CD 2D 6F    call $6F2D
6EE8: D9          exx
6EE9: DD 19       add  ix,de
6EEB: 10 F7       djnz $6EE4
6EED: 2A 4A 8F    ld   hl,($8F4A)
6EF0: 7E          ld   a,(hl)
6EF1: FE FF       cp   $FF
6EF3: C0          ret  nz
6EF4: 21 EA 8B    ld   hl,$8BEA
6EF7: 11 18 00    ld   de,$0018
6EFA: 06 03       ld   b,$03
6EFC: 7E          ld   a,(hl)
6EFD: A7          and  a
6EFE: C0          ret  nz
6EFF: 19          add  hl,de
6F00: 10 FA       djnz $6EFC
6F02: 21 51 8F    ld   hl,$8F51
6F05: 34          inc  (hl)
6F06: 23          inc  hl
6F07: 11 35 06    ld   de,$0635
6F0A: FF          rst  $38
6F0B: 3A 47 8F    ld   a,($8F47)
6F0E: 47          ld   b,a
6F0F: CB 27       sla  a
6F11: 80          add  a,b
6F12: BE          cp   (hl)
6F13: 11 08 06    ld   de,$0608
6F16: 20 07       jr   nz,$6F1F
6F18: 3E 04       ld   a,$04
6F1A: 32 51 8F    ld   ($8F51),a
6F1D: 1E 10       ld   e,$10
6F1F: 3E 40       ld   a,$40
6F21: 32 48 8F    ld   ($8F48),a
6F24: FF          rst  $38
6F25: AF          xor  a
6F26: 21 90 8C    ld   hl,$8C90
6F29: 06 30       ld   b,$30
6F2B: D7          rst  $10
6F2C: C9          ret
6F2D: DD 7E 02    ld   a,(ix+$02)
6F30: FE 02       cp   $02
6F32: CA 36 35    jp   z,$3536
6F35: D6 0B       sub  $0B
6F37: 30 04       jr   nc,$6F3D
6F39: CD 06 40    call $4006
6F3C: C9          ret

6F42: 21 51 8F    ld   hl,$8F51                                       
6F45: 34          inc  (hl)
6F46: 23          inc  hl
6F47: 7E          ld   a,(hl)
6F48: A7          and  a
6F49: 28 04       jr   z,$6F4F
6F4B: 47          ld   b,a
6F4C: CD 31 11    call $1131
6F4F: 21 34 86    ld   hl,$8634
6F52: CD 19 11    call $1119
6F55: 09          add  hl,bc
6F56: 09          add  hl,bc
6F57: 7B          ld   a,e
6F58: 87          add  a,a
6F59: 27          daa
6F5A: CD 19 11    call $1119
6F5D: C9          ret
6F5E: 21 48 8F    ld   hl,$8F48
6F61: 7E          ld   a,(hl)
6F62: FE 20       cp   $20
6F64: 20 13       jr   nz,$6F79
6F66: 2E 52       ld   l,$52
6F68: 7E          ld   a,(hl)
6F69: A7          and  a
6F6A: 28 0B       jr   z,$6F77
6F6C: 11 15 03    ld   de,$0315
6F6F: FF          rst  $38
6F70: 3A E5 89    ld   a,($89E5)
6F73: A7          and  a
6F74: C0          ret  nz
6F75: 35          dec  (hl)
6F76: C0          ret  nz
6F77: 2E 48       ld   l,$48
6F79: 35          dec  (hl)
6F7A: C0          ret  nz
6F7B: 36 60       ld   (hl),$60
6F7D: 3A 07 89    ld   a,($8907)
6F80: FE 03       cp   $03
6F82: C2 98 6F    jp   nz,$6F98
; protection checksum again...
6F85: 21 32 0B    ld   hl,$0B32
6F88: 11 71 70    ld   de,$7071
6F8B: 06 79       ld   b,$79
6F8D: 1A          ld   a,(de)
6F8E: BE          cp   (hl)
6F8F: C2 F9 6D    jp   nz,$6DF9
6F92: 23          inc  hl
6F93: 13          inc  de
6F94: 10 F7       djnz $6F8D
6F96: 26 8F       ld   h,$8F
6F98: 2E 51       ld   l,$51
6F9A: 36 06       ld   (hl),$06
6F9C: C9          ret
6F9D: 3A 47 8F    ld   a,($8F47)
6FA0: 21 34 86    ld   hl,$8634
6FA3: 77          ld   (hl),a
6FA4: 47          ld   b,a
6FA5: AF          xor  a
6FA6: C6 05       add  a,$05
6FA8: 10 FC       djnz $6FA6
6FAA: 32 47 8F    ld   ($8F47),a
6FAD: 11 E0 FF    ld   de,$FFE0
6FB0: 06 03       ld   b,$03
6FB2: 19          add  hl,de
6FB3: 36 00       ld   (hl),$00
6FB5: 10 FB       djnz $6FB2
6FB7: 21 51 8F    ld   hl,$8F51
6FBA: 34          inc  (hl)
6FBB: 2E 48       ld   l,$48
6FBD: 36 80       ld   (hl),$80
6FBF: DD 21 C5 6A ld   ix,$6AC5
6FC3: 21 ED 6F    ld   hl,$6FED
6FC6: 06 44       ld   b,$44
6FC8: DD 7E 00    ld   a,(ix+$00)
6FCB: BE          cp   (hl)
6FCC: 20 14       jr   nz,$6FE2
6FCE: DD 2C       inc  ixl
6FD0: DD 7D       ld   a,ixl
6FD2: A7          and  a
6FD3: 20 02       jr   nz,$6FD7
6FD5: DD 24       inc  ixh
6FD7: 23          inc  hl
6FD8: 10 EE       djnz $6FC8
6FDA: CD 44 0F    call $0F44
6FDD: 11 27 06    ld   de,$0627
6FE0: FF          rst  $38
6FE1: C9          ret
6FE2: AF          xor  a
6FE3: 21 00 88    ld   hl,$8800
6FE6: 11 01 88    ld   de,$8801
6FE9: 77          ld   (hl),a
6FEA: ED B0       ldir
6FEC: C9          ret
6FED: 3A 2D 89    ld   a,($892D)
6FF0: FE 02       cp   $02
6FF2: C0          ret  nz
6FF3: 3A 56 8F    ld   a,($8F56)
6FF6: A7          and  a
6FF7: C0          ret  nz
6FF8: 3C          inc  a
6FF9: 32 56 8F    ld   ($8F56),a
6FFC: 21 50 84    ld   hl,$8450
6FFF: 11 00 00    ld   de,$0000
7002: 7B          ld   a,e
7003: 86          add  a,(hl)
7004: 5F          ld   e,a
7005: 30 01       jr   nc,$7008
7007: 14          inc  d
7008: 2C          inc  l
7009: 7D          ld   a,l
700A: E6 1F       and  $1F
700C: FE 1B       cp   $1B
700E: 20 03       jr   nz,$7013
7010: 2C          inc  l
7011: 18 EF       jr   $7002
7013: FE 1F       cp   $1F
7015: 20 EB       jr   nz,$7002
7017: 3E 12       ld   a,$12
7019: 85          add  a,l
701A: 6F          ld   l,a
701B: 30 E5       jr   nc,$7002
701D: 24          inc  h
701E: 7C          ld   a,h
701F: FE 88       cp   $88
7021: 38 DF       jr   c,$7002
7023: 7B          ld   a,e
7024: FE B8       cp   $B8
7026: 28 03       jr   z,$702B
7028: C3 29 09    jp   $0929
702B: 7A          ld   a,d
702C: FE 29       cp   $29
702E: C2 29 38    jp   nz,$3829
7031: C9          ret
7032: 21 47 8F    ld   hl,$8F47
7035: 7E          ld   a,(hl)
7036: A7          and  a
7037: C4 59 70    call nz,$7059
703A: 23          inc  hl
703B: 7E          ld   a,(hl)
703C: A7          and  a
703D: 28 14       jr   z,$7053
703F: 35          dec  (hl)
7040: 7E          ld   a,(hl)
7041: E6 0F       and  $0F
7043: A7          and  a
7044: C0          ret  nz
7045: 2E 54       ld   l,$54
7047: 34          inc  (hl)
7048: CB 46       bit  0,(hl)
704A: 11 A7 06    ld   de,$06A7
704D: 28 02       jr   z,$7051
704F: 1E 27       ld   e,$27
7051: FF          rst  $38
7052: C9          ret
7053: 36 20       ld   (hl),$20
7055: 2E 51       ld   l,$51
7057: 34          inc  (hl)
7058: C9          ret
7059: 35          dec  (hl)
705A: 11 15 03    ld   de,$0315
705D: FF          rst  $38
705E: C9          ret
705F: 21 48 8F    ld   hl,$8F48
7062: 35          dec  (hl)
7063: C0          ret  nz
7064: CD CF 0E    call $0ECF
7067: AF          xor  a
7068: 32 52 8F    ld   ($8F52),a
706B: 3E 06       ld   a,$06
706D: 32 0A 88    ld   (in_game_sub_state_880A),a
7070: C9          ret
7071: 21 BC 82    ld   hl,$82BC
7074: 11 E0 FF    ld   de,$FFE0
7077: 06 0A       ld   b,$0A
7079: 7E          ld   a,(hl)
707A: 19          add  hl,de
707B: BE          cp   (hl)
707C: C2 B3 08    jp   nz,$08B3
707F: 10 F8       djnz $7079
7081: 21 41 8D    ld   hl,$8D41
7084: 35          dec  (hl)
7085: 20 03       jr   nz,$708A
7087: CD 28 0A    call $0A28
708A: CD F8 09    call $09F8
708D: 21 50 8E    ld   hl,$8E50
7090: 35          dec  (hl)
7091: C0          ret  nz
7092: 36 01       ld   (hl),$01
7094: 2C          inc  l
7095: 35          dec  (hl)
7096: 3A 53 8E    ld   a,($8E53)
7099: 3D          dec  a
709A: 21 AB 0B    ld   hl,$0BAB
709D: CD 45 0C    call $0C45
70A0: ED 53 56 8E ld   ($8E56),de
70A4: 21 53 8E    ld   hl,$8E53
70A7: 35          dec  (hl)
70A8: C0          ret  nz
70A9: 21 50 8E    ld   hl,$8E50
70AC: 36 96       ld   (hl),$96
70AE: 2C          inc  l
70AF: AF          xor  a
70B0: 77          ld   (hl),a
70B1: 21 62 84    ld   hl,$8462
70B4: 57          ld   d,a
70B5: 5F          ld   e,a
70B6: 0E 0E       ld   c,$0E
70B8: 06 1D       ld   b,$1D
70BA: 7B          ld   a,e
70BB: 86          add  a,(hl)
70BC: 30 01       jr   nc,$70BF
70BE: 14          inc  d
70BF: 5F          ld   e,a
70C0: 23          inc  hl
70C1: 10 F7       djnz $70BA
70C3: 7D          ld   a,l
70C4: C6 03       add  a,$03
70C6: 6F          ld   l,a
70C7: 30 01       jr   nc,$70CA
70C9: 24          inc  h
70CA: 0D          dec  c
70CB: 20 EB       jr   nz,$70B8
70CD: 2A 48 8F    ld   hl,($8F48)
70D0: 7B          ld   a,e
70D1: BE          cp   (hl)
70D2: C2 B3 08    jp   nz,$08B3
70D5: 23          inc  hl
70D6: 7E          ld   a,(hl)
70D7: BA          cp   d
70D8: C2 E9 08    jp   nz,$08E9
70DB: AF          xor  a
70DC: 32 48 8F    ld   ($8F48),a
70DF: 32 49 8F    ld   ($8F49),a
70E2: 3E 03       ld   a,GAME_IN_PLAY_03
70E4: 32 05 88    ld   (game_state_8805),a
70E7: C3 00 0E    jp   init_play_0E00

71B9: 3A 38 8F    ld   a,($8F38)
71BC: 21 EF 02    ld   hl,update_sprite_shadows_02EF
71BF: E5          push hl
71C0: EF          rst  $28
jump_table_71C1:
	.word	$71C7    
	.word	$72A0    
	.word	$7421

71C7: CD CE 71    call $71CE                                          
71CA: CD D4 20    call $20D4
71CD: C9          ret
71CE: 21 36 8F    ld   hl,$8F36
71D1: 7E          ld   a,(hl)
71D2: A7          and  a
71D3: 28 02       jr   z,$71D7
71D5: 35          dec  (hl)
71D6: C9          ret
71D7: 21 99 8A    ld   hl,$8A99
71DA: 3A 90 8C    ld   a,($8C90)
71DD: B6          or   (hl)
71DE: 21 87 8A    ld   hl,$8A87
71E1: 20 1A       jr   nz,$71FD
71E3: 3A 5B 8F    ld   a,($8F5B)
71E6: A7          and  a
71E7: 20 0F       jr   nz,$71F8
71E9: 3A 84 8A    ld   a,(lift_speed_8A84)
71EC: FE 60       cp   $60
71EE: 38 03       jr   c,$71F3
71F0: 32 5B 8F    ld   ($8F5B),a
71F3: CB 96       res  2,(hl)
71F5: CB DE       set  3,(hl)
71F7: C9          ret
71F8: CB D6       set  2,(hl)
71FA: CB 9E       res  3,(hl)
71FC: C9          ret
71FD: 3A 84 8A    ld   a,(lift_speed_8A84)
7200: FE 59       cp   $59
7202: 28 07       jr   z,$720B
7204: 30 DD       jr   nc,$71E3
7206: CB 96       res  2,(hl)
7208: CB DE       set  3,(hl)
720A: C9          ret
720B: 3A 39 8F    ld   a,($8F39)
720E: A7          and  a
720F: 20 0A       jr   nz,$721B
7211: 3E 01       ld   a,$01
7213: 32 39 8F    ld   ($8F39),a
7216: CB 96       res  2,(hl)
7218: CB 9E       res  3,(hl)
721A: C9          ret
721B: FE 02       cp   $02
721D: 28 0B       jr   z,$722A
721F: 3E 02       ld   a,$02
7221: 32 39 8F    ld   ($8F39),a
7224: 3E 10       ld   a,$10
7226: 32 87 8A    ld   ($8A87),a
7229: C9          ret
722A: 21 3E 8F    ld   hl,$8F3E
722D: 7E          ld   a,(hl)
722E: A7          and  a
722F: C2 92 72    jp   nz,$7292
7232: 2E 3B       ld   l,$3B
7234: 34          inc  (hl)
7235: 7E          ld   a,(hl)
7236: E6 07       and  $07
7238: C2 87 72    jp   nz,$7287
723B: 3A 96 8C    ld   a,($8C96)
723E: CB 3F       srl  a
7240: CB 3F       srl  a
7242: CB 3F       srl  a
7244: 3C          inc  a
7245: 47          ld   b,a
7246: 21 E0 87    ld   hl,$87E0
7249: 11 E0 FF    ld   de,$FFE0
724C: 19          add  hl,de
724D: 10 FD       djnz $724C
724F: CD 87 72    call $7287
7252: CB 3F       srl  a
7254: CB 3F       srl  a
7256: CB 3F       srl  a
7258: 3C          inc  a
7259: 47          ld   b,a
725A: 23          inc  hl
725B: 10 FD       djnz $725A
725D: 36 2C       ld   (hl),$2C
725F: 11 00 FC    ld   de,$FC00
7262: 19          add  hl,de
7263: 3A 96 8C    ld   a,($8C96)
7266: E6 06       and  $06
7268: FE 06       cp   $06
726A: 3A 94 8C    ld   a,($8C94)
726D: 28 0C       jr   z,$727B
726F: E6 06       and  $06
7271: FE 02       cp   $02
7273: 28 03       jr   z,$7278
7275: 36 00       ld   (hl),$00
7277: C9          ret
7278: 36 40       ld   (hl),$40
727A: C9          ret
727B: E6 06       and  $06
727D: FE 02       cp   $02
727F: 28 03       jr   z,$7284
7281: 36 80       ld   (hl),$80
7283: C9          ret
7284: 36 C0       ld   (hl),$C0
7286: C9          ret
7287: 3A 94 8C    ld   a,($8C94)
728A: FE D0       cp   $D0
728C: D8          ret  c
728D: 3E 01       ld   a,$01
728F: 32 3E 8F    ld   ($8F3E),a
7292: AF          xor  a
7293: 32 87 8A    ld   ($8A87),a
7296: 32 5B 8F    ld   ($8F5B),a
7299: 21 38 8F    ld   hl,$8F38
729C: 34          inc  (hl)
729D: 23          inc  hl
729E: 77          ld   (hl),a
729F: C9          ret

72A0: CD D4 20    call $20D4
72A3: CD A7 72    call $72A7
72A6: C9          ret
72A7: 21 3A 8F    ld   hl,$8F3A
72AA: 7E          ld   a,(hl)
72AB: A7          and  a
72AC: 20 04       jr   nz,$72B2
72AE: CD E1 72    call $72E1
72B1: C9          ret
72B2: 3A 3C 8F    ld   a,($8F3C)
72B5: A7          and  a
72B6: CA E3 73    jp   z,$73E3
72B9: DD 21 E0 8A ld   ix,$8AE0
72BD: 11 18 00    ld   de,$0018
72C0: 3A 3D 8F    ld   a,($8F3D)
72C3: 87          add  a,a
72C4: 47          ld   b,a
72C5: D9          exx
72C6: CD CF 72    call $72CF
72C9: D9          exx
72CA: DD 19       add  ix,de
72CC: 10 F7       djnz $72C5
72CE: C9          ret
72CF: DD 7E 00    ld   a,(ix+$00)
72D2: DD B6 01    or   (ix+$01)
72D5: 0F          rrca
72D6: D0          ret  nc
72D7: DD 7E 02    ld   a,(ix+$02)
72DA: EF          rst  $28
jump_table_72DB:
	.word	$733C       
	.word	$7395       
	.word	$73CE       

72E1: 3A 90 8C    ld   a,($8C90)
72E4: A7          and  a
72E5: C0          ret  nz
72E6: 3C          inc  a
72E7: 32 3A 8F    ld   ($8F3A),a
72EA: 21 3D 8F    ld   hl,$8F3D
72ED: 34          inc  (hl)
72EE: 7E          ld   a,(hl)
72EF: FE 04       cp   $04
72F1: 20 08       jr   nz,$72FB
72F3: 2E 38       ld   l,$38
72F5: 34          inc  (hl)
72F6: 2E 36       ld   l,$36
72F8: 36 20       ld   (hl),$20
72FA: C9          ret
72FB: 87          add  a,a
72FC: 32 3C 8F    ld   ($8F3C),a
72FF: 47          ld   b,a
7300: 21 09 74    ld   hl,$7409
7303: 11 18 00    ld   de,$0018
7306: DD 21 E0 8A ld   ix,$8AE0
730A: DD 36 00 01 ld   (ix+$00),$01
730E: 7E          ld   a,(hl)
730F: DD 77 06    ld   (ix+$06),a
7312: 23          inc  hl
7313: 7E          ld   a,(hl)
7314: DD 77 10    ld   (ix+$10),a
7317: 23          inc  hl
7318: 7E          ld   a,(hl)
7319: DD 77 04    ld   (ix+$04),a
731C: 23          inc  hl
731D: 7E          ld   a,(hl)
731E: DD 77 0F    ld   (ix+$0f),a
7321: 23          inc  hl
7322: DD 7D       ld   a,ixl
7324: CB 5F       bit  3,a
7326: 28 04       jr   z,$732C
7328: DD 36 03 80 ld   (ix+$03),$80
732C: DD 36 05 80 ld   (ix+$05),$80
7330: DD 19       add  ix,de
7332: 10 D6       djnz $730A
7334: 78          ld   a,b
7335: 21 38 8F    ld   hl,$8F38
7338: 77          ld   (hl),a
7339: 23          inc  hl
733A: 77          ld   (hl),a
733B: C9          ret

733C: 3A 96 8C    ld   a,($8C96)
733F: CB 3F       srl  a
7341: CB 3F       srl  a
7343: CB 3F       srl  a
7345: DD BE 06    cp   (ix+$06)
7348: 28 05       jr   z,$734F
734A: 3C          inc  a
734B: DD BE 06    cp   (ix+$06)
734E: C0          ret  nz
734F: 3A 94 8C    ld   a,($8C94)
7352: CB 3F       srl  a
7354: CB 3F       srl  a
7356: CB 3F       srl  a
7358: C6 04       add  a,$04
735A: DD BE 04    cp   (ix+$04)
735D: 28 07       jr   z,$7366
735F: D8          ret  c
7360: D6 05       sub  $05
7362: DD BE 04    cp   (ix+$04)
7365: D0          ret  nc
7366: DD 34 02    inc  (ix+$02)
7369: DD 7D       ld   a,ixl
736B: CB 5F       bit  3,a
736D: 20 1B       jr   nz,$738A
736F: 11 86 40    ld   de,$4086
7372: CD 1E 38    call $381E
7375: DD 36 09 40 ld   (ix+$09),$40
7379: 21 39 8F    ld   hl,$8F39
737C: 34          inc  (hl)
737D: 3A 3D 8F    ld   a,($8F3D)
7380: BE          cp   (hl)
7381: C0          ret  nz
7382: 7E          ld   a,(hl)
7383: 11 30 06    ld   de,$0630
7386: 83          add  a,e
7387: 5F          ld   e,a
7388: FF          rst  $38
7389: C9          ret
738A: 11 03 74    ld   de,$7403
738D: CD 1E 38    call $381E
7390: DD 36 09 38 ld   (ix+$09),$38
7394: C9          ret
7395: CD 06 40    call $4006
7398: DD 7D       ld   a,ixl
739A: CB 5F       bit  3,a
739C: 20 18       jr   nz,$73B6
739E: DD 7E 03    ld   a,(ix+$03)
73A1: DD 86 09    add  a,(ix+$09)
73A4: DD 77 03    ld   (ix+$03),a
73A7: 30 03       jr   nc,$73AC
73A9: DD 34 04    inc  (ix+$04)
73AC: DD 7E 04    ld   a,(ix+$04)
73AF: FE 1D       cp   $1D
73B1: D8          ret  c
73B2: DD 34 02    inc  (ix+$02)
73B5: C9          ret
73B6: DD 7E 03    ld   a,(ix+$03)
73B9: DD 96 09    sub  (ix+$09)
73BC: DD 77 03    ld   (ix+$03),a
73BF: 30 03       jr   nc,$73C4
73C1: DD 35 04    dec  (ix+$04)
73C4: DD 7E 04    ld   a,(ix+$04)
73C7: FE 04       cp   $04
73C9: D0          ret  nc
73CA: DD 34 02    inc  (ix+$02)
73CD: C9          ret
73CE: DD 7D       ld   a,ixl
73D0: 6F          ld   l,a
73D1: DD 7C       ld   a,ixh
73D3: 67          ld   h,a
73D4: AF          xor  a
73D5: 06 18       ld   b,$18
73D7: D7          rst  $10
73D8: 21 3C 8F    ld   hl,$8F3C
73DB: 35          dec  (hl)
73DC: C0          ret  nz
73DD: 3E 30       ld   a,$30
73DF: 32 36 8F    ld   ($8F36),a
73E2: C9          ret
73E3: 21 36 8F    ld   hl,$8F36
73E6: 7E          ld   a,(hl)
73E7: A7          and  a
73E8: 28 02       jr   z,$73EC
73EA: 35          dec  (hl)
73EB: C9          ret
73EC: 3A 3D 8F    ld   a,($8F3D)
73EF: A7          and  a
73F0: 28 06       jr   z,$73F8
73F2: 11 B0 06    ld   de,$06B0
73F5: 83          add  a,e
73F6: 5F          ld   e,a
73F7: FF          rst  $38
73F8: 3E 18       ld   a,$18
73FA: 32 36 8F    ld   ($8F36),a
73FD: AF          xor  a
73FE: 21 3A 8F    ld   hl,$8F3A
7401: 77          ld   (hl),a
7402: C9          ret
7403: 40          ld   b,b
7404: 21 10 FF    ld   hl,$FF10
7407: 03          inc  bc
7408: 74          ld   (hl),h
7409: 0D          dec  c
740A: 40          ld   b,b
740B: 0D          dec  c
740C: 29          add  hl,hl
740D: 0D          dec  c
740E: 40          ld   b,b
740F: 0B          dec  bc
7410: 21 09 40    ld   hl,$4009
7413: 15          dec  d
7414: 29          add  hl,hl
7415: 09          add  hl,bc
7416: 40          ld   b,b
7417: 13          inc  de
7418: 21 13 40    ld   hl,$4013
741B: 0C          inc  c
741C: 29          add  hl,hl
741D: 13          inc  de
741E: 40          ld   b,b
741F: 0A          ld   a,(bc)
7420: 21 21 36    ld   hl,$3621
7423: 8F          adc  a,a
7424: 7E          ld   a,(hl)
7425: A7          and  a
7426: 28 02       jr   z,$742A
7428: 35          dec  (hl)
7429: C9          ret
742A: 21 37 8F    ld   hl,$8F37
742D: 06 09       ld   b,$09
742F: D7          rst  $10
7430: 21 E0 8A    ld   hl,$8AE0
7433: 06 48       ld   b,$48
7435: D7          rst  $10
7436: 32 0A 88    ld   (in_game_sub_state_880A),a
7439: 32 5B 8F    ld   ($8F5B),a
743C: 3E 07       ld   a,$07
743E: 32 51 8E    ld   (title_sub_state_8E51),a
7441: C9          ret

pigs_arrive_during_title_7442:
7442: 3A 21 89    ld   a,($8921)
7445: E6 03       and  $03
7447: EF          rst  $28
jump_table_7448:
	.word	$744E
	.word	$7517
	.word	$755D

744E: AF          xor  a
744F: 32 B7 88    ld   ($88B7),a
7452: 11 F0 4A    ld   de,$4AF0
7455: 21 E1 43    ld   hl,$43E1
7458: 22 BA 88    ld   ($88BA),hl
745B: ED 53 45 8F ld   ($8F45),de
745F: 21 42 84    ld   hl,$8442
7462: 22 B8 88    ld   ($88B8),hl
7465: 21 42 80    ld   hl,$8042
7468: 22 43 8F    ld   ($8F43),hl
746B: 21 21 89    ld   hl,$8921
746E: 34          inc  (hl)
746F: 21 9A 74    ld   hl,$749A
7472: 11 00 00    ld   de,$0000
7475: 06 08       ld   b,$08
7477: 1A          ld   a,(de)
7478: BE          cp   (hl)
7479: C2 86 74    jp   nz,$7486
747C: 23          inc  hl
747D: 13          inc  de
747E: 10 F7       djnz $7477
7480: DD 21 92 00 ld   ix,bootup_0092
7484: 06 74       ld   b,$74
7486: DD 7E 00    ld   a,(ix+$00)
7489: BE          cp   (hl)
748A: C2 DF 67    jp   nz,$67DF
748D: 23          inc  hl
748E: DD 2C       inc  ixl
7490: DD 7D       ld   a,ixl
7492: A7          and  a
7493: 20 02       jr   nz,$7497
7495: DD 24       inc  ixh
7497: 10 ED       djnz $7486
7499: C9          ret
749A: AF          xor  a
749B: 32 80 A1    ld   (mainlatch_a180),a
749E: C3 92 00    jp   bootup_0092

; unreachable?
74A1: FF          rst  $38
74A2: 32 00 A0    ld   (watchdog_a000),a
74A5: 31 00 90    ld   sp,ram_top_9000
74A8: 32 00 88    ld   ($8800),a
74AB: 06 08       ld   b,$08
74AD: C5          push bc
74AE: 21 00 00    ld   hl,$0000
74B1: DD 21 79 00 ld   ix,$0079
74B5: 11 00 00    ld   de,$0000
74B8: 4A          ld   c,d
74B9: 7B          ld   a,e
74BA: 86          add  a,(hl)
74BB: 5F          ld   e,a
74BC: 30 04       jr   nc,$74C2
74BE: 14          inc  d
74BF: 20 01       jr   nz,$74C2
74C1: 0C          inc  c
74C2: 2C          inc  l
74C3: 20 F4       jr   nz,$74B9
74C5: 24          inc  h
74C6: 7C          ld   a,h
74C7: E6 0F       and  $0F
74C9: 20 EE       jr   nz,$74B9
74CB: 32 00 A0    ld   (watchdog_a000),a
74CE: 7B          ld   a,e
74CF: DD BE 00    cp   (ix+$00)
74D2: 20 0C       jr   nz,$74E0
74D4: 7A          ld   a,d
74D5: DD BE 01    cp   (ix+$01)
74D8: 20 06       jr   nz,$74E0
74DA: 79          ld   a,c
74DB: DD BE 02    cp   (ix+$02)
74DE: 28 02       jr   z,$74E2
74E0: 18 06       jr   $74E8
74E2: E5          push hl
74E3: 21 FF 8F    ld   hl,$8FFF
74E6: 34          inc  (hl)
74E7: E1          pop  hl
74E8: DD 23       inc  ix
74EA: DD 23       inc  ix
74EC: DD 23       inc  ix
74EE: 10 C5       djnz $74B5
74F0: 3A E0 A0    ld   a,(dsw0_a0e0)
74F3: E6 0F       and  $0F
74F5: 21 69 00    ld   hl,$0069
74F8: E7          rst  $20
74F9: 7E          ld   a,(hl)
74FA: B7          or   a
74FB: 18 16       jr   $7513	; ???? complete bogus

74FD: 57          ld   d,a
74FE: E6 0F       and  $0F
7500: 5F          ld   e,a
7501: AA          xor  d
7502: 0F          rrca
7503: 0F          rrca
7504: 0F          rrca
7505: 0F          rrca
7506: CD FA 00    call $00FA
7509: 7B          ld   a,e
750A: FE 0A       cp   $0A
750C: 38 02       jr   c,$7510
750E: C6 07       add  a,$07
7510: 77          ld   (hl),a
7511: 09          add  hl,bc
7512: C9          ret
32 00 A0 CD
7517: CD 81 43    call $4381       
751A: 21 B7 88    ld   hl,$88B7
751D: 34          inc  (hl)
751E: 7E          ld   a,(hl)
751F: FE 1C       cp   $1C
7521: C0          ret  nz
7522: 21 20 89    ld   hl,$8920
7525: 7E          ld   a,(hl)
7526: 34          inc  (hl)
7527: A7          and  a
7528: 32 B7 88    ld   ($88B7),a
752B: C8          ret  z
752C: 21 BC 82    ld   hl,$82BC
752F: 11 00 00    ld   de,$0000
7532: 0E 02       ld   c,$02
7534: 06 0E       ld   b,$0E
7536: 7E          ld   a,(hl)
7537: 83          add  a,e
7538: 5F          ld   e,a
7539: 30 01       jr   nc,$753C
753B: 14          inc  d
753C: 7D          ld   a,l
753D: D6 20       sub  $20
753F: 6F          ld   l,a
7540: 30 01       jr   nc,$7543
7542: 25          dec  h
7543: 10 F1       djnz $7536
7545: 0D          dec  c
7546: 21 BC 86    ld   hl,$86BC
7549: 20 E9       jr   nz,$7534
754B: 7B          ld   a,e
754C: FE 4F       cp   $4F
754E: C2 E1 43    jp   nz,$43E1
7551: 15          dec  d
7552: C2 2C 46    jp   nz,$462C
7555: 21 21 89    ld   hl,$8921
7558: 34          inc  (hl)
7559: CD B2 0F    call $0FB2
755C: C9          ret

755D: CD 6D 75    call $756D
7560: CD 21 76    call $7621
7563: CD 13 6B    call $6B13
7566: CD AF 76    call $76AF
7569: CD EF 02    call update_sprite_shadows_02EF
756C: C9          ret
756D: 21 29 89    ld   hl,$8929
7570: 7E          ld   a,(hl)
7571: A7          and  a
7572: 28 02       jr   z,$7576
7574: 35          dec  (hl)
7575: C9          ret
7576: 3A 2D 89    ld   a,($892D)
7579: FE 08       cp   $08
757B: C8          ret  z
757C: DD 21 E0 8A ld   ix,$8AE0
7580: FD 21 70 8B ld   iy,$8B70
7584: 11 18 00    ld   de,$0018
7587: 06 08       ld   b,$08
7589: D9          exx
758A: CD 95 75    call $7595
758D: D9          exx
758E: DD 19       add  ix,de
7590: FD 19       add  iy,de
7592: 10 F5       djnz $7589
7594: C9          ret
7595: DD 7E 00    ld   a,(ix+$00)
7598: DD B6 01    or   (ix+$01)
759B: 0F          rrca
759C: D8          ret  c
759D: DD 36 00 01 ld   (ix+$00),$01
75A1: AF          xor  a
75A2: DD 77 03    ld   (ix+$03),a
75A5: DD 77 05    ld   (ix+$05),a
75A8: DD 36 04 15 ld   (ix+$04),$15
75AC: DD 36 06 1E ld   (ix+$06),$1E
75B0: 3A 2D 89    ld   a,($892D)
75B3: FE 02       cp   $02
75B5: 38 31       jr   c,$75E8
75B7: AF          xor  a
75B8: FD 77 03    ld   (iy+$03),a
75BB: FD 77 05    ld   (iy+$05),a
75BE: FD 36 04 14 ld   (iy+$04),$14
75C2: FD 36 06 1E ld   (iy+$06),$1E
75C6: 21 18 76    ld   hl,$7618
75C9: 3A 22 89    ld   a,($8922)
75CC: E7          rst  $20
75CD: FD 77 17    ld   (iy+$17),a
75D0: 21 57 56    ld   hl,$5657
75D3: CD 45 0C    call $0C45
75D6: FD 73 0C    ld   (iy+$0c),e
75D9: FD 72 0D    ld   (iy+$0d),d
75DC: FD 36 09 18 ld   (iy+$09),$18
75E0: FD 36 00 01 ld   (iy+$00),$01
75E4: 21 22 89    ld   hl,$8922
75E7: 34          inc  (hl)
75E8: DD 36 09 18 ld   (ix+$09),$18
75EC: 3A 2D 89    ld   a,($892D)
75EF: FE 02       cp   $02
75F1: 38 02       jr   c,$75F5
75F3: 3E 02       ld   a,$02
75F5: 21 1E 76    ld   hl,$761E
75F8: E7          rst  $20
75F9: 32 29 89    ld   ($8929),a
75FC: 21 2D 89    ld   hl,$892D
75FF: 34          inc  (hl)
7600: 7E          ld   a,(hl)
7601: FE 03       cp   $03
7603: 11 DD 76    ld   de,$76DD
7606: 30 03       jr   nc,$760B
7608: 11 D4 76    ld   de,$76D4
760B: CD 1E 38    call $381E
760E: 3A 2D 89    ld   a,($892D)
7611: 87          add  a,a
7612: 87          add  a,a
7613: FD 77 11    ld   (iy+$11),a
7616: F1          pop  af
7617: C9          ret

761C: 01 03 16    ld   bc,$1603
761F: 28 12       jr   z,$7633
7621: 06 0E       ld   b,$0E
7623: 18 02       jr   $7627
7625: 06 08       ld   b,$08
7627: DD 21 E0 8A ld   ix,$8AE0
762B: 11 18 00    ld   de,$0018
762E: D9          exx
762F: CD 38 76    call $7638
7632: D9          exx
7633: DD 19       add  ix,de
7635: 10 F7       djnz $762E
7637: C9          ret
7638: DD 7E 02    ld   a,(ix+$02)
763B: E6 03       and  $03
763D: EF          rst  $28
jump_table_763E:
	.word	$7644
	.word	$7675
	.word	$76A6

7644: DD 7E 00    ld   a,(ix+$00)
7647: A7          and  a
7648: C8          ret  z
7649: CD 06 40    call $4006
764C: DD 7E 05    ld   a,(ix+$05)
764F: DD 96 09    sub  (ix+$09)
7652: 30 03       jr   nc,$7657
7654: DD 35 06    dec  (ix+$06)
7657: DD 77 05    ld   (ix+$05),a
765A: DD 7E 06    ld   a,(ix+$06)
765D: FE 06       cp   $06
765F: D0          ret  nc
7660: 3E 20       ld   a,$20
7662: 32 2E 89    ld   ($892E),a
7665: 11 18 00    ld   de,$0018
7668: 06 0E       ld   b,$0E
766A: 3E 01       ld   a,$01
766C: DD 77 02    ld   (ix+$02),a
766F: DD 19       add  ix,de
7671: 10 F9       djnz $766C
7673: F1          pop  af
7674: C9          ret
7675: CD 06 40    call $4006
7678: 21 2E 89    ld   hl,$892E
767B: 7E          ld   a,(hl)
767C: A7          and  a
767D: 28 02       jr   z,$7681
767F: 35          dec  (hl)
7680: C9          ret
7681: 3E 02       ld   a,$02
7683: 21 E2 8A    ld   hl,$8AE2
7686: 11 18 00    ld   de,$0018
7689: 06 08       ld   b,$08
768B: 77          ld   (hl),a
768C: 19          add  hl,de
768D: 10 FC       djnz $768B
768F: AF          xor  a
7690: 21 A2 8B    ld   hl,$8BA2
7693: 11 18 00    ld   de,$0018
7696: 06 06       ld   b,$06
7698: 77          ld   (hl),a
7699: 19          add  hl,de
769A: 10 FC       djnz $7698
769C: 32 57 8D    ld   ($8D57),a
769F: 3E 08       ld   a,$08
76A1: 32 51 8E    ld   (title_sub_state_8E51),a
76A4: F1          pop  af
76A5: C9          ret
76A6: 3A 58 8D    ld   a,($8D58)
76A9: A7          and  a
76AA: C0          ret  nz
76AB: CD 06 40    call $4006
76AE: C9          ret
76AF: 21 2A 89    ld   hl,$892A
76B2: 7E          ld   a,(hl)
76B3: A7          and  a
76B4: 28 02       jr   z,$76B8
76B6: 35          dec  (hl)
76B7: C9          ret
76B8: 36 16       ld   (hl),$16
76BA: 23          inc  hl
76BB: 34          inc  (hl)
76BC: 7E          ld   a,(hl)
76BD: E6 01       and  $01
76BF: 11 E6 76    ld   de,$76E6
76C2: 20 03       jr   nz,$76C7
76C4: 11 E8 76    ld   de,$76E8
76C7: 21 71 84    ld   hl,$8471
76CA: 01 40 00    ld   bc,$0040
76CD: 1A          ld   a,(de)
76CE: 77          ld   (hl),a
76CF: 13          inc  de
76D0: 09          add  hl,bc
76D1: 1A          ld   a,(de)
76D2: 77          ld   (hl),a
76D3: C9          ret
76D4: 45          ld   b,l
76D5: 0D          dec  c
76D6: 08          ex   af,af'
76D7: 45          ld   b,l
76D8: 36 08       ld   (hl),$08
76DA: FF          rst  $38
76DB: D4 76 C0    call nc,$C076
76DE: 03          inc  bc
76DF: 08          ex   af,af'
76E0: C0          ret  nz
76E1: 09          add  hl,bc
76E2: 08          ex   af,af'
76E3: FF          rst  $38
76E4: DD          db   $dd
76E5: 76          halt
76E6: 3F          ccf
76E7: 46          ld   b,(hl)
76E8: 46          ld   b,(hl)
76E9: 3F          ccf
76EA: CD F4 76    call $76F4
76ED: CD 25 76    call $7625
76F0: CD EF 02    call update_sprite_shadows_02EF
76F3: C9          ret
76F4: DD 21 A0 8B ld   ix,$8BA0
76F8: 11 18 00    ld   de,$0018
76FB: 06 06       ld   b,$06
76FD: D9          exx
76FE: CD 07 77    call $7707
7701: D9          exx
7702: DD 19       add  ix,de
7704: 10 F7       djnz $76FD
7706: C9          ret
7707: DD 7E 00    ld   a,(ix+$00)
770A: DD B6 01    or   (ix+$01)
770D: 0F          rrca
770E: D0          ret  nc
770F: DD 7E 02    ld   a,(ix+$02)
7712: E6 03       and  $03
7714: EF          rst  $28
jump_table_7715:
	.word	$771D
	.word	$7740
	.word	$7790
	.word	$7881
771D: DD 35 11    dec  (ix+$11)
7720: C0          ret  nz
7721: 21 57 8D    ld   hl,$8D57
7724: 7E          ld   a,(hl)
7725: 4F          ld   c,a
7726: 34          inc  (hl)
7727: DD 77 13    ld   (ix+$13),a
772A: 79          ld   a,c
772B: 21 69 78    ld   hl,$7869
772E: 87          add  a,a
772F: E7          rst  $20
7730: DD 77 15    ld   (ix+$15),a
7733: 23          inc  hl
7734: 7E          ld   a,(hl)
7735: DD 77 16    ld   (ix+$16),a
7738: 3E EC       ld   a,$EC
773A: DD 77 0A    ld   (ix+$0a),a
773D: DD 34 02    inc  (ix+$02)
7740: CD 06 40    call $4006
7743: DD 7E 0A    ld   a,(ix+$0a)
7746: ED 44       neg
7748: 47          ld   b,a
7749: DD 7E 03    ld   a,(ix+$03)
774C: B8          cp   b
774D: 30 03       jr   nc,$7752
774F: DD 35 04    dec  (ix+$04)
7752: DD 86 0A    add  a,(ix+$0a)
7755: DD 77 03    ld   (ix+$03),a
7758: 47          ld   b,a
7759: DD 7E 04    ld   a,(ix+$04)
775C: E6 1F       and  $1F
775E: FE 09       cp   $09
7760: D0          ret  nc
7761: DD 34 02    inc  (ix+$02)
7764: DD 36 11 18 ld   (ix+$11),$18
7768: CD F1 0E    call $0EF1
776B: DD 7E 17    ld   a,(ix+$17)
776E: 21 B1 41    ld   hl,$41B1
7771: CD 45 0C    call $0C45
7774: CD 1E 38    call $381E
7777: 11 B3 0B    ld   de,$0BB3
777A: 06 05       ld   b,$05
777C: AF          xor  a
777D: 6F          ld   l,a
777E: 67          ld   h,a
777F: 1A          ld   a,(de)
7780: E6 1F       and  $1F
7782: E7          rst  $20
7783: 13          inc  de
7784: 10 F9       djnz $777F
7786: 7D          ld   a,l
7787: 84          add  a,h
7788: C6 C7       add  a,$C7
778A: C8          ret  z
778B: 21 E9 89    ld   hl,$89E9
778E: 34          inc  (hl)
778F: C9          ret
7790: CD 06 40    call $4006
7793: DD 35 11    dec  (ix+$11)
7796: C0          ret  nz
7797: DD 7E 13    ld   a,(ix+$13)
779A: 21 21 78    ld   hl,$7821
779D: CD 45 0C    call $0C45
77A0: DD 6E 15    ld   l,(ix+$15)
77A3: DD 66 16    ld   h,(ix+$16)
77A6: CD 0F 78    call $780F
77A9: 21 41 78    ld   hl,$7841
77AC: DD 7E 13    ld   a,(ix+$13)
77AF: CD 45 0C    call $0C45
77B2: DD 6E 15    ld   l,(ix+$15)
77B5: DD 66 16    ld   h,(ix+$16)
77B8: 01 00 FC    ld   bc,$FC00
77BB: 09          add  hl,bc
77BC: CD 0F 78    call $780F
77BF: 21 58 8D    ld   hl,$8D58
77C2: 7E          ld   a,(hl)
77C3: A7          and  a
77C4: 20 02       jr   nz,$77C8
77C6: 36 01       ld   (hl),$01
77C8: AF          xor  a
77C9: DD 77 00    ld   (ix+$00),a
77CC: DD 77 01    ld   (ix+$01),a
77CF: DD 77 02    ld   (ix+$02),a
77D2: DD 77 03    ld   (ix+$03),a
77D5: DD 77 04    ld   (ix+$04),a
77D8: DD 77 05    ld   (ix+$05),a
77DB: DD 77 06    ld   (ix+$06),a
77DE: DD 77 16    ld   (ix+$16),a
77E1: DD 7E 13    ld   a,(ix+$13)
77E4: FE 05       cp   $05
77E6: D8          ret  c
77E7: DD 36 01 01 ld   (ix+$01),$01
77EB: DD 36 02 03 ld   (ix+$02),$03
77EF: DD 36 11 80 ld   (ix+$11),$80
77F3: 21 BC 82    ld   hl,$82BC
77F6: 11 E0 FF    ld   de,$FFE0
77F9: 01 00 0A    ld   bc,$0A00
77FC: 7E          ld   a,(hl)
77FD: 19          add  hl,de
77FE: BE          cp   (hl)
77FF: 20 74       jr   nz,$7875
7801: 81          add  a,c
7802: 4F          ld   c,a
7803: 10 F7       djnz $77FC
7805: C6 83       add  a,$83
7807: 21 0E 78    ld   hl,$780E
780A: BE          cp   (hl)
780B: C2 34 23    jp   nz,$2334
780E: C9          ret
780F: 01 E0 FF    ld   bc,$FFE0
7812: 1A          ld   a,(de)
7813: 77          ld   (hl),a
7814: 13          inc  de
7815: 23          inc  hl
7816: 1A          ld   a,(de)
7817: 77          ld   (hl),a
7818: 13          inc  de
7819: 09          add  hl,bc
781A: 1A          ld   a,(de)
781B: 77          ld   (hl),a
781C: 2B          dec  hl
781D: 13          inc  de
781E: 1A          ld   a,(de)
781F: 77          ld   (hl),a
7820: C9          ret


7881: DD 35 11    dec  (ix+$11)
7884: C0          ret  nz
7885: FD 21 00 79 ld   iy,$7900
7889: 21 79 07    ld   hl,$0779
788C: 11 00 00    ld   de,$0000
788F: 0E 09       ld   c,$09
7891: 06 20       ld   b,$20
7893: 7E          ld   a,(hl)
7894: 83          add  a,e
7895: 5F          ld   e,a
7896: 30 01       jr   nc,$7899
7898: 14          inc  d
7899: 23          inc  hl
789A: 10 F7       djnz $7893
789C: FD 7E 00    ld   a,(iy+$00)
789F: BB          cp   e
78A0: C2 0E 78    jp   nz,$780E
78A3: FD 7E 01    ld   a,(iy+$01)
78A6: BA          cp   d
78A7: C2 0E 78    jp   nz,$780E
78AA: FD 7D       ld   a,iyl
78AC: C6 02       add  a,$02
78AE: 30 02       jr   nc,$78B2
78B0: FD 24       inc  iyh
78B2: FD 6F       ld   iyl,a
78B4: 0D          dec  c
78B5: 20 DA       jr   nz,$7891
78B7: 3E 02       ld   a,$02
78B9: 32 51 8E    ld   (title_sub_state_8E51),a
78BC: FD 21 48 85 ld   iy,$8548
78C0: 21 00 00    ld   hl,$0000
78C3: 11 20 00    ld   de,$0020
78C6: 0E 04       ld   c,$04
78C8: 06 0C       ld   b,$0C
78CA: FD 7E 00    ld   a,(iy+$00)
78CD: 85          add  a,l
78CE: 30 01       jr   nc,$78D1
78D0: 24          inc  h
78D1: 6F          ld   l,a
78D2: FD 19       add  iy,de
78D4: 10 F4       djnz $78CA
78D6: CB 41       bit  0,c
78D8: 20 08       jr   nz,$78E2
78DA: 11 E0 FF    ld   de,$FFE0
78DD: FD 23       inc  iy
78DF: 0D          dec  c
78E0: 18 E6       jr   $78C8
78E2: 0D          dec  c
78E3: 28 07       jr   z,$78EC
78E5: 11 FF FB    ld   de,$FBFF
78E8: FD 19       add  iy,de
78EA: 18 F6       jr   $78E2
78EC: 7D          ld   a,l
78ED: 84          add  a,h
78EE: C6 A6       add  a,$A6
78F0: C2 20 03    jp   nz,$0320
78F3: 21 E0 8A    ld   hl,$8AE0
78F6: AF          xor  a
78F7: 47          ld   b,a
78F8: D7          rst  $10
78F9: 06 37       ld   b,$37
78FB: D7          rst  $10
78FC: CD C8 77    call $77C8
78FF: C9          ret
7900: B8          cp   b
7901: 02          ld   (bc),a
7902: 94          sub  h
7903: 03          inc  bc
7904: 21 05 EB    ld   hl,$EB05 bogus & useless
7907: 05          dec  b
7908: 2A 09 40    ld   hl,($4009)
790B: 0A          ld   a,(bc)
790C: 41          ld   b,c
790D: 0C          inc  c
790E: A4          and  h
790F: 0C          inc  c
7910: DB 0E       in   a,($0E)
7912: 3A 06 88    ld   a,($8806)
7915: A7          and  a
7916: C8          ret  z
7917: 3A 0D 88    ld   a,($880D)
791A: A7          and  a
791B: 11 E1 89    ld   de,$89E1
791E: 21 30 8A    ld   hl,$8A30
7921: 28 04       jr   z,$7927
7923: 2E 33       ld   l,$33
7925: 1E E2       ld   e,$E2
7927: 1A          ld   a,(de)
7928: A7          and  a
7929: C0          ret  nz
792A: 23          inc  hl
792B: 7E          ld   a,(hl)
792C: 2B          dec  hl
792D: CB 47       bit  0,a
792F: 06 3B       ld   b,$3B
7931: 28 01       jr   z,$7934
7933: 04          inc  b
7934: 7E          ld   a,(hl)
7935: B8          cp   b
7936: 28 02       jr   z,$793A
7938: 34          inc  (hl)
7939: C9          ret
793A: 36 00       ld   (hl),$00
793C: 23          inc  hl
793D: 34          inc  (hl)
793E: 7E          ld   a,(hl)
793F: 5F          ld   e,a
7940: E6 0F       and  $0F
7942: FE 0A       cp   $0A
7944: C0          ret  nz
7945: 7B          ld   a,e
7946: E6 F0       and  $F0
7948: C6 10       add  a,$10
794A: FE 60       cp   $60
794C: 77          ld   (hl),a
794D: C0          ret  nz
794E: 36 00       ld   (hl),$00
7950: 23          inc  hl
7951: 34          inc  (hl)
7952: 7E          ld   a,(hl)
7953: 5F          ld   e,a
7954: E6 0F       and  $0F
7956: FE 0A       cp   $0A
7958: C0          ret  nz
7959: 7B          ld   a,e
795A: E6 F0       and  $F0
795C: C6 10       add  a,$10
795E: 77          ld   (hl),a
795F: C9          ret
7960: 11 09 06    ld   de,$0609
7963: FF          rst  $38
7964: DD 21 01 29 ld   ix,$2901
7968: 21 00 00    ld   hl,$0000
796B: 5D          ld   e,l
796C: 53          ld   d,e
796D: 06 5B       ld   b,$5B
796F: DD 7E 00    ld   a,(ix+$00)
7972: 83          add  a,e
7973: 5F          ld   e,a
7974: 30 01       jr   nc,$7977
7976: 14          inc  d
7977: 4F          ld   c,a
7978: DD 7D       ld   a,ixl
797A: E6 01       and  $01
797C: 20 06       jr   nz,$7984
797E: 79          ld   a,c
797F: 85          add  a,l
7980: 6F          ld   l,a
7981: 30 01       jr   nc,$7984
7983: 24          inc  h
7984: DD 23       inc  ix
7986: 10 E7       djnz $796F
7988: 7B          ld   a,e
7989: DD BE 00    cp   (ix+$00)
798C: C2 0B 7A    jp   nz,$7A0B
798F: 7A          ld   a,d
7990: DD BE 01    cp   (ix+$01)
7993: C2 A0 0F    jp   nz,$0FA0
7996: 7D          ld   a,l
7997: DD BE 02    cp   (ix+$02)
799A: C2 88 13    jp   nz,$1388
799D: 7C          ld   a,h
799E: DD BE 03    cp   (ix+$03)
79A1: C2 70 17    jp   nz,$1770
79A4: 3A 0D 88    ld   a,($880D)
79A7: A7          and  a
79A8: DD 21 32 8A ld   ix,$8A32
79AC: 28 03       jr   z,$79B1
79AE: DD 2E 35    ld   ixl,$35
79B1: 21 2D 86    ld   hl,$862D
79B4: 11 E0 FF    ld   de,$FFE0
79B7: 06 02       ld   b,$02
79B9: DD 7E 00    ld   a,(ix+$00)
79BC: 4F          ld   c,a
79BD: E6 F0       and  $F0
79BF: 0F          rrca
79C0: 0F          rrca
79C1: 0F          rrca
79C2: 0F          rrca
79C3: 77          ld   (hl),a
79C4: 19          add  hl,de
79C5: 79          ld   a,c
79C6: E6 0F       and  $0F
79C8: 77          ld   (hl),a
79C9: 19          add  hl,de
79CA: CB 40       bit  0,b
79CC: 20 04       jr   nz,$79D2
79CE: 36 51       ld   (hl),$51
79D0: 19          add  hl,de
79D1: DD 2B       dec  ix
79D3: 10 E4       djnz $79B9
79D5: DD E5       push ix
79D7: E1          pop  hl
79D8: AF          xor  a
79D9: 06 03       ld   b,$03
79DB: D7          rst  $10
79DC: 21 E7 89    ld   hl,$89E7
79DF: 06 07       ld   b,$07
79E1: 7E          ld   a,(hl)
79E2: A7          and  a
79E3: 20 0A       jr   nz,$79EF
79E5: 23          inc  hl
79E6: 10 F9       djnz $79E1
79E8: C9          ret
79E9: 21 AC 68    ld   hl,$68AC
79EC: 11 00 00    ld   de,$0000
79EF: 7E          ld   a,(hl)
79F0: FE C9       cp   $C9
79F2: 28 08       jr   z,$79FC
79F4: 83          add  a,e
79F5: 30 01       jr   nc,$79F8
79F7: 14          inc  d
79F8: 5F          ld   e,a
79F9: 23          inc  hl
79FA: 18 F3       jr   $79EF
79FC: 21 0B 7A    ld   hl,$7A0B
79FF: 7B          ld   a,e
7A00: BE          cp   (hl)
7A01: C2 D0 07    jp   nz,$07D0
7A04: 7A          ld   a,d
7A05: 23          inc  hl
7A06: BE          cp   (hl)
7A07: C2 85 1A    jp   nz,$1A85
7A0A: C9          ret



7E6D: 3A 88 89    ld   a,($8988)
7E70: FE 04       cp   $04
7E72: D8          ret  c
7E73: 3A 5F 8A    ld   a,($8A5F)
7E76: A7          and  a
7E77: C0          ret  nz
7E78: 21 BE 64    ld   hl,$64BE
7E7B: 0E 00       ld   c,$00
7E7D: 59          ld   e,c
7E7E: 7E          ld   a,(hl)
7E7F: 2B          dec  hl
7E80: 81          add  a,c
7E81: 4F          ld   c,a
7E82: 30 01       jr   nc,$7E85
7E84: 1C          inc  e
7E85: 3E 34       ld   a,$34
7E87: BE          cp   (hl)
7E88: 20 F4       jr   nz,$7E7E
7E8A: 7B          ld   a,e
7E8B: 81          add  a,c
7E8C: E6 B0       and  $B0
7E8E: C8          ret  z
7E8F: 21 EF 89    ld   hl,$89EF
7E92: 34          inc  (hl)
7E93: C9          ret
7E94: 21 D6 7F    ld   hl,$7FD6
7E97: E5          push hl
7E98: 3A 2A 8E    ld   a,($8E2A)
7E9B: A7          and  a
7E9C: C0          ret  nz
7E9D: 3A FC 89    ld   a,($89FC)
7EA0: A7          and  a
7EA1: 20 05       jr   nz,$7EA8
7EA3: 3C          inc  a
7EA4: 32 2A 8E    ld   ($8E2A),a
7EA7: C9          ret
7EA8: 3A 26 8E    ld   a,($8E26)
7EAB: EF          rst  $28
jump_table_7EAC:
	.word	$7EB2      
	.word	$7F0E      
	.word	$7F5D      

7EB2: 21 65 85    ld   hl,$8565
7EB5: 22 27 8E    ld   ($8E27),hl
7EB8: 3E 03       ld   a,$03
7EBA: 32 25 8E    ld   ($8E25),a
7EBD: 3A FC 89    ld   a,($89FC)
7EC0: 21 A0 03    ld   hl,$03A0
7EC3: 22 2B 8E    ld   ($8E2B),hl
7EC6: DD 21 FD 8D ld   ix,$8DFD
7ECA: 47          ld   b,a
7ECB: 11 03 00    ld   de,$0003
7ECE: DD 19       add  ix,de
7ED0: 10 FC       djnz $7ECE
7ED2: DD 22 1F 8E ld   ($8E1F),ix
7ED6: 3A 0F 88    ld   a,($880F)
7ED9: A7          and  a
7EDA: 20 06       jr   nz,$7EE2
7EDC: 3A 0D 88    ld   a,($880D)
7EDF: A7          and  a
7EE0: 20 05       jr   nz,$7EE7
7EE2: 21 11 88    ld   hl,$8811
7EE5: 18 03       jr   $7EEA
7EE7: 21 12 88    ld   hl,$8812
7EEA: 22 21 8E    ld   ($8E21),hl
7EED: 3A FC 89    ld   a,($89FC)
7EF0: 47          ld   b,a
7EF1: ED 5B 27 8E ld   de,($8E27)
7EF5: 13          inc  de
7EF6: 13          inc  de
7EF7: 10 FC       djnz $7EF5
7EF9: ED 53 27 8E ld   ($8E27),de
7EFD: 3E 11       ld   a,$11
7EFF: 12          ld   (de),a
7F00: 32 23 8E    ld   ($8E23),a
7F03: 3E 01       ld   a,$01
7F05: 32 26 8E    ld   ($8E26),a
7F08: 3E 0C       ld   a,$0C
7F0A: 32 24 8E    ld   ($8E24),a
7F0D: C9          ret
7F0E: 2A 2B 8E    ld   hl,($8E2B)
7F11: 2B          dec  hl
7F12: 22 2B 8E    ld   ($8E2B),hl
7F15: 7C          ld   a,h
7F16: A7          and  a
7F17: 20 07       jr   nz,$7F20
7F19: 7D          ld   a,l
7F1A: A7          and  a
7F1B: 20 03       jr   nz,$7F20
7F1D: C3 A8 7F    jp   $7FA8
7F20: 2A 21 8E    ld   hl,($8E21)
7F23: CB 5E       bit  3,(hl)
7F25: 20 1B       jr   nz,$7F42
7F27: CB 56       bit  2,(hl)
7F29: 28 32       jr   z,$7F5D
7F2B: 21 24 8E    ld   hl,$8E24
7F2E: 35          dec  (hl)
7F2F: C0          ret  nz
7F30: 3E 0C       ld   a,$0C
7F32: 32 24 8E    ld   ($8E24),a
7F35: 21 23 8E    ld   hl,$8E23
7F38: 34          inc  (hl)
7F39: 7E          ld   a,(hl)
7F3A: FE 2D       cp   $2D
7F3C: 38 19       jr   c,$7F57
7F3E: 36 10       ld   (hl),$10
7F40: 18 15       jr   $7F57
7F42: 21 24 8E    ld   hl,$8E24
7F45: 35          dec  (hl)
7F46: C0          ret  nz
7F47: 3E 0C       ld   a,$0C
7F49: 32 24 8E    ld   ($8E24),a
7F4C: 21 23 8E    ld   hl,$8E23
7F4F: 35          dec  (hl)
7F50: 7E          ld   a,(hl)
7F51: FE 10       cp   $10
7F53: 30 02       jr   nc,$7F57
7F55: 36 2C       ld   (hl),$2C
7F57: ED 4B 27 8E ld   bc,($8E27)
7F5B: 7E          ld   a,(hl)
7F5C: 02          ld   (bc),a
7F5D: 2A 21 8E    ld   hl,($8E21)
7F60: 7E          ld   a,(hl)
7F61: 21 29 8E    ld   hl,$8E29
7F64: 07          rlca
7F65: 07          rlca
7F66: 07          rlca
7F67: 07          rlca
7F68: CB 16       rl   (hl)
7F6A: 7E          ld   a,(hl)
7F6B: E6 07       and  $07
7F6D: FE 01       cp   $01
7F6F: C0          ret  nz
7F70: 21 A0 03    ld   hl,$03A0
7F73: 22 2B 8E    ld   ($8E2B),hl
7F76: 3A 23 8E    ld   a,($8E23)
7F79: 2A 1F 8E    ld   hl,($8E1F)
7F7C: 77          ld   (hl),a
7F7D: 23          inc  hl
7F7E: 22 1F 8E    ld   ($8E1F),hl
7F81: 21 25 8E    ld   hl,$8E25
7F84: 35          dec  (hl)
7F85: 7E          ld   a,(hl)
7F86: A7          and  a
7F87: 32 25 8E    ld   ($8E25),a
7F8A: 28 1C       jr   z,$7FA8
7F8C: 3A 23 8E    ld   a,($8E23)
7F8F: 2A 27 8E    ld   hl,($8E27)
7F92: 77          ld   (hl),a
7F93: 01 E0 FF    ld   bc,$FFE0
7F96: 09          add  hl,bc
7F97: 22 27 8E    ld   ($8E27),hl
7F9A: 3E 11       ld   a,$11
7F9C: 77          ld   (hl),a
7F9D: 3E 01       ld   a,$01
7F9F: 32 26 8E    ld   ($8E26),a
7FA2: 3E 11       ld   a,$11
7FA4: 32 23 8E    ld   ($8E23),a
7FA7: C9          ret
7FA8: CD CF 0E    call $0ECF
7FAB: 3A 25 8E    ld   a,($8E25)
7FAE: A7          and  a
7FAF: 28 16       jr   z,$7FC7
7FB1: 47          ld   b,a
7FB2: 3E 10       ld   a,$10
7FB4: 2A 27 8E    ld   hl,($8E27)
7FB7: 11 E0 FF    ld   de,$FFE0
7FBA: DD 2A 1F 8E ld   ix,($8E1F)
7FBE: 77          ld   (hl),a
7FBF: DD 77 00    ld   (ix+$00),a
7FC2: 19          add  hl,de
7FC3: DD 23       inc  ix
7FC5: 10 F7       djnz $7FBE
7FC7: 21 08 88    ld   hl,$8808
7FCA: 36 80       ld   (hl),$80
7FCC: AF          xor  a
7FCD: 32 26 8E    ld   ($8E26),a
7FD0: 3E 01       ld   a,$01
7FD2: 32 2A 8E    ld   ($8E2A),a
7FD5: C9          ret
7FD6: 3A 02 88    ld   a,(nb_credits_8802)
7FD9: A7          and  a
7FDA: C8          ret  z
7FDB: 21 0E 88    ld   hl,$880E
7FDE: 7E          ld   a,(hl)
7FDF: A7          and  a
7FE0: 28 0D       jr   z,$7FEF
7FE2: 2B          dec  hl
7FE3: 7E          ld   a,(hl)
7FE4: A7          and  a
7FE5: 3A 08 89    ld   a,(nb_lives_8908)
7FE8: 21 48 89    ld   hl,$8948
7FEB: 20 02       jr   nz,$7FEF
7FED: 2E 88       ld   l,$88
7FEF: B6          or   (hl)
7FF0: A7          and  a
7FF1: C0          ret  nz
7FF2: 3A 10 88    ld   a,($8810)
7FF5: E6 18       and  $18
7FF7: A7          and  a
7FF8: C8          ret  z
7FF9: CD CF 0E    call $0ECF
7FFC: C3 78 0D    jp   $0D78

