using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace hrms_web_application
{
    public partial class AdminMaster : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadHeaderUser();
            }
        }

        private void LoadHeaderUser()
        {
            if (Session["UserId"] == null)
                return;

            string cs = ConfigurationManager
                .ConnectionStrings["Pulse360DB"]
                .ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(@"
                    SELECT 
                        FirstName,
                        LastName,
                        Email,
                        ProfilePicture
                    FROM [User]
                    WHERE UserId = @UserId
                ", con);

                cmd.Parameters.AddWithValue("@UserId", Session["UserId"]);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    // Name
                    lblHeaderUserName.Text =
                        dr["FirstName"] + " " + dr["LastName"];

                    // Email
                    lblHeaderEmail.Text =
                        dr["Email"]?.ToString();

                    // Profile Image
                    string imgPath =
                        dr["ProfilePicture"]?.ToString();

                    if (!string.IsNullOrWhiteSpace(imgPath))
                    {
                        imgProfileHeader.ImageUrl = imgPath;
                        imgProfileLarge.ImageUrl = imgPath;
                    }
                    else
                    {
                        imgProfileHeader.ImageUrl =
                            "/assets/img/profiles/default.png";
                        imgProfileLarge.ImageUrl =
                            "/assets/img/profiles/default.png";
                    }
                }
            }
        }
    }
}


