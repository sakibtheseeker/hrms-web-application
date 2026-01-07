using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.Services;
using System.Web.UI;

namespace hrms_web_application
{
    public partial class AddRole : System.Web.UI.Page
    {
        private static readonly string cs =
            ConfigurationManager.ConnectionStrings["Pulse360DB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // ❗ DO NOT redirect here
            // Page_Load must NOT block AJAX WebMethods
        }

        // ===================== FETCH ROLES =====================
        [WebMethod(EnableSession = true)]
        public static List<RoleDTO> GetRoles()
        {
            List<RoleDTO> list = new List<RoleDTO>();

            string cs = ConfigurationManager
                .ConnectionStrings["Pulse360DB"]
                .ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                using (SqlCommand cmd = new SqlCommand("GetAllRoles", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            list.Add(new RoleDTO
                            {
                                RoleId = Convert.ToInt32(dr["RoleId"]),
                                RoleName = dr["RoleName"].ToString(),
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


        // ===================== GET ROLE BY ID =====================
        [WebMethod(EnableSession = true)]
        public static RoleDTO GetRoleById(int roleId)
        {
            RoleDTO role = null;

            string cs = ConfigurationManager
                .ConnectionStrings["Pulse360DB"]
                .ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                using (SqlCommand cmd = new SqlCommand("GetRoleById", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@RoleId", roleId);

                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            role = new RoleDTO
                            {
                                RoleId = Convert.ToInt32(dr["RoleId"]),
                                RoleName = dr["RoleName"].ToString(),
                                Status = dr["Status"].ToString()
                            };
                        }
                    }
                }
            }

            return role;
        }


        // ===================== ADD ROLE =====================
        [WebMethod(EnableSession = true)]
        public static string AddNewRole(string roleName, string status)
        {
            string cs = ConfigurationManager
                .ConnectionStrings["Pulse360DB"]
                .ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                using (SqlCommand cmd = new SqlCommand("AddNewRole", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@RoleName", roleName.Trim());
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


        // ===================== UPDATE ROLE =====================
        [WebMethod(EnableSession = true)]
        public static string UpdateRole(int roleId, string roleName, string status)
        {
            string cs = ConfigurationManager
                .ConnectionStrings["Pulse360DB"]
                .ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                using (SqlCommand cmd = new SqlCommand("UpdateRole", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@RoleId", roleId);
                    cmd.Parameters.AddWithValue("@RoleName", roleName.Trim());
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


        // ===================== SOFT DELETE (INACTIVE) =====================
        [WebMethod(EnableSession = true)]
        public static string SoftDeleteRole(int roleId)
        {
            string cs = ConfigurationManager
                .ConnectionStrings["Pulse360DB"]
                .ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                using (SqlCommand cmd = new SqlCommand("SoftDeleteRole", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@RoleId", roleId);
                    cmd.Parameters.AddWithValue(
                        "@ModifiedBy",
                        HttpContext.Current.Session["UserName"]?.ToString() ?? "Admin"
                    );

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            return "inactive";
        }



        [WebMethod(EnableSession = true)]
        public static string ToggleRoleStatus(int roleId)
        {
            string cs = ConfigurationManager
                .ConnectionStrings["Pulse360DB"]
                .ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                using (SqlCommand cmd = new SqlCommand("ToggleRoleStatus", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@RoleId", roleId);
                    cmd.Parameters.AddWithValue(
                        "@ModifiedBy",
                        HttpContext.Current.Session["UserName"]?.ToString() ?? "Admin"
                    );

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            return "success";
        }

        // ===================== DTO =====================
        public class RoleDTO
        {
            public int RoleId { get; set; }
            public string RoleName { get; set; }
            public string Status { get; set; }
            public string CreatedBy { get; set; }
            public string ModifiedBy { get; set; }
        }
    }
}
