--//--------------------------------------------
--// Copyright (c) Xunlei, Ltd. 2004-2014
--//--------------------------------------------
--//
--// Author     : fanfeilong
--// Create     : 2014-11-14
--// Histrory   :
--// Description: HostWndFactory.lua 窗体工厂
--//
--//--------------------------------------------

----------------------------------
--//[函数说明]
--//创建窗体(辅助函数)
----------------------------------
function createWnd(wndTemplateType,wndID,wndName)
    local templateMananger  = XLGetObject("Xunlei.UIEngine.TemplateManager")
    local wndTemplate = templateMananger:GetTemplate(wndID,wndTemplateType)
    if not wndTemplate then return nil end
    local wnd = wndTemplate:CreateInstance(wndName)
    if not wnd then return nil end

    --//
    --//通过metatable为hostwnd添加扩展方法
    --//
    local metatable = getmetatable(wnd)

    --//
    --//直接通过hostwnd获取指定ID的UI对象
    --//
    function metatable:GetUIObject(objectID)
          local objTree = self:GetBindUIObjectTree()
          if not objTree then return nil end
          local obj = objTree:GetUIObject(objectID)
          return obj
    end
    
    function metatable:Close()
        local hostWndFactory =  XLGetGlobal("HostWndFactory")
        hostWndFactory:DestroyWndAndTree(wndName)    
    end
    
    return wnd
end

----------------------------------
--//[函数说明]
--//创建树(辅助函数)
----------------------------------
function createTree(treeTemplateType,treeID,treeName)
    local templateMananger  = XLGetObject("Xunlei.UIEngine.TemplateManager")
    local treeTemplate = templateMananger:GetTemplate(treeID,treeTemplateType)
    if not treeTemplate then return nil end
    local tree = treeTemplate:CreateInstance(treeName)
    if not tree then return nil end

    return tree
end

local HostWndFactory = {}

----------------------------------
--//[函数说明]
--//创建HostWnd
----------------------------------
function HostWndFactory:CreateHostWnd(wndID,wndName)
    return createWnd("HostWndTemplate",wndID,wndName)
end
----------------------------------
--//[函数说明]
--//创建ObjectTree
----------------------------------
function HostWndFactory:CreateObjectTree(treeID,treeName)
    return createTree("ObjectTreeTemplate",treeID,treeName)
end
----------------------------------
--//[函数说明]
--//销毁窗口以及绑定的对象树
----------------------------------
function HostWndFactory:DestroyWndAndTree(wndName)
    local hostwndManager = XLGetObject("Xunlei.UIEngine.HostWndManager")
    local objtreeManager = XLGetObject("Xunlei.UIEngine.TreeManager")

    local hostwnd = hostwndManager:GetHostWnd(wndName)
    if not hostwnd then return end

    local objtree = hostwnd:UnbindUIObjectTree()
    if not objtree then return end     
                                                                
    objtreeManager:DestroyTree(objtree)
    hostwnd:Destroy()
    hostwndManager:RemoveHostWnd(wndName)
end

-----------------------
--//[函数说明]
--//入口点
-----------------------
function Register()
    local HostWndFactoryMeta = { __index = HostWndFactory}
    setmetatable(HostWndFactory,HostWndFactoryMeta)
    XLSetGlobal("HostWndFactory",HostWndFactory)
end