using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;

namespace PTGirls.Model
{
    public class User
    {
        private Int64 userId;
        private string userName;
        private string password;

        public Int64 UserId
        {
            get { return userId; }
            set { userId = value; }
        }
        public string UserName
        {
            get { return userName; }
            set { userName = value; }
        }
        public string Password
        {
            get { return password; }
            set { password = value; }
        }

        public User() { }

        public User(Int64 userId, string userName, string password)
        {
            this.userId = userId;
            this.userName = userName;
            this.password = password;
        }
    }
}