pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
#include src/utils.lua
#include src/dynamic-obj.lua
#include src/swimmers.lua
#include src/collisions.lua
#include src/world.lua
#include src/particles.lua
#include src/player.lua
#include src/sub.lua
#include src/camera.lua
#include src/ui.lua
#include src/trophies.lua

function _init()
  class = { init = function()end; extend = function(self, proto) local meta = {}
    local proto = setmetatable(proto or {},{__index=self, __call=function(_,...) local o=setmetatable({},meta) return o,o:init(...) end})
    meta.__index = proto ; for k,v in pairs(proto.__ or {}) do meta['__'..k]=v end ; return proto end }
  setmetatable(class, { __call = class.extend })
  cartdata('super_duper_persist_data')
  cam_x=0
  cam_y=0
  reset_t=0
  up_c=7
  down_c=7
  i_trophies()

  trophy_spr_map={
    brute_force=23,
    for_my_aquarium=27,
    for_my_wall=11,
    and_stay_dead=22,
    no_sushi_tonight=20,
    catch_and_release=16,
    super_wrangler=21,
    repair_man=10,
    the_claaaw=9,
    one_small_step=1,
    you_raise_me_up=24,
    crab_n_go=18,
    super_surfer=25,
    fresh_air=26,
  }
end

function _update()
  -- go back
  if (btnp(❎)) then
    load('sdd.p8')
  end

  -- hold down  z to reset trophies
  if (btn(🅾️)) then
    reset_t+=1
    if (reset_t>128) then
      reset_t=0
      for i=0,63 do
        dset(i, 0)
        extcmd('reset')
      end
    end
  else
    reset_t=0
  end

  -- scroll through trophies
  if (btn(⬆️) and cam_y>0) then
    cam_y-=2
    up_c=9
  elseif (btn(⬇️) and cam_y<#all_trophies+60) then
    cam_y+=2
    down_c=9
  else
    up_c=7
    down_c=7
  end
  camera(cam_x, cam_y)
end

function _draw()
  cls(0)

  -- list all trophies
  for i=1, #all_trophies do
    local trophy = all_trophies[i]
    local x = 19
    local y = (12 * i)+10
    local c = 6
    local sprite = 7
    local s = ""
    local idx = indexof(current_trophies, trophy)
    local is_unlocked = idx and idx > 0

    -- check if trophy is unlocked
    sprite = trophy_spr_map[trophy]

    if (is_unlocked) then
      c = 9
      -- convert to human readable
      local t = split(trophy, '_')
      for i=1, #t do
        s = s..t[i].." "
      end
    else
      s = "?????"
    end
    -- draw trophy list
    print(s, x, y+i, c)
    circfill(x-10, y+i+1, 7, 1)
    rect(x-14, y+i-5, x+128, y+i+8, 1)
    circfill(x-10, y+i+1, 7, 1)
    spr(sprite, x - 14, y+i-2, 1,1)
  end

  -- draw scroll bar
  rectfill(cam_x+129-12, cam_y, cam_x+127, cam_y+128, 5)
  local scroll_h = 59 / (#all_trophies+60)
  local scroll_y = cam_y * scroll_h
  rectfill(cam_x+129-11, cam_y+scroll_y+60, cam_x+126, cam_y+scroll_y+scroll_h+22, 6)


  rectfill(cam_x-2, cam_y, cam_x+128, cam_y+12, 1)  -- draw header
  spr(7, cam_x+6, cam_y+2, 1,1)
  line(cam_x,cam_y+12,cam_x+128,cam_y+12, 7)
  print("sUPER dUPER tROPHIES", cam_x+18, cam_y+3, 9)


  -- draw reset warning bar
  if (reset_t>0) then
    rectfill(cam_x-2, cam_y, cam_x+128, cam_y+12, 0)
    print('resetting trophies...', cam_x+22, cam_y+4, 8)
    line(cam_x,cam_y+12,cam_x+reset_t,cam_y+12, 8)
  end

  -- draw back
  print("❎ back", cam_x+86, cam_y+120, 6)
  print("⬆️", cam_x+119, cam_y+15, up_c)
  print("⬇️", cam_x+119, cam_y+121, down_c)
end
__gfx__
00000000000aa0000009a0000000000099956999000000000000000009f9faa0000000000000b000666700000000500000000000000000000000666666660000
0000000000999700009a9a0000000000912121290005650000000000899f9aa80000000000bbbbb060670000024444400000000000000000066d6d6d6d6d6660
007007000a9ff9a009a9afa0a4a44a4a92121219005616500007067089f9faa8000000000b7b7b7b0076000002464446000000000000000066d7d7d7d7d7d766
000770000a9ff9a09a9af9fa94944949912121290600600600066667889f9a88000000000bbbbbbb066670000ccccc660000000000000000667d7d7d7d7d7d66
0007700000999900a9af9f9f0555a5500555555005000005000d0dd08889a8880000000000ccccc000066700cccccc66000000000000000066d7d7d7d7d7d766
00700700077447700af9f9f0a445644aa445644a05000005000000008889a888bbbbb000bb11111b000066600266644600000000000000000676767676767660
000000000d7777d0009f9f0094444449944444490d00000d000000008889a8883333333f00ccccc0000006660244442000000676676000000667676767676760
00000000006006000009f0009444444994444449000000000000000008999a803333300001111111000000660002200000067767767760000066767676767600
0000006600777700000000000000000000777700044444907000000700056000000050000000f00000000aaa0000000000677677776776000006666666666000
000006660767777000000000000000000783f3704900004907000070005006000000d000000ffff0700a0aaa0000000006776777677677600000666666660000
6666666676777777000000000008e0007789bf77049000040077770000500600000060000000ff00670000aa0006000667767767677767760077eeeddeee7700
66616666d76777770070700000888e005777777500444444005757000f9999a006565650077099000000a0000ccccc66677676776767677667eeeeeeeeeeee76
07766e667d7777770080800000887e0015155555000004400077770009f999a060999906cc70f0f0000000a0cccccc66d67d76d767d76d7dd77777777777777d
00066666d76777678888888800878e005151555500044400070770700f9999a0509ff905c000888800000000006660060dd6d6d6d6d6d6d00dd6d6d6d6d6d6d0
0066ffff0d7676700888888000888e0015155555004400007007700709f999a00d9999d0cc880000777a7a7a0000000000dd6d6d6d6d6d0000dd6d6d6d6d6d00
0000000000d7d7008080080800888e000151555004400000000000000f9999a067944976cccccccccccccccc000000000000dddddddd00000000dddddddd0000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000006600000000000000660000000000000066000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000066600000000000006660000000000000666000000000000000000000000000000000000000000000000000000000000000000000000
00000000600000666666666660000600666666666000006666666666600006000000000000000000000000000000000000000000000000000000000000000000
00000000666006606661666666600600666166666660066066616666666006000000000000000000000000000000000000000000000000000000000000000000
000000006666666006666e666666660006666e666666666006666e66666666000000000000000000000000000000000000000000000000000000000000000000
00000000666666000666666666666600066666666666660006666666666666000000000000000000000000000000000000000000000000000000000000000000
00000000ff0006600066ffffff000600006fffffff000660006fffffff0006000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000004880000048800000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000044480000444800000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000600600097970900979090000200000002000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000ccccc609797979997979790004980000044900000000000007070000000000000000000000000000000000000000000000000000000000000000000
00000000cccccc609797979997979790004980000044900000000000008080000000000000000000000000000000000000000000000000000000000000000000
00000000006660600097970900979090004400000044000000000000888888880000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000400000000400000000000088888800000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000004200000004000000000000800880080000000000000000000000000000000000000000000000000000000000000000
00000000000000060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000060000050000006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000005000050000050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000500155500500070000000777000000007777077000077000000000000000000000000000000000000000000000000000000000000000000000000
00000000000051551555000077777777777777777777777777777777000000000000000000000000000000000000000000000000000000000000000000000000
00000000000015155565000071717777717171777771717177777771000000000000000000000000000000000000000000000000000000000000000000000000
00000000000151555556500017171717171717171717171717171717000000000000000000000000000000000000000000000000000000000000000000000000
00000000000515155565600011111171711111711171111111117111000000000000000000000000000000000000000000000000000000000000000000000000
00000000655151555556555600545440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000005151555656000f0054540000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000005151515600004f045404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000015151565000044000004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000005005156005000004f9f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000050000000000500044449f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000005000000000000500545449f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000004545449000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
61616161616161616161f3616100616161616161616161616161616133616161616161f361616161616161616361616161616161616100a28383616161616161
61616161616161616161616161616161616161616161616161616161616161614242424242424242424242424242424242424242424242424242424242424242
616161616161616161616161d200c261616161d27171007100716161336161616161616161616161616161616361616161616161616100000000616161616161
61616161616161616161616161616161616161616161616161616161616161614242424242424242424242424242424242424242424242424242424242424242
616161f3616161616161616100000063730200000200000000737163336161616161616161616161616161616361616161616161616100000000f36161616161
61616161616161616161616161616161616161616161616161616161616161614242424242424242424242424242424242424242424242424242424242424242
6161616161616161616161610000003141414141510000b0003141414161616161c2616161616161d2616161636161616161616161d200000000c26161616161
61616161616161616161616161f36161616161616161616161616161616161614242424242424242424242424242424242424242424242424242424242424242
61616161616161616161616131313161616161616141414141616161616171616161616161616161616161616361616161616161610000000000c26161616161
616161616161616161616161616161616161616161616161616161616100717171717100c2424242424242424242424242424242424242424242424242424242
61616161616161616161616161616161c26161d2616161616161d271717173c26161616161616161616161d2636161f361616161d2000000000000c261616161
616161616161616161616161616161616161616161616161616171007100000000000000000000c2424242424242424242424242424242424242424242424242
61616161d20000000000000000000000000000000000000000000000000063007300000000730000000000006361616161d200000000000000000000007171c2
d200717100c261616161616161616161616161616161616161710000000000000000000000000000c24242424242424242424242424242424242424242424242
6161616113b331414141414141414141414141414141414141414141414141414141414141414141414141414161616161000000000000000000000000000000
0000000000717171717171616161616161616161616161617100000000000000000000000000000000c242424242424242424242424242424242424242424242
61616161414161616161616161616161616161616161616161616161616161616161616161616161616161616161616161000000020000000000000000000000
000200000000000000000071716161616161f361616161716300000000000000000000000000000000a1c2424242424242424242424242424242424242424242
61616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161000000000000006312000000000000
00000000000000000000000000c261616161616161616163b3630063000000000000000000000000a1b200424242f34242424242424242424242424242424242
6161616161616161616161616161616161616161616161616161616161f36161616161616161c2616161616161616161d2000000000000003151000000000000
00000000000000000000000000006161616161616161f341414151510000000000000000000000a1b2000000c242424242424242424242424242424242424242
616161616161616161616161616161616161616161617171616161616161616171717171717162c2616161616161d2d20000000000000000c2d2000000000000
000000000000000000000000000071717171717161616161616161d200000000000000000000a1b2000000a1b200c24242424242424242424242424242424242
61616161616161616161616161616161616161616171000071616161616161610000000000003362626262626271000000000000000000000000000000000200
000000000000000000000000000000000000000071007162626262000000000000000200000083b10000a1b20000333342424242424242424242424242424242
616161616161f3616161616161616171717171716100730000716161616161710000000000003333333333333300000000000000000000000000000000000000
00000000000000000000000000000000000000000000003333333300000000000000030000a1b2a2b1a1b2000000333342424242424242424242424242424242
61616161616161616161616161617100000000007173630000007171717171000000000000003333333333333300000000000000000000000000000000000000
000000000000005300000000000000530000630000000033333333000000000053000300a1b2000083b200000000333342424242424242424242424242424242
61616161616161616161616161f30302000000000063630000000000000000000000000000003141414141415100000000000000000200000000000000000000
00001200b0000072000000000000007200736300000001333333334300b00053725303a1b20000a1b26300000000333142424242424242424242424242424242
6161616161616161616161616161030300b000007363637300000065000000000000314141416161f36161616151000000000000630300000000000000000000
0000314141414151000000000001433141414141414141414141414141414141414141415100a1b2636300b33141414242424242424242424242424242424242
61616161616161616161616161614141414141414141414141414151000000000031616161616161616171716161510000000000630300000000008292000000
0000616161616161630000000031416161616161616161616161616161616161424242f342414141414141414142424242424242424242424242424242424242
6161616161616161616161616161616161616161616161616161617100000000316161616161616171710000c261615100000000630363000000a18383b10000
006361617171616163000000314161616161616161616161616161616161616142424242f3424242424242424242424242424242424242424242424242424242
616161616161616161616161616161616161616161616161616171000000000061616161616161616300000000616161511222006303630000a183838383b100
00313161000061616300314141616161616161616161616161616161616161614242424242424242424242424242424242424242424242424242424242424242
616161616161616161616161616161616161616161616161617100000000003161616161616161616300b000003737373723231363036372a1838383838383b1
6337373712b3616163b3616161616161616161616161616161616161616161614242424242424242424242424242424242424242424242424242424242424242
61616161616161616161616161616161616161616161616171000000000000616161616161616141414141414141616161414141414141414137414141414141
41414141414161614141616161616161616161616161616161616161616161614242424242424242424242424242424242424242424242424242424242424242
616161616161616161616161616161616161616161f3617100000000000031616161616161616161616161616161616161616161616161616137616161616161
61616161616161616161616161616161616161616161616161616161616161614242424242424242424242424242424242424242424242424242424242424242
61616161616161616161616161616161616161616161710000000000314141616161616161616161616161616161616161616161616161616171616161616161
61616161616161616161616161616161616161616161616161616161616161614242424242424242424242424242424242424242424242424242424242424242
61616161616161610000000000000000007171917171000000000031616161616161616161616161616161616161616161616161616161616100616161616161
61616161616161616161616161616161616161616161616161616161616161614242424242424242424242424242424242424242424242424242424242424242
61616161616152000000000000000000000000000000000000003161616161616161616161616161616161616161616161616161616161616100616161616161
61616161616161616161616161616161616161616161616161616161616161614242424242424242424242424242424242424242424242424242424242424242
61616161616161000000000000000000000000020000000000316161616161616161616161616161616161616161616161616161616161616100616161616161
61616161f36161616161616161616161616161616161616161616161616161614242424242424242424242424242424242424242424242424242424242424242
616161616161f30000000000000000000013000300000000006161616161616161616161616161616161616161616161616161f3616161616100616161616161
61616161616161616161616161616161616161616161616161616161616161614242424242424242424242424242424242424242424242424242424242424242
6161616161616153650000b000000033233313030202650031616161616161f36161616161616161616161616161616161616161616161616100616161616161
61616161616161616161616161616161616161616161616161616161616161614242424242424242424242424242424242424242424242424242424242424242
61616161614141414141414141414141414141414141414161616161616161616161616161616161616161616161616161616161616161616100616161616161
61616161616161616161616161616161616161616161616161616161616161614242424242424242424242424242424242424242424242424242424242424242
61616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616100616161616161
61616161616161616161616161616161616161616161616161616161616161614242424242424242424242424242424242424242424242424242424242424242
61616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616141616161616161
61616161616161616161616161616161616161616161616161616161616161614242424242424242424242424242424242424242424242424242424242424242
