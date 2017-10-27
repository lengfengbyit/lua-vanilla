local config = require('config.application')
local app = require('vanilla.v.application'):new(config)
local helper = require('config.helper');

--[[local app = helper:dumpTab(app);
helper:log(app);--]]

app:bootstrap():run()