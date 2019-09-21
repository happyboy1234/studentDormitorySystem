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
        .containerText{
            padding: 5px;
            height: 60px;
        }
        .container-comment{
            display: inline-block;
            float: right;
            margin-right: 120px
        }
        .container-comment img{
            width: 22.5px;
            height: 16px;
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
        <div class="middle-msg" style="width: 1200px;height: 120px;margin: 40px auto;border: 1px solid #ccc;">
            <textarea name="message" id="message" style="width: 100%;height: 120px; box-sizing: border-box;resize: none"placeholder="请在这里输入"></textarea><br>
            <div style="display: inline-block;float: right">
                <button onclick="sendmsg()">发布</button>&nbsp;&nbsp;<button onclick="clearmsg()" >清空</button>
            </div>

            <script type="text/javascript">
                function back() {
                    history.back();
                }
                function sendmsg() {
                    <%
                       SimpleDateFormat f=new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");//24小时
                       Date date = new Date();
                       String sqlDate = f.format(date);
                    %>
                    var uaccount ="<%=uaccount%>";
                    var uname = "<%=uname%>";
                    var messagetime = "<%=sqlDate%>";
                    var messageContext = $("#message").val();
                    var src = 'image/'+"<%=apacheDao.findImgPath(uaccount)%>";

                    alert(uaccount+"--"+uname+"--"+messagetime+"--"+messageContext+"--"+src);
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
                                var li = document.createElement("li");

                                //显示名字
                                var showname = document.createElement("div");
                                showname.className="showname";
                                showname.textContent = "<%=uname%>";
                                //写showname的孩子

                                var left = document.createElement("div");
                                left.className="left";
                                var userfont = document.createElement("img");
                                userfont.className="userimg";
                                userfont.src=src;
                                left.appendChild(userfont);

                                var right = document.createElement("div");
                                right.className="right";
                                var username = document.createElement("div");
                                username.className="username";
                                username.textContent=uname;
                                var timesend = document.createElement("div");
                                timesend.className="timesend";
                                timesend.textContent=messagetime;

                                right.appendChild(username);
                                right.appendChild(timesend);
                                showname.appendChild(left);
                                showname.appendChild(right);

                                var contain = document.createElement("div");
                                contain.className="container";

                                //显示发布的消息
                                var text = document.createElement("div");
                                text.className="containerText";
                                text.textContent=messageContext;
                                //构造评论的点赞信息
                                var comment = document.createElement("div");
                                comment.className ="container-comment";
                                var img1 = document.createElement("img");
                                img1.src="image/noclick.png";
                                var img2 = document.createElement("img");
                                img2.src="image/click.png";
                                comment.appendChild(img1);
                                comment.appendChild(img2);

                                contain.appendChild(text);
                                contain.appendChild(comment);


                                li.appendChild(showname);
                                li.appendChild(contain);
                                $("ul").prepend(li);
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
                                <div class="timesend"><%=msg.getMessagetime()%></div>
                            </div>
                        </div>
                        <div class="container">
                            <div class="containerText">
                                <%=msg.getMessageContext()%>
                            </div>
                            <div class="container-comment" >
                                <img  src="image/noclick.png" alt="点赞">&nbsp;&nbsp;<img src="image/click.png" alt="评论">
                            </div>
                        </div>
                    </li>
            <%
                    }
                }
            %>
        </ul>
    </div>
</div>

</body>
</html>
