<%@ Page Language="C#"
    MasterPageFile="~/AdminMaster.Master"
    AutoEventWireup="true"
    CodeFile="LeaveSetting.aspx.cs"
    Inherits="hrms_web_application.Admin.Attendance.Leave.LeaveSetting" %>


<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h3 class="mb-4">Manage Leave Settings</h3>

    <asp:Label ID="lblSuccess" runat="server" CssClass="alert alert-success d-block" Visible="false"></asp:Label>
    <asp:Label ID="lblError" runat="server" CssClass="alert alert-danger d-block" Visible="false"></asp:Label>

    <div class="row">
        <asp:Repeater ID="rptLeaveTypes" runat="server">
    <ItemTemplate>

        <div class="col-xl-4 col-md-6 mb-3">
            <div class="card">
                <div class="card-body d-flex justify-content-between align-items-center">

                    <div>
                        <h6 class="mb-2"><%# Eval("LeaveType") %></h6>

                        <!-- Active -->
                        <asp:RadioButton ID="rbActive"
                            runat="server"
                            Text=" Active"
                            GroupName='<%# "grp_" + Eval("LeaveTypeId") %>'
                            AutoPostBack="true"
                            Checked='<%# Eval("status").ToString() == "Active" %>'
                            OnCheckedChanged="StatusChanged" />

                        <!-- Inactive -->
                        <asp:RadioButton ID="rbInactive"
                            runat="server"
                            Text=" Inactive"
                            GroupName='<%# "grp_" + Eval("LeaveTypeId") %>'
                            AutoPostBack="true"
                            Checked='<%# Eval("status").ToString() == "Inactive" %>'
                            OnCheckedChanged="StatusChanged" />

                        <asp:HiddenField ID="hfLeaveTypeId"
                            runat="server"
                            Value='<%# Eval("LeaveTypeId") %>' />
                    </div>

                </div>
            </div>
        </div>

    </ItemTemplate>
</asp:Repeater>

</div>

</asp:Content>
