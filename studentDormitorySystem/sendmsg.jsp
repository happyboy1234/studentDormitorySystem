<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.List" %>
<%@ page import="com.sofency.entry.message" %>
<%@ page import="com.sofency.Dao.apacheDao" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.ParseException" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>发说说</title>
    <link rel="stylesheet" type="text/css" href="css/reset.css"/>
    <script src="js/jquery.js"></script>
    <style>
        #canvas{
            width:100%;
            height:500px;
            overflow: hidden;
            top:0;
            left:0;
            background-color: #1a1724;
        }
        .canvas-wrap{
            height: 100px;
        }
        li .showname{
            margin-right: -10px;
            width: 400px;
            color: black;
        }
        li .container{
            width: 1160px;
            margin-left: 20px;
            margin: 10px auto;
            box-sizing: border-box;
            border-radius: 5px;
            height: 100px;
            border: 1px solid #ccc;
        }
        li .showname .left{
            display: inline-block;
            width: 70px;
            height: 70px;
        }
        li .showname .left .userimg{
            width: 60px;
            height: 60px;
            border-radius: 50%;
        }
        li .showname .right{
            display: inline-block;
            vertical-align: top;
        }

        li .showname .right .username{
            height: 30px;
        }
        li .showname .right .timesend{
            height: 30px;
        }

        li .containerText{
            padding: 5px;
            height: 60px;
        }
        li .container-comment{
            display: inline-block;
            float: right;
            margin-right: 120px
        }
        li .container-comment img{
            width: 22.5px;
            height: 16px;
        }


    </style>
</head>
<body style="overflow-x: hidden;overflow-y: auto">

<%
    String uaccount = request.getParameter("uaccount");//获取账户
    String uname = request.getParameter("uname");//获取名字
    List<message> list = apacheDao.searchMessage();
%>
<section class="canvas-wrap" >
    <div id="canvas" class="gradient" style="height: 100px"></div>
</section>
<script src="js/three.min.js"></script>
<script src="js/projector.js"></script>
<script src="js/canvas-renderer.js"></script>
<script src="js/3d-lines-animation.js"></script>
<script src="js/color.js"></script>


<div class="sendmsg" style="display: block;width: 100%;z-index: 2000;
background-color: rgba(255,255,255,1);border: 1px solid #ccc">
    <button class="back" style="cursor:pointer;width: 80px;height: 30px;text-align: center;line-height: 30px;border-radius: 5px;background-color: #ccc;" onclick="back()">返回</button>
    <div class="container-border" style="border: 1px solid #ccc;width: 1300px;height: inherit;margin: 0 auto;">
        <!--发送信息-->
        <div class="middle-msg" style="width: 1200px;height: 120px;margin: 40px auto;">
            <textarea name="message" id="message" style="width: 100%;height: 120px; box-sizing: border-box;resize: none;border-radius: 10px"placeholder="请在这里输入"></textarea><br>
            <div style="display: inline-block;float: right">
                <button onclick="sendmsg()">发布</button>&nbsp;&nbsp;<button onclick="clearmsg()" >清空</button>
            </div>

            <script type="text/javascript">
                function back() {
                    history.back();
                }
                function sendmsg() {
                    <%
                       SimpleDateFormat f=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");//24小时  hh是12小时的
                       Date date = new Date();
                       String sqlDate = f.format(date);
                    %>
                    var uaccount ="<%=uaccount%>";
                    var uname = "<%=uname%>";
                    var messagetime = "<%=sqlDate%>";
                    var messageContext = $("#message").val();
                    $.ajax({
                        url:"messageServlet",
                        type:"post",
                        data:{
                            "uaccount":uaccount,
                            "uname":uname,
                            "messagetime":messagetime,
                            "messageContext":messageContext
                        },
                        success:function (data) {
                            if("ok"== data){
                                window.location.reload();//加载信息
                            }else if("false"==data){
                                alert("失败了");
                            }
                        }
                    })
                }

                function clearmsg(){
                    $("#message").val('');
                }
            </script>
        </div>
        <!--显示信息-->
        <ul>
            <%
                if(list!=null){
                    for(message msg:list){
            %>
                    <li>
                        <div class="showname">
                            <div class="left" ><img  class="userimg"  src="<%=request.getContextPath()+"/image/"+apacheDao.findImgPath(msg.getUaccount())%>" alt=""></div>
                            <div class="right">
                                <div class="username" ><%=msg.getUname()%></div>
                                <div class="uaccount" style="display: none;"><%=msg.getUaccount()%></div>
                                <div class="timesend"><%=msg.getMessagetime()%></div>
                            </div>
                        </div>
                        <div class="container">
                            <div class="containerText">
                                <%=msg.getMessageContext()%>
                            </div>
                            <div class="container-comment" >
                                <%
                                    //向数据库中查找是否点赞
                                    Object[] obj ={uaccount,msg.getMessagetime(),msg.getUaccount()};
                                    String test = apacheDao.findIsCancel(obj);
                                    if(test.equals("ok")){
                                %>
                                <img  class="noclick" src="image/click.png" alt="点赞" onclick="clickzan(this)">
                                <%
                                    }else{
                                %>
                                <img  class="noclick" src="image/noclick.png" alt="点赞" onclick="clickzan(this)">
                                <%
                                    }
                                %>
                                &nbsp;&nbsp;<img class="comment" src="image/comment.png" alt="评论" onclick="">
                            </div>
                        </div>
                    </li>
            <%
                    }
                }
            %>
        </ul>
        <script type="text/javascript">
            var flag =true;
            function clickzan(js){
                //获取点赞的时间
                <%
                //获取点赞时间
                   SimpleDateFormat f1=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");//24小时  hh是12小时的
                   Date dianzanTime = new Date();
                   String dianzan = f.format(date);
                %>
                //获取发消息账户的id
                var message_uaccount = $(js).parent().parent().parent().children(".showname").children(".right").children(".uaccount").text();
                //获取发送文章的时间(主键)
                var message_time = $(js).parent().parent().parent().children(".showname").children(".right").children(".timesend").text();
                //获取当前用户的账户即点赞的账户
                var uaccount="<%=uaccount%>";
                //当前点赞的时间
                var dianzan = "<%=dianzan%>";

                //查询作者文章是否被当前用户所点过赞
                $.ajax({
                    url:"findIsCancelServlet",
                    type:"post",
                    async:true,
                    data:{
                        "messageuAuthor":message_uaccount,
                        "uaccount":uaccount,
                        "messageTime":message_time
                    },
                    success:function(data){
                        alert(data);
                        if(data=="ok"){//点赞了则清除点赞记录
                            $(js).attr("src","image/noclick.png");
                            //向数据库中进行删除操作
                           $.ajax({
                               async:false,
                               url:"deleteDianZanServlet",
                               type:"post",
                               data:{
                                   "messageAuthor":message_uaccount,
                                   "uaccount":uaccount,
                                   "messageTime":message_time
                               },
                               success:function(re){
                                   if(re==1)  alert("取消点赞");
                                   else alert("取消失败");
                               }
                           })

                        }else if(data=="false") {//没有点赞插入记录

                            //向数据库中进行添加操作
                            $.ajax({
                                async:false,
                                url:"insertDianZanServlet",
                                type:"post",
                                data:{
                                    "Author":message_uaccount,
                                    "account":uaccount,
                                    "Time":message_time,
                                    "dianzan":dianzan,
                                    "isDianZan":"1"
                                },
                                success:function(re){
                                    if(re==1) {
                                        $(js).attr("src","image/click.png");
                                        alert("点赞成功");
                                    } else {
                                        alert("点赞失败");
                                    }
                                }
                            })

                        }
                    }
                })
            }
        </script>
    </div>
</div>

</body>
</html>
