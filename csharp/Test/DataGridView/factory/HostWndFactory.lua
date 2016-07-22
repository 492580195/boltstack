--//--------------------------------------------
--// Copyright (c) Xunlei, Ltd. 2004-2014
--//--------------------------------------------
--//
--// Author     : fanfeilong
--// Create     : 2014-11-14
--// Histrory   :
--// Description: HostWndFactory.lua ���幤��
--//
--//--------------------------------------------

----------------------------------
--//[����˵��]
--//��������(��������)
----------------------------------
function createWnd(wndTemplateType,wndID,wndName)
    local templateMananger  = XLGetObject("Xunlei.UIEngine.TemplateManager")
    local wndTemplate = templateMananger:GetTemplate(wndID,wndTemplateType)
    if not wndTemplate then return nil end
    local wnd = wndTemplate:CreateInstance(wndName)
    if not wnd then return nil end

    --//
    --//ͨ��metatableΪhostwnd�����չ����
    --//
    local metatable = getmetatable(wnd)

    --//
    --//ֱ��ͨ��hostwnd��ȡָ��ID��UI����
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
--//[����˵��]
--//������(��������)
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
--//[����˵��]
--//����HostWnd
----------------------------------
function HostWndFactory:CreateHostWnd(wndID,wndName)
    return createWnd("HostWndTemplate",wndID,wndName)
end
----------------------------------
--//[����˵��]
--//����ObjectTree
----------------------------------
function HostWndFactory:CreateObjectTree(treeID,treeName)
    return createTree("ObjectTreeTemplate",treeID,treeName)
end
----------------------------------
--//[����˵��]
--//���ٴ����Լ��󶨵Ķ�����
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
--//[����˵��]
--//��ڵ�
-----------------------
function Register()
    local HostWndFactoryMeta = { __index = HostWndFactory}
    setmetatable(HostWndFactory,HostWndFactoryMeta)
    XLSetGlobal("HostWndFactory",HostWndFactory)
end