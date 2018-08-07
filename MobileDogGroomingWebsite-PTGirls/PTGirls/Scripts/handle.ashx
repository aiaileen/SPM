<%@ WebHandler Language="C#" Class="PTGirls.Scripts.handle" %>
using System;
using System.Web;
using System.Web.SessionState;
using PTGirls.Model;
using PTGirls.Controllers;
using System.IO;
using System.Text;
using System.Security.AccessControl;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using Newtonsoft.Json.Linq;
using System.Security.AccessControl;

using System.Linq;
using System.Net.Mail;

using System.Net;
using System.Security;
using System.Threading.Tasks;
namespace PTGirls.Scripts
{

	public class handle : System.Web.IHttpHandler, IRequiresSessionState
	{
        public Users users = new Users();
        public UserInfos uinfos = new UserInfos();
        public Appointments apps = new Appointments();
        public Dogs dogs = new Dogs();
        public string userPath = "user.txt";
        public string userInfoPath = "userInfo.txt";
        public string dogPath = "dog.txt";
        public string appointmentPath = "Appointment.txt";

		public void ProcessRequest (HttpContext context)
		{
            context.Response.ContentType = "text/plain";
            string flag = context.Request["flag"];

            string result = "";

            if (flag == "register")
            {  
                string userName = context.Request["UserName"];
                string password = context.Request["Password"];

                readUserContent("user.txt");
                long idNum = users.userList.Count;
                string idNo = idNum.ToString();
                string writeIn = idNo+","+userName+","+password;

                User currentUser = new User(idNum, userName, password);

                if(!users.hasUser(userName))
                {
                    userWrite(userPath,writeIn);
                    users.addUser(currentUser);
                    long temp = idNum*12;
                    result = temp.ToString();   
                }
                else
                {
                    result = "This name is already used. Please change into another one.";
                }

                context.Response.Write(result);
                
            }
            else if (flag == "login")
            { 

                string userName = context.Request["UserName"];
                string password = context.Request["Password"];

                readUserContent("user.txt");

                for (int i = 0; i < users.userList.Count;i++)
                {
                    if(users.userList[i].UserName ==userName)
                    {
                        if (users.userList[i].Password == password)
                        {
                            long cipherUserId = (users.userList[i].UserId-1)*12;
                            result = cipherUserId.ToString();
                        }
                        else
                        {

                            result = "err,Your password is not right. Please check.";
                        }
                    }

                }
                if (result == "")
                    result = "err,Your account cannot be found. Please register first.";

                context.Response.Write(result);
            }
            else if (flag=="loadMailAddress")
            {
                int currentUserID = int.Parse(context.Request["UserId"])/12;

                readUserContent("user.txt");

                for (int i = 0; i < users.userList.Count;i++)
                {
                    if(users.userList[i].UserId-1 ==currentUserID)
                    {
                        result = users.userList[i].UserName;

                    }

                }
                if (result == "")
                    result = "err";

                context.Response.Write(result);

            }
            else if (flag=="sendMail"){

                string mailTo = context.Request["MailTo"];
                string userName = context.Request["UserName"];
                string dogName = context.Request["DogName"];
                string appDate = context.Request["Date"];
                string writeIn = "Dear "+userName+"," + "\r\n";
                writeIn = writeIn + "" + "\r\n";
                writeIn = writeIn + "You have an appointment for your pet "+dogName+" on "+ appDate+ ".\r\n";
                writeIn = writeIn + "We are looking forward to meet you then!" + "\r\n";
                writeIn = writeIn + "" + "\r\n";
                //writeIn = writeIn + "Yours sincerely," + "\r\n";
                writeIn = writeIn + "Tom's Grooming Team" + "\r\n";
                writeIn = writeIn+ System.DateTime.Now.ToString("G");
                SendEmail(writeIn,mailTo);
                context.Response.Write("0");
            }
            else if (flag == "editUserInfo")
            { 
                int currentUserID = int.Parse(context.Request["UserId"])/12;
                string userName = context.Request["UserName"];
                string address = context.Request["Address"];
                string contactnum = context.Request["ContactNum"];

                string writeIn = currentUserID.ToString()+","+userName+","+address+","+contactnum;
                userInfoWrite(userInfoPath,writeIn);
                context.Response.Write("0");
            }

            else if (flag == "addDogInfo")
            { 

                int currentUserID = int.Parse(context.Request["UserId"])/12;
                string dogName = context.Request["DogName"];
                string dogBreed = context.Request["DogBreed"];
                string dogDOB = context.Request["DogDOB"];

                string writeIn = ","+currentUserID.ToString()+","+dogName+","+dogBreed+","+dogDOB;
                dogWrite(dogPath,writeIn);
                context.Response.Write("0");
            }

            else if (flag == "addApp")
            { 
                int currentUserID = int.Parse(context.Request["UserId"])/12;
                string service = context.Request["Service"];
                string dogid = context.Request["DogId"];
                string appDate = context.Request["AppDate"];
                string comment = context.Request["Comment"];

                string writeIn = ","+currentUserID.ToString()+","+dogid+","+appDate+","+service+","+comment;
                result = appWrite(appointmentPath,writeIn,appDate);
                context.Response.Write(result);

            }  

            else if (flag == "editApp")
            { 
                string appID = context.Request["AppId"];
                int currentUserID = int.Parse(context.Request["UserId"])/12;
                string service = context.Request["Service"];
                string dogid = context.Request["DogId"];
                string appDate = context.Request["AppDate"];
                string comment = context.Request["Comment"];

                string writeIn = appID+","+currentUserID.ToString()+","+dogid+","+appDate+","+service+","+comment;
                result = appEdit(appointmentPath,writeIn,appDate);
                context.Response.Write(result);

            }            
            else if (flag == "deleteApp")
            { 
                int appId = int.Parse(context.Request["AppId"]);
                result = appDelete(appointmentPath,appId);
                context.Response.Write(result);

            }
            else if (flag == "initiate")
            { 

                readUserContent("user.txt");

            }

            else if (flag == "loadApp")
            { 
                int currentUserID = int.Parse(context.Request["UserId"])/12;
                long cuId = currentUserID;
                result = readAppContent(appointmentPath,cuId);
                context.Response.Write(result);

            }            
            else if (flag == "loadAppAdmin")
            { 
                int appId = int.Parse(context.Request["AppId"]);
                result = readAppAdmin(appointmentPath,appId);
                context.Response.Write(result);

            }
            else if (flag == "loadAllApp")
            { 
                result = readAppContent(appointmentPath,0);
                context.Response.Write(result);

            }

            else if (flag == "loadInfo")
            { 
                int currentUserID = int.Parse(context.Request["UserId"])/12;
                long userid = currentUserID;
                result = readUserInfoContent(userInfoPath,userid);
                context.Response.Write(result);

            }
            else if (flag == "loadAllUsers")
            { 
                result = readAllUserContent(userInfoPath);
                context.Response.Write(result);

            }
            else if (flag == "loadDog")
            { 
                int dogid = int.Parse(context.Request["DogId"]);
                result = readDogProfile(dogPath,dogid);
                context.Response.Write(result);

            }
            else if (flag == "loadDogs")
            { 
                int currentUserID = int.Parse(context.Request["UserId"])/12;
                result = readDogContent(dogPath,currentUserID,0);
                context.Response.Write(result);

            }
            else if (flag == "loadAllDogs")
            { 
                result = readAllDogContent(dogPath);
                context.Response.Write(result);

            }

		}
	
		public bool IsReusable {
			get {
				return false;
			}
		}
        public void readUserContent(string Path)
        {
            StreamReader sr = new StreamReader(Path, Encoding.Default);
            string content;
            while ((content = sr.ReadLine()) != null)
            {
                User user = new User(users.userList.Count+1,content.Split(',')[1],content.Split(',')[2]);
                users.addUser(user);
            }
            sr.Dispose();
            sr.Close();
        }

        public string readAllUserContent(string Path)
        {
            string rtn = "";

            StreamReader sr = new StreamReader(Path, Encoding.Default);
            string content;
            while ((content = sr.ReadLine()) != null)
            {
                int userId = int.Parse(content.Split(',')[0]);
                string userName = content.Split(',')[1];
                string address = content.Split(',')[2];
                string contactNum = content.Split(',')[3];
                UserInfo uinfo = new UserInfo(userId, userName, address, contactNum);
                uinfos.addUserInfo(uinfo);
            }
            rtn = JsonConvert.SerializeObject(uinfos.uinfoList);
            sr.Dispose();
            sr.Close();
            return rtn;
        }

        public string readUserInfoContent(string Path,long userId)
        {

            string rtn = ""; 
            UserInfo uinfo;             StreamReader sr = new StreamReader(Path, Encoding.Default);             string content;             while ((content = sr.ReadLine()) != null)             {                                  string urId = content.Split(',')[0];
                long userid = long.Parse(urId);
                if(userid == userId)
                {                     string userName = content.Split(',')[1];                     string userAddress = content.Split(',')[2].ToString();                     string contactNum = content.Split(',')[3].ToString();                      uinfo = new UserInfo(long.Parse(urId), userName, userAddress, contactNum.Trim());                      rtn = JsonConvert.SerializeObject(uinfo);                 
                }              }             sr.Dispose();             sr.Close();
            return rtn;
        }

        public string readAllDogContent(string Path)
        {
            string rtn = "";
            StreamReader sr = new StreamReader(Path, Encoding.Default);
            string content;
            while ((content = sr.ReadLine()) != null)
            {
                int dogId = int.Parse(content.Split(',')[0]);
                int userId = int.Parse(content.Split(',')[1]);
                string dogName = content.Split(',')[2];
                string breed = content.Split(',')[3];
                string dob = content.Split(',')[4];

                Dog cuDog = new Dog(dogId, userId, dogName, breed, dob);
                dogs.addDog(cuDog);
            }
            rtn = JsonConvert.SerializeObject(dogs.dogList);
            sr.Dispose();
            sr.Close();
            return rtn;
        }

        public string readDogProfile(string Path,int cuDogId)
        {
            string rtn = "";
            StreamReader sr = new StreamReader(Path, Encoding.Default);
            string content;
            while ((content = sr.ReadLine()) != null)
            {

                int dogId = int.Parse(content.Split(',')[0]);
                if (dogId == cuDogId){
                    int userId = int.Parse(content.Split(',')[1]);
                    string dogName = content.Split(',')[2];
                    string breed = content.Split(',')[3];
                    string dob = content.Split(',')[4];

                    Dog cuDog = new Dog(dogId, userId, dogName, breed, dob);
                    dogs.addDog(cuDog);
                }
            }
            rtn = JsonConvert.SerializeObject(dogs.dogList);
            sr.Dispose();
            sr.Close();
            return rtn;
        }
        public string readDogContent(string Path, int cuUserId, int cuDogId)
        {
            string rtn = "";
            StreamReader sr = new StreamReader(Path, Encoding.Default);
            string content;
            while ((content = sr.ReadLine()) != null)
            {
                string urid = content.Split(',')[1].ToString();
                int userId = int.Parse(urid);
                if (userId == cuUserId)
                {
                    int dogId = int.Parse(content.Split(',')[0]);
                    if (cuDogId != 0)
                    {
                        if (dogId == cuDogId){

                            string dogName = content.Split(',')[2];
                            string breed = content.Split(',')[3];
                            string dob = content.Split(',')[4];

                            Dog cuDog = new Dog(dogId, userId, dogName, breed, dob);
                            dogs.addDog(cuDog);
                        }

                    }
                    else
                    {
                        string dogName = content.Split(',')[2];
                        string breed = content.Split(',')[3];
                        string dob = content.Split(',')[4];

                        Dog cuDog = new Dog(dogId, userId, dogName, breed, dob);
                        dogs.addDog(cuDog);
                    }
                }
            }
            rtn = JsonConvert.SerializeObject(dogs.dogList);
            sr.Dispose();
            sr.Close();
            return rtn;
        }

        public string readAppContent(string Path, long cuId)
        {
            string rtn= "";
            StreamReader sr = new StreamReader(Path, Encoding.Default);
            string content;
            while ((content = sr.ReadLine()) != null)
            {
                string urid = content.Split(',')[1].ToString();
                long userId = long.Parse(urid);
                if(userId == cuId||cuId==0)                 {                     long appId = long.Parse(content.Split(',')[0]);                     long dogId = long.Parse(content.Split(',')[2]);
                    string date = content.Split(',')[3];                     string service = content.Split(',')[4];                     string comments = "";                     if(content.Split(',')[5]!=null)                         comments = content.Split(',')[5].ToString();                     Appointment app = new Appointment(appId,userId,dogId,date,service,comments);                     apps.addApp(app);                 }
            }
            rtn = JsonConvert.SerializeObject(apps.appList);
            sr.Dispose();
            sr.Close();
            return rtn;
        }

        public string readAppAdmin(string Path, int appId)
        {
            string rtn = "";
            StreamReader sr = new StreamReader(Path, Encoding.Default);
            string content;
            while ((content = sr.ReadLine()) != null)
            {
                int appid = int.Parse(content.Split(',')[0]);
                if (appid==appId)
                {
                    int ownerId = int.Parse(content.Split(',')[1]);
                    int dogId = int.Parse(content.Split(',')[2]);
                    string date = content.Split(',')[3];
                    string service = content.Split(',')[4];
                    string comments = "";
                    if (content.Split(',')[5] != null)
                        comments = content.Split(',')[5].ToString();
                    Appointment app = new Appointment(appId, ownerId, dogId, date, service, comments);
                    apps.addApp(app);
                }
            }
            rtn = JsonConvert.SerializeObject(apps.appList);
            sr.Dispose();
            sr.Close();
            return rtn;
        }
        public void userWrite(string path,string writeIn)
        {
            StreamReader sr = new StreamReader(path, Encoding.Default);             string content;             String writeLine = "";             while ((content = sr.ReadLine()) != null)             {
                if(content!=writeIn)                     writeLine = writeLine+content+"\r\n" ;             }             sr.Dispose();             sr.Close();              FileStream fs = new FileStream(path, FileMode.Create, FileAccess.ReadWrite);             StreamWriter sw = new StreamWriter(fs,Encoding.Default);              writeLine= writeLine+writeIn;             try {                 sw.Write(writeLine);                 sw.Flush();                 sw.Close();                 fs.Close();             } 
            catch (FileNotFoundException e) {             } 
            catch (IOException e) {             } 
            finally {             } 
        }
        public void userInfoWrite(string path,string writeIn)
        {
            StreamReader sr = new StreamReader(path, Encoding.Default);
            string content;
            bool flag = true;
            String writeLine = "";
            while ((content = sr.ReadLine()) != null)
            {
                if(content.Split(',')[0]!=writeIn.Split(',')[0])
                {

                    writeLine = writeLine + content + "\r\n";

                }
                else
                {

                    writeLine = writeLine + writeIn + "\r\n";
                    flag = false;
                }
            }
            sr.Dispose();
            sr.Close();

            FileStream fs = new FileStream(path, FileMode.Create, FileAccess.ReadWrite);
            StreamWriter sw = new StreamWriter(fs,Encoding.Default);
            if(flag)writeLine= writeLine+writeIn;
            try {
                sw.Write(writeLine);
                sw.Flush();
                sw.Close();
                fs.Close();
            } 
            catch (FileNotFoundException e) {
            } 
            catch (IOException e) {
            } 
            finally {
            }

        }

        public string appWrite(string path, string writeIn, string appDate)
        {
            StreamReader sr = new StreamReader(path, Encoding.Default);
            string content;
            string appId;
            int temp = 0;
            String writeLine = "";
            while ((content = sr.ReadLine()) != null)
            {
                if (temp < int.Parse(content.Split(',')[0])) temp = int.Parse(content.Split(',')[0]);
                if (content.Split(',')[3] != appDate)
                    writeLine = writeLine + content + "\r\n";
                else
                {
                    sr.Dispose();
                    sr.Close();
                    return "This time is already booked by another customer. Please arrange a new time.";
                }
            }
            sr.Dispose();
            sr.Close();

            temp = temp + 1;
            appId = temp.ToString();
            writeIn = appId + writeIn;
            FileStream fs = new FileStream(path, FileMode.OpenOrCreate, FileAccess.ReadWrite);
            StreamWriter sw = new StreamWriter(fs, Encoding.Default);

            writeLine = writeLine + writeIn;
            try
            {
                sw.Write(writeLine);
                sw.Flush();
                sw.Close();
                fs.Close();
            }
            catch (FileNotFoundException e)
            {
            }
            catch (IOException e)
            {
            }
            finally
            {
            }
            return "0";

        }
        public string appEdit(string path, string writeIn, string appDate)
        {
            StreamReader sr = new StreamReader(path, Encoding.Default);
            string content;
            string appId;
            String writeLine = "";
            while ((content = sr.ReadLine()) != null)
            {
                if (content.Split(',')[3] != appDate)
                {
                    if(content.Split(',')[0]!=writeIn.Split(',')[0])
                    {

                        writeLine = writeLine + content + "\r\n";

                    }
                    else
                    {

                        writeLine = writeLine + writeIn + "\r\n";
                    }

                }
                else
                {
                    if(content.Split(',')[0]==writeIn.Split(',')[0])
                    {
                        writeLine = writeLine + writeIn + "\r\n";
                    }
                    else
                    {
                        sr.Dispose();
                        sr.Close();
                        return "This time is already booked by another customer. Please arrange a new time.";
                    }
                }
            }
            sr.Dispose();
            sr.Close();

            FileStream fs = new FileStream(path, FileMode.Create, FileAccess.ReadWrite);
            StreamWriter sw = new StreamWriter(fs, Encoding.Default);

            try
            {
                sw.Write(writeLine);
                sw.Flush();
                sw.Close();
                fs.Close();
            }
            catch (FileNotFoundException e)
            {
            }
            catch (IOException e)
            {
            }
            finally
            {
            }
            return "0";

        }

        public string appDelete(string path, int appId)
        {
            StreamReader sr = new StreamReader(path, Encoding.Default);
            string content;
            String writeLine = "";
            while ((content = sr.ReadLine()) != null)
            {
                if (int.Parse(content.Split(',')[0])!= appId)
                {
                    writeLine = writeLine + content + "\r\n";
                }

            }
            sr.Dispose();
            sr.Close();

            FileStream fs = new FileStream(path, FileMode.Create, FileAccess.ReadWrite);
            StreamWriter sw = new StreamWriter(fs, Encoding.Default);

            try
            {
                sw.Write(writeLine);
                sw.Flush();
                sw.Close();
                fs.Close();
            }
            catch (FileNotFoundException e)
            {
            }
            catch (IOException e)
            {
            }
            finally
            {
            }
            return "0";

        }
        public void dogWrite(string path, string writeIn)
        {
            StreamReader sr = new StreamReader(path, Encoding.Default);
            string content;
            string dogId;
            int temp = 0;
            String writeLine = "";
            while ((content = sr.ReadLine()) != null)
            {
                if (temp < int.Parse(content.Split(',')[0]))temp = int.Parse(content.Split(',')[0]);
                writeLine = writeLine + content + "\r\n";
            }
            sr.Dispose();
            sr.Close();

            temp = temp + 1;
            dogId = temp.ToString();
            writeIn = dogId + writeIn;
            FileStream fs = new FileStream(path, FileMode.OpenOrCreate, FileAccess.ReadWrite);
            StreamWriter sw = new StreamWriter(fs, Encoding.Default);

            writeLine = writeLine + writeIn;
            try
            {
                sw.Write(writeLine);
                sw.Flush();
                sw.Close();
                fs.Close();
            }
            catch (FileNotFoundException e)
            {
            }
            catch (IOException e)
            {
            }
            finally
            {
            }

        }
        public bool SendEmail(string writeIn,string mailTo) 
        {
            
            string smtpServer = "smtp.163.com"; 
            string mailFrom = "clefairys@163.com"; 
            string userPassword = "lyflivkimboa";

            SmtpClient smtpClient = new SmtpClient();
            smtpClient.DeliveryMethod = SmtpDeliveryMethod.Network;
            smtpClient.Host = smtpServer; 
            smtpClient.Credentials = new System.Net.NetworkCredential(mailFrom, userPassword);
            smtpClient.EnableSsl = true;

            MailMessage mailMessage = new MailMessage(mailFrom, mailTo);

            mailMessage.Subject = "Auto Reminder from Tom's Grooming"; 
            mailMessage.Body = writeIn;
            mailMessage.BodyEncoding = Encoding.UTF8;
            mailMessage.IsBodyHtml = true;
            mailMessage.Priority = MailPriority.Low;

            try
            {
                smtpClient.Send(mailMessage); 
                return true;
            }
            catch (SmtpException ex)
            {
                
                return false;
            }

        }
	}
}
