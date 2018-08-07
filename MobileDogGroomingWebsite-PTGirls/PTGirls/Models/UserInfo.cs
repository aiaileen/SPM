using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;

namespace PTGirls.Model
{
    public class UserInfo
    {
        private Int64 userId;
        private string userName;
        private string address;
        private string contactNum;

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
        public string Address
        {
            get { return address; }
            set { address = value; }
        }
        public string ContactNum
        {
            get { return contactNum; }
            set { contactNum = value; }
        }

        public UserInfo() { }

        public UserInfo(Int64 userId)
        {
            this.userId = userId;
        }

        public UserInfo(Int64 userId, string userName, string address, string contactNum)
        {
            this.userId = userId;
            this.userName = userName;
            this.address = address;
            this.contactNum = contactNum;
        }
    }
}