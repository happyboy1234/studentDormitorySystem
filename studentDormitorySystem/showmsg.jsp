<%@ page import="java.util.List" %>
<%@ page import="com.sofency.Dao.apacheDao" %>
<%@ page import="com.sofency.entry.dianzan" %><%--
  Created by IntelliJ IDEA.
  User: sofency
  Date: 2019/9/24
  Time: 21:38
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>我的消息</title>
</head>
<body>
<%
    //处理账户信息
    String uaccount = request.getParameter("uaccount");
    System.out.println(uaccount);
    //获取点赞信息
    List<dianzan> list = apacheDao.getDianzan(uaccount);
%>
    <div class="container" style="width: 1200px; margin: 10px auto;height: 800px;background-color: #c8d6e5;text-align: center">
        <%
            if(list!=null){
                for(dianzan dian:list){
       %>
        <div class="msgContent" style="height: 80px;border: 1px solid #ccc;line-height: 80px">
            <span><%=dian.getUaccount()%>点赞了你在</span><span><%=dian.getMessagetime()%>发表的评论</span>
        </div>
       <%
               }
            }else{
       %>
        <div style="height: 80px;border: 1px solid #ccc;line-height: 80px">
            暂无消息
        </div>
        <%
            }
        %>
    </div>
</body>
</html>
