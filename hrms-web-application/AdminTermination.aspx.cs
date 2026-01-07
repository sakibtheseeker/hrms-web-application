using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Services;
using System.Web.UI;

namespace Solution360
{
    public partial class AdminTermination : Page
    {
        static string cs = ConfigurationManager.ConnectionStrings["Pulse360DB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadUsers();
                LoadTerminations();
            }
        }

        void LoadUsers()
        {
            ddlUser.DataSource = GetData("GetAllEmployees");
            ddlUser.DataTextField = "Name";
            ddlUser.DataValueField = "UserId";
            ddlUser.DataBind();
        }

        void LoadTerminations()
        {
            gvTermination.DataSource = GetData("GetAllTerminations");
            gvTermination.DataBind();
        }

        DataTable GetData(string proc)
        {
            SqlDataAdapter da = new SqlDataAdapter(proc, cs);
            da.SelectCommand.CommandType = CommandType.StoredProcedure;
            DataTable dt = new DataTable();
            da.Fill(dt);
            return dt;
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            int id = string.IsNullOrEmpty(hfTerminationId.Value)
                        ? 0
                        : Convert.ToInt32(hfTerminationId.Value);

            SqlConnection con = new SqlConnection(cs);
            SqlCommand cmd = new SqlCommand("SaveTermination", con);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@Id", id);
            cmd.Parameters.AddWithValue("@UserId", ddlUser.SelectedValue);
            cmd.Parameters.AddWithValue("@TerminationType", ddlType.SelectedValue);
            cmd.Parameters.AddWithValue("@NoticeDate", txtNoticeDate.Text);
            cmd.Parameters.AddWithValue("@ResignDate", txtResignDate.Text);
            cmd.Parameters.AddWithValue("@Reason", txtReason.Text);

            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();

            hfTerminationId.Value = "";
            LoadTerminations();
        }

        protected void gvTermination_PageIndexChanging(object sender, System.Web.UI.WebControls.GridViewPageEventArgs e)
        {
            gvTermination.PageIndex = e.NewPageIndex;
            LoadTerminations();
        }

        // ===== AJAX =====

        [WebMethod]
        public static object GetTermination(int id)
        {
            SqlConnection con = new SqlConnection(cs);
            SqlCommand cmd = new SqlCommand("GetTerminationById", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@id", id);

            con.Open();
            SqlDataReader dr = cmd.ExecuteReader();
            dr.Read();

            var data = new
            {
                TerminationId = id,
                UserId = dr["UserId"].ToString(),
                TerminationType = dr["TerminationType"].ToString(),
                NoticeDate = Convert.ToDateTime(dr["NoticeDate"]).ToString("yyyy-MM-dd"),
                ResignDate = Convert.ToDateTime(dr["ResignDate"]).ToString("yyyy-MM-dd"),
                Reason = dr["Reason"].ToString()
            };

            con.Close();
            return data;
        }

        [WebMethod]
        public static void DeleteTerminationAjax(int id)
        {
            SqlConnection con = new SqlConnection(cs);
            SqlCommand cmd = new SqlCommand("DeleteTermination", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@id", id);

            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();
        }
    }
}