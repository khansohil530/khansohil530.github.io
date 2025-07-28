--cave diver
--by sohil

function _init()
 game_over=false
 make_cave()
 make_player()
end

function _update()
 if (not game_over) then
  update_cave()
  move_player()
  check_hit()
 elseif btnp(❎) then
  _init()
 end
end

function _draw()
 cls()
 draw_player()
 draw_cave()
 if game_over then
  print("game over!",44,44,7)
  print("your score:"..player.score,34,54,7)
  print("press ❎ to play again!", 18,72,6)
 else
  print("score:"..player.score,2,2,7)
 end
end

--player
function make_player()
 player = {
  x=24,
  y=60,
  dy=0, --fall speed
  rise=1, --sprites
  fall=2,
  dead=3,
  speed=2, --fly speed
  score=0
 }
end

function draw_player()
 if game_over then
  spr(player.dead, player.x, player.y)
 elseif player.dy<0 then
  spr(player.rise, player.x, player.y)
 else
  spr(player.fall, player.x, player.y)
 end
end

function move_player()
 gravity=0.2 --bigger means more gravity!
 player.dy+=gravity
 --jump
 if btnp(⬆️) then
  player.dy-=5
  sfx(0)
 end

 player.y+=player.dy

 player.score+=player.speed
 if player.score%100==0 do
  player.speed+=1
 end
end

function check_hit()
 for i=player.x, player.x+7 do
  if (cave[i+1].top > player.y
   or cave[i+1].btm<player.y+7) then
    game_over=true
    sfx(1)
  end
 end
end
--cave

function make_cave()
 cave={{top=5, btm=119}}
 top = 45 -- how low can ceiling go?
 btm=85 -- how high can floor get?
end

function update_cave()
 -- remove the back of cave

 if (#cave>player.speed) then
  for i=1,player.speed do
   del(cave, cave[1])
  end
 end

 --add more cave
 while (#cave<128) do
  local col={}
  local up=flr(rnd(7)-3)
  local dwn=flr(rnd(7)-3)
  col.top=mid(3, cave[#cave].top + up, top)
  col.btm=mid(btm, cave[#cave].btm+dwn, 124)
  add(cave,col)
 end
end

function draw_cave()
 top_color=5
 btm_color=5
 for i=1,#cave do
  line(i-1, 0, i-1, cave[i].top, top_color)
  line(i-1, 127, i-1, cave[i].btm, btm_color)
 end
end