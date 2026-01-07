using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace hrms_web_application
{
    public partial class AddDepartment : System.Web.UI.Page
    {

        private static readonly string cs =
            ConfigurationManager.ConnectionStrings["Pulse360DB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // 🔐 Admin-only protection
            if (Session["UserId"] == null || Session["RoleId"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            int roleId = Convert.ToInt32(Session["RoleId"]);
            if (roleId != 3) // Admin only
            {
                Response.Redirect("Login.aspx");
                return;
            }
        }

        // ===================== FETCH DEPARTMENTS =====================
        [WebMethod]
        [System.Web.Script.Services.ScriptMethod(ResponseFormat = System.Web.Script.Services.ResponseFormat.Json)]
        public static List<DepartmentDTO> GetDepartments()
        {
            List<DepartmentDTO> list = new List<DepartmentDTO>();

            string cs = ConfigurationManager
                        .ConnectionStrings["Pulse360DB"]
                        .ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                using (SqlCommand cmd = new SqlCommand("GetAllDepartments", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            list.Add(new DepartmentDTO
                            {
                                DepartmentId = Convert.ToInt32(dr["DepartmentId"]),
                                Name = dr["Name"].ToString(),
                                NoOfEmployee = Convert.ToInt32(dr["NoOfEmployee"]),
                                Status = dr["Status"].ToString(),
                                CreatedBy = dr["CreatedBy"].ToString(),
                                ModifiedBy = dr["ModifiedBy"].ToString()
                            });
                        }
                    }
                }
            }

            return list;
        }


        [WebMethod]
        [System.Web.Script.Services.ScriptMethod(ResponseFormat =
 System.Web.Script.Services.ResponseFormat.Json)]
        public static DepartmentDTO GetDepartmentById(int departmentId)
        {
            DepartmentDTO d = null;

            string cs = ConfigurationManager
                .ConnectionStrings["Pulse360DB"]
                .ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                using (SqlCommand cmd = new SqlCommand("GetDepartmentById", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@DepartmentId", departmentId);

                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            d = new DepartmentDTO
                            {
                                DepartmentId = Convert.ToInt32(dr["DepartmentId"]),
                                Name = dr["Name"].ToString(),
                                Status = dr["Status"].ToString()
                            };
                        }
                    }
                }
            }

            return d;
        }




        // ===================== ADD DEPARTMENT =====================
        [WebMethod]
        public static string AddNewDepartment(string name, string status)
        {
            string cs = ConfigurationManager
                .ConnectionStrings["Pulse360DB"]
                .ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                using (SqlCommand cmd = new SqlCommand("AddNewDepartment", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@Name", name.Trim());
                    cmd.Parameters.AddWithValue("@Status", status);
                    cmd.Parameters.AddWithValue(
                        "@CreatedBy",
                        HttpContext.Current.Session["UserName"]?.ToString() ?? "Admin"
                    );

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            return "success";
        }




        // ===================== UPDATE DEPARTMENT =====================
        [WebMethod]
        public static string UpdateDepartment(int departmentId, string name, string status)
        {
            string cs = ConfigurationManager
                .ConnectionStrings["Pulse360DB"]
                .ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                using (SqlCommand cmd = new SqlCommand("UpdateDepartment", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@DepartmentId", departmentId);
                    cmd.Parameters.AddWithValue("@Name", name.Trim());
                    cmd.Parameters.AddWithValue("@Status", status);
                    cmd.Parameters.AddWithValue(
                        "@ModifiedBy",
                        HttpContext.Current.Session["UserName"]?.ToString() ?? "Admin"
                    );

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            return "updated";
        }



        // ===================== DELETE DEPARTMENT =====================
        [WebMethod]
        public static string DeleteDepartment(int departmentId)
        {
            string cs = ConfigurationManager
                .ConnectionStrings["Pulse360DB"]
                .ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                using (SqlCommand cmd = new SqlCommand("DeleteDepartment", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@DepartmentId", departmentId);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            return "deleted";
        }


        // ===================== TOGGLE STATUS =====================
        [WebMethod]
        public static string ToggleDepartmentStatus(int departmentId)
        {
            string cs = ConfigurationManager
                .ConnectionStrings["Pulse360DB"]
                .ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                using (SqlCommand cmd = new SqlCommand("ToggleDepartmentStatus", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@DepartmentId", departmentId);
                    cmd.Parameters.AddWithValue(
                        "@ModifiedBy",
                        HttpContext.Current.Session["UserName"]?.ToString() ?? "Admin"
                    );

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            return "toggled";
        }


        public class DepartmentDTO
        {
            public int DepartmentId { get; set; }
            public string Name { get; set; }
            public int NoOfEmployee { get; set; }
            public string Status { get; set; }
            public string CreatedBy { get; set; }
            public string ModifiedBy { get; set; }
        }

       

    }
}