<%@ Page Language="C#" Inherits="PTGirls.Content.register" AutoEventWireup="true" CodeFile="register.aspx.cs"%>
<!DOCTYPE html>
<link rel="stylesheet" href="/css/app.css">
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>

<!--    <script type="text/javascript" src="functions.js"></script>-->

    <script type="text/javascript">
      $(document).ready(function () {
                          jQuery.ajax({
                        type: "post",
                        async: false,
                        timeout: 2000,
                        url: "/Scripts/handle.ashx",
                        data: { flag: "initiate" },
                        dataType: "text",
                        cache: false,
                        success: function (data) {
                        },
                        error: function (err) {
                        }
                    });
    });
        function registerClick() {

                var username = $("#un1").val();
                var myreg = /^[0-9a-zA-Z\-\.\_]+@[0-9a-zA-Z\-]+\.[0-9a-zA-Z\-\.]+$/;
                if (!myreg.test(username)) {
                    alert('Please enter an Email');
                    return;
                }
                var password = $("#pswd").val();
                if (username != "") {
                    jQuery.ajax({
                        type: "post",
                        async: false,
                        timeout: 2000,
                        url: "/Scripts/handle.ashx",
                        data: { flag: "register", UserName: username, Password: password },
                        dataType: "text",
                        cache: false,
                        success: function (data) {
                            if(data.split(' ')[0]!="This"){
                                alert("Register Successfully!");
                                window.location.replace("userInfo.aspx?userId="+data);
                            }
                            else
                                alert(data);
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
    <title>RegisterNow</title>
</head>
<body>
        <div id="container" class="">
            <nav class="navbar navbar-default navbar-down">
                <div class="container-nav">
                    <div class="navbar-header">
                        <a id="back2main" class="navbar-brand" href="/Default.aspx">
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
                        Registration

                    </dt>
                    <dd>
                        
                        <span style="Width:150px;display:inline-block">Your user name:</span>
                        <input id="un1" />
                        <asp:Label id="registerInfo"  Style="color:red" runat="server" >
                    </asp:Label></dd>

                    <dd>

                        <span style="Width:150px;display:inline-block">Your password:</span>
                        <input id="pswd" type="password"/>
                    </dd>
                    <dd>
                    <input type="button" id="registerButton" value="Register"  onclick="registerClick()" Style="margin-left:156px" />
                    </dd>
                </dl>
            </div>
        </form>
</body>
</html>
