---
title: Small Functions are Good for the Universe
---
This is a copy of [a post](https://love2d.org/forums/viewtopic.php?t=2826&p=33948#p33950) I
did some time ago in the LÖVE forums, which someone kindly reminded me of
today.

<!-- MORE -->

> Why is it forbidden for a function to do two different things?

There are many reasons. The first one is that functions are supposed to
be reusable. If you divide a big function into smaller functions, you
can reuse those smaller functions in other places. The other reason is
that by giving proper names to those functions, your code looks more
like English and less than machine code. It's easier to understand for
humans.

A big function is like a landscape that one has to explore in order to
"understand". When you have smaller functions with significant names,
those names act as "signposts" indicating where the code "goes" to
humans.

> What would you use instead?

If a function does two things, you divide it in two functions, give
those functions proper, significant, pronounceable names, and call those
functions from the original one.

For example, if you have a big function like this one:

(Note: I'll be using my class library, middleclass, tangentially, just
to show how a good design and object orientation facilitate making
stuff)

```lua
function Turret:update(dt)
  local t
  local dx,dy,d
  local cd = math.huge
  for _,p in ipairs(Game.players)
    dx = self.x - p.x
    dy = self.y - p.y
    d = dx*dx + dy*dy
    if d < cd then
      t = p
      cd = d
    end
  end

  if t then
    Bullet.new(self.x, self.y, math.atan2(self.x - t.x, self.y - t.y))
  end
end
```

If you use lots of functions like this one, your code tends to become
unmanageable, especially if you return to it after not touching it for
several months. It's a code that you understand while you are writing, and
certainly the machine understands it, but it doesn't have "signposts" for
future visitors. They have to "explore" it to know it.

One option is to put a couple comments.

```lua
function Turret:update(dt)
  -- get nearest player within sight
  local t
  local dx,dy,d
  local cd = math.huge
  for _,p in ipairs(Game.players)
    dx = self.x - p.x
    dy = self.y - p.y
    d = dx*dx + dy*dy
    if d < cd then
      t = p
      cd = d
    end
  end

  -- shoot a bullet to the player
  if t then
    Bullet.new(self.x, self.y, math.atan2(self.x - t.x, self.y - t.y))
  end
end
```
A much, much better solution is extracting those two "different things"
into functions, ditch the comments, and use better names for the
variable while you are at it.

While you are doing this, you will suddenly realize that this function
isn't really making two things. It's doing **LOTS** of things. Each one
of those things belongs to a different function.

Like this:

```lua
function Turret:update(dt)
  local target = self:getTarget()
  if target then self:shootAt(target) end
end

function Turret:getTarget()
  return self:getNearest(Game.players)
end

function Turret:getNearest(objects)
  local distance, nearest
  local shortestDistance = math.huge
  for _,object in ipairs(objects)
    distance = self:getSquaredDistance(object)
    if distance < shortestDistance then
      nearest = object
      shortestDistance = distance
    end
  end
  return nearest
end

function Turret:getSquaredDistance(object)
  local dx, dy = self.x - object.x, self.y - object.y
  return dx*dx + dy*dy
end

function Turret:shootAt(target)
  Bullet.new(self.x, self.y, self:getAngle(target))
end

function Turret:getAngle(object)
  return math.atan2(self.x - t.x, self.y - t.y)
end
```
I'm sorry but I could not make `Turrent:getNearest` any smaller.

Both programs do the same; for the machine, they are no different. But
for programmers, they are so much easier to understand and maintain.
Take a look at `Turret:update()`! Isn't it just beautiful?

And now that you have smaller functions, you can reuse them in other
places. I could move getDistance and getAngle to a Vector class, for
example. That way I could use code for calculating distances and angles
in all `Enemies` and `Players`, not just in my `Turret` class.

Notice that the `Turret` is prepared to attack players, but it's very
easy to subclass it now and create a turret that shoots other things,
like asteroids. Actually, let me show you:

```lua
AsteroidCleaningTurret = class('AsteroidCleaningTurret', Turret)
function AsteroidCleaningTurret:getTarget()
  return self:getNearest(Game.asteroids)
end
```

That's it. If I create an `AsteroidCleaningTurret`, it'll start shooting
asteroids. In 4 lines. If the code of `Turret:update()` was the first
version, I would have had to fiddle much more in order to do this. It's
so easy to modify now! I could make a `DrunkenTurret` that calculates
angles badly. Or one that shoots 4 bullets instead of just one. There're
so many places you can tweak!

...

And I guess I'll just shut up now. I hope I made my point. Each function
should do just one thing because that's better for the Universe.
