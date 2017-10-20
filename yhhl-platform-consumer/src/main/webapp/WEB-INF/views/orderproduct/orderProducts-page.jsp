<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html >
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Demo</title>
	<%@ include file="/common/meta.jsp" %>
    <%@ include file="/common/import.jsp" %>
    <script type="text/javascript" src="${ctx}/js/money.js?v=1.0.0"></script>
<script type="text/javascript">

		$(function(){
			$('#dataPageList').datagrid({
				title:'订单列表',
				iconCls:'icon-ok',
				url:'${ctx}/sysManage/orderproduct/getOrderProductsDatas.do?t='+new Date(),
				nowrap: false,
				striped: true,
				collapsible:false,				
				fitColumns: true,
				pagination:true,
				singleSelect:true,
				rownumbers:true,
				remoteSort: false,
				pageList:[3,5,10,50],
				idField:'orderProdId',
				columns:[[
					{field:'orderId',title:'订单编号',width:100,sortable:true},
					{field:'prodId',title:'商品编号',width:100,sortable:true},
					{field:'prodName',title:'商品名称',width:100,sortable:true},
					{field:'unitPrice',title:'出售单价',width:100,formatter:function(value){
						return moneyFormatterNoY(value/100);
					}},
					{field:'prodNum',title:'售出数量',width:100,sortable:true},
					{field:'unitPrice',title:'出售总价',width:100,formatter:function(value,row,index){
						return moneyFormatterNoY(row.unitPrice/100*row.prodNum);
					}}
				]],
				toolbar:[{
					text:'增加',
					iconCls:'icon-add',
					handler:function(){
						saveEntity();
					}
				},'-',{
					text:'删除',
					iconCls:'icon-remove',
					handler:function(){
						deleteEntity();
					}
				},'-',{
					text:'修改',
					iconCls:'icon-edit',
					handler:function(){
						editEntity();
					}
				},'-',{
					text:'刷新',
					iconCls:'icon-reload',
					handler:function(){
						$('#dataPageList').datagrid('reload');
					}
				}
				],
				onDblClickRow:function(){
					//dataItemTree();
				},
				onLoadSuccess : function(data){
					if (data.flag == 2) {
						$.messager.alert('结果', data.msg, 'error');
					} else if (data.flag == 3){
						$.messager.alert('结果', '您还未登录，请先登录！', 'error', function(){
							document.location.href="${ctx}/sysManage/index.do";
						});
					} else if(data.flag!= 1){
						$.messager.alert('结果', '操作失败，请重试', 'error');
					}
				}
			});		
		});
		
		function refresh(){
			var url = '${ctx}/sysManage/orderproduct/getOrderProductsDatas.action';
			$.ajax({
				type: "post",
				data: "",
				dataType: "",
				url: url,
				success: function(data, textStatus){
					alert("OK");
				},
				error: function(messg){
					alert("error");
				}
			});
		}
		
		function saveEntity(){
			$('#saveFrame').html('');			
			var url = '${ctx}/sysManage/orderproduct/initAddOrderProducts.do';				
			$('#saveFrame').attr("title",'');
			$('#saveFrame').attr("src",url);
			$("#saveDiv").window({title:"修改-产品",iconCls:'icon-add',height:"550px",width:"650px",left:"50px",top:"30px"});
			$('#saveDiv').window('open');
		}
		
		// 进入修改页面
		function editEntity(){
			var node = getSelected();		
			if (node){	
				var url = '${ctx}/sysManage/orderproduct/initAddOrderProducts.do?id='+node.prodId;
				$('#saveFrame').attr("title","修改"+node.prodName);
				$('#saveFrame').attr("src",url);
				$("#saveDiv").window({title:"修改产品-"+node.prodName,iconCls:'icon-edit',height:"550px",width:"650px",left:"50px",top:"30px"});
				$('#saveDiv').window('open');
			}
		}
		
		//删除，物理删除
		function deleteEntity(){					
			var node = getSelected();	
			if(node){
		    	$.messager.confirm('确认','您确定要删除：<font color=red>'+node.orderId+'</font> ？',function(r){
		        	if(r){
						$.ajax({
							type: "post",
							url: "${ctx}/sysManage/orderproduct/delOrderProducts.do?id="+node.orderId,
							dataType: "json",
							success: function(data){
	    						if(data.flag==1){
	    							$.messager.confirm('提交结果', '操作成功', function(){
	    				    			winReload();// 刷新列表
	    							});
	    						}else if(data.flag==2){
	    							$.messager.alert('结果', data.msg, 'info');	
	    						}else if (data.flag == 3) {
									$.messager.alert('结果', '您还未登录，请先登录！', 'error', function(){
										document.location.href="${ctx}/sysManage/index.do";
									});
								}else{
	    							$.messager.alert('结果', '操作失败，请重试', 'error');	
	    						}
							},
							error:function(messg)  { 
					       	    $.messager.alert('错误提示', '操作失败:'+messg.responseText, 'error');
					       } 
						});
		          	}
		       });		             		
		    }	
		}
		
		// 判断是否选中一条记录
		function getSelected(){
			var selected = $('#dataPageList').datagrid('getSelected');
			if (selected){
				return selected;
			}else{
				$.messager.alert('提示', '请选择要操作的数据', 'info');
			}
		}
		
		// 点击取消按钮，关闭添加窗口
		function colseAdd(){
			$('#saveDiv').window('close');
		}
		
		// 刷新列表
		function winReload(){
			$('#dataPageList').datagrid('reload');
		}

	//查询
    function searchList(){					
	    	var queryParams = $('#dataPageList').datagrid('options').queryParams;
			$('#dataPageList').datagrid('options').pageNumber = 1;
			$('#dataPageList').datagrid('getPager').pagination({pageNumber: 1});
	    	//查询条件放到queryParams中：格式filter_params       
	        queryParams.filter_name = $('#filter_name').val();
	        $('#dataPageList').datagrid("reload");
   }
   
   //清空查询条件   
    function clearForm(){   
      	$('#dataPageList'). datagrid('clearSelections');  
	    $('#queryForm')[0].reset();  
    }
   
   
	</script>
</script>
</head>
<body>

	<div id="" class="easyui-panel" title="查询条件" collapsible="true" style="padding:5px;">
	    <form id="queryForm" name="queryForm">
		    <center style="line-height:22spx;padding:5px;">
			         姓名：
			       <span class="textbox easyui-fluid" style="width: 300px; height: 30px;">
			         <input type="text" id="filter_name" name="filter_name" size="20" class="textbox-text validatebox-text textbox-prompt" style="margin: 0px 0px 0px 0px; padding-top: 0px; padding-bottom: 0px; padding-left:3px; height: 30px; line-height: 30px; width: 300px;" autocomplete="off" />
			      </span>
			    <a href="javascript:void(0);" onclick="searchList();" class="easyui-linkbutton" iconCls="icon-search">查询</a>
			    <a href="javascript:void(0);" onclick="clearForm();" class="easyui-linkbutton" iconCls="icon-cancel">清空</a>
		    </center>
		</form>
	</div>

	<table id="dataPageList"></table>

	<!-- 添加窗口 -->
	<div id="saveDiv" class="easyui-window" title="用户信息" modal="false" style="padding:5px;width: 500px;height:230px;"
    	iconCls="icon-search" closed="true" maximizable="false" minimizable="false" collapsible="false">
   		<iframe frameborder="0"  id="saveFrame" height="100%" width="100%" scrolling="No" frameborder="0" ></iframe>
    </div>
</body>
</html>