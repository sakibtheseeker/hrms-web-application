<%@ Page Title="Approve Leaves"
    Language="C#"
    MasterPageFile="~/AdminMaster.Master"
    AutoEventWireup="true"
    CodeBehind="AdminApproveLeave.aspx.cs"
    Inherits="hrms_web_application.Admin.AdminApproveLeave" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

<h3>Leave Approval</h3>

<div class="mb-3">
    <asp:Button ID="btnApprove" runat="server"
        Text="Approve Selected"
        CssClass="btn btn-success me-2"
        OnClick="btnApprove_Click" />

    <asp:Button ID="btnReject" runat="server"
        Text="Reject Selected"
        CssClass="btn btn-danger"
        OnClick="btnReject_Click" />
</div>

<asp:GridView ID="gvLeaves" runat="server"
    CssClass="table table-bordered"
    AutoGenerateColumns="false"
    DataKeyNames="LeaveRequestId"
    AllowPaging="true"
    PageSize="5"
    OnPageIndexChanging="gvLeaves_PageIndexChanging"
     OnRowDataBound="gvLeaves_RowDataBound">

    <Columns>

        <asp:TemplateField>
            <HeaderTemplate>
                <input type="checkbox" onclick="toggleAll(this)" />
            </HeaderTemplate>
            <ItemTemplate>
                <asp:CheckBox ID="chkRow" runat="server" />
            </ItemTemplate>
        </asp:TemplateField>

        <asp:BoundField DataField="FirstName" HeaderText="Employee" />
        <asp:BoundField DataField="LeaveType" HeaderText="Leave Type" />
        <asp:BoundField DataField="StartDate" HeaderText="From" DataFormatString="{0:dd-MMM-yyyy}" />
        <asp:BoundField DataField="EndDate" HeaderText="To" DataFormatString="{0:dd-MMM-yyyy}" />
        <asp:BoundField DataField="NumberOfDays" HeaderText="Days" />

        <asp:TemplateField HeaderText="Status">
    <ItemTemplate>
        <asp:Label ID="lblStatus"
            runat="server"
            Text='<%# Eval("Status") %>'
            CssClass="badge">
        </asp:Label>
    </ItemTemplate>
</asp:TemplateField>


    </Columns>
</asp:GridView>

<script>
    function toggleAll(src) {
        document.querySelectorAll("input[id*='chkRow']")
            .forEach(x => x.checked = src.checked);
    }
</script>

</asp:Content>
