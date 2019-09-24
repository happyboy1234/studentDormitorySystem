<%@ page import="com.sofency.Dao.apacheDao" %>
<%@ page import="java.util.List" %>
<%@page contentType="text/html;charset=utf-8" language="java"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>宿舍的小窝</title>
    <link rel="stylesheet" type="text/css" href="css/reset.css"/>
    <script src="js/jquery.js"></script>
    <link rel="stylesheet" href="css/system.css">
</head>
<body>
<header>
    <div class="head-left">舍友签到情况</div>
    <div class="head-right">
        <%
            //获取账户
            String uaccount = request.getParameter("uaccount");
            //根据账户查询图片
            String imgpath = apacheDao.findImgPath(uaccount);//内存的路径
            String imgPath = request.getContextPath()+"/image/"+imgpath;//真实服务器上的路径
            //根据账户查询学生的信息
            String dornum = apacheDao.findRoomNum(uaccount);
            List<Object[]> listsign = apacheDao.findSign(dornum);//根据宿舍号查询到宿舍的签到情况
            Object[] object={uaccount};
            Object[] usermsg=  apacheDao.searchusermsg(object);//查询学生信息
        %>
        <img src="<%=imgPath%>" class="userimg" alt="userimg" title="瞅我干啥">
        <a href="showmsg.jsp?uaccount=<%=uaccount%>">消息</a>
        <a href="#" onclick="showWin()">我的资料</a>
        <a href="sendmsg.jsp?uaccount=<%=uaccount%>&uname=<%=usermsg[1]%>">发趣事</a>
        <a href="#" onclick="sign()">签到</a>
        </div>
    </div>
</header>
<article>
    <main>
        <table>
            <thead>
                <tr>
                    <td>姓名</td>
                    <td>学号</td>
                    <td>出生日期</td>
                    <td>是否单身</td>
                    <td>今日签到时间</td>
                    <td>本周签到次数</td>
                    <td>本周签到率</td>
                </tr>
            </thead>
            <tbody>
                <%
                    for(Object[] obj:listsign){
                %>
                <tr>
                    <td ><%=obj[0]%></td>
                    <td ><%=obj[1]%></td>
                    <td ><%=obj[2]%></td>
                    <td ><%=obj[3]%></td>
                    <td ><%=obj[4]%></td>
                    <td ><%=obj[5]%></td>
                    <td ><span><%=obj[6]%>%</span></span><meter high="7" low="0" max="7" min="0" value="<%=obj[5]%>"></meter></td>
                </tr>
                <%
                    }
                %>
                <script>
                    <!--设置样式-->
                    $("tr:contains(<%=uaccount%>)").css("backgroundColor","#dff9fb");
                    $("tr").css("height","50px").css("border","1px solid #ccc");
                    $("tr td").css("border","1px solid #ccc").css("width","180px");
                    $("tr td:nth-child(4)").css("width","100px");
                    $("tr td:nth-child(6)").css("width","140px");
                    $("tr td:nth-child(7)").css("width","300px");
                </script>
            </tbody>
        </table>
    </main>
</article>

<div class="changeUserMsg" >
    <div class="loginUsermsg" >

        <h1 style="font-size: 30px;margin-bottom: 10px">我的资料</h1>
        <div><label for="fontimg">头像</label><input type="text" id="fontimg" name="fontimg"></div>
        <div><label for="signText">签名</label><input type="text" value="<%=usermsg[0]%>" id="signText" name="signText"></div>
        <div><label for="username">姓名</label><input type="text" value="<%=usermsg[1]%>" id= "username" name="username"/></div>
        <div><label for="usersex">性别</label><input type="text" value="<%=usermsg[2]%>" id ="usersex" name="usersex"/></div>
        <div><label for="institute">学院</label>
            <input type="text" value="<%=usermsg[3]%>" name="institute" id="institute"/>
        </div>
        <div><label for="major">专业</label>
            <input type="text" value="<%=usermsg[4]%>" name="major" id ="major"/>
        </div>
        <div><label for="userid">学号</label><input type="text" value="<%=uaccount%>" name="userid" id ="userid"  readonly/></div>
        <div><label for="borndate">出生日期</label><input type="text" value="<%=usermsg[5]%>" name="borndate" id="borndate"/></div>
        <div><label for="isSingle">单身情况</label><input type="text" value="<%=usermsg[6]%>" name="isSingle" id="isSingle"/><br></div>
        <br>
        <input type="button" value="修改" onclick="changemsg()">
        <input type="button" value="取消"  onclick="cancelWin()">
    </div>
</div>
<script type="text/javascript">
    function sign(){
        //获取账户的签到次数
        var dom = $("tr:contains(<%=uaccount%>)");
        var num = parseInt(dom.children().eq(5).text());//签到次数加一
        //签到时间
        var time = new Date();
        var signtime = time.getFullYear()+"-"+(time.getMonth()+1)+"-"+time.getDate()+" "+time.getHours()+":"+time.getMinutes();
        //签到次数
        if(time.getDate()==0 && time.getHours()==23 && time.getMinutes()==59){
            num = 0;//签到次数清零
        }
        var signtimes = (num+1)%7;
        //签到率
        var signrate = (signtimes*100 /7).toFixed(1);

        $.ajax({
            url:"signServlet",
            type:"post",
            async:true,
            data:{
                "uaccount":<%=uaccount%>,
                "signtime":signtime,
                "signtimes":signtimes,
                "signrate":signrate
            },
            success:function(data){
                if("ok" == data){
                    setTimeout(function(){
                       window.location.reload();//一秒后刷新界面
                    },1000)
                }else{
                    alert("哈哈哈哈哈 sb");
                }
            }
        })
    }

    function changemsg(){
        var signText = $("#signText").val();//签名
        var username = $("#username").val();//用户姓名
        var usersex = $("#usersex").val();//用户性别
        var institute = $("#institute").val();//学院
        var major = $("#major").val();//专业
        var userid = $("#userid").val();//学号
        var borndate = $("#borndate").val();//出生日期
        var isSingle = $("#isSingle").val();//单身情况
        alert(signText);
        $.ajax({
            url:"updateMsgServlet",
            type:"post",
            async:true,
            data:{
                "signText":signText,
                "username":username,
                "usersex":usersex,
                "institute":institute,
                "major":major,
                "userid":userid,
                "borndate":borndate,
                "isSingle":isSingle
            },
            success:function(data){
                if(data=="ok"){
                    alert("修改成功");
                    $(".changeUserMsg").fadeOut("slow");
                }else if(data=="false"){
                    alert("修改失败");
                }
            }
        })
    }

    function showWin(){
        $(".changeUserMsg").fadeIn("slow");
    }
    function cancelWin(){
        $(".changeUserMsg").fadeOut("slow");
    }
</script>
</body>
</html>