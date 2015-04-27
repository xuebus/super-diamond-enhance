<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<a class="brand" href="/superdiamond/index">首页</a> >> <b><c:out value="${project.PROJ_NAME}"/> - <c:out value="${type}"/></b> <br/><br/>

<b>模块：</b>
<select id="sel-queryModule">
	<option value="">全部</option>
	<c:forEach items="${modules}" var="module">
		<option value='<c:out value="${module.MODULE_ID}"/>'><c:out value="${module.MODULE_NAME}"/></option>
	</c:forEach>
</select>
<!-- <button type="button" id="queryModule" class="btn btn-primary">查询</button> -->
<c:if test="${isOwner}">
	<!-- <a id="addModule" href="javascript:void(0)">添加Module</a> -->
	<!-- <a id="delModule" href="javascript:void(0)">删除Module</a> -->
</c:if>
<!-- <a id="deleteModule" href="javascript:void(0)">删除Module</a> -->
<div class="pull-right">
	<button type="button" class="btn btn-primary" onclick="exportAllConfigs(<c:out value="${projectId}"/>);">导出配置</button>
	<c:if test="${isOwner}">
		<button type="button" id="importModule" class="btn btn-primary">导入配置</button>
		<button type="button" onclick="addModuleTemplate('<c:out value="${projectId}"/>');" class="btn btn-primary">导入模版</button>
		<button type="button" id="addConfig" class="btn btn-primary">添加配置</button>
	</c:if>
	<button type="button" id="preview" class="btn btn-primary">预览</button>
</div>

<div id="addModalWin" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  	<div class="modal-header">
    	<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
    	<h3 id="myModalLabel">添加Module</h3>
  	</div>
  	<div class="modal-body">
    	<form id="moduleForm" class="form-horizontal" action='<c:url value="/module/save" />' method="post">
  			<div class="control-group">
    			<label class="control-label">名称：</label>
    			<div class="controls">
    				<input type="hidden" name="projectId" value='<c:out value="${projectId}"/>'/>
    				<input type="hidden" name="type" value='<c:out value="${type}"/>'/>
    				<input type="hidden" name="page" value='<c:out value="${currentPage}"/>'/>
      				<input type="text" id="addModuleName" name="name" class="input-large"> <span id="addTip" style="color: red"></span>
    			</div>
  			</div>
		</form>
  	</div>
  	<div class="modal-footer">
    	<button class="btn" data-dismiss="modal" aria-hidden="true">关闭</button>
    	<button class="btn btn-primary" id="saveModule">保存</button>
  	</div>
</div>

<div id="importModuleWin" style="width:700px" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  	<div class="modal-header">
    	<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
    	<h3 id="myModalLabel">请选择module模板文件</h3>
  	</div>
  	<div class="modal-body">
		<form class="form-horizontal" action='<c:url value="/importModule" />' enctype="multipart/form-data"  method="post" id="importModuleForm">
            <input type="file" name="file" id="moduleExcel"/>
            <input type="hidden" name="type" value='<c:out value="${type}"/>'/>
            <input type="hidden" name="projectId" value='<c:out value="${projectId}"/>'/>
        </form>
  	</div>
  	<div class="modal-footer">
  		<span id="fileUploadConfigTip" style="color: red"></span>
    	<button class="btn" data-dismiss="modal" aria-hidden="true">关闭</button>
    	<button class="btn btn-primary" id="submitModule">上传</button>
  	</div>
</div>
<div id="addConfigWin" style="width:700px" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  	<div class="modal-header">
    	<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
    	<h3 id="myModalLabel">参数配置</h3>
  	</div>
  	<div class="modal-body">
    	<form id="configForm" class="form-horizontal" action='<c:url value="/config/save" />' method="post">
  			<div class="control-group">
  				<!-- 记录defaultModule的id -->
  				<c:forEach items="${modules}" var="module">
					<c:if test="${module.MODULE_NAME == 'default'}">
						<input type="hidden" id="defaultModule" value="${module.MODULE_ID}"/>
					</c:if>
				</c:forEach>
  				<label class="control-label">模块：</label>
    			<div class="controls">
    				<select class="input-xxlarge" name="moduleId" id="config-moduleId">
						<!-- <option value="">请选择...</option> -->
						<c:forEach items="${modules}" var="module">
							<!-- 只显示default module -->
							<option value='<c:out value="${module.MODULE_ID}"/>'><c:out value="${module.MODULE_NAME}"/></option>
						</c:forEach>
					</select>
    			</div>
    			<label class="control-label">资源类型：</label>
    			<div class="controls">
    				<select class="input-xxlarge" name="configType" id="config-configType">
						<option value="CONFIG">CONFIG</option>
						<option value="DRM">DRM</option>
					</select>
    			</div>
    			<label class="control-label">可见性：</label>
    			<div class="controls">
    				<select class="input-xxlarge" name="visableType" id="config-visableType">
						<option value="PUBLIC">PUBLIC</option>
						<option value="PRIVATE">PRIVATE</option>
					</select>
    			</div>
    			<label class="control-label">Config Key：</label>
    			<div class="controls">
    				<input type="hidden" name="configId" id="config-configId" />
    				<input type="hidden" name="projectId" value='<c:out value="${projectId}"/>'/>
    				<input type="hidden" name="type" value='<c:out value="${type}"/>'/>
    				<input type="hidden" name="page" value='<c:out value="${currentPage}"/>'/>
    				<input type="hidden" name="selModuleId" value='<c:out value="${moduleId}"/>'/>
    				<input type="hidden" name="flag" id="config-flag"/>
      				<input type="text" name="configKey" class="input-xxlarge" id="config-configKey">
    			</div>
    			<label class="control-label">Config Value：</label>
    			<div class="controls">
    				<textarea rows="8" name="configValue" class="input-xxlarge" id="config-configValue"></textarea>
    			</div>
    			<label class="control-label">描述：</label>
    			<div class="controls">
      				<textarea rows="2" class="input-xxlarge" name="configDesc" id="config-configDesc"></textarea>
    			</div>
  			</div>
		</form>
  	</div>
  	<div class="modal-footer">
  		<span id="configTip" style="color: red"></span>
    	<button class="btn" data-dismiss="modal" aria-hidden="true">关闭</button>
    	<button class="btn btn-primary" id="saveConfig">保存</button>
    	<button class="btn btn-primary" id="saveConfigExt">保存继续添加</button>
  	</div>
</div>
<!-- add by kanguangwen -->
<div id="pushConfigWin" style="width:700px" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  	<div class="modal-header">
    	<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
    	<h5 id="myModalLabel">MODULE:<font color="read"><span id="moduleValue"></span></font> KEY:<font color="read"><span id="keyValue"></span></font>
    	 VALUE:<font color="read"><span id="globalValue"></span></font> newValue:&nbsp;<input type="text" id="newValue"/></h5>
  	</div>
  	<div class="modal-body">
    	<table class="table table-striped table-bordered">
		  	<thead>
		    	<tr>
		    		<th width="60">客户端类型</th>
		    		<th width="90">客户端地址</th>
		    		<th width="90">连接时间</th>
		    		<th width="90">最后心跳时间</th>
		    		<th width="50">项目名称</th>
		      		<th width="50">操作</th>
		    	</tr>
		  	</thead>
		  	<tbody id="clientInfos"></tbody>
		</table>
  	</div>
</div>
<div id="clientInfosWin" style="width:700px" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  	<div class="modal-header">
    	<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
    	<h3>客户端列表</h3>
  	</div>
  	<div class="modal-body">
    	<table class="table table-striped table-bordered">
		  	<thead>
		    	<tr>
		    		<th width="20%">客户端类型</th>
		    		<th width="20%">客户端地址</th>
		    		<th width="20%">连接时间</th>
		    		<th width="20%">最后心跳时间</th>
		    		<th width="20%">项目名称</th>
		    	</tr>
		  	</thead>
		  	<tbody id="showClientInfos"></tbody>
		</table>
  	</div>
</div>

<table class="table table-striped table-bordered">
  	<thead>
    	<tr>
    		<th width="50">Module</th>
      		<th width="50">Key</th>
      		<th>Value</th>
      		<th width="100">描述</th>
      		<th width="70">配置类型</th>
      		<th width="50">可见性</th>
      		<th width="45">操作人</th>
      		<th width="120">操作时间</th>
      		<th width="200">操作</th>
    	</tr>
  	</thead>
  	<tbody>
    	<c:forEach items="${configs}" var="config">
    		<tr id='row-<c:out value="${config.CONFIG_ID}"/>'>
               	<td value='<c:out value="${config.MODULE_ID}"/>'>
                  	<c:out value="${config.MODULE_NAME}"/>
               	</td>
               	<td value='<c:out value="${config.CONFIG_KEY}"/>'>
               		<c:out value="${config.CONFIG_KEY}"/>
               	</td>
               	<c:if test="${!isAdmin && !isOwner && config.VISABLE_TYPE == 'PRIVATE'}">
	               	<td title='******' >
	                  	******
	               	</td>
               	</c:if>
               	<c:if test="${isAdmin || isOwner || config.VISABLE_TYPE == 'PUBLIC'}">
	               	<td title='<c:out value="${config.CONFIG_VALUE}"/>' >
	                  	<script type="text/javascript">
	                  		var value = '<c:out value="${config.CONFIG_VALUE}"/>';
	                  		if(value.length > 30)
	                  			document.write(value.substring(0, 30) + "...");
	                  		else
	                  			document.write(value);
	                  	</script>
	               	</td>
               	</c:if>
               	<td title='<c:out value="${config.CONFIG_DESC}"/>' >
                  	<script type="text/javascript">
                  		var value = '<c:out value="${config.CONFIG_DESC}"/>';
                  		if(value.length > 15)
                  			document.write(value.substring(0, 15) + "...");
                  		else
                  			document.write(value);
                  	</script>
               	</td>
               	<td title='<c:out value="${config.CONFIG_TYPE}"/>'>
                  	<c:out value="${config.CONFIG_TYPE}"/>
               	</td>
               	<td title='<c:out value="${config.VISABLE_TYPE}"/>'>
                  	<c:out value="${config.VISABLE_TYPE}"/>
               	</td>
               	<td>
                  	<c:out value="${config.OPT_USER}"/>
               	</td>
               	<td>
                  	<c:out value="${config.OPT_TIME}"/>
               	</td>
               	<td>
               		<c:if test="${isOwner}">
                  		<a class="deleteConfig" href='/superdiamond/config/delete/<c:out value="${config.CONFIG_ID}"/>?projectId=<c:out value="${projectId}"/>&type=<c:out value="${type}"/>&moduleName=<c:out value="${config.MODULE_NAME}"/>' title="删除"><i class="icon-remove"></i></a>&nbsp;&nbsp;
	                  	<a href='javascript:updateConfig(<c:out value="${config.CONFIG_ID}"/>)' title="更新"><i class="icon-edit"></i></a>&nbsp;&nbsp;&nbsp;&nbsp;
                  		<!-- 为DRM资源才显示推送按钮 -->	
	                  	<c:if test="${config.CONFIG_TYPE == 'DRM'}">
	                  	<!-- add by kanguangwen -->
							<button type="button" onclick="pushGlobalConfig('${projectId}','${config.MODULE_NAME}','${config.CONFIG_KEY}');" class="btn btn-primary">全推</button>&nbsp;&nbsp;&nbsp;&nbsp;
							<button type="button" onclick="pushPartConfig('${projectId}','${config.MODULE_NAME}','${config.CONFIG_KEY}','${config.CONFIG_VALUE}');" class="btn btn-primary">局推</button>
	                  	</c:if>
	                  	<!-- 为CONFIG资源显示ip列表 -->
	                  	<c:if test="${config.CONFIG_TYPE == 'CONFIG'}">
							<button type="button" onclick="showClientInfos('${projectId}','${config.MODULE_NAME}');" class="btn btn-primary">客户端列表</button>
	                  	</c:if>
                  	</c:if>
                  	<c:if test="${!isOwner}">
                  		<button type="button" onclick="showClientInfos('${projectId}','${config.MODULE_NAME}');" class="btn btn-primary">客户端列表</button>
                  	</c:if>
               	</td>
          	</tr>
     	</c:forEach>
	</tbody>
</table>

<c:if test="${sessionScope.message != null}">
	<div class="alert alert-error clearfix" style="margin-bottom: 5px;width: 400px; padding: 2px 15px 2px 10px;">
		${sessionScope.message}
	</div>
</c:if>

<script type="text/javascript">
function updateConfig(id) {
	var tds = $("#row-" + id + " > td");
	$("#config-moduleId").val($(tds.get(0)).attr("value"));
	$("#config-configKey").val($(tds.get(1)).attr("value"));
	$("#config-configValue").val($(tds.get(2)).attr("title"));
	$("#config-configDesc").val($(tds.get(3)).attr("title"));
	$("#config-configType").val($(tds.get(4)).attr("title"));
	$("#config-visableType").val($(tds.get(5)).attr("title"));
	$("#config-configId").val(id);
	
	$('#addConfigWin').modal({
		backdrop: false
	})
}
//add by kanguangwen
//打开推送客户端列表
function pushPartConfig(projectId,moduleName,configKey,configValue){
	var pushInfo = "'"+projectId+"',"+"'development',"+"'"+moduleName+"',"+"'"+configKey+"'";
	var temp;
	//获取最新的客户端连接列表
	$.ajax({
		  url: '/superdiamond/profile/'+projectId+'/development/'+moduleName,
		  type: 'POST',
		  dataType: 'html',
		  success: function(data, textStatus, xhr) {
				//字符串转换成json对象
			    var clientInfos = eval('(' + data + ')');
			  	var text;
				for(var clientInfo in clientInfos){
					temp = pushInfo;
					temp += (",'"+clientInfos[clientInfo].address+"'")
					text += ('<tr><td>'+
					clientInfos[clientInfo].clientType
			        +'</td><td>'+
					clientInfos[clientInfo].address
			        +'</td><td>'+
					clientInfos[clientInfo].connTime
			        +'</td><td>'+
					clientInfos[clientInfo].lastConnTime
			        +'</td><td>'+
					clientInfos[clientInfo].projectName
			        +'</td><td><button class=\"btn btn-primary\" onclick=\"pushAction('+temp+');\">推送</button></td></tr>')
				}
				//展现客户端连接列表
				$("#clientInfos").html('');
				$("#clientInfos").append(text);
		  }
	});
	$("#moduleValue").text(moduleName);
	$("#keyValue").text(configKey);
	$("#globalValue").text(configValue);

	$('#pushConfigWin').modal({
		backdrop: true
	})		 
}
//展示CONFIG客户端列表
function showClientInfos(projectId,moduleName){
	//获取最新的客户端连接列表
	$.ajax({
		  url: '/superdiamond/profile/'+projectId+'/development/'+moduleName,
		  type: 'POST',
		  dataType: 'html',
		  success: function(data, textStatus, xhr) {
				//字符串转换成json对象
			    var clientInfos = eval('(' + data + ')');
			  	var text;
				for(var clientInfo in clientInfos){
					text += ('<tr><td>'+
					clientInfos[clientInfo].clientType
			        +'</td><td>'+
					clientInfos[clientInfo].address
			        +'</td><td>'+
					clientInfos[clientInfo].connTime
			        +'</td><td>'+
					clientInfos[clientInfo].lastConnTime
			        +'</td><td>'+
					clientInfos[clientInfo].projectName
			        +'</td></tr>')
				}
				//展现客户端连接列表
				$("#showClientInfos").html('');
				$("#showClientInfos").append(text);
		  }
	});

	$('#clientInfosWin').modal({
		backdrop: true
	})		 
}
//向客户端推送单个配置项
function pushAction(projectId,profile,moduleName,configKey,clientAddress){
	if($("#newValue").val() == ''){
		alert('请输入要推送的数据!');
		return;
	}
    bootbox.confirm("确认推送? 推送后<font color=\"read\">"+clientAddress+"</font>所对应的客户端数据将被替换为<font color=\"read\">"+$("#newValue").val()+"</font>", function(confirmed) {
    	if(confirmed){
    		$.ajax({
    			  url: '/superdiamond/partPush/'+projectId+'/development/'+moduleName,
    			  type: 'POST',
    			  dataType: 'html',
    			  data: {clientAddress: clientAddress,configKey:configKey,configValue: $("#newValue").val()},
    			  success: function(data, textStatus, xhr) {
    					//字符串转换成json对象
    					if(data != ''){
    						//简单的alert出推送失败的服务器信息
    						alert(data);
    					}else{
    						alert('推送触发成功!');
    					}
    			  }
    		});
    	}
    });
    return false;
}


function pushGlobalConfig(projectId,moduleName,configKey){
	 bootbox.confirm("确认全局推送? 推送后订阅<font color=\"read\">"+configKey+"</font>的所有客户端数据将被替换！", function(confirmed) {
	    	if(confirmed){
	    		$.ajax({
	    			  url: '/superdiamond/globalPush/'+projectId+'/development/'+moduleName,
	    			  type: 'POST',
	    			  dataType: 'html',
	    			  data: {configKey: configKey},
	    			  success: function(data, textStatus, xhr) {
	    					//字符串转换成json对象
	    					if(data != ''){
	    						//简单的alert出推送失败的服务器信息
	    						alert(data);
	    					}else{
	    						alert('推送触发成功!');
	    					}
	    			  }
	    		});
	    	}
	    });
	    return false;
}


function addModuleTemplate(projectId){
	window.open('/superdiamond/moduleManage/moduleList?page=1&projectId='+projectId,'模版列表','height=500,width=1000,top=100,left=150,toolbar=no,menubar=no,scrollbars=no,resizable=no,location=no,status=no,z-look=yes')
}
	
//导出配置到Excel文件
function exportAllConfigs(projectId){
	window.location.href="/superdiamond/exportAllConfig/development?projectId="+projectId;
}

$(document).ready(function () {
	$("#sel-queryModule").val(<c:out value="${moduleId}"/>);
	
	$("#preview").click(function(e) {
		window.location.href = '/superdiamond/profile/preview/<c:out value="${project.PROJ_CODE}"/>/<c:out value="${type}"/>?projectId=<c:out value="${projectId}"/>';
	});
	
	$("a.deleteConfig").click(function(e) {
	    e.preventDefault();
	    bootbox.confirm("确定删除配置项，删除之后不可恢复！", function(confirmed) {
	    	if(confirmed)
	    		window.location.href = $(e.target).parent().attr("href");
	    });
	    
	    return false;
	});
	
	$("#sel-queryModule").change(function(e) {
		var moduleId = $("#sel-queryModule").val();
		var url = '/superdiamond/profile/<c:out value="${type}"/>/<c:out value="${projectId}"/>';
		if(moduleId)
			url = url + "?moduleId=" + moduleId;
		
		window.location.href = url;
	});
	
	$("#queryModule").click(function(e) {
		var moduleId = $("#sel-queryModule").val();
		var url = '/superdiamond/profile/<c:out value="${type}"/>/<c:out value="${projectId}"/>';
		if(moduleId)
			url = url + "?moduleId=" + moduleId;
		
		window.location.href = url;
	});
	
	$("#addModule").click(function(e) {
		$('#addModalWin').modal({
			keyboard: false
		})
	});
	
	$("#delModule").click(function(e) {
		var moduleId = $("#sel-queryModule").val();
		if(moduleId) {
			window.location.href = '/superdiamond/module/delete/<c:out value="${type}"/>/<c:out value="${projectId}"/>/' + moduleId;
		} else {
			bootbox.alert("请选择一个模块！");
		}
	});
	
	$("#saveModule").click(function(e) {
		if(!$("#addModuleName").val()) {
			$("#addTip").text("不能为空");
		} else {
			$("#moduleForm")[0].submit();
		}
	});
	
	$("#addConfig").click(function(e) {
		$("#config-moduleId").val($("#defaultModule").val());
		$('#addConfigWin').modal({
			backdrop: true
		})
	});
	//显示导入模板的页面
	$("#importModule").click(function(e) {
		$('#importModuleWin').modal({
			backdrop: true
		})
	});
	//提交Excel文件
	$("#submitModule").click(function(e) {
		if(!$("#moduleExcel").val()) {
			$("#fileUploadConfigTip").text("请选择Excel文件!");
		} else {
			$("#importModuleForm")[0].submit();
		}
	});
	
	$("#saveConfig").click(function(e) {
		if(!$("#config-moduleId").val()) {
			$("#configTip").text("模块不能为空");
		} else if(!$("#config-configKey").val()) {
			$("#configTip").text("configKey不能为空");
		} else if(!$("#config-configValue").val()) {
			$("#configTip").text("configValue不能为空");
		} else {
			$("#configForm")[0].submit();
		}
	});
	
	$("#saveConfigExt").click(function(e) {
		$("#config-flag").val("con");
		if(!$("#config-moduleId").val()) {
			$("#configTip").text("模块不能为空");
		} else if(!$("#config-configKey").val()) {
			$("#configTip").text("configKey不能为空");
		} else if(!$("#config-configValue").val()) {
			$("#configTip").text("configValue不能为空");
		} else {
			$("#configForm")[0].submit();
		}
	});
	
	var flag = "<%= request.getParameter("flag")%>";
	if(flag == "con") {
		$("#addConfig").click();
	}
});
</script>