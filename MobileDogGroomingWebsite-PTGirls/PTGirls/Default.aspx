<%@ Page Language="C#" Inherits="PTGirls.Default" %>
<!DOCTYPE html>
<link rel="stylesheet" href="http://www.bluewheelers.com.au/wp-content/themes/blue-wheelers/assets/css/app.css">

<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<script src="http://cdn.static.runoob.com/libs/angular.js/1.4.6/angular.min.js"></script>
<style type="text/css">
    .table_name {
        color:white;
        font-size:16px;
        font-weight:bold;
        }
    .srk{
        color:white;
        font-size:14px;
        }

.btn {
    overflow: auto
}

    .btn a {
        margin-left: -20px;
        font-size: 14px;
        text-align: center;
        background-color: #1196EE;
        float: left;
        margin-right: 10px;
        padding: 5px 20px;
        color: #FFF
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
                var d = $("#go2edit");
                d.attr('href',"/Content/userInfo.aspx"+a);
                $(".slogin").show();
                userId = a.split('userId=')[1];
                jQuery.ajax({
                            type: "post",
                            async: false,
                            timeout: 2000,
                            url: "/Scripts/handle.ashx",
                            data: { flag: "loadInfo",UserId: userId },
                            dataType: "text",
                            cache: false,
                            success: function (data) {
                                if(data!=""){
                                    var a = JSON.parse(data);
                                    $("#userBar").text("Welcome "+a.UserName+"!");
                                }
                                else{
                                    $("#nullInfo").show();
                                }
                                $(".unlogin").hide();
                            },
                            error: function (err) {
                                alert("LoadUserInfo Error");
                            }
                        });
                var dogs;
                jQuery.ajax({
                            type: "post",
                            async: false,
                            timeout: 2000,
                            url: "/Scripts/handle.ashx",
                            data: { flag: "loadDogs",UserId: userId },
                            dataType: "text",
                            cache: false,
                            success: function (data) {
                                dogs = JSON.parse(data);
                            },
                            error: function (err) {
                                alert("LoadDogInfo Error");
                            }
                                });
                var obj=document.getElementById('dogsList');
                obj.add(new Option("",0));
                for(var j=0;j< dogs.length;j++){
                    obj.add(new Option(dogs[j].Name,dogs[j].DogId));
                }

            }
            else{
                $(".unlogin").show();
                $(".slogin").hide();
            }
        });
        //Angular Part
        var app = angular.module("confirmsModule", []);

        app.controller("confirmsController", function ($scope, $http) {
            var a = window.location.search;
            if(a!=""){
                $(".unlogin").hide();
                $(".slogin").show();
                var userId = a.split('userId=')[1];
                $scope.find = function () {
                    $http({
                        method: "GET",
                        async: false,
                        url: "/Scripts/handle.ashx",
                        params: { "flag": "loadApp","UserId": userId }
                    }).success(function (data) {
                        var dogs;
                        if(data!=""){
                            $scope.names = data;
                            jQuery.ajax({
                                    type: "post",
                                    async: false,
                                    timeout: 2000,
                                    url: "/Scripts/handle.ashx",
                                    data: { flag: "loadDogs",UserId: userId },
                                    dataType: "text",
                                    cache: false,
                                    success: function (data) {
                                        dogs = JSON.parse(data);
                                    },
                                    error: function (err) {
                                        alert("LoadDogInfo Error");
                                    }
                                });

                           for(var i = 0;i<$scope.names.length;i++){
                                for(var j=0;j< dogs.length;j++){
                                    if($scope.names[i].DogId==dogs[j].DogId)
                                        $scope.names[i].DogName = dogs[j].Name;
                                }
                           }
                        }
                        else{
                            $("#nullInfo").show();
                        }
    

                    }).error(function () {
                        alert("LoadAppInfo Error");
                    });

                };
                $scope.find();
             }
             else{

                $(".unlogin").show();
                $(".slogin").hide(); 
             }
        });

        function addAppClick(){
            $("#addAppTable").show(500);
            $(".addsche").show();
            $(".resche").hide();
        }
    
        function serviceListChange(){
            var service = $("#servicesList").val();
            var price = "$170";
            if(service=="Wash") price = "$30";
            if(service=="Groom") price = "$60";
            if(service=="Health Check") price = "$100";
            if(service=="Wash+Groom") price = "$90";
            if(service=="Groom+Health Check") price = "$160";
            if(service=="Wash+Health Check") price = "$130";
            var obj=document.getElementById('priceTag');
            obj.innerHTML=price;
        }
        function confirmClick() {
                var service = $("#servicesList").val();
                var dogid = $("#dogsList").val()
                var appdate = $("#appDate").val();
                var comment = $("#appComment").val();
                if(service ==""){
                    alert("Please choose a service.");
                    return;
                }
                if(dogid ==""){
                    alert("Please choose the pet.");
                    return;
                }
                if(appdate ==""){
                    alert("Please enter the appointment date.");
                    return;
                }
                if(service!=""&&dogid!=""&&appdate!=""){
                    if(confirm("Do you wish to have an appointment on "+appdate+"? The total cost will be "+$("#priceTag").text()+"."))
                        addApp(userId,service,dogid,appdate,comment);
                }
            
        }
        function addApp(userId,service,dogid,appdate,comment){
            jQuery.ajax({
                type: "post",
                async: false,
                timeout: 2000,
                url: "/Scripts/handle.ashx",
                data: { flag: "addApp",UserId:userId,Service:service,DogId:dogid,AppDate:appdate,Comment:comment},
                dataType: "text",
                cache: false,
                success: function (data) {
                    if(data=="0"){
                        alert("Your appointment is accpeted!");
                        window.location.replace("Default.aspx?userId="+userId);
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
    
        function checkUnique(){
            var unik = 0;
            var a = document.getElementsByClassName("ckbx");
            for(var i =0;i<a.length;i++){
                if(a[i].checked)unik++;
            }
            if(unik==1) return true;
            else return false;
        }
    
        function cancelClick() {
            if(checkUnique()){
                if(confirm("Do you really want to cancel this appointment?")){
                    var unik = 0;
                    var a = document.getElementsByClassName("ckbx");
                    for(var i =0;i<a.length;i++){
                        if(a[i].checked){
                            var b = a[i];
                        }
                    }
                    var appId = b.parentElement.parentElement.childNodes[3].innerHTML;
                    jQuery.ajax({
                            type: "post",
                            async: false,
                            timeout: 2000,
                            url: "/Scripts/handle.ashx",
                            data: { flag: "deleteApp", AppId:appId},
                            dataType: "text",
                            cache: false,
                            success: function (data) {
                                if(data=="0"){
                                    alert("Delete Successfully.");
                                    var b = $("#back2main");
                                    window.location.replace(b.attr('href'));
                                }
                                else{
                                    alert(data);
                                }
                            },
                            error: function (err) {
                                alert("DeleteApp Error");
                            }
                       });
                }
            }
            else{
                alert("Please choose one and ONLY one record.");
            }
        }
    function sendAutoReminder(){
        if(checkUnique()){
            var unik = 0;
            var a = document.getElementsByClassName("ckbx");
            for(var i =0;i<a.length;i++){
                if(a[i].checked){
                    var b = a[i];
                }
            }
            var c = window.location.search;
            var userId = c.split('userId=')[1];
            var userName = $("#userBar").text().split('Welcome ')[1].split('!')[0];
            var petName = b.parentElement.parentElement.childNodes[5].innerHTML;
            var time = b.parentElement.parentElement.childNodes[7].innerHTML;
            var mailTo = "";
            jQuery.ajax({
                    type: "post",
                    async: false,
                    timeout: 2000,
                    url: "/Scripts/handle.ashx",
                    data: { flag: "loadMailAddress", UserId:userId},
                    dataType: "text",
                    cache: false,
                    success: function (data) {
                        if(data!=""&&data!="err"){
                            mailTo = data;
                        }
                        else{
                            alert("loadMailAddress Error");
                        }
                    },
                    error: function (err) {
                        alert("loadMailAddress Error");
                    }
            });
            jQuery.ajax({
                    type: "post",
                    async: false,
                    timeout: 2000,
                    url: "/Scripts/handle.ashx",
                    data: { flag: "sendMail", UserName:userName,DogName:petName,Date:time,MailTo:mailTo},
                    dataType: "text",
                    cache: false,
                    success: function (data) {
                        if(data=="0"){
                            alert("Auto Reminder Sent!");
                        }
                        else{
                            alert("SendMail Error");
                        }
                    },
                    error: function (err) {
                        alert("SendMail Error");
                    }
            });
    
    
        }
        else
        {
            alert("Please choose one and ONLY one record.");
        }
    }
        function editClick(userId,service,dogid,appdate,comment){
            $(".addsche").hide();
            $(".resche").show();
            if(checkUnique()){
                var unik = 0;
                var a = document.getElementsByClassName("ckbx");
                for(var i =0;i<a.length;i++){
                    if(a[i].checked){
                        var b = a[i];
                    }
                }
                var appId = b.parentElement.parentElement.childNodes[3].innerHTML;
                jQuery.ajax({
                    type: "post",
                    async: false,
                    timeout: 2000,
                    url: "/Scripts/handle.ashx",
                    data: { flag: "loadAppAdmin", AppId:appId},
                    dataType: "text",
                    cache: false,
                    success: function (data) {
                        if(data!=""){
                            var appInfo = JSON.parse(data);
                            var c = window.location.search;
                            var userId = c.split('userId=')[1];
                            var dogs;
                            jQuery.ajax({
                                    type: "post",
                                    async: false,
                                    timeout: 2000,
                                    url: "/Scripts/handle.ashx",
                                    data: { flag: "loadDogs",UserId: userId },
                                    dataType: "text",
                                    cache: false,
                                    success: function (data) {
                                        dogs = JSON.parse(data);
                                        var obj=document.getElementById('dogsList');
                                        $("#dogsList").children().remove();
                                        obj.add(new Option("",0));
                                        for(var j=0;j< dogs.length;j++){
                                            obj.add(new Option(dogs[j].Name,dogs[j].DogId));
                                        }
                                    },
                                    error: function (err) {
                                        alert("LoadDogsInfo Error");
                                    }
                                });
                            $("#appComment").val(appInfo[0].Comments);
                            $("#appDate").val(appInfo[0].Date);
                            var select_value = "option[value="+appInfo[0].DogId+"]";
                            $("#dogsList").find(select_value).prop("selected", "true");
                            select_value = "option[value='"+appInfo[0].Service+"']";
                            $("#servicesList").find(select_value).prop("selected", "true");
                            serviceListChange();
                            $("#addAppTable").show(500);
                        }
                        else{
                            alert("LoadAppAdmin Error");
                        }
                    },
                    error: function (err) {
                        alert("LoadAppAdmin Error");
                    }
               });
            }
            else{
                alert("Please choose one and ONLY one record.");
            }
        }
    
        function editApp(appId,userId,service,dogid,appdate,comment){
            jQuery.ajax({
                    type: "post",
                    async: false,
                    timeout: 2000,
                    url: "/Scripts/handle.ashx",
                    data: { flag: "editApp",AppId:appId,UserId:userId,Service:service,DogId:dogid,AppDate:appdate,Comment:comment},
                    dataType: "text",
                    cache: false,
                    success: function (data) {
                        if(data=="0"){
                            alert("Your appointment is updated!");
                            closeClick();
                            var b = $("#back2main");
                            window.location.replace(b.attr('href'));
                        }
                        else{
                            alert(data);
                        }
                    },
                    error: function (err) {

                        alert("updateApp Error");
                    }
               });
        }
        function rescheduleClick() {        
            var c = window.location.search;
            var userId = c.split('userId=')[1];
            var service = $("#servicesList").val();
            var dogid = $("#dogsList").val()
            var appdate = $("#appDate").val();
            var comment = $("#appComment").val();
            if(userId==""){
                alert("Load userId not correct");
                return;
            }
            if(service ==""){
                alert("Please choose a service.");
                return;
            }
            if(dogid ==""||dogid=="0"){
                alert("Please choose the pet.");
                return;
            }
            if(appdate ==""){
                alert("Please enter the appointment date.");
                return;
            }
            if(service!=""&&dogid!=""&&appdate!=""){
                if(confirm("Do you wish to update this appointmen?")){
                    var a = document.getElementsByClassName("ckbx");
                    for(var i =0;i<a.length;i++){
                        if(a[i].checked){
                            var b = a[i];
                        }
                    }
                    var appId = b.parentElement.parentElement.childNodes[3].innerHTML;
                    editApp(appId,userId,service,dogid,appdate,comment);
                }
            }

        }
        function closeClick(){
            $("#addAppTable").hide(500);
        }
    
        function logout(){
            alert("Log Out successfully!");
            window.location.replace("Default.aspx");
        }
    </script>
<html>
<head runat="server">
	<title>Welcome to Tom's Grooming</title>
</head>
<body>
    <form id="form1" runat="server">
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
                        <li><a>        </a></li>
                        <li>

                            <a class="unlogin" href="/content/login.aspx">Login  </a>
                            </li> 
                        
                        <li>
                            <a class="unlogin" href="/content/register.aspx" target="_blank">Register</a>
                        </li>
                        <li>
                            <a id="userBar" class="slogin"></a>
                        </li>
                            <li><a id="logout" class="slogin" onclick="logout()">Log Out</a></li>
                        <li class="menu-btn-wrapper"> <button class="menu-btn">
                        <span></span>
                        <span></span>
                        <span></span>
                        Menu </button>
                        </li>
                    </ul>

                <div>
                </div>
                </div>
            </nav>
            <ul class="floating-social">
                <li class="link-facebook">
                    <a target="_blank" href="https://www.facebook.com/" title="Like us on Facebook">
                    <span class="icon-facebook"></span>
                    </a>
                </li>
                <li class="link-youtube">
                    <a target="_blank" href="https://www.youtube.com/" title="Subscribe on YouTube">
                    <span class="icon-youtube-play"></span>
                    </a>
                </li>
                <li class="link-instagram">
                    <a target="_blank" href="https://instagram.com/" title="Follow us on Instagram">
                    <span class="icon-instagram"></span>
                    </a>
                </li>
            </ul>
            <ul class="social-mobile">
                <li class="link-facebook">
                    <a target="_blank" href="https://www.facebook.com/" title="Like us on Facebook">
                    <span class="icon-facebook"></span>
                    </a>
                </li>
                <li class="link-youtube">
                    <a target="_blank" href="https://www.youtube.com/user/" title="Subscribe on YouTube">
                    <span class="icon-youtube-play"></span>
                    </a>
                </li>
                <li class="link-instagram">
                    <a target="_blank" href="https://instagram.com/" title="Follow us on Instagram">
                    <span class="icon-instagram"></span>
                    </a>
                </li>
            </ul>



            <section id="section-community" ng-app="confirmsModule" ng-controller="confirmsController">

            <div class="container">
                <h2 class="mail-ray unlogin">Hello & Welcome!</h2>
                <ul class="menu unlogin">
                    <li>
                        <a href="/content/register.aspx" target="_blank">Want to register</a>
                    </li>
                    <li>
                        <a href="/content/login.aspx">I'm a member</a>
                    </li>
                    <li>
                        <a href="/content/admin.aspx">I'm a groomer</a>
                    </li>
                </ul>
                <div class="title slogin">
                    <h2 class="mail-ray">Your Appointments</h2>
                </div>
                <div class="slogin" style="margin-bottom:50px;">
                    <ul class="menu slogin" style="float:left; margin-left:80px;">
                        <li>
                            <a href="" onclick="addAppClick();">Add</a>
                        </li>
                        <li>
                            <a href="" onclick="editClick()">Edit</a>
                        </li>
                        <li>
                            <a href="" onclick="cancelClick()">Cancel</a>
                        </li>
                    </ul>
                    <table id="addAppTable" style="display:none;height: 100%;width:950px;background-color:white;margin-bottom:50px;" align="center">
                        <tr>
                            <td width="40%">
                                <span>Choose your pet:</span> 
                            </td>
                            <td>
                                <select id="dogsList"></select>
                                <a id="go2edit" href="" style="color:orange;padding-left:140px;"> Go add a new pet</a>
                            </td>
                        </tr> 
                        <tr>
                            <td>
                                <span style="width:200px;">Pick the service you want:</span>
                            </td>
                            <td>
                                <select id="servicesList" onchange="serviceListChange()">
                                  <option value =""></option>
                                  <option value ="Wash">Wash</option>
                                  <option value ="Groom">Groom</option>
                                  <option value="Health Check">Health Check</option>
                                  <option value="Wash+Groom">Wash+Groom</option>
                                  <option value="Wash+Health Check">Wash+Health Check</option>
                                  <option value="Groom+Health Check">Groom+Health Check</option>
                                  <option value="Wash+Groom+Health Check">Wash+Groom+Health Check</option>
                                </select>

                                <asp:Label id="priceTag" Style="color:#1196EE;weight:bold;padding-left:20px;" runat="server"></asp:Label>
                            </td>
                        </tr> 
                        <tr>
                            <td>
                                <span>Appointment Date: </span>
                            </td>
                            <td>
                                <input id="appDate" type="text"/>
                                <asp:Label id="dateformat" Style="color:#1196EE;weight:bold;padding-left:40px;" runat="server">DD/MM/YYYY hh(24):00 </asp:Label>
                            </td>
                        </tr> 
                        <tr>
                            <td>
                                <span>Leave some speical requirements if needed:</span>
                            </td>
                            <td>
                                <input id="appComment" style="width:400px;" type="text"/>
                            </td> 
                        </tr>
                        <tr>
                            <td colspan="2">
                                <div class="btn resche" style="display:none">
                                    <a href="" style="margin-right:40px;" onclick="rescheduleClick();">Reschedule</a>
                                </div>
                                <div class="btn addsche" style="display:none">
                                    <a href="" style="margin-right:40px;" onclick="confirmClick();">Confirm</a>
                                </div>
                                <div class="btn">
                                    <a href="" style="margin-right:40px;" onclick="closeClick();">Close</a>
                                </div>
                            </td>   
                        </tr>
                    </table>
                    <table id="appList" style="height: 100%;width:950px;" align="center">
                        <tr>
                            <td class="table_name" style="width: 5%"></td>
                            <td class="table_name" style="width: 5%">No.</td>
                            <td class="table_name" style="width: 20%">DogName</td>
                            <td class="table_name" style="width: 15%">Time</td>
                            <td class="table_name" style="width: 20%">Service</td>
                            <td class="table_name" style="width: 25%">Comments</td>
                        </tr>
                        <tr id="nullInfo" style="display:none;">
                            <td class="table_name" style="width: 5%"></td>
                            <td style="color:white;" colspan="5">You have no appointment currently. Please add.</td>
                        </tr>
                        <tr  ng-repeat="x in names">
                            <td><input  class="ckbx" type="checkbox" / ></td>
                            <td class="srk" ng-bind="x.AppId"></td>
                            <td class="srk" ng-bind="x.DogName"></td>
                            <td class="srk" ng-bind="x.Date"></td>
                            <td class="srk" ng-bind="x.Service"></td>
                            <td class="srk" ng-bind="x.Comments"></td>
                        </tr>
                    </table>
                            <div>
                     <input class="slogin" type="button" id="autoReminder" value="SendAutoReminder"  onclick="sendAutoReminder();" Style="margin-left:96px;margin-top:20px; float:left" />  

                        </div>
                </div>

                <div class="row masonry masonry-min-height" style="position: relative; height: 866px;">
                    <video position: bottom; autoplay="" loop="" muted="" poster="http://www.bluewheelers.com.au/wp-content/uploads/2016/04/RALPHIE_PLAYING_01_withRed-1.gif" class="ralphie-footer">
                        <source src="http://www.bluewheelers.com.au/wp-content/uploads/2016/04/RALPHIE_PLAYING_01_withRed-1.mp4" type="video/mp4">
                        <source src="http://www.bluewheelers.com.au/wp-content/uploads/2016/04/RALPHIE_PLAYING_01_withRed.webm" type="video/webm">
                        <source src="" type="video/ogg">
                    </video>
                </div>
            </div>
            <div><p style="color:white">Toms Grooming &copy 2018</p><div/>
            </section>
        </div>
	</form>
        
</body>
</html>
