-- Generated by Haxe 3.4.0 (git build development @ a60bee7)
local function _hx_anon_newindex(t,k,v) t.__fields__[k] = true; rawset(t,k,v); end
local _hx_anon_mt = {__newindex=_hx_anon_newindex}
local function _hx_a(...)
  local __fields__ = {};
  local ret = {__fields__ = __fields__};
  local max = select('#',...);
  local tab = {...};
  local cur = 1;
  while cur < max do
    local v = tab[cur];
    __fields__[v] = true;
    ret[v] = tab[cur+1];
    cur = cur + 2
  end
  return setmetatable(ret, _hx_anon_mt)
end

local function _hx_e()
  return setmetatable({__fields__ = {}}, _hx_anon_mt)
end

local function _hx_o(obj)
  return setmetatable(obj, _hx_anon_mt)
end

local function _hx_new(prototype)
  return setmetatable({__fields__ = {}}, {__newindex=_hx_anon_newindex, __index=prototype})
end

local _hxClasses = {}
Int = (function() _hxClasses.Int = _hx_o({__fields__={__name__=true},__name__={"Int"}}); return _hxClasses.Int end)();
Dynamic = (function() 
_hxClasses.Dynamic = _hx_o({__fields__={__name__=true},__name__={"Dynamic"}}); return _hxClasses.Dynamic end)();
Float = (function() 
_hxClasses.Float = _hx_e(); return _hxClasses.Float end)();
Float.__name__ = {"Float"}
Bool = (function() 
_hxClasses.Bool = _hx_e(); return _hxClasses.Bool end)();
Bool.__ename__ = {"Bool"}
Class = (function() 
_hxClasses.Class = _hx_o({__fields__={__name__=true},__name__={"Class"}}); return _hxClasses.Class end)();
Enum = _hx_e();

local _hx_array_mt = {
  __newindex = function(t,k,v)
    local len = t.length
    t.length =  k >= len and (k + 1) or len
    rawset(t,k,v)
  end
}

local function _hx_tab_array(tab,length)
  tab.length = length
  return setmetatable(tab, _hx_array_mt)
end

local _hx_exports = _hx_exports or {}
local Array = _hx_e()
local defold = {}
defold.support = {}
defold.support.Script = _hx_e()
local Block = _hx_e()
defold.support.GuiScript = _hx_e()
local Board = _hx_e()
local LevelComplete = _hx_e()
local MainMenu = _hx_e()
local Messages = _hx_e()
local NoDropRoom = _hx_e()
local PresentLevel = _hx_e()
local Restart = _hx_e()
local String = _hx_e()
local Std = _hx_e()
defold.GoMessages = _hx_e()
defold.GuiMessages = _hx_e()
defold.SpriteMessages = _hx_e()
defold.types = {}
defold.types._Message = {}
defold.types._Message.Message_Impl_ = _hx_e()
local haxe = {}
haxe.io = {}
haxe.io.Eof = _hx_e()
local lua = {}
lua.Boot = _hx_e()

local _hx_bind, _hx_bit, _hx_staticToInstance, _hx_funcToField, _hx_maxn, _hx_print, _hx_apply_self, _hx_box_mr, _hx_bit_clamp, _hx_table, _hx_bit_raw

Array.new = {}
Array.prototype = _hx_a(
  'join', function(self,sep) 
    local tbl = ({});
    local _gthis = self;
    local cur_length = 0;
    local i = _hx_o({__fields__={hasNext=true,next=true},hasNext=function() 
      do return cur_length < _gthis.length end;
    end,next=function() 
      cur_length = cur_length + 1;
      do return _gthis[cur_length - 1] end;
    end});
    while (i:hasNext()) do 
      _G.table.insert(tbl,Std.string(i:next()));
      end;
    do return _G.table.concat(tbl,sep) end
  end,
  'push', function(self,x) 
    _G.rawset(self,self.length,x);
    _G.rawset(self,"length",self.length + 1);
    do return _G.rawget(self,"length") end
  end,
  'iterator', function(self) 
    local _gthis = self;
    local cur_length = 0;
    do return _hx_o({__fields__={hasNext=true,next=true},hasNext=function() 
      do return cur_length < _gthis.length end;
    end,next=function() 
      cur_length = cur_length + 1;
      do return _gthis[cur_length - 1] end;
    end}) end
  end
)

defold.support.Script.new = function() 
  local self = _hx_new(defold.support.Script.prototype)
  defold.support.Script.super(self)
  return self
end
defold.support.Script.super = function(self) 
end
defold.support.Script.prototype = _hx_a(
  'init', function(self,_self) 
  end,
  'final', function(self,_self) 
  end,
  'update', function(self,_self,dt) 
  end,
  'on_message', function(self,_self,message_id,message,sender) 
  end,
  'on_input', function(self,_self,action_id,action) 
    do return false end
  end,
  'on_reload', function(self,_self) 
  end
)

Block.new = function() 
  local self = _hx_new(Block.prototype)
  Block.super(self)
  return self
end
Block.super = function(self) 
  defold.support.Script.super(self);
end
_hx_exports["Block"] = Block
Block.prototype = _hx_a(
  'init', function(self,_self) 
    _G.go.set_scale(0.18);
    _self.fx1 = nil;
    _self.fx2 = nil;
    _G.msg.post("#cover",defold.GoMessages.disable);
    if (_self.color ~= nil) then 
      _G.msg.post("#sprite",defold.SpriteMessages.play_animation,_hx_o({__fields__={id=true},id=_self.color}));
    else
      _G.msg.post("#sprite",defold.GoMessages.disable);
    end;
  end,
  'final', function(self,_self) 
    if (_self.fx1 ~= nil) then 
      _G.go.delete(_self.fx1);
    end;
    if (_self.fx2 ~= nil) then 
      _G.go.delete(_self.fx2);
    end;
    if (_self.cover ~= nil) then 
      _G.go.delete(_self.cover);
    end;
  end,
  'on_message', function(self,_self,message_id,message,_) 
    local message_id1 = message_id;
    if (message_id1) == Messages.lights_off or (message_id1) == Messages.lights_on then 
      _G.msg.post(_self.fx1,message_id);
      _G.msg.post(_self.fx2,message_id);
    elseif (message_id1) == Messages.make_magic then 
      _self.color = _G.hash("magic");
      _G.msg.post("#cover",defold.GoMessages.enable);
      _G.msg.post("#sprite",defold.GoMessages.enable);
      _G.msg.post("#sprite",defold.SpriteMessages.play_animation,_hx_o({__fields__={id=true},id=_G.hash("magic-sphere_layer1")}));
      local hleft = _G.hash("left");
      local hright = _G.hash("right");
      _self.fx1 = _G.factory.create("#fxfactory",_G.vmath.vector3(0,0,0),nil,({direction = hleft}));
      _self.fx2 = _G.factory.create("#fxfactory",_G.vmath.vector3(0,0,0),nil,({direction = hright}));
      _G.msg.post(_self.fx1,defold.GoMessages.set_parent,_hx_o({__fields__={parent_id=true,keep_world_transform=true},parent_id=_G.go.get_id(),keep_world_transform=0}));
      _G.msg.post(_self.fx2,defold.GoMessages.set_parent,_hx_o({__fields__={parent_id=true,keep_world_transform=true},parent_id=_G.go.get_id(),keep_world_transform=0}));
      _G.go.set(_self.fx1,"position.z",0.01);
      _G.go.set(_self.fx1,"scale",1);
      _G.go.set(_self.fx2,"position.z",0.02);
      _G.go.set(_self.fx2,"scale",1); end;
  end
)
Block.__super__ = defold.support.Script
setmetatable(Block.prototype,{__index=defold.support.Script.prototype})

defold.support.GuiScript.new = function() 
  local self = _hx_new(defold.support.GuiScript.prototype)
  defold.support.GuiScript.super(self)
  return self
end
defold.support.GuiScript.super = function(self) 
end
defold.support.GuiScript.prototype = _hx_a(
  'init', function(self,_self) 
  end,
  'final', function(self,_self) 
  end,
  'update', function(self,_self,dt) 
  end,
  'on_message', function(self,_self,message_id,message,sender) 
  end,
  'on_input', function(self,_self,action_id,action) 
    do return false end
  end,
  'on_reload', function(self,_self) 
  end
)

Board.new = function() 
  local self = _hx_new(Board.prototype)
  Board.super(self)
  return self
end
Board.super = function(self) 
  defold.support.GuiScript.super(self);
end
_hx_exports["Board"] = Board
Board.prototype = _hx_a(
  'init', function(self,_) 
    _G.msg.post("#",Messages.show);
    _G.msg.post("/restart#gui",Messages.hide);
    _G.msg.post("/level_complete#gui",Messages.hide);
  end,
  'on_message', function(self,_,message_id,message,_1) 
    if (message_id) == Messages.hide then 
      _G.msg.post("#",defold.GoMessages.disable);
    elseif (message_id) == Messages.set_drop_counter then 
      _G.gui.set_text(_G.gui.get_node("drop_counter"),message.drops .. " x");
    elseif (message_id) == Messages.show then 
      _G.msg.post("#",defold.GoMessages.enable); end;
  end,
  'on_input', function(self,_,action_id,action) 
    if ((action_id == _G.hash("touch")) and action.pressed) then 
      local restart = _G.gui.get_node("restart");
      local drop = _G.gui.get_node("drop");
      if (_G.gui.pick_node(restart,action.x,action.y)) then 
        _G.msg.post("/restart#gui",Messages.show);
        _G.msg.post("#",Messages.hide);
      else
        if (_G.gui.pick_node(drop,action.x,action.y)) then 
          _G.msg.post("/board#script",Messages.drop);
        end;
      end;
    end;
    do return false end
  end
)
Board.__super__ = defold.support.GuiScript
setmetatable(Board.prototype,{__index=defold.support.GuiScript.prototype})

LevelComplete.new = function() 
  local self = _hx_new(LevelComplete.prototype)
  LevelComplete.super(self)
  return self
end
LevelComplete.super = function(self) 
  defold.support.GuiScript.super(self);
end
_hx_exports["LevelComplete"] = LevelComplete
LevelComplete.prototype = _hx_a(
  'init', function(self,_) 
    _G.msg.post("#",Messages.hide);
  end,
  'on_message', function(self,_,message_id,_1,_2) 
    if (message_id) == Messages.hide then 
      _G.msg.post("#",defold.GoMessages.disable);
      _G.msg.post(".",defold.GoMessages.release_input_focus);
    elseif (message_id) == Messages.show then 
      _G.msg.post("#",defold.GoMessages.enable);
      _G.msg.post(".",defold.GoMessages.acquire_input_focus); end;
  end,
  'on_input', function(self,_,action_id,action) 
    if ((action_id == _G.hash("touch")) and action.pressed) then 
      if (_G.gui.pick_node(_G.gui.get_node("continue"),action.x,action.y)) then 
        _G.msg.post("board#script",Messages.next_level);
        _G.msg.post("#",Messages.hide);
      end;
    end;
    do return true end
  end
)
LevelComplete.__super__ = defold.support.GuiScript
setmetatable(LevelComplete.prototype,{__index=defold.support.GuiScript.prototype})

MainMenu.new = function() 
  local self = _hx_new(MainMenu.prototype)
  MainMenu.super(self)
  return self
end
MainMenu.super = function(self) 
  defold.support.GuiScript.super(self);
end
_hx_exports["MainMenu"] = MainMenu
MainMenu.prototype = _hx_a(
  'init', function(self,_) 
    _G.msg.post(".",defold.GoMessages.acquire_input_focus);
    local bs = _hx_tab_array({[0]="brick1", "brick2", "brick3", "brick4", "brick5", "brick6" }, 6);
    local _g = 0;
    while (_g < bs.length) do 
      local b = bs[_g];
      _g = _g + 1;
      local n = _G.gui.get_node(b);
      local rt = (_G.math.random() * 3) + 1;
      local a = _G.math.random(-45,45);
      _G.gui.set_color(n,_G.vmath.vector4(1,1,1,0));
      _G.gui.animate(n,"position.y",-100 - _G.math.random(0,50),_G.gui.EASING_INSINE,1 + rt,0,nil,_G.gui.PLAYBACK_LOOP_FORWARD);
      _G.gui.animate(n,"color.w",1,_G.gui.EASING_INSINE,1 + rt,0,nil,_G.gui.PLAYBACK_LOOP_FORWARD);
      _G.gui.animate(n,"rotation.z",a,_G.gui.EASING_INSINE,1 + rt,0,nil,_G.gui.PLAYBACK_LOOP_FORWARD);
      end;
    _G.gui.animate(_G.gui.get_node("start"),"color.x",1,_G.gui.EASING_INOUTSINE,1,0,nil,_G.gui.PLAYBACK_LOOP_PINGPONG);
  end,
  'on_input', function(self,_,action_id,action) 
    if ((action_id == _G.hash("touch")) and action.pressed) then 
      if (_G.gui.pick_node(_G.gui.get_node("start"),action.x,action.y)) then 
        _G.msg.post("/main#script",Messages.start_game);
      end;
    end;
    do return false end
  end
)
MainMenu.__super__ = defold.support.GuiScript
setmetatable(MainMenu.prototype,{__index=defold.support.GuiScript.prototype})

Messages.new = {}

NoDropRoom.new = function() 
  local self = _hx_new(NoDropRoom.prototype)
  NoDropRoom.super(self)
  return self
end
NoDropRoom.super = function(self) 
  defold.support.GuiScript.super(self);
end
_hx_exports["NoDropRoom"] = NoDropRoom
NoDropRoom.prototype = _hx_a(
  'init', function(self,_self) 
    _G.msg.post("#",Messages.hide);
    _self.t = 0;
  end,
  'update', function(self,_self,dt) 
    if (_self.t < 0) then 
      _G.msg.post("#",Messages.hide);
    else
      _self.t = _self.t - dt;
    end;
  end,
  'on_message', function(self,_self,message_id,message,_) 
    if (message_id) == Messages.hide then 
      _G.msg.post("#",defold.GoMessages.disable);
    elseif (message_id) == Messages.show then 
      _self.t = 1;
      _G.msg.post("#",defold.GoMessages.enable); end;
  end
)
NoDropRoom.__super__ = defold.support.GuiScript
setmetatable(NoDropRoom.prototype,{__index=defold.support.GuiScript.prototype})

PresentLevel.new = function() 
  local self = _hx_new(PresentLevel.prototype)
  PresentLevel.super(self)
  return self
end
PresentLevel.super = function(self) 
  defold.support.GuiScript.super(self);
end
_hx_exports["PresentLevel"] = PresentLevel
PresentLevel.prototype = _hx_a(
  'init', function(self,_) 
    _G.msg.post("#",Messages.hide);
  end,
  'on_message', function(self,_,message_id,message,_1) 
    if (message_id) == PresentLevel.ShowMessage then 
      _G.gui.set_text(_G.gui.get_node("message"),"Level " .. message.level);
      _G.msg.post("#",defold.GoMessages.enable);
    elseif (message_id) == Messages.hide then 
      _G.msg.post("#",defold.GoMessages.disable); end;
  end
)
PresentLevel.__super__ = defold.support.GuiScript
setmetatable(PresentLevel.prototype,{__index=defold.support.GuiScript.prototype})

Restart.new = function() 
  local self = _hx_new(Restart.prototype)
  Restart.super(self)
  return self
end
Restart.super = function(self) 
  defold.support.GuiScript.super(self);
end
_hx_exports["Restart"] = Restart
Restart.prototype = _hx_a(
  'on_message', function(self,_,message_id,message,_1) 
    if (message_id) == Messages.hide then 
      _G.msg.post("#",defold.GoMessages.disable);
      _G.msg.post(".",defold.GoMessages.release_input_focus);
    elseif (message_id) == Messages.show then 
      _G.msg.post("#",defold.GoMessages.enable);
      _G.msg.post(".",defold.GoMessages.acquire_input_focus); end;
  end,
  'on_input', function(self,_,action_id,action) 
    if ((action_id == _G.hash("touch")) and action.pressed) then 
      local yes = _G.gui.get_node("yes");
      local no = _G.gui.get_node("no");
      local quit = _G.gui.get_node("quit");
      if (_G.gui.pick_node(no,action.x,action.y)) then 
        _G.msg.post("#",Messages.hide);
        _G.msg.post("/board#gui",Messages.show);
      else
        if (_G.gui.pick_node(yes,action.x,action.y)) then 
          _G.msg.post("board:/board#script",Messages.restart_level);
          _G.msg.post("/board#gui",Messages.show);
          _G.msg.post("#",Messages.hide);
        else
          if (_G.gui.pick_node(quit,action.x,action.y)) then 
            _G.msg.post("main:/main#script",Messages.to_main_menu);
            _G.msg.post("#",Messages.hide);
          end;
        end;
      end;
    end;
    do return true end
  end
)
Restart.__super__ = defold.support.GuiScript
setmetatable(Restart.prototype,{__index=defold.support.GuiScript.prototype})

String.new = {}
String.__index = function(s,k) 
  if (k == "length") then 
    do return _G.string.len(s) end;
  else
    local o = String.prototype;
    local field = k;
    if ((function() 
      local _hx_1
      if (o.__fields__ ~= nil) then 
      _hx_1 = o.__fields__[field] ~= nil; else 
      _hx_1 = o[field] ~= nil; end
      return _hx_1
    end )()) then 
      do return String.prototype[k] end;
    else
      if (String.__oldindex ~= nil) then 
        do return String.__oldindex[k] end;
      else
        do return nil end;
      end;
    end;
  end;
end
String.fromCharCode = function(code) 
  do return _G.string.char(code) end;
end
String.prototype = _hx_a(
  'toString', function(self) 
    do return self end
  end
)

Std.new = {}
Std.string = function(s) 
  do return lua.Boot.__string_rec(s) end;
end

defold.GoMessages.new = {}

defold.GuiMessages.new = {}

defold.SpriteMessages.new = {}

defold.types._Message.Message_Impl_.new = {}
defold.types._Message.Message_Impl_._new = function(s) 
  do return _G.hash(s) end;
end

haxe.io.Eof.new = {}
haxe.io.Eof.prototype = _hx_a(
  'toString', function(self) 
    do return "Eof" end
  end
)

lua.Boot.new = {}
lua.Boot.isArray = function(o) 
  if (_G.type(o) == "table") then 
    if ((o.__enum__ == nil) and (_G.getmetatable(o) ~= nil)) then 
      do return _G.getmetatable(o).__index == Array.prototype end;
    else
      do return false end;
    end;
  else
    do return false end;
  end;
end
lua.Boot.printEnum = function(o,s) 
  if (o.length == 2) then 
    do return o[0] end;
  else
    local str = Std.string(o[0]) .. "(";
    s = s .. "\t";
    local _g1 = 2;
    local _g = o.length;
    while (_g1 < _g) do 
      _g1 = _g1 + 1;
      local i = _g1 - 1;
      if (i ~= 2) then 
        str = str .. ("," .. lua.Boot.__string_rec(o[i],s));
      else
        str = str .. lua.Boot.__string_rec(o[i],s);
      end;
      end;
    do return str .. ")" end;
  end;
end
lua.Boot.printClassRec = function(c,result,s) 
  if (result == nil) then 
    result = "";
  end;
  local f = lua.Boot.__string_rec;
  for k,v in pairs(c) do if result ~= '' then result = result .. ', ' end result = result .. k .. ':' .. f(v, s.. '	') end;
  do return result end;
end
lua.Boot.__string_rec = function(o,s) 
  if (s == nil) then 
    s = "";
  end;
  local _g = type(o);
  local _g1 = _g;
  if (_g1) == "boolean" then 
    do return tostring(o) end;
  elseif (_g1) == "function" then 
    do return "<function>" end;
  elseif (_g1) == "nil" then 
    do return "null" end;
  elseif (_g1) == "number" then 
    if (o == _G.math.huge) then 
      do return "Infinity" end;
    else
      if (o == -_G.math.huge) then 
        do return "-Infinity" end;
      else
        if (o ~= o) then 
          do return "NaN" end;
        else
          do return tostring(o) end;
        end;
      end;
    end;
  elseif (_g1) == "string" then 
    do return o end;
  elseif (_g1) == "table" then 
    if (o.__enum__ ~= nil) then 
      do return lua.Boot.printEnum(o,s) end;
    else
      if ((o.toString ~= nil) and not lua.Boot.isArray(o)) then 
        do return o:toString() end;
      else
        if (lua.Boot.isArray(o)) then 
          local o2 = o;
          if (s.length > 5) then 
            do return "[...]" end;
          else
            local _g2 = _hx_tab_array({ }, 0);
            local _g11 = 0;
            while (_g11 < o2.length) do 
              local i = o2[_g11];
              _g11 = _g11 + 1;
              _g2:push(lua.Boot.__string_rec(i,s .. 1));
              end;
            do return "[" .. _g2:join(",") .. "]" end;
          end;
        else
          if (o.__class__ ~= nil) then 
            do return "{" .. lua.Boot.printClassRec(o,"",s .. "\t") .. "}" end;
          else
            local fields = lua.Boot.fieldIterator(o);
            local buffer = ({});
            local first = true;
            _G.table.insert(buffer,"{ ");
            local f = fields;
            while (f:hasNext()) do 
              local f1 = f:next();
              if (first) then 
                first = false;
              else
                _G.table.insert(buffer,", ");
              end;
              _G.table.insert(buffer,"" .. Std.string(f1) .. " : " .. Std.string(o[f1]));
              end;
            _G.table.insert(buffer," }");
            do return _G.table.concat(buffer,"") end;
          end;
        end;
      end;
    end;
  elseif (_g1) == "thread" then 
    do return "<thread>" end;
  elseif (_g1) == "userdata" then 
    do return "<userdata>" end;else
  _G.error("Unknown Lua type",0); end;
end
lua.Boot.fieldIterator = function(o) 
  local tbl = (function() 
    local _hx_1
    if (o.__fields__ ~= nil) then 
    _hx_1 = o.__fields__; else 
    _hx_1 = o; end
    return _hx_1
  end )();
  local cur = _G.pairs(tbl);
  local next_valid = function(tbl1,val) 
    while (lua.Boot.hiddenFields[val] ~= nil) do 
      val = cur(tbl1,val);
      end;
    do return val end;
  end;
  local cur_val = next_valid(tbl,cur(tbl,nil));
  do return _hx_o({__fields__={next=true,hasNext=true},next=function() 
    local ret = cur_val;
    cur_val = next_valid(tbl,cur(tbl,cur_val));
    do return ret end;
  end,hasNext=function() 
    do return cur_val ~= nil end;
  end}) end;
end
local _hx_string_mt = _G.getmetatable('');
String.__oldindex = _hx_string_mt.__index;
_hx_string_mt.__index = String.__index;
_hx_string_mt.__add = function(a,b) return Std.string(a)..Std.string(b) end;
_hx_string_mt.__concat = _hx_string_mt.__add
_hx_array_mt.__index = Array.prototype

Messages.start_game = _G.hash("start_game")
Messages.next_level = _G.hash("next_level")
Messages.restart_level = _G.hash("restart_level")
Messages.to_main_menu = _G.hash("to_main_menu")
Messages.hide = _G.hash("hide")
Messages.show = _G.hash("show")
Messages.drop = _G.hash("drop")
Messages.set_drop_counter = _G.hash("set_drop_counter")
Messages.make_magic = _G.hash("make_magic")
Messages.lights_on = _G.hash("lights_on")
Messages.lights_off = _G.hash("lights_off")
PresentLevel.ShowMessage = _G.hash("show")
defold.GoMessages.acquire_input_focus = _G.hash("acquire_input_focus")
defold.GoMessages.disable = _G.hash("disable")
defold.GoMessages.enable = _G.hash("enable")
defold.GoMessages.release_input_focus = _G.hash("release_input_focus")
defold.GoMessages.request_transform = _G.hash("request_transform")
defold.GoMessages.set_parent = _G.hash("set_parent")
defold.GoMessages.transform_response = _G.hash("transform_response")
defold.GuiMessages.layout_changed = _G.hash("layout_changed")
defold.SpriteMessages.animation_done = _G.hash("animation_done")
defold.SpriteMessages.play_animation = _G.hash("play_animation")
lua.Boot.hiddenFields = {__id__=true, hx__closures=true, super=true, prototype=true, __fields__=true, __ifields__=true, __class__=true, __properties__=true}
do

end
return _hx_exports
