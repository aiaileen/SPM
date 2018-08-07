<%@ Page Language="C#" Inherits="PTGirls.Content.manage" AutoEventWireup="true" CodeFile="manage.aspx.cs"%>
<!DOCTYPE html>
<link rel="stylesheet" href="/css/app.css">
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<script src="http://cdn.static.runoob.com/libs/angular.js/1.4.6/angular.min.js"></script>
<style type="text/css">
.viewtable{
color:#1f69dd;font-size:16px;font-weight:bold;
}
</style>
<script type="text/javascript">
       var userId;
       var pickDate = "";
       $(document).ready(function () {
        });
        //Angular Part
        var app = angular.module("confirmsModule", []);
        app.controller("confirmsController", function ($scope, $http) {
                $scope.find = function () {
                    $http({
                        method: "GET",
                        async: false,
                        url: "/Scripts/handle.ashx",
                        params: { "flag": "loadAllApp" }
                    }).success(function (data) {
                        var dogs;
                        var users;
                        if(data!=""){
                            $scope.names = data;
                            jQuery.ajax({
                                    type: "post",
                                    async: false,
                                    timeout: 2000,
                                    url: "/Scripts/handle.ashx",
                                    data: { flag: "loadAllDogs",UserId: userId },
                                    dataType: "text",
                                    cache: false,
                                    success: function (data) {
                                        dogs = JSON.parse(data);
                                    },
                                    error: function (err) {
                                        alert("LoadAllDogInfo Error");
                                    }
                                });
    
                            for(var i = 0;i<$scope.names.length;i++){
                                 for(var j=0;j< dogs.length;j++){
                                     if($scope.names[i].DogId==dogs[j].DogId)
                                         $scope.names[i].DogName = dogs[j].Name;
                                 }
                            }
                            jQuery.ajax({
                                    type: "post",
                                    async: false,
                                    timeout: 2000,
                                    url: "/Scripts/handle.ashx",
                                    data: { flag: "loadAllUsers" },
                                    dataType: "text",
                                    cache: false,
                                    success: function (data) {
                                        users = JSON.parse(data);
                                    },
                                    error: function (err) {
                                        alert("LoadAllUserInfo Error");
                                    }
                                });

                           for(var i = 0;i<$scope.names.length;i++){
                                for(var j=0;j< users.length;j++){
                                    if($scope.names[i].UserId==users[j].UserId){
                                        $scope.names[i].OwnerName = users[j].UserName;
                                        $scope.names[i].ContactNum = users[j].ContactNum;
                                        $scope.names[i].Address = users[j].Address;
                                    }
                                }
                           }
                           for(var i = 0;i<$scope.names.length;i++){
                               if(pickDate!=""){ 
                                   if($scope.names[i].Date.split(' ')[0]==pickDate)
                                        $scope.names[i].pickdate = false;
                                   else
                                        $scope.names[i].pickdate = true;
                               }
                               else
                                    $scope.names[i].pickdate = false;
                           }

                        }
                    }).error(function () {
                        alert("LoadAllApp Error");
                    });

                };
                $scope.find();
        });
        function changePickDate(){
            if(!($("#pickDate").val()=="")){
                var day = $("#pickDate").val().split('/')[0].replace('0','');
                var month = $("#pickDate").val().split('/')[1].replace('0','');
                var year = $("#pickDate").val().split('/')[2];
                pickDate = day+'/'+month+'/'+year;
            }
            else
                pickDate = "";
            var a = $('div[ng-controller="confirmsController"]').scope();
            a.find();
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
                                    window.location.replace("manage.aspx");
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
        function editClick(userId,service,dogid,appdate,comment){
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
                            var UserId = appInfo[0].UserId;
                            userId = parseInt(UserId)*12;
                            $("#hidden_currentUserId").val(userId);
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

                            var a = $('div[ng-controller="confirmsController"]').scope();
                            a.find();
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
            var userId = $("#hidden_currentUserId").val();
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
                if(confirm("Do you wish to update this appointment?")){
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
        function sendAutoReminder(){
            if(checkUnique()){
                var unik = 0;
                var a = document.getElementsByClassName("ckbx");
                for(var i =0;i<a.length;i++){
                    if(a[i].checked){
                        var b = a[i];
                    }
                }
                var userName = b.parentElement.parentElement.childNodes[7].innerHTML
                var petName = b.parentElement.parentElement.childNodes[13].innerHTML;
                var time = b.parentElement.parentElement.childNodes[5].innerHTML;
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
                            var UserId = appInfo[0].UserId;
                            userId = parseInt(UserId)*12;
                            $("#hidden_currentUserId").val(userId);

                            }
                        else{
                            alert("LoadAppAdmin Error");
                        }
                    },
                    error: function (err) {
                        alert("LoadAppAdmin Error");
                    }
               });
    
                var userId = $("#hidden_currentUserId").val();
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
        function closeClick(){
            $("#addAppTable").hide(500);
        }
</script>
<html>
<head runat="server">
    <title>Management</title>
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
                            <a href="">Edit Admin Profile</a>
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
                    Appointments View

                </dt>
            </dl>
        </div>
        <div id="appview" ng-app="confirmsModule" ng-controller="confirmsController">

        <div class="container">
            <div class="slogin" style="margin-bottom:20px;margin-left:20px;">
                    <ul>
                        <input class="slogin" type="button" id="editBtn" value="Edit"  onclick="editClick()" Style="margin-right:26px; float:left" />  
                        <input class="slogin" type="button" id="cancelBtn" value="Cancel"  onclick="cancelClick()" Style="margin-right:26px; float:left" />  
                        <input class="slogin" type="button" id="reminderBtn" value="SendReminder"  onclick="sendAutoReminder()" Style="margin-right:26px; float:left" /> 
                        <input class="slogin" type="button" id="changeShowBtn" value="ShowOnlyOn"  onclick="changePickDate()"  Style="float:left"/> 
                        <input type="text" id="pickDate" /><asp:Label runat="server" ID="dateFormat" Style="color:#1196EE;weight:bold;">DD/MM/YYYY</asp:Label>
                    </ul>
            </div>
            <div>   
            <table id="addAppTable" style="display:none;height: 100%;width:950px;background-color:white;margin-bottom:50px;" align="center">
                        <tr>
                            <td width="40%">
                                <span>Choose your pet:</span> 
                            </td>
                            <td>
                                <select id="dogsList"></select>
                                <a id="go2edit" href="" style="color:orange;padding-left:140px;"> Go add a new pet</a>
                                <input id="hidden_currentUserId" type="text" style="display:none;"/>
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
                                <div class="btn">
                                    <a href="" style="margin-right:40px;" onclick="rescheduleClick();">Edit</a>
                                </div>
                                <div class="btn">
                                    <a href="" style="margin-right:40px;" onclick="closeClick();">Close</a>
                                </div>
                            </td>   
                        </tr>
                    </table>
                <table id="appList" style="height: 100%;width:1050px;margin-left:50px;" align="left">
                    <tr>
                        <td class="viewtable" style="width: 2%"></td>
                        <td class="viewtable" style="width: 2%;">No</td>
                        <td class="viewtable" style="width: 15%">Time</td>
                        <td class="viewtable" style="width: 15%">Owner Name</td>
                        <td class="viewtable" style="width: 15%">Contact Number</td>
                        <td class="viewtable" style="width: 15%">Address</td>
                        <td class="viewtable" style="width: 10%">DogName</td>
                        <td class="viewtable" style="width: 10%">Service</td>
                        <td class="viewtable" style="width: 20%">Comments</td>
                    </tr>
                    <tr  ng-repeat="x in names" ng-hide="x.pickdate">
                        <td id="ckBx"><input class="ckbx"id="checkBox" type="checkbox" / ></td>
                        <td id="appId" class="appid" ng-bind="x.AppId"></td>
                        <td class="srk" ng-bind="x.Date"></td>
                        <td class="srk" ng-bind="x.OwnerName"></td>
                        <td class="srk" ng-bind="x.ContactNum"></td>
                        <td class="srk" ng-bind="x.Address"></td>
                        <td class="srk" ng-bind="x.DogName"></td>
                        <td class="srk" ng-bind="x.Service"></td>
                        <td class="srk" ng-bind="x.Comments"></td>
                    </tr>
                </table>
            </div>
        </div>
        </div>
            <div><table><tr style="height:100px;"></tr></table></div>
    </form>
</body>
</html>
