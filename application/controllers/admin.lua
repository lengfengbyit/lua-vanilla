local AdminController = {}
local helper = require('config.helper')

--显示登录页面
function AdminController:login()

    -- 如果已经登录，则跳转到index页面
    if self:isLogin() then ngx.exec('/admin/index') end

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
            helper:setCookie(
                {username = args['userName'], pwd = args['password']},
                nil, 3600
            );
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

-- 注销登录
function AdminController:logout()

end

-- 后台框架页面
function AdminController:index()

    -- 没有登录则跳转到登录页面
    if not self:isLogin() then
        helper:log('this is index')
        ngx.exec('/admin/login');
    end

    local view = self:getView()
    return view:display()
end

-- 控制台页面
function AdminController:main()

    local view = self:getView()

    return view:display()
end

function AdminController:video()

    local view = self:getView()

    return view:display()
end

-- 检查用户是否登录
function AdminController:isLogin()
    local cookie = require('resty.cookie'):new();
    local username = cookie:get('username');
    local pwd = cookie:get('pwd');

    if username == 'admin' and pwd == 'admin123' then
        return true;
    end

    return false;
end

return AdminController