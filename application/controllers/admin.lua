local AdminController = {}
local helper = require('config.helper')

--显示登录页面
function AdminController:login()
    local view = self:getView()

    -- 获得当前请求方法
    local reqMethod = ngx.var.request_method

    if reqMethod == 'GET' then

        local  args = ngx.req.get_uri_args()
        local userName = args['userName'] or 'nil'

        return view:display()
    elseif reqMethod == 'POST' then

        local receive_headers = ngx.req.get_headers()

        ngx.req.read_body()
        args = ngx.req.get_post_args()

        if args['userName'] == 'admin' and args['password'] == 'admin123' then
            helper:log('登录成功');
            ngx.exec('/admin/index');
        else
            helper:log('登录失败');
        end

        helper:log('用户名：' .. args['userName'] .. '，密码：' .. args['password'])
        helper:closeLogFile()
    end

    return view:display()
end

--控制台页面
function AdminController:index()
    local view = self:getView()
    helper:log('后台首页');

    return view:display()
end


function AdminController:main()

    local view = self:getView()

    return view:display()
end

function AdminController:video()

    local view = self:getView()

    return view:display()
end

function AdminController:test()

    return helper:dumpTab(helper:getAllCookie())

end

function AdminController:setCookie()
    --[[ngx.header["Set-Cookie"] = 'pwd=admin123;usename=admin; path=/;Expires=' ..
    -- ngx.header["Set-Cookie"] = 'pwd=admin123'
    ngx.cookie_time(ngx.time() + 100)--]]

    local time = ngx.cookie_time(ngx.time() + 200);
    ngx.header['Set-Cookie'] = {'username=admin;path=/','pwd=admin123;Expires=' .. time}
    -- helper:setCookie({username = 'admin', pwd = 'admin123'}, nil, 86400);
    return 'setCookie'
end

function AdminController:getCookie()

    return ngx.var.http_cookie
    -- return 'username:' .. ngx.var['cookie_usename'] .. 'pwd:' .. ngx.var['cookie_pwd'];
end


return AdminController