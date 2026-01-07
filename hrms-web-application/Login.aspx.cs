using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;

namespace hrms_web_application
{
    public partial class Login : System.Web.UI.Page
    {
        string connStr = ConfigurationManager
                            .ConnectionStrings["Pulse360DB"]
                            .ConnectionString;

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();

            using (SqlConnection con = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("AuthenticateUser", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@PasswordHash", password); // TODO: hash

                    con.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (!dr.Read())
                        {
                            ShowError("Invalid email or password");
                            return;
                        }

                        string status = dr["Status"].ToString();

                        // ❌ block inactive users
                        if (!status.Equals("Active", StringComparison.OrdinalIgnoreCase))
                        {
                            ShowError("Your account is inactive. Contact admin.");
                            return;
                        }

                        // ✅ session
                        Session["UserId"] = dr["UserId"];
                        Session["UserName"] = dr["FirstName"] + " " + dr["LastName"];
                        Session["Email"] = email;
                        Session["RoleId"] = dr["RoleId"];

                        int roleId = Convert.ToInt32(dr["RoleId"]);
                        RedirectByRole(roleId);
                    }
                }
            }
        }


        private void RedirectByRole(int roleId)
        {
            string url;

            switch (roleId)
            {
                case 3: // Admin
                    url = "~/AdminDashboard.aspx";
                    break;

                case 10: // Employee
                    url = "~/EmployeeDashboard.aspx";
                    break;

                case 8: // Manager
                    url = "~/EmployeeReport.aspx";
                    break;

                default:
                    url = "~/Login.aspx";
                    break;
            }

            Response.Redirect(url, false);
            HttpContext.Current.ApplicationInstance.CompleteRequest();
        }


        private void ShowError(string message)
        {
            ClientScript.RegisterStartupScript(
                this.GetType(),
                "loginError",
                $"alert('{message}');",
                true);
        }

        protected void GoogleLogin_Click(object sender, EventArgs e)
        {
            ClientScript.RegisterStartupScript(
                this.GetType(),
                "googleInfo",
                "alert('Google login coming soon');",
                true);
        }
    }
}
