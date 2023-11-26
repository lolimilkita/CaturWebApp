using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CaturWebApp
{
    public partial class Index : System.Web.UI.Page
    {
        int Task_Id;
        SqlConnection myCon = new SqlConnection(ConfigurationManager.ConnectionStrings["TaskConnection"].ConnectionString);
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                DoGridView("", "");
            }
            if (!String.IsNullOrEmpty(Request.QueryString["srch"]) || !String.IsNullOrEmpty(Request.QueryString["fltr"]))
            {
                DoGridView(Request.QueryString["srch"], Request.QueryString["fltr"]);
            }
        }

        private void DoGridView(string search, string filter)
        {
            try
            {
                myCon.Open();
                using (SqlCommand myCom = new SqlCommand("dbo.usp_GetTasks", myCon))
                {
                    myCom.Connection = myCon;
                    myCom.CommandType = CommandType.StoredProcedure;
                    myCom.Parameters.Add("@Srch", SqlDbType.VarChar).Value = search == "" ? null : search;
                    myCom.Parameters.Add("@fltr", SqlDbType.VarChar).Value = filter == "" ? null : filter;

                    SqlDataReader myDr = myCom.ExecuteReader();

                    gvTasks.DataSource = myDr;
                    gvTasks.DataBind();

                    myDr.Close();
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error in Tasks doGridView: " + ex.Message; }
            finally { myCon.Close(); }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            var searchText = Server.UrlEncode(txtSearchMaster.Text); // URL encode in case of special characters
            var searchFilter = Server.UrlEncode(DropDownList1.Text);

            Response.Redirect("~/Index.aspx?srch=" + searchText + "&fltr=" + searchFilter);
        }

        protected void lbNewTasks_Click(object sender, EventArgs e)
        {
            try
            {
                txtTaskTitle.Text = "";
                txtDescription.Text = "";

                lblTaskNew.Visible = true;
                lblTaskUpd.Visible = false;
                btnAddTask.Visible = true;
                btnUpdTask.Visible = false;

                GetStatusForDLL();

                ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openTaskDetail();", true);
            }
            catch (Exception) { throw; }
        }
        protected void btnAddTask_Click(object sender, EventArgs e)
        {
            try
            {
                myCon.Open();
                using (SqlCommand myCom = new SqlCommand("dbo.usp_InsTask", myCon))
                {


                    myCom.CommandType = CommandType.StoredProcedure;
                    myCom.Parameters.Add("@Title", SqlDbType.VarChar).Value = txtTaskTitle.Text;
                    myCom.Parameters.Add("@Description", SqlDbType.VarChar).Value = txtDescription.Text;
                    myCom.Parameters.Add("@StatusID", SqlDbType.VarChar).Value = ddlStatus.SelectedValue == "0" ? null : ddlStatus.SelectedValue;

                    myCom.ExecuteNonQuery();
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error in btnAddTask_Click: " + ex.Message; }
            finally { myCon.Close(); }
            DoGridView("", "");
        }
        protected void btnUpdTask_Click(object sender, EventArgs e)
        {
            UpdTask();
            DoGridView("", "");
        }
        protected void gvTasks_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "UpdTask")
            {
                Task_Id = Convert.ToInt32(e.CommandArgument);

                txtTaskTitle.Text = "";
                txtDescription.Text = "";

                lblTaskNew.Visible = false;
                lblTaskUpd.Visible = true;
                btnAddTask.Visible = false;
                btnUpdTask.Visible = true;

                GetStatusForDLL();
                GetTask(Task_Id);

                ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openTaskDetail();", true);
            }
        }

        private void UpdTask()
        {
            try
            {
                myCon.Open();
                using (SqlCommand cmd = new SqlCommand("dbo.usp_UpdTask", myCon))
                {
                    cmd.Connection = myCon;
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@ID", SqlDbType.Int).Value = int.Parse(lblTaskID.Text);
                    cmd.Parameters.Add("@Title", SqlDbType.VarChar).Value = txtTaskTitle.Text;
                    cmd.Parameters.Add("@Description", SqlDbType.VarChar).Value = txtDescription.Text;
                    cmd.Parameters.Add("@StatusID", SqlDbType.VarChar).Value = ddlStatus.SelectedValue;

                    int rows = cmd.ExecuteNonQuery();
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error in Tasks - UpdTask: " + ex.Message; }
            finally { myCon.Close(); }
        }

        protected void gvTasks_RowDeleting(Object sender, GridViewDeleteEventArgs e)
        {
            Task_Id = Convert.ToInt32(gvTasks.DataKeys[e.RowIndex].Value.ToString());

            try
            {
                myCon.Open();

                using (SqlCommand cmd = new SqlCommand("dbo.usp_DelTask", myCon))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@ID", SqlDbType.Int).Value = Task_Id;
                    cmd.ExecuteScalar();
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error in gvTasks_RowDeleting: " + ex.Message; }
            finally { myCon.Close(); }
            DoGridView("", "");
        }

        private void GetTask(int task_id)
        {
            try
            {
                myCon.Open();
                using (SqlCommand myCmd = new SqlCommand("dbo.usp_GetTask", myCon))
                {
                    myCmd.Connection = myCon;
                    myCmd.CommandType = CommandType.StoredProcedure;
                    myCmd.Parameters.Add("@ID", SqlDbType.Int).Value = task_id;
                    SqlDataReader myDr = myCmd.ExecuteReader();

                    if (myDr.HasRows)
                    {
                        while (myDr.Read())
                        {
                            txtTaskTitle.Text = myDr.GetValue(1).ToString();
                            txtDescription.Text = myDr.GetValue(2).ToString();
                            ddlStatus.SelectedValue = myDr.GetValue(3).ToString();
                            lblTaskID.Text = Task_Id.ToString();
                        }
                    }
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error in Companies GetEmployee: " + ex.Message; }
            finally { myCon.Close(); }
        }

        private void GetStatusForDLL()
        {
            try
            {
                myCon.Open();
                using (SqlCommand cmd = new SqlCommand("dbo.usp_GetStatus", myCon))
                {
                    SqlDataReader myDr = cmd.ExecuteReader();

                    ddlStatus.DataSource = myDr;
                    ddlStatus.DataTextField = "status";
                    ddlStatus.DataValueField = "id";
                    ddlStatus.DataBind();
                    ddlStatus.Items.Insert(0, new ListItem("-- Select Status --", "0"));

                    myDr.Close();
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error in Tasks - GetStatusForDLL: " + ex.Message; }
            finally { myCon.Close(); }
        }

    }
}