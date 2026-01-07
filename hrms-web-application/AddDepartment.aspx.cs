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

            string cs = ConfigurationManager.ConnectionStrings["Pulse360DB"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(@"
            SELECT DepartmentId, Name, NoOfEmployee, Status, CreatedBy, ModifiedBy
            FROM Departments
            ORDER BY DepartmentId DESC", con);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                while (dr.Read())
                {
                    list.Add(new DepartmentDTO
                    {
                        DepartmentId = Convert.ToInt32(dr["DepartmentId"]),
                        Name = dr["Name"]?.ToString(),

                        // ✅ HANDLE NULLS SAFELY
                        NoOfEmployee = dr["NoOfEmployee"] == DBNull.Value
                            ? 0
                            : Convert.ToInt32(dr["NoOfEmployee"]),

                        Status = dr["Status"]?.ToString(),

                        CreatedBy = dr["CreatedBy"] == DBNull.Value
                            ? ""
                            : dr["CreatedBy"].ToString(),

                        ModifiedBy = dr["ModifiedBy"] == DBNull.Value
                            ? ""
                            : dr["ModifiedBy"].ToString()
                    });
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
                .ConnectionStrings["Pulse360DB"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(
                    "SELECT DepartmentId, Name, Status FROM Departments WHERE DepartmentId = @Id", con);

                cmd.Parameters.AddWithValue("@Id", departmentId);
                con.Open();

                SqlDataReader dr = cmd.ExecuteReader();
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

            return d;
        }



        // ===================== ADD DEPARTMENT =====================
        [WebMethod]
        public static string AddNewDepartment(string name, string status)
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(@"
            INSERT INTO Departments
                (Name, Status, NoOfEmployee, CreatedBy, CreatedAt)
            VALUES
                (@Name, @Status, 0, 'Admin', GETDATE())", con);

                cmd.Parameters.AddWithValue("@Name", name.Trim());
                cmd.Parameters.AddWithValue("@Status", status);

                con.Open();
                cmd.ExecuteNonQuery();

                
            }

            return "success";
        }



        // ===================== UPDATE DEPARTMENT =====================
        [WebMethod]
        public static string UpdateDepartment(int departmentId, string name, string status)
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(@"
            UPDATE Departments
            SET
                Name = @Name,
                Status = @Status,
                ModifiedBy = 'Admin',
                ModifiedAt = GETDATE()
            WHERE DepartmentId = @Id", con);

                cmd.Parameters.AddWithValue("@Id", departmentId);
                cmd.Parameters.AddWithValue("@Name", name.Trim());
                cmd.Parameters.AddWithValue("@Status", status);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            return "updated";
        }


        // ===================== DELETE DEPARTMENT =====================
        [WebMethod]
        public static string DeleteDepartment(int departmentId)
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(
                    "DELETE FROM Departments WHERE DepartmentId = @Id", con);

                cmd.Parameters.AddWithValue("@Id", departmentId);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            return "deleted";
        }

        // ===================== TOGGLE STATUS =====================
        [WebMethod]
        public static string ToggleDepartmentStatus(int departmentId)
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(@"
                    UPDATE Departments
                    SET Status = CASE 
                        WHEN Status = 'Active' THEN 'Inactive'
                        ELSE 'Active'
                    END
                    WHERE DepartmentId = @Id", con);

                cmd.Parameters.AddWithValue("@Id", departmentId);

                con.Open();
                cmd.ExecuteNonQuery();
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