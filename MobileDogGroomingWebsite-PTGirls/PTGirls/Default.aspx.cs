using System;
using System.Web;
using System.Web.UI;
using System.Collections.Generic;
using PTGirls.Model;
using PTGirls.Controllers;
using System.IO;
using System.Text;
using System.Security.AccessControl;

using System.Linq;
using System.Net.Mail;

using System.Net;
using System.Security;
using System.Threading.Tasks;
namespace PTGirls
{

    public partial class Default : System.Web.UI.Page
    {
        User currentUser = new User();

        public Users users = new Users();

        protected void Page_Load(object sender, EventArgs e)
        {


            //SendEmail(writeIn);


            if (!IsPostBack)
            {
            }
        }



    }

}
