using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using PTGirls.Model;

namespace PTGirls.Controllers
{
    public class Dogs : Controller
    {
        public List<Dog> dogList = new List<Dog>();

        public void addDog(Dog dog)
        {
            dogList.Add(dog);
        }
    }
}
