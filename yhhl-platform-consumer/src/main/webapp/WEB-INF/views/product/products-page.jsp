<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html >
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Demo</title>
<%@ include file="/common/meta.jsp"%>
<%@ include file="/common/import.jsp"%>
<script type="text/javascript" src="${ctx}/js/money.js"></script>
<script type="text/javascript"
	src="${ctx}/js/WdatePicker/WdatePicker.js"></script>
<script type="text/javascript">
	function addEntity() {
		var url = "${ctx}/products/initAddProducts.do" + '?t=' + new Date();
		$('#saveFrame').attr("title", '');
		$('#saveFrame').attr("src", url);
		$("#saveDiv").window({
			title : "添加产品",
			iconCls : "icon-add",
			width : "650px",
			height : "550px",
			left : "50px",
			top : "30px"
		});
		$('#saveDiv').window('open');
		return false;
	}

	$(function() {
		$('#dataPageList').datagrid({
			title : '产品列表',
			iconCls : 'icon-ok',
			url : '${ctx }/products/getProductsDatas.do?t=' + new Date(),
			nowrap : false,
			striped : true,
			collapsible : true, // 可折叠
			fitColumns : true,
			pagination : true,
			singleSelect : true,
			rownumbers : true,
			remoteSort : false,
			pageList : [ 3, 5, 10, 50 ],
			idField : 'prodId',
			columns : [ [ {
				field : 'prodName',
				title : '商品名称',
				width : 100,
				sortable : true
			}, {
				field : 'unitPriceCost',
				title : '进货单价',
				width : 65,
				formatter : function(value) {
					return moneyFormatterNoY(value / 100);
				}
			},{
				field : 'unitPriceSell',
				title : '销售单价',
				width : 65
			}, {
				field : 'brands',
				title : '品牌',
				width : 100
			}, {
				field : 'unit',
				title : '单位',
				width : 50
			}, {
				field : 'properties',
				title : '参数',
				width : 100
			}, {
				field : 'mark',
				title : '标签',
				width : 100
			}, {
				field : 'type',
				title : '类型',
				width : 65
			}, {
				field : 'createTime',
				title : '添加时间',
				width : 100,
				sortable : true
			}, {
				field : 'modifyTime',
				title : '修改时间',
				width : 100,
				sortable : true
			}, {
				field:'button',title:'操作',width:100,align:'center',
					formatter:function(value,rec){
						var btn = '<a class="button-edit button-default l-btn l-btn-small" onclick="showProdStockData(\''+rec.prodId+'\',\''+rec.prodName+'\')" href="javascript:void(0)">';
						btn += '<span class="l-btn-left">';
						btn += '<span class="l-btn-text">添加库存</span>';
						btn += '</span>';
						btn += '</a>';
						return btn;
					}
			} ] ],
			toolbar : [ {
				text : '增加',
				iconCls : 'icon-add',
				handler : function() {
					saveEntity();
				}
			}, '-', {
				text : '增加产品详情',
				iconCls : 'icon-add',
				handler : function() {
					saveEntityDetail();
				}
			}, '-', {
				text : '删除',
				iconCls : 'icon-remove',
				handler : function() {
					deleteEntity();
				}
			}, '-', {
				text : '修改',
				iconCls : 'icon-edit',
				handler : function() {
					editEntity();
				}
			}, '-', {
				text : '刷新',
				iconCls : 'icon-reload',
				handler : function() {
					$('#dataPageList').datagrid('reload');
				}
			} ],
			onDblClickRow : function() {
				//dataItemTree();
			}
		});
	});

	function refresh() {
		var url = '${ctx}/products/getProductsDatas.action';
		$.ajax({
			type : "post",
			data : "",
			dataType : "",
			url : url,
			success : function(data, textStatus) {
				alert("OK");
			},
			error : function(messg) {
				alert("error");
			}
		});
	}

	function saveEntity() {
		$('#saveFrame').html('');
		var url = '${ctx}/products/initAddProducts.do';
		$('#saveFrame').attr("title", '');
		$('#saveFrame').attr("src", url);
		$("#saveDiv").window({
			title : "添加产品",
			iconCls : 'icon-add',
			height : "550px",
			width : "650px",
			left : "50px",
			top : "30px"
		});
		$('#saveDiv').window('open');
	}
	
	function saveEntityDetail() {
		var node = getSelected();
		if (node) {
			var url = '${ctx}/products/initAddProductsDetail.do?prodId='
					+ node.prodId;
			parent.addTab("添加产品详情-" + node.prodName, url);
		}
	}

	// 进入修改页面
	function editEntity() {
		var node = getSelected();
		if (node) {
			var url = '${ctx}/products/initAddProducts.do?id=' + node.prodId;
			$('#saveFrame').attr("title", "修改" + node.prodName);
			$('#saveFrame').attr("src", url);
			$("#saveDiv").window({
				title : "修改产品-" + node.prodName,
				iconCls : 'icon-edit',
				height : "550px",
				width : "650px",
				left : "50px",
				top : "30px"
			});
			$('#saveDiv').window('open');
		}
	}

	//删除，物理删除
	function deleteEntity() {
		var node = getSelected();
		if (node) {
			$.messager.confirm('确认', '您确定要删除：<font color=red>' + node.name
					+ '</font> ？', function(r) {
				if (r) {
					$.ajax({
						type : "post",
						url : "${ctx}/products/delProducts.do?id="
								+ node.prodId,
						dataType : "json",
						success : function(data) {
							if (data.flag == 1) {
								$.messager.confirm('提交结果', '操作成功', function() {
									winReload();// 刷新列表
								});
							} else if (data.flag == 2) {
								$.messager.alert('结果', data.msg, 'info');
							} else {
								$.messager.alert('结果', '操作失败，请重试', 'error');
							}
						},
						error : function(messg) {
							$.messager.alert('错误提示', '操作失败:'
									+ messg.responseText, 'error');
						}
					});
				}
			});
		}
	}

	// 判断是否选中一条记录
	function getSelected() {
		var selected = $('#dataPageList').datagrid('getSelected');
		if (selected) {
			return selected;
		} else {
			$.messager.alert('提示', '请选择要操作的数据', 'info');
		}
	}

	// 点击取消按钮，关闭添加窗口
	function colseAdd() {
		$('#saveDiv').window('close');
	}

	// 刷新列表
	function winReload() {
		$('#dataPageList').datagrid('reload');
	}

	//查询
	function searchList() {
		var queryParams = $('#dataPageList').datagrid('options').queryParams;
		$('#dataPageList').datagrid('options').pageNumber = 1;
		$('#dataPageList').datagrid('getPager').pagination({
			pageNumber : 1
		});
		//查询条件放到queryParams中：格式filter_params       
		queryParams.filter_name = $('#filter_name').val();
		$('#dataPageList').datagrid("reload");
	}

	//清空查询条件   
	function clearForm() {
		$('#dataPageList').datagrid('clearSelections');
		$('#queryForm')[0].reset();
	}
	
	
	function publishDetail(){
		var startDate = $("#startDate").val();
		var endDate = $("#endDate").val();
		$.ajax({
			type : "post",
			url : "${ctx}/products/publishProdDetails.do?startDate="+startDate+"&endDate="+endDate,
			dataType : "json",
			success : function(data) {
				if (data.flag == 1) {
					$.messager.alert('结果', data.msg, 'info');
				} else if (data.flag == 2) {
					$.messager.alert('结果', data.msg, 'error');
				} else {
					$.messager.alert('结果', '操作失败，请重试', 'error');
				}
			},
			error : function(messg) {
				$.messager.alert('错误提示', '操作失败:'
						+ messg.responseText, 'error');
			}
		});
	}
	//////////////////商品规格、颜色、库存管理//////////////////////
	// 库存列表		
	function showProdStockData(prodId,prodName){
		$('#dataItemPageList').datagrid({
			title:'库存列表-商品ID【'+prodName+'】',
			iconCls:'icon-ok',
			url:'${ctx }/stocks/getStocksDatas.do?filter_prodId='+prodId+'&t='+new Date(),
			nowrap: false,
			striped: true,
			collapsible:false,				
			fitColumns: true,
			pagination:true,
			singleSelect:true,
			rownumbers:true,
			remoteSort: false,
			pageList:[3,5,10,50],
			idField:'stockId',
			columns:[[
				{field:'prodId',title:'商品编号',width:100,sortable:true},
				{field:'colorsId',title:'颜色名称',width:100,sortable:true},
				{field:'specificationId',title:'规格',width:100},
				{field:'remainNum',title:'库存数量',width:100,sortable:true},
				{field:'selledNum',title:'已售数量',width:100,sortable:true}
			]],
			toolbar:[{
				text:'增加',
				iconCls:'icon-add',
				handler:function(){
					saveEntityExtend();
				}
			},'-',{
				text:'修改',
				iconCls:'icon-edit',
				handler:function(){
					editProductExtend();
				}
			},'-',{
				text:'删除',
				iconCls:'icon-remove',
				handler:function(){
					deleteProductExtend();
				}
			},'-',{
				text:'刷新',
				iconCls:'icon-reload',
				handler:function(){
					$('#dataItemPageList').datagrid('reload');
				}
			}
			],
			onDblClickRow:function(){
				
			}
		});
	}
	
	// 判断是否选中一条记录
	function getSelectedProductsExtend() {
		var selected = $('#dataItemPageList').datagrid('getSelected');
		if (selected) {
			return selected;
		} else {
			$.messager.alert('提示', '请选择要操作的数据', 'info');
		}
	}
	
	function saveEntityExtend() {
		var node = getSelected(); // 获取商品ID
		if(node){
			$('#saveFrame').html('');
			var url = '${ctx}/stocks/initAddStocks.do?prodId='+node.prodId;
			$('#saveFrame').attr("title", '');
			$('#saveFrame').attr("src", url);
			$("#saveDiv").window({ title : "添加库存",iconCls : 'icon-add',height : "550px",width : "650px",
				left : "50px",
				top : "30px"
			});
			$('#saveDiv').window('open');
		}
	}
	
	function editProductExtend() {
		var node = getSelectedProductsExtend(); // 获取库存ID
		if(node){
			$('#saveFrame').html('');
			var url = '${ctx}/stocks/initAddStocks.do?stockId='+node.stockId;
			$('#saveFrame').attr("title", '');
			$('#saveFrame').attr("src", url);
			$("#saveDiv").window({ title : "修改库存",iconCls : 'icon-add',height : "550px",width : "650px",
				left : "50px",
				top : "30px"
			});
			$('#saveDiv').window('open');
		}
	}
	
	// 刷新列表
	function productExtendReload(){
		$('#dataItemPageList').datagrid('reload');
	}
</script>
</script>
</head>
<body>

	<div id="" class="easyui-panel" title="查询条件" collapsible="true"
		style="padding: 5px;">
		<form id="queryForm" name="queryForm">
			<center style="line-height: 22spx; padding: 5px;">
				产品名称： <span class="textbox easyui-fluid"
					style="width: 350px; height: 30px;"> <input type="text"
					id="filter_prodName" name="filter_prodName" size="20"
					class="textbox-text validatebox-text textbox-prompt"
					style="margin: 0px 0px 0px 0px; padding-top: 0px; padding-bottom: 0px; padding-left: 3px; height: 30px; line-height: 30px; width: 350px;"
					autocomplete="off" />
				</span> <a href="javascript:void(0);" onclick="searchList();"
					class="easyui-linkbutton" iconCls="icon-search">查询</a> <a
					href="javascript:void(0);" onclick="clearForm();"
					class="easyui-linkbutton" iconCls="icon-cancel">清空</a>
			</center>
		</form>
		<form id="publishProductsDetailForm" action="">
			<center style="line-height: 22spx; padding: 5px;">
				开始日期： <span class="textbox easyui-fluid"
					style="width: 150px; height: 30px;"><input type="text" id="startDate" name="startDate"
					class="textbox-text validatebox-text textbox-prompt"
					style="margin: 0px 0px 0px 0px; padding-top: 0px; padding-bottom: 0px; padding-left: 3px; height: 30px; line-height: 30px; width: 150px;"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})"></span>
				&nbsp;&nbsp;结束日期： <span class="textbox easyui-fluid"
					style="width: 150px; height: 30px;"><input
					type="text" id="endDate" name="endDate" class="textbox-text validatebox-text textbox-prompt"
					style="margin: 0px 0px 0px 0px; padding-top: 0px; padding-bottom: 0px; padding-left: 3px; height: 30px; line-height: 30px; width: 150px;"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})"></span>
				<a href="javascript:void(0);" onclick="publishDetail();"
					class="easyui-linkbutton" iconCls="icon-print">生成商品详情静态页面</a>	
			</center>
		</form>
	</div>

	<table id="dataPageList"></table>

	<!-- 添加窗口 -->
	<div id="saveDiv" class="easyui-window" title="用户信息" modal="false"
		style="padding: 5px; width: 500px; height: 230px;"
		iconCls="icon-search" closed="true" maximizable="false"
		minimizable="false" collapsible="false">
		<iframe frameborder="0" id="saveFrame" height="100%" width="100%"
			scrolling="No" frameborder="0"></iframe>
	</div>
	
	<!-- 库存列表 -->
    <table id="dataItemPageList"></table>
</body>
</html>