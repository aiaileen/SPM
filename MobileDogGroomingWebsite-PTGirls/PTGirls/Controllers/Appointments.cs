using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using PTGirls.Model;
namespace PTGirls.Controllers
{
    public class Appointments : Controller
    {
        public List<Appointment> appList = new List<Appointment>();

        public void addApp(Appointment app)
        {
            appList.Add(app);
        }

    }
}
