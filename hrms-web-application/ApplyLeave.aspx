<%@ Page Title="" Language="C#" MasterPageFile="~/EmployeeMaster.Master" AutoEventWireup="true" CodeBehind="ApplyLeave.aspx.cs" Inherits="hrms_web_application.ApplyLeave" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

   

<asp:ScriptManager runat="server" ID="ScriptManager1" />

<!-- HEADER -->
<div class="d-flex justify-content-between mb-3">
    <h2>Leave Requests</h2>
    <button type="button" class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#applyLeaveModal">
        Apply Leave
    </button>
</div>

<!-- LEAVE BALANCE CARDS -->
<div class="row mb-4">
    <asp:Repeater ID="rptLeaves" runat="server" DataSourceID="dsSummary">
        <ItemTemplate>
            <div class="col-md-4 mb-3">
                <div class="card shadow-sm">
                    <div class="card-body">
                        <h6><%# Eval("LeaveType") %></h6>
                        <h4><%# Eval("TotalLeaves") %></h4>
                        <span class="badge bg-info">
                            Remaining: <%# Eval("RemainingLeaves") %>
                        </span>
                    </div>
                </div>
            </div>
        </ItemTemplate>
    </asp:Repeater>
</div>

<asp:SqlDataSource ID="dsSummary" runat="server"
    ConnectionString="<%$ ConnectionStrings:Pulse360DB %>"
    SelectCommand="GetEmployeeLeaveSummary"
    SelectCommandType="StoredProcedure">
    <SelectParameters>
        <asp:SessionParameter Name="UserId" SessionField="userId" Type="Int32" />
    </SelectParameters>
</asp:SqlDataSource>

<!-- MY LEAVE REQUESTS -->
<div class="card mt-4">
    <div class="card-header">
        <h4>My Leave Requests</h4>
    </div>
    <div class="card-body">
        <asp:GridView ID="GridView1" runat="server"
            CssClass="table table-bordered table-striped"
            AutoGenerateColumns="false"
            DataSourceID="SqlDataSourceLeaveRequests">
            <Columns>
                <asp:BoundField DataField="LeaveTypeId" HeaderText="Leave Type ID" />
                <asp:BoundField DataField="LeaveType" HeaderText="Leave Type" />
                <asp:BoundField DataField="StartDate" HeaderText="Start Date" DataFormatString="{0:yyyy-MM-dd}" />
                <asp:BoundField DataField="EndDate" HeaderText="End Date" DataFormatString="{0:yyyy-MM-dd}" />
                <asp:BoundField DataField="Reason" HeaderText="Reason" />
                <asp:BoundField DataField="NoOfDays" HeaderText="Days" />
                <asp:BoundField DataField="Status" HeaderText="Status" />
            </Columns>
        </asp:GridView>
    </div>
</div>

<asp:SqlDataSource ID="SqlDataSourceLeaveRequests" runat="server"
    ConnectionString="<%$ ConnectionStrings:Pulse360DB %>"
    SelectCommand="GetMyLeaveRequests"
    SelectCommandType="StoredProcedure">
    <SelectParameters>
        <asp:SessionParameter Name="UserId" SessionField="userId" Type="Int32" />
    </SelectParameters>
</asp:SqlDataSource>

<!-- APPLY LEAVE MODAL -->
<div class="modal fade" id="applyLeaveModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">

            <div class="modal-header">
                <h5 class="modal-title">Apply Leave</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">
                <!-- Error / Success -->
                <asp:Label ID="LabelError" runat="server" ForeColor="Red" />
                <asp:Label ID="LabelSuccess" runat="server" ForeColor="Green" Visible="false" />

                <!-- FORM -->
                <div class="mb-3">
                    <label>Leave Type</label>
                    <asp:DropDownList ID="ddlLeaveType" runat="server"
                        CssClass="form-control"
                        DataSourceID="dsLeaveTypes"
                        DataTextField="LeaveType"
                        DataValueField="LeaveTypeId" />
                </div>

                <div class="mb-3">
                    <label>Reason</label>
                    <asp:TextBox ID="txtReason" runat="server" CssClass="form-control" />
                </div>

                <div class="mb-3">
                    <label>Start Date</label>
                    <asp:TextBox ID="txtStartDate" runat="server" TextMode="Date" CssClass="form-control" />
                </div>

                <div class="mb-3">
                    <label>End Date</label>
                    <asp:TextBox ID="txtEndDate" runat="server" TextMode="Date" CssClass="form-control" />
                </div>
            </div>

            <div class="modal-footer">
                <asp:Button ID="btnApply" runat="server" Text="Apply" CssClass="btn btn-primary" OnClick="btnApply_Click" />
                                <asp:Button ID="Button1" runat="server" Text="Close" CssClass="btn btn-primary" OnClick="close" />

            </div>

        </div>
    </div>
</div>

<asp:SqlDataSource ID="dsLeaveTypes" runat="server"
    ConnectionString="<%$ ConnectionStrings:Pulse360DB %>"
    SelectCommand="GetEmployeeLeaveTypes"
    SelectCommandType="StoredProcedure">
    <SelectParameters>
        <asp:SessionParameter Name="UserId" SessionField="userId" Type="Int32" />
    </SelectParameters>
</asp:SqlDataSource>

</asp:Content>

