using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;
using PTGirls.Model;
namespace PTGirls.Controllers
{
    public class Users
    { 
        public List<User> userList = new List<User>();

        public void addUser(User us){
            userList.Add(us);
        }
        public void addUserInfo(UserInfo usin){
            
        }

        public Boolean hasUser(String username){
            foreach (User user in userList)
            {

                if (user.UserName == username)
                {
                    return true;
                }

            }
            return false;


        }
    }
}