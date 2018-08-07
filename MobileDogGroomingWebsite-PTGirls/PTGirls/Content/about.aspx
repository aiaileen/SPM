<%@ Page Language="C#" AutoEventWireup="true"%>
<!DOCTYPE html>
<link rel="stylesheet" href="/css/app.css">

<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<script type="text/javascript">
      $(document).ready(function () {
                    
      });
    </script>

<html>
<head runat="server">
    <title>About Us</title>
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
                        PTGirls Team (AD03_Group2)

                    </dt>
                   
                    <dd>
   
                        
                        <span style="Width:150px;display:inline-block">Silan Li: 847869</span>

                    </dd>

                    <dd>

                        <span style="Width:150px;display:inline-block">Yinghua Shi: 862150</span>
                    </dd>
                    <dd>

                        <span style="Width:150px;display:inline-block">Yuke Xie: 812482</span>
                    </dd>
                    <dd>

                        <span style="Width:150px;display:inline-block">Ailin Zhang: 874810</span>
                    </dd>
                    <dd>
                        <img src="/schoolLogo.png" height="200" width="200" />
                   </dd>
                </dl>
            </div>

    </form>
</body>
</html>
