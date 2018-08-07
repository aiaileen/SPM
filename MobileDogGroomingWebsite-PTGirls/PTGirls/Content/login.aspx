<%@ Page Language="C#" Inherits="PTGirls.Content.login" AutoEventWireup="true" CodeFile="login.aspx.cs"%>
<!DOCTYPE html>
<link rel="stylesheet" href="/css/app.css">

<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<script type="text/javascript">
      $(document).ready(function () {
                    
      });
        function loginClick() {

                var username = $("#un1").val();
                var password = $("#pswd").val();
                if (username != "") {
                    jQuery.ajax({
                        type: "post",
                        async: false,
                        timeout: 2000,
                        url: "/Scripts/handle.ashx",
                        data: { flag: "login", UserName: username, Password: password },
                        dataType: "text",
                        cache: false,
                        success: function (data) {
                            if(data.split(',')[0]!="err"){
                                alert("Login successfully! Now redirect to the home page!");
                                window.location.replace("/Default.aspx?userId="+data);
                            }
                            else{
                                alert(data.split(',')[1]);
                                if(data.split(',')[1]=="Your account cannot be found. Please register first."){
                                window.location.replace("register.aspx");}
                            }
                        },
                        error: function (err) {
                        }
                    });
                }
            
        }
        function backUrl(name) {
            var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
            var r = window.location.search.substr(1).match(reg);
            if (r != null)
                return unescape(r[2]);
            return null;
        }
    </script>

<html>
<head runat="server">
    <title>Login</title>
</head>
<body>
        <div id="container" class="">
            <nav class="navbar navbar-default navbar-down">
                <div class="container-nav">
                    <div class="navbar-header">
                        <a class="navbar-brand" href="/Default.aspx">
                            <img src="/logo2.svg">
                        </a>
                    </div>
                    <ul class="nav navbar-nav navbar-right">
                        <li class="dropdown ">
                         <a href="" role="button" aria-haspopup="true" aria-expanded="false"> About Us
                                    <span class="caret"></span>
                         </a>
                            <ul class="dropdown-menu">
                            <li>
                                <a href="/content/about.aspx">Meet Our Team</a>
                            </li>
                            </ul>
                        </li>
                        <li class="dropdown ">
                            <a href="" role="button" aria-haspopup="true" aria-expanded="false"> Our Services
                            <span class="caret"></span>
                            </a>
                            <ul class="dropdown-menu">
                            <li>
                            <a href="">Edit User Profile</a>
                            </li>
                        </ul>
                        </li>

                        <li class="menu-btn-wrapper"> <button class="menu-btn">
                        <span></span>
                        <span></span>
                        <span></span>
                        Menu </button>
                        </li>
                    </ul>

                </div>
            </nav>
            </div>
    <form id="form1" runat="server">
        <div class="container">
                <dl class="faq-list">
                    <dt> 
                        Log In

                    </dt>
                   
                    <dd>
                        
                        <span style="Width:150px;display:inline-block">Your user name:</span>
                        <input id="un1" />
                    </dd>

                    <dd>

                        <span style="Width:150px;display:inline-block">Your password:</span>
                        <input id="pswd" type="password"/>
                    </dd>
                    <dd>
                    <input type="button" id="loginButton" value="Login"  onclick="loginClick()" Style="margin-left:156px" />
                    </dd>
                </dl>
            </div>
    </form>
</body>
</html>
