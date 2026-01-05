<%@ Page Language="C#" MasterPageFile="~/EmployeeMaster.Master"
    AutoEventWireup="true"
    CodeBehind="TimesheetEmployee.aspx.cs"
    Inherits="hrms_web_application.Employee.Attendance.Timesheet" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

<div class="container mt-4">

    <div class="d-flex justify-content-between mb-3">
        <h3>Timesheets</h3>

        <!-- OPEN MODAL BUTTON -->
        <button type="button" class="btn btn-primary"
            data-bs-toggle="modal"
            data-bs-target="#addModal">
            Add Timesheet
        </button>
    </div>

    <!-- MODAL -->
    <div class="modal fade" id="addModal" tabindex="-1"
         aria-labelledby="addModalLabel" aria-hidden="true">

        <div class="modal-dialog">
            <div class="modal-content">

                <div class="modal-header">
                    <h5 class="modal-title" id="addModalLabel">Add Timesheet</h5>
                    <button type="button" class="btn-close"
                        data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">
                    <label>Project</label>
                    <asp:DropDownList ID="ddlProject" runat="server"
                        CssClass="form-control"></asp:DropDownList>
                    <br />

                    <label>Date</label>
                    <asp:TextBox ID="txtDate" runat="server"
                        TextMode="Date" CssClass="form-control" />
                    <br />

                    <label>Worked Hours</label>
                    <asp:TextBox ID="txtHours" runat="server"
                        TextMode="Number" CssClass="form-control" />
                </div>

                <div class="modal-footer">
                    <asp:Button ID="btnSave" runat="server"
                        Text="Save"
                        CssClass="btn btn-success"
                        OnClick="btnSave_Click" />

                    <button type="button" class="btn btn-secondary"
                        data-bs-dismiss="modal">
                        Close
                    </button>
                </div>

            </div>
        </div>
    </div>

    <hr />

    <!-- GRIDVIEW -->
    <asp:GridView ID="gvTimesheet" runat="server"
        AutoGenerateColumns="false"
        CssClass="table table-bordered table-striped">

        <Columns>
            <asp:BoundField DataField="ProjectName" HeaderText="Project" />
            <asp:BoundField DataField="Date" HeaderText="Date"
                DataFormatString="{0:dd/MM/yyyy}" />
            <asp:BoundField DataField="WorkHours" HeaderText="Hours" />

            <asp:TemplateField HeaderText="Status">
                <ItemTemplate>
                    <span class="badge <%# Eval("Status").ToString() == "Approved" ? "bg-success" :
                        Eval("Status").ToString() == "Rejected" ? "bg-danger" : "bg-warning" %>">
                        <%# Eval("Status") %>
                    </span>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>

    </asp:GridView>

</div>

</asp:Content>
