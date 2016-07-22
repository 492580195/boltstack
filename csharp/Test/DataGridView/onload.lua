--//--------------------------------------------
--// Copyright (c) Xunlei, Ltd. 2004-2014
--//--------------------------------------------
--//
--// Author     : fanfeilong
--// Create     : 2014-11-14
--// Histrory   :
--// Description: Ѹ��P2P���������ƽ���
--//
--//--------------------------------------------

-----------------------
--//[����˵��]
--//������ģ��
-----------------------
function LoadModule(module,entry)
    local pos1, pos2 = string.find(__document, "downloadersimulator")
    local packagePath = string.sub(__document, 1, pos2);
    local modulePath   = string.format("%s/%s",packagePath,module); 
	local md =XLLoadModule(modulePath)
	local entryFunc = md[entry]
	if not entryFunc then
	    local message = string.format("%s,missing entry function:%s",modulePath,entry)
	    XLMessageBox(message)
	    return
	end
	entryFunc()
end

-----------------------
--//[����˵��]
--//��ʾ������
-----------------------
function Run()
    local hostWndFactory =  XLGetGlobal("HostWndFactory")        

    --// ��������
    local mainWnd  = hostWndFactory:CreateHostWnd("main.wnd","MainWnd")
    if not mainWnd then return end
    
    --// ����ȫ�ֱ���
    XLSetGlobal("MainWnd.Instance",mainWnd)
    
    --// ����ί��
    local simulator = XLGetObject("Xunlei.Simulator.Object")
    simulator:SetDelegate(function()
        --// On XLDS Inited
        local mainWnd = XLGetGlobal("MainWnd.Instance")
        mainWnd:ShowInit() 
    end,function(logNo,type,ip,port,log,userData)
        --// Show Log
        local mainWnd = XLGetGlobal("MainWnd.Instance")
        mainWnd:ShowLog(logNo,type,ip,port,log,userData)    
    end,nil)

    --// ����������
    local mainTree = hostWndFactory:CreateObjectTree("main.tree","MainTree")
    if not mainTree then return end

    --// �󶨶�����������
    mainWnd:BindUIObjectTree(mainTree)
    mainWnd:Create()
end


function Main()
    --// 1. ������ģ��
    local modules =
    {
        "factory/HostWndFactory.lua",    
    }
    for i,module in ipairs(modules) do
        LoadModule(module,"Register")
    end

    --// 2. ��ʾ������
    Run()
end

Main()

