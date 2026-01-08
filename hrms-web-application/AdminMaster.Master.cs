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
            LoadHeaderUser();
            if (!IsPostBack)
            {
                
            }
        }

        protected string GetPriorityBadge(object priority)
        {
            if (priority == null || priority == DBNull.Value)
                return "badge bg-secondary";

            string p = priority.ToString().ToLower();

            switch (p)
            {
                case "high":
                    return "badge bg-danger";
                case "medium":
                    return "badge bg-warning";
                case "low":
                    return "badge bg-success";
                default:
                    return "badge bg-secondary";
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
                        if (!imgPath.StartsWith("/"))
                            imgPath = "/Content/uploads/" + imgPath;

                        Session["Epath"] = imgPath;
                        Session["Name"] = dr["FirstName"] + " " + dr["LastName"];

                        imgProfileHeader.ImageUrl = ResolveUrl(imgPath);
                        imgProfileLarge.ImageUrl = ResolveUrl(imgPath);
                    }
                    else
                    {
                        Session["Epath"] = "/assets/img/profiles/default.png";
                    }

                }
            }
        }
    }
}
