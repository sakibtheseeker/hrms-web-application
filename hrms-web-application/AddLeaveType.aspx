<%@ Page Title="" Language="C#" MasterPageFile="~/AdminMaster.Master" AutoEventWireup="true" CodeBehind="AddLeaveType.aspx.cs" Inherits="hrms_web_application.Admin.Attendance.Leave.AddLeaveType" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="d-flex justify-content-between mb-3">
        <h3>Leave Types</h3>

         <asp:TextBox ID="txtSearchLeave" runat="server" CssClass="form-control me-2" 
                     placeholder="Search Leave Type or Status" 
                     AutoPostBack="true" OnTextChanged="txtSearchLeave_TextChanged" Height="16px"></asp:TextBox>

      <asp:Button ID="Button1" runat="server"
    Text="Add Leave Type"
    CssClass="btn btn-primary"
    OnClientClick="openModal(); return false;" />

    </div>

    <!-- Success / Error -->
    <asp:Label ID="Label1" runat="server" CssClass="text-success"></asp:Label>
    <asp:Label ID="Label2" runat="server" CssClass="text-danger"></asp:Label>

    <!-- Modal -->
    <div class="modal fade" id="addModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">

                <div class="modal-header">
                    <h5 class="modal-title">Add Leave Type</h5>
                </div>

                <div class="modal-body">
                    <label>Leave Type</label>
                    <asp:TextBox ID="TextBox1" runat="server"
                        CssClass="form-control"></asp:TextBox>
                </div>

                <div class="modal-footer">
                    <asp:Button ID="Button2" runat="server"
                        Text="Save"
                        CssClass="btn btn-success"
                        OnClick="Button1_Click" />
                </div>

            </div>
        </div>
    </div>

    <!-- GridView -->
<asp:GridView ID="GridView1" runat="server"
    AutoGenerateColumns="False"
    DataKeyNames="LeaveTypeId"
    OnRowCommand="GridView1_RowCommand"
    CssClass="table table-bordered"
    
    >

    <Columns>
        <asp:BoundField DataField="LeaveTypeId" HeaderText="ID" ReadOnly="True" />
        <asp:BoundField DataField="LeaveType" HeaderText="Leave Type" />
        <asp:BoundField DataField="status" HeaderText="Status" />

        <asp:TemplateField HeaderText="Action">
            <ItemTemplate>
                <asp:LinkButton ID="lnkDelete"
                    runat="server"
                    CommandName="DeleteLeave"
                    CommandArgument='<%# Eval("LeaveTypeId") %>'
                    OnClientClick="return confirm('Are you sure you want to delete?');">
                    <i class="fa fa-trash text-danger"></i>
                </asp:LinkButton>
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>

</asp:GridView>


    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:Pulse360DB %>" SelectCommand="SELECT [LeaveTypeId], [LeaveType], [status] FROM [MasterLeaveTypes]"></asp:SqlDataSource>
    <!-- Script -->
    <script>
        function openModal() {
            var myModal = new bootstrap.Modal(document.getElementById('addModal'));
            myModal.show();
        }
    </script>
</asp:Content>
