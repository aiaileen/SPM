using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;

namespace PTGirls.Model
{
    public class Dog
    {
        private Int64 dogId;
        private Int64 ownerId;
        private string name;
        private string breed;
        private string dob;

        public Int64 DogId
        {
            get { return dogId; }
            set { dogId = value; }
        }
        public Int64 OwnerId
        {
            get { return ownerId; }
            set { ownerId = value; }
        }
        public string Name
        {
            get { return name; }
            set { name = value; }
        }
        public string Breed
        {
            get { return breed; }
            set { breed = value; }
        }
        public string DOB{
            get { return dob; }
            set { dob = value; }
        }

        public Dog() { }

        public Dog(Int64 dogId, Int64 ownerId)
        {
            this.dogId = dogId;
            this.ownerId = ownerId;
        }

        public Dog(Int64 dogId, Int64 ownerId, string name, string breed, string DOB)
        {
            this.dogId = dogId;
            this.ownerId = ownerId;
            this.name = name;
            this.breed = breed;
            this.DOB = DOB;
        }
    }
}