<%@ Page Language="C#" Inherits="PTGirls.Content.userInfo" AutoEventWireup="true" CodeFile="userInfo.aspx.cs"%>
<!DOCTYPE html>
<link rel="stylesheet" href="/css/app.css">
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<script src="http://cdn.static.runoob.com/libs/angular.js/1.4.6/angular.min.js"></script>

<!--    <script type="text/javascript" src="functions.js"></script>-->
<style type="text/css">
    .dogRect{
        height:30px;
        width:56px;
        margin-right:20px;
        border-style: solid; 
        border-width:1px;

          border-top-width: 1px;
          border-right-width: 1px;
          border-bottom-width: 5px;
          border-left-width: 1px;
    }

</style>
    <script type="text/javascript">
      var userId;
      $(document).ready(function () {
            var a = window.location.search;
            if(a!=""){
                var b = $("#back2main");
                b.attr('href',"/Default.aspx"+a);
                var c = $("#profileUrl");
                c.attr('href',"/Content/userInfo.aspx"+a);
                userId = a.split('userId=')[1];
                jQuery.ajax({
                            type: "post",
                            async: false,
                            timeout: 2000,
                            url: "/Scripts/handle.ashx",
                            data: { flag: "loadInfo",UserId:userId},
                            dataType: "text",
                            cache: false,
                            success: function (data) {
                                if(data!=""){
                                    var a = JSON.parse(data);
                                    $("#userName").val(a.UserName);
                                    $("#userAddress").val(a.Address);
                                    $("#contactNum").val(a.ContactNum);

                                }
                            },
                            error: function (err) {
                                alert("LoadUserInfo Error");
                            }
                           });
                    }
                    else{
                        alert("No userId. Please register first.");
                        window.location.replace("register.aspx");
                    }
        });
        var app = angular.module("confirmsModule", []);
        app.controller("confirmsController", function ($scope, $http) {
                $scope.find = function () {
                    var a = window.location.search;
                    var userId = a.split('userId=')[1];
                    $http({
                        method: "GET",
                        async: false,
                        url: "/Scripts/handle.ashx",
                        params: { "flag": "loadDogs","UserId": userId }
                    }).success(function (data) {
                        $scope.names = data;
                        var dogs =$scope.names;
                        for(var i =0;i<dogs.length;i++){
                            $scope.names[i].href = "/Content/pet.aspx?userId="+userId+"&dogId="+dogs[i].DogId;
                        }
                    }).error(function () {
                        alert("LoadDogsInfo Error");
                    });
                };
                $scope.find();
      
        });
        function addClick(){
            $("#addDog").show(400);
        }
        function addDog(dogname,dogbreed,dogdob){
            jQuery.ajax({
                type: "post",
                async: false,
                timeout: 2000,
                url: "/Scripts/handle.ashx",
                data: { flag: "addDogInfo",UserId:userId,DogName:dogname,DogBreed:dogbreed,DogDOB:dogdob},
                dataType: "text",
                cache: false,
                success: function (data) {
                    if(data="0"){
                        alert("Dog information added successfully!");
                    }
                    else{
                        alert(data);
                    }
                },
                error: function (err) {
                    alert("addDogInfo Error");
                }
           });
        }
        function editUserInfo(username,address,contactnum){
            jQuery.ajax({
                type: "post",
                async: false,
                timeout: 2000,
                url: "/Scripts/handle.ashx",
                data: { flag: "editUserInfo",UserId:userId,UserName:username,Address:address,ContactNum:contactnum},
                dataType: "text",
                cache: false,
                success: function (data) {
                    if(data="0"){
                        alert("Your information is updated!");
                        window.location.replace("userInfo.aspx?userId="+userId);
                    }
                    else{
                        alert(data);
                    }
                },
                error: function (err) {

                    alert("editUserInfo Error");
                }
           });
        }
        function saveClick() {
                var username = $("#userName").val();
                var address = $("#userAddress").val().replace(',',' ');
                var contactnum = $("#contactNum").val();
                var dogname = $("#dogName").val();
                var dogbreed = $("#dogBreed").val();
                var dogdob = $("#dogDOB").val();
                if(username ==""){
                    alert("Please enter User name.");
                    return;
                }
                if(address ==""){
                    alert("Please enter Address.");
                    return;
                }
                if(contactnum ==""){
                    alert("Please enter Contact Number.");
                    return;
                }
                if(dogname==""||dogbreed==""||dogdob==""){
                    if($(".dogRect").text() ==""){
                        alert("Please add a dog.");
                        return;
                    }
                    if(!(dogname==""&&dogbreed==""&&dogdob=="")){
                        if(dogname ==""){
                            alert("Please enter dog name.");
                            return;
                        }
                        if(dogbreed ==""){
                            alert("Please enter dog breed.");
                            return;
                        }
                        if(dogdob ==""){
                            alert("Please enter dog's date of birth.");
                            return;
                        }
                    }
                }
                if(dogname!=""&&dogbreed!=""&&dogdob!=""){
                    addDog(dogname,dogbreed,dogdob);
                }
                if(username!=""&&address!=""&&contactnum!=""){
                    editUserInfo(username,address,contactnum);
                }
            
        }
    </script>
<html>
<head runat="server">
    <title>Your Profile</title>
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
                            <a id="profileUrl" href="">Edit User Profile</a>
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
            <div class="container"  ng-app="confirmsModule" ng-controller="confirmsController">
                <dl class="faq-list">
                    <dt> 
                        User Information

                    </dt>
                    <dd>
                        
                        <span style="Width:250px;display:inline-block">User name:</span>
                        <input id="userName" />
                        <asp:Label id="p1"  Style="color:red" runat="server">*</asp:Label>
                    </dd>

                    <dd>

                        <span style="Width:250px;display:inline-block">Your address:</span>
                        <input id="userAddress" type="input" style="Width:400px;"/>
                        <asp:Label id="p2"  Style="color:red" runat="server">*</asp:Label>
                    </dd>
                    <dd>

                        <span style="Width:250px;display:inline-block">Your contact number:</span>
                        <input id="contactNum" type="input"/>
                        <asp:Label id="p3" Style="color:red" runat="server">*</asp:Label>
                    </dd>
                    <dd >

                        <span style="Width:250px;display:inline-block">Your dogs:</span>
                        <div class="btn">
                            <a href="" style="margin-right:40px;" onclick="addClick();">Add</a>
                        </div>
                        <span ng-repeat="x in names">
                            <a  class="dogRect" ng-href={{x.href}} >{{x.Name}}
                            </a>
                        </span>
                        <asp:Label id="p4"  Style="color:red" runat="server">*</asp:Label>
                    </dd>
                    <div id="addDog" style="display:none;">
                    <dd>
                        <span style="Width:250px;display:inline-block">DogName:</span>
                        <input id="dogName" type="input"/>
                    </dd>
                    <dd>
                        <span style="Width:250px;display:inline-block">Breed:</span>
                        <input id="dogBreed" type="input"/>
                    <dd>
                        <span style="Width:250px;display:inline-block">Date of Birth:</span>
                        <input id="dogDOB" type="input"/>
                        <asp:Label id="p5" Style="color:#1196EE" runat="server">DD/MM/YYYY</asp:Label>
                    </dd>
                    </div>
                    <dd>
                    <input type="button" id="saveBtn"  value="Save"  onclick="saveClick()" Style="width:100px;margin-left:256px" />
                    </dd>
                </dl>
            </div>
        </form>
</body>
</html>
