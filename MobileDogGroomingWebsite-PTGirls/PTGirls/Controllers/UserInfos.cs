using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using PTGirls.Model;

namespace PTGirls.Controllers
{
    public class UserInfos : Controller
    {
        public List<UserInfo> uinfoList = new List<UserInfo>();

        public void addUserInfo(UserInfo uinfo)
        {
            uinfoList.Add(uinfo);
        }
    }
}
