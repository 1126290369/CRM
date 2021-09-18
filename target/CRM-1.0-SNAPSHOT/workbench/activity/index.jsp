<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + 	request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css" />
<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

<script type="text/javascript">

	$(function(){
		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});
		$("#createButton").click(function () {

			$.ajax({
				url:"workbench/activity/getUserList.do",
				// data:"",
				type:"get",
				datatype:"json",
				success:function (data) {
					// window.alert(data)
					eval("var data1="+data)

					var html = ""
					$.each(data1,function (i,j) {
						// window.alert(j)
						html+="<option value='"+j.id+"'>"+j.name+"</option>"
					})

					$("#create-marketActivityOwner").html(html)
					var default_id = "${user.id}"
					// window.alert(default_id)
					$("#create-marketActivityOwner").val(default_id)


					$("#createActivityModal").modal("show")



				}
			})

		})
		$("#saveModal").click(function () {

			// window.alert("1")
			$.ajax({
				url:"workbench/activity/saveActivity.do",
				data:{
					"owner":$("#create-marketActivityOwner").val(),
					"name":$("#create-marketActivityName").val(),
					"startDate":$("#create-startTime").val(),
					"endDate":$("#create-endTime").val(),
					"cost":$("#create-cost").val(),
					"describe":$("#create-describe").val()
				},
				type:"post",
				datatype:"json",
				success:function (data) {
					// window.alert(data)
					eval("var dataObject ="+data)
					// window.alert(dataObject.success)
					if (dataObject.success){
						$("#AddForm")[0].reset();
						$("#createActivityModal").modal("hide");
						updateActivityList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
					}else {
						window.alert("保存失败")
					}

				}
			})
		});
        updateActivityList(1,2);
		$("#search-button").click(function () {
			$("#search-button").blur();
			$("#hidden-name").val($.trim($("#search-name").val()))
			$("#hidden-owner").val($.trim($("#search-owner").val()))
			$("#hidden-startDate").val($.trim($("#search-startDate").val()))
			$("#hidden-endDate").val($.trim($("#search-endDate").val()))
			updateActivityList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
			// window.alert("a")
		});

		$("#qx").click(function () {

			$("input[name=xz]").prop("checked",this.checked)
		});
		$("#activityList").on("click",$("input[name=xz]"),function () {
			$("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length)
		});



		$("#delete-button").click(function () {

			var $name =$("input[name=xz]:checked")
			if ($name.length==0){
				window.alert("请勾选需要删除的记录");
			}else {

				// window.alert("删除操作");
				var checkedList =""
				for (i=0;i<$name.length;i++){
					checkedList += "id="+$name[i].value;
					if (i<$name.length-1){
						checkedList+="&"
					}
				}
				// window.alert(checkedList)
				if (confirm("确定删除数据吗？")){
					$.ajax({
						url:"workbench/activity/delete.do",
						data:checkedList,
						type:"get",
						datatype:"json",
						success:function (data) {

							eval("var dataObject = "+data)
							// window.alert(dataObject)
							if (dataObject.success){
								updateActivityList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
							}else {
								window.alert("删除失败！")
							}

						}
					})
				}



			};
		});
		$("#edit-button").click(function () {

			// window.alert("xiugai")
			var $name =$("input[name=xz]:checked")
			if($name.length==0){
				window.alert("请勾选需要修改的数据")
			}else if($name.length>=2){
				window.alert("只可同时一条数据")
			}else{
				var id = $("input[name=xz]:checked")[0].value
				// window.alert(id)
				$.ajax({
					url:"workbench/activity/edit.do",
					data:{
						"id":id
					},
					type:"get",
					datatype:"json",
					success:function (data) {
						//返回userList和单选id为选中单元id的activity
						eval("var dataObject ="+data)
						var html = ""
						$.each(dataObject.userList,function (a,b) {
							html+="<option value='"+b.id+"'>"+b.name+"</option>"
						})
						$("#edit-marketActivityOwner").html(html);
						$("#edit-marketActivityOwner").val(dataObject.activity.owner)



						$("#edit-marketActivityName").val(dataObject.activity.name)
						$("#edit-startTime").val(dataObject.activity.startDate)
						$("#edit-endTime").val(dataObject.activity.endDate)
						$("#edit-cost").val(dataObject.activity.cost)
						$("#edit-describe").val(dataObject.activity.description)
						$("#editActivityModal").modal("show")


					}

				})
			}
		})

		$("#updateButton").click(function () {
			$.ajax({
                url:"workbench/activity/update.do",
                data:{
                	"id":$.trim($("input[name=xz]:checked").val()),
                    "owner":$.trim($("#edit-marketActivityOwner").val()),
                    "name":$.trim($("#edit-marketActivityName").val()),
                    "startTime":$.trim($("#edit-startTime").val()),
                    "endTime":$.trim($("#edit-endTime").val()),
                    "cost":$.trim($("#edit-cost").val()),
                    "describe":$.trim($("#edit-describe").val())
                },
                type:"post",
                datatype:"json",
                success:function (data) {

                    eval("var dataObject = "+data)
                    if (dataObject.success){
                        $("#editActivityModal").modal("hide");
                        updateActivityList($("#activityPage").bs_pagination('getOption', 'currentPage')
                            ,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

                    }
                }

            })

		})




		
	});






	function updateActivityList(pageNo,pageSize) {
		$("#qx").prop("checked",false)
		// window.alert(pageNo)
		$("#search-name").val($.trim($("#hidden-name").val()))
		$("#search-owner").val($.trim($("#hidden-owner").val()))
		$("#search-startDate").val($.trim($("#hidden-startDate").val()))
		$("#search-endDate").val($.trim($("#hidden-endDate").val()))
	    $.ajax({
            url:"workbench/activity/activityList.do",
            data:{
                "pageNo":pageNo,
                "pageSize":pageSize,
                "name":$("#search-name").val(),
                "owner":$("#search-owner").val(),
                "startDate":$("#search-startDate").val(),
                "endDate":$("#search-endDate").val()

            },
            type:"get",
            datatype:"json",
            success:function (data) {
                eval("var dataObject = "+data)
				// window.alert("123")
                //data里有activityList和total
                var html = ""
                $.each(dataObject.activityList,function (a,b) {
                    html+="<tr class=\"active\">\n" +
                        "<td><input type=\"checkbox\" name='xz' value='"+b.id+"'/></td>\n" +
                        "<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/activity/detail.do?id="+b.id+"';\">"+b.name+"</a></td>\n" +
                        "<td>"+b.owner+"</td>\n" +
                        "<td>"+b.startDate+"</td>\n" +
                        "<td>"+b.endDate+"</td>\n" +
                        "</tr>"

                })
                $("#activityList").html(html)
				var totalPages = dataObject.total%pageSize==0?dataObject.total/pageSize:parseInt(dataObject.total/pageSize)+1
                $("#activityPage").bs_pagination({
                    currentPage: pageNo, // 页码
                    rowsPerPage: pageSize, // 每页显示的记录条数
                    maxRowsPerPage: 20, // 每页最多显示的记录条数
                    totalPages: totalPages, // 总页数
                    totalRows: dataObject.total, // 总记录条数

                    visiblePageLinks: 3, // 显示几个卡片

                    showGoToPage: true,
                    showRowsPerPage: true,
                    showRowsInfo: true,
                    showRowsDefaultInfo: true,

                    onChangePage : function(event, data){
						updateActivityList(data.currentPage , data.rowsPerPage);
                    }
                });

            }

        })


    }



	
</script>
</head>
<body>
<input type="hidden" id="hidden-name">
<input type="hidden" id="hidden-owner">
<input type="hidden" id="hidden-startDate">
<input type="hidden" id="hidden-endDate">

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form" id="AddForm">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityOwner">

								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-startTime" readonly>
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-endTime" readonly>
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveModal">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-marketActivityOwner">
								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-startTime">
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-endTime">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateButton">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control time" type="text" id="search-startDate" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control time" type="text" id="search-endDate">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="search-button">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createButton"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="edit-button"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger " id="delete-button"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx"/></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="activityList">
						
                        
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;">
				<div id="activityPage"></div>

			</div>
			
		</div>
		
	</div>
</body>
</html>