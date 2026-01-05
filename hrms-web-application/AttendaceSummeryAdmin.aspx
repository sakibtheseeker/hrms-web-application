<%@ Page Title="Attendance Admin"
    Language="C#"
    MasterPageFile="~/AdminMaster.Master"
    AutoEventWireup="true"
    CodeBehind="AttendaceSummeryAdmin.aspx.cs"
    Inherits="hrms_web_application.Admin.Attendance.AttendaceSummeryAdmin" EnableEventValidation="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

<div class="page-breadcrumb mb-3">
    <h2>Attendance Admin</h2>
</div>

<!-- DASHBOARD -->
<div class="card mb-3">
    <div class="card-body">
        <h4>Attendance Details Today</h4>
        <p>Data from <asp:Label ID="lblTotalEmployees" runat="server" /> employees</p>

        <div class="row text-center">
            <div class="col">
                <h6>Present</h6>
                <h4><asp:Label ID="lblPresent" runat="server" /></h4>
            </div>
            <div class="col">
                <h6>Late Login</h6>
                <h4><asp:Label ID="lblLate" runat="server" /></h4>
            </div>
            <div class="col">
                <h6>Absent</h6>
                <h4><asp:Label ID="lblAbsent" runat="server" /></h4>
            </div>
        </div>
    </div>
</div>

<!-- EXPORT BUTTONS -->
<div class="mb-3">
 

    <asp:Button ID="btnExportExcel" runat="server"
        Text="Export Excel"
        CssClass="btn btn-success ms-2"
        OnClick="btnExportExcel_Click" />
</div>

<!-- TABLE -->
<div class="card">
    <div class="card-body">
       <asp:GridView ID="gvAttendance"
    runat="server"
    CssClass="table table-bordered table-striped"
    AutoGenerateColumns="False"
    DataKeyNames="AttendanceId"
    OnRowEditing="gvAttendance_RowEditing"
    OnRowUpdating="gvAttendance_RowUpdating"
    OnRowCancelingEdit="gvAttendance_RowCancelingEdit">
    <Columns>
        <asp:BoundField DataField="AttendanceId" HeaderText="AId" ReadOnly="True" />
        <asp:BoundField DataField="Date" HeaderText="Date" DataFormatString="{0:yyyy-MM-dd}" ReadOnly="True" />
        <asp:BoundField DataField="EmployeeName" HeaderText="Employee" ReadOnly="True" />
        <asp:BoundField DataField="Status" HeaderText="Status" />
        <asp:BoundField DataField="CheckIn" HeaderText="Check In" DataFormatString="{0:hh:mm tt}" />
        <asp:BoundField DataField="CheckOut" HeaderText="Check Out" DataFormatString="{0:hh:mm tt}" />
        <asp:BoundField DataField="BreakHours" HeaderText="Break (hrs)" />
        <asp:BoundField DataField="Late" HeaderText="Late (min)" />
        <asp:BoundField DataField="ProductionHours" HeaderText="Production (hrs)" />
        <asp:CommandField ShowEditButton="True" />
    </Columns>
</asp:GridView>

    </div>
</div>

</asp:Content>
