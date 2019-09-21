<%@page contentType="text/html;charset=utf-8" language="java"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <!--引入外部重置样式-->
    <link rel="stylesheet" type="text/css" href="css/reset.css"/>
    <link rel="stylesheet" href="css/image.css">
    <script src="js/jquery.js"></script>
    <link rel="stylesheet" href="css/index.css">
</head>
<body>
<header>
    <h1>学生宿舍管理系统</h1>
    <div>
        <button  id="howToUse">如何使用</button>
        <button id="contactUs">联系我们</button>
    </div>
</header>
<!--轮播图-->
<article>
    <div class="left-container">
        <div class="container">
            <div class="images">
                <a href=""><img src="image/pic1.jpg" alt=""></a>
                <a href=""><img src="image/pic2.jpg" alt=""></a>
                <a href=""><img src="image/pic3.jpg" alt=""></a>
                <a href=""><img src="image/pic4.jpg" alt=""></a>
                <a href=""><img src="image/pic5.jpg" alt=""></a>
            </div>
            <div class="dots"></div>
            <div class="arrow">
                <div class="item left">&lt;</div>
                <div class=" item right">&gt;</div>
            </div>
        </div>
        <div class="text">
            <div class="top">
                <span class="title">&gt;&gt;宿舍出过的奇葩事</span><a href=""><span>更多</span></a>
            </div>
            <ul>
                <li><a href="">掌上搜啊少年斯纳思安</a></li>
                <li><a href="">死傲娇死啊吉萨季赛</a></li>
                <li><a href="">嫂嫂咳嗽阿口岸咳嗽考试卡</a></li>
                <li><a href="">将阿虎在集散撒</a></li>
                <li><a href="">掌上搜啊少年斯纳思安</a></li>
            </ul>
        </div>
    </div>

    <!--登录表单-->
    <div class="right-container">
        <div>
            <h1>登录</h1>
            <label for="uaccount">账户</label><input type="text" name = "uaccount" id="uaccount" placeholder="用户名"><br>
            <label for="upwd">密码</label><input type="password" name ="upwd" id="upwd" placeholder="密码"><br>
            <input type="submit" value="登录" onclick="postMessage()">
            <div class="other-func">
                <button onclick="addMsg()" id="register">注册账号</button>
                <button onclick="">忘记密码</button>
                <div style="display: none" id="registerPage">
                    <div style="position: fixed; left: 0; top: 0;
                    right: 0; margin: auto; width: 350px;
                    height: 570px;
                    background-color:rgba(255,255,255,0.8);opcity:0.4;border: 1px solid #ccc;">
                        <h1>注册界面</h1>
                        <form action="dorstuServlet" accept-charset="utf-8" method="post" enctype="multipart/form-data" class="msg" style="text-align: left;margin-top: 10px;">
                            <label for="img">图片</label><input type="file" name="img" id="img"/><hr>
                            <label for="initName">姓名</label><input type="text" name="uName" id="initName"/><hr>
                            <label for="initAccount">账户</label><input type="text" name="account" id="initAccount"/><hr>
                            <label for="initPwd">密码</label><input type="text" name="pwd" id="initPwd"/><hr>
                            <label>性别</label>
                            <input type="radio" name="sex" value="female"/>女
                            <input type="radio" name="sex" value="male" checked/>男<hr>
                            <label for="bornDate">出生日期</label><input type="date" name="bornDate" id="bornDate"><hr>
                            <label>是否单身</label>
                            <input type="radio" name="single" value="yes">是
                            <input type="radio" name="single" value="no">否
                            <hr>
                            <label for="initInstitute">学院</label>
                            <select name="institute" class="institute" id="initInstitute" onchange="addMajor(this.value)">
                                <option>--请选择--</option>
                                <option value="计算机科学学院">计算机科学学院</option>
                                <option value="机电工程学院">机电工程学院</option>
                                <option value="管理学院">管理学院</option>
                                <option value="电子信息学院">电子信息学院</option>
                                <option value="纺织与科学工程学院">纺织与科学工程学院</option>
                            </select><br>
                            <label for="major">专业</label>
                            <select class="major" id="major" name="major">
                                <option>--请选择--</option>
                                <script>
                                    var arr=new Array(5);
                                    arr[0]=["计算机科学学院","软件工程","计算机科学与技术","数字媒体技术"];
                                    arr[1]=["机电工程学院","机械设计制造及其自动化","机械电子工程","机械工程","工业工程"];
                                    arr[2]=["管理学院","国际金融与贸易","会计","信息科学与技术"];
                                    arr[3]=["电子信息学院","微电子工程与技术","理论力学","单片机的开发"];
                                    arr[4]=["纺织与科学工程学院","非机织造专业","纺织工程","服装与艺术设计"];

                                    function addMajor(val){
                                        //把之前的给删除了
                                        var allMajor =$(".major")[0];
                                        var option1 = allMajor.getElementsByTagName("option");//在特定区域内选中
                                        for(var i=0;i<option1.length;i++){
                                            var op = option1[i];
                                            allMajor.remove(op);
                                            i--;
                                        }
                                        for(var i=0;i<arr.length;i++) {
                                            if (arr[i][0] == val) {
                                                for (var j = 1; j < arr[i].length; j++) {
                                                    var list = document.createElement("option");
                                                    list.value = arr[i][j];//设置value的值
                                                    var text = document.createTextNode(arr[i][j]);
                                                    list.appendChild(text);
                                                    allMajor.appendChild(list);
                                                }
                                            }
                                        }
                                    }
                                </script>
                            </select>
                            <hr>
                            <label for="dormitory">宿舍号</label><input type="text" id="dormitory" name="dornum"/><br>
                            <hr>
                            <input type="submit" value="提交"/>
                            <span  class="formmsg">
                               <%=request.getAttribute("flag")%>
                            </span>
                        </form>
                        <script>
                            $(".msg").children("input").css("margin","5px 0").css("height","18px").
                            css("border","none").css("borderBottom","1px solid #ccc").css("backgroundColor","transition");
                            $(".sex").css("vertical-align","middle").css("margin-top","-20px").css("marginLeft","5px");
                            $("select").css({
                                "margin":"5px 0",
                                "height":"23px"
                            })
                        </script>

                    </div>
                </div>
            </div>
            <span class="prompt" style="display: block;color: red;width: 100%;margin-top: 10px;text-align: center;"></span>
        </div>
    </div>
</article>
<footer style="position:fixed; bottom: 0;width: 100%; text-align: center;font-size: 30px;background-color: #1abc9c;height: 100px;line-height: 100px">
    <div>welcome to studentDormitorySystem</div>
</footer>
<script src="js/image.js"></script>
<script>
    function  postMessage() {
        var uaccount=$("#uaccount").val();//uaccount
        var upwd = $("#upwd").val();
        $.ajax({
            url: "loginByPassword",
            type:"post",
            async:true,
            data:{
                "uaccount":uaccount,
                "upwd":upwd
            },
            success:function(data) {
                if (data == "ok") {
                    window.location.href="system.jsp?uaccount="+uaccount;
                } else if (data == "false") {
                    document.getElementsByClassName("prompt")[0].innerHTML = "登陆失败";
                }else if(data == "noUser"){
                    document.getElementsByClassName("prompt")[0].innerHTML="用户不存在";
                    $("#username").val("");// 将input的文本清空
                    $("#upwd").val("");
                }
            }
        })
    }
    function addMsg(){
        $("#registerPage").css("display","block");
    }
</script>
</body>
</html>