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
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

    <script type="text/javascript">

        //默认情况下取消和保存按钮是隐藏的
        var cancelAndSaveBtnDefault = true;

        $(function(){
            $("#remark").focus(function(){
                if(cancelAndSaveBtnDefault){
                    //设置remarkDiv的高度为130px
                    $("#remarkDiv").css("height","130px");
                    //显示
                    $("#cancelAndSaveBtn").show("2000");
                    cancelAndSaveBtnDefault = false;
                }
            });

            $("#cancelBtn").click(function(){
                //显示
                $("#cancelAndSaveBtn").hide();
                //设置remarkDiv的高度为130px
                $("#remarkDiv").css("height","130px");
                cancelAndSaveBtnDefault = true;
            });

            $(".remarkDiv").mouseover(function(){
                $(this).children("div").children("div").show();
            });

            $(".remarkDiv").mouseout(function(){
                $(this).children("div").children("div").hide();
            });

            $(".myHref").mouseover(function(){
                $(this).children("span").css("color","blue");
            });

            $(".myHref").mouseout(function(){
                $(this).children("span").css("color","#E6E6E6");
            });
            showRemark();
            $("#remarkBody").on("mouseover",".remarkDiv",function(){
                $(this).children("div").children("div").show();
            })
            $("#remarkBody").on("mouseout",".remarkDiv",function(){
                $(this).children("div").children("div").hide();
            })
            // editRemark("111");

            //修改备注的更新按钮
            $("#updateRemarkBtn").click(function () {
                var noteContent = $("#noteContent").val();
                // window.alert(noteContent)
                var id = $("#remarkId").val();
                // window.alert(id)
                $.ajax({
                    url:"workbench/activity/editRemark.do",
                    data:{
                        "id":id,
                        "noteContent":noteContent
                    },
                    type:"post",
                    dataType:"json",
                    success:function (data) {
                        // window.alert(data)
                        if (data.success){
                            $("#n"+id).html(data.activityRemark.noteContent)
                            $("#s"+id).html(data.activityRemark.editTime+" 由"+data.activityRemark.editBy)
                            $("#editRemarkModal").modal("hide");
                        }else {
                            window.alert("更新失败")
                        }

                    }
                })
                $("#updateRemarkBtn").blur()
            });
            //添加备注
            $("#remarkSaveButton").click(function () {
                // window.alert("添加备注")
                var noteContent = $.trim($("#remark").val())
                window.alert(noteContent)
                if (noteContent==""){
                    window.alert("备注信息不能为空")
                }else {
                    // window.alert(noteContent)
                    var activityId="${a.id}";
                    $.ajax({
                        url:"workbench/activity/addRemark.do",
                        data:{
                            "noteContent":noteContent,
                            "activityId":activityId
                        },
                        type:"post",
                        dataType:"json",
                        success:function (data) {
                            //返回一个success和activityRemark单条
                            if (data.success){
                                var html=""
                                html ="<div class=\"remarkDiv\" id = 'div"+data.activityRemark.id+"' style=\"height: 60px;\">\n" +
                                    "<img title=\""+data.activityRemark.id+"\" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">\n" +
                                    "<div style=\"position: relative; top: -40px; left: 40px;\" >\n" +
                                    "<h5 id = 'n"+data.activityRemark.id+"'>"+data.activityRemark.noteContent+"</h5>\n" +
                                    "<font color=\"gray\">市场活动</font> <font color=\"gray\">-</font> <b>${a.name}</b> <small style=\"color: gray;\" id = 's"+data.activityRemark.id+"'> "+(data.activityRemark.editFlag==0?data.activityRemark.createTime:data.activityRemark.editTime)+" 由 "+(data.activityRemark.editFlag==0?data.activityRemark.createBy:data.activityRemark.editBy)+"</small>\n" +
                                    "<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">\n" +
                                    "<a class=\"myHref\" href=\"javascript:void(0);\" onclick=\"editRemark('"+data.activityRemark.id+"')\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #FF0000;\"></span></a>\n" +
                                    "&nbsp;&nbsp;&nbsp;&nbsp;\n" +
                                    "<a class=\"myHref\" href=\"javascript:void(0);\" onclick=\"deleteRemark('"+data.activityRemark.id+"')\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>\n" +
                                    "</div>\n" +
                                    "</div>\n" +
                                    "</div>"
                                // window.alert(data)
                                $("#remarkDiv").before(html);
                                $("#remark").val("");
                            }else {
                                window.alert("添加备注失败")
                            }
                        }
                    })
                }

                $("#remarkSaveButton").blur()
            })


        });
        //修改备注
        function editRemark(id) {
            // window.alert(id)
            $("#editRemarkModal").modal("show");
            $("#remarkId").val(id)
            var noteContent = $("#n"+id+"").html()
            // window.alert(noteContent)
            $("#noteContent").val(noteContent)
        };
        //删除备注
        function deleteRemark(id) {
            // window.alert(id)
            if(confirm("确定删除备注吗？")){
                // window.alert(id)
                $.ajax({
                    url:"workbench/activity/deleteRemark.do",
                    data:{
                        "id":id
                    },
                    type:"post",
                    dataType:"json",
                    success:function (data) {
                        if(data.success){
                            $("#div"+id+"").remove()
                        }else{
                            window.alert("删除失败")
                        }
                    }
                })
            }
        };
        //展示备注
        function showRemark() {
            $.ajax({
                url:"workbench/activity/showRemark.do",
                data:{
                    "activityId":"${a.id}"
                },
                type:"get",
                dataType:"json",
                success:function (data) {
                    // window.alert(data)
                    // eval("var dataObject = "+data)
                    //需要返回一个备注信息列表activityRemarkList和success
                    //     var data = data.activityRemarkList
                    var html = ""
                    $.each(data,function (i,n) {
                        html+="<div class=\"remarkDiv\" id = 'div"+n.id+"' style=\"height: 60px;\">\n" +
                        "<img title=\""+n.id+"\" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">\n" +
                        "<div style=\"position: relative; top: -40px; left: 40px;\" >\n" +
                        "<h5 id = 'n"+n.id+"'>"+n.noteContent+"</h5>\n" +
                        "<font color=\"gray\">市场活动</font> <font color=\"gray\">-</font> <b>${a.name}</b> <small style=\"color: gray;\" id = 's"+n.id+"'> "+(n.editFlag==0?n.createTime:n.editTime)+" 由 "+(n.editFlag==0?n.createBy:n.editBy)+"</small>\n" +
                        "<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">\n" +
                        "<a class=\"myHref\" href=\"javascript:void(0);\" onclick=\"editRemark('"+n.id+"')\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #FF0000;\"></span></a>\n" +
                        "&nbsp;&nbsp;&nbsp;&nbsp;\n" +
                        "<a class=\"myHref\" href=\"javascript:void(0);\" onclick=\"deleteRemark('"+n.id+"')\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>\n" +
                        "</div>\n" +
                        "</div>\n" +
                        "</div>"
                        // html="<div>aaa</div>"


                    });
                    $("#remarkDiv").before(html);




                }
            })

        }

    </script>

</head>
<body>

<!-- 修改市场活动备注的模态窗口 -->
<div class="modal fade" id="editRemarkModal" role="dialog">
    <%-- 备注的id --%>
    <input type="hidden" id="remarkId">
    <div class="modal-dialog" role="document" style="width: 40%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" >修改备注</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">内容</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="noteContent"></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
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
                <h4 class="modal-title" id="myModalLabel">修改市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-marketActivityOwner">
                                <option>zhangsan</option>
                                <option>lisi</option>
                                <option>wangwu</option>
                            </select>
                        </div>
                        <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-startTime" value="2020-10-10">
                        </div>
                        <label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-endTime" value="2020-10-20">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-cost" value="5,000">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-describe">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal">更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 返回按钮 -->
<div style="position: relative; top: 35px; left: 10px;">
    <a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
</div>

<!-- 大标题 -->
<div style="position: relative; left: 40px; top: -30px;">
    <div class="page-header">
        <h3>市场活动-${a.name} <small>${a.startDate} ~ ${a.endDate}</small></h3>
    </div>
    <div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
        <button type="button" class="btn btn-default" data-toggle="modal" data-target="#editActivityModal"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
        <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
    </div>
</div>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${a.owner}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${a.name}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>

    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">开始日期</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${a.startDate}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${a.endDate}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">成本</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${a.cost}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${a.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${a.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${a.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${a.editTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${a.description}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div style="position: relative; top: 30px; left: 40px;" id="remarkBody">
    <div class="page-header">
        <h4>备注</h4>
    </div>

    <!-- 备注1 -->


    <!-- 备注2 -->
    <div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
        <form role="form" style="position: relative;top: 10px; left: 10px;">
            <textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
            <p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
                <button id="cancelBtn" type="button" class="btn btn-default">取消</button>
                <button type="button" class="btn btn-primary" id="remarkSaveButton">保存</button>
            </p>
        </form>
    </div>
</div>
<div style="height: 200px;" ></div>
</body>
</html>