<%@ Page Language="C#" Inherits="PTGirls.Content.pet" AutoEventWireup="true" CodeFile="pet.aspx.cs"%>
<!DOCTYPE html>
<link rel="stylesheet" href="/css/app.css">
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<script src="http://cdn.static.runoob.com/libs/angular.js/1.4.6/angular.min.js"></script>
<script type="text/javascript">
      var userId;
      $(document).ready(function () {
            var a = window.location.search;
            if(a!=""){
                var userId = a.split('userId=')[1].split('&')[0];
                var dogId = a.split('dogId=')[1];
                
                var b = $("#back2main");
                b.attr('href',"/Default.aspx?userId="+userId);
                var c = $("#profileUrl");
                c.attr('href',"/Content/userInfo.aspx?userId="+userId);
                jQuery.ajax({
                    type: "post",
                    async: false,
                    timeout: 2000,
                    url: "/Scripts/handle.ashx",
                    data: { flag: "loadDog",DogId:dogId},
                    dataType: "text",
                    cache: false,
                    success: function (data) {
                        if(data!=""){
                            var a = JSON.parse(data);
                            $("#dogName").val(a[0].Name);
                            $("#breed").val(a[0].Breed);
                            $("#dogDOB").val(a[0].DOB);

                        }
                    },
                    error: function (err) {
                        alert("LoadDogInfo Error");
                    }
                   });
            }
            else{
                alert("No userId. Please register first.");
                window.location.replace("register.aspx");
            }
        });
</script>
<html>
<head runat="server">
    <title>Pet Information</title>
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
                            <a href="" id="profileUrl">Edit User Profile</a>
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
                        Your pet information
                    </dt>
                    <dd>
                        <span style="Width:150px;display:inline-block">Pet Name:</span>
                        <asp:TextBox ID="dogName" Style = "Width:200px;" runat="server" />
                        <asp:Label id="registerInfo"  Style="color:red" runat="server" >
                    </asp:Label>
                    </dd>
                    <dd>
                        <span style="Width:150px;display:inline-block">Breed:</span>
                    <asp:TextBox ID="breed" Style = "Width:200px;" runat="server" ></asp:TextBox>
                    </dd>
                    <dd>
                        <span style="Width:150px;display:inline-block">Date of Birth:</span>
                    <asp:TextBox ID="dogDOB" Style = "Width:200px;" runat="server" ></asp:TextBox>
                    </dd>
                </dl>
            </div>
    </form>
</body>
</html>
