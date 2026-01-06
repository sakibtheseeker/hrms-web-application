using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
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

            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(@"
                    SELECT RoleId, RoleName, Status, CreatedBy, ModifiedBy
                    FROM Role
                    ORDER BY RoleId DESC", con);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                while (dr.Read())
                {
                    list.Add(new RoleDTO
                    {
                        RoleId = Convert.ToInt32(dr["RoleId"]),
                        RoleName = dr["RoleName"].ToString(),
                        Status = dr["Status"].ToString(),
                        CreatedBy = dr["CreatedBy"] == DBNull.Value ? "" : dr["CreatedBy"].ToString(),
                        ModifiedBy = dr["ModifiedBy"] == DBNull.Value ? "" : dr["ModifiedBy"].ToString()
                    });
                }
            }

            return list;
        }

        // ===================== GET ROLE BY ID =====================
        [WebMethod(EnableSession = true)]
        public static RoleDTO GetRoleById(int roleId)
        {
            RoleDTO role = null;

            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(@"
                    SELECT RoleId, RoleName, Status
                    FROM Role
                    WHERE RoleId = @Id", con);

                cmd.Parameters.AddWithValue("@Id", roleId);
                con.Open();

                SqlDataReader dr = cmd.ExecuteReader();
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

            return role;
        }

        // ===================== ADD ROLE =====================
        [WebMethod(EnableSession = true)]
        public static string AddNewRole(string roleName, string status)
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(@"
                    INSERT INTO Role
                        (RoleName, Status, CreatedBy, CreatedAt)
                    VALUES
                        (@RoleName, @Status, 'Admin', GETDATE())", con);

                cmd.Parameters.AddWithValue("@RoleName", roleName.Trim());
                cmd.Parameters.AddWithValue("@Status", status);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            return "success";
        }

        // ===================== UPDATE ROLE =====================
        [WebMethod(EnableSession = true)]
        public static string UpdateRole(int roleId, string roleName, string status)
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(@"
                    UPDATE Role
                    SET RoleName = @RoleName,
                        Status = @Status,
                        ModifiedBy = 'Admin',
                        ModifiedAt = GETDATE()
                    WHERE RoleId = @Id", con);

                cmd.Parameters.AddWithValue("@Id", roleId);
                cmd.Parameters.AddWithValue("@RoleName", roleName.Trim());
                cmd.Parameters.AddWithValue("@Status", status);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            return "updated";
        }

        // ===================== SOFT DELETE (INACTIVE) =====================
        [WebMethod(EnableSession = true)]
        public static string SoftDeleteRole(int roleId)
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(@"
                    UPDATE Role
                    SET Status = 'Inactive',
                        ModifiedBy = 'Admin',
                        ModifiedAt = GETDATE()
                    WHERE RoleId = @Id", con);

                cmd.Parameters.AddWithValue("@Id", roleId);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            return "inactive";
        }


        [WebMethod(EnableSession = true)]
        public static string ToggleRoleStatus(int roleId)
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(@"
                    UPDATE [Role]
                    SET Status = CASE 
                        WHEN Status = 'Active' THEN 'Inactive'
                        ELSE 'Active'
                    END,
                    ModifiedBy = 'Admin',
                    ModifiedAt = GETDATE()
                    WHERE RoleId = @RoleId", con);

                cmd.Parameters.AddWithValue("@RoleId", roleId);

                con.Open();
                cmd.ExecuteNonQuery();
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
