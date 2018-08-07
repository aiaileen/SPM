using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;

namespace PTGirls.Model
{
    public class Appointment
    {
        private Int64 appId;
        private Int64 userId;
        private Int64 dogId;
        private string date;
        private string service;
        private string comments;

        public Int64 AppId
        {
            get { return appId; }
            set { appId = value; }
        }
        public Int64 UserId
        {
            get { return userId; }
            set { userId = value; }
        }
        public Int64 DogId
        {
            get { return dogId; }
            set { dogId = value; }
        }
        public string Date
        {
            get { return date; }
            set { date = value; }
        }
        public string Service
        {
            get { return service; }
            set { service = value; }
        }
        public string Comments
        {
            get { return comments; }
            set { comments = value; }
        }

        public Appointment() { }

        public Appointment(Int64 appId)
        {
            this.appId = appId;
        }

        public Appointment(Int64 appId, Int64 userId, Int64 dogId, string date, string service, string comments)
        {
            this.appId = appId;
            this.userId = userId;
            this.dogId = dogId;
            this.service = service;
            this.comments = comments;
            this.date = date;
        }
    }
}