function _init()
 game_over=false
 win=false
 g=0.025 --gravity
 make_player()
 make_ground()
end

function _update()
 if (not game_over) then
  move_player()
  check_land()
 else
  if (btnp(❎)) _init()
 end
end

function _draw()
 cls()

 draw_stars()
 draw_ground()
 draw_player()

 if game_over then
  if win then
   print("you win!", 48,48,11)
  else
   print("too bad!", 48,48,8)
  end
  print("press ❎ to play again", 20,70,5)
 end
end

function rnde(low,high)
 return flr(rnd(high-low+1)+low)
end

function draw_stars()
 srand(1)
 for i=1,50 do
  pset(rnde(0,127),rnde(0,127),rnde(5,7))
 end
 srand(time())
end

function make_ground()
 --create ground
 gnd={}
 local top=96
 local btm=120

 --set up landing pad
 pad={}
 pad.width=15
 pad.x=rnde(0,126-pad.width)
 pad.y=rnde(top,btm)
 pad.sprite=2

 --create ground at pad
 for i=pad.x,pad.x+pad.width do
  gnd[i]=pad.y
 end

 --create ground at right of pad
 for i=pad.x+pad.width+1, 127 do
 	local h=rnde(gnd[i-1]-3, gnd[i-1]+3)
 	gnd[i] = mid(top,h,btm)
 end

 for i=pad.x-1,0,-1 do
	 local h=rnde(gnd[i+1]-3, gnd[i+1]+3)
	 gnd[i] = mid(top,h,btm)
 end
end

function draw_ground()
 for i=0,127 do
  line(i,gnd[i],i,127,5)
 end
 spr(pad.sprite,pad.x,pad.y,2,1)
end

function check_land()
 l_x=flr(p.x)
 r_x=flr(p.x+7)
 b_y=flr(p.y+7)

 over_pad = l_x>=pad.x and r_x<=pad.x+pad.width
 on_pad=b_y>=pad.y-1
 slow=p.dy<1
 if (over_pad and on_pad and slow) then
  end_game(true)
 elseif (over_pad and on_pad) then
  end_game(false)
 else
  for i=l_x,r_x do
   if (gnd[i]<b_y) end_game(false)
  end
 end
end

function end_game(won)
 game_over=true
 win=won
 if (win) then
  sfx(1)
 else
  sfx(2)
 end
end

 --player


function make_player()
 p = {
  x=60,y=8,
  dx=0,dy=0,
  sprite=1,
  alive=true,
  thrust=0.075
 }
end

function move_player()
 p.dy+=g

 thrust()

 p.x+=p.dx
 p.y+=p.dy

 stay_on_screen()
 end

function stay_on_screen()
 if p.x<0 then
  p.x=0
  p.dx=0
 end
 if p.x>119 then
  p.x=119
  p.dx=0
 end
 if p.y<0 then
  p.y=0
  p.dy=0
 end
end

function draw_player()
 spr(p.sprite,p.x,p.y)
 if (game_over and win) then
  spr(4,p.x,p.y-8)
 elseif (game_over) then
  spr(5,p.x,p.y)
 end
end

function thrust()
 if (btn(⬆️)) p.dy-=p.thrust
 if (btn(⬅️)) p.dx-=p.thrust
 if (btn(➡️)) p.dx+=p.thrust

 if (btn(⬆️) or btn(⬅️) or btn(➡️)) sfx(0)
end