using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Services;
using System.Web.UI;

namespace Solution360
{
    public partial class AdminPromotion : Page
    {
        static string cs = ConfigurationManager.ConnectionStrings["Pulse360DB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDropdowns();
                LoadPromotions();
            }
        }

        void LoadPromotions()
        {
            gvPromotion.DataSource = GetData("GetAllPromotions");
            gvPromotion.DataBind();
        }

        void LoadDropdowns()
        {
            ddlUser.DataSource = GetData("GetAllEmployees");
            ddlUser.DataTextField = "Name";
            ddlUser.DataValueField = "UserId";
            ddlUser.DataBind();

            ddlFrom.DataSource = GetData("GetDesignations");
            ddlFrom.DataTextField = "Name";
            ddlFrom.DataValueField = "Name";
            ddlFrom.DataBind();

            ddlTo.DataSource = GetData("GetDesignations");
            ddlTo.DataTextField = "Name";
            ddlTo.DataValueField = "Name";
            ddlTo.DataBind();
        }

        DataTable GetData(string proc)
        {
            SqlDataAdapter da = new SqlDataAdapter(proc, cs);
            da.SelectCommand.CommandType = CommandType.StoredProcedure;
            DataTable dt = new DataTable();
            da.Fill(dt);
            return dt;
        }

        protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            SqlDataAdapter da = new SqlDataAdapter("SearchPromotion", cs);
            da.SelectCommand.CommandType = CommandType.StoredProcedure;
            da.SelectCommand.Parameters.AddWithValue("@key", txtSearch.Text);

            DataTable dt = new DataTable();
            da.Fill(dt);

            gvPromotion.DataSource = dt;
            gvPromotion.DataBind();
        }

        protected void gvPromotion_PageIndexChanging(object sender, System.Web.UI.WebControls.GridViewPageEventArgs e)
        {
            gvPromotion.PageIndex = e.NewPageIndex;
            LoadPromotions();
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            int id = string.IsNullOrEmpty(hfPromotionId.Value) ? 0 : Convert.ToInt32(hfPromotionId.Value);

            SqlConnection con = new SqlConnection(cs);
            SqlCommand cmd = new SqlCommand("SavePromotion", con);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@Id", id);
            cmd.Parameters.AddWithValue("@UserId", ddlUser.SelectedValue);
            cmd.Parameters.AddWithValue("@From", ddlFrom.SelectedValue);
            cmd.Parameters.AddWithValue("@To", ddlTo.SelectedValue);
            cmd.Parameters.AddWithValue("@Date", txtDate.Text);

            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();

            hfPromotionId.Value = "";
            LoadPromotions();
        }

        // ===== AJAX METHODS (MVC STYLE) =====

        [WebMethod]
        public static object GetPromotion(int id)
        {
            SqlConnection con = new SqlConnection(cs);
            SqlCommand cmd = new SqlCommand("GetPromotionById", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@id", id);

            con.Open();
            SqlDataReader dr = cmd.ExecuteReader();
            dr.Read();

            var data = new
            {
                PromotionId = id,
                UserId = dr["UserId"].ToString(),
                DesignationFrom = dr["DesignationFrom"].ToString(),
                DesignationTo = dr["DesignationTo"].ToString(),
                Date = Convert.ToDateTime(dr["Date"]).ToString("yyyy-MM-dd")
            };

            con.Close();
            return data;
        }

        [WebMethod]
        public static void DeletePromotionAjax(int id)
        {
            SqlConnection con = new SqlConnection(cs);
            SqlCommand cmd = new SqlCommand("DeletePromotion", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@id", id);

            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();
        }
    }
}