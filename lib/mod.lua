-- koro - a simple chorus for fx mod
-- v1.0 @sonoCircuit

local fx = require 'fx/lib/fx'
local md = require 'core/mods'

local FxKoro = fx:new{subpath = "/fx_koro"}

local function set_param(key, val)
  osc.send({ "localhost", 57120 }, "/fx_koro/set", {key, val})
end

local function round_form(param, quant, form)
  return(util.round(param, quant)..form)
end

function FxKoro:add_params()
    params:add_group("fx_koro", "fx koro", 5)
    FxKoro:add_slot("fx_koro_slot", "slot")

    params:add_control("fx_koro_rate", "rate", controlspec.new(0.01, 6, "exp", 0, 0.4, "", 1/200), function(param) return round_form(param:get(), 0.01, "Hz") end)
    params:set_action("fx_koro_rate", function(x) set_param("rate", x) end)

    params:add_control("fx_koro_depth", "depth", controlspec.new(0, 1, "lin", 0, 0.2), function(param) return round_form(param:get() * 100, 1, "%") end)
    params:set_action("fx_koro_depth", function(x) set_param("depth", x) end)

    params:add_control("fx_koro_spread", "spread", controlspec.new(0, 1, "lin", 0, 1), function(param) return round_form(param:get() * 100, 1, "%") end)
    params:set_action("fx_koro_spread", function(x) set_param("spread", x) end)
end

md.hook.register("script_post_init", "fx koro mod post init", function() FxKoro:add_params() end)
